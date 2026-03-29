-- MySQL schema derived from supabase/schema.sql
-- Target DB: faculty-db @ localhost (adjust DB/credentials as needed)
-- Note: MySQL has no RLS; enforce access in application code.

-- Choose database (create if needed)
CREATE DATABASE IF NOT EXISTS `faculty-db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `faculty-db`;

-- Drop tables in dependency order if rerunning
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS evaluation_responses;
DROP TABLE IF EXISTS evaluations;
DROP TABLE IF EXISTS evaluator_assignments;
DROP TABLE IF EXISTS rubric_items;
DROP TABLE IF EXISTS rubric_categories;
DROP TABLE IF EXISTS student_sentiments;
DROP TABLE IF EXISTS sections;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS evaluation_periods;
DROP TABLE IF EXISTS profiles;
DROP TABLE IF EXISTS departments;
SET FOREIGN_KEY_CHECKS = 1;

-- Enum equivalents
-- Using ENUM to mirror Postgres enums

CREATE TABLE departments (
  id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE profiles (
  id CHAR(36) PRIMARY KEY,
  full_name VARCHAR(255),
  email VARCHAR(255) UNIQUE,
  role ENUM('admin','faculty','student','evaluator') NOT NULL DEFAULT 'faculty',
  department_id CHAR(36),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_profiles_department FOREIGN KEY (department_id) REFERENCES departments(id)
) ENGINE=InnoDB;

CREATE TABLE courses (
  id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  code VARCHAR(64) NOT NULL,
  title VARCHAR(255) NOT NULL,
  department_id CHAR(36),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_courses_code (code),
  CONSTRAINT fk_courses_department FOREIGN KEY (department_id) REFERENCES departments(id)
) ENGINE=InnoDB;

CREATE TABLE sections (
  id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  course_id CHAR(36) NOT NULL,
  faculty_id CHAR(36),
  term VARCHAR(64),
  academic_year VARCHAR(32),
  schedule VARCHAR(128),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_sections_course FOREIGN KEY (course_id) REFERENCES courses(id),
  CONSTRAINT fk_sections_faculty FOREIGN KEY (faculty_id) REFERENCES profiles(id)
) ENGINE=InnoDB;

CREATE TABLE evaluation_periods (
  id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  name VARCHAR(255) NOT NULL,
  start_date DATE,
  end_date DATE,
  status ENUM('draft','open','closed') NOT NULL DEFAULT 'draft',
  rubric_version VARCHAR(64),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE rubric_categories (
  id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  label VARCHAR(255) NOT NULL,
  description TEXT,
  order_index INT NOT NULL DEFAULT 0,
  weight DECIMAL(6,2) NOT NULL DEFAULT 1.00,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE rubric_items (
  id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  category_id CHAR(36) NOT NULL,
  prompt TEXT NOT NULL,
  max_score INT NOT NULL DEFAULT 5,
  order_index INT NOT NULL DEFAULT 0,
  weight DECIMAL(6,2) NOT NULL DEFAULT 1.00,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_rubric_items_category FOREIGN KEY (category_id) REFERENCES rubric_categories(id)
) ENGINE=InnoDB;

CREATE TABLE evaluator_assignments (
  id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  period_id CHAR(36) NOT NULL,
  section_id CHAR(36),
  faculty_id CHAR(36) NOT NULL,
  evaluator_id CHAR(36) NOT NULL,
  role ENUM('self','peer','supervisor','student') NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_assignments (period_id, section_id, faculty_id, evaluator_id, role),
  CONSTRAINT fk_assignments_period FOREIGN KEY (period_id) REFERENCES evaluation_periods(id),
  CONSTRAINT fk_assignments_section FOREIGN KEY (section_id) REFERENCES sections(id),
  CONSTRAINT fk_assignments_faculty FOREIGN KEY (faculty_id) REFERENCES profiles(id),
  CONSTRAINT fk_assignments_evaluator FOREIGN KEY (evaluator_id) REFERENCES profiles(id)
) ENGINE=InnoDB;

CREATE TABLE evaluations (
  id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  assignment_id CHAR(36) NOT NULL,
  status ENUM('draft','submitted') NOT NULL DEFAULT 'submitted',
  submitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  overall_comment TEXT,
  CONSTRAINT fk_evaluations_assignment FOREIGN KEY (assignment_id) REFERENCES evaluator_assignments(id)
) ENGINE=InnoDB;

CREATE TABLE evaluation_responses (
  id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  evaluation_id CHAR(36) NOT NULL,
  rubric_item_id CHAR(36) NOT NULL,
  score INT NOT NULL,
  comment TEXT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_eval_responses (evaluation_id, rubric_item_id),
  CONSTRAINT ck_score_range CHECK (score BETWEEN 1 AND 5),
  CONSTRAINT fk_responses_evaluation FOREIGN KEY (evaluation_id) REFERENCES evaluations(id),
  CONSTRAINT fk_responses_rubric_item FOREIGN KEY (rubric_item_id) REFERENCES rubric_items(id)
) ENGINE=InnoDB;

CREATE TABLE student_sentiments (
  id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  period_id CHAR(36),
  section_id CHAR(36),
  faculty_id CHAR(36),
  student_id CHAR(36),
  sentiment ENUM('positive','neutral','negative') NOT NULL DEFAULT 'positive',
  comments TEXT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_sentiments_period FOREIGN KEY (period_id) REFERENCES evaluation_periods(id),
  CONSTRAINT fk_sentiments_section FOREIGN KEY (section_id) REFERENCES sections(id),
  CONSTRAINT fk_sentiments_faculty FOREIGN KEY (faculty_id) REFERENCES profiles(id),
  CONSTRAINT fk_sentiments_student FOREIGN KEY (student_id) REFERENCES profiles(id)
) ENGINE=InnoDB;

-- Indexes for performance (mirrors the Postgres ones)
CREATE INDEX idx_sections_course ON sections(course_id);
CREATE INDEX idx_assignments_faculty ON evaluator_assignments(faculty_id);
CREATE INDEX idx_assignments_evaluator ON evaluator_assignments(evaluator_id);
CREATE INDEX idx_eval_responses_eval ON evaluation_responses(evaluation_id);
CREATE INDEX idx_student_sentiment_faculty ON student_sentiments(faculty_id);

-- Seed starter rubric categories (optional)
INSERT INTO rubric_categories (id, label, description, order_index, weight)
VALUES
  (UUID(), 'Commitment', 'Sensitivity, availability, records, timeliness', 1, 1.00),
  (UUID(), 'Knowledge of Subject', 'Mastery, relevance, currency', 2, 1.00),
  (UUID(), 'Teaching for Independent Learning', 'Strategies, self-esteem, accountability, beyond requirements', 3, 1.00),
  (UUID(), 'Management of Learning', 'Facilitation, experience design, structure, materials', 4, 1.00)
ON DUPLICATE KEY UPDATE label = VALUES(label);
