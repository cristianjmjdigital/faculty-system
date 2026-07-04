import { redirect } from "next/navigation";
import { getMysqlPool } from "@/lib/mysql";
import { getServerSessionUser, roleDefaultPath } from "@/lib/local-auth";

export const dynamic = "force-dynamic";

type FacultyRow = {
  id: string;
  full_name: string | null;
  email: string | null;
  role: string;
};

export default async function ProgramHeadPage() {
  const user = await getServerSessionUser();
  if (!user) {
    redirect("/auth/login/faculty?next=%2Fprogram-head");
  }
  if (user.must_change_password) {
    redirect("/auth/change-password");
  }
  if (user.role !== "program_head") {
    redirect(roleDefaultPath(user.role));
  }

  const pool = getMysqlPool();
  const [profileRows] = await pool.query(
    `SELECT id, full_name, email, department_id
     FROM profiles
     WHERE id = ?
     LIMIT 1`,
    [user.id]
  );
  const profile = (profileRows as any[])[0];

  const [departmentRows] = await pool.query(
    `SELECT name FROM departments WHERE id = ? LIMIT 1`,
    [profile?.department_id ?? null]
  );
  const department = (departmentRows as any[])[0] ?? null;

  if (!profile?.department_id) {
    return (
      <main className="section-shell space-y-4">
        <div className="badge">Program Head</div>
        <h1 className="text-2xl font-bold text-white">No department assigned</h1>
        <p className="text-slate-400 text-sm">Assign a department to this account before using the program head portal.</p>
      </main>
    );
  }

  const [facultyRows] = await pool.query(
    `SELECT id, full_name, email, role
     FROM profiles
     WHERE department_id = ? AND role IN ('faculty','program_head')
     ORDER BY full_name ASC`,
    [profile.department_id]
  );
  const faculty = facultyRows as FacultyRow[];
  const facultyIds = faculty.map((row) => row.id);

  const [summaryRows] = await pool.query(
    facultyIds.length > 0
      ? `SELECT a.faculty_id,
           COUNT(*) AS submission_count,
           COALESCE(SUM(er.score), 0) AS total_points,
           COALESCE(AVG(er.score), 0) AS average_score
         FROM evaluations e
         INNER JOIN evaluator_assignments a ON a.id = e.assignment_id
         INNER JOIN evaluation_responses er ON er.evaluation_id = e.id
         WHERE e.status = 'submitted' AND a.faculty_id IN (?)
         GROUP BY a.faculty_id`
      : `SELECT NULL AS faculty_id, 0 AS submission_count, 0 AS total_points, 0 AS average_score WHERE 1 = 0`,
    [facultyIds]
  );

  const [sentimentRows] = await pool.query(
    facultyIds.length > 0
      ? `SELECT faculty_id,
           COUNT(*) AS sentiment_count,
           SUM(CASE WHEN sentiment = 'positive' THEN 1 ELSE 0 END) AS positive_count,
           SUM(CASE WHEN sentiment = 'neutral' THEN 1 ELSE 0 END) AS neutral_count,
           SUM(CASE WHEN sentiment = 'negative' THEN 1 ELSE 0 END) AS negative_count
         FROM student_sentiments
         WHERE faculty_id IN (?)
         GROUP BY faculty_id`
      : `SELECT NULL AS faculty_id, 0 AS sentiment_count, 0 AS positive_count, 0 AS neutral_count, 0 AS negative_count WHERE 1 = 0`,
    [facultyIds]
  );

  const [commentRows] = await pool.query(
    facultyIds.length > 0
      ? `SELECT faculty_id, comments, sentiment, created_at
         FROM student_sentiments
         WHERE faculty_id IN (?) AND comments IS NOT NULL AND comments <> ''
         ORDER BY created_at DESC
         LIMIT 40`
      : `SELECT NULL AS faculty_id, NULL AS comments, NULL AS sentiment, NOW() AS created_at WHERE 1 = 0`,
    [facultyIds]
  );

  const summaries = new Map<string, any>();
  for (const row of summaryRows as any[]) summaries.set(String(row.faculty_id), row);
  const sentiments = new Map<string, any>();
  for (const row of sentimentRows as any[]) sentiments.set(String(row.faculty_id), row);
  const commentsByFaculty = new Map<string, any[]>();
  for (const row of commentRows as any[]) {
    const key = String(row.faculty_id);
    if (!commentsByFaculty.has(key)) commentsByFaculty.set(key, []);
    commentsByFaculty.get(key)!.push(row);
  }

  const totalSubmissions = Array.from(summaries.values()).reduce((sum, row: any) => sum + Number(row.submission_count ?? 0), 0);
  const totalPoints = Array.from(summaries.values()).reduce((sum, row: any) => sum + Number(row.total_points ?? 0), 0);

  return (
    <main className="section-shell space-y-6">
      <header className="space-y-1">
        <div className="badge">Program Head</div>
        <h1 className="mt-2 text-2xl font-bold text-white">Department summary</h1>
        <p className="text-slate-400 text-sm">
          Summary results for faculty in your department.
        </p>
      </header>

      <div className="grid gap-4 sm:grid-cols-3">
        <div className="stat-card p-5">
          <p className="text-xs uppercase tracking-wider text-slate-400">Faculty members</p>
          <p className="mt-1 text-3xl font-bold text-white">{faculty.length}</p>
        </div>
        <div className="stat-card p-5">
          <p className="text-xs uppercase tracking-wider text-slate-400">Submitted evaluations</p>
          <p className="mt-1 text-3xl font-bold text-white">{totalSubmissions}</p>
        </div>
        <div className="stat-card p-5">
          <p className="text-xs uppercase tracking-wider text-slate-400">Total points</p>
          <p className="mt-1 text-3xl font-bold text-white">{totalPoints}</p>
        </div>
      </div>

      <div className="space-y-4">
        {faculty.map((member) => {
          const summary = summaries.get(member.id);
          const sentiment = sentiments.get(member.id);
          const comments = commentsByFaculty.get(member.id) ?? [];
          return (
            <section key={member.id} className="card glass">
              <div className="card-header">
                <div>
                  <h2 className="text-lg font-semibold text-white">{member.full_name ?? member.email}</h2>
                  <p className="text-xs text-slate-300">{member.role}</p>
                </div>
                <div className="text-right text-xs text-slate-400">
                  <p>{summary ? `${summary.submission_count} submissions` : "No submissions yet"}</p>
                  {sentiment ? <p>{sentiment.sentiment_count} sentiment entries</p> : null}
                </div>
              </div>
              <div className="card-body space-y-4 bg-white/60 backdrop-blur">
                <div className="grid gap-3 md:grid-cols-3">
                  <div className="rounded-xl border border-white/10 bg-slate-950/80 p-4 text-white">
                    <p className="text-xs text-slate-400">Average score</p>
                    <p className="mt-1 text-2xl font-bold">
                      {summary ? Number(summary.average_score).toFixed(2) : "0.00"}
                    </p>
                  </div>
                  <div className="rounded-xl border border-white/10 bg-slate-950/80 p-4 text-white">
                    <p className="text-xs text-slate-400">Positive / Neutral / Negative</p>
                    <p className="mt-1 text-2xl font-bold">
                      {sentiment ? `${sentiment.positive_count}/${sentiment.neutral_count}/${sentiment.negative_count}` : "0/0/0"}
                    </p>
                  </div>
                  <div className="rounded-xl border border-white/10 bg-slate-950/80 p-4 text-white">
                    <p className="text-xs text-slate-400">Department</p>
                    <p className="mt-1 text-sm font-semibold">{department?.name ?? profile.department_id}</p>
                  </div>
                </div>

                {comments.length > 0 ? (
                  <div className="space-y-2">
                    <p className="text-sm font-semibold text-slate-900">Recent comments</p>
                    {comments.slice(0, 3).map((row) => (
                      <div key={`${member.id}-${String(row.created_at)}`} className="rounded-lg border border-slate-200 bg-white p-3">
                        <div className="flex items-center justify-between text-xs text-slate-500">
                          <span className="capitalize">{row.sentiment}</span>
                          <span>{new Date(row.created_at).toLocaleDateString()}</span>
                        </div>
                        <p className="mt-1 text-sm text-slate-700">{row.comments}</p>
                      </div>
                    ))}
                  </div>
                ) : null}
              </div>
            </section>
          );
        })}
      </div>
    </main>
  );
}