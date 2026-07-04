import Link from "next/link";
import { redirect } from "next/navigation";
import AccountClient from "./account-client";
import { getServerSessionUser, roleDefaultPath } from "@/lib/local-auth";

export const dynamic = "force-dynamic";

export default async function AccountPage() {
  const user = await getServerSessionUser();
  if (!user) {
    redirect("/auth/login");
  }

  if (user.must_change_password) {
    redirect("/auth/change-password");
  }

  return (
    <main className="section-shell space-y-6">
      <header className="space-y-1">
        <div className="badge">Account</div>
        <h1 className="mt-2 text-2xl font-bold text-white">Update information</h1>
        <p className="text-slate-400 text-sm">Manage your personal details and password.</p>
      </header>

      <div className="rounded-2xl border border-white/10 bg-white/[0.04] p-4 text-sm text-slate-300">
        Privacy notice: your identity is kept confidential in the evaluation process.
      </div>

      <AccountClient />

      <Link href={roleDefaultPath(user.role)} className="btn-secondary inline-flex w-fit">
        Back to portal
      </Link>
    </main>
  );
}