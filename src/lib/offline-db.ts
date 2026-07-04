import { getMysqlPool } from "@/lib/mysql";
import { randomUUID } from "crypto";
import type { ResultSetHeader } from "mysql2";

type Filter = { column: string; value: any };
type InFilter = { column: string; values: any[] };
type Order = { column: string; ascending?: boolean; foreignTable?: string };

export type DbOperation = {
  table: string;
  action: "select" | "insert" | "update" | "delete";
  columns?: string;
  filters?: Filter[];
  inFilters?: InFilter[];
  order?: Order[];
  limit?: number;
  values?: any;
  count?: "exact";
  head?: boolean;
  single?: boolean;
  maybeSingle?: boolean;
};

const SIMPLE_TABLES = new Set([
  "departments",
  "courses",
  "evaluation_periods",
  "profiles",
  "rubric_items",
  "rubric_categories",
  "sections",
  "student_sentiments",
  "evaluator_assignments",
  "evaluations",
  "evaluation_responses",
]);

const UUID_ID_TABLES = new Set([
  "departments",
  "courses",
  "evaluation_periods",
  "profiles",
  "rubric_items",
  "rubric_categories",
  "sections",
  "student_sentiments",
  "evaluator_assignments",
  "evaluations",
  "evaluation_responses",
]);

function normalizeCols(cols?: string) {
  return (cols || "*").replace(/\s+/g, " ").trim();
}

function getEq(filters: Filter[] = [], column: string) {
  return filters.find((f) => f.column === column)?.value;
}

function buildSimpleWhere(filters: Filter[] = [], inFilters: InFilter[] = []) {
  const clauses: string[] = [];
  const values: any[] = [];

  for (const f of filters) {
    if (f.column.includes(".")) continue;
    clauses.push(`\`${f.column}\` = ?`);
    values.push(f.value);
  }

  for (const f of inFilters) {
    if (f.column.includes(".")) continue;
    if (!f.values.length) {
      clauses.push("1 = 0");
      continue;
    }
    clauses.push(`\`${f.column}\` IN (${f.values.map(() => "?").join(",")})`);
    values.push(...f.values);
  }

  return {
    where: clauses.length ? ` WHERE ${clauses.join(" AND ")}` : "",
    values,
  };
}

function parseSimpleColumns(columns?: string) {
  const cols = normalizeCols(columns);
  if (cols === "*") return "*";
  return cols
    .split(",")
    .map((c) => c.trim())
    .filter(Boolean)
    .map((c) => `\`${c}\``)
    .join(", ");
}

function toSerializable(value: any): any {
  if (value instanceof Date) {
    return value.toISOString();
  }

  if (Array.isArray(value)) {
    return value.map((item) => toSerializable(item));
  }

  if (value && typeof value === "object") {
    const output: Record<string, any> = {};
    for (const [key, nested] of Object.entries(value)) {
      output[key] = toSerializable(nested);
    }
    return output;
  }

  return value;
}

function applySingleMode(result: { data: any[]; error: any; count?: number }, op: DbOperation) {
  if (result.error) return result;

  const normalizedData = toSerializable(result.data);

  if (op.single) {
    if (!normalizedData.length) {
      return { data: null, error: { message: "No rows returned" }, count: result.count };
    }
    return { data: normalizedData[0], error: null, count: result.count };
  }

  if (op.maybeSingle) {
    return { data: normalizedData[0] ?? null, error: null, count: result.count };
  }

  return { ...result, data: normalizedData };
}

async function selectRubricCategories(op: DbOperation) {
  const pool = getMysqlPool();
  const [catRows] = await pool.query(
    "SELECT id, label, description, order_index, weight, created_at FROM rubric_categories ORDER BY order_index ASC"
  );
  const [itemRows] = await pool.query(
    "SELECT id, category_id, prompt, max_score, order_index, weight, created_at FROM rubric_items ORDER BY order_index ASC"
  );

  const rows = (catRows as any[]).map((c) => ({
    ...c,
    rubric_items: (itemRows as any[]).filter((i) => i.category_id === c.id),
  }));

  return applySingleMode({ data: rows, error: null }, op);
}

async function selectSectionsWithRelations(op: DbOperation) {
  const pool = getMysqlPool();
  const filters = op.filters || [];
  const whereParts: string[] = [];
  const values: any[] = [];

  const facultyId = getEq(filters, "faculty_id");
  if (facultyId) {
    whereParts.push("s.faculty_id = ?");
    values.push(facultyId);
  }

  const sql = `
    SELECT
      s.id, s.term, s.academic_year, s.schedule, s.created_at,
      c.id AS course_id, c.code AS course_code, c.title AS course_title,
      f.id AS faculty_id, f.full_name AS faculty_full_name
    FROM sections s
    LEFT JOIN courses c ON c.id = s.course_id
    LEFT JOIN profiles f ON f.id = s.faculty_id
    ${whereParts.length ? `WHERE ${whereParts.join(" AND ")}` : ""}
    ORDER BY s.created_at DESC
    ${op.limit ? `LIMIT ${Number(op.limit)}` : ""}
  `;

  const [rows] = await pool.query(sql, values);
  const cols = normalizeCols(op.columns);

  const data = (rows as any[]).map((r) => {
    if (cols.includes("faculty:faculty_id") && cols.includes("course:course_id")) {
      return {
        id: r.id,
        term: r.term,
        academic_year: r.academic_year,
        schedule: r.schedule,
        course: r.course_id ? { id: r.course_id, code: r.course_code, title: r.course_title } : null,
        faculty: r.faculty_id ? { id: r.faculty_id, full_name: r.faculty_full_name } : null,
      };
    }

    if (cols.includes("faculty:faculty_id")) {
      return {
        id: r.id,
        term: r.term,
        academic_year: r.academic_year,
        schedule: r.schedule,
        course: r.course_id ? { code: r.course_code, title: r.course_title } : null,
        faculty: r.faculty_id ? { full_name: r.faculty_full_name } : null,
      };
    }

    return {
      id: r.id,
      term: r.term,
      academic_year: r.academic_year,
      schedule: r.schedule,
      course: r.course_id ? { code: r.course_code, title: r.course_title } : null,
    };
  });

  return applySingleMode({ data, error: null }, op);
}

async function selectAssignmentsWithRelations(op: DbOperation) {
  const pool = getMysqlPool();
  const filters = op.filters || [];
  const whereParts: string[] = [];
  const values: any[] = [];

  const evaluatorId = getEq(filters, "evaluator_id");
  const id = getEq(filters, "id");
  if (evaluatorId) {
    whereParts.push("ea.evaluator_id = ?");
    values.push(evaluatorId);
  }
  if (id) {
    whereParts.push("ea.id = ?");
    values.push(id);
  }

  const sql = `
    SELECT
      ea.id, ea.period_id, ea.faculty_id, ea.evaluator_id, ea.section_id, ea.role, ea.created_at,
      ep.name AS period_name, ep.status AS period_status, ep.start_date, ep.end_date,
      pf.full_name AS faculty_name, pf.email AS faculty_email,
      pe.full_name AS evaluator_name, pe.email AS evaluator_email,
      s.term AS section_term,
      c.code AS section_course_code, c.title AS section_course_title
    FROM evaluator_assignments ea
    LEFT JOIN evaluation_periods ep ON ep.id = ea.period_id
    LEFT JOIN profiles pf ON pf.id = ea.faculty_id
    LEFT JOIN profiles pe ON pe.id = ea.evaluator_id
    LEFT JOIN sections s ON s.id = ea.section_id
    LEFT JOIN courses c ON c.id = s.course_id
    ${whereParts.length ? `WHERE ${whereParts.join(" AND ")}` : ""}
    ORDER BY ea.created_at DESC
    ${op.limit ? `LIMIT ${Number(op.limit)}` : ""}
  `;

  const [rows] = await pool.query(sql, values);

  const data = (rows as any[]).map((r) => ({
    id: r.id,
    period_id: r.period_id,
    faculty_id: r.faculty_id,
    evaluator_id: r.evaluator_id,
    section_id: r.section_id,
    role: r.role,
    created_at: r.created_at,
    period: r.period_id
      ? { id: r.period_id, name: r.period_name, status: r.period_status, start_date: r.start_date, end_date: r.end_date }
      : null,
    faculty: r.faculty_id ? { id: r.faculty_id, full_name: r.faculty_name, email: r.faculty_email } : null,
    evaluator: r.evaluator_id ? { id: r.evaluator_id, full_name: r.evaluator_name, email: r.evaluator_email } : null,
    section: r.section_id
      ? {
          id: r.section_id,
          term: r.section_term,
          course: r.section_course_code ? { code: r.section_course_code, title: r.section_course_title } : null,
        }
      : null,
  }));

  return applySingleMode({ data, error: null }, op);
}

async function selectStudentSentimentsWithRelations(op: DbOperation) {
  const pool = getMysqlPool();
  const filters = op.filters || [];
  const whereParts: string[] = [];
  const values: any[] = [];

  const studentId = getEq(filters, "student_id");
  const facultyId = getEq(filters, "faculty_id");
  if (studentId) {
    whereParts.push("ss.student_id = ?");
    values.push(studentId);
  }
  if (facultyId) {
    whereParts.push("ss.faculty_id = ?");
    values.push(facultyId);
  }

  const sql = `
    SELECT
      ss.id, ss.sentiment, ss.comments, ss.created_at,
      pf.full_name AS faculty_full_name,
      s.term AS section_term, s.academic_year AS section_academic_year
    FROM student_sentiments ss
    LEFT JOIN profiles pf ON pf.id = ss.faculty_id
    LEFT JOIN sections s ON s.id = ss.section_id
    ${whereParts.length ? `WHERE ${whereParts.join(" AND ")}` : ""}
    ORDER BY ss.created_at DESC
    ${op.limit ? `LIMIT ${Number(op.limit)}` : ""}
  `;

  const [rows] = await pool.query(sql, values);
  const cols = normalizeCols(op.columns);

  const data = (rows as any[]).map((r) => {
    if (cols.includes("section:section_id")) {
      return {
        id: r.id,
        sentiment: r.sentiment,
        comments: r.comments,
        created_at: r.created_at,
        faculty: { full_name: r.faculty_full_name },
        section: { term: r.section_term, academic_year: r.section_academic_year },
      };
    }

    if (cols.includes("faculty:faculty_id")) {
      return {
        id: r.id,
        sentiment: r.sentiment,
        comments: r.comments,
        created_at: r.created_at,
        faculty: { full_name: r.faculty_full_name },
      };
    }

    return {
      id: r.id,
      sentiment: r.sentiment,
      comments: r.comments,
      created_at: r.created_at,
    };
  });

  return applySingleMode({ data, error: null }, op);
}

async function selectEvaluationsWithRelations(op: DbOperation) {
  const pool = getMysqlPool();
  const filters = op.filters || [];
  const inFilters = op.inFilters || [];
  const assignmentId = getEq(filters, "assignment_id");
  const evaluatorId = getEq(filters, "assignment.evaluator_id");
  const facultyId = getEq(filters, "assignment.faculty_id");
  const assignmentIn = inFilters.find((f) => f.column === "assignment_id")?.values || [];
  const cols = normalizeCols(op.columns);

  if (cols.includes("evaluation_responses (")) {
    const sql = `
      SELECT
        e.id, e.assignment_id, e.status, e.submitted_at, e.overall_comment,
        ea.role AS assignment_role,
        ep.name AS period_name,
        pe.full_name AS evaluator_name,
        er.score,
        rc.label AS category_label
      FROM evaluations e
      JOIN evaluator_assignments ea ON ea.id = e.assignment_id
      LEFT JOIN evaluation_periods ep ON ep.id = ea.period_id
      LEFT JOIN profiles pe ON pe.id = ea.evaluator_id
      LEFT JOIN evaluation_responses er ON er.evaluation_id = e.id
      LEFT JOIN rubric_items ri ON ri.id = er.rubric_item_id
      LEFT JOIN rubric_categories rc ON rc.id = ri.category_id
      WHERE ea.faculty_id = ?
      ORDER BY e.submitted_at DESC
    `;

    const [rows] = await pool.query(sql, [facultyId]);
    const map = new Map<string, any>();

    for (const r of rows as any[]) {
      if (!map.has(r.id)) {
        map.set(r.id, {
          id: r.id,
          status: r.status,
          submitted_at: r.submitted_at,
          overall_comment: r.overall_comment,
          evaluation_responses: [],
          assignment: {
            role: r.assignment_role,
            evaluator: { full_name: r.evaluator_name },
            period: { name: r.period_name },
          },
        });
      }
      if (r.score !== null && r.category_label) {
        map.get(r.id).evaluation_responses.push({
          score: r.score,
          rubric_item: { category: { label: r.category_label } },
        });
      }
    }

    return applySingleMode({ data: Array.from(map.values()), error: null }, op);
  }

  if (cols.includes("assignment:assignment_id")) {
    const sql = `
      SELECT
        e.id, e.status, e.submitted_at,
        ea.role,
        pf.full_name AS faculty_name,
        ep.name AS period_name
      FROM evaluations e
      JOIN evaluator_assignments ea ON ea.id = e.assignment_id
      LEFT JOIN profiles pf ON pf.id = ea.faculty_id
      LEFT JOIN evaluation_periods ep ON ep.id = ea.period_id
      WHERE ea.evaluator_id = ?
      ORDER BY e.submitted_at DESC
    `;
    const [rows] = await pool.query(sql, [evaluatorId]);
    const data = (rows as any[]).map((r) => ({
      id: r.id,
      status: r.status,
      submitted_at: r.submitted_at,
      assignment: {
        role: r.role,
        faculty: { full_name: r.faculty_name },
        period: { name: r.period_name },
      },
    }));
    return applySingleMode({ data, error: null }, op);
  }

  if (assignmentIn.length > 0) {
    const sql = `
      SELECT id, assignment_id, status, submitted_at, overall_comment
      FROM evaluations
      WHERE assignment_id IN (${assignmentIn.map(() => "?").join(",")})
    `;
    const [rows] = await pool.query(sql, assignmentIn);
    return applySingleMode({ data: rows as any[], error: null }, op);
  }

  if (assignmentId) {
    const [rows] = await pool.query(
      "SELECT id, assignment_id, status, submitted_at, overall_comment FROM evaluations WHERE assignment_id = ? LIMIT 1",
      [assignmentId]
    );
    return applySingleMode({ data: rows as any[], error: null }, op);
  }

  const [rows] = await pool.query("SELECT id, assignment_id, status, submitted_at, overall_comment FROM evaluations");
  return applySingleMode({ data: rows as any[], error: null }, op);
}

async function selectEvaluationResponsesWithRelations(op: DbOperation) {
  const pool = getMysqlPool();
  const cols = normalizeCols(op.columns);

  if (cols.includes("evaluation:evaluation_id")) {
    const sql = `
      SELECT
        er.score,
        s.id AS section_id, s.term, s.academic_year, s.schedule,
        c.code AS course_code, c.title AS course_title,
        pf.full_name AS faculty_name
      FROM evaluation_responses er
      JOIN evaluations e ON e.id = er.evaluation_id
      JOIN evaluator_assignments ea ON ea.id = e.assignment_id
      LEFT JOIN sections s ON s.id = ea.section_id
      LEFT JOIN courses c ON c.id = s.course_id
      LEFT JOIN profiles pf ON pf.id = s.faculty_id
      ${op.limit ? `LIMIT ${Number(op.limit)}` : ""}
    `;
    const [rows] = await pool.query(sql);
    const data = (rows as any[]).map((r) => ({
      score: r.score,
      evaluation: {
        assignment: {
          section: r.section_id
            ? {
                id: r.section_id,
                term: r.term,
                academic_year: r.academic_year,
                schedule: r.schedule,
                course: r.course_code ? { code: r.course_code, title: r.course_title } : null,
                faculty: { full_name: r.faculty_name },
              }
            : null,
        },
      },
    }));
    return applySingleMode({ data, error: null }, op);
  }

  const { where, values } = buildSimpleWhere(op.filters, op.inFilters);
  const [rows] = await pool.query(`SELECT * FROM evaluation_responses${where}`, values);
  return applySingleMode({ data: rows as any[], error: null }, op);
}

async function executeSelect(op: DbOperation) {
  const table = op.table;
  const cols = normalizeCols(op.columns);

  if (op.count === "exact" && op.head) {
    const pool = getMysqlPool();
    const { where, values } = buildSimpleWhere(op.filters, op.inFilters);
    const [rows] = await pool.query(`SELECT COUNT(*) AS cnt FROM \`${table}\`${where}`, values);
    return { data: [], count: Number((rows as any[])[0]?.cnt ?? 0), error: null };
  }

  if (table === "rubric_categories" && cols.includes("rubric_items")) return selectRubricCategories(op);
  if (table === "sections" && cols.includes("course:course_id")) return selectSectionsWithRelations(op);
  if (table === "evaluator_assignments" && cols.includes("period:evaluation_periods")) return selectAssignmentsWithRelations(op);
  if (table === "student_sentiments" && (cols.includes("faculty:faculty_id") || cols.includes("section:section_id"))) {
    return selectStudentSentimentsWithRelations(op);
  }
  if (table === "evaluations" && (cols.includes("assignment:assignment_id") || cols.includes("evaluation_responses (") || op.inFilters?.length || op.filters?.some((f) => f.column === "assignment_id"))) {
    return selectEvaluationsWithRelations(op);
  }
  if (table === "evaluation_responses" && cols.includes("evaluation:evaluation_id")) return selectEvaluationResponsesWithRelations(op);

  if (!SIMPLE_TABLES.has(table)) {
    return { data: null, error: { message: `Unsupported table: ${table}` } };
  }

  const pool = getMysqlPool();
  const { where, values } = buildSimpleWhere(op.filters, op.inFilters);
  const order = (op.order || [])
    .filter((o) => !o.foreignTable)
    .map((o) => `\`${o.column}\` ${o.ascending === false ? "DESC" : "ASC"}`)
    .join(", ");
  const limit = op.limit ? ` LIMIT ${Number(op.limit)}` : "";

  const sql = `SELECT ${parseSimpleColumns(op.columns)} FROM \`${table}\`${where}${order ? ` ORDER BY ${order}` : ""}${limit}`;
  const [rows] = await pool.query(sql, values);
  return applySingleMode({ data: rows as any[], error: null }, op);
}

async function executeInsert(op: DbOperation) {
  const table = op.table;
  const pool = getMysqlPool();
  const payload = Array.isArray(op.values) ? op.values : [op.values];
  if (!payload.length) return { data: null, error: { message: "Insert payload is empty" } };
  const insertedIds: Array<number | string> = [];

  for (const rawRow of payload) {
    const row = { ...(rawRow || {}) };
    if ((row as any).id === undefined && UUID_ID_TABLES.has(table)) {
      (row as any).id = randomUUID();
    }
    const entries = Object.entries(row || {}).filter(([, v]) => v !== undefined);
    const cols = entries.map(([k]) => `\`${k}\``).join(", ");
    const placeholders = entries.map(() => "?").join(", ");
    const values = entries.map(([, v]) => v);
    const [result] = await pool.query<ResultSetHeader>(`INSERT INTO \`${table}\` (${cols}) VALUES (${placeholders})`, values);
    const explicitId = (row as any)?.id;
    if (explicitId !== undefined && explicitId !== null) {
      insertedIds.push(explicitId);
    } else if (result?.insertId !== undefined && result.insertId !== null && result.insertId !== 0) {
      insertedIds.push(result.insertId);
    }

    Object.assign(rawRow, row);
  }

  if (op.columns && insertedIds.length) {
    const selectedColumns = parseSimpleColumns(op.columns);
    const placeholders = insertedIds.map(() => "?").join(", ");
    const [rows] = await pool.query(
      `SELECT ${selectedColumns} FROM \`${table}\` WHERE id IN (${placeholders})`,
      insertedIds,
    );

    const rowsById = new Map<any, any>((rows as any[]).map((row) => [row.id, row]));
    const orderedRows = insertedIds.map((id) => rowsById.get(id)).filter(Boolean);
    return applySingleMode({ data: orderedRows as any[], error: null }, op);
  }

  if (op.single || op.maybeSingle) {
    return applySingleMode({ data: payload as any[], error: null }, op);
  }

  return { data: payload, error: null };
}

async function executeUpdate(op: DbOperation) {
  const table = op.table;
  const pool = getMysqlPool();
  const updates = Object.entries(op.values || {}).filter(([, v]) => v !== undefined);
  if (!updates.length) return { data: null, error: { message: "No update values provided" } };

  const setClause = updates.map(([k]) => `\`${k}\` = ?`).join(", ");
  const setValues = updates.map(([, v]) => v);
  const { where, values } = buildSimpleWhere(op.filters, op.inFilters);

  await pool.query(`UPDATE \`${table}\` SET ${setClause}${where}`, [...setValues, ...values]);
  return { data: null, error: null };
}

async function executeDelete(op: DbOperation) {
  const table = op.table;
  const pool = getMysqlPool();
  const { where, values } = buildSimpleWhere(op.filters, op.inFilters);
  await pool.query(`DELETE FROM \`${table}\`${where}`, values);
  return { data: null, error: null };
}

export async function executeDbOperation(op: DbOperation) {
  try {
    if (op.action === "select") return executeSelect(op);
    if (op.action === "insert") return executeInsert(op);
    if (op.action === "update") return executeUpdate(op);
    if (op.action === "delete") return executeDelete(op);
    return { data: null, error: { message: "Unsupported action" } };
  } catch (error: any) {
    return { data: null, error: { message: error?.message || "DB operation failed" } };
  }
}

