import LoginForm from "../login/login-form";
import Link from "next/link";

export const dynamic = "force-dynamic";

export default function FacultyLoginPage() {
  return (
    <main className="grid min-h-screen lg:grid-cols-2">
      <div className="relative hidden overflow-hidden hero-bg lg:flex lg:flex-col lg:justify-between lg:p-12">
        <div className="absolute inset-0 opacity-20" aria-hidden>
          <div className="pointer-events-none absolute -left-20 top-20 h-72 w-72 rounded-full bg-accent/50 blur-[100px]" />
          <div className="pointer-events-none absolute bottom-10 right-10 h-56 w-56 rounded-full bg-accent-light/30 blur-[80px]" />
        </div>

        <div className="relative z-10">
          <Link href="/" className="inline-flex items-center">
            <span className="text-lg font-semibold text-ink">RateMe: Faculty Evaluation with Decision Support System</span>
          </Link>
        </div>

        <div className="relative z-10 space-y-6">
          <h1 className="text-4xl font-bold leading-tight text-ink">Faculty sign in</h1>
          <p className="max-w-md text-lg text-slate-600">
            Access your faculty dashboard, performance ratings, and evaluation summaries.
          </p>
        </div>

        <p className="relative z-10 text-xs text-slate-500">
          &copy; {new Date().getFullYear()} RateMe: Faculty Evaluation with Decision Support System
        </p>
      </div>

      <div className="flex items-center justify-center bg-slate-50 p-6 sm:p-12">
        <div className="w-full max-w-md space-y-8 fade-in">
          <div className="lg:hidden">
            <Link href="/" className="inline-flex items-center">
              <span className="text-lg font-semibold text-ink">RateMe: Faculty Evaluation with Decision Support System</span>
            </Link>
          </div>

          <div className="space-y-2">
            <h2 className="text-3xl font-bold tracking-tight text-ink">Faculty sign in</h2>
            <p className="text-muted">Use your faculty credentials to continue.</p>
          </div>

          <LoginForm forceRedirect="/faculty" />

          <p className="text-center text-xs text-muted">
            <Link href="/auth/login" className="font-medium text-accent hover:text-accent-light transition-colors">
              Back to main sign in
            </Link>
          </p>
        </div>
      </div>
    </main>
  );
}
