import Link from "next/link";

const highlights = [
  {
    title: "Admin Console",
    body: "Manage faculty, courses, evaluation periods, and rubrics with quick exports.",
    href: "/admin",
  },
  {
    title: "Evaluator Flows",
    body: "Peer, supervisor, and self-evaluations mapped to your rubric structure.",
    href: "/admin",
  },
  {
    title: "Student Sentiment",
    body: "Lightweight form for qualitative feedback and notes tied to courses.",
    href: "/student",
  },
];

const steps = [
  "Configure Supabase keys in .env.local",
  "Define rubrics, periods, faculty, and course-section assignments",
  "Share evaluator and student links to collect responses",
];

export default function HomePage() {
  return (
    <main>
      <section className="bg-gradient-to-br from-ink via-midnight to-black text-white">
        <div className="section-shell py-16">
          <div className="max-w-3xl space-y-6">
            <div className="badge">Faculty Evaluation</div>
            <h1 className="text-4xl font-bold leading-tight">Centralize evaluations, sentiment, and reporting.</h1>
            <p className="text-lg text-slate-200">
              Next.js + Supabase starter to run multi-role faculty evaluations and capture
              student sentiment aligned to your rubric.
            </p>
            <div className="flex flex-wrap gap-3">
              <Link href="/admin" className="btn-primary">Go to Admin</Link>
              <Link href="/student" className="btn-secondary">Student Sentiment</Link>
            </div>
            <div className="flex flex-col gap-2 text-sm text-slate-200">
              {steps.map((step) => (
                <div key={step} className="flex items-center gap-2">
                  <span className="h-2 w-2 rounded-full bg-accent" />
                  <span>{step}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      <section className="section-shell grid gap-6 md:grid-cols-3">
        {highlights.map((item) => (
          <div key={item.title} className="card h-full">
            <div className="card-header">
              <h3 className="text-lg font-semibold">{item.title}</h3>
              <Link className="text-sm font-semibold text-accent" href={item.href}>
                Open
              </Link>
            </div>
            <div className="card-body text-sm text-slate-700">{item.body}</div>
          </div>
        ))}
      </section>
    </main>
  );
}
