"use client";

import { FormEvent, useState } from "react";
import { useRouter } from "next/navigation";

export default function ChangePasswordForm() {
  const router = useRouter();
  const [message, setMessage] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  const submit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setSaving(true);
    setMessage(null);

    const formData = new FormData(event.currentTarget);
    const response = await fetch("/api/account", {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        current_password: formData.get("current_password"),
        new_password: formData.get("new_password"),
        confirm_password: formData.get("confirm_password"),
      }),
    });

    const payload = await response.json().catch(() => ({}));
    if (!response.ok) {
      setMessage(payload.error || "Unable to update password.");
      setSaving(false);
      return;
    }

    setMessage("Password changed. Redirecting...");
    const role = payload.profile?.role;
    router.replace(role === "admin" ? "/admin" : role === "student" ? "/student" : role === "program_head" ? "/program-head" : "/faculty");
    router.refresh();
  };

  return (
    <form onSubmit={submit} className="space-y-4 rounded-2xl border border-white/10 bg-white/[0.04] p-5">
      <p className="text-sm text-slate-300">
        You must change your password before continuing. Use the temporary password provided by your administrator.
      </p>
      <div className="grid gap-4 md:grid-cols-3">
        <label className="space-y-1 text-sm">
          Current password
          <input className="input w-full" name="current_password" type="password" required />
        </label>
        <label className="space-y-1 text-sm">
          New password
          <input className="input w-full" name="new_password" type="password" required />
        </label>
        <label className="space-y-1 text-sm">
          Confirm password
          <input className="input w-full" name="confirm_password" type="password" required />
        </label>
      </div>
      {message ? <p className="text-sm text-slate-300">{message}</p> : null}
      <button className="btn-primary" disabled={saving} type="submit">
        {saving ? "Saving..." : "Change password"}
      </button>
    </form>
  );
}