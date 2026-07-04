import Link from "next/link";
import { redirect } from "next/navigation";
import ChangePasswordForm from "./change-password-form";
import { getServerSessionUser, roleDefaultPath } from "@/lib/local-auth";

export const dynamic = "force-dynamic";

export default async function ChangePasswordPage() {
  const user = await getServerSessionUser();
  if (!user) {
    redirect("/auth/login");
  }

  if (!user.must_change_password) {
    redirect(roleDefaultPath(user.role));
  }

  return (
    <main className="grid min-h-screen place-items-center bg-slate-950 p-6 text-white">
      <div className="w-full max-w-xl space-y-5 rounded-2xl border border-white/10 bg-white/[0.04] p-6">
        <div className="space-y-1">
          <p className="badge">First login</p>
          <h1 className="text-2xl font-bold">Change your password</h1>
          <p className="text-sm text-slate-400">
            Your account was created with a temporary password. Update it before accessing your portal.
          </p>
        </div>

        <div className="rounded-xl border border-white/10 bg-black/20 px-4 py-3 text-sm text-slate-300">
          Privacy notice: identity data and evaluation records are protected and used only for academic reporting.
        </div>

        <ChangePasswordForm />

        <Link href="/api/auth/logout" className="inline-flex text-sm text-slate-400 hover:text-white">
          Sign out instead
        </Link>
      </div>
    </main>
  );
}