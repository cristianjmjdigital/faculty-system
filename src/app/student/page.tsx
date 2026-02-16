import StudentForm from "./student-form";
import { getSupabaseServerClient } from "@/lib/supabase-server";

export const dynamic = "force-dynamic";

type PeriodOption = {
  id: string;
  name: string;
};

type SectionOption = {
  id: string;
  label: string;
  facultyId: string | null;
};

async function loadStudentData() {
  const supabase = getSupabaseServerClient();

  const [periodsResult, sectionsResult] = await Promise.all([
    supabase
      .from("evaluation_periods")
      .select("id, name, status, start_date")
      .eq("status", "open")
      .order("start_date", { ascending: true }),
    supabase
      .from("sections")
      .select(
        "id, term, academic_year, schedule, course:course_id ( code, title ), faculty:faculty_id ( id, full_name )"
      )
      .limit(50),
  ]);

  const periods: PeriodOption[] = (periodsResult.data ?? []).map((p) => ({ id: p.id, name: p.name }));

  const sections: SectionOption[] = (sectionsResult.data ?? []).map((s: any) => {
    const course = s.course ? `${s.course.code} ${s.course.title}` : "Section";
    const term = s.term ? ` • ${s.term}` : "";
    const schedule = s.schedule ? ` • ${s.schedule}` : "";
    return {
      id: s.id,
      label: `${course}${term}${schedule}`,
      facultyId: s.faculty ? s.faculty.id : null,
    };
  });

  return {
    periods,
    sections,
    error: periodsResult.error?.message || sectionsResult.error?.message,
  };
}

export default async function StudentPage() {
  const { periods, sections, error } = await loadStudentData();

  return (
    <main className="section-shell space-y-6">
      <header className="space-y-1">
        <p className="text-sm uppercase tracking-wide text-slate-500">Student</p>
        <h1 className="text-2xl font-bold">Share your notes and sentiment</h1>
        <p className="text-slate-600 text-sm">
          Captures qualitative input and saves to Supabase with period and section context. Authentication is required
          to satisfy row-level security.
        </p>
      </header>

      <div className="card">
        <div className="card-body space-y-4">
          {error ? <p className="text-sm text-rose-700">{error}</p> : null}
          <StudentForm periods={periods} sections={sections} />
        </div>
      </div>
    </main>
  );
}
