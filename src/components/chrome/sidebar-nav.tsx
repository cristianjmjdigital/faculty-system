"use client";

import Link from "next/link";
import { usePathname, useSearchParams } from "next/navigation";

type NavLink = {
  href: string;
  label: string;
  role?: string;
  section?: string;
};

const managedRoles = new Set(["faculty", "student"]);

const links: NavLink[] = [
  { href: "/admin", label: "Dashboard", section: "Management" },
  { href: "/admin/assignments", label: "Assignments" },
  { href: "/admin/records", label: "Records" },
  { href: "/admin/users", label: "Users", section: "People" },
  { href: "/admin/users?role=faculty", label: "Faculty", role: "faculty" },
  { href: "/admin/users?role=student", label: "Students", role: "student" },
  { href: "/faculty", label: "My Dashboard", section: "Personal" },
];

export default function SidebarNav() {
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const currentRole = searchParams?.get("role") ?? null;

  let lastSection = "";

  return (
    <nav className="space-y-1 text-sm">
      {links.map((link) => {
        const linkPath = link.href.split("?")[0];
        const pathMatch = pathname === linkPath || pathname.startsWith(`${linkPath}/`);
        const roleMatch = link.role
          ? currentRole === link.role
          : !managedRoles.has(currentRole ?? "");
        const active = pathMatch && roleMatch;

        const showSection = link.section && link.section !== lastSection;
        if (link.section) lastSection = link.section;

        return (
          <div key={link.href}>
            {showSection && (
              <div className="mb-2 mt-6 px-3 text-[10px] font-semibold uppercase tracking-widest text-slate-500 first:mt-0">
                {link.section}
              </div>
            )}
            <Link
              href={link.href}
              className={`flex items-center rounded-xl px-3 py-2.5 transition-all duration-150 ${
                active
                  ? "bg-accent/10 text-accent font-semibold shadow-sm"
                  : "text-slate-600 hover:bg-slate-100 hover:text-ink"
              }`}
            >
              <span>{link.label}</span>
            </Link>
          </div>
        );
      })}
    </nav>
  );
}
