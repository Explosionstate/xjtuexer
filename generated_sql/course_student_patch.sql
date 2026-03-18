CREATE TABLE IF NOT EXISTS `course_student` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `course_id` bigint NOT NULL,
    `student_id` bigint NOT NULL,
    `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_course_student` (`course_id`, `student_id`),
    KEY `idx_course_student_student` (`student_id`),
    CONSTRAINT `fk_course_student_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT `fk_course_student_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT IGNORE INTO `course_student` (`course_id`, `student_id`)
SELECT DISTINCT lr.course_id, lr.user_id
FROM `learning_record` lr
UNION
SELECT DISTINCT fcs.course_id, fcs.student_id
FROM `fact_course_score` fcs;
