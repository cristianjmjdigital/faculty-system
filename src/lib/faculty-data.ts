import { getDbServerClient } from "@/lib/db-server";
import { redirect } from "next/navigation";
import { getServerSessionUser } from "@/lib/local-auth";

export type SectionRow = {
  id: string;
  term: string | null;
  academic_year: string | null;
  schedule: string | null;
  course: { code: string; title: string } | null;
};

export type Sentiment = {
  id: string;
  sentiment: string;
  comments: string | null;
  created_at: string;
  periodName: string | null;
  moduleLabel: string | null;
};

export type EvaluationData = {
  role: string;
  evaluatorName: string;
  periodName: string;
  status: string;
  submittedAt: string | null;
  overallComment: string | null;
  categoryAverages: Record<string, number>;
  categoryScores: Record<string, number[]>;
};

export type FacultyProfile = {
  id: string;
  full_name: string | null;
  email: string | null;
  role: string;
  department_id?: string | null;
};

export type FacultyData = {
  user: { id: string };
  profile: FacultyProfile | null;
  sections: SectionRow[];
  sentiments: Sentiment[];
  evaluations: EvaluationData[];
  errorMessage: string | null;
};

function calcAvg(scores: number[]): number {
  if (scores.length === 0) return 0;
  return Number((scores.reduce((a, b) => a + b, 0) / scores.length).toFixed(2));
}

export async function loadFacultyData(): Promise<FacultyData> {
  const sessionUser = await getServerSessionUser();
  if (!sessionUser) {
    redirect("/auth/login?next=%2Ffaculty");
  }

  const db = getDbServerClient();
  const user = { id: sessionUser.id };

  const [profileRes, sectionsRes, sentimentsRes, evaluationsRes] = await Promise.all([
    db.from("profiles").select("id, full_name, email, role, department_id").eq("id", user.id).maybeSingle(),
    db
      .from("sections")
      .select("id, term, academic_year, schedule, course:course_id ( code, title )")
      .eq("faculty_id", user.id)
      .order("created_at", { ascending: false })
      .limit(50),
    db
      .from("student_sentiments")
      .select("id, sentiment, comments, created_at, period:evaluation_periods ( name ), section:section_id ( term, course:course_id ( code ) )")
      .eq("faculty_id", user.id)
      .order("created_at", { ascending: false })
      .limit(200),
    db
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

  const sections: SectionRow[] = ((sectionsRes.data ?? []) as any[]).map((s) => ({
    ...s,
    course: Array.isArray(s.course) ? s.course[0] ?? null : s.course ?? null,
  }));

  const sentiments: Sentiment[] = ((sentimentsRes.data ?? []) as any[]).map((s) => {
    const section = Array.isArray(s.section) ? s.section[0] ?? null : s.section ?? null;
    const period = Array.isArray(s.period) ? s.period[0] ?? null : s.period ?? null;
    const courseCode = section?.course?.code ?? null;
    return {
      id: s.id,
      sentiment: s.sentiment,
      comments: s.comments ?? null,
      created_at: s.created_at,
      periodName: period?.name ?? null,
      moduleLabel: courseCode ? `${courseCode}${section?.term ? ` (${section.term})` : ""}` : null,
    };
  });

  const evaluations: EvaluationData[] = ((evaluationsRes.data ?? []) as any[]).map((ev) => {
    const byCategory: Record<string, number[]> = {};
    (ev.evaluation_responses ?? []).forEach((resp: any) => {
      const cat = resp.rubric_item?.category?.label || "Unknown";
      if (!byCategory[cat]) byCategory[cat] = [];
      byCategory[cat].push(resp.score);
    });

    const categoryAverages: Record<string, number> = {};
    for (const [cat, scores] of Object.entries(byCategory)) {
      categoryAverages[cat] = calcAvg(scores);
    }

    return {
      role: ev.assignment?.role || "",
      evaluatorName: ev.assignment?.evaluator?.full_name || "Anonymous",
      periodName: ev.assignment?.period?.name || "Unknown Period",
      status: ev.status,
      submittedAt: ev.submitted_at,
      overallComment: ev.overall_comment ?? null,
      categoryAverages,
      categoryScores: byCategory,
    };
  });

  const errorMessage = profileRes.error?.message ?? sectionsRes.error?.message ?? null;

  return {
    user: { id: user.id },
    profile: profileRes.data,
    sections,
    sentiments,
    evaluations,
    errorMessage,
  };
}


