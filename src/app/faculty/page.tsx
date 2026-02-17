import { getSupabaseServerClient } from "@/lib/supabase-server";
import { redirect } from "next/navigation";
import Link from "next/link";

type RawSectionRow = {
  id: string;
  term: string | null;
  academic_year: string | null;
  schedule: string | null;
  course: { code: string; title: string } | { code: string; title: string }[] | null;
};

type SectionRow = {
  id: string;
  term: string | null;
  academic_year: string | null;
  schedule: string | null;
  course: { code: string; title: string } | null;
};

type Sentiment = {
  id: string;
  sentiment: string;
  comments: string | null;
  created_at: string;
};

type EvaluationSummary = {
  role: string;
  evaluatorName: string;
  periodName: string;
  status: string;
  submittedAt: string | null;
  categoryAverages: Record<string, number>;
};

export const dynamic = "force-dynamic";

function calculateCategoryAverage(responsesByCategory: Record<string, number[]>): Record<string, number> {
  const result: Record<string, number> = {};
  for (const [category, scores] of Object.entries(responsesByCategory)) {
    if (scores.length > 0) {
      result[category] = Number((scores.reduce((a, b) => a + b, 0) / scores.length).toFixed(2));
    }
  }
  return result;
}

export default async function FacultyPage() {
  const supabase = getSupabaseServerClient();

  const {
    data: userData,
    error: userError,
  } = await supabase.auth.getUser();

  const user = userData?.user ?? null;

  if (!user) {
    redirect("/auth/login?next=%2Ffaculty");
  }

  let profile = null;
  let sections: SectionRow[] = [];
  let sentiments: Sentiment[] = [];
  let evaluations: EvaluationSummary[] = [];
  let errorMessage: string | null = userError?.message ?? null;

  if (user) {
    const [profileRes, sectionsRes, sentimentsRes, evaluationsRes] = await Promise.all([
      supabase.from("profiles").select("id, full_name, email, role").eq("id", user.id).maybeSingle(),
      supabase
        .from("sections")
        .select("id, term, academic_year, schedule, course:course_id ( code, title )")
        .eq("faculty_id", user.id)
        .order("created_at", { ascending: false })
        .limit(50),
      supabase
        .from("student_sentiments")
        .select("id, sentiment, comments, created_at")
        .eq("faculty_id", user.id)
        .order("created_at", { ascending: false })
        .limit(100),
      supabase
        .from("evaluations")
        .select(`
          status,
          submitted_at,
          overall_comment,
          evaluation_responses (
            score,
            rubric_item:rubric_item_id (
              category:category_id ( label )
            )
          ),
          assignment:assignment_id (
            role,
            evaluator:evaluator_id ( full_name ),
            period:evaluation_periods ( name )
          )
        `)
        .eq("assignment.faculty_id", user.id),
    ]);

    profile = profileRes.data;
    sections = ((sectionsRes.data ?? []) as RawSectionRow[]).map((section) => ({
      ...section,
      course: Array.isArray(section.course) ? section.course[0] ?? null : section.course ?? null,
    }));
    sentiments = sentimentsRes.data ?? [];
    
    // Process evaluations
    evaluations = ((evaluationsRes.data ?? []) as any[]).map((evaluation) => {
      const responsesByCategory: Record<string, number[]> = {};
      (evaluation.evaluation_responses ?? []).forEach((resp: any) => {
        const category = resp.rubric_item?.category?.label || "Unknown";
        if (!responsesByCategory[category]) responsesByCategory[category] = [];
        responsesByCategory[category].push(resp.score);
      });

      return {
        role: evaluation.assignment?.role || "",
        evaluatorName: evaluation.assignment?.evaluator?.full_name || "Anonymous",
        periodName: evaluation.assignment?.period?.name || "Unknown Period",
        status: evaluation.status,
        submittedAt: evaluation.submitted_at,
        categoryAverages: calculateCategoryAverage(responsesByCategory),
      };
    });

    errorMessage = errorMessage ?? profileRes.error?.message ?? sectionsRes.error?.message ?? null;
  }

  const signedIn = Boolean(user);
  const sentimentSummary = {
    positive: sentiments.filter(s => s.sentiment === "positive").length,
    neutral: sentiments.filter(s => s.sentiment === "neutral").length,
    negative: sentiments.filter(s => s.sentiment === "negative").length,
  };

  return (
    <main className="section-shell space-y-6">
      <header className="space-y-1">
        <p className="text-sm uppercase tracking-wide text-slate-300">Faculty</p>
        <h1 className="text-2xl font-bold text-white">My dashboard</h1>
        <p className="text-slate-200 text-sm">View your assignments, evaluations, and student feedback.</p>
      </header>

      {errorMessage ? (
        <p className="rounded-lg bg-amber-900/40 px-3 py-2 text-sm text-amber-100 shadow-sm">
          {errorMessage}
        </p>
      ) : null}

      <div className="card glass">
        <div className="card-header">
          <h2 className="text-lg font-semibold text-white">Profile</h2>
        </div>
        <div className="card-body bg-white/60 backdrop-blur text-sm text-slate-800">
          {profile ? (
            <div className="space-y-1">
              <p className="font-semibold text-slate-900">{profile.full_name ?? "(no name)"}</p>
              <p className="text-slate-700">{profile.email}</p>
              <p className="pill inline-flex capitalize">{profile.role}</p>
            </div>
          ) : signedIn ? (
            <p>No profile found for this account.</p>
          ) : (
            <p>Sign in to view your profile.</p>
          )}
        </div>
      </div>

      <div className="card glass">
        <div className="card-header">
          <h2 className="text-lg font-semibold text-white">My Sections</h2>
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
                      {signedIn ? "No sections assigned yet." : "Sign in to view your assigned sections."}
                    </td>
                  </tr>
                ) : (
                  sections.map((s) => (
                    <tr key={s.id}>
                      <td className="font-semibold text-slate-900">
                        {s.course ? `${s.course.code} ${s.course.title}` : "—"}
                      </td>
                      <td className="text-slate-600 text-sm">
                        {[s.term, s.academic_year].filter(Boolean).join(" ")}
                      </td>
                      <td className="text-slate-600 text-sm">{s.schedule ?? ""}</td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>

      {sentiments.length > 0 && (
        <div className="card glass">
          <div className="card-header">
            <h2 className="text-lg font-semibold text-white">Student Sentiment</h2>
          </div>
          <div className="card-body bg-white/60 backdrop-blur space-y-4">
            <div className="grid gap-3 md:grid-cols-3">
              <div className="rounded-lg bg-green-100 p-3 text-center">
                <p className="text-xs text-green-700 font-medium">Positive</p>
                <p className="text-2xl font-bold text-green-900">{sentimentSummary.positive}</p>
              </div>
              <div className="rounded-lg bg-gray-100 p-3 text-center">
                <p className="text-xs text-gray-700 font-medium">Neutral</p>
                <p className="text-2xl font-bold text-gray-900">{sentimentSummary.neutral}</p>
              </div>
              <div className="rounded-lg bg-red-100 p-3 text-center">
                <p className="text-xs text-red-700 font-medium">Negative</p>
                <p className="text-2xl font-bold text-red-900">{sentimentSummary.negative}</p>
              </div>
            </div>

            {sentiments.length > 0 && (
              <div className="border-t pt-4 mt-4">
                <h3 className="font-semibold text-slate-900 mb-3">Recent Comments</h3>
                <div className="space-y-2 max-h-64 overflow-y-auto">
                  {sentiments
                    .filter(s => s.comments)
                    .slice(0, 10)
                    .map((s) => (
                      <div
                        key={s.id}
                        className={`rounded p-2 text-sm ${
                          s.sentiment === "positive"
                            ? "bg-green-50 text-green-900"
                            : s.sentiment === "neutral"
                            ? "bg-gray-50 text-gray-900"
                            : "bg-red-50 text-red-900"
                        }`}
                      >
                        <p className="font-medium capitalize">{s.sentiment}</p>
                        <p className="text-xs">{s.comments}</p>
                        <p className="text-xs opacity-70 mt-1">
                          {new Date(s.created_at).toLocaleDateString()}
                        </p>
                      </div>
                    ))}
                </div>
              </div>
            )}
          </div>
        </div>
      )}

      {evaluations.length > 0 && (
        <div className="card glass">
          <div className="card-header">
            <h2 className="text-lg font-semibold text-white">Evaluation Feedback</h2>
          </div>
          <div className="card-body bg-white/60 backdrop-blur space-y-4">
            {evaluations.map((evaluation, idx) => (
              <details key={idx} className="group border border-slate-200 rounded">
                <summary className="cursor-pointer p-3 hover:bg-slate-50 flex justify-between items-center">
                  <span className="text-sm font-medium text-slate-800">
                    {evaluation.evaluatorName} ({evaluation.role})
                    <span className="text-xs text-slate-600 ml-2">{evaluation.periodName}</span>
                  </span>
                  <span className={`pill text-xs ${evaluation.status === "submitted" ? "bg-green-200 text-green-800" : ""}`}>
                    {evaluation.status}
                  </span>
                </summary>

                <div className="border-t p-3 space-y-3">
                  <div className="grid gap-2 md:grid-cols-2">
                    {Object.entries(evaluation.categoryAverages).map(([category, avg]) => (
                      <div key={category}>
                        <p className="text-xs font-semibold text-slate-700">{category}</p>
                        <p className="text-sm text-slate-600">Average: {avg} / 5</p>
                        <div className="h-2 bg-slate-200 rounded mt-1 overflow-hidden">
                          <div
                            className="h-full bg-gradient-to-r from-blue-500 to-blue-600"
                            style={{ width: `${(avg / 5) * 100}%` }}
                          />
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              </details>
            ))}
          </div>
        </div>
      )}

      <div className="flex justify-between">
        <Link href="/" className="btn-secondary">
          ← Home
        </Link>
        <Link href="/evaluator" className="btn-secondary">
          Evaluations →
        </Link>
      </div>
    </main>
  );
}
