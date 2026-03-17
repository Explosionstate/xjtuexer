/*
 Incremental schema upgrade for academic analytics.
 This script is additive and keeps existing tables/interfaces compatible.
 Target database: springboot_demo (MySQL 8+)
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS `schema_migration_log` (
                                                      `id` bigint NOT NULL AUTO_INCREMENT,
                                                      `migration_code` varchar(64) NOT NULL,
    `migration_name` varchar(128) NOT NULL,
    `executed_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_schema_migration_code` (`migration_code`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Schema migration log';

-- ------------------------------------------------------------
-- Dimension tables
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `dim_college` (
                                             `college_id` bigint NOT NULL AUTO_INCREMENT,
                                             `college_code` varchar(32) NOT NULL,
    `college_name` varchar(128) NOT NULL,
    `is_active` tinyint(1) NOT NULL DEFAULT 1,
    `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`college_id`),
    UNIQUE KEY `uq_dim_college_code` (`college_code`),
    UNIQUE KEY `uq_dim_college_name` (`college_name`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='College dimension';

CREATE TABLE IF NOT EXISTS `dim_major` (
                                           `major_id` bigint NOT NULL AUTO_INCREMENT,
                                           `college_id` bigint NOT NULL,
                                           `major_code` varchar(32) NOT NULL,
    `major_name` varchar(128) NOT NULL,
    `is_active` tinyint(1) NOT NULL DEFAULT 1,
    `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`major_id`),
    UNIQUE KEY `uq_dim_major_code` (`major_code`),
    UNIQUE KEY `uq_dim_major_college_name` (`college_id`, `major_name`),
    KEY `idx_dim_major_college` (`college_id`),
    CONSTRAINT `fk_dim_major_college` FOREIGN KEY (`college_id`) REFERENCES `dim_college` (`college_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Major dimension';

CREATE TABLE IF NOT EXISTS `dim_class` (
                                           `class_id` bigint NOT NULL AUTO_INCREMENT,
                                           `major_id` bigint NOT NULL,
                                           `class_code` varchar(32) NOT NULL,
    `class_name` varchar(128) NOT NULL,
    `grade_year` smallint DEFAULT NULL,
    `is_active` tinyint(1) NOT NULL DEFAULT 1,
    `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`class_id`),
    UNIQUE KEY `uq_dim_class_code` (`class_code`),
    UNIQUE KEY `uq_dim_class_major_name` (`major_id`, `class_name`),
    KEY `idx_dim_class_major` (`major_id`),
    KEY `idx_dim_class_grade` (`grade_year`),
    CONSTRAINT `fk_dim_class_major` FOREIGN KEY (`major_id`) REFERENCES `dim_major` (`major_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Class dimension';

CREATE TABLE IF NOT EXISTS `dim_term` (
                                          `term_id` bigint NOT NULL AUTO_INCREMENT,
                                          `term_code` varchar(32) NOT NULL,
    `term_name` varchar(64) NOT NULL,
    `academic_year` int NOT NULL,
    `term_no` tinyint NOT NULL,
    `start_date` date DEFAULT NULL,
    `end_date` date DEFAULT NULL,
    `status` varchar(16) NOT NULL DEFAULT 'planned',
    `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`term_id`),
    UNIQUE KEY `uq_dim_term_code` (`term_code`),
    UNIQUE KEY `uq_dim_term_year_no` (`academic_year`, `term_no`),
    KEY `idx_dim_term_status` (`status`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Term dimension';

-- ------------------------------------------------------------
-- FIX: Add bridge columns to legacy student table safely
-- ------------------------------------------------------------
SET @sql = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM information_schema.columns
      WHERE table_schema = DATABASE()
        AND table_name = 'student'
        AND column_name = 'college_id'
    ),
    'SELECT ''college_id already exists''',
    'ALTER TABLE `student` ADD COLUMN `college_id` bigint NULL AFTER `college`'
  )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM information_schema.columns
      WHERE table_schema = DATABASE()
        AND table_name = 'student'
        AND column_name = 'major_id'
    ),
    'SELECT ''major_id already exists''',
    'ALTER TABLE `student` ADD COLUMN `major_id` bigint NULL AFTER `college_id`'
  )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM information_schema.columns
      WHERE table_schema = DATABASE()
        AND table_name = 'student'
        AND column_name = 'class_id'
    ),
    'SELECT ''class_id already exists''',
    'ALTER TABLE `student` ADD COLUMN `class_id` bigint NULL AFTER `major_id`'
  )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM information_schema.columns
      WHERE table_schema = DATABASE()
        AND table_name = 'student'
        AND column_name = 'grade_year'
    ),
    'SELECT ''grade_year already exists''',
    'ALTER TABLE `student` ADD COLUMN `grade_year` smallint NULL AFTER `class_id`'
  )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ------------------------------------------------------------
-- Enrollment and teaching organization
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `student_enrollment` (
                                                    `enrollment_id` bigint NOT NULL AUTO_INCREMENT,
                                                    `student_id` bigint NOT NULL,
                                                    `college_id` bigint DEFAULT NULL,
                                                    `major_id` bigint DEFAULT NULL,
                                                    `class_id` bigint DEFAULT NULL,
                                                    `grade_year` smallint DEFAULT NULL,
                                                    `start_term_id` bigint DEFAULT NULL,
                                                    `end_term_id` bigint DEFAULT NULL,
                                                    `status` varchar(16) NOT NULL DEFAULT 'active',
    `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`enrollment_id`),
    KEY `idx_student_enrollment_student` (`student_id`),
    KEY `idx_student_enrollment_status` (`status`),
    KEY `idx_student_enrollment_college_major_class` (`college_id`, `major_id`, `class_id`),
    CONSTRAINT `fk_student_enrollment_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT `fk_student_enrollment_college` FOREIGN KEY (`college_id`) REFERENCES `dim_college` (`college_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
    CONSTRAINT `fk_student_enrollment_major` FOREIGN KEY (`major_id`) REFERENCES `dim_major` (`major_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
    CONSTRAINT `fk_student_enrollment_class` FOREIGN KEY (`class_id`) REFERENCES `dim_class` (`class_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
    CONSTRAINT `fk_student_enrollment_start_term` FOREIGN KEY (`start_term_id`) REFERENCES `dim_term` (`term_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
    CONSTRAINT `fk_student_enrollment_end_term` FOREIGN KEY (`end_term_id`) REFERENCES `dim_term` (`term_id`) ON DELETE SET NULL ON UPDATE RESTRICT
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Student enrollment history';

CREATE TABLE IF NOT EXISTS `course_offering` (
                                                 `offering_id` bigint NOT NULL AUTO_INCREMENT,
                                                 `course_id` bigint NOT NULL,
                                                 `term_id` bigint NOT NULL,
                                                 `teacher_id` bigint NOT NULL,
                                                 `class_id` bigint DEFAULT NULL,
                                                 `credit` decimal(4,1) DEFAULT NULL,
    `assessment_type` varchar(32) DEFAULT NULL,
    `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`offering_id`),
    UNIQUE KEY `uq_course_offering_unique` (`course_id`, `term_id`, `teacher_id`, `class_id`),
    KEY `idx_course_offering_term` (`term_id`),
    KEY `idx_course_offering_class` (`class_id`),
    CONSTRAINT `fk_course_offering_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `fk_course_offering_term` FOREIGN KEY (`term_id`) REFERENCES `dim_term` (`term_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `fk_course_offering_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `fk_course_offering_class` FOREIGN KEY (`class_id`) REFERENCES `dim_class` (`class_id`) ON DELETE SET NULL ON UPDATE RESTRICT
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Course offering by term';

-- 下面其余 fact / agg / portrait / analysis 表保持你原样即可
-- 不需要改动

-- ------------------------------------------------------------
-- Fact / aggregate / portrait tables
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `fact_course_score` (
                                                    `score_id` bigint NOT NULL AUTO_INCREMENT,
                                                    `student_id` bigint NOT NULL,
                                                    `course_id` bigint NOT NULL,
                                                    `term_id` bigint NOT NULL,
                                                    `offering_id` bigint DEFAULT NULL,
                                                    `usual_score` decimal(5,2) DEFAULT NULL,
    `final_score` decimal(5,2) NOT NULL,
    `gpa_point` decimal(4,2) DEFAULT NULL,
    `rank_in_class` int DEFAULT NULL,
    `rank_in_major` int DEFAULT NULL,
    `is_passed` tinyint(1) NOT NULL DEFAULT 1,
    `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`score_id`),
    UNIQUE KEY `uq_fact_course_score` (`student_id`, `course_id`, `term_id`),
    KEY `idx_fact_course_score_term` (`term_id`),
    KEY `idx_fact_course_score_course` (`course_id`),
    KEY `idx_fact_course_score_student` (`student_id`),
    CONSTRAINT `fk_fact_course_score_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT `fk_fact_course_score_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `fk_fact_course_score_term` FOREIGN KEY (`term_id`) REFERENCES `dim_term` (`term_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `fk_fact_course_score_offering` FOREIGN KEY (`offering_id`) REFERENCES `course_offering` (`offering_id`) ON DELETE SET NULL ON UPDATE RESTRICT
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Per student per course score by term';

CREATE TABLE IF NOT EXISTS `fact_term_gpa` (
                                                `term_gpa_id` bigint NOT NULL AUTO_INCREMENT,
                                                `student_id` bigint NOT NULL,
                                                `term_id` bigint NOT NULL,
                                                `avg_score` decimal(5,2) DEFAULT NULL,
    `gpa` decimal(4,2) DEFAULT NULL,
    `total_credits` decimal(6,2) DEFAULT NULL,
    `passed_credits` decimal(6,2) DEFAULT NULL,
    `class_rank` int DEFAULT NULL,
    `major_rank` int DEFAULT NULL,
    `college_rank` int DEFAULT NULL,
    `cohort_size` int DEFAULT NULL,
    `class_id` bigint DEFAULT NULL,
    `major_id` bigint DEFAULT NULL,
    `college_id` bigint DEFAULT NULL,
    `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`term_gpa_id`),
    UNIQUE KEY `uq_fact_term_gpa` (`student_id`, `term_id`),
    KEY `idx_fact_term_gpa_term` (`term_id`),
    KEY `idx_fact_term_gpa_class` (`class_id`),
    KEY `idx_fact_term_gpa_major` (`major_id`),
    KEY `idx_fact_term_gpa_college` (`college_id`),
    CONSTRAINT `fk_fact_term_gpa_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT `fk_fact_term_gpa_term` FOREIGN KEY (`term_id`) REFERENCES `dim_term` (`term_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `fk_fact_term_gpa_class` FOREIGN KEY (`class_id`) REFERENCES `dim_class` (`class_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
    CONSTRAINT `fk_fact_term_gpa_major` FOREIGN KEY (`major_id`) REFERENCES `dim_major` (`major_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
    CONSTRAINT `fk_fact_term_gpa_college` FOREIGN KEY (`college_id`) REFERENCES `dim_college` (`college_id`) ON DELETE SET NULL ON UPDATE RESTRICT
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Student term-level GPA/score facts';

CREATE TABLE IF NOT EXISTS `agg_cohort_stat` (
                                                  `agg_id` bigint NOT NULL AUTO_INCREMENT,
                                                  `term_id` bigint NOT NULL,
                                                  `scope_type` varchar(16) NOT NULL COMMENT 'class/major/college',
    `scope_id` bigint NOT NULL,
    `course_id` bigint DEFAULT NULL,
    `metric_type` varchar(32) NOT NULL DEFAULT 'term_gpa',
    `sample_size` int NOT NULL DEFAULT 0,
    `avg_score` decimal(5,2) DEFAULT NULL,
    `avg_gpa` decimal(4,2) DEFAULT NULL,
    `pass_rate` decimal(5,2) DEFAULT NULL,
    `excellent_rate` decimal(5,2) DEFAULT NULL,
    `failure_rate` decimal(5,2) DEFAULT NULL,
    `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`agg_id`),
    UNIQUE KEY `uq_agg_scope_metric` (`term_id`, `scope_type`, `scope_id`, `course_id`, `metric_type`),
    KEY `idx_agg_scope` (`scope_type`, `scope_id`),
    CONSTRAINT `fk_agg_cohort_stat_term` FOREIGN KEY (`term_id`) REFERENCES `dim_term` (`term_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Privacy-safe cohort aggregates';

CREATE TABLE IF NOT EXISTS `fact_warning_event` (
                                                     `warning_id` bigint NOT NULL AUTO_INCREMENT,
                                                     `student_id` bigint NOT NULL,
                                                     `term_id` bigint DEFAULT NULL,
                                                     `warning_type` varchar(64) NOT NULL,
    `warning_level` varchar(16) NOT NULL DEFAULT 'low',
    `risk_score` decimal(6,2) NOT NULL DEFAULT 0,
    `status` varchar(16) NOT NULL DEFAULT 'open',
    `opened_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `resolved_at` datetime DEFAULT NULL,
    `handler` varchar(64) DEFAULT NULL,
    `remark` varchar(512) DEFAULT NULL,
    `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`warning_id`),
    KEY `idx_fact_warning_event_student` (`student_id`),
    KEY `idx_fact_warning_event_term` (`term_id`),
    KEY `idx_fact_warning_event_status` (`status`),
    CONSTRAINT `fk_fact_warning_event_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT `fk_fact_warning_event_term` FOREIGN KEY (`term_id`) REFERENCES `dim_term` (`term_id`) ON DELETE SET NULL ON UPDATE RESTRICT
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Student warning events';

CREATE TABLE IF NOT EXISTS `student_portrait` (
                                                   `portrait_id` bigint NOT NULL AUTO_INCREMENT,
                                                   `student_id` bigint NOT NULL,
                                                   `learning_index` decimal(6,2) DEFAULT NULL,
    `cumulative_avg_score` decimal(5,2) DEFAULT NULL,
    `cumulative_gpa` decimal(4,2) DEFAULT NULL,
    `total_credits` decimal(6,2) DEFAULT NULL,
    `passed_credits` decimal(6,2) DEFAULT NULL,
    `failed_course_count` int DEFAULT NULL,
    `risk_level` varchar(16) DEFAULT NULL,
    `portrait_json` json DEFAULT NULL,
    `snapshot_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`portrait_id`),
    UNIQUE KEY `uq_student_portrait_student` (`student_id`),
    KEY `idx_student_portrait_risk` (`risk_level`),
    CONSTRAINT `fk_student_portrait_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE ON UPDATE RESTRICT
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Student portrait snapshot';

CREATE TABLE IF NOT EXISTS `agent_analysis_result` (
                                                       `analysis_id` bigint NOT NULL AUTO_INCREMENT,
                                                       `student_id` bigint NOT NULL,
                                                       `term_id` bigint DEFAULT NULL,
                                                       `analysis_type` varchar(32) NOT NULL DEFAULT 'academic',
    `risk_level` varchar(16) DEFAULT NULL,
    `summary_text` text,
    `findings_json` json DEFAULT NULL,
    `recommendations_json` json DEFAULT NULL,
    `model_name` varchar(64) DEFAULT NULL,
    `generated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`analysis_id`),
    KEY `idx_agent_analysis_student` (`student_id`),
    KEY `idx_agent_analysis_term` (`term_id`),
    KEY `idx_agent_analysis_type` (`analysis_type`),
    CONSTRAINT `fk_agent_analysis_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT `fk_agent_analysis_term` FOREIGN KEY (`term_id`) REFERENCES `dim_term` (`term_id`) ON DELETE SET NULL ON UPDATE RESTRICT
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Persisted agent analysis results';

-- ------------------------------------------------------------
-- Seed a default term for immediate availability (idempotent)
-- ------------------------------------------------------------
INSERT INTO `dim_term` (`term_code`, `term_name`, `academic_year`, `term_no`, `status`)
VALUES ('2025-FALL', '2025-2026学年第一学期', 2025, 1, 'current')
ON DUPLICATE KEY UPDATE
    `term_name` = VALUES(`term_name`),
    `status` = VALUES(`status`),
    `gmt_modified` = CURRENT_TIMESTAMP;

INSERT INTO `schema_migration_log` (`migration_code`, `migration_name`)
VALUES ('ACADEMIC_20260317_V1', 'Academic analytics schema incremental upgrade')
ON DUPLICATE KEY UPDATE
    `migration_name` = VALUES(`migration_name`),
    `executed_at` = CURRENT_TIMESTAMP;

SET FOREIGN_KEY_CHECKS = 1;
