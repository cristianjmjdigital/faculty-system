import { getSupabaseServerClient } from "@/lib/supabase-server";

export const dynamic = "force-dynamic";

export default async function FacultyPage() {
  const supabase = getSupabaseServerClient();

  const [profileRes, sectionsRes] = await Promise.all([
    supabase.from("profiles").select("id, full_name, email, role").maybeSingle(),
    supabase
      .from("sections")
      .select("id, term, academic_year, schedule, course:course_id ( code, title )")
      .limit(20),
  ]);

  const profile = profileRes.data;
  const sections = sectionsRes.data ?? [];

  return (
    <main className="section-shell space-y-6">
      <header className="space-y-1">
        <p className="text-sm uppercase tracking-wide text-slate-300">Faculty</p>
        <h1 className="text-2xl font-bold text-white">My assignments</h1>
        <p className="text-slate-200 text-sm">Quick view of your sections and schedule.</p>
      </header>

      <div className="card glass">
        <div className="card-header">
          <h2 className="text-lg font-semibold text-white">Profile</h2>
        </div>
        <div className="card-body bg-white/60 backdrop-blur text-sm text-slate-800">
          {profile ? (
            <div className="space-y-1">
              <p className="font-semibold text-slate-900">{profile.full_name ?? "(no name)"}</p>
              <p className="text-slate-700">{profile.email}</p>
              <p className="pill inline-flex">{profile.role}</p>
            </div>
          ) : (
            <p>Sign in to view your profile.</p>
          )}
        </div>
      </div>

      <div className="card glass">
        <div className="card-header">
          <h2 className="text-lg font-semibold text-white">Sections</h2>
        </div>
        <div className="card-body bg-white/60 backdrop-blur">
          <div className="overflow-auto rounded-lg border border-slate-200 bg-white shadow-sm">
            <table className="table min-w-[520px]">
              <thead>
                <tr>
                  <th>Course</th>
                  <th>Term</th>
                  <th>Schedule</th>
                </tr>
              </thead>
              <tbody>
                {sections.length === 0 ? (
                  <tr>
                    <td className="py-4 text-sm text-slate-600" colSpan={3}>
                      No sections assigned.
                    </td>
                  </tr>
                ) : (
                  sections.map((s) => (
                    <tr key={s.id}>
                      <td className="font-semibold text-slate-900">
                        {s.course ? `${s.course.code} ${s.course.title}` : "—"}
                      </td>
                      <td className="text-slate-600 text-sm">{s.term ?? ""} {s.academic_year ?? ""}</td>
                      <td className="text-slate-600 text-sm">{s.schedule ?? ""}</td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </main>
  );
}
