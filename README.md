# Faculty Evaluation (Next.js + MySQL Offline)

A comprehensive system for faculty evaluation and student sentiment collection. Built with Next.js 14 (App Router), Tailwind CSS, and MySQL.

## 📚 Documentation

### Quick Start
1. Install dependencies: `npm install`
2. Copy `.env.example` to `.env.local` and set:
   - `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_DATABASE`
3. Run dev server: `npm run dev`
4. Open `http://localhost:3000` (or the next available port shown in terminal, e.g. `3001`)

Offline login defaults after importing `supabase/mysql-seed.sql`:
- `admin@example.com` / `admin123`
- `faculty1@example.com` / `faculty123`
- `faculty2@example.com` / `faculty123`
- `student1@example.com` / `student123`

### System Documentation
- **[SYSTEM_FLOWS.md](./SYSTEM_FLOWS.md)** - Complete system architecture, data models, user flows, API endpoints, and security policies
- **[FLOW_DIAGRAMS.md](./FLOW_DIAGRAMS.md)** - Visual diagrams (Mermaid) for system architecture, user workflows, database relationships, and data flows
- **[LOCAL_XAMPP_MYSQL.md](./LOCAL_XAMPP_MYSQL.md)** - Local XAMPP/phpMyAdmin setup using the MySQL schema and seed

### Import Faculty/Course List (HTML)

If you exported class loads as HTML (like `FACULTY.html` and `SEMESTERS.html`), run:

`powershell -ExecutionPolicy Bypass -File .\scripts\import-faculty-html.ps1`

This maps data into:
- `departments`
- `profiles` (`role='faculty'`)
- `courses`
- `sections`

The importer also adds these `sections` columns when missing:
- `section_code`
- `program_code`
- `student_count`

To import as second semester:

`powershell -ExecutionPolicy Bypass -File .\scripts\import-faculty-html.ps1 -SemesterIndex 1`

## Features

✅ Multi-role authentication (Admin, Faculty, Student, Evaluator)  
✅ Rubric-based evaluation system (4 categories: Commitment, Knowledge, Independent Learning, Learning Management)  
✅ Evaluation assignment and tracking  
✅ Student sentiment collection  
✅ Database with Row-Level Security (RLS) policies  
✅ Admin dashboard for management  
✅ Offline local auth + MySQL integration  
✅ Responsive UI with Tailwind CSS  

## Architecture

### Stack
- **Frontend**: Next.js 14, React 18, TypeScript, Tailwind CSS
- **Backend**: Next.js API Routes + local MySQL access
- **Auth**: Local cookie session auth
- **Database**: MySQL (XAMPP/phpMyAdmin friendly)

### Key Components
- Home page with highlights and quick start steps
- Authentication system with role-based access
- Admin console for user, period, rubric, and section management
- Faculty dashboard for evaluations and feedback
- Student sentiment form
- Component library for reusable UI

## Included

- App Router structure with authenticated pages (admin, faculty, student)
- Local browser/server DB clients backed by MySQL
- Database schema + seed SQL (see `supabase/`)
- Offline authentication APIs (`/api/auth/*`)
- Tailwind styling with card and button components

## Database Schema

See the complete MySQL schema in `supabase/mysql-schema.sql`. Key tables:
- `profiles` - User accounts and roles
- `departments`, `courses`, `sections` - Academic structure
- `evaluation_periods` - Evaluation windows
- `rubric_categories`, `rubric_items` - Assessment framework
- `evaluator_assignments` - Evaluation assignments
- `evaluations`, `evaluation_responses` - Submission records
- `student_sentiments` - Qualitative feedback

## Next Steps

- [ ] Build evaluation form UI for evaluators
- [ ] Implement evaluation submission endpoints
- [ ] Create admin reporting dashboard
- [ ] Add PDF/CSV export functionality
- [ ] Build faculty dashboard with aggregated feedback
- [ ] Implement trend analysis and charts
- [ ] Add email notifications for evaluators
- [ ] Add full MySQL data migration for remaining advanced reports

## User Roles

| Role | Permissions |
|------|-----------|
| **Admin** | Create users, setup rubrics, manage periods, create assignments, view all reports |
| **Faculty** | Complete self-evaluation, view peer feedback, submit student sentiment, download personal report |
| **Evaluator** | Complete assigned evaluations (peer/supervisor), submit scores and comments |
| **Student** | Submit sentiment feedback about faculty |

For detailed information about system flows, user journeys, and architecture, see [SYSTEM_FLOWS.md](./SYSTEM_FLOWS.md) and [FLOW_DIAGRAMS.md](./FLOW_DIAGRAMS.md).
