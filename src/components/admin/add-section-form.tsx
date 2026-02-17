"use client";

import { FormEvent, useMemo, useState } from "react";
import { getSupabaseBrowserClient } from "@/lib/supabase-browser";

type CourseOption = { id: string; label: string };
type FacultyOption = { id: string; name: string };

type Props = {
  courses: CourseOption[];
  faculty: FacultyOption[];
};

export default function AddSectionForm({ courses, faculty }: Props) {
  const supabase = useMemo(() => getSupabaseBrowserClient(), []);
  const [message, setMessage] = useState<{ kind: "success" | "error"; text: string } | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setMessage(null);
    setIsSubmitting(true);

    const form = new FormData(event.currentTarget);
    const courseId = (form.get("course_id") as string) || null;
    const facultyId = (form.get("faculty_id") as string) || null;
    const term = (form.get("term") as string)?.trim() || null;
    const academicYear = (form.get("academic_year") as string)?.trim() || null;
    const schedule = (form.get("schedule") as string)?.trim() || null;

    if (!courseId || !facultyId) {
      setMessage({ kind: "error", text: "Course and faculty are required." });
      setIsSubmitting(false);
      return;
    }

    const { error } = await supabase.from("sections").insert([
      {
        course_id: courseId,
        faculty_id: facultyId,
        term,
        academic_year: academicYear,
        schedule,
      },
    ]);

    if (error) {
      setMessage({ kind: "error", text: error.message });
      setIsSubmitting(false);
      return;
    }

    setMessage({ kind: "success", text: "Section added." });
    setIsSubmitting(false);
    event.currentTarget.reset();
  };

  return (
    <form className="space-y-4" onSubmit={handleSubmit}>
      {message ? (
        <div
          className={`rounded-lg px-3 py-2 text-sm ${
            message.kind === "success" ? "bg-green-900/30 text-green-100" : "bg-rose-900/30 text-rose-100"
          }`}
        >
          {message.text}
        </div>
      ) : null}

      <div className="grid gap-4 md:grid-cols-2">
        <label className="space-y-1 text-sm font-medium">
          Course
          <select name="course_id" className="input w-full" defaultValue="" required disabled={isSubmitting}>
            <option value="">Select course</option>
            {courses.map((c) => (
              <option key={c.id} value={c.id}>
                {c.label}
              </option>
            ))}
          </select>
        </label>

        <label className="space-y-1 text-sm font-medium">
          Faculty
          <select name="faculty_id" className="input w-full" defaultValue="" required disabled={isSubmitting}>
            <option value="">Select faculty</option>
            {faculty.map((f) => (
              <option key={f.id} value={f.id}>
                {f.name}
              </option>
            ))}
          </select>
        </label>
      </div>

      <div className="grid gap-4 md:grid-cols-3">
        <label className="space-y-1 text-sm font-medium">
          Term
          <input name="term" className="input w-full" placeholder="1st Sem" disabled={isSubmitting} />
        </label>

        <label className="space-y-1 text-sm font-medium">
          Academic year
          <input name="academic_year" className="input w-full" placeholder="2025-2026" disabled={isSubmitting} />
        </label>

        <label className="space-y-1 text-sm font-medium">
          Schedule
          <input name="schedule" className="input w-full" placeholder="MWF 9:00-10:00" disabled={isSubmitting} />
        </label>
      </div>

      <div className="flex gap-2">
        <button type="submit" className="btn-primary" disabled={isSubmitting}>
          {isSubmitting ? "Saving..." : "Add section"}
        </button>
        <button type="reset" className="btn-secondary" disabled={isSubmitting}>
          Reset
        </button>
      </div>
    </form>
  );
}