import LoginForm from "../login-form";
import { getServerSessionUser, roleDefaultPath } from "@/lib/local-auth";
import { redirect } from "next/navigation";
import Link from "next/link";

export const dynamic = "force-dynamic";

export default async function StudentLoginPage({ searchParams }: { searchParams?: Record<string, string | string[] | undefined> }) {
  const nextParam = searchParams?.next;
  const next = typeof nextParam === "string" && nextParam.startsWith("/") ? nextParam : "/student";

  const user = await getServerSessionUser();
  if (user) {
    redirect(user.role === "student" ? next : roleDefaultPath(user.role));
  }

  return (
    <main className="grid min-h-screen place-items-center bg-slate-50 p-6">
      <div className="w-full max-w-md rounded-2xl border border-slate-200 bg-white p-6 shadow-sm space-y-5">
        <div className="space-y-1">
          <p className="badge">Student</p>
          <h1 className="text-2xl font-bold text-ink">Student Login</h1>
          <p className="text-sm text-muted">Use a student account to submit evaluations and sentiments.</p>
        </div>

        <LoginForm next={next} expectedRole="student" />

        <p className="text-xs text-muted">
          Need faculty or admin access? Go to <Link href="/auth/login/faculty" className="text-accent hover:text-accent-light">faculty login</Link> or <Link href="/auth/login/admin" className="text-accent hover:text-accent-light">admin login</Link>.
        </p>
      </div>
    </main>
  );
}
