# Academic DB Upgrade Guide

This guide describes the database-only upgrade for academic analytics.
It is additive and designed to keep existing modules compatible.

## Scope
- Keep legacy tables unchanged for current business flows.
- Add normalized dimensions/facts for:
  - student personal analysis
  - class/major/college comparison
  - trend analysis by term
  - warning/risk analysis
  - agent-generated analysis persistence

## Files
- Baseline schema: `db.sql`
- Incremental upgrade: `db_academic_upgrade.sql`
- Runtime DB config: `src/main/resources/application.yml`

## Keep Existing Tables
- `user`
- `student`
- `teacher`
- `course`
- `learning_record`
- `coursevisit`

## Added Tables
- `schema_migration_log`
- `dim_college`
- `dim_major`
- `dim_class`
- `dim_term`
- `student_enrollment`
- `course_offering`
- `fact_course_score`
- `fact_term_gpa`
- `agg_cohort_stat`
- `fact_warning_event`
- `student_portrait`
- `agent_analysis_result`

## Added Fields
- `student.college_id`
- `student.major_id`
- `student.class_id`
- `student.grade_year`

## Why This Layout
- `dim_*` tables isolate educational hierarchy and term semantics.
- `fact_course_score` stores per-student-per-course-per-term performance.
- `fact_term_gpa` supports historical trend and rank analysis.
- `agg_cohort_stat` stores privacy-safe cohort aggregates (not raw peer details).
- `fact_warning_event` supports warning workflows and risk tracking.
- `student_portrait` supports fast agent context loading.
- `agent_analysis_result` records generated analysis/recommendations for traceability.

## Apply Order
1. Ensure target DB is `springboot_demo`.
2. Execute `db.sql` if initializing from scratch.
3. Execute `db_academic_upgrade.sql`.
4. Verify migration marker in `schema_migration_log`.

## Quick Verification SQL
```sql
SELECT migration_code, migration_name, executed_at
FROM schema_migration_log
WHERE migration_code = 'ACADEMIC_20260317_V1';

SHOW TABLES LIKE 'dim_term';
SHOW TABLES LIKE 'fact_course_score';
SHOW TABLES LIKE 'fact_term_gpa';
SHOW TABLES LIKE 'agg_cohort_stat';
SHOW TABLES LIKE 'fact_warning_event';
SHOW TABLES LIKE 'student_portrait';
SHOW TABLES LIKE 'agent_analysis_result';

SHOW COLUMNS FROM student LIKE 'college_id';
SHOW COLUMNS FROM student LIKE 'major_id';
SHOW COLUMNS FROM student LIKE 'class_id';
SHOW COLUMNS FROM student LIKE 'grade_year';
```

## Notes
- This upgrade does not replace legacy analytics tables immediately.
- Existing modules can keep using old tables while new analytics pipelines start writing to new fact tables.
- Backfill strategy can be rolled out in a later step without breaking current features.
