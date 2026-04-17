"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

const tabs = [
  { href: "/student", label: "Dashboard" },
  { href: "/student/evaluate", label: "Evaluate Faculty" },
  { href: "/student/sentiment", label: "Submit Sentiment" },
];

export default function StudentTabNav() {
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
