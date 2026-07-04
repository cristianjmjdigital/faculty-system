import Link from "next/link";
import { getDbServerClient } from "@/lib/db-server";
import UsersTable from "@/components/admin/users-table";
import AddUserForm from "@/components/admin/add-user-form";

const allowedRoles = new Set(["admin", "faculty", "student", "evaluator", "program_head"]);

export const dynamic = "force-dynamic";

type UsersPageProps = {
  searchParams?: {
    role?: string;
  };
};

export default async function UsersPage({ searchParams }: UsersPageProps) {
  const db = getDbServerClient();
  const roleFilter = searchParams?.role && allowedRoles.has(searchParams.role) ? searchParams.role : undefined;
  const defaultRoleForForm = (roleFilter as "admin" | "faculty" | "student" | "evaluator" | "program_head" | undefined) ?? "faculty";

  const [departmentsRes, profilesRes] = await Promise.all([
    db.from("departments").select("id, name").order("name", { ascending: true }),
    (function fetchProfiles() {
      let query = db
        .from("profiles")
        .select("id, full_name, email, role, department_id")
        .order("full_name", { ascending: true })
        .limit(100);

      if (roleFilter) {
        query = query.eq("role", roleFilter);
      }

      return query;
    })(),
  ]);

  const departments = departmentsRes.data ?? [];
  const data = profilesRes.data;
  const error = profilesRes.error ?? departmentsRes.error;

  return (
    <main className="section-shell space-y-6">
      <header className="space-y-1">
        <div className="badge">Admin</div>
        <h1 className="mt-2 text-2xl font-bold text-white">Users & roles</h1>
        <p className="text-slate-400 text-sm">
          Manage admin / faculty / student roles{roleFilter ? ` — filtered to ${roleFilter}.` : "."}
        </p>
        <div className="pt-2">
          <Link href="/admin/credentials" className="text-sm font-medium text-cyan-300 hover:text-cyan-200">
            Open printable credential sheet
          </Link>
        </div>
      </header>

      <div className="card glass">
        <div className="card-header">
          <h2 className="text-lg font-semibold text-white">Add faculty / student</h2>
        </div>
        <div className="card-body bg-white/60 backdrop-blur">
          <AddUserForm departments={departments} defaultRole={defaultRoleForForm} />
        </div>
      </div>

      <div className="card glass">
        <div className="card-header">
          <h2 className="text-lg font-semibold text-white">Directory</h2>
          {roleFilter ? <span className="pill">{roleFilter}</span> : null}
        </div>
        <div className="card-body bg-white/60 backdrop-blur">
          <UsersTable initialProfiles={data ?? []} error={error?.message} />
        </div>
      </div>
    </main>
  );
}


