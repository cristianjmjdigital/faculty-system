# Faculty Evaluation (Next.js + Supabase)

A starter for faculty evaluation and student sentiment collection. Built with Next.js 14 (App Router), Tailwind CSS, and Supabase.

## Getting started

1. Install dependencies: `npm install`
2. Copy `.env.example` to `.env.local` and set:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
3. Run dev server: `npm run dev`
4. Open http://localhost:3000

## Included

- App Router structure with sample admin and student pages
- Supabase browser/server clients (auth-helpers)
- Tailwind styling with simple cards/buttons

## Next steps

- Model rubric categories (Commitment, Knowledge of Subject, Teaching for Independent Learning, Management of Learning)
- Add database tables for faculty, courses/sections, evaluation periods, rubric items, evaluator assignments, responses, and student sentiment
- Wire forms to Supabase RPC/Row Level Security, and add authentication (admin/faculty/student roles)
- Export PDFs/CSVs for reports and add trend charts
