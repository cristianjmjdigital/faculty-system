import LoginForm from "./login-form";
import { getSupabaseServerClient } from "@/lib/supabase-server";
import { redirect } from "next/navigation";

export const dynamic = "force-dynamic";

export default async function LoginPage({ searchParams }: { searchParams?: Record<string, string | string[] | undefined> }) {
  const supabase = getSupabaseServerClient();
  const nextParam = searchParams?.next;
  const next = typeof nextParam === "string" && nextParam.startsWith("/") ? nextParam : "/student";

  const { data } = await supabase.auth.getUser();
  if (data?.user) {
    redirect(next);
  }

  return (
    <main className="section-shell max-w-xl space-y-6">
      <header className="space-y-1 text-center">
        <p className="text-sm uppercase tracking-wide text-slate-500">Auth</p>
        <h1 className="text-2xl font-bold">Sign in</h1>
        <p className="text-slate-600 text-sm">Use your email and password to access the portal.</p>
      </header>

      <div className="card">
        <div className="card-body">
          <LoginForm next={next} />
        </div>
      </div>
    </main>
  );
}
