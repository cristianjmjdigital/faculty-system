"use client";

import { FormEvent, useMemo, useState } from "react";
import { getSupabaseBrowserClient } from "@/lib/supabase-browser";

type PeriodOption = {
  id: string;
  name: string;
};

type SectionOption = {
  id: string;
  label: string;
  facultyId: string | null;
};

type Props = {
  periods: PeriodOption[];
  sections: SectionOption[];
};

export default function StudentForm({ periods, sections }: Props) {
  const supabase = useMemo(() => getSupabaseBrowserClient(), []);
  const [status, setStatus] = useState<{ kind: "idle" | "success" | "error"; message?: string }>({ kind: "idle" });
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setStatus({ kind: "idle" });
    setIsSubmitting(true);

    const formData = new FormData(event.currentTarget);
    const periodId = (formData.get("periodId") as string) || null;
    const sectionId = (formData.get("sectionId") as string) || null;
    const sentiment = (formData.get("sentiment") as string) || "positive";
    const comments = (formData.get("comments") as string) || "";

    const facultyId = sectionId
      ? sections.find((s) => s.id === sectionId)?.facultyId ?? null
      : null;

    const { error } = await supabase.from("student_sentiments").insert([
      {
        period_id: periodId,
        section_id: sectionId,
        faculty_id: facultyId,
        sentiment,
        comments,
      },
    ]);

    if (error) {
      setStatus({ kind: "error", message: error.message });
      setIsSubmitting(false);
      return;
    }

    setStatus({ kind: "success", message: "Feedback saved." });
    setIsSubmitting(false);
    event.currentTarget.reset();
  };

  return (
    <form className="space-y-4" onSubmit={handleSubmit}>
      {status.kind === "success" ? (
        <div className="rounded-lg bg-green-50 p-3 text-sm text-green-800">{status.message}</div>
      ) : null}
      {status.kind === "error" ? (
        <div className="rounded-lg bg-rose-50 p-3 text-sm text-rose-800">{status.message}</div>
      ) : null}

      <div className="grid gap-4 md:grid-cols-2">
        <label className="space-y-1 text-sm font-medium">
          Period
          <select
            name="periodId"
            className="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm focus:border-ink focus:outline-none"
            defaultValue=""
          >
            <option value="">Select an open period</option>
            {periods.map((p) => (
              <option key={p.id} value={p.id}>
                {p.name}
              </option>
            ))}
          </select>
        </label>
        <label className="space-y-1 text-sm font-medium">
          Section
          <select
            name="sectionId"
            className="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm focus:border-ink focus:outline-none"
            defaultValue=""
          >
            <option value="">Select a section (optional)</option>
            {sections.map((s) => (
              <option key={s.id} value={s.id}>
                {s.label}
              </option>
            ))}
          </select>
        </label>
      </div>

      <label className="space-y-1 text-sm font-medium">
        Your sentiment
        <select
          name="sentiment"
          className="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm focus:border-ink focus:outline-none"
          defaultValue="positive"
        >
          <option value="positive">Positive</option>
          <option value="neutral">Neutral</option>
          <option value="negative">Needs improvement</option>
        </select>
      </label>

      <label className="space-y-1 text-sm font-medium">
        Notes / comments
        <textarea
          required
          name="comments"
          rows={4}
          className="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm focus:border-ink focus:outline-none"
          placeholder="Share what worked well and what can improve"
        />
      </label>

      <div className="flex gap-2">
        <button type="submit" className="btn-primary" disabled={isSubmitting}>
          {isSubmitting ? "Submitting..." : "Submit feedback"}
        </button>
        <button type="reset" className="btn-secondary" disabled={isSubmitting}>
          Reset
        </button>
      </div>
    </form>
  );
}
