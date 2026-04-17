"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

const tabs = [
  { href: "/faculty", label: "Dashboard" },
  { href: "/faculty/self-evaluation", label: "Self Evaluation" },
  { href: "/faculty/performance", label: "Performance Rating" },
  { href: "/faculty/summary", label: "Evaluation Summary" },
  { href: "/faculty/sentiment", label: "Sentiment Report" },
  { href: "/faculty/analytics", label: "Data & Graphs" },
];

export default function FacultyTabNav() {
  const pathname = usePathname();

  return (
    <nav className="-mb-px flex gap-1 overflow-x-auto">
      {tabs.map((tab) => {
        const active = pathname === tab.href;
        return (
          <Link
            key={tab.href}
            href={tab.href}
            className={`whitespace-nowrap border-b-2 px-4 py-3 text-sm font-medium transition-colors ${
              active
                ? "border-accent text-accent"
                : "border-transparent text-slate-600 hover:border-slate-200 hover:text-ink"
            }`}
          >
            {tab.label}
          </Link>
        );
      })}
    </nav>
  );
}
