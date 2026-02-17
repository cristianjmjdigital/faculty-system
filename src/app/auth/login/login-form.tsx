"use client";

import { FormEvent, useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { getSupabaseBrowserClient } from "@/lib/supabase-browser";

type Props = {
  next: string;
};

export default function LoginForm({ next }: Props) {
  const supabase = useMemo(() => getSupabaseBrowserClient(), []);
  const router = useRouter();
  const [status, setStatus] = useState<{ kind: "idle" | "error"; message?: string }>({ kind: "idle" });
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    let mounted = true;
    supabase.auth.getSession().then(({ data }) => {
      if (!mounted) return;
      if (data.session) {
        router.replace(next);
      }
    });
    return () => {
      mounted = false;
    };
  }, [next, router, supabase]);

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

    router.replace(next);
  };

  return (
    <form className="space-y-4" onSubmit={handleSubmit}>
      {status.kind === "error" ? (
        <div className="rounded-lg bg-rose-50 p-3 text-sm text-rose-800">{status.message}</div>
      ) : null}

      <label className="space-y-1 text-sm font-medium">
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

      <label className="space-y-1 text-sm font-medium">
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
        {loading ? "Signing in..." : "Sign in"}
      </button>
    </form>
  );
}
