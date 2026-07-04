USE `faculty-db`;

ALTER TABLE profiles
  MODIFY role ENUM('admin','faculty','student','evaluator','program_head') NOT NULL DEFAULT 'faculty',
  ADD COLUMN IF NOT EXISTS phone VARCHAR(64) NULL AFTER department_id,
  ADD COLUMN IF NOT EXISTS address TEXT NULL AFTER phone,
  ADD COLUMN IF NOT EXISTS position_title VARCHAR(255) NULL AFTER address,
  ADD COLUMN IF NOT EXISTS must_change_password TINYINT(1) NOT NULL DEFAULT 1 AFTER position_title;

UPDATE profiles
SET must_change_password = 1
WHERE must_change_password IS NULL;