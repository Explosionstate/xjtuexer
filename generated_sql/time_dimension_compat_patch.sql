-- Compatibility patch for analytics time filtering
-- Goal: enhance time-dimension support without deleting/changing existing business data.
-- Safe principles:
-- 1) no DROP TABLE / TRUNCATE / DELETE
-- 2) only additive schema changes + backfill
-- 3) existing data remains available

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 1;

-- 1) learning_record: add event_time for unified time filtering
SET @has_event_time := (
    SELECT COUNT(1)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'learning_record'
      AND column_name = 'event_time'
);
SET @sql_event_time := IF(
    @has_event_time = 0,
    'ALTER TABLE learning_record ADD COLUMN event_time DATETIME NULL COMMENT ''Unified event time'' AFTER check_in_time',
    'SELECT 1'
);
PREPARE stmt FROM @sql_event_time;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Backfill event_time (non-destructive)
UPDATE learning_record
SET event_time = COALESCE(event_time, check_in_time, last_updated)
WHERE event_time IS NULL;

-- 2) learning_record: add term_id relation to dim_term
SET @has_term_id := (
    SELECT COUNT(1)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'learning_record'
      AND column_name = 'term_id'
);
SET @sql_term_id := IF(
    @has_term_id = 0,
    'ALTER TABLE learning_record ADD COLUMN term_id BIGINT NULL COMMENT ''Term dimension id (dim_term.term_id)'' AFTER course_id',
    'SELECT 1'
);
PREPARE stmt FROM @sql_term_id;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Backfill term_id from dim_term date range (non-destructive)
UPDATE learning_record lr
LEFT JOIN dim_term dt
       ON DATE(COALESCE(lr.event_time, lr.check_in_time, lr.last_updated)) BETWEEN dt.start_date AND dt.end_date
SET lr.term_id = COALESCE(lr.term_id, dt.term_id)
WHERE lr.term_id IS NULL;

-- 3) additive indexes for time-based query performance
SET @has_idx_event_time := (
    SELECT COUNT(1)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'learning_record'
      AND index_name = 'idx_learning_record_event_time'
);
SET @sql_idx_event_time := IF(
    @has_idx_event_time = 0,
    'ALTER TABLE learning_record ADD INDEX idx_learning_record_event_time (event_time)',
    'SELECT 1'
);
PREPARE stmt FROM @sql_idx_event_time;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @has_idx_lr_term := (
    SELECT COUNT(1)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'learning_record'
      AND index_name = 'idx_learning_record_term'
);
SET @sql_idx_lr_term := IF(
    @has_idx_lr_term = 0,
    'ALTER TABLE learning_record ADD INDEX idx_learning_record_term (term_id)',
    'SELECT 1'
);
PREPARE stmt FROM @sql_idx_lr_term;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @has_idx_warning_opened := (
    SELECT COUNT(1)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'fact_warning_event'
      AND index_name = 'idx_fact_warning_event_opened_at'
);
SET @sql_idx_warning_opened := IF(
    @has_idx_warning_opened = 0,
    'ALTER TABLE fact_warning_event ADD INDEX idx_fact_warning_event_opened_at (opened_at)',
    'SELECT 1'
);
PREPARE stmt FROM @sql_idx_warning_opened;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @has_idx_score_created := (
    SELECT COUNT(1)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'fact_course_score'
      AND index_name = 'idx_fact_course_score_created'
);
SET @sql_idx_score_created := IF(
    @has_idx_score_created = 0,
    'ALTER TABLE fact_course_score ADD INDEX idx_fact_course_score_created (gmt_created)',
    'SELECT 1'
);
PREPARE stmt FROM @sql_idx_score_created;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4) add foreign key only if absent
SET @has_fk_lr_term := (
    SELECT COUNT(1)
    FROM information_schema.referential_constraints
    WHERE constraint_schema = DATABASE()
      AND table_name = 'learning_record'
      AND constraint_name = 'fk_learning_record_term'
);
SET @sql_fk_lr_term := IF(
    @has_fk_lr_term = 0,
    'ALTER TABLE learning_record ADD CONSTRAINT fk_learning_record_term FOREIGN KEY (term_id) REFERENCES dim_term(term_id) ON DELETE SET NULL ON UPDATE RESTRICT',
    'SELECT 1'
);
PREPARE stmt FROM @sql_fk_lr_term;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 5) ensure event_time remains usable for historical null values
UPDATE learning_record
SET event_time = COALESCE(check_in_time, last_updated)
WHERE event_time IS NULL;