"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

const links = [
  { href: "/admin", label: "Dashboard", icon: "📊" },
  { href: "/admin/records", label: "Records", icon: "📚" },
  { href: "/admin/users", label: "Users", icon: "👥" },
  { href: "/student", label: "Student", icon: "🧑‍🎓" },
  { href: "/faculty", label: "Faculty", icon: "🎓" },
];

export default function SidebarNav() {
  const pathname = usePathname();

  return (
    <nav className="space-y-2 text-sm text-slate-300">
      {links.map((link) => {
        const active = pathname === link.href || pathname.startsWith(link.href);
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
