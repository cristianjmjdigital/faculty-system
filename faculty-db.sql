-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 04, 2026 at 08:57 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `faculty-db`
--

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `code` varchar(64) NOT NULL,
  `title` varchar(255) NOT NULL,
  `department_id` char(36) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `code`, `title`, `department_id`, `created_at`) VALUES
('ce331056-7773-11f1-88cc-cf926f75fe99', 'Math 2', 'Teaching Math in the Intermediate Grades', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce334777-7773-11f1-88cc-cf926f75fe99', 'Research', 'Methods of Research', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce336c61-7773-11f1-88cc-cf926f75fe99', 'FS 3', 'Teaching Internship', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce33901d-7773-11f1-88cc-cf926f75fe99', 'AB 15', 'Introduction to Project Feasibility/Project Benefit Monitoring Evaluation', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce33b33a-7773-11f1-88cc-cf926f75fe99', 'AB 16', 'Business Law and Taxation', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce33d802-7773-11f1-88cc-cf926f75fe99', 'PCIT 02', 'Fundamentals of Database System', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce33fb11-7773-11f1-88cc-cf926f75fe99', 'PFIT 04', 'Software Engineering', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce341d4e-7773-11f1-88cc-cf926f75fe99', 'CCIT 03', 'Computer Programming 2', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce34413c-7773-11f1-88cc-cf926f75fe99', 'PCIT 13', 'Capstone Project and Research 1', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce3465e4-7773-11f1-88cc-cf926f75fe99', 'SEMINAR', 'Seminars', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce34887c-7773-11f1-88cc-cf926f75fe99', 'GEC 8', 'Ethics', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce34abdc-7773-11f1-88cc-cf926f75fe99', 'AB 14a', 'Introduction to Personnel Management', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce34cdb6-7773-11f1-88cc-cf926f75fe99', 'AB 3a', 'Concepts and Dynamics of Management', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce34ee5c-7773-11f1-88cc-cf926f75fe99', 'PE 2', 'PATHFIT 2 ??? Exercise-based Fitness Activities', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce351894-7773-11f1-88cc-cf926f75fe99', 'Prof. Ed. 3', 'Facilitating Learner- Centered Teaching', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce353fd4-7773-11f1-88cc-cf926f75fe99', 'Crop Sci. 1', 'Principles of Crop Production', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce35638b-7773-11f1-88cc-cf926f75fe99', 'OJT', 'On-the-Job-Training', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce358a4f-7773-11f1-88cc-cf926f75fe99', 'PSIT 02', 'Data Mining Methodology', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce35ad33-7773-11f1-88cc-cf926f75fe99', 'PCIT 12', 'Information Assurance & Security 2', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce35cf00-7773-11f1-88cc-cf926f75fe99', 'CCIT 05', 'Information Management', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce35efb7-7773-11f1-88cc-cf926f75fe99', 'GEC 3', 'The Contemporary World', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce361267-7773-11f1-88cc-cf926f75fe99', 'TLE 2', 'Edukasyong Pantahanan at Pangkabuhayan with Entrepreneurship', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce363acc-7773-11f1-88cc-cf926f75fe99', 'AB 17', 'Agribusiness Research Methods', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce365afe-7773-11f1-88cc-cf926f75fe99', 'Prof. Ed. 8', 'Assessment in Learning 2', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce367e9d-7773-11f1-88cc-cf926f75fe99', 'Crop. Prot. 2', 'Approaches and Practices in Pest Management', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce3697da-7773-11f1-88cc-cf926f75fe99', 'Soil Sci. 2', 'Soil Fertility Conservation and Management', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce36bba0-7773-11f1-88cc-cf926f75fe99', 'An. Sci. 1', 'Introduction to Animal Science', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce36d8f6-7773-11f1-88cc-cf926f75fe99', 'AB 2a', 'Principles of Accounting', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce36f9ab-7773-11f1-88cc-cf926f75fe99', 'PFIT 02', 'Human Computer Interaction 2', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce3719b7-7773-11f1-88cc-cf926f75fe99', 'PCIT 10', 'Quantitative Methods with Modelling and Simulation', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce373aa1-7773-11f1-88cc-cf926f75fe99', 'PFIT 06', 'Business Process Management', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce37650c-7773-11f1-88cc-cf926f75fe99', 'PCIT 01', 'Discrete Mathematics', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce379092-7773-11f1-88cc-cf926f75fe99', 'PSIT 05', 'Regression Analysis', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce37b194-7773-11f1-88cc-cf926f75fe99', 'PCIT 07', 'Information Assurance & Security 1', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce37d8c2-7773-11f1-88cc-cf926f75fe99', 'GEM', 'Life and Works of Rizal', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce380076-7773-11f1-88cc-cf926f75fe99', 'GEC 9', 'Life and Works of Rizal', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce38199f-7773-11f1-88cc-cf926f75fe99', 'GEC 2', 'Readings in the Philippine History', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce383259-7773-11f1-88cc-cf926f75fe99', 'AB 1', 'Introduction to Agribusiness Management', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce384e98-7773-11f1-88cc-cf926f75fe99', 'AB 18', 'Introduction to International Marketing', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce387935-7773-11f1-88cc-cf926f75fe99', 'GEC 7', 'Science, Technology and Society', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce389a84-7773-11f1-88cc-cf926f75fe99', 'GEL 1', 'Human Reproduction', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce38bda8-7773-11f1-88cc-cf926f75fe99', 'Sci. 2', 'Teaching Science in Elementary grades (Physics, Earth and Space Science)', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce38d379-7773-11f1-88cc-cf926f75fe99', 'PE 4', 'PATHFIT 4- Team Sports and Recreation Activities', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce38eacf-7773-11f1-88cc-cf926f75fe99', 'Prof. Ed. 7', 'The Teacher and the Community, School Culture and Organizational Leadership', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce39027c-7773-11f1-88cc-cf926f75fe99', 'PCIT 06', 'Networking 1', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce391dba-7773-11f1-88cc-cf926f75fe99', 'PCIT 08', 'System Integration and Architecture', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce39460f-7773-11f1-88cc-cf926f75fe99', 'CCIT 04', 'Data Structures and Algorithms', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:28'),
('ce39751b-7773-11f1-88cc-cf926f75fe99', 'Agri. 15', 'Introduction to Water Management and Irrigation', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:29'),
('ce3991d2-7773-11f1-88cc-cf926f75fe99', 'GEC 5', 'Purposive Communication', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:29'),
('ce39a9fa-7773-11f1-88cc-cf926f75fe99', 'ENG 2', 'Teaching English in the Elementary Grades through Literature', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:29'),
('ce39c27b-7773-11f1-88cc-cf926f75fe99', 'Soil Sci. 1', 'Principles of Soil Science', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:29'),
('ce39dd0a-7773-11f1-88cc-cf926f75fe99', 'Food Tech', 'Practicum in Food Science', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:29'),
('ce39f650-7773-11f1-88cc-cf926f75fe99', 'Prof. Ed. 4', 'Foundation of Special and Inclusive Education', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:29'),
('ce3a1693-7773-11f1-88cc-cf926f75fe99', 'GEL 3', 'Philippine Popular Culture', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:29'),
('ce3a2e2a-7773-11f1-88cc-cf926f75fe99', 'MTB 1', 'Content and Pedagogy for the Mother Tongue', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', '2026-07-04 14:44:29');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`id`, `name`, `created_at`) VALUES
('ce2c93ea-7773-11f1-88cc-cf926f75fe99', 'BACHELOR OF ELEMENTARY EDUCATION', '2026-07-04 14:44:28'),
('ce2cb3f2-7773-11f1-88cc-cf926f75fe99', 'BACHELOR OF AGRI-BUSINESS', '2026-07-04 14:44:28'),
('ce2cfbd1-7773-11f1-88cc-cf926f75fe99', 'BACHELOR OF SCIENCE IN INFORMATION TECHNOLOGY', '2026-07-04 14:44:28');

-- --------------------------------------------------------

--
-- Table structure for table `evaluations`
--

CREATE TABLE `evaluations` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `assignment_id` char(36) NOT NULL,
  `status` enum('draft','submitted') NOT NULL DEFAULT 'submitted',
  `submitted_at` datetime NOT NULL DEFAULT current_timestamp(),
  `overall_comment` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `evaluations`
--

INSERT INTO `evaluations` (`id`, `assignment_id`, `status`, `submitted_at`, `overall_comment`) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '88888888-8888-8888-8888-888888888801', 'submitted', '2026-07-04 14:46:52', 'Self evaluation completed'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '88888888-8888-8888-8888-888888888804', 'submitted', '2026-07-04 14:46:52', 'Student evaluation completed');

-- --------------------------------------------------------

--
-- Table structure for table `evaluation_periods`
--

CREATE TABLE `evaluation_periods` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `name` varchar(255) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('draft','open','closed') NOT NULL DEFAULT 'draft',
  `rubric_version` varchar(64) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `evaluation_periods`
--

INSERT INTO `evaluation_periods` (`id`, `name`, `start_date`, `end_date`, `status`, `rubric_version`, `created_at`) VALUES
('55555555-5555-5555-5555-555555555501', 'Midyear 2026', '2026-06-01', '2026-06-30', 'open', 'v1', '2026-07-04 14:46:52'),
('55555555-5555-5555-5555-555555555502', 'Year End 2026', '2026-11-01', '2026-11-30', 'closed', 'v1', '2026-07-04 14:46:52');

-- --------------------------------------------------------

--
-- Table structure for table `evaluation_responses`
--

CREATE TABLE `evaluation_responses` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `evaluation_id` char(36) NOT NULL,
  `rubric_item_id` char(36) NOT NULL,
  `score` int(11) NOT NULL,
  `comment` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ;

--
-- Dumping data for table `evaluation_responses`
--

INSERT INTO `evaluation_responses` (`id`, `evaluation_id`, `rubric_item_id`, `score`, `comment`, `created_at`) VALUES
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba0', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'd64e5a67-94ad-49f8-b39c-deed75765120', 4, 'Knowledge is up to date', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba1', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '878e4ccb-56b7-452f-bf74-b44fcba05015', 5, 'Provides useful practice activities', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba2', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '8beb4ccb-95d6-44cb-a2f6-4dbe6d3d6d89', 4, 'Encouraging and supportive', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba3', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '171d91a9-c9ec-475f-ad62-447bfc007491', 4, 'Students can contribute ideas', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba4', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'b589e637-4140-4047-8dda-d5ca2b3262a6', 4, 'Promotes accountability', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba5', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'e388cff3-d0f9-4163-85cc-b1c96f90006f', 4, 'Encourages deeper learning', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba6', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '3d499c10-aabc-4ff7-8ab5-8a9f09538969', 4, 'Group work is well structured', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba7', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'ede1634a-01b4-4cd7-b380-8f96f602ce3e', 4, 'Good facilitator role', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba8', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '95c2dbda-5487-43a9-ab6a-cda47fc907e1', 4, 'Healthy discussion in class', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbba9', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '6b39ac0d-fa7e-4692-a26b-9b221b7affc9', 4, 'Class context is adjusted well', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbaa', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'f354ff8c-4e5d-4150-85e5-3ffe48c5fd94', 5, 'Materials are used effectively', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'f7dd1264-d2fc-4f03-85ac-4bbff79ed217', 4, 'Doing well on this criterion', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '51f5f385-dc49-496f-a425-7d4a79b551df', 4, 'Strong collaboration with students', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb3', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '4d9ac33a-70bf-4edd-843c-e5b9df8899d6', 5, 'Always available after class', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb4', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'c4704c91-5961-43db-af58-4ee6b2bae2eb', 4, 'Well prepared and punctual', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb5', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '72648a54-b958-44ee-b963-7d172be3655b', 4, 'Records are maintained properly', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb6', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '1ffba6fb-f93d-4562-a7b8-7e8685b3c9b6', 4, 'Good mastery overall', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb7', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '43085002-591e-4757-b286-27c886a2bad4', 4, 'Current theories are discussed', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb8', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'dfa07af5-342e-4512-903f-34c326aaf870', 4, 'Linked to practical examples', '2026-07-04 14:46:52'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb9', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '86f59b5c-1621-43a6-9c40-efbe0f3eaa35', 4, 'Explains relevance well', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-ccccccccccc1', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'f7dd1264-d2fc-4f03-85ac-4bbff79ed217', 5, 'Very responsive and respectful', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-ccccccccccc2', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '51f5f385-dc49-496f-a425-7d4a79b551df', 4, 'Good collaboration in class', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-ccccccccccc3', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '4d9ac33a-70bf-4edd-843c-e5b9df8899d6', 5, 'Always available to help', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-ccccccccccc4', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'c4704c91-5961-43db-af58-4ee6b2bae2eb', 5, 'Always on time and prepared', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-ccccccccccc5', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '72648a54-b958-44ee-b963-7d172be3655b', 4, 'Keeps good class records', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-ccccccccccc6', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '1ffba6fb-f93d-4562-a7b8-7e8685b3c9b6', 4, 'Knowledgeable instructor', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-ccccccccccc7', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '43085002-591e-4757-b286-27c886a2bad4', 4, 'Shares current practices', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-ccccccccccc8', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'dfa07af5-342e-4512-903f-34c326aaf870', 4, 'Relevant to practice', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-ccccccccccc9', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '86f59b5c-1621-43a6-9c40-efbe0f3eaa35', 5, 'Always relates lessons', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-ccccccccccca', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'd64e5a67-94ad-49f8-b39c-deed75765120', 4, 'Up-to-date content', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-cccccccccccb', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '878e4ccb-56b7-452f-bf74-b44fcba05015', 5, 'Gives practice activities', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '8beb4ccb-95d6-44cb-a2f6-4dbe6d3d6d89', 4, 'Supports student confidence', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-cccccccccccd', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '171d91a9-c9ec-475f-ad62-447bfc007491', 4, 'Lets students contribute', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-ccccccccccce', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'b589e637-4140-4047-8dda-d5ca2b3262a6', 5, 'Encourages independent thinking', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-cccccccccccf', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'e388cff3-d0f9-4163-85cc-b1c96f90006f', 4, 'Pushes learning beyond requirements', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-ccccccccccd0', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '3d499c10-aabc-4ff7-8ab5-8a9f09538969', 4, 'Good group work opportunities', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-ccccccccccd1', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'ede1634a-01b4-4cd7-b380-8f96f602ce3e', 4, 'Facilitates well', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-ccccccccccd2', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '95c2dbda-5487-43a9-ab6a-cda47fc907e1', 4, 'Healthy exchange is encouraged', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-ccccccccccd3', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '6b39ac0d-fa7e-4692-a26b-9b221b7affc9', 4, 'Class flow is well managed', '2026-07-04 14:46:52'),
('cccccccc-cccc-cccc-cccc-ccccccccccd4', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'f354ff8c-4e5d-4150-85e5-3ffe48c5fd94', 5, 'Uses materials effectively', '2026-07-04 14:46:52');

-- --------------------------------------------------------

--
-- Table structure for table `evaluator_assignments`
--

CREATE TABLE `evaluator_assignments` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `period_id` char(36) NOT NULL,
  `section_id` char(36) DEFAULT NULL,
  `faculty_id` char(36) NOT NULL,
  `evaluator_id` char(36) NOT NULL,
  `role` enum('self','peer','supervisor','student') NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `evaluator_assignments`
--

INSERT INTO `evaluator_assignments` (`id`, `period_id`, `section_id`, `faculty_id`, `evaluator_id`, `role`, `created_at`) VALUES
('88888888-8888-8888-8888-888888888801', '55555555-5555-5555-5555-555555555501', 'ce4ed671-7773-11f1-88cc-cf926f75fe99', 'ce32e8db-7773-11f1-88cc-cf926f75fe99', 'ce32e8db-7773-11f1-88cc-cf926f75fe99', 'self', '2026-07-04 14:46:52'),
('88888888-8888-8888-8888-888888888802', '55555555-5555-5555-5555-555555555501', 'ce4ed671-7773-11f1-88cc-cf926f75fe99', 'ce32e8db-7773-11f1-88cc-cf926f75fe99', 'ce32b35b-7773-11f1-88cc-cf926f75fe99', 'peer', '2026-07-04 14:46:52'),
('88888888-8888-8888-8888-888888888803', '55555555-5555-5555-5555-555555555501', 'ce4ed671-7773-11f1-88cc-cf926f75fe99', 'ce32e8db-7773-11f1-88cc-cf926f75fe99', '22222222-2222-2222-2222-222222222201', 'supervisor', '2026-07-04 14:46:52'),
('88888888-8888-8888-8888-888888888804', '55555555-5555-5555-5555-555555555501', 'ce4ed671-7773-11f1-88cc-cf926f75fe99', 'ce32e8db-7773-11f1-88cc-cf926f75fe99', '22222222-2222-2222-2222-222222222204', 'student', '2026-07-04 14:46:52');

-- --------------------------------------------------------

--
-- Table structure for table `profiles`
--

CREATE TABLE `profiles` (
  `id` char(36) NOT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL DEFAULT '123456',
  `role` enum('admin','faculty','student','evaluator','program_head') NOT NULL DEFAULT 'faculty',
  `department_id` char(36) DEFAULT NULL,
  `phone` varchar(64) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `position_title` varchar(255) DEFAULT NULL,
  `must_change_password` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `profiles`
--

INSERT INTO `profiles` (`id`, `full_name`, `email`, `password`, `role`, `department_id`, `phone`, `address`, `position_title`, `must_change_password`, `created_at`) VALUES
('22222222-2222-2222-2222-222222222201', 'Alex Admin', 'admin@example.com', 'admin123', 'admin', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 0, '2026-07-04 14:46:52'),
('22222222-2222-2222-2222-222222222202', 'Frida Faculty', 'faculty1@example.com', 'faculty123', 'faculty', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:46:52'),
('22222222-2222-2222-2222-222222222203', 'Felix Faculty', 'faculty2@example.com', 'faculty123', 'faculty', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:46:52'),
('22222222-2222-2222-2222-222222222204', 'Sam Student', 'student1@example.com', 'student123', 'student', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:46:52'),
('22222222-2222-2222-2222-222222222205', 'Pat Program Head', 'programhead@example.com', 'head123', 'program_head', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 0, '2026-07-04 14:46:52'),
('22222222-2222-2222-2222-222222222206', 'Eli Evaluator', 'evaluator@example.com', 'evaluator123', 'evaluator', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:46:52'),
('ce2d2834-7773-11f1-88cc-cf926f75fe99', 'ABUNDO, JULIE ANNE S.', 'faculty.abundo.julie.anne.s@local.test', 'faculty123', 'faculty', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce2d51f5-7773-11f1-88cc-cf926f75fe99', 'ABUNDO, SIMIAS A.', 'faculty.abundo.simias.a@local.test', 'faculty123', 'faculty', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce2db52c-7773-11f1-88cc-cf926f75fe99', 'ARQUERO, EMILVERCHRISTIAN V.', 'faculty.arquero.emilverchristian.v@local.test', 'faculty123', 'faculty', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce2ddfa1-7773-11f1-88cc-cf926f75fe99', 'BASAS, BERNIE S.', 'faculty.basas.bernie.s@local.test', 'faculty123', 'faculty', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce2e0ab8-7773-11f1-88cc-cf926f75fe99', 'BALLADARES, ROSE ANN C.', 'faculty.balladares.rose.ann.c@local.test', 'faculty123', 'faculty', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce2e3bb6-7773-11f1-88cc-cf926f75fe99', 'GEQUILLANA, ROSEMIE G.', 'faculty.gequillana.rosemie.g@local.test', 'faculty123', 'faculty', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce2e7246-7773-11f1-88cc-cf926f75fe99', 'JANGAD, JOEL - LOVE A.', 'faculty.jangad.joel.love.a@local.test', 'faculty123', 'faculty', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce2eaab9-7773-11f1-88cc-cf926f75fe99', 'ODENCIO, JOSE EDMUND P.', 'faculty.odencio.jose.edmund.p@local.test', 'faculty123', 'faculty', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce2ee545-7773-11f1-88cc-cf926f75fe99', 'SELDORA, LOVELYN S.', 'faculty.seldora.lovelyn.s@local.test', 'faculty123', 'faculty', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce2f1e6a-7773-11f1-88cc-cf926f75fe99', 'SUMAGAYSAY, EFRAIM B.', 'faculty.sumagaysay.efraim.b@local.test', 'faculty123', 'faculty', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce2f57b6-7773-11f1-88cc-cf926f75fe99', 'ARNIDO, JOHN KENNETH O.', 'faculty.arnido.john.kenneth.o@local.test', 'faculty123', 'faculty', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce2f9497-7773-11f1-88cc-cf926f75fe99', 'CADAYONA, MARJORIE D.', 'faculty.cadayona.marjorie.d@local.test', 'faculty123', 'faculty', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce2fd4f1-7773-11f1-88cc-cf926f75fe99', 'CUIZON, JERRY JUN M.', 'faculty.cuizon.jerry.jun.m@local.test', 'faculty123', 'faculty', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce300c97-7773-11f1-88cc-cf926f75fe99', 'DE LA SERNA, RONALD T.', 'faculty.de.la.serna.ronald.t@local.test', 'faculty123', 'faculty', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce3050f1-7773-11f1-88cc-cf926f75fe99', 'DUMAS, ALEXANDER S.', 'faculty.dumas.alexander.s@local.test', 'faculty123', 'faculty', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce3088c8-7773-11f1-88cc-cf926f75fe99', 'ESPA??OLA, RYAN O.', 'faculty.espa.ola.ryan.o@local.test', 'faculty123', 'faculty', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce30af50-7773-11f1-88cc-cf926f75fe99', 'ESTACION, MERCY JOHN P.', 'faculty.estacion.mercy.john.p@local.test', 'faculty123', 'faculty', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce30dab8-7773-11f1-88cc-cf926f75fe99', 'GEALOLO, MIKE CHRISTIAN C.', 'faculty.gealolo.mike.christian.c@local.test', 'faculty123', 'faculty', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce3113f0-7773-11f1-88cc-cf926f75fe99', 'GETONZO, ELSIE A.', 'faculty.getonzo.elsie.a@local.test', 'faculty123', 'faculty', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce315050-7773-11f1-88cc-cf926f75fe99', 'INGUILLO, REA V.', 'faculty.inguillo.rea.v@local.test', 'faculty123', 'faculty', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce318cc0-7773-11f1-88cc-cf926f75fe99', 'JUNGCO, HALYN E.', 'faculty.jungco.halyn.e@local.test', 'faculty123', 'faculty', 'ce2c93ea-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce31c0a4-7773-11f1-88cc-cf926f75fe99', 'MORALES, DYSA S.', 'faculty.morales.dysa.s@local.test', 'faculty123', 'faculty', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce31fabb-7773-11f1-88cc-cf926f75fe99', 'PELINGON, CHARLIE E.', 'faculty.pelingon.charlie.e@local.test', '123faculty', 'faculty', 'ce2cfbd1-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 0, '2026-07-04 14:44:28'),
('ce32334d-7773-11f1-88cc-cf926f75fe99', 'SARIENTO, JUVY G.', 'faculty.sariento.juvy.g@local.test', 'faculty123', 'faculty', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce325e51-7773-11f1-88cc-cf926f75fe99', 'SENCIL, JEZZA MAR L.', 'faculty.sencil.jezza.mar.l@local.test', 'faculty123', 'faculty', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce328cf4-7773-11f1-88cc-cf926f75fe99', 'SUMAGAYSAY, FRANTIBER P.', 'faculty.sumagaysay.frantiber.p@local.test', 'faculty123', 'faculty', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce32b35b-7773-11f1-88cc-cf926f75fe99', 'PRADO, PETER JOHN D.', 'faculty.prado.peter.john.d@local.test', 'faculty123', 'faculty', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28'),
('ce32e8db-7773-11f1-88cc-cf926f75fe99', 'TUBONGBANUA, ANGELOU M.', 'faculty.tubongbanua.angelou.m@local.test', 'faculty123', 'faculty', 'ce2cb3f2-7773-11f1-88cc-cf926f75fe99', NULL, NULL, NULL, 1, '2026-07-04 14:44:28');

-- --------------------------------------------------------

--
-- Table structure for table `rubric_categories`
--

CREATE TABLE `rubric_categories` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `label` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `order_index` int(11) NOT NULL DEFAULT 0,
  `weight` decimal(6,2) NOT NULL DEFAULT 1.00,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rubric_categories`
--

INSERT INTO `rubric_categories` (`id`, `label`, `description`, `order_index`, `weight`, `created_at`) VALUES
('65504595-1814-42b2-8e81-eb8228661f8a', 'Commitment', 'Sensitivity, availability, records, timeliness', 1, 1.00, '2026-02-16 06:28:05'),
('6f608ddd-8036-4122-af1a-274612a2c182', 'Teaching for Independent Learning', 'Strategies, self-esteem, accountability, beyond requirements', 3, 1.00, '2026-02-16 06:28:05'),
('78972b31-2a5f-453f-9b5b-e1944dc60906', 'Management of Learning', 'Facilitation, experience design, structure, materials', 4, 1.00, '2026-02-16 06:28:05'),
('d1804438-3d81-44ae-b303-ef00d17032a4', 'Knowledge of Subject', 'Mastery, relevance, currency', 2, 1.00, '2026-02-16 06:28:05');

-- --------------------------------------------------------

--
-- Table structure for table `rubric_items`
--

CREATE TABLE `rubric_items` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `category_id` char(36) NOT NULL,
  `prompt` text NOT NULL,
  `max_score` int(11) NOT NULL DEFAULT 5,
  `order_index` int(11) NOT NULL DEFAULT 0,
  `weight` decimal(6,2) NOT NULL DEFAULT 1.00,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rubric_items`
--

INSERT INTO `rubric_items` (`id`, `category_id`, `prompt`, `max_score`, `order_index`, `weight`, `created_at`) VALUES
('171d91a9-c9ec-475f-ad62-447bfc007491', '6f608ddd-8036-4122-af1a-274612a2c182', 'Allows students to create their own course rules/objectives.', 5, 3, 1.00, '2026-02-16 06:28:05'),
('1ffba6fb-f93d-4562-a7b8-7e8685b3c9b6', 'd1804438-3d81-44ae-b303-ef00d17032a4', 'Demonstrates mastery without relying solely on the textbook.', 5, 1, 1.00, '2026-02-16 06:28:05'),
('3d499c10-aabc-4ff7-8ab5-8a9f09538969', '78972b31-2a5f-453f-9b5b-e1944dc60906', 'Creates opportunities for intensive/extensive contribution (dyads/triads/groups).', 5, 1, 1.00, '2026-02-16 06:28:05'),
('43085002-591e-4757-b286-27c886a2bad4', 'd1804438-3d81-44ae-b303-ef00d17032a4', 'Shares state-of-the-art theory and practice.', 5, 2, 1.00, '2026-02-16 06:28:05'),
('4d9ac33a-70bf-4edd-843c-e5b9df8899d6', '65504595-1814-42b2-8e81-eb8228661f8a', 'Makes self-available to students beyond official time.', 5, 3, 1.00, '2026-02-16 06:28:05'),
('51f5f385-dc49-496f-a425-7d4a79b551df', '65504595-1814-42b2-8e81-eb8228661f8a', 'Integrates sensitively learning objectives with those of the students in a collaborative process.', 5, 2, 1.00, '2026-02-16 06:28:05'),
('6b39ac0d-fa7e-4692-a26b-9b221b7affc9', '78972b31-2a5f-453f-9b5b-e1944dc60906', 'Restructures context to enhance learning objectives.', 5, 4, 1.00, '2026-02-16 06:28:05'),
('72648a54-b958-44ee-b963-7d172be3655b', '65504595-1814-42b2-8e81-eb8228661f8a', 'Keeps accurate records of students performance and prompt submission.', 5, 5, 1.00, '2026-02-16 06:28:05'),
('86f59b5c-1621-43a6-9c40-efbe0f3eaa35', 'd1804438-3d81-44ae-b303-ef00d17032a4', 'Explains relevance to previous lessons and daily life.', 5, 4, 1.00, '2026-02-16 06:28:05'),
('878e4ccb-56b7-452f-bf74-b44fcba05015', '6f608ddd-8036-4122-af1a-274612a2c182', 'Creates strategies for students to practice concepts.', 5, 1, 1.00, '2026-02-16 06:28:05'),
('8beb4ccb-95d6-44cb-a2f6-4dbe6d3d6d89', '6f608ddd-8036-4122-af1a-274612a2c182', 'Enhances self-esteem / gives recognition.', 5, 2, 1.00, '2026-02-16 06:28:05'),
('95c2dbda-5487-43a9-ab6a-cda47fc907e1', '78972b31-2a5f-453f-9b5b-e1944dc60906', 'Designs conditions for healthy exchange/confrontation.', 5, 3, 1.00, '2026-02-16 06:28:05'),
('b589e637-4140-4047-8dda-d5ca2b3262a6', '6f608ddd-8036-4122-af1a-274612a2c182', 'Lets students think independently and be accountable.', 5, 4, 1.00, '2026-02-16 06:28:05'),
('c4704c91-5961-43db-af58-4ee6b2bae2eb', '65504595-1814-42b2-8e81-eb8228661f8a', 'Regularly comes to class on time, well-groomed and well-prepared.', 5, 4, 1.00, '2026-02-16 06:28:05'),
('d64e5a67-94ad-49f8-b39c-deed75765120', 'd1804438-3d81-44ae-b303-ef00d17032a4', 'Shows up-to-date knowledge on trends/issues.', 5, 5, 1.00, '2026-02-16 06:28:05'),
('dfa07af5-342e-4512-903f-34c326aaf870', 'd1804438-3d81-44ae-b303-ef00d17032a4', 'Integrates subject to practical circumstances and student intents.', 5, 3, 1.00, '2026-02-16 06:28:05'),
('e388cff3-d0f9-4163-85cc-b1c96f90006f', '6f608ddd-8036-4122-af1a-274612a2c182', 'Encourages learning beyond requirements and applying concepts.', 5, 5, 1.00, '2026-02-16 06:28:05'),
('ede1634a-01b4-4cd7-b380-8f96f602ce3e', '78972b31-2a5f-453f-9b5b-e1944dc60906', 'Assumes roles (facilitator, coach, integrator, referee).', 5, 2, 1.00, '2026-02-16 06:28:05'),
('f354ff8c-4e5d-4150-85e5-3ffe48c5fd94', '78972b31-2a5f-453f-9b5b-e1944dc60906', 'Uses instructional materials/CAI/fieldtrips/etc.', 5, 5, 1.00, '2026-02-16 06:28:05'),
('f7dd1264-d2fc-4f03-85ac-4bbff79ed217', '65504595-1814-42b2-8e81-eb8228661f8a', 'Demonstrates sensitivity to students ability to attend and absorb content information.', 5, 1, 1.00, '2026-02-16 06:28:05');

-- --------------------------------------------------------

--
-- Table structure for table `sections`
--

CREATE TABLE `sections` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `course_id` char(36) NOT NULL,
  `faculty_id` char(36) DEFAULT NULL,
  `term` varchar(64) DEFAULT NULL,
  `academic_year` varchar(32) DEFAULT NULL,
  `section_code` varchar(64) DEFAULT NULL,
  `program_code` varchar(32) DEFAULT NULL,
  `student_count` int(11) DEFAULT NULL,
  `schedule` varchar(128) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sections`
--

INSERT INTO `sections` (`id`, `course_id`, `faculty_id`, `term`, `academic_year`, `section_code`, `program_code`, `student_count`, `schedule`, `created_at`) VALUES
('ce3a7007-7773-11f1-88cc-cf926f75fe99', 'ce331056-7773-11f1-88cc-cf926f75fe99', 'ce2d2834-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 2A', 'BEED', 26, NULL, '2026-07-04 14:44:29'),
('ce3a97d1-7773-11f1-88cc-cf926f75fe99', 'ce331056-7773-11f1-88cc-cf926f75fe99', 'ce2d2834-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 2B', 'BEED', 25, NULL, '2026-07-04 14:44:29'),
('ce3ae38f-7773-11f1-88cc-cf926f75fe99', 'ce334777-7773-11f1-88cc-cf926f75fe99', 'ce2d2834-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 2A', 'BEED', 26, NULL, '2026-07-04 14:44:29'),
('ce3b0c54-7773-11f1-88cc-cf926f75fe99', 'ce336c61-7773-11f1-88cc-cf926f75fe99', 'ce2d2834-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 4C', 'BEED', 36, NULL, '2026-07-04 14:44:29'),
('ce3b368c-7773-11f1-88cc-cf926f75fe99', 'ce33901d-7773-11f1-88cc-cf926f75fe99', 'ce2d51f5-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 3A', 'BSAB', 28, NULL, '2026-07-04 14:44:29'),
('ce3b5a09-7773-11f1-88cc-cf926f75fe99', 'ce33901d-7773-11f1-88cc-cf926f75fe99', 'ce2d51f5-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 3B', 'BSAB', 29, NULL, '2026-07-04 14:44:29'),
('ce3b7f4d-7773-11f1-88cc-cf926f75fe99', 'ce33901d-7773-11f1-88cc-cf926f75fe99', 'ce2d51f5-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 3C', 'BSAB', 34, NULL, '2026-07-04 14:44:29'),
('ce3ba331-7773-11f1-88cc-cf926f75fe99', 'ce33b33a-7773-11f1-88cc-cf926f75fe99', 'ce2d51f5-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 3A', 'BSAB', 28, NULL, '2026-07-04 14:44:29'),
('ce3bceda-7773-11f1-88cc-cf926f75fe99', 'ce33b33a-7773-11f1-88cc-cf926f75fe99', 'ce2d51f5-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 3B', 'BSAB', 29, NULL, '2026-07-04 14:44:29'),
('ce3bf210-7773-11f1-88cc-cf926f75fe99', 'ce33b33a-7773-11f1-88cc-cf926f75fe99', 'ce2d51f5-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 3C', 'BSAB', 34, NULL, '2026-07-04 14:44:29'),
('ce3c11b3-7773-11f1-88cc-cf926f75fe99', 'ce33d802-7773-11f1-88cc-cf926f75fe99', 'ce2db52c-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1A', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce3c3016-7773-11f1-88cc-cf926f75fe99', 'ce33d802-7773-11f1-88cc-cf926f75fe99', 'ce2db52c-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1B', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce3c5b1c-7773-11f1-88cc-cf926f75fe99', 'ce33d802-7773-11f1-88cc-cf926f75fe99', 'ce2db52c-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1C', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce3c8093-7773-11f1-88cc-cf926f75fe99', 'ce33fb11-7773-11f1-88cc-cf926f75fe99', 'ce2db52c-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 3B', 'BSIT', 35, NULL, '2026-07-04 14:44:29'),
('ce3caa81-7773-11f1-88cc-cf926f75fe99', 'ce341d4e-7773-11f1-88cc-cf926f75fe99', 'ce2ddfa1-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1A', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce3cd08f-7773-11f1-88cc-cf926f75fe99', 'ce341d4e-7773-11f1-88cc-cf926f75fe99', 'ce2ddfa1-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1B', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce3cf527-7773-11f1-88cc-cf926f75fe99', 'ce341d4e-7773-11f1-88cc-cf926f75fe99', 'ce2ddfa1-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1C', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce3d1f0f-7773-11f1-88cc-cf926f75fe99', 'ce33fb11-7773-11f1-88cc-cf926f75fe99', 'ce2ddfa1-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 3A', 'BSIT', 34, NULL, '2026-07-04 14:44:29'),
('ce3d3e1d-7773-11f1-88cc-cf926f75fe99', 'ce34413c-7773-11f1-88cc-cf926f75fe99', 'ce2e0ab8-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 3A', 'BSIT', 34, NULL, '2026-07-04 14:44:29'),
('ce3d5cb2-7773-11f1-88cc-cf926f75fe99', 'ce34413c-7773-11f1-88cc-cf926f75fe99', 'ce2e0ab8-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 3B', 'BSIT', 35, NULL, '2026-07-04 14:44:29'),
('ce3d7767-7773-11f1-88cc-cf926f75fe99', 'ce3465e4-7773-11f1-88cc-cf926f75fe99', 'ce2e0ab8-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 3A', 'BSIT', 34, NULL, '2026-07-04 14:44:29'),
('ce3d908d-7773-11f1-88cc-cf926f75fe99', 'ce336c61-7773-11f1-88cc-cf926f75fe99', 'ce2e3bb6-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 4A', 'BEED', 33, NULL, '2026-07-04 14:44:29'),
('ce3daaa6-7773-11f1-88cc-cf926f75fe99', 'ce34887c-7773-11f1-88cc-cf926f75fe99', 'ce2e7246-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1A', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce3dc6ed-7773-11f1-88cc-cf926f75fe99', 'ce34887c-7773-11f1-88cc-cf926f75fe99', 'ce2e7246-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1B', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce3de9bc-7773-11f1-88cc-cf926f75fe99', 'ce34887c-7773-11f1-88cc-cf926f75fe99', 'ce2e7246-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1C', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce3e10df-7773-11f1-88cc-cf926f75fe99', 'ce34887c-7773-11f1-88cc-cf926f75fe99', 'ce2e7246-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 1A', 'BEED', 35, NULL, '2026-07-04 14:44:29'),
('ce3e3f8c-7773-11f1-88cc-cf926f75fe99', 'ce34abdc-7773-11f1-88cc-cf926f75fe99', 'ce2eaab9-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 3A', 'BSAB', 28, NULL, '2026-07-04 14:44:29'),
('ce3e6376-7773-11f1-88cc-cf926f75fe99', 'ce34abdc-7773-11f1-88cc-cf926f75fe99', 'ce2eaab9-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 3B', 'BSAB', 29, NULL, '2026-07-04 14:44:29'),
('ce3e8b61-7773-11f1-88cc-cf926f75fe99', 'ce34abdc-7773-11f1-88cc-cf926f75fe99', 'ce2eaab9-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 3C', 'BSAB', 34, NULL, '2026-07-04 14:44:29'),
('ce3ea98c-7773-11f1-88cc-cf926f75fe99', 'ce34cdb6-7773-11f1-88cc-cf926f75fe99', 'ce2eaab9-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2C', 'BSAB', 39, NULL, '2026-07-04 14:44:29'),
('ce3ecaa3-7773-11f1-88cc-cf926f75fe99', 'ce34ee5c-7773-11f1-88cc-cf926f75fe99', 'ce2ee545-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1A', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce3eeeac-7773-11f1-88cc-cf926f75fe99', 'ce34ee5c-7773-11f1-88cc-cf926f75fe99', 'ce2ee545-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1B', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce3f1d62-7773-11f1-88cc-cf926f75fe99', 'ce34ee5c-7773-11f1-88cc-cf926f75fe99', 'ce2ee545-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1C', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce3f42fe-7773-11f1-88cc-cf926f75fe99', 'ce34ee5c-7773-11f1-88cc-cf926f75fe99', 'ce2ee545-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1A', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce3f6fe3-7773-11f1-88cc-cf926f75fe99', 'ce34ee5c-7773-11f1-88cc-cf926f75fe99', 'ce2ee545-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1B', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce3f9200-7773-11f1-88cc-cf926f75fe99', 'ce34ee5c-7773-11f1-88cc-cf926f75fe99', 'ce2ee545-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1C', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce3fbb1e-7773-11f1-88cc-cf926f75fe99', 'ce351894-7773-11f1-88cc-cf926f75fe99', 'ce2ee545-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 1A', 'BEED', 35, NULL, '2026-07-04 14:44:29'),
('ce3fd971-7773-11f1-88cc-cf926f75fe99', 'ce353fd4-7773-11f1-88cc-cf926f75fe99', 'ce2f1e6a-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1A', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce3ff919-7773-11f1-88cc-cf926f75fe99', 'ce353fd4-7773-11f1-88cc-cf926f75fe99', 'ce2f1e6a-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1B', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce401377-7773-11f1-88cc-cf926f75fe99', 'ce35638b-7773-11f1-88cc-cf926f75fe99', 'ce2f1e6a-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 4C', 'BSAB', 40, NULL, '2026-07-04 14:44:29'),
('ce403169-7773-11f1-88cc-cf926f75fe99', 'ce358a4f-7773-11f1-88cc-cf926f75fe99', 'ce2f57b6-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 3A', 'BSIT', 34, NULL, '2026-07-04 14:44:29'),
('ce405310-7773-11f1-88cc-cf926f75fe99', 'ce358a4f-7773-11f1-88cc-cf926f75fe99', 'ce2f57b6-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 3B', 'BSIT', 35, NULL, '2026-07-04 14:44:29'),
('ce4071d5-7773-11f1-88cc-cf926f75fe99', 'ce35ad33-7773-11f1-88cc-cf926f75fe99', 'ce2f57b6-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 3A', 'BSIT', 34, NULL, '2026-07-04 14:44:29'),
('ce40917e-7773-11f1-88cc-cf926f75fe99', 'ce35ad33-7773-11f1-88cc-cf926f75fe99', 'ce2f57b6-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 3B', 'BSIT', 35, NULL, '2026-07-04 14:44:29'),
('ce40ace6-7773-11f1-88cc-cf926f75fe99', 'ce35cf00-7773-11f1-88cc-cf926f75fe99', 'ce2f57b6-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 2A', 'BSIT', 35, NULL, '2026-07-04 14:44:29'),
('ce40c78a-7773-11f1-88cc-cf926f75fe99', 'ce35efb7-7773-11f1-88cc-cf926f75fe99', 'ce2f9497-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1A', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce40e655-7773-11f1-88cc-cf926f75fe99', 'ce35efb7-7773-11f1-88cc-cf926f75fe99', 'ce2f9497-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1B', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce4106ba-7773-11f1-88cc-cf926f75fe99', 'ce35efb7-7773-11f1-88cc-cf926f75fe99', 'ce2f9497-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1C', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce4121b3-7773-11f1-88cc-cf926f75fe99', 'ce361267-7773-11f1-88cc-cf926f75fe99', 'ce2f9497-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 2A', 'BEED', 26, NULL, '2026-07-04 14:44:29'),
('ce414703-7773-11f1-88cc-cf926f75fe99', 'ce361267-7773-11f1-88cc-cf926f75fe99', 'ce2f9497-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 2B', 'BEED', 25, NULL, '2026-07-04 14:44:29'),
('ce416326-7773-11f1-88cc-cf926f75fe99', 'ce363acc-7773-11f1-88cc-cf926f75fe99', 'ce2f9497-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 3B', 'BSAB', 29, NULL, '2026-07-04 14:44:29'),
('ce41818d-7773-11f1-88cc-cf926f75fe99', 'ce363acc-7773-11f1-88cc-cf926f75fe99', 'ce2f9497-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 3C', 'BSAB', 34, NULL, '2026-07-04 14:44:29'),
('ce419aa5-7773-11f1-88cc-cf926f75fe99', 'ce351894-7773-11f1-88cc-cf926f75fe99', 'ce2f9497-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 1B', 'BEED', 35, NULL, '2026-07-04 14:44:29'),
('ce41b514-7773-11f1-88cc-cf926f75fe99', 'ce365afe-7773-11f1-88cc-cf926f75fe99', 'ce2fd4f1-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 2A', 'BEED', 26, NULL, '2026-07-04 14:44:29'),
('ce41d292-7773-11f1-88cc-cf926f75fe99', 'ce365afe-7773-11f1-88cc-cf926f75fe99', 'ce2fd4f1-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 2B', 'BEED', 25, NULL, '2026-07-04 14:44:29'),
('ce41f264-7773-11f1-88cc-cf926f75fe99', 'ce34887c-7773-11f1-88cc-cf926f75fe99', 'ce2fd4f1-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1A', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce4211aa-7773-11f1-88cc-cf926f75fe99', 'ce34887c-7773-11f1-88cc-cf926f75fe99', 'ce2fd4f1-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1B', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce423456-7773-11f1-88cc-cf926f75fe99', 'ce34887c-7773-11f1-88cc-cf926f75fe99', 'ce2fd4f1-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1C', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce425443-7773-11f1-88cc-cf926f75fe99', 'ce34887c-7773-11f1-88cc-cf926f75fe99', 'ce2fd4f1-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 1B', 'BEED', 35, NULL, '2026-07-04 14:44:29'),
('ce427928-7773-11f1-88cc-cf926f75fe99', 'ce336c61-7773-11f1-88cc-cf926f75fe99', 'ce2fd4f1-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 4B', 'BEED', 34, NULL, '2026-07-04 14:44:29'),
('ce4296c6-7773-11f1-88cc-cf926f75fe99', 'ce367e9d-7773-11f1-88cc-cf926f75fe99', 'ce300c97-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2A', 'BSAB', 39, NULL, '2026-07-04 14:44:29'),
('ce42b9f5-7773-11f1-88cc-cf926f75fe99', 'ce367e9d-7773-11f1-88cc-cf926f75fe99', 'ce300c97-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2B', 'BSAB', 41, NULL, '2026-07-04 14:44:29'),
('ce42db19-7773-11f1-88cc-cf926f75fe99', 'ce367e9d-7773-11f1-88cc-cf926f75fe99', 'ce300c97-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2C', 'BSAB', 39, NULL, '2026-07-04 14:44:29'),
('ce43003e-7773-11f1-88cc-cf926f75fe99', 'ce353fd4-7773-11f1-88cc-cf926f75fe99', 'ce300c97-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1C', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce431e84-7773-11f1-88cc-cf926f75fe99', 'ce3697da-7773-11f1-88cc-cf926f75fe99', 'ce300c97-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2C', 'BSAB', 39, NULL, '2026-07-04 14:44:29'),
('ce433af0-7773-11f1-88cc-cf926f75fe99', 'ce36bba0-7773-11f1-88cc-cf926f75fe99', 'ce3050f1-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1C', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce43585b-7773-11f1-88cc-cf926f75fe99', 'ce35638b-7773-11f1-88cc-cf926f75fe99', 'ce3088c8-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 4A', 'BSAB', 38, NULL, '2026-07-04 14:44:29'),
('ce437e81-7773-11f1-88cc-cf926f75fe99', 'ce35638b-7773-11f1-88cc-cf926f75fe99', 'ce3088c8-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 4B', 'BSAB', 40, NULL, '2026-07-04 14:44:29'),
('ce439f38-7773-11f1-88cc-cf926f75fe99', 'ce36d8f6-7773-11f1-88cc-cf926f75fe99', 'ce3088c8-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2A', 'BSAB', 39, NULL, '2026-07-04 14:44:29'),
('ce43bae6-7773-11f1-88cc-cf926f75fe99', 'ce36d8f6-7773-11f1-88cc-cf926f75fe99', 'ce3088c8-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2B', 'BSAB', 41, NULL, '2026-07-04 14:44:29'),
('ce43e53f-7773-11f1-88cc-cf926f75fe99', 'ce36d8f6-7773-11f1-88cc-cf926f75fe99', 'ce3088c8-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2C', 'BSAB', 39, NULL, '2026-07-04 14:44:29'),
('ce441001-7773-11f1-88cc-cf926f75fe99', 'ce363acc-7773-11f1-88cc-cf926f75fe99', 'ce3088c8-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 3A', 'BSAB', 28, NULL, '2026-07-04 14:44:29'),
('ce443450-7773-11f1-88cc-cf926f75fe99', 'ce36f9ab-7773-11f1-88cc-cf926f75fe99', 'ce30af50-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 2A', 'BSIT', 35, NULL, '2026-07-04 14:44:29'),
('ce4456e3-7773-11f1-88cc-cf926f75fe99', 'ce36f9ab-7773-11f1-88cc-cf926f75fe99', 'ce30af50-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 2B', 'BSIT', 35, NULL, '2026-07-04 14:44:29'),
('ce447640-7773-11f1-88cc-cf926f75fe99', 'ce3719b7-7773-11f1-88cc-cf926f75fe99', 'ce30af50-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 2A', 'BSIT', 35, NULL, '2026-07-04 14:44:29'),
('ce4494b2-7773-11f1-88cc-cf926f75fe99', 'ce3719b7-7773-11f1-88cc-cf926f75fe99', 'ce30af50-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 2B', 'BSIT', 35, NULL, '2026-07-04 14:44:29'),
('ce44baa6-7773-11f1-88cc-cf926f75fe99', 'ce373aa1-7773-11f1-88cc-cf926f75fe99', 'ce30af50-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 3A', 'BSIT', 34, NULL, '2026-07-04 14:44:29'),
('ce44dc1f-7773-11f1-88cc-cf926f75fe99', 'ce37650c-7773-11f1-88cc-cf926f75fe99', 'ce30dab8-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1A', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce44fad5-7773-11f1-88cc-cf926f75fe99', 'ce37650c-7773-11f1-88cc-cf926f75fe99', 'ce30dab8-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1B', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce452604-7773-11f1-88cc-cf926f75fe99', 'ce37650c-7773-11f1-88cc-cf926f75fe99', 'ce30dab8-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1C', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce4550e3-7773-11f1-88cc-cf926f75fe99', 'ce379092-7773-11f1-88cc-cf926f75fe99', 'ce30dab8-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 3B', 'BSIT', 35, NULL, '2026-07-04 14:44:29'),
('ce457615-7773-11f1-88cc-cf926f75fe99', 'ce37b194-7773-11f1-88cc-cf926f75fe99', 'ce30dab8-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 2A', 'BSIT', 35, NULL, '2026-07-04 14:44:29'),
('ce4596f6-7773-11f1-88cc-cf926f75fe99', 'ce37d8c2-7773-11f1-88cc-cf926f75fe99', 'ce3113f0-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 1A', 'BEED', 35, NULL, '2026-07-04 14:44:29'),
('ce45b690-7773-11f1-88cc-cf926f75fe99', 'ce37d8c2-7773-11f1-88cc-cf926f75fe99', 'ce3113f0-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 1B', 'BEED', 35, NULL, '2026-07-04 14:44:29'),
('ce45da72-7773-11f1-88cc-cf926f75fe99', 'ce380076-7773-11f1-88cc-cf926f75fe99', 'ce3113f0-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2A', 'BSAB', 35, NULL, '2026-07-04 14:44:29'),
('ce46012d-7773-11f1-88cc-cf926f75fe99', 'ce380076-7773-11f1-88cc-cf926f75fe99', 'ce3113f0-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2B', 'BSAB', 35, NULL, '2026-07-04 14:44:29'),
('ce46288e-7773-11f1-88cc-cf926f75fe99', 'ce380076-7773-11f1-88cc-cf926f75fe99', 'ce3113f0-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2C', 'BSAB', 35, NULL, '2026-07-04 14:44:29'),
('ce464db4-7773-11f1-88cc-cf926f75fe99', 'ce38199f-7773-11f1-88cc-cf926f75fe99', 'ce3113f0-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1A', 'BSAB', 35, NULL, '2026-07-04 14:44:29'),
('ce466c5d-7773-11f1-88cc-cf926f75fe99', 'ce383259-7773-11f1-88cc-cf926f75fe99', 'ce315050-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2A', 'BSAB', 39, NULL, '2026-07-04 14:44:29'),
('ce469176-7773-11f1-88cc-cf926f75fe99', 'ce383259-7773-11f1-88cc-cf926f75fe99', 'ce315050-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2B', 'BSAB', 41, NULL, '2026-07-04 14:44:29'),
('ce46b81a-7773-11f1-88cc-cf926f75fe99', 'ce383259-7773-11f1-88cc-cf926f75fe99', 'ce315050-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2C', 'BSAB', 39, NULL, '2026-07-04 14:44:29'),
('ce46dc59-7773-11f1-88cc-cf926f75fe99', 'ce384e98-7773-11f1-88cc-cf926f75fe99', 'ce315050-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 3A', 'BSAB', 28, NULL, '2026-07-04 14:44:29'),
('ce46fb22-7773-11f1-88cc-cf926f75fe99', 'ce384e98-7773-11f1-88cc-cf926f75fe99', 'ce315050-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 3B', 'BSAB', 29, NULL, '2026-07-04 14:44:29'),
('ce471db3-7773-11f1-88cc-cf926f75fe99', 'ce384e98-7773-11f1-88cc-cf926f75fe99', 'ce315050-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 3C', 'BSAB', 34, NULL, '2026-07-04 14:44:29'),
('ce474034-7773-11f1-88cc-cf926f75fe99', 'ce34cdb6-7773-11f1-88cc-cf926f75fe99', 'ce315050-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2A', 'BSAB', 39, NULL, '2026-07-04 14:44:29'),
('ce47636b-7773-11f1-88cc-cf926f75fe99', 'ce34cdb6-7773-11f1-88cc-cf926f75fe99', 'ce315050-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2B', 'BSAB', 41, NULL, '2026-07-04 14:44:29'),
('ce478377-7773-11f1-88cc-cf926f75fe99', 'ce387935-7773-11f1-88cc-cf926f75fe99', 'ce318cc0-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 1A', 'BEED', 35, NULL, '2026-07-04 14:44:29'),
('ce47a300-7773-11f1-88cc-cf926f75fe99', 'ce387935-7773-11f1-88cc-cf926f75fe99', 'ce318cc0-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 1B', 'BEED', 35, NULL, '2026-07-04 14:44:29'),
('ce47c3f1-7773-11f1-88cc-cf926f75fe99', 'ce387935-7773-11f1-88cc-cf926f75fe99', 'ce318cc0-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1A', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce47e3dc-7773-11f1-88cc-cf926f75fe99', 'ce387935-7773-11f1-88cc-cf926f75fe99', 'ce318cc0-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1B', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce48028c-7773-11f1-88cc-cf926f75fe99', 'ce387935-7773-11f1-88cc-cf926f75fe99', 'ce318cc0-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1C', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce481c10-7773-11f1-88cc-cf926f75fe99', 'ce389a84-7773-11f1-88cc-cf926f75fe99', 'ce318cc0-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 1A', 'BEED', 35, NULL, '2026-07-04 14:44:29'),
('ce483a8c-7773-11f1-88cc-cf926f75fe99', 'ce389a84-7773-11f1-88cc-cf926f75fe99', 'ce318cc0-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 1B', 'BEED', 35, NULL, '2026-07-04 14:44:29'),
('ce4857a3-7773-11f1-88cc-cf926f75fe99', 'ce38bda8-7773-11f1-88cc-cf926f75fe99', 'ce318cc0-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 1A', 'BEED', 35, NULL, '2026-07-04 14:44:29'),
('ce487636-7773-11f1-88cc-cf926f75fe99', 'ce38d379-7773-11f1-88cc-cf926f75fe99', 'ce31c0a4-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2A', 'BSAB', 39, NULL, '2026-07-04 14:44:29'),
('ce489ae1-7773-11f1-88cc-cf926f75fe99', 'ce38d379-7773-11f1-88cc-cf926f75fe99', 'ce31c0a4-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2B', 'BSAB', 41, NULL, '2026-07-04 14:44:29'),
('ce48c1e9-7773-11f1-88cc-cf926f75fe99', 'ce38d379-7773-11f1-88cc-cf926f75fe99', 'ce31c0a4-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2C', 'BSAB', 39, NULL, '2026-07-04 14:44:29'),
('ce48e5df-7773-11f1-88cc-cf926f75fe99', 'ce38d379-7773-11f1-88cc-cf926f75fe99', 'ce31c0a4-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 2A', 'BSIT', 35, NULL, '2026-07-04 14:44:29'),
('ce490aa4-7773-11f1-88cc-cf926f75fe99', 'ce38d379-7773-11f1-88cc-cf926f75fe99', 'ce31c0a4-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 2B', 'BSIT', 35, NULL, '2026-07-04 14:44:29'),
('ce492a5a-7773-11f1-88cc-cf926f75fe99', 'ce38d379-7773-11f1-88cc-cf926f75fe99', 'ce31c0a4-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 2A', 'BEED', 26, NULL, '2026-07-04 14:44:29'),
('ce4959e5-7773-11f1-88cc-cf926f75fe99', 'ce38d379-7773-11f1-88cc-cf926f75fe99', 'ce31c0a4-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 2B', 'BEED', 25, NULL, '2026-07-04 14:44:29'),
('ce4983c6-7773-11f1-88cc-cf926f75fe99', 'ce34ee5c-7773-11f1-88cc-cf926f75fe99', 'ce31c0a4-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 1A', 'BEED', 35, NULL, '2026-07-04 14:44:29'),
('ce49a985-7773-11f1-88cc-cf926f75fe99', 'ce34ee5c-7773-11f1-88cc-cf926f75fe99', 'ce31c0a4-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 1B', 'BEED', 35, NULL, '2026-07-04 14:44:29'),
('ce49cb75-7773-11f1-88cc-cf926f75fe99', 'ce38eacf-7773-11f1-88cc-cf926f75fe99', 'ce31c0a4-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 2A', 'BEED', 26, NULL, '2026-07-04 14:44:29'),
('ce49eb8f-7773-11f1-88cc-cf926f75fe99', 'ce38eacf-7773-11f1-88cc-cf926f75fe99', 'ce31c0a4-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 2B', 'BEED', 25, NULL, '2026-07-04 14:44:29'),
('ce4a063e-7773-11f1-88cc-cf926f75fe99', 'ce39027c-7773-11f1-88cc-cf926f75fe99', 'ce31fabb-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 2A', 'BSIT', 35, NULL, '2026-07-04 14:44:29'),
('ce4a27dc-7773-11f1-88cc-cf926f75fe99', 'ce39027c-7773-11f1-88cc-cf926f75fe99', 'ce31fabb-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 2B', 'BSIT', 35, NULL, '2026-07-04 14:44:29'),
('ce4a47df-7773-11f1-88cc-cf926f75fe99', 'ce391dba-7773-11f1-88cc-cf926f75fe99', 'ce31fabb-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 2A', 'BSIT', 35, NULL, '2026-07-04 14:44:29'),
('ce4a672f-7773-11f1-88cc-cf926f75fe99', 'ce391dba-7773-11f1-88cc-cf926f75fe99', 'ce31fabb-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 2B', 'BSIT', 35, NULL, '2026-07-04 14:44:29'),
('ce4a8217-7773-11f1-88cc-cf926f75fe99', 'ce39460f-7773-11f1-88cc-cf926f75fe99', 'ce31fabb-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 3A', 'BSIT', 34, NULL, '2026-07-04 14:44:29'),
('ce4aa004-7773-11f1-88cc-cf926f75fe99', 'ce36bba0-7773-11f1-88cc-cf926f75fe99', 'ce32334d-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1A', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce4abaec-7773-11f1-88cc-cf926f75fe99', 'ce36bba0-7773-11f1-88cc-cf926f75fe99', 'ce32334d-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1B', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce4ad80e-7773-11f1-88cc-cf926f75fe99', 'ce39751b-7773-11f1-88cc-cf926f75fe99', 'ce32334d-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 3A', 'BSAB', 28, NULL, '2026-07-04 14:44:29'),
('ce4af327-7773-11f1-88cc-cf926f75fe99', 'ce39751b-7773-11f1-88cc-cf926f75fe99', 'ce32334d-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 3B', 'BSAB', 29, NULL, '2026-07-04 14:44:29'),
('ce4b11fe-7773-11f1-88cc-cf926f75fe99', 'ce39751b-7773-11f1-88cc-cf926f75fe99', 'ce32334d-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 3C', 'BSAB', 34, NULL, '2026-07-04 14:44:29'),
('ce4b36f4-7773-11f1-88cc-cf926f75fe99', 'ce3991d2-7773-11f1-88cc-cf926f75fe99', 'ce325e51-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1A', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce4b5a52-7773-11f1-88cc-cf926f75fe99', 'ce3991d2-7773-11f1-88cc-cf926f75fe99', 'ce325e51-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1B', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce4b7bf2-7773-11f1-88cc-cf926f75fe99', 'ce3991d2-7773-11f1-88cc-cf926f75fe99', 'ce325e51-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1C', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce4babcb-7773-11f1-88cc-cf926f75fe99', 'ce39a9fa-7773-11f1-88cc-cf926f75fe99', 'ce325e51-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 2A', 'BEED', 26, NULL, '2026-07-04 14:44:29'),
('ce4bcd10-7773-11f1-88cc-cf926f75fe99', 'ce39a9fa-7773-11f1-88cc-cf926f75fe99', 'ce325e51-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 2B', 'BEED', 25, NULL, '2026-07-04 14:44:29'),
('ce4beedd-7773-11f1-88cc-cf926f75fe99', 'ce389a84-7773-11f1-88cc-cf926f75fe99', 'ce325e51-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1A', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce4c11f8-7773-11f1-88cc-cf926f75fe99', 'ce389a84-7773-11f1-88cc-cf926f75fe99', 'ce325e51-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1B', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce4c3095-7773-11f1-88cc-cf926f75fe99', 'ce389a84-7773-11f1-88cc-cf926f75fe99', 'ce325e51-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSIT 1C', 'BSIT', 26, NULL, '2026-07-04 14:44:29'),
('ce4c51e8-7773-11f1-88cc-cf926f75fe99', 'ce39c27b-7773-11f1-88cc-cf926f75fe99', 'ce328cf4-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1A', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce4c708b-7773-11f1-88cc-cf926f75fe99', 'ce39c27b-7773-11f1-88cc-cf926f75fe99', 'ce328cf4-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1B', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce4c94dd-7773-11f1-88cc-cf926f75fe99', 'ce39c27b-7773-11f1-88cc-cf926f75fe99', 'ce328cf4-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1C', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce4cb7ae-7773-11f1-88cc-cf926f75fe99', 'ce3697da-7773-11f1-88cc-cf926f75fe99', 'ce328cf4-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2A', 'BSAB', 39, NULL, '2026-07-04 14:44:29'),
('ce4cd9f9-7773-11f1-88cc-cf926f75fe99', 'ce3697da-7773-11f1-88cc-cf926f75fe99', 'ce328cf4-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2B', 'BSAB', 41, NULL, '2026-07-04 14:44:29'),
('ce4cfbc3-7773-11f1-88cc-cf926f75fe99', 'ce39dd0a-7773-11f1-88cc-cf926f75fe99', 'ce32b35b-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2A', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce4d1c55-7773-11f1-88cc-cf926f75fe99', 'ce39dd0a-7773-11f1-88cc-cf926f75fe99', 'ce32b35b-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2B', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce4d3a85-7773-11f1-88cc-cf926f75fe99', 'ce39dd0a-7773-11f1-88cc-cf926f75fe99', 'ce32b35b-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 2C', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce4d585b-7773-11f1-88cc-cf926f75fe99', 'ce39f650-7773-11f1-88cc-cf926f75fe99', 'ce32b35b-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 1A', 'BEED', 35, NULL, '2026-07-04 14:44:29'),
('ce4d8277-7773-11f1-88cc-cf926f75fe99', 'ce39f650-7773-11f1-88cc-cf926f75fe99', 'ce32b35b-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 1B', 'BEED', 35, NULL, '2026-07-04 14:44:29'),
('ce4dabe2-7773-11f1-88cc-cf926f75fe99', 'ce38bda8-7773-11f1-88cc-cf926f75fe99', 'ce32b35b-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 1B', 'BEED', 35, NULL, '2026-07-04 14:44:29'),
('ce4dceac-7773-11f1-88cc-cf926f75fe99', 'ce3a1693-7773-11f1-88cc-cf926f75fe99', 'ce32e8db-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1A', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce4def4e-7773-11f1-88cc-cf926f75fe99', 'ce3a1693-7773-11f1-88cc-cf926f75fe99', 'ce32e8db-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1B', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce4e107e-7773-11f1-88cc-cf926f75fe99', 'ce3a1693-7773-11f1-88cc-cf926f75fe99', 'ce32e8db-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BSAB 1C', 'BSAB', 50, NULL, '2026-07-04 14:44:29'),
('ce4e3afc-7773-11f1-88cc-cf926f75fe99', 'ce3a1693-7773-11f1-88cc-cf926f75fe99', 'ce32e8db-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 2A', 'BEED', 26, NULL, '2026-07-04 14:44:29'),
('ce4e68a3-7773-11f1-88cc-cf926f75fe99', 'ce3a1693-7773-11f1-88cc-cf926f75fe99', 'ce32e8db-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 2B', 'BEED', 25, NULL, '2026-07-04 14:44:29'),
('ce4e8c03-7773-11f1-88cc-cf926f75fe99', 'ce3a2e2a-7773-11f1-88cc-cf926f75fe99', 'ce32e8db-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 2A', 'BEED', 26, NULL, '2026-07-04 14:44:29'),
('ce4eade3-7773-11f1-88cc-cf926f75fe99', 'ce3a2e2a-7773-11f1-88cc-cf926f75fe99', 'ce32e8db-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 2B', 'BEED', 25, NULL, '2026-07-04 14:44:29'),
('ce4ed671-7773-11f1-88cc-cf926f75fe99', 'ce334777-7773-11f1-88cc-cf926f75fe99', 'ce32e8db-7773-11f1-88cc-cf926f75fe99', 'FIRST SEMESTER', '2026-2027', 'BEED 2B', 'BEED', 25, NULL, '2026-07-04 14:44:29');

-- --------------------------------------------------------

--
-- Table structure for table `student_sentiments`
--

CREATE TABLE `student_sentiments` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `period_id` char(36) DEFAULT NULL,
  `section_id` char(36) DEFAULT NULL,
  `faculty_id` char(36) DEFAULT NULL,
  `student_id` char(36) DEFAULT NULL,
  `sentiment` enum('positive','neutral','negative') NOT NULL DEFAULT 'positive',
  `comments` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_sentiments`
--

INSERT INTO `student_sentiments` (`id`, `period_id`, `section_id`, `faculty_id`, `student_id`, `sentiment`, `comments`, `created_at`) VALUES
('99999999-9999-9999-9999-999999999901', '55555555-5555-5555-5555-555555555501', 'ce4ed671-7773-11f1-88cc-cf926f75fe99', 'ce32e8db-7773-11f1-88cc-cf926f75fe99', '22222222-2222-2222-2222-222222222204', 'positive', 'Great pacing and clear slides.', '2026-07-04 14:46:52'),
('99999999-9999-9999-9999-999999999902', '55555555-5555-5555-5555-555555555501', 'ce4ed671-7773-11f1-88cc-cf926f75fe99', 'ce32e8db-7773-11f1-88cc-cf926f75fe99', '22222222-2222-2222-2222-222222222204', 'neutral', 'Would like more examples in class.', '2026-07-04 14:46:52'),
('99999999-9999-9999-9999-999999999903', '55555555-5555-5555-5555-555555555501', 'ce4ed671-7773-11f1-88cc-cf926f75fe99', 'ce32e8db-7773-11f1-88cc-cf926f75fe99', '22222222-2222-2222-2222-222222222204', 'negative', 'Sometimes the discussion moves too quickly.', '2026-07-04 14:46:52');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_courses_code` (`code`),
  ADD KEY `fk_courses_department` (`department_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `evaluations`
--
ALTER TABLE `evaluations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_evaluations_assignment` (`assignment_id`);

--
-- Indexes for table `evaluation_periods`
--
ALTER TABLE `evaluation_periods`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `evaluation_responses`
--
ALTER TABLE `evaluation_responses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_eval_responses` (`evaluation_id`,`rubric_item_id`),
  ADD KEY `fk_responses_rubric_item` (`rubric_item_id`),
  ADD KEY `idx_eval_responses_eval` (`evaluation_id`);

--
-- Indexes for table `evaluator_assignments`
--
ALTER TABLE `evaluator_assignments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_assignments` (`period_id`,`section_id`,`faculty_id`,`evaluator_id`,`role`),
  ADD KEY `fk_assignments_section` (`section_id`),
  ADD KEY `idx_assignments_faculty` (`faculty_id`),
  ADD KEY `idx_assignments_evaluator` (`evaluator_id`);

--
-- Indexes for table `profiles`
--
ALTER TABLE `profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_profiles_department` (`department_id`);

--
-- Indexes for table `rubric_categories`
--
ALTER TABLE `rubric_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rubric_items`
--
ALTER TABLE `rubric_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_rubric_items_category` (`category_id`);

--
-- Indexes for table `sections`
--
ALTER TABLE `sections`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_sections_faculty` (`faculty_id`),
  ADD KEY `idx_sections_course` (`course_id`);

--
-- Indexes for table `student_sentiments`
--
ALTER TABLE `student_sentiments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_sentiments_period` (`period_id`),
  ADD KEY `fk_sentiments_section` (`section_id`),
  ADD KEY `fk_sentiments_student` (`student_id`),
  ADD KEY `idx_student_sentiment_faculty` (`faculty_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `fk_courses_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`);

--
-- Constraints for table `evaluations`
--
ALTER TABLE `evaluations`
  ADD CONSTRAINT `fk_evaluations_assignment` FOREIGN KEY (`assignment_id`) REFERENCES `evaluator_assignments` (`id`);

--
-- Constraints for table `evaluation_responses`
--
ALTER TABLE `evaluation_responses`
  ADD CONSTRAINT `fk_responses_evaluation` FOREIGN KEY (`evaluation_id`) REFERENCES `evaluations` (`id`),
  ADD CONSTRAINT `fk_responses_rubric_item` FOREIGN KEY (`rubric_item_id`) REFERENCES `rubric_items` (`id`);

--
-- Constraints for table `evaluator_assignments`
--
ALTER TABLE `evaluator_assignments`
  ADD CONSTRAINT `fk_assignments_evaluator` FOREIGN KEY (`evaluator_id`) REFERENCES `profiles` (`id`),
  ADD CONSTRAINT `fk_assignments_faculty` FOREIGN KEY (`faculty_id`) REFERENCES `profiles` (`id`),
  ADD CONSTRAINT `fk_assignments_period` FOREIGN KEY (`period_id`) REFERENCES `evaluation_periods` (`id`),
  ADD CONSTRAINT `fk_assignments_section` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`);

--
-- Constraints for table `profiles`
--
ALTER TABLE `profiles`
  ADD CONSTRAINT `fk_profiles_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`);

--
-- Constraints for table `rubric_items`
--
ALTER TABLE `rubric_items`
  ADD CONSTRAINT `fk_rubric_items_category` FOREIGN KEY (`category_id`) REFERENCES `rubric_categories` (`id`);

--
-- Constraints for table `sections`
--
ALTER TABLE `sections`
  ADD CONSTRAINT `fk_sections_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`),
  ADD CONSTRAINT `fk_sections_faculty` FOREIGN KEY (`faculty_id`) REFERENCES `profiles` (`id`);

--
-- Constraints for table `student_sentiments`
--
ALTER TABLE `student_sentiments`
  ADD CONSTRAINT `fk_sentiments_faculty` FOREIGN KEY (`faculty_id`) REFERENCES `profiles` (`id`),
  ADD CONSTRAINT `fk_sentiments_period` FOREIGN KEY (`period_id`) REFERENCES `evaluation_periods` (`id`),
  ADD CONSTRAINT `fk_sentiments_section` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`),
  ADD CONSTRAINT `fk_sentiments_student` FOREIGN KEY (`student_id`) REFERENCES `profiles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
