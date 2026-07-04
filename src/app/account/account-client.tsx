"use client";

import { FormEvent, useEffect, useState } from "react";

type Profile = {
  id: string;
  full_name: string | null;
  email: string | null;
  role: string;
  department_id: string | null;
  phone: string | null;
  address: string | null;
  position_title: string | null;
  must_change_password: boolean;
};

export default function AccountClient() {
  const [profile, setProfile] = useState<Profile | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [passwordSaving, setPasswordSaving] = useState(false);
  const [message, setMessage] = useState<string | null>(null);

  useEffect(() => {
    fetch("/api/account", { cache: "no-store" })
      .then(async (res) => {
        const data = await res.json().catch(() => ({}));
        if (res.ok) {
          setProfile(data.profile);
        } else {
          setMessage(data.error || "Unable to load profile.");
        }
      })
      .finally(() => setLoading(false));
  }, []);

  const submitProfile = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setSaving(true);
    setMessage(null);

    const formData = new FormData(event.currentTarget);
    const response = await fetch("/api/account", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        full_name: formData.get("full_name"),
        email: formData.get("email"),
        phone: formData.get("phone"),
        address: formData.get("address"),
        position_title: formData.get("position_title"),
      }),
    });

    const payload = await response.json().catch(() => ({}));
    if (!response.ok) {
      setMessage(payload.error || "Unable to save profile.");
      setSaving(false);
      return;
    }

    setProfile(payload.profile);
    setMessage("Profile updated.");
    setSaving(false);
  };

  const submitPassword = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setPasswordSaving(true);
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
      setMessage(payload.error || "Unable to change password.");
      setPasswordSaving(false);
      return;
    }

    setProfile(payload.profile);
    setMessage("Password updated.");
    event.currentTarget.reset();
    setPasswordSaving(false);
  };

  if (loading) {
    return <p className="text-sm text-slate-400">Loading profile...</p>;
  }

  if (!profile) {
    return <p className="text-sm text-rose-300">Unable to load account details.</p>;
  }

  return (
    <div className="space-y-8">
      {message ? <div className="rounded-xl bg-white/5 px-4 py-3 text-sm text-slate-200">{message}</div> : null}

      <form onSubmit={submitProfile} className="space-y-4 rounded-2xl border border-white/10 bg-white/[0.04] p-5">
        <div>
          <h2 className="text-lg font-semibold text-white">Personal Information</h2>
          <p className="text-sm text-slate-400">Update your contact details and display information.</p>
        </div>

        <div className="grid gap-4 md:grid-cols-2">
          <label className="space-y-1 text-sm">
            Full name
            <input className="input w-full" name="full_name" defaultValue={profile.full_name ?? ""} />
          </label>
          <label className="space-y-1 text-sm">
            Email
            <input className="input w-full" name="email" type="email" defaultValue={profile.email ?? ""} />
          </label>
          <label className="space-y-1 text-sm">
            Phone
            <input className="input w-full" name="phone" defaultValue={profile.phone ?? ""} />
          </label>
          <label className="space-y-1 text-sm">
            Position title
            <input className="input w-full" name="position_title" defaultValue={profile.position_title ?? ""} />
          </label>
          <label className="space-y-1 text-sm md:col-span-2">
            Address
            <textarea className="input w-full" name="address" rows={3} defaultValue={profile.address ?? ""} />
          </label>
        </div>

        <button className="btn-primary" disabled={saving} type="submit">
          {saving ? "Saving..." : "Save profile"}
        </button>
      </form>

      <form onSubmit={submitPassword} className="space-y-4 rounded-2xl border border-white/10 bg-white/[0.04] p-5">
        <div>
          <h2 className="text-lg font-semibold text-white">Change Password</h2>
          <p className="text-sm text-slate-400">
            {profile.must_change_password
              ? "A password change is required before you continue."
              : "Use a new password whenever you need to update your login credentials."}
          </p>
        </div>

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

        <button className="btn-primary" disabled={passwordSaving} type="submit">
          {passwordSaving ? "Updating..." : "Update password"}
        </button>
      </form>
    </div>
  );
}