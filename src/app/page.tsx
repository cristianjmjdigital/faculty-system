import Link from "next/link";

const roleCards = [
  {
    title: "Administrator",
    desc: "Manage periods, rubrics, sections, users, and evaluator assignments.",
    href: "/admin",
  },
  {
    title: "Faculty",
    desc: "Review evaluations, sentiments, and department performance summaries.",
    href: "/faculty",
  },
  {
    title: "Program Head",
    desc: "See department-wide results and monitor faculty feedback in one view.",
    href: "/program-head",
  },
  {
    title: "Student",
    desc: "Submit rubric-based evaluations and sentiment feedback for assigned sections.",
    href: "/student",
  },
];

const highlights = [
  { label: "Roles supported", value: "4" },
  { label: "Rubric categories", value: "4" },
  { label: "Primary reports", value: "5" },
];

const capabilities = [
  "Role-based sign in and access control",
  "Faculty performance and sentiment dashboards",
  "Program head department summary",
  "Offline MySQL data layer for local deployment",
];

export default function HomePage() {
  return (
    <main className="bg-slate-950 text-white">
      <section className="relative overflow-hidden border-b border-white/10 bg-slate-950">
        <div className="absolute inset-0 opacity-20" aria-hidden>
          <div className="pointer-events-none absolute -left-24 top-12 h-72 w-72 rounded-full bg-sky-500/20 blur-[110px]" />
          <div className="pointer-events-none absolute right-0 top-20 h-64 w-64 rounded-full bg-cyan-400/15 blur-[120px]" />
          <div className="pointer-events-none absolute bottom-0 left-1/2 h-56 w-56 rounded-full bg-white/5 blur-[100px]" />
        </div>

        <div className="section-shell relative z-10 py-20 lg:py-24">
          <div className="grid gap-12 lg:grid-cols-[1.3fr_0.9fr] lg:items-center">
            <div className="space-y-6">
              <div className="flex flex-wrap items-center gap-3">
                <span className="badge">Faculty Evaluation System</span>
              </div>

              <div className="space-y-4 max-w-3xl">
                <h1 className="text-4xl font-semibold tracking-tight sm:text-5xl lg:text-6xl">
                  A cleaner way to manage faculty evaluation workflows.
                </h1>
                <p className="max-w-2xl text-base leading-7 text-slate-300 sm:text-lg">
                  Secure role-based access, structured rubric scoring, student sentiment tracking, and department-level reporting in one application.
                </p>
              </div>

              <div className="flex flex-wrap gap-3 pt-1">
                <Link href="/auth/login" className="btn-primary">Sign in</Link>
                <Link href="/admin" className="btn-secondary">Admin console</Link>
                <Link href="/faculty" className="btn-ghost">Faculty portal</Link>
              </div>

              <div className="grid gap-3 pt-4 sm:grid-cols-3">
                {highlights.map((item) => (
                  <div key={item.label} className="rounded-2xl border border-white/10 bg-white/[0.04] p-4 backdrop-blur">
                    <div className="text-2xl font-semibold text-white">{item.value}</div>
                    <div className="mt-1 text-xs uppercase tracking-[0.2em] text-slate-400">{item.label}</div>
                  </div>
                ))}
              </div>
            </div>

            <div className="rounded-3xl border border-white/10 bg-white/[0.04] p-6 shadow-2xl backdrop-blur">
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs uppercase tracking-[0.25em] text-slate-400">What it supports</p>
                    <h2 className="mt-1 text-xl font-semibold text-white">Built for live use</h2>
                  </div>
                </div>

                <div className="space-y-3">
                  {capabilities.map((item) => (
                    <div key={item} className="flex items-start gap-3 rounded-2xl border border-white/10 bg-slate-950/60 p-4">
                      <span className="mt-1 h-2 w-2 rounded-full bg-cyan-400" />
                      <p className="text-sm leading-6 text-slate-200">{item}</p>
                    </div>
                  ))}
                </div>

                <div className="rounded-2xl border border-white/10 bg-slate-950/70 p-4 text-sm text-slate-300">
                  Designed for admin, faculty, program head, and student roles with clean local deployment.
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section className="section-shell py-16">
        <div className="mb-8 max-w-2xl">
          <p className="badge">Portals</p>
          <h2 className="mt-3 text-3xl font-semibold text-white">Direct access by role</h2>
          <p className="mt-2 max-w-2xl text-sm leading-6 text-slate-400">
            Each portal focuses on a single workflow so the interface stays simple, predictable, and easy to use.
          </p>
        </div>

        <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
          {roleCards.map((card) => (
            <Link
              key={card.title}
              href={card.href}
              className="group rounded-3xl border border-white/10 bg-white/[0.04] p-6 transition-all duration-200 hover:-translate-y-1 hover:border-cyan-400/30 hover:bg-white/[0.06] hover:shadow-2xl"
            >
              <div className="mb-8 flex h-12 w-12 items-center justify-center rounded-2xl bg-cyan-400/10 text-cyan-300 transition-colors group-hover:bg-cyan-400/20">
                <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                  <path strokeLinecap="round" strokeLinejoin="round" d="M9 5l7 7-7 7" />
                </svg>
              </div>
              <h3 className="text-lg font-semibold text-white">{card.title}</h3>
              <p className="mt-2 text-sm leading-6 text-slate-400">{card.desc}</p>
            </Link>
          ))}
        </div>
      </section>

      <section className="section-shell pb-20">
        <div className="overflow-hidden rounded-3xl border border-white/10 bg-white/[0.04] shadow-2xl backdrop-blur">
          <div className="grid gap-0 lg:grid-cols-[1fr_1fr]">
            <div className="border-b border-white/10 p-8 lg:border-b-0 lg:border-r lg:border-white/10">
              <p className="badge">System overview</p>
              <h2 className="mt-3 text-3xl font-semibold text-white">Focus on the evaluation workflow, not the interface.</h2>
              <p className="mt-3 max-w-xl text-sm leading-6 text-slate-400">
                The application keeps the experience simple: sign in, complete the assigned task, review the results, and move on.
              </p>
            </div>

            <div className="grid gap-4 p-8 sm:grid-cols-2">
              {[
                ["Admin", "Periods, rubric setup, assignments, and user management."],
                ["Faculty", "Evaluation summaries, performance, and comments."],
                ["Program Head", "Department-level analysis and faculty overview."],
                ["Student", "Evaluations and sentiment submission."],
              ].map(([title, desc]) => (
                <div key={title} className="rounded-2xl border border-white/10 bg-slate-950/70 p-4">
                  <h3 className="text-sm font-semibold uppercase tracking-[0.2em] text-slate-200">{title}</h3>
                  <p className="mt-2 text-sm leading-6 text-slate-400">{desc}</p>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>
    </main>
  );
}

