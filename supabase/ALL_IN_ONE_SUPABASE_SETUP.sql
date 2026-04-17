-- =============================================================
-- Faculty Evaluation System - All-in-One Supabase SQL Setup
-- Date: 2026-04-16
--
-- WHAT THIS DOES
-- 0) Creates demo auth users (safe to re-run; skips existing)
-- 1) Creates schema (types, tables, constraints, indexes)
-- 2) Applies development allow-all RLS policies
-- 3) Seeds reference + sample data
-- 4) Finalizes mappings/assignments/sample evaluations
-- 5) Runs verification queries
--
-- Demo accounts created (password: Password123!)
--   admin@example.com      role: admin
--   faculty1@example.com   role: faculty
--   faculty2@example.com   role: faculty
--   student1@example.com   role: student
-- =============================================================

-- -------------------------------------------------------------
-- 0) Create demo auth users (skip if already present)
-- -------------------------------------------------------------
DO $$
DECLARE
  uid uuid;
BEGIN
  -- admin@example.com
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'admin@example.com') THEN
    uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, aud, role, email,
      encrypted_password, email_confirmed_at,
      created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, confirmation_token, recovery_token,
      email_change_token_new, email_change
    ) VALUES (
      uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'admin@example.com',
      crypt('Password123!', gen_salt('bf')),
      now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb,
      '{"full_name":"Alex Admin"}'::jsonb,
      false, '', '', '', ''
    );
    INSERT INTO auth.identities (id, provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
    VALUES (gen_random_uuid(), 'admin@example.com', uid, jsonb_build_object('sub', uid::text, 'email', 'admin@example.com'), 'email', now(), now(), now());
  END IF;

  -- faculty1@example.com
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'faculty1@example.com') THEN
    uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, aud, role, email,
      encrypted_password, email_confirmed_at,
      created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, confirmation_token, recovery_token,
      email_change_token_new, email_change
    ) VALUES (
      uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'faculty1@example.com',
      crypt('Password123!', gen_salt('bf')),
      now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb,
      '{"full_name":"Frida Faculty"}'::jsonb,
      false, '', '', '', ''
    );
    INSERT INTO auth.identities (id, provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
    VALUES (gen_random_uuid(), 'faculty1@example.com', uid, jsonb_build_object('sub', uid::text, 'email', 'faculty1@example.com'), 'email', now(), now(), now());
  END IF;

  -- faculty2@example.com
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'faculty2@example.com') THEN
    uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, aud, role, email,
      encrypted_password, email_confirmed_at,
      created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, confirmation_token, recovery_token,
      email_change_token_new, email_change
    ) VALUES (
      uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'faculty2@example.com',
      crypt('Password123!', gen_salt('bf')),
      now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb,
      '{"full_name":"Felix Faculty"}'::jsonb,
      false, '', '', '', ''
    );
    INSERT INTO auth.identities (id, provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
    VALUES (gen_random_uuid(), 'faculty2@example.com', uid, jsonb_build_object('sub', uid::text, 'email', 'faculty2@example.com'), 'email', now(), now(), now());
  END IF;

  -- student1@example.com
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'student1@example.com') THEN
    uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, aud, role, email,
      encrypted_password, email_confirmed_at,
      created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, confirmation_token, recovery_token,
      email_change_token_new, email_change
    ) VALUES (
      uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'student1@example.com',
      crypt('Password123!', gen_salt('bf')),
      now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb,
      '{"full_name":"Sam Student"}'::jsonb,
      false, '', '', '', ''
    );
    INSERT INTO auth.identities (id, provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
    VALUES (gen_random_uuid(), 'student1@example.com', uid, jsonb_build_object('sub', uid::text, 'email', 'student1@example.com'), 'email', now(), now(), now());
  END IF;
END $$;

-- -------------------------------------------------------------
-- 1) Extensions, enums, helper function
-- -------------------------------------------------------------
create extension if not exists "uuid-ossp";
create extension if not exists "pgcrypto";

create type app_role as enum ('admin', 'faculty', 'student', 'evaluator');
create type evaluation_role as enum ('self', 'peer', 'supervisor', 'student');
create type period_status as enum ('draft', 'open', 'closed');
create type evaluation_status as enum ('draft', 'submitted');
create type sentiment_scale as enum ('positive', 'neutral', 'negative');

create or replace function app_is_admin() returns boolean as $$
  select coalesce(current_setting('request.jwt.claims', true)::json ->> 'role', '') = 'admin';
$$ language sql stable;

-- -------------------------------------------------------------
-- 2) Tables
-- -------------------------------------------------------------
create table if not exists departments (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  created_at timestamptz not null default now()
);

create table if not exists profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  full_name text,
  email text unique,
  role app_role not null default 'faculty',
  department_id uuid references departments(id),
  created_at timestamptz not null default now()
);

create table if not exists courses (
  id uuid primary key default gen_random_uuid(),
  code text not null,
  title text not null,
  department_id uuid references departments(id),
  created_at timestamptz not null default now(),
  unique(code)
);

create table if not exists sections (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references courses(id) on delete cascade,
  faculty_id uuid references profiles(id),
  term text,
  academic_year text,
  schedule text,
  created_at timestamptz not null default now()
);

create table if not exists evaluation_periods (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  start_date date,
  end_date date,
  status period_status not null default 'draft',
  rubric_version text,
  created_at timestamptz not null default now()
);

create table if not exists rubric_categories (
  id uuid primary key default gen_random_uuid(),
  label text not null,
  description text,
  order_index integer not null default 0,
  weight numeric(6,2) not null default 1.0,
  created_at timestamptz not null default now()
);

create table if not exists rubric_items (
  id uuid primary key default gen_random_uuid(),
  category_id uuid not null references rubric_categories(id) on delete cascade,
  prompt text not null,
  max_score integer not null default 5,
  order_index integer not null default 0,
  weight numeric(6,2) not null default 1.0,
  created_at timestamptz not null default now()
);

create table if not exists evaluator_assignments (
  id uuid primary key default gen_random_uuid(),
  period_id uuid not null references evaluation_periods(id) on delete cascade,
  section_id uuid references sections(id),
  faculty_id uuid not null references profiles(id),
  evaluator_id uuid not null references profiles(id),
  role evaluation_role not null,
  created_at timestamptz not null default now(),
  unique(period_id, section_id, faculty_id, evaluator_id, role)
);

create table if not exists evaluations (
  id uuid primary key default gen_random_uuid(),
  assignment_id uuid not null references evaluator_assignments(id) on delete cascade,
  status evaluation_status not null default 'submitted',
  submitted_at timestamptz not null default now(),
  overall_comment text
);

create table if not exists evaluation_responses (
  id uuid primary key default gen_random_uuid(),
  evaluation_id uuid not null references evaluations(id) on delete cascade,
  rubric_item_id uuid not null references rubric_items(id),
  score integer not null check (score between 1 and 5),
  comment text,
  created_at timestamptz not null default now(),
  unique(evaluation_id, rubric_item_id)
);

create table if not exists student_sentiments (
  id uuid primary key default gen_random_uuid(),
  period_id uuid references evaluation_periods(id),
  section_id uuid references sections(id),
  faculty_id uuid references profiles(id),
  student_id uuid references profiles(id),
  sentiment sentiment_scale not null default 'positive',
  comments text,
  created_at timestamptz not null default now()
);

-- -------------------------------------------------------------
-- 3) Base indexes + idempotent unique helper indexes
-- -------------------------------------------------------------
create index if not exists idx_sections_course on sections(course_id);
create index if not exists idx_assignments_faculty on evaluator_assignments(faculty_id);
create index if not exists idx_assignments_evaluator on evaluator_assignments(evaluator_id);
create index if not exists idx_eval_responses_eval on evaluation_responses(evaluation_id);
create index if not exists idx_student_sentiment_faculty on student_sentiments(faculty_id);

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes WHERE tablename = 'evaluation_periods' AND indexname = 'uq_eval_periods_name'
  ) THEN
    CREATE UNIQUE INDEX uq_eval_periods_name ON evaluation_periods (name);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes WHERE tablename = 'sections' AND indexname = 'uq_sections_course_faculty_term_year_sched'
  ) THEN
    CREATE UNIQUE INDEX uq_sections_course_faculty_term_year_sched
      ON sections (
        course_id,
        COALESCE(faculty_id, '00000000-0000-0000-0000-000000000000'::uuid),
        COALESCE(term, ''),
        COALESCE(academic_year, ''),
        COALESCE(schedule, '')
      );
  END IF;
END $$;

-- -------------------------------------------------------------
-- 4) Development RLS policy set (allow-all)
-- -------------------------------------------------------------
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE evaluation_periods ENABLE ROW LEVEL SECURITY;
ALTER TABLE rubric_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE rubric_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE evaluator_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE evaluations ENABLE ROW LEVEL SECURITY;
ALTER TABLE evaluation_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_sentiments ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN
    SELECT schemaname, tablename, policyname
    FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename IN (
        'departments','profiles','courses','sections','evaluation_periods',
        'rubric_categories','rubric_items','evaluator_assignments',
        'evaluations','evaluation_responses','student_sentiments'
      )
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', rec.policyname, rec.schemaname, rec.tablename);
  END LOOP;
END $$;

DO $$
DECLARE
  tbl TEXT;
BEGIN
  FOR tbl IN
    SELECT unnest(ARRAY[
      'departments','profiles','courses','sections','evaluation_periods',
      'rubric_categories','rubric_items','evaluator_assignments',
      'evaluations','evaluation_responses','student_sentiments'
    ])
  LOOP
    EXECUTE format('CREATE POLICY %I ON %I FOR SELECT TO anon, authenticated USING (true);', 'allow_all_select', tbl);
    EXECUTE format('CREATE POLICY %I ON %I FOR INSERT TO anon, authenticated WITH CHECK (true);', 'allow_all_insert', tbl);
    EXECUTE format('CREATE POLICY %I ON %I FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);', 'allow_all_update', tbl);
    EXECUTE format('CREATE POLICY %I ON %I FOR DELETE TO anon, authenticated USING (true);', 'allow_all_delete', tbl);
  END LOOP;
END $$;

-- -------------------------------------------------------------
-- 5) Cleanup (repeatable seed)
-- -------------------------------------------------------------
DELETE FROM evaluation_responses WHERE evaluation_id IN (
  SELECT e.id
  FROM evaluations e
  JOIN evaluator_assignments ea ON ea.id = e.assignment_id
  JOIN evaluation_periods p ON p.id = ea.period_id AND p.name = 'Midyear 2026'
);

DELETE FROM evaluations WHERE assignment_id IN (
  SELECT ea.id
  FROM evaluator_assignments ea
  JOIN evaluation_periods p ON p.id = ea.period_id AND p.name = 'Midyear 2026'
);

DELETE FROM evaluator_assignments WHERE period_id IN (
  SELECT id FROM evaluation_periods WHERE name = 'Midyear 2026'
);

DELETE FROM student_sentiments WHERE period_id IN (
  SELECT id FROM evaluation_periods WHERE name = 'Midyear 2026'
);

DELETE FROM rubric_items WHERE category_id IN (
  SELECT id FROM rubric_categories WHERE label IN (
    'Commitment', 'Knowledge of Subject', 'Teaching for Independent Learning', 'Management of Learning'
  )
);

DELETE FROM rubric_categories WHERE label IN (
  'Commitment', 'Knowledge of Subject', 'Teaching for Independent Learning', 'Management of Learning'
);

DELETE FROM evaluation_periods WHERE name = 'Midyear 2026';
DELETE FROM sections WHERE schedule IN ('MWF 9:00-10:00', 'TTh 1:00-2:30');
DELETE FROM courses WHERE code IN ('CS101', 'CS201', 'MATH201');
DELETE FROM profiles WHERE email IN (
  'admin@example.com', 'faculty1@example.com', 'faculty2@example.com', 'student1@example.com'
);
DELETE FROM departments WHERE name IN ('Computer Science', 'Mathematics', 'Physics');

-- -------------------------------------------------------------
-- 6) Seed reference and sample data
-- -------------------------------------------------------------
INSERT INTO departments (name)
VALUES ('Computer Science'), ('Mathematics'), ('Physics');

WITH u AS (
  SELECT id, email FROM auth.users WHERE email IN (
    'admin@example.com', 'faculty1@example.com', 'faculty2@example.com', 'student1@example.com'
  )
)
INSERT INTO profiles (id, full_name, email, role, department_id)
SELECT
  u.id,
  CASE u.email
    WHEN 'admin@example.com' THEN 'Alex Admin'
    WHEN 'faculty1@example.com' THEN 'Frida Faculty'
    WHEN 'faculty2@example.com' THEN 'Felix Faculty'
    WHEN 'student1@example.com' THEN 'Sam Student'
  END AS full_name,
  u.email,
  (
    CASE u.email
      WHEN 'admin@example.com' THEN 'admin'
      WHEN 'student1@example.com' THEN 'student'
      ELSE 'faculty'
    END
  )::app_role AS role,
  (SELECT id FROM departments WHERE name = 'Computer Science')
FROM u;

INSERT INTO courses (code, title, department_id)
VALUES
  ('CS101', 'Intro to Computing', (SELECT id FROM departments WHERE name = 'Computer Science')),
  ('CS201', 'Data Structures', (SELECT id FROM departments WHERE name = 'Computer Science')),
  ('MATH201', 'Calculus II', (SELECT id FROM departments WHERE name = 'Mathematics'));

WITH f1 AS (SELECT id FROM profiles WHERE email = 'faculty1@example.com'),
     f2 AS (SELECT id FROM profiles WHERE email = 'faculty2@example.com')
INSERT INTO sections (course_id, faculty_id, term, academic_year, schedule)
VALUES
  ((SELECT id FROM courses WHERE code='CS101'), (SELECT id FROM f1), '1st Sem', '2025-2026', 'MWF 9:00-10:00'),
  ((SELECT id FROM courses WHERE code='CS201'), (SELECT id FROM f2), '1st Sem', '2025-2026', 'TTh 1:00-2:30');

INSERT INTO evaluation_periods (name, start_date, end_date, status, rubric_version)
VALUES ('Midyear 2026', '2026-06-01', '2026-06-30', 'open', 'v1');

INSERT INTO rubric_categories (label, description, order_index, weight)
VALUES
  ('Commitment', 'Sensitivity, availability, records, timeliness', 1, 1.0),
  ('Knowledge of Subject', 'Mastery, relevance, currency', 2, 1.0),
  ('Teaching for Independent Learning', 'Strategies, self-esteem, accountability, beyond requirements', 3, 1.0),
  ('Management of Learning', 'Facilitation, experience design, structure, materials', 4, 1.0);

WITH cat AS (
  SELECT id, label FROM rubric_categories WHERE label IN (
    'Commitment',
    'Knowledge of Subject',
    'Teaching for Independent Learning',
    'Management of Learning'
  )
)
INSERT INTO rubric_items (category_id, prompt, order_index)
VALUES
  ((SELECT id FROM cat WHERE label = 'Commitment'), 'Demonstrates sensitivity to students ability to attend and absorb content information.', 1),
  ((SELECT id FROM cat WHERE label = 'Commitment'), 'Integrates sensitively learning objectives with those of the students in a collaborative process.', 2),
  ((SELECT id FROM cat WHERE label = 'Commitment'), 'Makes self-available to students beyond official time.', 3),
  ((SELECT id FROM cat WHERE label = 'Commitment'), 'Regularly comes to class on time, well-groomed and well-prepared to complete assigned responsibilities.', 4),
  ((SELECT id FROM cat WHERE label = 'Commitment'), 'Keeps accurate records of students performance and prompt submission of the same.', 5),

  ((SELECT id FROM cat WHERE label = 'Knowledge of Subject'), 'Demonstrates mastery of the subject matter (explain the subject matter without relying solely on the prescribed textbook).', 1),
  ((SELECT id FROM cat WHERE label = 'Knowledge of Subject'), 'Draws and share information on the state of the art of theory and practice in his/her discipline.', 2),
  ((SELECT id FROM cat WHERE label = 'Knowledge of Subject'), 'Integrates subject to practical circumstances and learning intents/purposes of the students.', 3),
  ((SELECT id FROM cat WHERE label = 'Knowledge of Subject'), 'Explains the relevance of present topics to the previous lessons, and relates the subject matter to relevant correct issues and/or daily life activities.', 4),
  ((SELECT id FROM cat WHERE label = 'Knowledge of Subject'), 'Demonstrates up-to-date knowledge and/or awareness on current trends and issues of the subject.', 5),

  ((SELECT id FROM cat WHERE label = 'Teaching for Independent Learning'), 'Creates teaching strategies that allow students to practice using concepts they need to understand.', 1),
  ((SELECT id FROM cat WHERE label = 'Teaching for Independent Learning'), 'Enhances student self-esteem and/or gives due recognition to students performance/potentials.', 2),
  ((SELECT id FROM cat WHERE label = 'Teaching for Independent Learning'), 'Allows students to create their own course with objectives and realistically defined student-professor rules and make them accountable for their performance.', 3),
  ((SELECT id FROM cat WHERE label = 'Teaching for Independent Learning'), 'Allows students to think independently and make their own decisions and holding them accountable for their performance based largely on their success in executing decisions.', 4),
  ((SELECT id FROM cat WHERE label = 'Teaching for Independent Learning'), 'Encourages students to learn beyond what is required and help/guide the students how to apply the concepts learned.', 5),

  ((SELECT id FROM cat WHERE label = 'Management of Learning'), 'Creates opportunities for intensive and/or extensive contribution of students in the class activities (e.g. breaks class into dyads, triads or buzz/task groups).', 1),
  ((SELECT id FROM cat WHERE label = 'Management of Learning'), 'Assumes roles as facilitator, resource person, coach, inquisitor, integrator, referee in drawing students to contribute to knowledge and understanding of the concepts at hand.', 2),
  ((SELECT id FROM cat WHERE label = 'Management of Learning'), 'Designs and implements learning conditions and experience that promote healthy exchange and/or confrontations.', 3),
  ((SELECT id FROM cat WHERE label = 'Management of Learning'), 'Structures/re-structures learning and teaching-learning context to enhance attainment of collective learning objectives.', 4),
  ((SELECT id FROM cat WHERE label = 'Management of Learning'), 'Use of instructional materials (audio/video materials, fieldtrips, film showing, computer aided instruction and etc.) to reinforce learning processes.', 5);

WITH period AS (SELECT id FROM evaluation_periods WHERE name = 'Midyear 2026' LIMIT 1),
     sec1 AS (SELECT id, faculty_id FROM sections WHERE faculty_id IS NOT NULL ORDER BY created_at ASC LIMIT 1),
     sec2 AS (SELECT id, faculty_id FROM sections WHERE faculty_id IS NOT NULL ORDER BY created_at DESC LIMIT 1),
     peer AS (SELECT id FROM profiles WHERE email = 'faculty2@example.com' LIMIT 1),
     supervisor AS (SELECT id FROM profiles WHERE email = 'admin@example.com' LIMIT 1)
INSERT INTO evaluator_assignments (period_id, section_id, faculty_id, evaluator_id, role)
SELECT * FROM (
  VALUES
    ((SELECT id FROM period), (SELECT id FROM sec1), (SELECT faculty_id FROM sec1), (SELECT faculty_id FROM sec1), 'self'::evaluation_role),
    ((SELECT id FROM period), (SELECT id FROM sec1), (SELECT faculty_id FROM sec1), (SELECT id FROM peer), 'peer'::evaluation_role),
    ((SELECT id FROM period), (SELECT id FROM sec1), (SELECT faculty_id FROM sec1), (SELECT id FROM supervisor), 'supervisor'::evaluation_role),
    ((SELECT id FROM period), (SELECT id FROM sec2), (SELECT faculty_id FROM sec2), (SELECT faculty_id FROM sec2), 'self'::evaluation_role),
    ((SELECT id FROM period), (SELECT id FROM sec2), (SELECT faculty_id FROM sec2), (SELECT id FROM supervisor), 'supervisor'::evaluation_role)
) AS v(period_id, section_id, faculty_id, evaluator_id, role)
WHERE v.period_id IS NOT NULL
  AND v.section_id IS NOT NULL
  AND v.faculty_id IS NOT NULL
  AND v.evaluator_id IS NOT NULL
ON CONFLICT (period_id, section_id, faculty_id, evaluator_id, role) DO NOTHING;

WITH period AS (SELECT id FROM evaluation_periods WHERE name = 'Midyear 2026' LIMIT 1),
     sec1 AS (SELECT id, faculty_id FROM sections WHERE faculty_id IS NOT NULL ORDER BY created_at ASC LIMIT 1),
     student AS (SELECT id FROM profiles WHERE email = 'student1@example.com' LIMIT 1)
INSERT INTO student_sentiments (period_id, section_id, faculty_id, student_id, sentiment, comments)
SELECT * FROM (
  VALUES
    ((SELECT id FROM period), (SELECT id FROM sec1), (SELECT faculty_id FROM sec1), (SELECT id FROM student), 'positive'::sentiment_scale, 'Great pacing and clear slides.'),
    ((SELECT id FROM period), (SELECT id FROM sec1), (SELECT faculty_id FROM sec1), (SELECT id FROM student), 'neutral'::sentiment_scale, 'Would like more examples in class.')
) AS v(period_id, section_id, faculty_id, student_id, sentiment, comments)
WHERE v.period_id IS NOT NULL
  AND v.section_id IS NOT NULL
  AND v.faculty_id IS NOT NULL
  AND v.student_id IS NOT NULL;

WITH a AS (
  SELECT ea.id FROM evaluator_assignments ea
  JOIN evaluation_periods p ON p.id = ea.period_id AND p.name = 'Midyear 2026'
  WHERE ea.role = 'self'
  LIMIT 1
)
INSERT INTO evaluations (assignment_id, status, overall_comment)
SELECT a.id, 'draft', 'Ready for scoring'
FROM a;

WITH a AS (
  SELECT ea.id FROM evaluator_assignments ea
  JOIN evaluation_periods p ON p.id = ea.period_id AND p.name = 'Midyear 2026'
  WHERE ea.role = 'self'
  LIMIT 1
), e AS (
  SELECT id FROM evaluations WHERE assignment_id = (SELECT id FROM a) LIMIT 1
), item AS (
  SELECT id FROM rubric_items ORDER BY order_index ASC LIMIT 1
)
INSERT INTO evaluation_responses (evaluation_id, rubric_item_id, score, comment)
SELECT
  (SELECT id FROM e),
  (SELECT id FROM item),
  4,
  'Doing well on this criterion'
FROM e;

-- -------------------------------------------------------------
-- 7) Finalize mappings (idempotent refresh for period data)
-- -------------------------------------------------------------
DO $$
DECLARE
  f1 uuid;
  f2 uuid;
  student uuid;
  admin_user uuid;
  v_period_id uuid;
  sec1 uuid;
  sec2 uuid;
  v_assignment_id uuid;
BEGIN
  SELECT id INTO f1 FROM profiles WHERE email = 'faculty1@example.com' LIMIT 1;
  SELECT id INTO f2 FROM profiles WHERE email = 'faculty2@example.com' LIMIT 1;
  SELECT id INTO student FROM profiles WHERE email = 'student1@example.com' LIMIT 1;
  SELECT id INTO admin_user FROM profiles WHERE email = 'admin@example.com' LIMIT 1;
  SELECT id INTO v_period_id FROM evaluation_periods WHERE name = 'Midyear 2026' LIMIT 1;

  UPDATE sections SET faculty_id = f1 WHERE course_id = (SELECT id FROM courses WHERE code = 'CS101' LIMIT 1);
  UPDATE sections SET faculty_id = f2 WHERE course_id = (SELECT id FROM courses WHERE code = 'CS201' LIMIT 1);

  SELECT id INTO sec1 FROM sections WHERE course_id = (SELECT id FROM courses WHERE code = 'CS101' LIMIT 1) LIMIT 1;
  SELECT id INTO sec2 FROM sections WHERE course_id = (SELECT id FROM courses WHERE code = 'CS201' LIMIT 1) LIMIT 1;

  DELETE FROM evaluator_assignments ea WHERE ea.period_id = v_period_id;

  IF v_period_id IS NOT NULL THEN
    IF sec1 IS NOT NULL AND f1 IS NOT NULL THEN
      INSERT INTO evaluator_assignments (period_id, section_id, faculty_id, evaluator_id, role)
      VALUES
        (v_period_id, sec1, f1, f1, 'self'::evaluation_role),
        (v_period_id, sec1, f1, f2, 'peer'::evaluation_role),
        (v_period_id, sec1, f1, admin_user, 'supervisor'::evaluation_role)
      ON CONFLICT (period_id, section_id, faculty_id, evaluator_id, role) DO NOTHING;
    END IF;

    IF sec2 IS NOT NULL AND f2 IS NOT NULL THEN
      INSERT INTO evaluator_assignments (period_id, section_id, faculty_id, evaluator_id, role)
      VALUES
        (v_period_id, sec2, f2, f2, 'self'::evaluation_role),
        (v_period_id, sec2, f2, admin_user, 'supervisor'::evaluation_role)
      ON CONFLICT (period_id, section_id, faculty_id, evaluator_id, role) DO NOTHING;
    END IF;
  END IF;

  DELETE FROM student_sentiments ss WHERE ss.period_id = v_period_id;
  IF v_period_id IS NOT NULL AND sec1 IS NOT NULL AND f1 IS NOT NULL AND student IS NOT NULL THEN
    INSERT INTO student_sentiments (period_id, section_id, faculty_id, student_id, sentiment, comments)
    VALUES
      (v_period_id, sec1, f1, student, 'positive'::sentiment_scale, 'Great pacing and clear slides.'),
      (v_period_id, sec1, f1, student, 'neutral'::sentiment_scale, 'Would like more examples in class.');
  END IF;

  DELETE FROM evaluation_responses WHERE evaluation_id IN (
    SELECT e.id FROM evaluations e
    JOIN evaluator_assignments ea ON ea.id = e.assignment_id
    WHERE ea.period_id = v_period_id
  );

  DELETE FROM evaluations USING evaluator_assignments ea
  WHERE evaluations.assignment_id = ea.id AND ea.period_id = v_period_id;

  IF v_period_id IS NOT NULL THEN
    SELECT id INTO v_assignment_id FROM evaluator_assignments
    WHERE period_id = v_period_id AND role = 'self'::evaluation_role
    ORDER BY created_at ASC LIMIT 1;

    IF v_assignment_id IS NOT NULL THEN
      INSERT INTO evaluations (assignment_id, status, overall_comment)
      VALUES (v_assignment_id, 'draft', 'Ready for scoring');

      INSERT INTO evaluation_responses (evaluation_id, rubric_item_id, score, comment)
      SELECT e.id, ri.id, 4, 'Doing well on this criterion'
      FROM evaluations e
      CROSS JOIN LATERAL (
        SELECT id FROM rubric_items ORDER BY order_index ASC LIMIT 1
      ) ri
      WHERE e.assignment_id = v_assignment_id
      LIMIT 1;
    END IF;
  END IF;
END $$;

-- -------------------------------------------------------------
-- 8) Verification queries
-- -------------------------------------------------------------
SELECT * FROM departments ORDER BY name;
SELECT id, full_name, email, role, department_id FROM profiles ORDER BY role, email;
SELECT code, title, department_id FROM courses ORDER BY code;
SELECT id, course_id, faculty_id, term, academic_year, schedule FROM sections ORDER BY created_at;
SELECT name, start_date, end_date, status, rubric_version FROM evaluation_periods ORDER BY start_date;
SELECT label, description, order_index, weight FROM rubric_categories ORDER BY order_index;
SELECT category_id, prompt, order_index FROM rubric_items ORDER BY category_id, order_index;
SELECT period_id, section_id, faculty_id, evaluator_id, role FROM evaluator_assignments ORDER BY created_at;
SELECT period_id, section_id, faculty_id, student_id, sentiment, comments FROM student_sentiments ORDER BY created_at;
SELECT assignment_id, status, overall_comment FROM evaluations ORDER BY submitted_at;
SELECT evaluation_id, rubric_item_id, score, comment FROM evaluation_responses ORDER BY created_at;
