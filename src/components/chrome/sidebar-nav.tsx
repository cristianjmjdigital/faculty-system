"use client";

import Link from "next/link";
import { usePathname, useSearchParams } from "next/navigation";

type NavLink = {
  href: string;
  label: string;
  icon: string;
  role?: string;
};

const managedRoles = new Set(["faculty", "student"]);

const links: NavLink[] = [
  { href: "/admin", label: "Dashboard", icon: "📊" },
  { href: "/admin/records", label: "Records", icon: "📚" },
  { href: "/admin/users", label: "Users", icon: "👥" },
  { href: "/admin/users?role=faculty", label: "Faculty", icon: "🎓", role: "faculty" },
  { href: "/admin/users?role=student", label: "Students", icon: "🧑‍🎓", role: "student" },
];

export default function SidebarNav() {
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const currentRole = searchParams?.get("role") ?? null;

  return (
    <nav className="space-y-2 text-sm text-slate-300">
      {links.map((link) => {
        const linkPath = link.href.split("?")[0];
        const pathMatch = pathname === linkPath || pathname.startsWith(`${linkPath}/`);
        const roleMatch = link.role
          ? currentRole === link.role
          : !managedRoles.has(currentRole ?? "");
        const active = pathMatch && roleMatch;
        return (
          <Link
            key={link.href}
            href={link.href}
            className={`flex items-center gap-3 rounded-lg px-3 py-2 transition hover:bg-white/10 ${
              active ? "bg-white/15 text-white" : ""
            }`}
          >
            <span>{link.icon}</span>
            <span className="font-semibold">{link.label}</span>
          </Link>
        );
      })}
    </nav>
  );
}
