import { getSupabaseServerClient } from "@/lib/supabase-server";
import UsersTable from "@/components/admin/users-table";

export const dynamic = "force-dynamic";

export default async function UsersPage() {
  const supabase = getSupabaseServerClient();
  const { data, error } = await supabase
    .from("profiles")
    .select("id, full_name, email, role, department_id")
    .order("full_name", { ascending: true })
    .limit(100);

  return (
    <main className="section-shell space-y-6">
      <header className="space-y-1">
        <p className="text-sm uppercase tracking-wide text-slate-300">Admin</p>
        <h1 className="text-2xl font-bold text-white">Users & roles</h1>
        <p className="text-slate-200 text-sm">Manage admin / faculty / student roles.</p>
      </header>

      <div className="card glass">
        <div className="card-header">
          <h2 className="text-lg font-semibold text-white">Directory</h2>
        </div>
        <div className="card-body bg-white/60 backdrop-blur">
          <UsersTable initialProfiles={data ?? []} error={error?.message} />
        </div>
      </div>
    </main>
  );
}
