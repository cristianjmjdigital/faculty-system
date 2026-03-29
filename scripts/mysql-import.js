// Helper script to bulk-import CSV exports from Supabase into MySQL.
// Requires: npm install mysql2
// Usage:
//   MYSQL_HOST=localhost MYSQL_USER=root MYSQL_PASSWORD="" MYSQL_DB=faculty-db node scripts/mysql-import.js
// CSV files default to ./exports/<table>.csv; override with env vars like CSV_DEPARTMENTS=path/to/departments.csv

const fs = require("fs");
const path = require("path");
const mysql = require("mysql2/promise");

const config = {
  host: process.env.MYSQL_HOST || "localhost",
  port: Number(process.env.MYSQL_PORT || 3306),
  user: process.env.MYSQL_USER || "root",
  password: process.env.MYSQL_PASSWORD || "",
  database: process.env.MYSQL_DB || "faculty-db",
};

const tables = [
  { name: "departments", columns: ["id", "name", "created_at"] },
  { name: "profiles", columns: ["id", "full_name", "email", "role", "department_id", "created_at"] },
  { name: "courses", columns: ["id", "code", "title", "department_id", "created_at"] },
  { name: "evaluation_periods", columns: ["id", "name", "start_date", "end_date", "status", "rubric_version", "created_at"] },
  { name: "rubric_categories", columns: ["id", "label", "description", "order_index", "weight", "created_at"] },
  { name: "rubric_items", columns: ["id", "category_id", "prompt", "max_score", "order_index", "weight", "created_at"] },
  { name: "sections", columns: ["id", "course_id", "faculty_id", "term", "academic_year", "schedule", "created_at"] },
  { name: "evaluator_assignments", columns: ["id", "period_id", "section_id", "faculty_id", "evaluator_id", "role", "created_at"] },
  { name: "evaluations", columns: ["id", "assignment_id", "status", "submitted_at", "overall_comment"] },
  { name: "evaluation_responses", columns: ["id", "evaluation_id", "rubric_item_id", "score", "comment", "created_at"] },
  { name: "student_sentiments", columns: ["id", "period_id", "section_id", "faculty_id", "student_id", "sentiment", "comments", "created_at"] },
];

function resolveCsvPath(tableName) {
  const envKey = `CSV_${tableName.toUpperCase()}`;
  const custom = process.env[envKey];
  const defaultPath = path.join(process.cwd(), "exports", `${tableName}.csv`);
  return path.resolve(custom || defaultPath);
}

function buildLoadSql(tableName, columns) {
  const vars = columns.map((c) => `@${c}`).join(", ");
  const setters = columns.map((c) => `\`${c}\` = NULLIF(@${c}, '')`).join(", ");
  return (
    `LOAD DATA LOCAL INFILE ? INTO TABLE \`${tableName}\` ` +
    "FIELDS TERMINATED BY ',' ENCLOSED BY '\\\"' ESCAPED BY '\\\"' " +
    "LINES TERMINATED BY '\\n' IGNORE 1 ROWS " +
    `(${vars}) SET ${setters};`
  );
}

async function main() {
  console.log("Connecting to MySQL...", config);
  const connection = await mysql.createConnection({
    ...config,
    multipleStatements: false,
    flags: ["+LOCAL_FILES"],
  });

  try {
    await connection.query("SET FOREIGN_KEY_CHECKS=0;");

    for (const table of tables) {
      const filePath = resolveCsvPath(table.name);
      if (!fs.existsSync(filePath)) {
        throw new Error(`Missing CSV for ${table.name}: ${filePath}`);
      }

      console.log(`Importing ${table.name} from ${filePath}`);
      const sql = buildLoadSql(table.name, table.columns);
      await connection.query(sql, [filePath]);
    }

    await connection.query("SET FOREIGN_KEY_CHECKS=1;");
    console.log("Import complete.");
  } finally {
    await connection.end();
  }
}

main().catch((err) => {
  console.error("Import failed:", err.message);
  process.exitCode = 1;
});
