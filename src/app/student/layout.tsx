import type { ReactNode } from "react";
import Link from "next/link";
import StudentTabNav from "@/components/chrome/student-tab-nav";
import SignOutButton from "@/components/chrome/sign-out-button";

export default function StudentLayout({ children }: { children: ReactNode }) {
  return (
    <div className="min-h-screen bg-sand text-ink">
      <header className="border-b border-slate-200/80 bg-white/80 backdrop-blur-xl">
        <div className="section-shell flex items-center justify-between py-4">
          <div className="flex items-center gap-3">
            <div>
              <p className="text-xs font-medium uppercase tracking-wider text-slate-400">RateMe</p>
              <p className="text-sm font-semibold text-ink">Faculty Evaluation with Decision Support System</p>
            </div>
          </div>
          <div className="flex items-center gap-3">
            <SignOutButton className="btn-ghost text-xs">Sign out</SignOutButton>
          </div>
        </div>
        <div className="section-shell !py-0">
          <StudentTabNav />
        </div>
      </header>
      <main className="fade-in">{children}</main>
    </div>
  );
}
