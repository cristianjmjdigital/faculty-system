import Link from "next/link";
import { redirect } from "next/navigation";
import { getDbServerClient } from "@/lib/db-server";
import { getServerSessionUser, roleDefaultPath } from "@/lib/local-auth";
import PrintButton from "./print-button";

export const dynamic = "force-dynamic";

type CredentialRow = {
  id: string;
  full_name: string | null;
  email: string | null;
  password: string | null;
  role: string;
  department_id: string | null;
};

export default async function CredentialsPage() {
  const user = await getServerSessionUser();
  if (!user) {
    redirect("/auth/login/admin?next=%2Fadmin%2Fcredentials");
  }
  if (user.must_change_password) {
    redirect("/auth/change-password");
  }
  if (user.role !== "admin") {
    redirect(roleDefaultPath(user.role));
  }

  const db = getDbServerClient();
  const [profilesRes, departmentsRes] = await Promise.all([
    db.from("profiles").select("id, full_name, email, password, role, department_id").order("full_name", { ascending: true }),
    db.from("departments").select("id, name"),
  ]);

  const rows: CredentialRow[] = (profilesRes.data ?? []) as any[];
  const departments = new Map<string, string>();
  for (const dept of (departmentsRes.data ?? []) as any[]) {
    departments.set(dept.id, dept.name);
  }

  return (
    <main className="section-shell space-y-6 py-8 print:py-0">
      <style>{`
        @media print {
          .no-print { display: none !important; }
          body { background: #fff !important; color: #000 !important; }
        }
      `}</style>

      <div className="no-print flex items-center justify-between gap-4 rounded-3xl border border-white/10 bg-white/[0.04] p-6 text-white">
        <div>
          <div className="badge">Admin</div>
          <h1 className="mt-2 text-2xl font-bold">Printable credentials</h1>
          <p className="text-sm text-slate-400">Use this sheet to hand out temporary access credentials offline.</p>
        </div>
        <div className="flex gap-2">
          <Link href="/admin/users" className="btn-secondary">Back to users</Link>
          <PrintButton />
        </div>
      </div>

      <div className="rounded-3xl border border-slate-200 bg-white p-6 text-slate-900 shadow-sm">
        <div className="mb-5 flex items-center justify-between border-b border-slate-200 pb-4">
          <div>
            <h2 className="text-xl font-bold">Faculty Evaluation System</h2>
            <p className="text-sm text-slate-600">Credential handout for local deployment</p>
          </div>
          <div className="text-right text-xs text-slate-500">
            <p>Generated for admin use only</p>
            <p>{new Date().toLocaleString()}</p>
          </div>
        </div>

        <div className="mb-5 rounded-2xl border border-amber-200 bg-amber-50 p-4 text-sm text-amber-900">
          Temporary passwords should be changed on first login. Share this sheet only with the intended account holder.
        </div>

        <div className="overflow-auto rounded-2xl border border-slate-200">
          <table className="min-w-full text-left text-sm">
            <thead className="bg-slate-50 text-xs uppercase tracking-[0.2em] text-slate-500">
              <tr>
                <th className="px-4 py-3">Name</th>
                <th className="px-4 py-3">Email</th>
                <th className="px-4 py-3">Password</th>
                <th className="px-4 py-3">Role</th>
                <th className="px-4 py-3">Department</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((row) => (
                <tr key={row.id} className="border-t border-slate-200">
                  <td className="px-4 py-3 font-medium">{row.full_name ?? "(no name)"}</td>
                  <td className="px-4 py-3">{row.email ?? "—"}</td>
                  <td className="px-4 py-3 font-mono text-sm">{row.password ?? "—"}</td>
                  <td className="px-4 py-3 capitalize">{row.role}</td>
                  <td className="px-4 py-3">{row.department_id ? departments.get(row.department_id) ?? row.department_id : "—"}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </main>
  );
}