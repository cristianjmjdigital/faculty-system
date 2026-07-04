-- Converted from Supabase export rows to MySQL/phpMyAdmin format
-- Import after supabase/mysql-schema.sql (and after categories dependencies if partial import)
USE `faculty-db`;
SET FOREIGN_KEY_CHECKS = 0;

-- Optional cleanup for re-importing only rubric content
DELETE FROM rubric_items
WHERE category_id IN (
  '65504595-1814-42b2-8e81-eb8228661f8a',
  'd1804438-3d81-44ae-b303-ef00d17032a4',
  '6f608ddd-8036-4122-af1a-274612a2c182',
  '78972b31-2a5f-453f-9b5b-e1944dc60906'
);

DELETE FROM rubric_categories
WHERE id IN (
  '65504595-1814-42b2-8e81-eb8228661f8a',
  'd1804438-3d81-44ae-b303-ef00d17032a4',
  '6f608ddd-8036-4122-af1a-274612a2c182',
  '78972b31-2a5f-453f-9b5b-e1944dc60906'
);

INSERT INTO rubric_categories (id, label, description, order_index, weight, created_at) VALUES
  ('65504595-1814-42b2-8e81-eb8228661f8a', 'Commitment', 'Sensitivity, availability, records, timeliness', 1, 1.00, '2026-02-16 06:28:05'),
  ('d1804438-3d81-44ae-b303-ef00d17032a4', 'Knowledge of Subject', 'Mastery, relevance, currency', 2, 1.00, '2026-02-16 06:28:05'),
  ('6f608ddd-8036-4122-af1a-274612a2c182', 'Teaching for Independent Learning', 'Strategies, self-esteem, accountability, beyond requirements', 3, 1.00, '2026-02-16 06:28:05'),
  ('78972b31-2a5f-453f-9b5b-e1944dc60906', 'Management of Learning', 'Facilitation, experience design, structure, materials', 4, 1.00, '2026-02-16 06:28:05');

INSERT INTO rubric_items (id, category_id, prompt, max_score, order_index, weight, created_at) VALUES
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

SET FOREIGN_KEY_CHECKS = 1;
