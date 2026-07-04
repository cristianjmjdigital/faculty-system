USE `faculty-db`;

DELETE rc
FROM rubric_categories rc
LEFT JOIN rubric_items ri ON ri.category_id = rc.id
WHERE ri.id IS NULL
  AND rc.label IN (
    'Commitment',
    'Knowledge of Subject',
    'Teaching for Independent Learning',
    'Management of Learning'
  );

SET @dept_id := (SELECT id FROM departments ORDER BY created_at ASC LIMIT 1);
SET @faculty_primary := (SELECT id FROM profiles WHERE role = 'faculty' ORDER BY created_at ASC LIMIT 1);
SET @faculty_peer := (SELECT id FROM profiles WHERE role = 'faculty' AND id <> @faculty_primary ORDER BY created_at ASC LIMIT 1);
SET @section_id := (SELECT id FROM sections ORDER BY created_at ASC LIMIT 1);

INSERT IGNORE INTO profiles (id, full_name, email, password, role, department_id, must_change_password) VALUES
  ('22222222-2222-2222-2222-222222222201', 'Alex Admin', 'admin@example.com', 'admin123', 'admin', @dept_id, 1),
  ('22222222-2222-2222-2222-222222222202', 'Frida Faculty', 'faculty1@example.com', 'faculty123', 'faculty', @dept_id, 1),
  ('22222222-2222-2222-2222-222222222203', 'Felix Faculty', 'faculty2@example.com', 'faculty123', 'faculty', @dept_id, 1),
  ('22222222-2222-2222-2222-222222222204', 'Sam Student', 'student1@example.com', 'student123', 'student', @dept_id, 1),
  ('22222222-2222-2222-2222-222222222205', 'Pat Program Head', 'programhead@example.com', 'head123', 'program_head', @dept_id, 1),
  ('22222222-2222-2222-2222-222222222206', 'Eli Evaluator', 'evaluator@example.com', 'evaluator123', 'evaluator', @dept_id, 1);

INSERT IGNORE INTO evaluation_periods (id, name, start_date, end_date, status, rubric_version) VALUES
  ('55555555-5555-5555-5555-555555555501', 'Midyear 2026', '2026-06-01', '2026-06-30', 'open', 'v1'),
  ('55555555-5555-5555-5555-555555555502', 'Year End 2026', '2026-11-01', '2026-11-30', 'closed', 'v1');

INSERT IGNORE INTO rubric_categories (id, label, description, order_index, weight, created_at) VALUES
  ('65504595-1814-42b2-8e81-eb8228661f8a', 'Commitment', 'Sensitivity, availability, records, timeliness', 1, 1.00, '2026-02-16 06:28:05'),
  ('d1804438-3d81-44ae-b303-ef00d17032a4', 'Knowledge of Subject', 'Mastery, relevance, currency', 2, 1.00, '2026-02-16 06:28:05'),
  ('6f608ddd-8036-4122-af1a-274612a2c182', 'Teaching for Independent Learning', 'Strategies, self-esteem, accountability, beyond requirements', 3, 1.00, '2026-02-16 06:28:05'),
  ('78972b31-2a5f-453f-9b5b-e1944dc60906', 'Management of Learning', 'Facilitation, experience design, structure, materials', 4, 1.00, '2026-02-16 06:28:05');

INSERT IGNORE INTO rubric_items (id, category_id, prompt, max_score, order_index, weight, created_at) VALUES
  ('f7dd1264-d2fc-4f03-85ac-4bbff79ed217', '65504595-1814-42b2-8e81-eb8228661f8a', 'Demonstrates sensitivity to students ability to attend and absorb content information.', 5, 1, 1.00, '2026-02-16 06:28:05'),
  ('51f5f385-dc49-496f-a425-7d4a79b551df', '65504595-1814-42b2-8e81-eb8228661f8a', 'Integrates sensitively learning objectives with those of the students in a collaborative process.', 5, 2, 1.00, '2026-02-16 06:28:05'),
  ('4d9ac33a-70bf-4edd-843c-e5b9df8899d6', '65504595-1814-42b2-8e81-eb8228661f8a', 'Makes self-available to students beyond official time.', 5, 3, 1.00, '2026-02-16 06:28:05'),
  ('c4704c91-5961-43db-af58-4ee6b2bae2eb', '65504595-1814-42b2-8e81-eb8228661f8a', 'Regularly comes to class on time, well-groomed and well-prepared.', 5, 4, 1.00, '2026-02-16 06:28:05'),
  ('72648a54-b958-44ee-b963-7d172be3655b', '65504595-1814-42b2-8e81-eb8228661f8a', 'Keeps accurate records of students performance and prompt submission.', 5, 5, 1.00, '2026-02-16 06:28:05'),

  ('1ffba6fb-f93d-4562-a7b8-7e8685b3c9b6', 'd1804438-3d81-44ae-b303-ef00d17032a4', 'Demonstrates mastery without relying solely on the textbook.', 5, 1, 1.00, '2026-02-16 06:28:05'),
  ('43085002-591e-4757-b286-27c886a2bad4', 'd1804438-3d81-44ae-b303-ef00d17032a4', 'Shares state-of-the-art theory and practice.', 5, 2, 1.00, '2026-02-16 06:28:05'),
  ('dfa07af5-342e-4512-903f-34c326aaf870', 'd1804438-3d81-44ae-b303-ef00d17032a4', 'Integrates subject to practical circumstances and student intents.', 5, 3, 1.00, '2026-02-16 06:28:05'),
  ('86f59b5c-1621-43a6-9c40-efbe0f3eaa35', 'd1804438-3d81-44ae-b303-ef00d17032a4', 'Explains relevance to previous lessons and daily life.', 5, 4, 1.00, '2026-02-16 06:28:05'),
  ('d64e5a67-94ad-49f8-b39c-deed75765120', 'd1804438-3d81-44ae-b303-ef00d17032a4', 'Shows up-to-date knowledge on trends/issues.', 5, 5, 1.00, '2026-02-16 06:28:05'),

  ('878e4ccb-56b7-452f-bf74-b44fcba05015', '6f608ddd-8036-4122-af1a-274612a2c182', 'Creates strategies for students to practice concepts.', 5, 1, 1.00, '2026-02-16 06:28:05'),
  ('8beb4ccb-95d6-44cb-a2f6-4dbe6d3d6d89', '6f608ddd-8036-4122-af1a-274612a2c182', 'Enhances self-esteem / gives recognition.', 5, 2, 1.00, '2026-02-16 06:28:05'),
  ('171d91a9-c9ec-475f-ad62-447bfc007491', '6f608ddd-8036-4122-af1a-274612a2c182', 'Allows students to create their own course rules/objectives.', 5, 3, 1.00, '2026-02-16 06:28:05'),
  ('b589e637-4140-4047-8dda-d5ca2b3262a6', '6f608ddd-8036-4122-af1a-274612a2c182', 'Lets students think independently and be accountable.', 5, 4, 1.00, '2026-02-16 06:28:05'),
  ('e388cff3-d0f9-4163-85cc-b1c96f90006f', '6f608ddd-8036-4122-af1a-274612a2c182', 'Encourages learning beyond requirements and applying concepts.', 5, 5, 1.00, '2026-02-16 06:28:05'),

  ('3d499c10-aabc-4ff7-8ab5-8a9f09538969', '78972b31-2a5f-453f-9b5b-e1944dc60906', 'Creates opportunities for intensive/extensive contribution (dyads/triads/groups).', 5, 1, 1.00, '2026-02-16 06:28:05'),
  ('ede1634a-01b4-4cd7-b380-8f96f602ce3e', '78972b31-2a5f-453f-9b5b-e1944dc60906', 'Assumes roles (facilitator, coach, integrator, referee).', 5, 2, 1.00, '2026-02-16 06:28:05'),
  ('95c2dbda-5487-43a9-ab6a-cda47fc907e1', '78972b31-2a5f-453f-9b5b-e1944dc60906', 'Designs conditions for healthy exchange/confrontation.', 5, 3, 1.00, '2026-02-16 06:28:05'),
  ('6b39ac0d-fa7e-4692-a26b-9b221b7affc9', '78972b31-2a5f-453f-9b5b-e1944dc60906', 'Restructures context to enhance learning objectives.', 5, 4, 1.00, '2026-02-16 06:28:05'),
  ('f354ff8c-4e5d-4150-85e5-3ffe48c5fd94', '78972b31-2a5f-453f-9b5b-e1944dc60906', 'Uses instructional materials/CAI/fieldtrips/etc.', 5, 5, 1.00, '2026-02-16 06:28:05');

SET @period_id := (SELECT id FROM evaluation_periods WHERE name = 'Midyear 2026' LIMIT 1);
SET @student_id := (SELECT id FROM profiles WHERE role = 'student' LIMIT 1);
SET @admin_id := (SELECT id FROM profiles WHERE role = 'admin' LIMIT 1);
SET @program_head_id := (SELECT id FROM profiles WHERE role = 'program_head' LIMIT 1);

INSERT IGNORE INTO evaluator_assignments (id, period_id, section_id, faculty_id, evaluator_id, role) VALUES
  ('88888888-8888-8888-8888-888888888801', @period_id, @section_id, @faculty_primary, @faculty_primary, 'self'),
  ('88888888-8888-8888-8888-888888888802', @period_id, @section_id, @faculty_primary, @faculty_peer, 'peer'),
  ('88888888-8888-8888-8888-888888888803', @period_id, @section_id, @faculty_primary, @admin_id, 'supervisor'),
  ('88888888-8888-8888-8888-888888888804', @period_id, @section_id, @faculty_primary, @student_id, 'student');

INSERT IGNORE INTO evaluations (id, assignment_id, status, overall_comment) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '88888888-8888-8888-8888-888888888801', 'submitted', 'Self evaluation completed'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '88888888-8888-8888-8888-888888888804', 'submitted', 'Student evaluation completed');

INSERT IGNORE INTO evaluation_responses (id, evaluation_id, rubric_item_id, score, comment) VALUES
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'f7dd1264-d2fc-4f03-85ac-4bbff79ed217', 4, 'Doing well on this criterion'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '51f5f385-dc49-496f-a425-7d4a79b551df', 4, 'Strong collaboration with students'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb3', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '4d9ac33a-70bf-4edd-843c-e5b9df8899d6', 5, 'Always available after class'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb4', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'c4704c91-5961-43db-af58-4ee6b2bae2eb', 4, 'Well prepared and punctual'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb5', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '72648a54-b958-44ee-b963-7d172be3655b', 4, 'Records are maintained properly'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb6', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '1ffba6fb-f93d-4562-a7b8-7e8685b3c9b6', 4, 'Good mastery overall'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb7', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '43085002-591e-4757-b286-27c886a2bad4', 4, 'Current theories are discussed'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb8', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'dfa07af5-342e-4512-903f-34c326aaf870', 4, 'Linked to practical examples'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb9', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '86f59b5c-1621-43a6-9c40-efbe0f3eaa35', 4, 'Explains relevance well'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba0', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'd64e5a67-94ad-49f8-b39c-deed75765120', 4, 'Knowledge is up to date'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba1', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '878e4ccb-56b7-452f-bf74-b44fcba05015', 5, 'Provides useful practice activities'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba2', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '8beb4ccb-95d6-44cb-a2f6-4dbe6d3d6d89', 4, 'Encouraging and supportive'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba3', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '171d91a9-c9ec-475f-ad62-447bfc007491', 4, 'Students can contribute ideas'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba4', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'b589e637-4140-4047-8dda-d5ca2b3262a6', 4, 'Promotes accountability'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba5', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'e388cff3-d0f9-4163-85cc-b1c96f90006f', 4, 'Encourages deeper learning'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba6', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '3d499c10-aabc-4ff7-8ab5-8a9f09538969', 4, 'Group work is well structured'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba7', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'ede1634a-01b4-4cd7-b380-8f96f602ce3e', 4, 'Good facilitator role'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba8', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '95c2dbda-5487-43a9-ab6a-cda47fc907e1', 4, 'Healthy discussion in class'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba9', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '6b39ac0d-fa7e-4692-a26b-9b221b7affc9', 4, 'Class context is adjusted well'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbaa', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'f354ff8c-4e5d-4150-85e5-3ffe48c5fd94', 5, 'Materials are used effectively'),

  ('cccccccc-cccc-cccc-cccc-ccccccccccc1', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'f7dd1264-d2fc-4f03-85ac-4bbff79ed217', 5, 'Very responsive and respectful'),
  ('cccccccc-cccc-cccc-cccc-ccccccccccc2', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '51f5f385-dc49-496f-a425-7d4a79b551df', 4, 'Good collaboration in class'),
  ('cccccccc-cccc-cccc-cccc-ccccccccccc3', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '4d9ac33a-70bf-4edd-843c-e5b9df8899d6', 5, 'Always available to help'),
  ('cccccccc-cccc-cccc-cccc-ccccccccccc4', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'c4704c91-5961-43db-af58-4ee6b2bae2eb', 5, 'Always on time and prepared'),
  ('cccccccc-cccc-cccc-cccc-ccccccccccc5', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '72648a54-b958-44ee-b963-7d172be3655b', 4, 'Keeps good class records'),
  ('cccccccc-cccc-cccc-cccc-ccccccccccc6', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '1ffba6fb-f93d-4562-a7b8-7e8685b3c9b6', 4, 'Knowledgeable instructor'),
  ('cccccccc-cccc-cccc-cccc-ccccccccccc7', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '43085002-591e-4757-b286-27c886a2bad4', 4, 'Shares current practices'),
  ('cccccccc-cccc-cccc-cccc-ccccccccccc8', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'dfa07af5-342e-4512-903f-34c326aaf870', 4, 'Relevant to practice'),
  ('cccccccc-cccc-cccc-cccc-ccccccccccc9', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '86f59b5c-1621-43a6-9c40-efbe0f3eaa35', 5, 'Always relates lessons'),
  ('cccccccc-cccc-cccc-cccc-ccccccccccca', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'd64e5a67-94ad-49f8-b39c-deed75765120', 4, 'Up-to-date content'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccb', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '878e4ccb-56b7-452f-bf74-b44fcba05015', 5, 'Gives practice activities'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '8beb4ccb-95d6-44cb-a2f6-4dbe6d3d6d89', 4, 'Supports student confidence'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccd', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '171d91a9-c9ec-475f-ad62-447bfc007491', 4, 'Lets students contribute'),
  ('cccccccc-cccc-cccc-cccc-ccccccccccce', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'b589e637-4140-4047-8dda-d5ca2b3262a6', 5, 'Encourages independent thinking'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccf', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'e388cff3-d0f9-4163-85cc-b1c96f90006f', 4, 'Pushes learning beyond requirements'),
  ('cccccccc-cccc-cccc-cccc-ccccccccccd0', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '3d499c10-aabc-4ff7-8ab5-8a9f09538969', 4, 'Good group work opportunities'),
  ('cccccccc-cccc-cccc-cccc-ccccccccccd1', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'ede1634a-01b4-4cd7-b380-8f96f602ce3e', 4, 'Facilitates well'),
  ('cccccccc-cccc-cccc-cccc-ccccccccccd2', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '95c2dbda-5487-43a9-ab6a-cda47fc907e1', 4, 'Healthy exchange is encouraged'),
  ('cccccccc-cccc-cccc-cccc-ccccccccccd3', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '6b39ac0d-fa7e-4692-a26b-9b221b7affc9', 4, 'Class flow is well managed'),
  ('cccccccc-cccc-cccc-cccc-ccccccccccd4', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'f354ff8c-4e5d-4150-85e5-3ffe48c5fd94', 5, 'Uses materials effectively');

INSERT IGNORE INTO student_sentiments (id, period_id, section_id, faculty_id, student_id, sentiment, comments) VALUES
  ('99999999-9999-9999-9999-999999999901', @period_id, @section_id, @faculty_primary, @student_id, 'positive', 'Great pacing and clear slides.'),
  ('99999999-9999-9999-9999-999999999902', @period_id, @section_id, @faculty_primary, @student_id, 'neutral', 'Would like more examples in class.'),
  ('99999999-9999-9999-9999-999999999903', @period_id, @section_id, @faculty_primary, @student_id, 'negative', 'Sometimes the discussion moves too quickly.');