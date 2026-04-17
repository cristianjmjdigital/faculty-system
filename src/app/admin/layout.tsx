import type { ReactNode } from "react";
import SidebarNav from "@/components/chrome/sidebar-nav";
import Link from "next/link";
import SignOutButton from "@/components/chrome/sign-out-button";

export default function AdminLayout({ children }: { children: ReactNode }) {
  return (
    <div className="min-h-screen bg-sand text-ink">
      <div className="flex">
        <aside className="sidebar">
          <div className="flex flex-col h-full px-5 py-6">
            <Link href="/" className="mb-10 flex items-center gap-3">
              <div>
                <p className="text-xs font-medium uppercase tracking-wider text-slate-400">RateMe</p>
                <p className="text-sm font-semibold text-ink">Faculty Evaluation with Decision Support System</p>
              </div>
            </Link>
            <SidebarNav />
            <div className="mt-auto pt-8 border-t border-slate-200/80">
              <SignOutButton className="flex items-center gap-2 rounded-xl px-3 py-2.5 text-sm text-slate-600 transition hover:bg-slate-100 hover:text-ink">
                Sign out
              </SignOutButton>
            </div>
          </div>
        </aside>

        <div className="flex-1">
          <header className="topbar">
            <div className="flex flex-1 items-center gap-4">
              <div className="relative flex-1 max-w-md">
                <input
                  className="input w-full !rounded-xl border-slate-200 bg-white text-ink placeholder:text-slate-400 focus:border-accent/40 focus:ring-accent/10"
                  placeholder="Search..."
                />
                <span className="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 rounded-md bg-slate-100 px-1.5 py-0.5 text-[10px] text-slate-500">⌘K</span>
              </div>
              <div className="flex items-center gap-2 ml-auto">
              </div>
            </div>
          </header>

          <main className="pb-12 pt-4 fade-in">{children}</main>
        </div>
      </div>
    </div>
  );
}