"use client";

import { FormEvent, useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { getSupabaseBrowserClient } from "@/lib/supabase-browser";

type LoginFormProps = {
  forceRedirect?: string;
};

const roleRouteMap: Record<string, string> = {
  admin: "/admin",
  faculty: "/faculty",
  student: "/student",
  evaluator: "/evaluator",
};

export default function LoginForm({ forceRedirect }: LoginFormProps) {
  const supabase = useMemo(() => getSupabaseBrowserClient(), []);
  const router = useRouter();
  const [status, setStatus] = useState<{ kind: "idle" | "error"; message?: string }>({ kind: "idle" });
  const [loading, setLoading] = useState(false);

  const resolveRedirect = async (userId: string) => {
    if (forceRedirect) return forceRedirect;
    const { data, error } = await supabase
      .from("profiles")
      .select("role")
      .eq("id", userId)
      .maybeSingle();

    if (error) return "/student";
    return roleRouteMap[data?.role ?? "student"] ?? "/student";
  };

  useEffect(() => {
    let mounted = true;
    supabase.auth.getSession().then(async ({ data }) => {
      if (!mounted) return;
      if (data.session) {
        const redirectTo = await resolveRedirect(data.session.user.id);
        router.replace(redirectTo);
      }
    });
    return () => {
      mounted = false;
    };
  }, [forceRedirect, router, supabase]);

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setStatus({ kind: "idle" });
    setLoading(true);

    const formData = new FormData(event.currentTarget);
    const email = (formData.get("email") as string) || "";
    const password = (formData.get("password") as string) || "";

    const { error } = await supabase.auth.signInWithPassword({ email, password });

    if (error) {
      setStatus({ kind: "error", message: error.message });
      setLoading(false);
      return;
    }

    const { data: userData } = await supabase.auth.getUser();
    const userId = userData.user?.id;
    const redirectTo = userId ? await resolveRedirect(userId) : "/student";
    router.replace(redirectTo);
  };

  return (
    <form className="space-y-5" onSubmit={handleSubmit}>
      {status.kind === "error" ? (
        <div className="rounded-xl bg-rose-50 border border-rose-200 p-4 text-sm text-rose-700">{status.message}</div>
      ) : null}

      <label className="block space-y-1.5 text-sm font-medium text-slate-700">
        Email
        <input
          name="email"
          type="email"
          required
          className="input"
          placeholder="you@example.com"
          autoComplete="email"
        />
      </label>

      <label className="block space-y-1.5 text-sm font-medium text-slate-700">
        Password
        <input
          name="password"
          type="password"
          required
          className="input"
          placeholder="••••••••"
          autoComplete="current-password"
        />
      </label>

      <button type="submit" className="btn-primary w-full" disabled={loading}>
        {loading ? (
          <span className="flex items-center gap-2">
            <span className="h-4 w-4 animate-spin rounded-full border-2 border-slate-300 border-t-slate-600" />
            Signing in...
          </span>
        ) : (
          "Sign in"
        )}
      </button>
    </form>
  );
}
