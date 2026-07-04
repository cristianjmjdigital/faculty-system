"use client";

import { FormEvent, useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import type { UserRole } from "@/lib/local-auth";

type Props = {
  next: string;
  expectedRole?: UserRole;
};

function defaultPathForRole(role?: string) {
  if (role === "admin") return "/admin";
  if (role === "faculty") return "/faculty";
  if (role === "evaluator") return "/evaluator";
  return "/student";
}

export default function LoginForm({ next, expectedRole }: Props) {
  const router = useRouter();
  const [status, setStatus] = useState<{ kind: "idle" | "error"; message?: string }>({ kind: "idle" });
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    fetch("/api/auth/me", { cache: "no-store" })
      .then(async (res) => {
        if (!res.ok) return null;
        const data = await res.json();
        return data.user;
      })
      .then((user) => {
        if (user) {
          if (user.must_change_password) {
            router.replace("/auth/change-password");
            return;
          }
          if (expectedRole && user.role !== expectedRole) {
            router.replace(defaultPathForRole(user.role));
            return;
          }
          router.replace(next || defaultPathForRole(user.role));
        }
      })
      .catch(() => {
        // Ignore session check errors on first load.
      });
  }, [next, router, expectedRole]);

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setStatus({ kind: "idle" });
    setLoading(true);

    const formData = new FormData(event.currentTarget);
    const email = (formData.get("email") as string) || "";
    const password = (formData.get("password") as string) || "";

    const response = await fetch("/api/auth/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password, next, expectedRole }),
    });

    const payload = await response.json().catch(() => ({}));

    if (!response.ok) {
      setStatus({ kind: "error", message: payload.error || "Unable to sign in." });
      setLoading(false);
      return;
    }

    router.replace(payload.next || next || "/student");
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
            <span className="h-4 w-4 animate-spin rounded-full border-2 border-white/30 border-t-white" />
            Signing in...
          </span>
        ) : (
          "Sign in"
        )}
      </button>

      <p className="rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-xs text-slate-600">
        Privacy notice: Evaluation identities are protected and personal data is handled for academic quality assurance only.
      </p>
    </form>
  );
}

