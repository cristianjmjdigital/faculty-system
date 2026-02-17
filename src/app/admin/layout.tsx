import type { ReactNode } from "react";
import SidebarNav from "@/components/chrome/sidebar-nav";
import Link from "next/link";

export default function AdminLayout({ children }: { children: ReactNode }) {
  return (
    <div className="min-h-screen bg-slate-950 text-white">
      <div className="flex">
        <aside className="sidebar">
          <div className="px-4 py-6">
            <div className="mb-8 flex items-center gap-2">
              <div className="h-10 w-10 rounded-xl bg-gradient-to-br from-indigo-500 to-sky-400" />
              <div>
                <p className="text-xs uppercase tracking-wide text-slate-300">Faculty Eval</p>
                <p className="text-base font-semibold">Academy</p>
              </div>
            </div>
            <SidebarNav />
          </div>
        </aside>

        <div className="flex-1">
          <header className="topbar">
            <div className="hidden items-center gap-3 md:flex">
              <span className="text-lg">👋</span>
              <div>
                <p className="text-sm text-slate-300">Hello Admin</p>
                <p className="text-base font-semibold text-white">Have a good day</p>
              </div>
            </div>
            <div className="flex flex-1 items-center gap-3">
              <div className="relative flex-1 max-w-md">
                <input
                  className="input w-full bg-white/10 text-white placeholder:text-slate-400"
                  placeholder="Search"
                />
                <span className="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 text-xs text-slate-400">⌘K</span>
              </div>
              <div className="flex items-center gap-3">
                <button className="rounded-full bg-white/10 p-2 text-white">☀️</button>
                <div className="h-10 w-10 rounded-full bg-gradient-to-br from-sky-400 to-indigo-600" />
              </div>
            </div>
          </header>

          <main className="pb-12 pt-4">{children}</main>
        </div>
      </div>
    </div>
  );
}