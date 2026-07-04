param(
  [string]$FacultyHtmlPath = "c:\Users\crist\Downloads\extracted_courses\FACULTY.html",
  [string]$SemestersHtmlPath = "c:\Users\crist\Downloads\extracted_courses\SEMESTERS.html",
  [string]$DefaultAcademicYear = "2026-2027",
  [string]$TermOverride = "",
  [int]$SemesterIndex = 0,
  [string]$MysqlPath = "c:\xampp\mysql\bin\mysql.exe",
  [string]$MysqlUser = "root",
  [string]$MysqlDatabase = "faculty-db"
)

$ErrorActionPreference = "Stop"

function Escape-SqlString {
  param([string]$Value)
  if ($null -eq $Value) { return "NULL" }
  return "'" + ($Value -replace "'", "''") + "'"
}

function Normalize-Slug {
  param([string]$Value)
  $slug = ($Value.ToLowerInvariant() -replace "[^a-z0-9]+", ".").Trim('.')
  if ([string]::IsNullOrWhiteSpace($slug)) { return "faculty" }
  return $slug
}

if (-not (Test-Path $FacultyHtmlPath)) {
  throw "FACULTY file not found: $FacultyHtmlPath"
}
if (-not (Test-Path $SemestersHtmlPath)) {
  throw "SEMESTERS file not found: $SemestersHtmlPath"
}
if (-not (Test-Path $MysqlPath)) {
  throw "MySQL client not found: $MysqlPath"
}

$facultyRaw = Get-Content $FacultyHtmlPath -Raw
$facultyCells = [regex]::Matches($facultyRaw, '<td[^>]*>(.*?)</td>', 'IgnoreCase') |
  ForEach-Object {
    ($_.Groups[1].Value -replace '<[^>]+>', '' -replace '&nbsp;', ' ' -replace '&amp;', '&').Trim()
  } |
  Where-Object { $_ -ne '' }

if ($facultyCells.Count -lt 14) {
  throw "FACULTY.html does not contain enough cells to parse rows."
}

$header = $facultyCells[0..6]
$dataCells = $facultyCells[7..($facultyCells.Count - 1)]

$rows = @()
for ($i = 0; $i -lt $dataCells.Count; $i += 7) {
  if ($i + 6 -ge $dataCells.Count) { break }
  $rows += [pscustomobject]@{
    Program = $dataCells[$i]
    ProgramDescription = $dataCells[$i + 1]
    Name = $dataCells[$i + 2]
    CourseCode = $dataCells[$i + 3]
    CourseDescription = $dataCells[$i + 4]
    SectionCode = $dataCells[$i + 5]
    StudentCount = $dataCells[$i + 6]
  }
}

if ($rows.Count -eq 0) {
  throw "No data rows parsed from FACULTY.html"
}

$semRaw = Get-Content $SemestersHtmlPath -Raw
$semesterValues = [regex]::Matches($semRaw, '<td[^>]*>(.*?)</td>', 'IgnoreCase') |
  ForEach-Object {
    ($_.Groups[1].Value -replace '<[^>]+>', '' -replace '&nbsp;', ' ' -replace '&amp;', '&').Trim()
  } |
  Where-Object { $_ -ne '' }

$defaultTerm = "FIRST SEMESTER"
if (-not [string]::IsNullOrWhiteSpace($TermOverride)) {
  $defaultTerm = $TermOverride
}
elseif ($semesterValues.Count -gt 0) {
  if ($SemesterIndex -lt 0 -or $SemesterIndex -ge $semesterValues.Count) {
    throw "SemesterIndex out of range. Found $($semesterValues.Count) semester rows, got $SemesterIndex."
  }
  $defaultTerm = $semesterValues[$SemesterIndex]
}

$uniqueDepartments = $rows |
  Group-Object ProgramDescription |
  ForEach-Object { [pscustomobject]@{ ProgramDescription = $_.Name; ProgramCode = ($_.Group[0].Program) } }

$uniqueFaculty = $rows |
  Group-Object Name |
  ForEach-Object {
    $first = $_.Group[0]
    [pscustomobject]@{
      Name = $_.Name
      ProgramDescription = $first.ProgramDescription
      ProgramCode = $first.Program
    }
  }

$uniqueCourses = $rows |
  Group-Object CourseCode |
  ForEach-Object {
    $courseCode = $_.Name
    $best = $_.Group | Sort-Object { $_.CourseDescription.Length } -Descending | Select-Object -First 1
    [pscustomobject]@{
      CourseCode = $courseCode
      CourseDescription = $best.CourseDescription
      ProgramDescription = $best.ProgramDescription
    }
  }

$queries = New-Object System.Collections.Generic.List[string]
$queries.Add("SET SESSION sql_safe_updates = 0;") | Out-Null
$queries.Add("SET NAMES utf8mb4;") | Out-Null
$queries.Add("START TRANSACTION;") | Out-Null

# Add optional columns for imported sheet metadata.
$queries.Add("ALTER TABLE sections ADD COLUMN IF NOT EXISTS section_code VARCHAR(64) NULL AFTER academic_year;") | Out-Null
$queries.Add("ALTER TABLE sections ADD COLUMN IF NOT EXISTS program_code VARCHAR(32) NULL AFTER section_code;") | Out-Null
$queries.Add("ALTER TABLE sections ADD COLUMN IF NOT EXISTS student_count INT NULL AFTER program_code;") | Out-Null

foreach ($dept in $uniqueDepartments) {
  $deptNameSql = Escape-SqlString $dept.ProgramDescription
  $queries.Add("INSERT INTO departments (id, name) VALUES (UUID(), $deptNameSql) ON DUPLICATE KEY UPDATE name = VALUES(name);") | Out-Null
}

# Deterministic local emails for faculty rows without an email source.
$emailCounters = @{}
foreach ($fac in $uniqueFaculty) {
  $fullName = $fac.Name
  $deptNameSql = Escape-SqlString $fac.ProgramDescription
  $fullNameSql = Escape-SqlString $fullName

  $slug = Normalize-Slug $fullName
  if (-not $emailCounters.ContainsKey($slug)) {
    $emailCounters[$slug] = 0
  }
  $emailCounters[$slug] = [int]$emailCounters[$slug] + 1
  $suffix = if ($emailCounters[$slug] -gt 1) { ".$($emailCounters[$slug])" } else { "" }
  $email = "faculty.$slug$suffix@local.test"
  $emailSql = Escape-SqlString $email

  $queries.Add(@"
SET @dept_id := (SELECT id FROM departments WHERE name = $deptNameSql LIMIT 1);
SET @existing_profile_id := (SELECT id FROM profiles WHERE full_name = $fullNameSql AND role = 'faculty' LIMIT 1);
SET @existing_email_id := (SELECT id FROM profiles WHERE email = $emailSql LIMIT 1);
INSERT INTO profiles (id, full_name, email, password, role, department_id)
VALUES (
  COALESCE(@existing_profile_id, @existing_email_id, UUID()),
  $fullNameSql,
  $emailSql,
  'faculty123',
  'faculty',
  @dept_id
)
ON DUPLICATE KEY UPDATE
  full_name = VALUES(full_name),
  role = 'faculty',
  department_id = VALUES(department_id);
"@) | Out-Null
}

foreach ($course in $uniqueCourses) {
  $codeSql = Escape-SqlString $course.CourseCode
  $titleSql = Escape-SqlString $course.CourseDescription
  $deptNameSql = Escape-SqlString $course.ProgramDescription

  $queries.Add(@"
SET @dept_id := (SELECT id FROM departments WHERE name = $deptNameSql LIMIT 1);
INSERT INTO courses (id, code, title, department_id)
VALUES (UUID(), $codeSql, $titleSql, @dept_id)
ON DUPLICATE KEY UPDATE
  title = VALUES(title),
  department_id = VALUES(department_id);
"@) | Out-Null
}

foreach ($row in $rows) {
  $courseCodeSql = Escape-SqlString $row.CourseCode
  $facultyNameSql = Escape-SqlString $row.Name
  $termSql = Escape-SqlString $defaultTerm
  $yearSql = Escape-SqlString $DefaultAcademicYear
  $sectionCodeSql = Escape-SqlString $row.SectionCode
  $programCodeSql = Escape-SqlString $row.Program
  $studentCountInt = 0
  [void][int]::TryParse(($row.StudentCount -replace '[^0-9\-]', ''), [ref]$studentCountInt)

  $queries.Add(@"
SET @course_id := (SELECT id FROM courses WHERE code = $courseCodeSql LIMIT 1);
SET @faculty_id := (SELECT id FROM profiles WHERE full_name = $facultyNameSql AND role = 'faculty' LIMIT 1);
INSERT INTO sections (id, course_id, faculty_id, term, academic_year, section_code, program_code, student_count, schedule)
SELECT UUID(), @course_id, @faculty_id, $termSql, $yearSql, $sectionCodeSql, $programCodeSql, $studentCountInt, NULL
FROM DUAL
WHERE @course_id IS NOT NULL
  AND @faculty_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
    FROM sections s
    WHERE s.course_id = @course_id
      AND s.faculty_id = @faculty_id
      AND COALESCE(s.term, '') = COALESCE($termSql, '')
      AND COALESCE(s.academic_year, '') = COALESCE($yearSql, '')
      AND COALESCE(s.section_code, '') = COALESCE($sectionCodeSql, '')
  );
"@) | Out-Null
}

$queries.Add("COMMIT;") | Out-Null

$sql = ($queries -join "`n")
$tmpSqlPath = Join-Path $env:TEMP ("faculty-import-" + [guid]::NewGuid().ToString() + ".sql")
Set-Content -Path $tmpSqlPath -Value $sql -Encoding UTF8

try {
  Get-Content $tmpSqlPath -Raw | & $MysqlPath -u $MysqlUser -D $MysqlDatabase
}
finally {
  if (Test-Path $tmpSqlPath) {
    Remove-Item $tmpSqlPath -Force
  }
}

$summaryQuery = @"
SELECT
  (SELECT COUNT(*) FROM departments) AS departments_count,
  (SELECT COUNT(*) FROM profiles WHERE role = 'faculty') AS faculty_profiles_count,
  (SELECT COUNT(*) FROM courses) AS courses_count,
  (SELECT COUNT(*) FROM sections) AS sections_count;
"@

Write-Host "Imported rows from FACULTY.html:" $rows.Count
Write-Host "Default term applied:" $defaultTerm
Write-Host "Default academic year applied:" $DefaultAcademicYear
& $MysqlPath -u $MysqlUser -D $MysqlDatabase -e $summaryQuery
