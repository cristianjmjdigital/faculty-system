import LoginForm from "../login-form";
import { getServerSessionUser, roleDefaultPath } from "@/lib/local-auth";
import { redirect } from "next/navigation";
import Link from "next/link";

export const dynamic = "force-dynamic";

export default async function AdminLoginPage({ searchParams }: { searchParams?: Record<string, string | string[] | undefined> }) {
  const nextParam = searchParams?.next;
  const next = typeof nextParam === "string" && nextParam.startsWith("/") ? nextParam : "/admin";

  const user = await getServerSessionUser();
  if (user) {
    redirect(user.role === "admin" ? next : roleDefaultPath(user.role));
  }

  return (
    <main className="grid min-h-screen place-items-center bg-slate-50 p-6">
      <div className="w-full max-w-md rounded-2xl border border-slate-200 bg-white p-6 shadow-sm space-y-5">
        <div className="space-y-1">
          <p className="badge">Admin</p>
          <h1 className="text-2xl font-bold text-ink">Admin Login</h1>
          <p className="text-sm text-muted">Use an admin account to access management pages.</p>
        </div>

        <LoginForm next={next} expectedRole="admin" />

        <p className="text-xs text-muted">
          Not an admin? Try the <Link href="/auth/login/faculty" className="text-accent hover:text-accent-light">faculty login</Link> or <Link href="/auth/login/student" className="text-accent hover:text-accent-light">student login</Link>.
        </p>
      </div>
    </main>
  );
}
