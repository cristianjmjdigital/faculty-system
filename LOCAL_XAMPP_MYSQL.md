# Local XAMPP + phpMyAdmin DB Setup

This project already has a MySQL schema and can be loaded locally in XAMPP.

## 1) Start local services

1. Open XAMPP Control Panel.
2. Start Apache and MySQL.
3. Open phpMyAdmin: http://localhost/phpmyadmin

## 2) Import schema and seed

1. Create database named faculty-db (utf8mb4).
2. Import these files in order:
   - supabase/mysql-schema.sql
   - supabase/mysql-seed.sql

If you only want to replace rubric categories/items with your exact Supabase export, import this after schema (or after full seed):
   - supabase/mysql-rubric-from-supabase.sql

If you import using SQL tab, run:

```sql
SOURCE supabase/mysql-schema.sql;
SOURCE supabase/mysql-seed.sql;
```

## 3) Quick verification queries

```sql
USE `faculty-db`;
SELECT COUNT(*) AS departments FROM departments;
SELECT COUNT(*) AS profiles FROM profiles;
SELECT COUNT(*) AS periods FROM evaluation_periods;
SELECT COUNT(*) AS assignments FROM evaluator_assignments;
SELECT COUNT(*) AS responses FROM evaluation_responses;
```

## 4) Offline login accounts (from mysql-seed.sql)

- admin@example.com / admin123
- faculty1@example.com / faculty123
- faculty2@example.com / faculty123
- student1@example.com / student123

## 5) Important note about the app code

The project now supports offline local auth using a MySQL-backed login API and cookie session.
Some data screens still use Supabase query helpers and should be migrated progressively for full offline data operations.

For school/demo use, the fastest migration sequence is:

1. Keep local auth via /api/auth/login.
2. Replace Supabase reads in server pages with direct MySQL queries.
3. Replace browser-side Supabase writes with API routes backed by MySQL.
4. Remove Supabase dependencies and env vars after all pages are moved.

## 6) Local DB connection values (for the Next app)

```env
MYSQL_HOST=127.0.0.1
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=
MYSQL_DATABASE=faculty-db
```

Use your XAMPP credentials if different.
