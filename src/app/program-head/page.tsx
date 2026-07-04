import Link from "next/link";
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
      <main className="min-h-screen bg-slate-950 text-white">
        <div className="section-shell py-10">
          <div className="overflow-hidden rounded-3xl border border-white/10 bg-white/[0.04] p-8 shadow-2xl backdrop-blur">
            <div className="flex items-center justify-between gap-4">
              <div>
                <div className="badge">Program Head</div>
                <h1 className="mt-3 text-3xl font-bold tracking-tight">Department summary</h1>
                <p className="mt-2 max-w-2xl text-sm text-slate-300">
                  This account is not yet assigned to a department.
                </p>
              </div>
              <div className="flex flex-wrap items-center gap-2">
                <Link href="/account" className="btn-secondary text-xs">Update profile</Link>
                <Link href="/api/auth/logout" className="btn-primary text-xs">Sign out</Link>
              </div>
            </div>

            <div className="mt-6 rounded-2xl border border-amber-500/20 bg-amber-500/10 px-4 py-3 text-sm text-amber-100">
              Assign a department to this account before using the program head portal.
            </div>
          </div>
        </div>
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
    <main className="min-h-screen bg-slate-950 text-white">
      <div className="section-shell space-y-6 py-10">
        <header className="overflow-hidden rounded-3xl border border-white/10 bg-white/[0.04] shadow-2xl backdrop-blur">
          <div className="flex flex-col gap-6 p-6 lg:flex-row lg:items-end lg:justify-between lg:p-8">
            <div className="space-y-4">
              <div className="flex items-center gap-2">
                <span className="badge">Program Head</span>
                <span className="rounded-full border border-emerald-400/20 bg-emerald-400/10 px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.2em] text-emerald-300">
                  Confidential summary
                </span>
              </div>
              <div className="max-w-3xl space-y-3">
                <h1 className="text-3xl font-bold tracking-tight text-white sm:text-4xl">Department summary dashboard</h1>
                <p className="max-w-2xl text-sm leading-6 text-slate-300">
                  Review faculty performance, sentiment trends, and recent comments for your assigned department.
                </p>
              </div>
            </div>

            <div className="flex flex-wrap items-center gap-2">
              <Link href="/account" className="btn-secondary text-xs">Update profile</Link>
              <Link href="/auth/change-password" className="btn-secondary text-xs">Change password</Link>
              <Link href="/api/auth/logout" className="btn-primary text-xs">Sign out</Link>
            </div>
          </div>
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
              <section key={member.id} className="overflow-hidden rounded-3xl border border-white/10 bg-white/[0.04] shadow-2xl backdrop-blur">
                <div className="flex flex-col gap-3 border-b border-white/10 px-6 py-5 sm:flex-row sm:items-center sm:justify-between">
                  <div>
                    <h2 className="text-lg font-semibold text-white">{member.full_name ?? member.email}</h2>
                    <p className="mt-1 text-xs uppercase tracking-[0.2em] text-slate-400">{member.role}</p>
                  </div>
                  <div className="rounded-full border border-white/10 bg-white/[0.05] px-3 py-1 text-xs text-slate-300">
                    {summary ? `${summary.submission_count} submissions` : "No submissions yet"}
                  </div>
                </div>

                <div className="space-y-5 px-6 py-6">
                  <div className="grid gap-3 md:grid-cols-3">
                    <div className="rounded-2xl border border-white/10 bg-slate-950/80 p-4 text-white">
                      <p className="text-xs uppercase tracking-wider text-slate-400">Average score</p>
                      <p className="mt-2 text-3xl font-bold">{summary ? Number(summary.average_score).toFixed(2) : "0.00"}</p>
                    </div>
                    <div className="rounded-2xl border border-white/10 bg-slate-950/80 p-4 text-white">
                      <p className="text-xs uppercase tracking-wider text-slate-400">Sentiment mix</p>
                      <p className="mt-2 text-2xl font-bold">
                        {sentiment ? `${sentiment.positive_count}/${sentiment.neutral_count}/${sentiment.negative_count}` : "0/0/0"}
                      </p>
                      <p className="mt-1 text-xs text-slate-500">Positive / neutral / negative</p>
                    </div>
                    <div className="rounded-2xl border border-white/10 bg-slate-950/80 p-4 text-white">
                      <p className="text-xs uppercase tracking-wider text-slate-400">Department</p>
                      <p className="mt-2 text-2xl font-semibold">{department?.name ?? profile.department_id}</p>
                    </div>
                  </div>

                  {comments.length > 0 ? (
                    <div className="space-y-3">
                      <div className="flex items-center justify-between">
                        <p className="text-sm font-semibold text-white">Recent comments</p>
                        <p className="text-xs text-slate-400">Top 3 latest entries</p>
                      </div>
                      <div className="grid gap-3">
                        {comments.slice(0, 3).map((row) => (
                          <div key={`${member.id}-${String(row.created_at)}`} className="rounded-2xl border border-white/10 bg-white/[0.04] p-4">
                            <div className="mb-2 flex items-center justify-between text-xs uppercase tracking-[0.2em] text-slate-400">
                              <span className="capitalize">{row.sentiment}</span>
                              <span>{new Date(row.created_at).toLocaleDateString()}</span>
                            </div>
                            <p className="text-sm leading-6 text-slate-200">{row.comments}</p>
                          </div>
                        ))}
                      </div>
                    </div>
                  ) : (
                    <p className="text-sm text-slate-400">No comment entries yet for this faculty member.</p>
                  )}
                </div>
              </section>
            );
          })}
        </div>
      </div>
    </main>
  );
}