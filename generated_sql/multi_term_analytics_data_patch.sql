-- Multi-term data patch for analytics and semester-based warning.
-- Compatible changes only: add/fill data without deleting existing rows.

SET NAMES utf8mb4;
SET @db := DATABASE();

-- 1) Ensure learning_record has event_time / term_id (safe for repeated execution)
SET @has_event_time := (
    SELECT COUNT(1)
    FROM information_schema.columns
    WHERE table_schema = @db
      AND table_name = 'learning_record'
      AND column_name = 'event_time'
);
SET @sql_add_event_time := IF(
    @has_event_time = 0,
    'ALTER TABLE learning_record ADD COLUMN event_time DATETIME NULL COMMENT ''Unified event time'' AFTER check_in_time',
    'SELECT 1'
);
PREPARE stmt FROM @sql_add_event_time;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @has_term_id := (
    SELECT COUNT(1)
    FROM information_schema.columns
    WHERE table_schema = @db
      AND table_name = 'learning_record'
      AND column_name = 'term_id'
);
SET @sql_add_term_id := IF(
    @has_term_id = 0,
    'ALTER TABLE learning_record ADD COLUMN term_id BIGINT NULL COMMENT ''Term dimension id (dim_term.term_id)'' AFTER course_id',
    'SELECT 1'
);
PREPARE stmt FROM @sql_add_term_id;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE learning_record
SET event_time = COALESCE(event_time, check_in_time, last_updated)
WHERE event_time IS NULL;

UPDATE learning_record lr
LEFT JOIN dim_term dt
       ON DATE(COALESCE(lr.event_time, lr.check_in_time, lr.last_updated)) BETWEEN dt.start_date AND dt.end_date
SET lr.term_id = COALESCE(lr.term_id, dt.term_id)
WHERE lr.term_id IS NULL;

-- 2) Expand historical learning records for terms 2024-FALL / 2025-SPRING / 2025-FALL
-- Source rows are current term rows (term_id = 5). This keeps behavior metrics available by semester.
INSERT INTO learning_record (
    user_id,
    course_id,
    term_id,
    check_in_time,
    event_time,
    task_point_id,
    is_online,
    last_updated
)
SELECT
    lr.user_id,
    lr.course_id,
    t.term_id,
    CASE
        WHEN lr.check_in_time IS NULL THEN NULL
        ELSE DATE_ADD(lr.check_in_time, INTERVAL t.shift_days DAY)
    END AS check_in_time,
    DATE_ADD(COALESCE(lr.event_time, lr.check_in_time, lr.last_updated), INTERVAL t.shift_days DAY) AS event_time,
    lr.task_point_id,
    CASE
        WHEN MOD(lr.user_id + lr.course_id + t.term_id, 6) = 0 THEN 0
        WHEN MOD(lr.user_id + lr.course_id + t.term_id, 7) = 0 THEN 1
        ELSE lr.is_online
    END AS is_online,
    DATE_ADD(lr.last_updated, INTERVAL t.shift_days DAY) AS last_updated
FROM learning_record lr
JOIN (
    SELECT 2 AS term_id, -540 AS shift_days
    UNION ALL SELECT 3, -365
    UNION ALL SELECT 4, -180
) t ON 1 = 1
JOIN dim_term dt ON dt.term_id = t.term_id
LEFT JOIN learning_record chk
       ON chk.user_id = lr.user_id
      AND chk.course_id = lr.course_id
      AND chk.term_id = t.term_id
      AND chk.task_point_id <=> lr.task_point_id
      AND DATE(COALESCE(chk.event_time, chk.check_in_time, chk.last_updated)) =
          DATE(DATE_ADD(COALESCE(lr.event_time, lr.check_in_time, lr.last_updated), INTERVAL t.shift_days DAY))
WHERE lr.term_id = 5
  AND MOD(lr.record_id + t.term_id, 4) <> 0
  AND DATE(DATE_ADD(COALESCE(lr.event_time, lr.check_in_time, lr.last_updated), INTERVAL t.shift_days DAY))
      BETWEEN dt.start_date AND dt.end_date
  AND chk.record_id IS NULL;

-- 3) Seed multi-term score facts from learning behavior (idempotent)
INSERT INTO fact_course_score (
    student_id,
    course_id,
    term_id,
    offering_id,
    usual_score,
    final_score,
    gpa_point,
    rank_in_class,
    rank_in_major,
    is_passed,
    gmt_created,
    gmt_modified
)
SELECT
    sb.student_id,
    sb.course_id,
    sb.term_id,
    NULL AS offering_id,
    CAST(ROUND(GREATEST(45, LEAST(98, sb.final_score + (MOD(sb.student_id + sb.course_id + sb.term_id, 11) - 5))), 2) AS DECIMAL(5,2)) AS usual_score,
    sb.final_score,
    CASE
        WHEN sb.final_score >= 90 THEN 4.00
        WHEN sb.final_score >= 85 THEN 3.70
        WHEN sb.final_score >= 82 THEN 3.30
        WHEN sb.final_score >= 78 THEN 3.00
        WHEN sb.final_score >= 75 THEN 2.70
        WHEN sb.final_score >= 72 THEN 2.30
        WHEN sb.final_score >= 68 THEN 2.00
        WHEN sb.final_score >= 64 THEN 1.50
        WHEN sb.final_score >= 60 THEN 1.00
        ELSE 0.00
    END AS gpa_point,
    NULL AS rank_in_class,
    NULL AS rank_in_major,
    CASE WHEN sb.final_score >= 60 THEN 1 ELSE 0 END AS is_passed,
    TIMESTAMP(DATE_ADD(dt.end_date, INTERVAL -(MOD(sb.student_id + sb.course_id + sb.term_id, 30) + 1) DAY), '10:00:00') AS gmt_created,
    TIMESTAMP(DATE_ADD(dt.end_date, INTERVAL -(MOD(sb.student_id + sb.course_id + sb.term_id, 15) + 1) DAY), '10:00:00') AS gmt_modified
FROM (
    SELECT DISTINCT
        lr.user_id AS student_id,
        lr.course_id,
        lr.term_id,
        CAST(
            ROUND(
                GREATEST(
                    48,
                    LEAST(
                        96,
                        66
                        + MOD(lr.user_id * 17 + lr.course_id * 7 + lr.term_id * 13, 31)
                        + CASE lr.term_id
                            WHEN 2 THEN -3
                            WHEN 3 THEN -1
                            WHEN 4 THEN 1
                            WHEN 5 THEN 3
                            ELSE 0
                          END
                    )
                ),
                2
            ) AS DECIMAL(5,2)
        ) AS final_score
    FROM learning_record lr
    WHERE lr.term_id IN (2, 3, 4, 5)
) sb
JOIN dim_term dt ON dt.term_id = sb.term_id
LEFT JOIN fact_course_score fcs
       ON fcs.student_id = sb.student_id
      AND fcs.course_id = sb.course_id
      AND fcs.term_id = sb.term_id
WHERE fcs.score_id IS NULL;

-- 4) Seed academic warning events per semester (idempotent)
INSERT INTO fact_warning_event (
    student_id,
    term_id,
    warning_type,
    warning_level,
    risk_score,
    status,
    opened_at,
    resolved_at,
    handler,
    remark,
    gmt_created,
    gmt_modified
)
SELECT
    agg.student_id,
    agg.term_id,
    'academic_warning' AS warning_type,
    CASE
        WHEN agg.avg_score < 60 OR agg.fail_courses >= 2 THEN 'high'
        WHEN agg.avg_score < 68 OR agg.fail_courses = 1 THEN 'medium'
        ELSE 'low'
    END AS warning_level,
    ROUND(GREATEST(8, (72 - agg.avg_score) * 1.6 + agg.fail_courses * 12 + (1 - agg.online_rate) * 20), 2) AS risk_score,
    CASE
        WHEN agg.term_id < 5 THEN 'resolved'
        WHEN agg.avg_score < 65 OR agg.fail_courses > 0 THEN 'open'
        ELSE 'resolved'
    END AS status,
    TIMESTAMP(DATE_ADD(dt.start_date, INTERVAL 45 DAY), '09:00:00') AS opened_at,
    CASE
        WHEN agg.term_id < 5 OR agg.avg_score >= 65
            THEN TIMESTAMP(DATE_ADD(dt.end_date, INTERVAL -7 DAY), '16:00:00')
        ELSE NULL
    END AS resolved_at,
    CASE
        WHEN agg.term_id < 5 OR agg.avg_score >= 65 THEN 'system'
        ELSE NULL
    END AS handler,
    CONCAT('avg=', ROUND(agg.avg_score, 1), ', failed=', agg.fail_courses, ', online=', ROUND(agg.online_rate * 100, 1), '%') AS remark,
    NOW() AS gmt_created,
    NOW() AS gmt_modified
FROM (
    SELECT
        f.student_id,
        f.term_id,
        AVG(f.final_score) AS avg_score,
        SUM(CASE WHEN f.final_score < 60 THEN 1 ELSE 0 END) AS fail_courses,
        COALESCE(AVG(CASE WHEN lr.is_online = 1 THEN 1 ELSE 0 END), 0) AS online_rate
    FROM fact_course_score f
    LEFT JOIN learning_record lr
           ON lr.user_id = f.student_id
          AND lr.term_id = f.term_id
    WHERE f.term_id IN (2, 3, 4, 5)
    GROUP BY f.student_id, f.term_id
    HAVING AVG(f.final_score) < 72
        OR SUM(CASE WHEN f.final_score < 60 THEN 1 ELSE 0 END) > 0
) agg
JOIN dim_term dt ON dt.term_id = agg.term_id
LEFT JOIN fact_warning_event ex
       ON ex.student_id = agg.student_id
      AND ex.term_id = agg.term_id
      AND ex.warning_type = 'academic_warning'
WHERE ex.warning_id IS NULL;

-- 5) Seed behavior warning events per semester (idempotent)
INSERT INTO fact_warning_event (
    student_id,
    term_id,
    warning_type,
    warning_level,
    risk_score,
    status,
    opened_at,
    resolved_at,
    handler,
    remark,
    gmt_created,
    gmt_modified
)
SELECT
    b.student_id,
    b.term_id,
    'behavior_warning' AS warning_type,
    CASE
        WHEN b.visit_count < 2 OR b.online_rate < 0.20 THEN 'high'
        ELSE 'medium'
    END AS warning_level,
    ROUND(GREATEST(8, (3 - b.visit_count) * 6 + (0.35 - b.online_rate) * 40 + b.missing_checkin * 3), 2) AS risk_score,
    CASE WHEN b.term_id < 5 THEN 'resolved' ELSE 'open' END AS status,
    TIMESTAMP(DATE_ADD(dt.start_date, INTERVAL 30 DAY), '09:00:00') AS opened_at,
    CASE WHEN b.term_id < 5 THEN TIMESTAMP(DATE_ADD(dt.end_date, INTERVAL -10 DAY), '16:00:00') ELSE NULL END AS resolved_at,
    CASE WHEN b.term_id < 5 THEN 'system' ELSE NULL END AS handler,
    CONCAT('visits=', b.visit_count, ', online=', ROUND(b.online_rate * 100, 1), '%, missed_checkin=', b.missing_checkin) AS remark,
    NOW() AS gmt_created,
    NOW() AS gmt_modified
FROM (
    SELECT
        lr.user_id AS student_id,
        lr.term_id,
        COUNT(*) AS visit_count,
        COALESCE(AVG(CASE WHEN lr.is_online = 1 THEN 1 ELSE 0 END), 0) AS online_rate,
        SUM(CASE WHEN lr.check_in_time IS NULL THEN 1 ELSE 0 END) AS missing_checkin
    FROM learning_record lr
    WHERE lr.term_id IN (2, 3, 4, 5)
    GROUP BY lr.user_id, lr.term_id
    HAVING COUNT(*) < 3
        OR COALESCE(AVG(CASE WHEN lr.is_online = 1 THEN 1 ELSE 0 END), 0) < 0.35
) b
JOIN dim_term dt ON dt.term_id = b.term_id
LEFT JOIN fact_warning_event ex
       ON ex.student_id = b.student_id
      AND ex.term_id = b.term_id
      AND ex.warning_type = 'behavior_warning'
WHERE ex.warning_id IS NULL;
