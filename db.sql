/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80043 (8.0.43)
 Source Host           : localhost:3306
 Source Schema         : springboot_demo

 Target Server Type    : MySQL
 Target Server Version : 80043 (8.0.43)
 File Encoding         : 65001

 Date: 19/03/2026 09:23:47
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin_user
-- ----------------------------
DROP TABLE IF EXISTS `admin_user`;
CREATE TABLE `admin_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??ID',
  `login_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '??????',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '???????????????????Spring Security???{id}encodedPassword?',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '??????',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '??',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '?????0=??1=??',
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `avatar` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '??',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_admin_user_login_name`(`login_name` ASC) USING BTREE,
  INDEX `idx_admin_user_is_deleted`(`is_deleted` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '??????' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of admin_user
-- ----------------------------
INSERT INTO `admin_user` VALUES (3, 'admin1', '120000:5P7vaGb6mvUwC5U1xDqCWA==:ZaVXcyYZFol9oOfK3BSauAPH5mP9rvUoEjcrcxdSEb8=', '2026-03-18 15:56:55', '教务数据管理员', 0, '2026-03-18 11:04:01', '2026-03-18 11:23:55', NULL);
INSERT INTO `admin_user` VALUES (4, 'admin2', 'admin2', '2026-03-17 13:36:00', '教学运营管理员', 0, '2026-03-18 11:04:01', '2026-03-18 11:24:08', NULL);
INSERT INTO `admin_user` VALUES (5, 'admin3', 'admin3', '2026-03-18 08:45:00', '平台管理员', 0, '2026-03-18 11:04:01', '2026-03-18 11:24:10', NULL);

-- ----------------------------
-- Table structure for admin_user_menu
-- ----------------------------
DROP TABLE IF EXISTS `admin_user_menu`;
CREATE TABLE `admin_user_menu`  (
  `admin_user_id` bigint NOT NULL COMMENT '???ID?admin_user.id?',
  `menu_id` bigint NOT NULL COMMENT '??ID?sys_menu.menu_id?',
  PRIMARY KEY (`admin_user_id`, `menu_id`) USING BTREE,
  INDEX `fk_admin_user_menu_menu`(`menu_id` ASC) USING BTREE,
  CONSTRAINT `fk_admin_user_menu_admin` FOREIGN KEY (`admin_user_id`) REFERENCES `admin_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_admin_user_menu_menu` FOREIGN KEY (`menu_id`) REFERENCES `sys_menu` (`menu_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '????????' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of admin_user_menu
-- ----------------------------
INSERT INTO `admin_user_menu` VALUES (3, 1);
INSERT INTO `admin_user_menu` VALUES (5, 1);
INSERT INTO `admin_user_menu` VALUES (3, 2);
INSERT INTO `admin_user_menu` VALUES (4, 2);
INSERT INTO `admin_user_menu` VALUES (5, 2);
INSERT INTO `admin_user_menu` VALUES (3, 3);
INSERT INTO `admin_user_menu` VALUES (4, 3);
INSERT INTO `admin_user_menu` VALUES (5, 3);
INSERT INTO `admin_user_menu` VALUES (3, 4);
INSERT INTO `admin_user_menu` VALUES (4, 4);
INSERT INTO `admin_user_menu` VALUES (5, 4);
INSERT INTO `admin_user_menu` VALUES (4, 5);
INSERT INTO `admin_user_menu` VALUES (5, 5);
INSERT INTO `admin_user_menu` VALUES (4, 6);
INSERT INTO `admin_user_menu` VALUES (5, 6);
INSERT INTO `admin_user_menu` VALUES (4, 7);
INSERT INTO `admin_user_menu` VALUES (5, 7);

-- ----------------------------
-- Table structure for admin_user_permission
-- ----------------------------
DROP TABLE IF EXISTS `admin_user_permission`;
CREATE TABLE `admin_user_permission`  (
  `admin_user_id` bigint NOT NULL COMMENT '???ID',
  `perm_id` bigint NOT NULL COMMENT '??ID',
  PRIMARY KEY (`admin_user_id`, `perm_id`) USING BTREE,
  INDEX `idx_admin_user_permission_perm_id`(`perm_id` ASC) USING BTREE,
  CONSTRAINT `fk_admin_user_permission_admin` FOREIGN KEY (`admin_user_id`) REFERENCES `admin_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_admin_user_permission_perm` FOREIGN KEY (`perm_id`) REFERENCES `sys_permission` (`perm_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '????????' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of admin_user_permission
-- ----------------------------
INSERT INTO `admin_user_permission` VALUES (3, 101);
INSERT INTO `admin_user_permission` VALUES (5, 101);
INSERT INTO `admin_user_permission` VALUES (3, 102);
INSERT INTO `admin_user_permission` VALUES (5, 102);
INSERT INTO `admin_user_permission` VALUES (3, 103);
INSERT INTO `admin_user_permission` VALUES (5, 103);
INSERT INTO `admin_user_permission` VALUES (3, 201);
INSERT INTO `admin_user_permission` VALUES (4, 201);
INSERT INTO `admin_user_permission` VALUES (5, 201);
INSERT INTO `admin_user_permission` VALUES (3, 202);
INSERT INTO `admin_user_permission` VALUES (4, 202);
INSERT INTO `admin_user_permission` VALUES (5, 202);
INSERT INTO `admin_user_permission` VALUES (3, 203);
INSERT INTO `admin_user_permission` VALUES (4, 203);
INSERT INTO `admin_user_permission` VALUES (5, 203);
INSERT INTO `admin_user_permission` VALUES (4, 301);
INSERT INTO `admin_user_permission` VALUES (5, 301);
INSERT INTO `admin_user_permission` VALUES (4, 302);
INSERT INTO `admin_user_permission` VALUES (5, 302);
INSERT INTO `admin_user_permission` VALUES (4, 303);
INSERT INTO `admin_user_permission` VALUES (5, 303);
INSERT INTO `admin_user_permission` VALUES (4, 304);
INSERT INTO `admin_user_permission` VALUES (5, 304);
INSERT INTO `admin_user_permission` VALUES (4, 305);
INSERT INTO `admin_user_permission` VALUES (5, 305);

-- ----------------------------
-- Table structure for agent_analysis_result
-- ----------------------------
DROP TABLE IF EXISTS `agent_analysis_result`;
CREATE TABLE `agent_analysis_result`  (
  `analysis_id` bigint NOT NULL AUTO_INCREMENT,
  `student_id` bigint NOT NULL,
  `term_id` bigint NULL DEFAULT NULL,
  `analysis_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'academic',
  `risk_level` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `summary_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `findings_json` json NULL,
  `recommendations_json` json NULL,
  `model_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `generated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`analysis_id`) USING BTREE,
  INDEX `idx_agent_analysis_student`(`student_id` ASC) USING BTREE,
  INDEX `idx_agent_analysis_term`(`term_id` ASC) USING BTREE,
  INDEX `idx_agent_analysis_type`(`analysis_type` ASC) USING BTREE,
  CONSTRAINT `fk_agent_analysis_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_agent_analysis_term` FOREIGN KEY (`term_id`) REFERENCES `dim_term` (`term_id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1024 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Persisted agent analysis results' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of agent_analysis_result
-- ----------------------------

-- ----------------------------
-- Table structure for agg_cohort_stat
-- ----------------------------
DROP TABLE IF EXISTS `agg_cohort_stat`;
CREATE TABLE `agg_cohort_stat`  (
  `agg_id` bigint NOT NULL AUTO_INCREMENT,
  `term_id` bigint NOT NULL,
  `scope_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'class/major/college',
  `scope_id` bigint NOT NULL,
  `course_id` bigint NULL DEFAULT NULL,
  `metric_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'term_gpa',
  `sample_size` int NOT NULL DEFAULT 0,
  `avg_score` decimal(5, 2) NULL DEFAULT NULL,
  `avg_gpa` decimal(4, 2) NULL DEFAULT NULL,
  `pass_rate` decimal(5, 2) NULL DEFAULT NULL,
  `excellent_rate` decimal(5, 2) NULL DEFAULT NULL,
  `failure_rate` decimal(5, 2) NULL DEFAULT NULL,
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`agg_id`) USING BTREE,
  UNIQUE INDEX `uq_agg_scope_metric`(`term_id` ASC, `scope_type` ASC, `scope_id` ASC, `course_id` ASC, `metric_type` ASC) USING BTREE,
  INDEX `idx_agg_scope`(`scope_type` ASC, `scope_id` ASC) USING BTREE,
  CONSTRAINT `fk_agg_cohort_stat_term` FOREIGN KEY (`term_id`) REFERENCES `dim_term` (`term_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 255 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Privacy-safe cohort aggregates' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of agg_cohort_stat
-- ----------------------------

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
  `course_id` bigint NOT NULL AUTO_INCREMENT COMMENT '??ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '????',
  `teacher_id` bigint NOT NULL COMMENT '??ID?teacher.teacher_id?',
  `chapters` json NULL COMMENT '?????JSON???',
  `materials` json NULL COMMENT '?????JSON???',
  `task_points` json NULL COMMENT '??????JSON???',
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `chapters_count` int GENERATED ALWAYS AS (json_length(`chapters`)) VIRTUAL COMMENT '???(???)' NULL,
  `materials_count` int GENERATED ALWAYS AS (json_length(`materials`)) VIRTUAL COMMENT '???(???)' NULL,
  `task_points_count` int GENERATED ALWAYS AS (json_length(`task_points`)) VIRTUAL COMMENT '????(???)' NULL,
  PRIMARY KEY (`course_id`) USING BTREE,
  UNIQUE INDEX `uq_course_course_teacher`(`course_id` ASC, `teacher_id` ASC) USING BTREE,
  INDEX `idx_course_teacher_id`(`teacher_id` ASC) USING BTREE,
  INDEX `idx_course_chapters_count`(`chapters_count` ASC) USING BTREE,
  INDEX `idx_course_materials_count`(`materials_count` ASC) USING BTREE,
  INDEX `idx_course_task_points_count`(`task_points_count` ASC) USING BTREE,
  CONSTRAINT `fk_course_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '???' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES (1, '思想道德与法治', 1101, '[\"导论：青年成长与法治中国\", \"理想信念与价值引领\", \"公民责任与社会规范\", \"网络文明与实践行动\"]', '[\"课程导学PPT\", \"法治案例集\", \"青年成长读本\"]', '[\"课堂签到\", \"法治案例测验\", \"主题讨论\", \"实践反思\"]', '2026-03-18 11:04:01', '2026-03-18 11:04:01', DEFAULT, DEFAULT, DEFAULT);
INSERT INTO `course` VALUES (2, '中国近现代史纲要', 1102, '[\"晚清变局与民族危机\", \"新民主主义革命道路\", \"新中国成立与建设探索\", \"改革开放与民族复兴\"]', '[\"历史文献选编\", \"专题微课视频\", \"课程导学讲义\"]', '[\"课堂签到\", \"章节测验\", \"史料阅读\", \"课程小结\"]', '2026-03-18 11:04:01', '2026-03-18 11:04:01', DEFAULT, DEFAULT, DEFAULT);
INSERT INTO `course` VALUES (3, '形势与政策', 1103, '[\"时政热点导读\", \"国家发展观察\", \"青年责任与时代选择\"]', '[\"时政资料包\", \"热点评论参考\", \"课堂讨论提纲\"]', '[\"课堂签到\", \"热点追踪\", \"专题发言\", \"政策评论\"]', '2026-03-18 11:04:01', '2026-03-18 11:04:01', DEFAULT, DEFAULT, DEFAULT);
INSERT INTO `course` VALUES (4, '马克思主义基本原理', 1104, '[\"世界的物质性\", \"实践与认识\", \"社会历史发展规律\", \"资本主义批判与现实意义\"]', '[\"原理课程讲义\", \"章节思维导图\", \"讨论资料\"]', '[\"课堂签到\", \"概念测验\", \"理论讨论\", \"单元总结\"]', '2026-03-18 11:04:01', '2026-03-18 11:04:01', DEFAULT, DEFAULT, DEFAULT);
INSERT INTO `course` VALUES (5, '毛泽东思想和中国特色社会主义理论体系概论', 1105, '[\"理论体系形成发展\", \"毛泽东思想核心内容\", \"中国特色社会主义理论体系\", \"当代中国发展道路\"]', '[\"理论体系教材摘要\", \"课堂讨论提纲\", \"经典文献摘编\"]', '[\"课堂签到\", \"章节测验\", \"课堂辩论\", \"课程反思\"]', '2026-03-18 11:04:01', '2026-03-18 11:04:01', DEFAULT, DEFAULT, DEFAULT);
INSERT INTO `course` VALUES (6, '习近平新时代中国特色社会主义思想概论', 1106, '[\"新时代十年的伟大变革\", \"以人民为中心的发展思想\", \"中国式现代化\", \"青年使命与担当\"]', '[\"理论学习手册\", \"新时代案例读本\", \"课程复习提要\"]', '[\"课堂签到\", \"理论问答\", \"主题讨论\", \"课程论文\"]', '2026-03-18 11:04:01', '2026-03-18 11:04:01', DEFAULT, DEFAULT, DEFAULT);
INSERT INTO `course` VALUES (7, '国家安全教育', 1121, '[\"总体国家安全观\", \"网络与数据安全\", \"校园安全与风险防范\", \"公共安全与应急意识\"]', '[\"国家安全教育读本\", \"主题短视频\", \"案例分析模板\"]', '[\"课堂签到\", \"知识打卡\", \"场景推演\", \"课程小结\"]', '2026-03-18 11:04:01', '2026-03-18 11:04:01', DEFAULT, DEFAULT, DEFAULT);
INSERT INTO `course` VALUES (8, '工程伦理与科技报国', 1130, '[\"工程伦理基本框架\", \"科技创新与国家战略\", \"学术规范与责任边界\", \"案例研讨与团队汇报\"]', '[\"工程伦理案例库\", \"科技报国人物素材\", \"分组汇报模板\"]', '[\"课堂签到\", \"案例分析\", \"小组汇报\", \"总结反思\"]', '2026-03-18 11:04:01', '2026-03-18 11:04:01', DEFAULT, DEFAULT, DEFAULT);

-- ----------------------------
-- Table structure for course_offering
-- ----------------------------
DROP TABLE IF EXISTS `course_offering`;
CREATE TABLE `course_offering`  (
  `offering_id` bigint NOT NULL AUTO_INCREMENT,
  `course_id` bigint NOT NULL,
  `term_id` bigint NOT NULL,
  `teacher_id` bigint NOT NULL,
  `class_id` bigint NULL DEFAULT NULL,
  `credit` decimal(4, 1) NULL DEFAULT NULL,
  `assessment_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`offering_id`) USING BTREE,
  UNIQUE INDEX `uq_course_offering_unique`(`course_id` ASC, `term_id` ASC, `teacher_id` ASC, `class_id` ASC) USING BTREE,
  INDEX `idx_course_offering_term`(`term_id` ASC) USING BTREE,
  INDEX `idx_course_offering_class`(`class_id` ASC) USING BTREE,
  INDEX `fk_course_offering_teacher`(`teacher_id` ASC) USING BTREE,
  CONSTRAINT `fk_course_offering_class` FOREIGN KEY (`class_id`) REFERENCES `dim_class` (`class_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_course_offering_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_course_offering_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_course_offering_term` FOREIGN KEY (`term_id`) REFERENCES `dim_term` (`term_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 128 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Course offering by term' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of course_offering
-- ----------------------------
INSERT INTO `course_offering` VALUES (1, 1, 4, 1101, 1, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (2, 1, 4, 1101, 2, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (3, 1, 4, 1101, 3, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (4, 1, 4, 1101, 4, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (5, 1, 4, 1101, 5, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (6, 1, 4, 1101, 6, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (7, 1, 4, 1101, 7, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (8, 1, 4, 1101, 8, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (9, 1, 4, 1101, 9, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (10, 1, 4, 1101, 10, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (11, 1, 4, 1101, 11, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (12, 1, 4, 1101, 12, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (13, 2, 5, 1102, 1, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (14, 2, 5, 1102, 2, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (15, 2, 5, 1102, 3, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (16, 2, 5, 1102, 4, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (17, 2, 5, 1102, 5, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (18, 2, 5, 1102, 6, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (19, 2, 5, 1102, 7, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (20, 2, 5, 1102, 8, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (21, 2, 5, 1102, 9, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (22, 2, 5, 1102, 10, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (23, 2, 5, 1102, 11, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (24, 2, 5, 1102, 12, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (25, 3, 4, 1103, 13, 2.0, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (26, 3, 4, 1103, 14, 2.0, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (27, 3, 4, 1103, 15, 2.0, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (28, 3, 4, 1103, 16, 2.0, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (29, 3, 4, 1103, 17, 2.0, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (30, 3, 4, 1103, 18, 2.0, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (31, 3, 4, 1103, 19, 2.0, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (32, 3, 4, 1103, 20, 2.0, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (33, 3, 4, 1103, 21, 2.0, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (34, 3, 4, 1103, 22, 2.0, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (35, 3, 4, 1103, 23, 2.0, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (36, 3, 4, 1103, 24, 2.0, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (37, 4, 5, 1104, 13, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (38, 4, 5, 1104, 14, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (39, 4, 5, 1104, 15, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (40, 4, 5, 1104, 16, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (41, 4, 5, 1104, 17, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (42, 4, 5, 1104, 18, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (43, 4, 5, 1104, 19, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (44, 4, 5, 1104, 20, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (45, 4, 5, 1104, 21, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (46, 4, 5, 1104, 22, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (47, 4, 5, 1104, 23, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (48, 4, 5, 1104, 24, 3.0, 'exam-paper', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (49, 5, 4, 1105, 25, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (50, 5, 4, 1105, 26, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (51, 5, 4, 1105, 27, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (52, 5, 4, 1105, 28, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (53, 5, 4, 1105, 29, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (54, 5, 4, 1105, 30, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (55, 5, 4, 1105, 31, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (56, 5, 4, 1105, 32, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (57, 5, 4, 1105, 33, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (58, 5, 4, 1105, 34, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (59, 5, 4, 1105, 35, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (60, 5, 4, 1105, 36, 3.0, 'mixed-assessment', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (61, 6, 5, 1106, 25, 2.5, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (62, 6, 5, 1106, 26, 2.5, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (63, 6, 5, 1106, 27, 2.5, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (64, 6, 5, 1106, 28, 2.5, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (65, 6, 5, 1106, 29, 2.5, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (66, 6, 5, 1106, 30, 2.5, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (67, 6, 5, 1106, 31, 2.5, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (68, 6, 5, 1106, 32, 2.5, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (69, 6, 5, 1106, 33, 2.5, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (70, 6, 5, 1106, 34, 2.5, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (71, 6, 5, 1106, 35, 2.5, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (72, 6, 5, 1106, 36, 2.5, 'seminar-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (73, 7, 4, 1121, 37, 2.0, 'topic-discussion', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (74, 7, 4, 1121, 38, 2.0, 'topic-discussion', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (75, 7, 4, 1121, 39, 2.0, 'topic-discussion', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (76, 7, 4, 1121, 40, 2.0, 'topic-discussion', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (77, 7, 4, 1121, 41, 2.0, 'topic-discussion', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (78, 7, 4, 1121, 42, 2.0, 'topic-discussion', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (79, 7, 4, 1121, 43, 2.0, 'topic-discussion', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (80, 7, 4, 1121, 44, 2.0, 'topic-discussion', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (81, 7, 4, 1121, 45, 2.0, 'topic-discussion', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (82, 7, 4, 1121, 46, 2.0, 'topic-discussion', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (83, 7, 4, 1121, 47, 2.0, 'topic-discussion', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (84, 7, 4, 1121, 48, 2.0, 'topic-discussion', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (85, 8, 5, 1130, 37, 2.0, 'project-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (86, 8, 5, 1130, 38, 2.0, 'project-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (87, 8, 5, 1130, 39, 2.0, 'project-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (88, 8, 5, 1130, 40, 2.0, 'project-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (89, 8, 5, 1130, 41, 2.0, 'project-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (90, 8, 5, 1130, 42, 2.0, 'project-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (91, 8, 5, 1130, 43, 2.0, 'project-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (92, 8, 5, 1130, 44, 2.0, 'project-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (93, 8, 5, 1130, 45, 2.0, 'project-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (94, 8, 5, 1130, 46, 2.0, 'project-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (95, 8, 5, 1130, 47, 2.0, 'project-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `course_offering` VALUES (96, 8, 5, 1130, 48, 2.0, 'project-report', '2026-03-18 11:04:01', '2026-03-18 11:04:01');

-- ----------------------------
-- Table structure for course_student
-- ----------------------------
DROP TABLE IF EXISTS `course_student`;
CREATE TABLE `course_student`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `course_id` bigint NOT NULL,
  `student_id` bigint NOT NULL,
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_course_student`(`course_id` ASC, `student_id` ASC) USING BTREE,
  INDEX `idx_course_student_student`(`student_id` ASC) USING BTREE,
  CONSTRAINT `fk_course_student_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_course_student_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1025 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course_student
-- ----------------------------
INSERT INTO `course_student` VALUES (1, 1, 2101, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (2, 2, 2101, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (3, 3, 2102, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (4, 4, 2102, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (5, 5, 2103, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (6, 6, 2103, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (7, 7, 2104, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (8, 8, 2104, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (9, 1, 2105, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (10, 2, 2105, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (11, 3, 2106, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (12, 4, 2106, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (13, 5, 2107, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (14, 6, 2107, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (15, 7, 2108, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (16, 8, 2108, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (17, 1, 2109, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (18, 2, 2109, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (19, 3, 2110, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (20, 4, 2110, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (21, 5, 2111, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (22, 6, 2111, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (23, 7, 2112, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (24, 8, 2112, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (25, 1, 2113, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (26, 2, 2113, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (27, 3, 2114, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (28, 4, 2114, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (29, 5, 2115, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (30, 6, 2115, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (31, 7, 2116, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (32, 8, 2116, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (33, 1, 2117, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (34, 2, 2117, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (35, 3, 2118, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (36, 4, 2118, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (37, 5, 2119, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (38, 6, 2119, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (39, 7, 2120, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (40, 8, 2120, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (41, 1, 2121, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (42, 2, 2121, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (43, 3, 2122, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (44, 4, 2122, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (45, 5, 2123, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (46, 6, 2123, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (47, 7, 2124, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (48, 8, 2124, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (49, 1, 2125, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (50, 2, 2125, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (51, 3, 2126, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (52, 4, 2126, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (53, 5, 2127, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (54, 6, 2127, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (55, 7, 2128, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (56, 8, 2128, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (57, 1, 2129, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (58, 2, 2129, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (59, 3, 2130, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (60, 4, 2130, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (61, 5, 2131, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (62, 6, 2131, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (63, 7, 2132, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (64, 8, 2132, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (65, 1, 2133, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (66, 2, 2133, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (67, 3, 2134, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (68, 4, 2134, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (69, 5, 2135, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (70, 6, 2135, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (71, 7, 2136, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (72, 8, 2136, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (73, 1, 2137, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (74, 2, 2137, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (75, 3, 2138, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (76, 4, 2138, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (77, 5, 2139, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (78, 6, 2139, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (79, 7, 2140, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (80, 8, 2140, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (81, 1, 2141, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (82, 2, 2141, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (83, 3, 2142, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (84, 4, 2142, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (85, 1, 2143, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (86, 2, 2143, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (87, 3, 2144, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (88, 4, 2144, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (89, 5, 2145, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (90, 6, 2145, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (91, 7, 2146, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (92, 8, 2146, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (93, 1, 2147, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (94, 2, 2147, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (95, 3, 2148, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (96, 4, 2148, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (97, 5, 2149, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (98, 6, 2149, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (99, 7, 2150, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (100, 8, 2150, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (101, 1, 2151, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (102, 2, 2151, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (103, 3, 2152, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (104, 4, 2152, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (105, 5, 2153, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (106, 6, 2153, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (107, 7, 2154, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (108, 8, 2154, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (109, 1, 2155, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (110, 2, 2155, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (111, 3, 2156, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (112, 4, 2156, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (113, 5, 2157, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (114, 6, 2157, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (115, 7, 2158, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (116, 8, 2158, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (117, 1, 2159, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (118, 2, 2159, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (119, 3, 2160, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (120, 4, 2160, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (121, 5, 2161, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (122, 6, 2161, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (123, 7, 2162, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (124, 8, 2162, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (125, 1, 2163, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (126, 2, 2163, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (127, 3, 2164, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (128, 4, 2164, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (129, 5, 2165, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (130, 6, 2165, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (131, 7, 2166, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (132, 8, 2166, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (133, 1, 2167, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (134, 2, 2167, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (135, 3, 2168, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (136, 4, 2168, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (137, 5, 2169, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (138, 6, 2169, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (139, 7, 2170, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (140, 8, 2170, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (141, 1, 2171, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (142, 2, 2171, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (143, 3, 2172, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (144, 4, 2172, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (145, 5, 2173, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (146, 6, 2173, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (147, 7, 2174, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (148, 8, 2174, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (149, 1, 2175, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (150, 2, 2175, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (151, 3, 2176, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (152, 4, 2176, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (153, 5, 2177, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (154, 6, 2177, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (155, 7, 2178, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (156, 8, 2178, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (157, 1, 2179, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (158, 2, 2179, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (159, 3, 2180, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (160, 4, 2180, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (161, 5, 2181, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (162, 6, 2181, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (163, 7, 2182, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (164, 8, 2182, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (165, 1, 2183, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (166, 2, 2183, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (167, 3, 2184, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (168, 4, 2184, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (169, 1, 2185, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (170, 2, 2185, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (171, 3, 2186, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (172, 4, 2186, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (173, 5, 2187, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (174, 6, 2187, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (175, 7, 2188, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (176, 8, 2188, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (177, 1, 2189, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (178, 2, 2189, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (179, 3, 2190, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (180, 4, 2190, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (181, 5, 2191, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (182, 6, 2191, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (183, 7, 2192, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (184, 8, 2192, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (185, 1, 2193, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (186, 2, 2193, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (187, 3, 2194, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (188, 4, 2194, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (189, 5, 2195, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (190, 6, 2195, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (191, 7, 2196, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (192, 8, 2196, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (193, 1, 2197, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (194, 2, 2197, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (195, 3, 2198, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (196, 4, 2198, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (197, 5, 2199, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (198, 6, 2199, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (199, 7, 2200, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (200, 8, 2200, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (201, 1, 2201, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (202, 2, 2201, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (203, 3, 2202, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (204, 4, 2202, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (205, 5, 2203, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (206, 6, 2203, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (207, 7, 2204, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (208, 8, 2204, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (209, 1, 2205, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (210, 2, 2205, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (211, 3, 2206, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (212, 4, 2206, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (213, 5, 2207, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (214, 6, 2207, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (215, 7, 2208, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (216, 8, 2208, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (217, 1, 2209, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (218, 2, 2209, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (219, 3, 2210, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (220, 4, 2210, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (221, 5, 2211, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (222, 6, 2211, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (223, 7, 2212, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (224, 8, 2212, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (225, 1, 2213, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (226, 2, 2213, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (227, 3, 2214, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (228, 4, 2214, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (229, 5, 2215, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (230, 6, 2215, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (231, 7, 2216, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (232, 8, 2216, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (233, 1, 2217, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (234, 2, 2217, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (235, 3, 2218, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (236, 4, 2218, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (237, 5, 2219, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (238, 6, 2219, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (239, 7, 2220, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (240, 8, 2220, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (241, 1, 2221, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (242, 2, 2221, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (243, 3, 2222, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (244, 4, 2222, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (245, 5, 2223, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (246, 6, 2223, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (247, 7, 2224, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (248, 8, 2224, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (249, 1, 2225, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (250, 2, 2225, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (251, 3, 2226, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (252, 4, 2226, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (253, 1, 2227, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (254, 2, 2227, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (255, 3, 2228, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (256, 4, 2228, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (257, 5, 2229, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (258, 6, 2229, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (259, 7, 2230, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (260, 8, 2230, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (261, 1, 2231, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (262, 2, 2231, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (263, 3, 2232, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (264, 4, 2232, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (265, 5, 2233, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (266, 6, 2233, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (267, 7, 2234, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (268, 8, 2234, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (269, 1, 2235, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (270, 2, 2235, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (271, 3, 2236, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (272, 4, 2236, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (273, 5, 2237, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (274, 6, 2237, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (275, 7, 2238, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (276, 8, 2238, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (277, 1, 2239, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (278, 2, 2239, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (279, 3, 2240, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (280, 4, 2240, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (281, 5, 2241, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (282, 6, 2241, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (283, 7, 2242, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (284, 8, 2242, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (285, 1, 2243, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (286, 2, 2243, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (287, 3, 2244, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (288, 4, 2244, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (289, 5, 2245, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (290, 6, 2245, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (291, 7, 2246, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (292, 8, 2246, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (293, 1, 2247, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (294, 2, 2247, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (295, 3, 2248, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (296, 4, 2248, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (297, 5, 2249, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (298, 6, 2249, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (299, 7, 2250, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (300, 8, 2250, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (301, 1, 2251, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (302, 2, 2251, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (303, 3, 2252, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (304, 4, 2252, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (305, 5, 2253, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (306, 6, 2253, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (307, 7, 2254, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (308, 8, 2254, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (309, 1, 2255, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (310, 2, 2255, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (311, 3, 2256, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (312, 4, 2256, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (313, 5, 2257, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (314, 6, 2257, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (315, 7, 2258, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (316, 8, 2258, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (317, 1, 2259, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (318, 2, 2259, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (319, 3, 2260, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (320, 4, 2260, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (321, 5, 2261, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (322, 6, 2261, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (323, 7, 2262, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (324, 8, 2262, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (325, 1, 2263, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (326, 2, 2263, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (327, 3, 2264, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (328, 4, 2264, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (329, 5, 2265, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (330, 6, 2265, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (331, 7, 2266, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (332, 8, 2266, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (333, 1, 2267, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (334, 2, 2267, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (335, 3, 2268, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (336, 4, 2268, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (337, 1, 2269, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (338, 2, 2269, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (339, 3, 2270, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (340, 4, 2270, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (341, 5, 2271, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (342, 6, 2271, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (343, 7, 2272, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (344, 8, 2272, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (345, 1, 2273, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (346, 2, 2273, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (347, 3, 2274, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (348, 4, 2274, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (349, 5, 2275, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (350, 6, 2275, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (351, 7, 2276, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (352, 8, 2276, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (353, 1, 2277, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (354, 2, 2277, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (355, 3, 2278, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (356, 4, 2278, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (357, 5, 2279, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (358, 6, 2279, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (359, 7, 2280, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (360, 8, 2280, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (361, 1, 2281, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (362, 2, 2281, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (363, 3, 2282, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (364, 4, 2282, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (365, 5, 2283, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (366, 6, 2283, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (367, 7, 2284, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (368, 8, 2284, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (369, 1, 2285, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (370, 2, 2285, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (371, 3, 2286, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (372, 4, 2286, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (373, 5, 2287, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (374, 6, 2287, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (375, 7, 2288, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (376, 8, 2288, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (377, 1, 2289, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (378, 2, 2289, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (379, 3, 2290, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (380, 4, 2290, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (381, 5, 2291, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (382, 6, 2291, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (383, 7, 2292, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (384, 8, 2292, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (385, 1, 2293, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (386, 2, 2293, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (387, 3, 2294, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (388, 4, 2294, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (389, 5, 2295, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (390, 6, 2295, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (391, 7, 2296, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (392, 8, 2296, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (393, 1, 2297, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (394, 2, 2297, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (395, 3, 2298, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (396, 4, 2298, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (397, 5, 2299, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (398, 6, 2299, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (399, 7, 2300, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (400, 8, 2300, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (401, 1, 2301, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (402, 2, 2301, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (403, 3, 2302, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (404, 4, 2302, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (405, 5, 2303, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (406, 6, 2303, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (407, 7, 2304, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (408, 8, 2304, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (409, 1, 2305, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (410, 2, 2305, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (411, 3, 2306, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (412, 4, 2306, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (413, 5, 2307, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (414, 6, 2307, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (415, 7, 2308, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (416, 8, 2308, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (417, 1, 2309, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (418, 2, 2309, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (419, 3, 2310, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (420, 4, 2310, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (421, 1, 2311, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (422, 2, 2311, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (423, 3, 2312, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (424, 4, 2312, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (425, 5, 2313, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (426, 6, 2313, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (427, 7, 2314, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (428, 8, 2314, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (429, 1, 2315, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (430, 2, 2315, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (431, 3, 2316, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (432, 4, 2316, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (433, 5, 2317, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (434, 6, 2317, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (435, 7, 2318, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (436, 8, 2318, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (437, 1, 2319, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (438, 2, 2319, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (439, 3, 2320, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (440, 4, 2320, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (441, 5, 2321, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (442, 6, 2321, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (443, 7, 2322, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (444, 8, 2322, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (445, 1, 2323, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (446, 2, 2323, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (447, 3, 2324, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (448, 4, 2324, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (449, 5, 2325, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (450, 6, 2325, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (451, 7, 2326, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (452, 8, 2326, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (453, 1, 2327, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (454, 2, 2327, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (455, 3, 2328, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (456, 4, 2328, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (457, 5, 2329, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (458, 6, 2329, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (459, 7, 2330, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (460, 8, 2330, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (461, 1, 2331, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (462, 2, 2331, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (463, 3, 2332, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (464, 4, 2332, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (465, 5, 2333, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (466, 6, 2333, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (467, 7, 2334, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (468, 8, 2334, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (469, 1, 2335, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (470, 2, 2335, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (471, 3, 2336, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (472, 4, 2336, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (473, 5, 2337, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (474, 6, 2337, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (475, 7, 2338, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (476, 8, 2338, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (477, 1, 2339, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (478, 2, 2339, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (479, 3, 2340, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (480, 4, 2340, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (481, 5, 2341, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (482, 6, 2341, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (483, 7, 2342, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (484, 8, 2342, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (485, 1, 2343, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (486, 2, 2343, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (487, 3, 2344, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (488, 4, 2344, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (489, 5, 2345, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (490, 6, 2345, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (491, 7, 2346, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (492, 8, 2346, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (493, 1, 2347, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (494, 2, 2347, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (495, 3, 2348, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (496, 4, 2348, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (497, 5, 2349, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (498, 6, 2349, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (499, 7, 2350, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (500, 8, 2350, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (501, 1, 2351, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (502, 2, 2351, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (503, 3, 2352, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (504, 4, 2352, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (505, 1, 2353, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (506, 2, 2353, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (507, 3, 2354, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (508, 4, 2354, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (509, 5, 2355, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (510, 6, 2355, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (511, 7, 2356, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (512, 8, 2356, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (513, 1, 2357, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (514, 2, 2357, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (515, 3, 2358, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (516, 4, 2358, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (517, 5, 2359, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (518, 6, 2359, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (519, 7, 2360, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (520, 8, 2360, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (521, 1, 2361, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (522, 2, 2361, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (523, 3, 2362, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (524, 4, 2362, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (525, 5, 2363, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (526, 6, 2363, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (527, 7, 2364, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (528, 8, 2364, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (529, 1, 2365, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (530, 2, 2365, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (531, 3, 2366, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (532, 4, 2366, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (533, 5, 2367, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (534, 6, 2367, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (535, 7, 2368, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (536, 8, 2368, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (537, 1, 2369, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (538, 2, 2369, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (539, 3, 2370, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (540, 4, 2370, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (541, 5, 2371, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (542, 6, 2371, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (543, 7, 2372, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (544, 8, 2372, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (545, 1, 2373, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (546, 2, 2373, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (547, 3, 2374, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (548, 4, 2374, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (549, 5, 2375, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (550, 6, 2375, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (551, 7, 2376, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (552, 8, 2376, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (553, 1, 2377, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (554, 2, 2377, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (555, 3, 2378, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (556, 4, 2378, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (557, 5, 2379, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (558, 6, 2379, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (559, 7, 2380, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (560, 8, 2380, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (561, 1, 2381, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (562, 2, 2381, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (563, 3, 2382, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (564, 4, 2382, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (565, 5, 2383, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (566, 6, 2383, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (567, 7, 2384, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (568, 8, 2384, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (569, 1, 2385, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (570, 2, 2385, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (571, 3, 2386, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (572, 4, 2386, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (573, 5, 2387, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (574, 6, 2387, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (575, 7, 2388, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (576, 8, 2388, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (577, 1, 2389, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (578, 2, 2389, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (579, 3, 2390, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (580, 4, 2390, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (581, 5, 2391, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (582, 6, 2391, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (583, 7, 2392, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (584, 8, 2392, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (585, 1, 2393, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (586, 2, 2393, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (587, 3, 2394, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (588, 4, 2394, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (589, 1, 2395, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (590, 2, 2395, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (591, 3, 2396, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (592, 4, 2396, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (593, 5, 2397, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (594, 6, 2397, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (595, 7, 2398, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (596, 8, 2398, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (597, 1, 2399, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (598, 2, 2399, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (599, 3, 2400, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (600, 4, 2400, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (601, 5, 2401, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (602, 6, 2401, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (603, 7, 2402, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (604, 8, 2402, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (605, 1, 2403, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (606, 2, 2403, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (607, 3, 2404, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (608, 4, 2404, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (609, 5, 2405, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (610, 6, 2405, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (611, 7, 2406, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (612, 8, 2406, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (613, 1, 2407, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (614, 2, 2407, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (615, 3, 2408, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (616, 4, 2408, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (617, 5, 2409, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (618, 6, 2409, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (619, 7, 2410, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (620, 8, 2410, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (621, 1, 2411, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (622, 2, 2411, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (623, 3, 2412, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (624, 4, 2412, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (625, 5, 2413, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (626, 6, 2413, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (627, 7, 2414, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (628, 8, 2414, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (629, 1, 2415, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (630, 2, 2415, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (631, 3, 2416, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (632, 4, 2416, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (633, 5, 2417, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (634, 6, 2417, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (635, 7, 2418, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (636, 8, 2418, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (637, 1, 2419, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (638, 2, 2419, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (639, 3, 2420, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (640, 4, 2420, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (641, 5, 2421, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (642, 6, 2421, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (643, 7, 2422, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (644, 8, 2422, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (645, 1, 2423, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (646, 2, 2423, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (647, 3, 2424, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (648, 4, 2424, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (649, 5, 2425, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (650, 6, 2425, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (651, 7, 2426, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (652, 8, 2426, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (653, 1, 2427, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (654, 2, 2427, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (655, 3, 2428, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (656, 4, 2428, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (657, 5, 2429, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (658, 6, 2429, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (659, 7, 2430, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (660, 8, 2430, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (661, 1, 2431, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (662, 2, 2431, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (663, 3, 2432, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (664, 4, 2432, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (665, 5, 2433, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (666, 6, 2433, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (667, 7, 2434, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (668, 8, 2434, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (669, 1, 2435, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (670, 2, 2435, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (671, 3, 2436, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (672, 4, 2436, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (673, 1, 2437, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (674, 2, 2437, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (675, 3, 2438, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (676, 4, 2438, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (677, 5, 2439, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (678, 6, 2439, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (679, 7, 2440, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (680, 8, 2440, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (681, 1, 2441, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (682, 2, 2441, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (683, 3, 2442, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (684, 4, 2442, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (685, 5, 2443, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (686, 6, 2443, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (687, 7, 2444, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (688, 8, 2444, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (689, 1, 2445, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (690, 2, 2445, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (691, 3, 2446, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (692, 4, 2446, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (693, 5, 2447, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (694, 6, 2447, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (695, 7, 2448, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (696, 8, 2448, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (697, 1, 2449, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (698, 2, 2449, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (699, 3, 2450, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (700, 4, 2450, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (701, 5, 2451, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (702, 6, 2451, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (703, 7, 2452, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (704, 8, 2452, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (705, 1, 2453, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (706, 2, 2453, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (707, 3, 2454, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (708, 4, 2454, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (709, 5, 2455, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (710, 6, 2455, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (711, 7, 2456, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (712, 8, 2456, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (713, 1, 2457, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (714, 2, 2457, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (715, 3, 2458, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (716, 4, 2458, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (717, 5, 2459, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (718, 6, 2459, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (719, 7, 2460, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (720, 8, 2460, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (721, 1, 2461, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (722, 2, 2461, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (723, 3, 2462, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (724, 4, 2462, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (725, 5, 2463, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (726, 6, 2463, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (727, 7, 2464, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (728, 8, 2464, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (729, 1, 2465, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (730, 2, 2465, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (731, 3, 2466, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (732, 4, 2466, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (733, 5, 2467, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (734, 6, 2467, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (735, 7, 2468, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (736, 8, 2468, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (737, 1, 2469, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (738, 2, 2469, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (739, 3, 2470, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (740, 4, 2470, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (741, 5, 2471, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (742, 6, 2471, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (743, 7, 2472, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (744, 8, 2472, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (745, 1, 2473, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (746, 2, 2473, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (747, 3, 2474, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (748, 4, 2474, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (749, 5, 2475, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (750, 6, 2475, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (751, 7, 2476, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (752, 8, 2476, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (753, 1, 2477, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (754, 2, 2477, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (755, 1, 2478, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (756, 2, 2478, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (757, 3, 2479, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (758, 4, 2479, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (759, 5, 2480, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (760, 6, 2480, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (761, 7, 2481, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (762, 8, 2481, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (763, 1, 2482, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (764, 2, 2482, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (765, 3, 2483, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (766, 4, 2483, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (767, 5, 2484, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (768, 6, 2484, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (769, 7, 2485, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (770, 8, 2485, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (771, 1, 2486, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (772, 2, 2486, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (773, 3, 2487, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (774, 4, 2487, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (775, 5, 2488, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (776, 6, 2488, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (777, 7, 2489, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (778, 8, 2489, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (779, 1, 2490, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (780, 2, 2490, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (781, 3, 2491, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (782, 4, 2491, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (783, 5, 2492, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (784, 6, 2492, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (785, 7, 2493, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (786, 8, 2493, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (787, 1, 2494, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (788, 2, 2494, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (789, 3, 2495, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (790, 4, 2495, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (791, 5, 2496, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (792, 6, 2496, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (793, 7, 2497, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (794, 8, 2497, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (795, 1, 2498, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (796, 2, 2498, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (797, 3, 2499, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (798, 4, 2499, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (799, 5, 2500, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (800, 6, 2500, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (801, 7, 2501, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (802, 8, 2501, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (803, 1, 2502, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (804, 2, 2502, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (805, 3, 2503, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (806, 4, 2503, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (807, 5, 2504, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (808, 6, 2504, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (809, 7, 2505, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (810, 8, 2505, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (811, 1, 2506, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (812, 2, 2506, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (813, 3, 2507, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (814, 4, 2507, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (815, 5, 2508, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (816, 6, 2508, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (817, 7, 2509, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (818, 8, 2509, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (819, 1, 2510, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (820, 2, 2510, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (821, 3, 2511, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (822, 4, 2511, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (823, 5, 2512, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (824, 6, 2512, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (825, 7, 2513, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (826, 8, 2513, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (827, 1, 2514, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (828, 2, 2514, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (829, 3, 2515, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (830, 4, 2515, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (831, 5, 2516, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (832, 6, 2516, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (833, 7, 2517, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (834, 8, 2517, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (835, 1, 2518, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (836, 2, 2518, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (837, 1, 2519, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (838, 2, 2519, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (839, 3, 2520, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (840, 4, 2520, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (841, 5, 2521, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (842, 6, 2521, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (843, 7, 2522, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (844, 8, 2522, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (845, 1, 2523, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (846, 2, 2523, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (847, 3, 2524, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (848, 4, 2524, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (849, 5, 2525, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (850, 6, 2525, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (851, 7, 2526, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (852, 8, 2526, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (853, 1, 2527, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (854, 2, 2527, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (855, 3, 2528, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (856, 4, 2528, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (857, 5, 2529, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (858, 6, 2529, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (859, 7, 2530, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (860, 8, 2530, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (861, 1, 2531, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (862, 2, 2531, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (863, 3, 2532, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (864, 4, 2532, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (865, 5, 2533, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (866, 6, 2533, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (867, 7, 2534, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (868, 8, 2534, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (869, 1, 2535, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (870, 2, 2535, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (871, 3, 2536, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (872, 4, 2536, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (873, 5, 2537, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (874, 6, 2537, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (875, 7, 2538, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (876, 8, 2538, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (877, 1, 2539, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (878, 2, 2539, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (879, 3, 2540, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (880, 4, 2540, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (881, 5, 2541, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (882, 6, 2541, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (883, 7, 2542, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (884, 8, 2542, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (885, 1, 2543, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (886, 2, 2543, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (887, 3, 2544, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (888, 4, 2544, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (889, 5, 2545, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (890, 6, 2545, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (891, 7, 2546, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (892, 8, 2546, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (893, 1, 2547, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (894, 2, 2547, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (895, 3, 2548, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (896, 4, 2548, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (897, 5, 2549, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (898, 6, 2549, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (899, 7, 2550, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (900, 8, 2550, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (901, 1, 2551, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (902, 2, 2551, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (903, 3, 2552, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (904, 4, 2552, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (905, 5, 2553, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (906, 6, 2553, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (907, 7, 2554, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (908, 8, 2554, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (909, 1, 2555, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (910, 2, 2555, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (911, 3, 2556, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (912, 4, 2556, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (913, 5, 2557, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (914, 6, 2557, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (915, 7, 2558, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (916, 8, 2558, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (917, 1, 2559, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (918, 2, 2559, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (919, 1, 2560, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (920, 2, 2560, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (921, 3, 2561, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (922, 4, 2561, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (923, 5, 2562, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (924, 6, 2562, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (925, 7, 2563, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (926, 8, 2563, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (927, 1, 2564, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (928, 2, 2564, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (929, 3, 2565, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (930, 4, 2565, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (931, 5, 2566, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (932, 6, 2566, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (933, 7, 2567, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (934, 8, 2567, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (935, 1, 2568, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (936, 2, 2568, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (937, 3, 2569, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (938, 4, 2569, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (939, 5, 2570, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (940, 6, 2570, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (941, 7, 2571, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (942, 8, 2571, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (943, 1, 2572, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (944, 2, 2572, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (945, 3, 2573, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (946, 4, 2573, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (947, 5, 2574, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (948, 6, 2574, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (949, 7, 2575, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (950, 8, 2575, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (951, 1, 2576, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (952, 2, 2576, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (953, 3, 2577, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (954, 4, 2577, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (955, 5, 2578, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (956, 6, 2578, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (957, 7, 2579, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (958, 8, 2579, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (959, 1, 2580, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (960, 2, 2580, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (961, 3, 2581, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (962, 4, 2581, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (963, 5, 2582, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (964, 6, 2582, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (965, 7, 2583, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (966, 8, 2583, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (967, 1, 2584, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (968, 2, 2584, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (969, 3, 2585, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (970, 4, 2585, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (971, 5, 2586, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (972, 6, 2586, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (973, 7, 2587, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (974, 8, 2587, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (975, 1, 2588, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (976, 2, 2588, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (977, 3, 2589, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (978, 4, 2589, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (979, 5, 2590, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (980, 6, 2590, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (981, 7, 2591, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (982, 8, 2591, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (983, 1, 2592, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (984, 2, 2592, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (985, 3, 2593, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (986, 4, 2593, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (987, 5, 2594, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (988, 6, 2594, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (989, 7, 2595, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (990, 8, 2595, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (991, 1, 2596, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (992, 2, 2596, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (993, 3, 2597, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (994, 4, 2597, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (995, 5, 2598, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (996, 6, 2598, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (997, 7, 2599, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (998, 8, 2599, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (999, 1, 2600, '2026-03-18 17:02:48', '2026-03-18 17:02:48');
INSERT INTO `course_student` VALUES (1000, 2, 2600, '2026-03-18 17:02:48', '2026-03-18 17:02:48');

-- ----------------------------
-- Table structure for coursevisit
-- ----------------------------
DROP TABLE IF EXISTS `coursevisit`;
CREATE TABLE `coursevisit`  (
  `course_id` bigint NOT NULL COMMENT '??ID?course.course_id?',
  `coursename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '???????????',
  `today` int NOT NULL DEFAULT 0 COMMENT '??????',
  `thisweek` int NOT NULL DEFAULT 0 COMMENT '??????',
  `thismonth` int NOT NULL DEFAULT 0 COMMENT '??????',
  `thisyear` int NOT NULL DEFAULT 0 COMMENT '??????',
  PRIMARY KEY (`coursename`) USING BTREE,
  UNIQUE INDEX `uq_coursevisit_course_id`(`course_id` ASC) USING BTREE,
  INDEX `idx_coursevisit_today`(`today` ASC) USING BTREE,
  INDEX `idx_coursevisit_thisweek`(`thisweek` ASC) USING BTREE,
  INDEX `idx_coursevisit_thismonth`(`thismonth` ASC) USING BTREE,
  INDEX `idx_coursevisit_thisyear`(`thisyear` ASC) USING BTREE,
  CONSTRAINT `fk_coursevisit_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '??????' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of coursevisit
-- ----------------------------
INSERT INTO `coursevisit` VALUES (2, '中国近现代史纲要', 17, 101, 289, 1111);
INSERT INTO `coursevisit` VALUES (6, '习近平新时代中国特色社会主义思想概论', 25, 145, 385, 1371);
INSERT INTO `coursevisit` VALUES (7, '国家安全教育', 28, 157, 410, 1437);
INSERT INTO `coursevisit` VALUES (8, '工程伦理与科技报国', 30, 168, 434, 1502);
INSERT INTO `coursevisit` VALUES (3, '形势与政策', 19, 112, 313, 1176);
INSERT INTO `coursevisit` VALUES (1, '思想道德与法治', 14, 89, 264, 1045);
INSERT INTO `coursevisit` VALUES (5, '毛泽东思想和中国特色社会主义理论体系概论', 22, 133, 360, 1305);
INSERT INTO `coursevisit` VALUES (4, '马克思主义基本原理', 20, 122, 336, 1240);

-- ----------------------------
-- Table structure for dim_class
-- ----------------------------
DROP TABLE IF EXISTS `dim_class`;
CREATE TABLE `dim_class`  (
  `class_id` bigint NOT NULL AUTO_INCREMENT,
  `major_id` bigint NOT NULL,
  `class_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `class_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `grade_year` smallint NULL DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`class_id`) USING BTREE,
  UNIQUE INDEX `uq_dim_class_code`(`class_code` ASC) USING BTREE,
  UNIQUE INDEX `uq_dim_class_major_name`(`major_id` ASC, `class_name` ASC) USING BTREE,
  INDEX `idx_dim_class_major`(`major_id` ASC) USING BTREE,
  INDEX `idx_dim_class_grade`(`grade_year` ASC) USING BTREE,
  CONSTRAINT `fk_dim_class_major` FOREIGN KEY (`major_id`) REFERENCES `dim_major` (`major_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 64 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Class dimension' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of dim_class
-- ----------------------------
INSERT INTO `dim_class` VALUES (1, 1, 'CL2025-IPE', '思想政治教育2025级1班', 2025, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (2, 2, 'CL2025-CS', '计算机科学与技术2025级1班', 2025, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (3, 3, 'CL2025-SE', '软件工程2025级1班', 2025, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (4, 4, 'CL2025-EIE', '电子信息工程2025级1班', 2025, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (5, 5, 'CL2025-EE', '电气工程及其自动化2025级1班', 2025, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (6, 6, 'CL2025-ME', '机械工程2025级1班', 2025, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (7, 7, 'CL2025-EN', '能源与动力工程2025级1班', 2025, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (8, 8, 'CL2025-BBA', '工商管理2025级1班', 2025, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (9, 9, 'CL2025-LAW', '法学2025级1班', 2025, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (10, 10, 'CL2025-MATH', '数学与应用数学2025级1班', 2025, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (11, 11, 'CL2025-ENG', '英语2025级1班', 2025, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (12, 12, 'CL2025-AERO', '飞行器设计与工程2025级1班', 2025, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (13, 1, 'CL2024-IPE', '思想政治教育2024级1班', 2024, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (14, 2, 'CL2024-CS', '计算机科学与技术2024级1班', 2024, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (15, 3, 'CL2024-SE', '软件工程2024级1班', 2024, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (16, 4, 'CL2024-EIE', '电子信息工程2024级1班', 2024, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (17, 5, 'CL2024-EE', '电气工程及其自动化2024级1班', 2024, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (18, 6, 'CL2024-ME', '机械工程2024级1班', 2024, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (19, 7, 'CL2024-EN', '能源与动力工程2024级1班', 2024, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (20, 8, 'CL2024-BBA', '工商管理2024级1班', 2024, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (21, 9, 'CL2024-LAW', '法学2024级1班', 2024, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (22, 10, 'CL2024-MATH', '数学与应用数学2024级1班', 2024, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (23, 11, 'CL2024-ENG', '英语2024级1班', 2024, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (24, 12, 'CL2024-AERO', '飞行器设计与工程2024级1班', 2024, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (25, 1, 'CL2023-IPE', '思想政治教育2023级1班', 2023, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (26, 2, 'CL2023-CS', '计算机科学与技术2023级1班', 2023, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (27, 3, 'CL2023-SE', '软件工程2023级1班', 2023, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (28, 4, 'CL2023-EIE', '电子信息工程2023级1班', 2023, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (29, 5, 'CL2023-EE', '电气工程及其自动化2023级1班', 2023, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (30, 6, 'CL2023-ME', '机械工程2023级1班', 2023, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (31, 7, 'CL2023-EN', '能源与动力工程2023级1班', 2023, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (32, 8, 'CL2023-BBA', '工商管理2023级1班', 2023, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (33, 9, 'CL2023-LAW', '法学2023级1班', 2023, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (34, 10, 'CL2023-MATH', '数学与应用数学2023级1班', 2023, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (35, 11, 'CL2023-ENG', '英语2023级1班', 2023, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (36, 12, 'CL2023-AERO', '飞行器设计与工程2023级1班', 2023, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (37, 1, 'CL2022-IPE', '思想政治教育2022级1班', 2022, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (38, 2, 'CL2022-CS', '计算机科学与技术2022级1班', 2022, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (39, 3, 'CL2022-SE', '软件工程2022级1班', 2022, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (40, 4, 'CL2022-EIE', '电子信息工程2022级1班', 2022, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (41, 5, 'CL2022-EE', '电气工程及其自动化2022级1班', 2022, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (42, 6, 'CL2022-ME', '机械工程2022级1班', 2022, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (43, 7, 'CL2022-EN', '能源与动力工程2022级1班', 2022, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (44, 8, 'CL2022-BBA', '工商管理2022级1班', 2022, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (45, 9, 'CL2022-LAW', '法学2022级1班', 2022, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (46, 10, 'CL2022-MATH', '数学与应用数学2022级1班', 2022, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (47, 11, 'CL2022-ENG', '英语2022级1班', 2022, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_class` VALUES (48, 12, 'CL2022-AERO', '飞行器设计与工程2022级1班', 2022, 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');

-- ----------------------------
-- Table structure for dim_college
-- ----------------------------
DROP TABLE IF EXISTS `dim_college`;
CREATE TABLE `dim_college`  (
  `college_id` bigint NOT NULL AUTO_INCREMENT,
  `college_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `college_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`college_id`) USING BTREE,
  UNIQUE INDEX `uq_dim_college_code`(`college_code` ASC) USING BTREE,
  UNIQUE INDEX `uq_dim_college_name`(`college_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'College dimension' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of dim_college
-- ----------------------------
INSERT INTO `dim_college` VALUES (1, 'MARS', '马克思主义学院', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_college` VALUES (2, 'COMP', '计算机科学与技术学院', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_college` VALUES (3, 'SOFT', '软件学院', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_college` VALUES (4, 'INFO', '电子与信息工程学院', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_college` VALUES (5, 'ELEC', '电气工程学院', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_college` VALUES (6, 'MECH', '机械工程学院', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_college` VALUES (7, 'ENER', '能源与动力工程学院', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_college` VALUES (8, 'MGMT', '经济与管理学院', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_college` VALUES (9, 'HSS', '人文社会科学学院', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_college` VALUES (10, 'MATH', '数学与统计学院', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_college` VALUES (11, 'FLS', '外国语学院', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_college` VALUES (12, 'AERO', '航空航天学院', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');

-- ----------------------------
-- Table structure for dim_major
-- ----------------------------
DROP TABLE IF EXISTS `dim_major`;
CREATE TABLE `dim_major`  (
  `major_id` bigint NOT NULL AUTO_INCREMENT,
  `college_id` bigint NOT NULL,
  `major_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `major_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`major_id`) USING BTREE,
  UNIQUE INDEX `uq_dim_major_code`(`major_code` ASC) USING BTREE,
  UNIQUE INDEX `uq_dim_major_college_name`(`college_id` ASC, `major_name` ASC) USING BTREE,
  INDEX `idx_dim_major_college`(`college_id` ASC) USING BTREE,
  CONSTRAINT `fk_dim_major_college` FOREIGN KEY (`college_id`) REFERENCES `dim_college` (`college_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Major dimension' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of dim_major
-- ----------------------------
INSERT INTO `dim_major` VALUES (1, 1, 'IPE', '思想政治教育', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_major` VALUES (2, 2, 'CS', '计算机科学与技术', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_major` VALUES (3, 3, 'SE', '软件工程', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_major` VALUES (4, 4, 'EIE', '电子信息工程', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_major` VALUES (5, 5, 'EE', '电气工程及其自动化', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_major` VALUES (6, 6, 'ME', '机械工程', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_major` VALUES (7, 7, 'EN', '能源与动力工程', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_major` VALUES (8, 8, 'BBA', '工商管理', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_major` VALUES (9, 9, 'LAW', '法学', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_major` VALUES (10, 10, 'MATH', '数学与应用数学', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_major` VALUES (11, 11, 'ENG', '英语', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_major` VALUES (12, 12, 'AERO', '飞行器设计与工程', 1, '2026-03-18 11:04:01', '2026-03-18 11:04:01');

-- ----------------------------
-- Table structure for dim_term
-- ----------------------------
DROP TABLE IF EXISTS `dim_term`;
CREATE TABLE `dim_term`  (
  `term_id` bigint NOT NULL AUTO_INCREMENT,
  `term_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `term_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `academic_year` int NOT NULL,
  `term_no` tinyint NOT NULL,
  `start_date` date NULL DEFAULT NULL,
  `end_date` date NULL DEFAULT NULL,
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'planned',
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`term_id`) USING BTREE,
  UNIQUE INDEX `uq_dim_term_code`(`term_code` ASC) USING BTREE,
  UNIQUE INDEX `uq_dim_term_year_no`(`academic_year` ASC, `term_no` ASC) USING BTREE,
  INDEX `idx_dim_term_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Term dimension' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of dim_term
-- ----------------------------
INSERT INTO `dim_term` VALUES (1, '2023-FALL', '2023-2024学年第一学期', 2023, 1, '2023-09-04', '2024-01-07', 'closed', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_term` VALUES (2, '2024-FALL', '2024-2025学年第一学期', 2024, 1, '2024-09-02', '2025-01-12', 'closed', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_term` VALUES (3, '2025-SPRING', '2024-2025学年第二学期', 2024, 2, '2025-02-24', '2025-07-06', 'closed', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_term` VALUES (4, '2025-FALL', '2025-2026学年第一学期', 2025, 1, '2025-09-01', '2026-01-11', 'closed', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_term` VALUES (5, '2026-SPRING', '2025-2026学年第二学期', 2025, 2, '2026-02-23', '2026-07-05', 'current', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `dim_term` VALUES (6, '2026-FALL', '2026-2027学年第一学期', 2026, 1, '2026-09-07', '2027-01-10', 'planned', '2026-03-18 11:04:01', '2026-03-18 11:04:01');

-- ----------------------------
-- Table structure for fact_course_score
-- ----------------------------
DROP TABLE IF EXISTS `fact_course_score`;
CREATE TABLE `fact_course_score`  (
  `score_id` bigint NOT NULL AUTO_INCREMENT,
  `student_id` bigint NOT NULL,
  `course_id` bigint NOT NULL,
  `term_id` bigint NOT NULL,
  `offering_id` bigint NULL DEFAULT NULL,
  `usual_score` decimal(5, 2) NULL DEFAULT NULL,
  `final_score` decimal(5, 2) NOT NULL,
  `gpa_point` decimal(4, 2) NULL DEFAULT NULL,
  `rank_in_class` int NULL DEFAULT NULL,
  `rank_in_major` int NULL DEFAULT NULL,
  `is_passed` tinyint(1) NOT NULL DEFAULT 1,
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`score_id`) USING BTREE,
  UNIQUE INDEX `uq_fact_course_score`(`student_id` ASC, `course_id` ASC, `term_id` ASC) USING BTREE,
  INDEX `idx_fact_course_score_term`(`term_id` ASC) USING BTREE,
  INDEX `idx_fact_course_score_course`(`course_id` ASC) USING BTREE,
  INDEX `idx_fact_course_score_student`(`student_id` ASC) USING BTREE,
  INDEX `fk_fact_course_score_offering`(`offering_id` ASC) USING BTREE,
  CONSTRAINT `fk_fact_course_score_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_fact_course_score_offering` FOREIGN KEY (`offering_id`) REFERENCES `course_offering` (`offering_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_fact_course_score_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_fact_course_score_term` FOREIGN KEY (`term_id`) REFERENCES `dim_term` (`term_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2050 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Per student per course score by term' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fact_course_score
-- ----------------------------

-- ----------------------------
-- Table structure for fact_term_gpa
-- ----------------------------
DROP TABLE IF EXISTS `fact_term_gpa`;
CREATE TABLE `fact_term_gpa`  (
  `term_gpa_id` bigint NOT NULL AUTO_INCREMENT,
  `student_id` bigint NOT NULL,
  `term_id` bigint NOT NULL,
  `avg_score` decimal(5, 2) NULL DEFAULT NULL,
  `gpa` decimal(4, 2) NULL DEFAULT NULL,
  `total_credits` decimal(6, 2) NULL DEFAULT NULL,
  `passed_credits` decimal(6, 2) NULL DEFAULT NULL,
  `class_rank` int NULL DEFAULT NULL,
  `major_rank` int NULL DEFAULT NULL,
  `college_rank` int NULL DEFAULT NULL,
  `cohort_size` int NULL DEFAULT NULL,
  `class_id` bigint NULL DEFAULT NULL,
  `major_id` bigint NULL DEFAULT NULL,
  `college_id` bigint NULL DEFAULT NULL,
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`term_gpa_id`) USING BTREE,
  UNIQUE INDEX `uq_fact_term_gpa`(`student_id` ASC, `term_id` ASC) USING BTREE,
  INDEX `idx_fact_term_gpa_term`(`term_id` ASC) USING BTREE,
  INDEX `idx_fact_term_gpa_class`(`class_id` ASC) USING BTREE,
  INDEX `idx_fact_term_gpa_major`(`major_id` ASC) USING BTREE,
  INDEX `idx_fact_term_gpa_college`(`college_id` ASC) USING BTREE,
  CONSTRAINT `fk_fact_term_gpa_class` FOREIGN KEY (`class_id`) REFERENCES `dim_class` (`class_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_fact_term_gpa_college` FOREIGN KEY (`college_id`) REFERENCES `dim_college` (`college_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_fact_term_gpa_major` FOREIGN KEY (`major_id`) REFERENCES `dim_major` (`major_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_fact_term_gpa_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_fact_term_gpa_term` FOREIGN KEY (`term_id`) REFERENCES `dim_term` (`term_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2049 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Student term-level GPA/score facts' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fact_term_gpa
-- ----------------------------

-- ----------------------------
-- Table structure for fact_warning_event
-- ----------------------------
DROP TABLE IF EXISTS `fact_warning_event`;
CREATE TABLE `fact_warning_event`  (
  `warning_id` bigint NOT NULL AUTO_INCREMENT,
  `student_id` bigint NOT NULL,
  `term_id` bigint NULL DEFAULT NULL,
  `warning_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `warning_level` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'low',
  `risk_score` decimal(6, 2) NOT NULL DEFAULT 0.00,
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'open',
  `opened_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `resolved_at` datetime NULL DEFAULT NULL,
  `handler` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`warning_id`) USING BTREE,
  INDEX `idx_fact_warning_event_student`(`student_id` ASC) USING BTREE,
  INDEX `idx_fact_warning_event_term`(`term_id` ASC) USING BTREE,
  INDEX `idx_fact_warning_event_status`(`status` ASC) USING BTREE,
  CONSTRAINT `fk_fact_warning_event_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_fact_warning_event_term` FOREIGN KEY (`term_id`) REFERENCES `dim_term` (`term_id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 256 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Student warning events' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fact_warning_event
-- ----------------------------

-- ----------------------------
-- Table structure for learning_record
-- ----------------------------
DROP TABLE IF EXISTS `learning_record`;
CREATE TABLE `learning_record`  (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '????ID',
  `user_id` bigint NOT NULL COMMENT '??ID?student.student_id?',
  `course_id` bigint NOT NULL COMMENT '??ID?course.course_id?',
  `check_in_time` datetime NULL DEFAULT NULL COMMENT '????',
  `task_point_id` bigint NULL DEFAULT NULL COMMENT '???ID??course.task_points??????????',
  `is_online` tinyint(1) NOT NULL DEFAULT 0 COMMENT '?????0=??1=??',
  `last_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '??????',
  PRIMARY KEY (`record_id`) USING BTREE,
  INDEX `idx_learning_record_course_id`(`course_id` ASC) USING BTREE,
  INDEX `idx_learning_record_is_online`(`is_online` ASC) USING BTREE,
  INDEX `idx_learning_record_check_in_time`(`check_in_time` ASC) USING BTREE,
  INDEX `idx_learning_record_user_course`(`user_id` ASC, `course_id` ASC) USING BTREE,
  CONSTRAINT `fk_learning_record_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_learning_record_student` FOREIGN KEY (`user_id`) REFERENCES `student` (`student_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1025 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '?????' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of learning_record
-- ----------------------------
INSERT INTO `learning_record` VALUES (1, 2101, 1, '2026-03-06 09:00:00', 3, 1, '2026-03-06 11:00:00');
INSERT INTO `learning_record` VALUES (2, 2101, 2, '2026-03-07 10:00:00', 4, 1, '2026-03-07 12:00:00');
INSERT INTO `learning_record` VALUES (3, 2102, 3, '2026-03-09 11:00:00', 2, 1, '2026-03-09 13:00:00');
INSERT INTO `learning_record` VALUES (4, 2102, 4, '2026-03-10 12:00:00', NULL, 0, '2026-03-10 10:00:00');
INSERT INTO `learning_record` VALUES (5, 2103, 5, '2026-03-12 08:00:00', 1, 1, '2026-03-12 11:00:00');
INSERT INTO `learning_record` VALUES (6, 2103, 6, NULL, 2, 1, '2026-03-13 12:00:00');
INSERT INTO `learning_record` VALUES (7, 2104, 7, '2026-03-15 10:00:00', 4, 1, '2026-03-15 13:00:00');
INSERT INTO `learning_record` VALUES (8, 2104, 8, '2026-03-16 11:00:00', NULL, 0, '2026-03-16 10:00:00');
INSERT INTO `learning_record` VALUES (9, 2105, 1, '2026-03-10 09:00:00', NULL, 0, '2026-03-10 11:00:00');
INSERT INTO `learning_record` VALUES (10, 2105, 2, '2026-03-11 10:00:00', 4, 1, '2026-03-11 12:00:00');
INSERT INTO `learning_record` VALUES (11, 2106, 3, NULL, 2, 1, '2026-03-13 13:00:00');
INSERT INTO `learning_record` VALUES (12, 2106, 4, '2026-03-14 12:00:00', 3, 1, '2026-03-14 10:00:00');
INSERT INTO `learning_record` VALUES (13, 2107, 5, '2026-03-16 08:00:00', 1, 0, '2026-03-16 11:00:00');
INSERT INTO `learning_record` VALUES (14, 2107, 6, '2026-03-17 09:00:00', 2, 1, '2026-03-17 12:00:00');
INSERT INTO `learning_record` VALUES (15, 2108, 7, '2026-03-19 10:00:00', NULL, 1, '2026-03-19 13:00:00');
INSERT INTO `learning_record` VALUES (16, 2108, 8, '2026-03-20 11:00:00', NULL, 1, '2026-03-20 10:00:00');
INSERT INTO `learning_record` VALUES (17, 2109, 1, '2026-03-14 09:00:00', 3, 1, '2026-03-14 11:00:00');
INSERT INTO `learning_record` VALUES (18, 2109, 2, '2026-03-15 10:00:00', 4, 1, '2026-03-15 12:00:00');
INSERT INTO `learning_record` VALUES (19, 2110, 3, '2026-03-17 11:00:00', 2, 1, '2026-03-17 13:00:00');
INSERT INTO `learning_record` VALUES (20, 2110, 4, '2026-03-18 12:00:00', 3, 1, '2026-03-18 10:00:00');
INSERT INTO `learning_record` VALUES (21, 2111, 5, '2026-03-20 08:00:00', NULL, 1, '2026-03-20 11:00:00');
INSERT INTO `learning_record` VALUES (22, 2111, 6, '2026-03-21 09:00:00', 2, 1, '2026-03-21 12:00:00');
INSERT INTO `learning_record` VALUES (23, 2112, 7, '2026-03-23 10:00:00', 4, 1, '2026-03-23 13:00:00');
INSERT INTO `learning_record` VALUES (24, 2112, 8, '2026-03-24 11:00:00', NULL, 0, '2026-03-24 10:00:00');
INSERT INTO `learning_record` VALUES (25, 2113, 1, '2026-03-18 09:00:00', 3, 1, '2026-03-18 11:00:00');
INSERT INTO `learning_record` VALUES (26, 2113, 2, '2026-03-19 10:00:00', NULL, 1, '2026-03-19 12:00:00');
INSERT INTO `learning_record` VALUES (27, 2114, 3, '2026-03-21 11:00:00', 2, 1, '2026-03-21 13:00:00');
INSERT INTO `learning_record` VALUES (28, 2114, 4, '2026-03-22 12:00:00', 3, 0, '2026-03-22 10:00:00');
INSERT INTO `learning_record` VALUES (29, 2115, 5, '2026-03-24 08:00:00', NULL, 1, '2026-03-24 11:00:00');
INSERT INTO `learning_record` VALUES (30, 2115, 6, '2026-03-25 09:00:00', 2, 1, '2026-03-25 12:00:00');
INSERT INTO `learning_record` VALUES (31, 2116, 7, '2026-03-27 10:00:00', 4, 1, '2026-03-27 13:00:00');
INSERT INTO `learning_record` VALUES (32, 2116, 8, '2026-03-28 11:00:00', NULL, 0, '2026-03-28 10:00:00');
INSERT INTO `learning_record` VALUES (33, 2117, 1, '2026-03-22 09:00:00', 3, 0, '2026-03-22 11:00:00');
INSERT INTO `learning_record` VALUES (34, 2117, 2, '2026-03-23 10:00:00', 4, 1, '2026-03-23 12:00:00');
INSERT INTO `learning_record` VALUES (35, 2118, 3, '2026-03-25 11:00:00', 2, 1, '2026-03-25 13:00:00');
INSERT INTO `learning_record` VALUES (36, 2118, 4, '2026-03-26 12:00:00', 3, 1, '2026-03-26 10:00:00');
INSERT INTO `learning_record` VALUES (37, 2119, 5, '2026-03-28 08:00:00', NULL, 0, '2026-03-28 11:00:00');
INSERT INTO `learning_record` VALUES (38, 2119, 6, '2026-03-29 09:00:00', 2, 1, '2026-03-29 12:00:00');
INSERT INTO `learning_record` VALUES (39, 2120, 7, '2026-03-31 10:00:00', 4, 1, '2026-03-31 13:00:00');
INSERT INTO `learning_record` VALUES (40, 2120, 8, NULL, 1, 1, '2026-04-01 10:00:00');
INSERT INTO `learning_record` VALUES (41, 2121, 1, '2026-03-26 09:00:00', 3, 1, '2026-03-26 11:00:00');
INSERT INTO `learning_record` VALUES (42, 2121, 2, '2026-03-27 10:00:00', 4, 1, '2026-03-27 12:00:00');
INSERT INTO `learning_record` VALUES (43, 2122, 3, '2026-03-29 11:00:00', 2, 0, '2026-03-29 13:00:00');
INSERT INTO `learning_record` VALUES (44, 2122, 4, '2026-03-30 12:00:00', 3, 1, '2026-03-30 10:00:00');
INSERT INTO `learning_record` VALUES (45, 2123, 5, NULL, NULL, 1, '2026-04-01 11:00:00');
INSERT INTO `learning_record` VALUES (46, 2123, 6, '2026-03-05 09:00:00', 2, 1, '2026-04-02 12:00:00');
INSERT INTO `learning_record` VALUES (47, 2124, 7, '2026-03-07 10:00:00', 4, 1, '2026-03-05 13:00:00');
INSERT INTO `learning_record` VALUES (48, 2124, 8, '2026-03-08 11:00:00', NULL, 1, '2026-03-06 10:00:00');
INSERT INTO `learning_record` VALUES (49, 2125, 1, '2026-03-30 09:00:00', 3, 1, '2026-03-30 11:00:00');
INSERT INTO `learning_record` VALUES (50, 2125, 2, '2026-03-31 10:00:00', 4, 1, '2026-03-31 12:00:00');
INSERT INTO `learning_record` VALUES (51, 2126, 3, '2026-03-05 11:00:00', 2, 1, '2026-04-02 13:00:00');
INSERT INTO `learning_record` VALUES (52, 2126, 4, '2026-03-06 12:00:00', 3, 0, '2026-03-04 10:00:00');
INSERT INTO `learning_record` VALUES (53, 2127, 5, '2026-03-08 08:00:00', 1, 1, '2026-03-06 11:00:00');
INSERT INTO `learning_record` VALUES (54, 2127, 6, '2026-03-09 09:00:00', NULL, 1, '2026-03-07 12:00:00');
INSERT INTO `learning_record` VALUES (55, 2128, 7, '2026-03-11 10:00:00', 4, 1, '2026-03-09 13:00:00');
INSERT INTO `learning_record` VALUES (56, 2128, 8, '2026-03-12 11:00:00', 1, 0, '2026-03-10 10:00:00');
INSERT INTO `learning_record` VALUES (57, 2129, 1, '2026-03-06 09:00:00', 3, 0, '2026-03-04 11:00:00');
INSERT INTO `learning_record` VALUES (58, 2129, 2, '2026-03-07 10:00:00', 4, 1, '2026-03-05 12:00:00');
INSERT INTO `learning_record` VALUES (59, 2130, 3, '2026-03-09 11:00:00', NULL, 1, '2026-03-07 13:00:00');
INSERT INTO `learning_record` VALUES (60, 2130, 4, '2026-03-10 12:00:00', 3, 1, '2026-03-08 10:00:00');
INSERT INTO `learning_record` VALUES (61, 2131, 5, '2026-03-12 08:00:00', 1, 0, '2026-03-10 11:00:00');
INSERT INTO `learning_record` VALUES (62, 2131, 6, '2026-03-13 09:00:00', 2, 1, '2026-03-11 12:00:00');
INSERT INTO `learning_record` VALUES (63, 2132, 7, '2026-03-15 10:00:00', 4, 1, '2026-03-13 13:00:00');
INSERT INTO `learning_record` VALUES (64, 2132, 8, '2026-03-16 11:00:00', 1, 1, '2026-03-14 10:00:00');
INSERT INTO `learning_record` VALUES (65, 2133, 1, '2026-03-10 09:00:00', 3, 1, '2026-03-08 11:00:00');
INSERT INTO `learning_record` VALUES (66, 2133, 2, '2026-03-11 10:00:00', 4, 0, '2026-03-09 12:00:00');
INSERT INTO `learning_record` VALUES (67, 2134, 3, '2026-03-13 11:00:00', 2, 1, '2026-03-11 13:00:00');
INSERT INTO `learning_record` VALUES (68, 2134, 4, '2026-03-14 12:00:00', 3, 1, '2026-03-12 10:00:00');
INSERT INTO `learning_record` VALUES (69, 2135, 5, '2026-03-16 08:00:00', NULL, 0, '2026-03-14 11:00:00');
INSERT INTO `learning_record` VALUES (70, 2135, 6, '2026-03-17 09:00:00', 2, 1, '2026-03-15 12:00:00');
INSERT INTO `learning_record` VALUES (71, 2136, 7, '2026-03-19 10:00:00', 4, 1, '2026-03-17 13:00:00');
INSERT INTO `learning_record` VALUES (72, 2136, 8, '2026-03-20 11:00:00', NULL, 1, '2026-03-18 10:00:00');
INSERT INTO `learning_record` VALUES (73, 2137, 1, '2026-03-14 09:00:00', 3, 1, '2026-03-12 11:00:00');
INSERT INTO `learning_record` VALUES (74, 2137, 2, '2026-03-15 10:00:00', 4, 1, '2026-03-13 12:00:00');
INSERT INTO `learning_record` VALUES (75, 2138, 3, '2026-03-17 11:00:00', 2, 1, '2026-03-15 13:00:00');
INSERT INTO `learning_record` VALUES (76, 2138, 4, '2026-03-18 12:00:00', NULL, 0, '2026-03-16 10:00:00');
INSERT INTO `learning_record` VALUES (77, 2139, 5, '2026-03-20 08:00:00', 1, 1, '2026-03-18 11:00:00');
INSERT INTO `learning_record` VALUES (78, 2139, 6, '2026-03-21 09:00:00', 2, 1, '2026-03-19 12:00:00');
INSERT INTO `learning_record` VALUES (79, 2140, 7, NULL, 4, 1, '2026-03-21 13:00:00');
INSERT INTO `learning_record` VALUES (80, 2140, 8, '2026-03-24 11:00:00', 1, 0, '2026-03-22 10:00:00');
INSERT INTO `learning_record` VALUES (81, 2141, 1, '2026-03-18 09:00:00', NULL, 0, '2026-03-16 11:00:00');
INSERT INTO `learning_record` VALUES (82, 2141, 2, '2026-03-19 10:00:00', 4, 1, '2026-03-17 12:00:00');
INSERT INTO `learning_record` VALUES (83, 2142, 3, '2026-03-21 11:00:00', 2, 1, '2026-03-19 13:00:00');
INSERT INTO `learning_record` VALUES (84, 2142, 4, '2026-03-22 12:00:00', 3, 1, '2026-03-20 10:00:00');
INSERT INTO `learning_record` VALUES (85, 2143, 1, '2026-03-20 09:00:00', 1, 1, '2026-03-18 11:00:00');
INSERT INTO `learning_record` VALUES (86, 2143, 2, '2026-03-21 10:00:00', 2, 1, '2026-03-19 12:00:00');
INSERT INTO `learning_record` VALUES (87, 2144, 3, NULL, 4, 1, '2026-03-21 13:00:00');
INSERT INTO `learning_record` VALUES (88, 2144, 4, '2026-03-24 12:00:00', NULL, 0, '2026-03-22 10:00:00');
INSERT INTO `learning_record` VALUES (89, 2145, 5, '2026-03-26 08:00:00', 3, 1, '2026-03-24 11:00:00');
INSERT INTO `learning_record` VALUES (90, 2145, 6, '2026-03-27 09:00:00', NULL, 1, '2026-03-25 12:00:00');
INSERT INTO `learning_record` VALUES (91, 2146, 7, '2026-03-29 10:00:00', 2, 1, '2026-03-27 13:00:00');
INSERT INTO `learning_record` VALUES (92, 2146, 8, '2026-03-30 11:00:00', 3, 0, '2026-03-28 10:00:00');
INSERT INTO `learning_record` VALUES (93, 2147, 1, '2026-03-24 09:00:00', NULL, 0, '2026-03-22 11:00:00');
INSERT INTO `learning_record` VALUES (94, 2147, 2, '2026-03-25 10:00:00', 2, 1, '2026-03-23 12:00:00');
INSERT INTO `learning_record` VALUES (95, 2148, 3, '2026-03-27 11:00:00', NULL, 1, '2026-03-25 13:00:00');
INSERT INTO `learning_record` VALUES (96, 2148, 4, '2026-03-28 12:00:00', NULL, 1, '2026-03-26 10:00:00');
INSERT INTO `learning_record` VALUES (97, 2149, 5, '2026-03-30 08:00:00', 3, 0, '2026-03-28 11:00:00');
INSERT INTO `learning_record` VALUES (98, 2149, 6, '2026-03-31 09:00:00', 4, 1, '2026-03-29 12:00:00');
INSERT INTO `learning_record` VALUES (99, 2150, 7, '2026-03-05 10:00:00', 2, 1, '2026-03-31 13:00:00');
INSERT INTO `learning_record` VALUES (100, 2150, 8, '2026-03-06 11:00:00', 3, 1, '2026-04-01 10:00:00');
INSERT INTO `learning_record` VALUES (101, 2151, 1, '2026-03-28 09:00:00', 1, 1, '2026-03-26 11:00:00');
INSERT INTO `learning_record` VALUES (102, 2151, 2, '2026-03-29 10:00:00', 2, 1, '2026-03-27 12:00:00');
INSERT INTO `learning_record` VALUES (103, 2152, 3, '2026-03-31 11:00:00', 4, 1, '2026-03-29 13:00:00');
INSERT INTO `learning_record` VALUES (104, 2152, 4, '2026-03-04 12:00:00', NULL, 1, '2026-03-30 10:00:00');
INSERT INTO `learning_record` VALUES (105, 2153, 5, '2026-03-06 08:00:00', 3, 1, '2026-04-01 11:00:00');
INSERT INTO `learning_record` VALUES (106, 2153, 6, '2026-03-07 09:00:00', 4, 1, '2026-04-02 12:00:00');
INSERT INTO `learning_record` VALUES (107, 2154, 7, '2026-03-09 10:00:00', 2, 1, '2026-03-05 13:00:00');
INSERT INTO `learning_record` VALUES (108, 2154, 8, '2026-03-10 11:00:00', 3, 1, '2026-03-06 10:00:00');
INSERT INTO `learning_record` VALUES (109, 2155, 1, '2026-03-04 09:00:00', NULL, 1, '2026-03-30 11:00:00');
INSERT INTO `learning_record` VALUES (110, 2155, 2, '2026-03-05 10:00:00', 2, 1, '2026-03-31 12:00:00');
INSERT INTO `learning_record` VALUES (111, 2156, 3, '2026-03-07 11:00:00', 4, 1, '2026-04-02 13:00:00');
INSERT INTO `learning_record` VALUES (112, 2156, 4, '2026-03-08 12:00:00', NULL, 0, '2026-03-04 10:00:00');
INSERT INTO `learning_record` VALUES (113, 2157, 5, '2026-03-10 08:00:00', 3, 1, '2026-03-06 11:00:00');
INSERT INTO `learning_record` VALUES (114, 2157, 6, '2026-03-11 09:00:00', 4, 1, '2026-03-07 12:00:00');
INSERT INTO `learning_record` VALUES (115, 2158, 7, '2026-03-13 10:00:00', 2, 1, '2026-03-09 13:00:00');
INSERT INTO `learning_record` VALUES (116, 2158, 8, NULL, 3, 0, '2026-03-10 10:00:00');
INSERT INTO `learning_record` VALUES (117, 2159, 1, '2026-03-08 09:00:00', NULL, 0, '2026-03-04 11:00:00');
INSERT INTO `learning_record` VALUES (118, 2159, 2, '2026-03-09 10:00:00', 2, 1, '2026-03-05 12:00:00');
INSERT INTO `learning_record` VALUES (119, 2160, 3, '2026-03-11 11:00:00', 4, 1, '2026-03-07 13:00:00');
INSERT INTO `learning_record` VALUES (120, 2160, 4, '2026-03-12 12:00:00', NULL, 1, '2026-03-08 10:00:00');
INSERT INTO `learning_record` VALUES (121, 2161, 5, NULL, 3, 0, '2026-03-10 11:00:00');
INSERT INTO `learning_record` VALUES (122, 2161, 6, '2026-03-15 09:00:00', 4, 1, '2026-03-11 12:00:00');
INSERT INTO `learning_record` VALUES (123, 2162, 7, '2026-03-17 10:00:00', NULL, 1, '2026-03-13 13:00:00');
INSERT INTO `learning_record` VALUES (124, 2162, 8, '2026-03-18 11:00:00', 3, 1, '2026-03-14 10:00:00');
INSERT INTO `learning_record` VALUES (125, 2163, 1, '2026-03-12 09:00:00', NULL, 1, '2026-03-08 11:00:00');
INSERT INTO `learning_record` VALUES (126, 2163, 2, '2026-03-13 10:00:00', 2, 0, '2026-03-09 12:00:00');
INSERT INTO `learning_record` VALUES (127, 2164, 3, '2026-03-15 11:00:00', 4, 1, '2026-03-11 13:00:00');
INSERT INTO `learning_record` VALUES (128, 2164, 4, '2026-03-16 12:00:00', 1, 1, '2026-03-12 10:00:00');
INSERT INTO `learning_record` VALUES (129, 2165, 5, '2026-03-18 08:00:00', 3, 1, '2026-03-14 11:00:00');
INSERT INTO `learning_record` VALUES (130, 2165, 6, '2026-03-19 09:00:00', 4, 1, '2026-03-15 12:00:00');
INSERT INTO `learning_record` VALUES (131, 2166, 7, '2026-03-21 10:00:00', 2, 1, '2026-03-17 13:00:00');
INSERT INTO `learning_record` VALUES (132, 2166, 8, '2026-03-22 11:00:00', 3, 1, '2026-03-18 10:00:00');
INSERT INTO `learning_record` VALUES (133, 2167, 1, '2026-03-16 09:00:00', NULL, 1, '2026-03-12 11:00:00');
INSERT INTO `learning_record` VALUES (134, 2167, 2, '2026-03-17 10:00:00', NULL, 1, '2026-03-13 12:00:00');
INSERT INTO `learning_record` VALUES (135, 2168, 3, '2026-03-19 11:00:00', 4, 1, '2026-03-15 13:00:00');
INSERT INTO `learning_record` VALUES (136, 2168, 4, '2026-03-20 12:00:00', 1, 0, '2026-03-16 10:00:00');
INSERT INTO `learning_record` VALUES (137, 2169, 5, '2026-03-22 08:00:00', 3, 1, '2026-03-18 11:00:00');
INSERT INTO `learning_record` VALUES (138, 2169, 6, '2026-03-23 09:00:00', 4, 1, '2026-03-19 12:00:00');
INSERT INTO `learning_record` VALUES (139, 2170, 7, '2026-03-25 10:00:00', 2, 1, '2026-03-21 13:00:00');
INSERT INTO `learning_record` VALUES (140, 2170, 8, '2026-03-26 11:00:00', NULL, 0, '2026-03-22 10:00:00');
INSERT INTO `learning_record` VALUES (141, 2171, 1, '2026-03-20 09:00:00', NULL, 0, '2026-03-16 11:00:00');
INSERT INTO `learning_record` VALUES (142, 2171, 2, '2026-03-21 10:00:00', 2, 1, '2026-03-17 12:00:00');
INSERT INTO `learning_record` VALUES (143, 2172, 3, '2026-03-23 11:00:00', 4, 0, '2026-03-19 13:00:00');
INSERT INTO `learning_record` VALUES (144, 2172, 4, '2026-03-24 12:00:00', NULL, 1, '2026-03-20 10:00:00');
INSERT INTO `learning_record` VALUES (145, 2173, 5, '2026-03-26 08:00:00', NULL, 0, '2026-03-22 11:00:00');
INSERT INTO `learning_record` VALUES (146, 2173, 6, '2026-03-27 09:00:00', 4, 1, '2026-03-23 12:00:00');
INSERT INTO `learning_record` VALUES (147, 2174, 7, '2026-03-29 10:00:00', 2, 1, '2026-03-25 13:00:00');
INSERT INTO `learning_record` VALUES (148, 2174, 8, '2026-03-30 11:00:00', 3, 1, '2026-03-26 10:00:00');
INSERT INTO `learning_record` VALUES (149, 2175, 1, '2026-03-24 09:00:00', 1, 1, '2026-03-20 11:00:00');
INSERT INTO `learning_record` VALUES (150, 2175, 2, '2026-03-25 10:00:00', 2, 1, '2026-03-21 12:00:00');
INSERT INTO `learning_record` VALUES (151, 2176, 3, '2026-03-27 11:00:00', 4, 1, '2026-03-23 13:00:00');
INSERT INTO `learning_record` VALUES (152, 2176, 4, '2026-03-28 12:00:00', 1, 1, '2026-03-24 10:00:00');
INSERT INTO `learning_record` VALUES (153, 2177, 5, '2026-03-30 08:00:00', 3, 1, '2026-03-26 11:00:00');
INSERT INTO `learning_record` VALUES (154, 2177, 6, '2026-03-31 09:00:00', 4, 1, '2026-03-27 12:00:00');
INSERT INTO `learning_record` VALUES (155, 2178, 7, NULL, 2, 1, '2026-03-29 13:00:00');
INSERT INTO `learning_record` VALUES (156, 2178, 8, '2026-03-06 11:00:00', 3, 1, '2026-03-30 10:00:00');
INSERT INTO `learning_record` VALUES (157, 2179, 1, '2026-03-28 09:00:00', 1, 1, '2026-03-24 11:00:00');
INSERT INTO `learning_record` VALUES (158, 2179, 2, '2026-03-29 10:00:00', 2, 1, '2026-03-25 12:00:00');
INSERT INTO `learning_record` VALUES (159, 2180, 3, '2026-03-31 11:00:00', 4, 1, '2026-03-27 13:00:00');
INSERT INTO `learning_record` VALUES (160, 2180, 4, '2026-03-04 12:00:00', 1, 0, '2026-03-28 10:00:00');
INSERT INTO `learning_record` VALUES (161, 2181, 5, '2026-03-06 08:00:00', 3, 1, '2026-03-30 11:00:00');
INSERT INTO `learning_record` VALUES (162, 2181, 6, '2026-03-07 09:00:00', NULL, 1, '2026-03-31 12:00:00');
INSERT INTO `learning_record` VALUES (163, 2182, 7, '2026-03-09 10:00:00', 2, 1, '2026-04-02 13:00:00');
INSERT INTO `learning_record` VALUES (164, 2182, 8, '2026-03-10 11:00:00', 3, 0, '2026-03-04 10:00:00');
INSERT INTO `learning_record` VALUES (165, 2183, 1, '2026-03-04 09:00:00', NULL, 0, '2026-03-28 11:00:00');
INSERT INTO `learning_record` VALUES (166, 2183, 2, NULL, 2, 0, '2026-03-29 12:00:00');
INSERT INTO `learning_record` VALUES (167, 2184, 3, '2026-03-07 11:00:00', NULL, 1, '2026-03-31 13:00:00');
INSERT INTO `learning_record` VALUES (168, 2184, 4, '2026-03-08 12:00:00', NULL, 1, '2026-04-01 10:00:00');
INSERT INTO `learning_record` VALUES (169, 2185, 1, '2026-03-06 09:00:00', 3, 1, '2026-03-30 11:00:00');
INSERT INTO `learning_record` VALUES (170, 2185, 2, '2026-03-07 10:00:00', NULL, 1, '2026-03-31 12:00:00');
INSERT INTO `learning_record` VALUES (171, 2186, 3, '2026-03-09 11:00:00', 2, 1, '2026-04-02 13:00:00');
INSERT INTO `learning_record` VALUES (172, 2186, 4, '2026-03-10 12:00:00', 3, 0, '2026-03-04 10:00:00');
INSERT INTO `learning_record` VALUES (173, 2187, 5, '2026-03-12 08:00:00', 1, 1, '2026-03-06 11:00:00');
INSERT INTO `learning_record` VALUES (174, 2187, 6, '2026-03-13 09:00:00', 2, 1, '2026-03-07 12:00:00');
INSERT INTO `learning_record` VALUES (175, 2188, 7, '2026-03-15 10:00:00', 4, 1, '2026-03-09 13:00:00');
INSERT INTO `learning_record` VALUES (176, 2188, 8, '2026-03-16 11:00:00', NULL, 0, '2026-03-10 10:00:00');
INSERT INTO `learning_record` VALUES (177, 2189, 1, '2026-03-10 09:00:00', 3, 0, '2026-03-04 11:00:00');
INSERT INTO `learning_record` VALUES (178, 2189, 2, '2026-03-11 10:00:00', 4, 1, '2026-03-05 12:00:00');
INSERT INTO `learning_record` VALUES (179, 2190, 3, '2026-03-13 11:00:00', 2, 1, '2026-03-07 13:00:00');
INSERT INTO `learning_record` VALUES (180, 2190, 4, '2026-03-14 12:00:00', 3, 1, '2026-03-08 10:00:00');
INSERT INTO `learning_record` VALUES (181, 2191, 5, '2026-03-16 08:00:00', NULL, 0, '2026-03-10 11:00:00');
INSERT INTO `learning_record` VALUES (182, 2191, 6, '2026-03-17 09:00:00', 2, 1, '2026-03-11 12:00:00');
INSERT INTO `learning_record` VALUES (183, 2192, 7, '2026-03-19 10:00:00', 4, 1, '2026-03-13 13:00:00');
INSERT INTO `learning_record` VALUES (184, 2192, 8, '2026-03-20 11:00:00', 1, 1, '2026-03-14 10:00:00');
INSERT INTO `learning_record` VALUES (185, 2193, 1, '2026-03-14 09:00:00', 3, 1, '2026-03-08 11:00:00');
INSERT INTO `learning_record` VALUES (186, 2193, 2, '2026-03-15 10:00:00', 4, 1, '2026-03-09 12:00:00');
INSERT INTO `learning_record` VALUES (187, 2194, 3, '2026-03-17 11:00:00', 2, 1, '2026-03-11 13:00:00');
INSERT INTO `learning_record` VALUES (188, 2194, 4, '2026-03-18 12:00:00', 3, 1, '2026-03-12 10:00:00');
INSERT INTO `learning_record` VALUES (189, 2195, 5, '2026-03-20 08:00:00', 1, 1, '2026-03-14 11:00:00');
INSERT INTO `learning_record` VALUES (190, 2195, 6, '2026-03-21 09:00:00', 2, 1, '2026-03-15 12:00:00');
INSERT INTO `learning_record` VALUES (191, 2196, 7, '2026-03-23 10:00:00', 4, 1, '2026-03-17 13:00:00');
INSERT INTO `learning_record` VALUES (192, 2196, 8, NULL, NULL, 1, '2026-03-18 10:00:00');
INSERT INTO `learning_record` VALUES (193, 2197, 1, '2026-03-18 09:00:00', 3, 1, '2026-03-12 11:00:00');
INSERT INTO `learning_record` VALUES (194, 2197, 2, '2026-03-19 10:00:00', 4, 1, '2026-03-13 12:00:00');
INSERT INTO `learning_record` VALUES (195, 2198, 3, '2026-03-21 11:00:00', 2, 1, '2026-03-15 13:00:00');
INSERT INTO `learning_record` VALUES (196, 2198, 4, '2026-03-22 12:00:00', 3, 0, '2026-03-16 10:00:00');
INSERT INTO `learning_record` VALUES (197, 2199, 5, NULL, NULL, 1, '2026-03-18 11:00:00');
INSERT INTO `learning_record` VALUES (198, 2199, 6, '2026-03-25 09:00:00', NULL, 1, '2026-03-19 12:00:00');
INSERT INTO `learning_record` VALUES (199, 2200, 7, '2026-03-27 10:00:00', 4, 1, '2026-03-21 13:00:00');
INSERT INTO `learning_record` VALUES (200, 2200, 8, '2026-03-28 11:00:00', 1, 0, '2026-03-22 10:00:00');
INSERT INTO `learning_record` VALUES (201, 2201, 1, '2026-03-22 09:00:00', 3, 0, '2026-03-16 11:00:00');
INSERT INTO `learning_record` VALUES (202, 2201, 2, '2026-03-23 10:00:00', 4, 1, '2026-03-17 12:00:00');
INSERT INTO `learning_record` VALUES (203, 2202, 3, '2026-03-25 11:00:00', NULL, 1, '2026-03-19 13:00:00');
INSERT INTO `learning_record` VALUES (204, 2202, 4, '2026-03-26 12:00:00', 3, 1, '2026-03-20 10:00:00');
INSERT INTO `learning_record` VALUES (205, 2203, 5, '2026-03-28 08:00:00', NULL, 0, '2026-03-22 11:00:00');
INSERT INTO `learning_record` VALUES (206, 2203, 6, '2026-03-29 09:00:00', 2, 1, '2026-03-23 12:00:00');
INSERT INTO `learning_record` VALUES (207, 2204, 7, '2026-03-31 10:00:00', 4, 1, '2026-03-25 13:00:00');
INSERT INTO `learning_record` VALUES (208, 2204, 8, '2026-03-04 11:00:00', 1, 1, '2026-03-26 10:00:00');
INSERT INTO `learning_record` VALUES (209, 2205, 1, '2026-03-26 09:00:00', 3, 1, '2026-03-20 11:00:00');
INSERT INTO `learning_record` VALUES (210, 2205, 2, '2026-03-27 10:00:00', 4, 1, '2026-03-21 12:00:00');
INSERT INTO `learning_record` VALUES (211, 2206, 3, '2026-03-29 11:00:00', 2, 1, '2026-03-23 13:00:00');
INSERT INTO `learning_record` VALUES (212, 2206, 4, '2026-03-30 12:00:00', 3, 1, '2026-03-24 10:00:00');
INSERT INTO `learning_record` VALUES (213, 2207, 5, '2026-03-04 08:00:00', NULL, 1, '2026-03-26 11:00:00');
INSERT INTO `learning_record` VALUES (214, 2207, 6, '2026-03-05 09:00:00', 2, 1, '2026-03-27 12:00:00');
INSERT INTO `learning_record` VALUES (215, 2208, 7, '2026-03-07 10:00:00', 4, 0, '2026-03-29 13:00:00');
INSERT INTO `learning_record` VALUES (216, 2208, 8, '2026-03-08 11:00:00', NULL, 1, '2026-03-30 10:00:00');
INSERT INTO `learning_record` VALUES (217, 2209, 1, '2026-03-30 09:00:00', 3, 1, '2026-03-24 11:00:00');
INSERT INTO `learning_record` VALUES (218, 2209, 2, '2026-03-31 10:00:00', 4, 1, '2026-03-25 12:00:00');
INSERT INTO `learning_record` VALUES (219, 2210, 3, '2026-03-05 11:00:00', 2, 1, '2026-03-27 13:00:00');
INSERT INTO `learning_record` VALUES (220, 2210, 4, '2026-03-06 12:00:00', NULL, 0, '2026-03-28 10:00:00');
INSERT INTO `learning_record` VALUES (221, 2211, 5, '2026-03-08 08:00:00', 1, 1, '2026-03-30 11:00:00');
INSERT INTO `learning_record` VALUES (222, 2211, 6, '2026-03-09 09:00:00', 2, 1, '2026-03-31 12:00:00');
INSERT INTO `learning_record` VALUES (223, 2212, 7, '2026-03-11 10:00:00', 4, 1, '2026-04-02 13:00:00');
INSERT INTO `learning_record` VALUES (224, 2212, 8, '2026-03-12 11:00:00', 1, 0, '2026-03-04 10:00:00');
INSERT INTO `learning_record` VALUES (225, 2213, 1, '2026-03-06 09:00:00', NULL, 0, '2026-03-28 11:00:00');
INSERT INTO `learning_record` VALUES (226, 2213, 2, '2026-03-07 10:00:00', 4, 1, '2026-03-29 12:00:00');
INSERT INTO `learning_record` VALUES (227, 2214, 3, '2026-03-09 11:00:00', 2, 1, '2026-03-31 13:00:00');
INSERT INTO `learning_record` VALUES (228, 2214, 4, '2026-03-10 12:00:00', 3, 1, '2026-04-01 10:00:00');
INSERT INTO `learning_record` VALUES (229, 2215, 5, '2026-03-12 08:00:00', 1, 0, '2026-03-04 11:00:00');
INSERT INTO `learning_record` VALUES (230, 2215, 6, '2026-03-13 09:00:00', 2, 1, '2026-03-05 12:00:00');
INSERT INTO `learning_record` VALUES (231, 2216, 7, NULL, NULL, 1, '2026-03-07 13:00:00');
INSERT INTO `learning_record` VALUES (232, 2216, 8, '2026-03-16 11:00:00', 1, 1, '2026-03-08 10:00:00');
INSERT INTO `learning_record` VALUES (233, 2217, 1, '2026-03-10 09:00:00', 3, 1, '2026-04-01 11:00:00');
INSERT INTO `learning_record` VALUES (234, 2217, 2, '2026-03-11 10:00:00', 4, 1, '2026-04-02 12:00:00');
INSERT INTO `learning_record` VALUES (235, 2218, 3, '2026-03-13 11:00:00', 2, 1, '2026-03-05 13:00:00');
INSERT INTO `learning_record` VALUES (236, 2218, 4, '2026-03-14 12:00:00', 3, 1, '2026-03-06 10:00:00');
INSERT INTO `learning_record` VALUES (237, 2219, 5, '2026-03-16 08:00:00', NULL, 1, '2026-03-08 11:00:00');
INSERT INTO `learning_record` VALUES (238, 2219, 6, '2026-03-17 09:00:00', 2, 0, '2026-03-09 12:00:00');
INSERT INTO `learning_record` VALUES (239, 2220, 7, '2026-03-19 10:00:00', 4, 1, '2026-03-11 13:00:00');
INSERT INTO `learning_record` VALUES (240, 2220, 8, '2026-03-20 11:00:00', NULL, 1, '2026-03-12 10:00:00');
INSERT INTO `learning_record` VALUES (241, 2221, 1, '2026-03-14 09:00:00', 3, 1, '2026-03-06 11:00:00');
INSERT INTO `learning_record` VALUES (242, 2221, 2, NULL, NULL, 1, '2026-03-07 12:00:00');
INSERT INTO `learning_record` VALUES (243, 2222, 3, '2026-03-17 11:00:00', 2, 1, '2026-03-09 13:00:00');
INSERT INTO `learning_record` VALUES (244, 2222, 4, '2026-03-18 12:00:00', 3, 0, '2026-03-10 10:00:00');
INSERT INTO `learning_record` VALUES (245, 2223, 5, '2026-03-20 08:00:00', 1, 1, '2026-03-12 11:00:00');
INSERT INTO `learning_record` VALUES (246, 2223, 6, '2026-03-21 09:00:00', 2, 1, '2026-03-13 12:00:00');
INSERT INTO `learning_record` VALUES (247, 2224, 7, '2026-03-23 10:00:00', 4, 1, '2026-03-15 13:00:00');
INSERT INTO `learning_record` VALUES (248, 2224, 8, '2026-03-24 11:00:00', NULL, 0, '2026-03-16 10:00:00');
INSERT INTO `learning_record` VALUES (249, 2225, 1, '2026-03-18 09:00:00', 3, 0, '2026-03-10 11:00:00');
INSERT INTO `learning_record` VALUES (250, 2225, 2, '2026-03-19 10:00:00', 4, 1, '2026-03-11 12:00:00');
INSERT INTO `learning_record` VALUES (251, 2226, 3, '2026-03-21 11:00:00', 2, 1, '2026-03-13 13:00:00');
INSERT INTO `learning_record` VALUES (252, 2226, 4, '2026-03-22 12:00:00', 3, 1, '2026-03-14 10:00:00');
INSERT INTO `learning_record` VALUES (253, 2227, 1, '2026-03-20 09:00:00', 1, 1, '2026-03-12 11:00:00');
INSERT INTO `learning_record` VALUES (254, 2227, 2, '2026-03-21 10:00:00', 2, 1, '2026-03-13 12:00:00');
INSERT INTO `learning_record` VALUES (255, 2228, 3, '2026-03-23 11:00:00', 4, 1, '2026-03-15 13:00:00');
INSERT INTO `learning_record` VALUES (256, 2228, 4, '2026-03-24 12:00:00', NULL, 0, '2026-03-16 10:00:00');
INSERT INTO `learning_record` VALUES (257, 2229, 5, '2026-03-26 08:00:00', 3, 1, '2026-03-18 11:00:00');
INSERT INTO `learning_record` VALUES (258, 2229, 6, '2026-03-27 09:00:00', 4, 1, '2026-03-19 12:00:00');
INSERT INTO `learning_record` VALUES (259, 2230, 7, '2026-03-29 10:00:00', 2, 1, '2026-03-21 13:00:00');
INSERT INTO `learning_record` VALUES (260, 2230, 8, '2026-03-30 11:00:00', 3, 0, '2026-03-22 10:00:00');
INSERT INTO `learning_record` VALUES (261, 2231, 1, '2026-03-24 09:00:00', NULL, 0, '2026-03-16 11:00:00');
INSERT INTO `learning_record` VALUES (262, 2231, 2, '2026-03-25 10:00:00', 2, 1, '2026-03-17 12:00:00');
INSERT INTO `learning_record` VALUES (263, 2232, 3, '2026-03-27 11:00:00', 4, 0, '2026-03-19 13:00:00');
INSERT INTO `learning_record` VALUES (264, 2232, 4, '2026-03-28 12:00:00', NULL, 1, '2026-03-20 10:00:00');
INSERT INTO `learning_record` VALUES (265, 2233, 5, '2026-03-30 08:00:00', 3, 0, '2026-03-22 11:00:00');
INSERT INTO `learning_record` VALUES (266, 2233, 6, '2026-03-31 09:00:00', 4, 1, '2026-03-23 12:00:00');
INSERT INTO `learning_record` VALUES (267, 2234, 7, '2026-03-05 10:00:00', NULL, 1, '2026-03-25 13:00:00');
INSERT INTO `learning_record` VALUES (268, 2234, 8, NULL, 3, 1, '2026-03-26 10:00:00');
INSERT INTO `learning_record` VALUES (269, 2235, 1, '2026-03-28 09:00:00', 1, 1, '2026-03-20 11:00:00');
INSERT INTO `learning_record` VALUES (270, 2235, 2, '2026-03-29 10:00:00', 2, 1, '2026-03-21 12:00:00');
INSERT INTO `learning_record` VALUES (271, 2236, 3, '2026-03-31 11:00:00', 4, 1, '2026-03-23 13:00:00');
INSERT INTO `learning_record` VALUES (272, 2236, 4, '2026-03-04 12:00:00', NULL, 1, '2026-03-24 10:00:00');
INSERT INTO `learning_record` VALUES (273, 2237, 5, NULL, 3, 1, '2026-03-26 11:00:00');
INSERT INTO `learning_record` VALUES (274, 2237, 6, '2026-03-07 09:00:00', 4, 1, '2026-03-27 12:00:00');
INSERT INTO `learning_record` VALUES (275, 2238, 7, '2026-03-09 10:00:00', 2, 1, '2026-03-29 13:00:00');
INSERT INTO `learning_record` VALUES (276, 2238, 8, '2026-03-10 11:00:00', 3, 1, '2026-03-30 10:00:00');
INSERT INTO `learning_record` VALUES (277, 2239, 1, '2026-03-04 09:00:00', 1, 1, '2026-03-24 11:00:00');
INSERT INTO `learning_record` VALUES (278, 2239, 2, '2026-03-05 10:00:00', NULL, 1, '2026-03-25 12:00:00');
INSERT INTO `learning_record` VALUES (279, 2240, 3, '2026-03-07 11:00:00', 4, 1, '2026-03-27 13:00:00');
INSERT INTO `learning_record` VALUES (280, 2240, 4, '2026-03-08 12:00:00', NULL, 0, '2026-03-28 10:00:00');
INSERT INTO `learning_record` VALUES (281, 2241, 5, '2026-03-10 08:00:00', 3, 1, '2026-03-30 11:00:00');
INSERT INTO `learning_record` VALUES (282, 2241, 6, '2026-03-11 09:00:00', 4, 1, '2026-03-31 12:00:00');
INSERT INTO `learning_record` VALUES (283, 2242, 7, '2026-03-13 10:00:00', 2, 1, '2026-04-02 13:00:00');
INSERT INTO `learning_record` VALUES (284, 2242, 8, '2026-03-14 11:00:00', NULL, 0, '2026-03-04 10:00:00');
INSERT INTO `learning_record` VALUES (285, 2243, 1, '2026-03-08 09:00:00', NULL, 0, '2026-03-28 11:00:00');
INSERT INTO `learning_record` VALUES (286, 2243, 2, '2026-03-09 10:00:00', 2, 0, '2026-03-29 12:00:00');
INSERT INTO `learning_record` VALUES (287, 2244, 3, '2026-03-11 11:00:00', 4, 1, '2026-03-31 13:00:00');
INSERT INTO `learning_record` VALUES (288, 2244, 4, '2026-03-12 12:00:00', NULL, 1, '2026-04-01 10:00:00');
INSERT INTO `learning_record` VALUES (289, 2245, 5, '2026-03-14 08:00:00', NULL, 0, '2026-03-04 11:00:00');
INSERT INTO `learning_record` VALUES (290, 2245, 6, '2026-03-15 09:00:00', 4, 1, '2026-03-05 12:00:00');
INSERT INTO `learning_record` VALUES (291, 2246, 7, '2026-03-17 10:00:00', 2, 1, '2026-03-07 13:00:00');
INSERT INTO `learning_record` VALUES (292, 2246, 8, '2026-03-18 11:00:00', 3, 1, '2026-03-08 10:00:00');
INSERT INTO `learning_record` VALUES (293, 2247, 1, '2026-03-12 09:00:00', NULL, 1, '2026-04-01 11:00:00');
INSERT INTO `learning_record` VALUES (294, 2247, 2, '2026-03-13 10:00:00', 2, 1, '2026-04-02 12:00:00');
INSERT INTO `learning_record` VALUES (295, 2248, 3, '2026-03-15 11:00:00', 4, 1, '2026-03-05 13:00:00');
INSERT INTO `learning_record` VALUES (296, 2248, 4, '2026-03-16 12:00:00', 1, 1, '2026-03-06 10:00:00');
INSERT INTO `learning_record` VALUES (297, 2249, 5, '2026-03-18 08:00:00', 3, 1, '2026-03-08 11:00:00');
INSERT INTO `learning_record` VALUES (298, 2249, 6, '2026-03-19 09:00:00', 4, 1, '2026-03-09 12:00:00');
INSERT INTO `learning_record` VALUES (299, 2250, 7, '2026-03-21 10:00:00', 2, 1, '2026-03-11 13:00:00');
INSERT INTO `learning_record` VALUES (300, 2250, 8, '2026-03-22 11:00:00', 3, 1, '2026-03-12 10:00:00');
INSERT INTO `learning_record` VALUES (301, 2251, 1, '2026-03-16 09:00:00', NULL, 1, '2026-03-06 11:00:00');
INSERT INTO `learning_record` VALUES (302, 2251, 2, '2026-03-17 10:00:00', 2, 1, '2026-03-07 12:00:00');
INSERT INTO `learning_record` VALUES (303, 2252, 3, '2026-03-19 11:00:00', 4, 1, '2026-03-09 13:00:00');
INSERT INTO `learning_record` VALUES (304, 2252, 4, '2026-03-20 12:00:00', 1, 0, '2026-03-10 10:00:00');
INSERT INTO `learning_record` VALUES (305, 2253, 5, '2026-03-22 08:00:00', 3, 1, '2026-03-12 11:00:00');
INSERT INTO `learning_record` VALUES (306, 2253, 6, '2026-03-23 09:00:00', NULL, 1, '2026-03-13 12:00:00');
INSERT INTO `learning_record` VALUES (307, 2254, 7, NULL, 2, 1, '2026-03-15 13:00:00');
INSERT INTO `learning_record` VALUES (308, 2254, 8, '2026-03-26 11:00:00', 3, 0, '2026-03-16 10:00:00');
INSERT INTO `learning_record` VALUES (309, 2255, 1, '2026-03-20 09:00:00', NULL, 0, '2026-03-10 11:00:00');
INSERT INTO `learning_record` VALUES (310, 2255, 2, '2026-03-21 10:00:00', 2, 1, '2026-03-11 12:00:00');
INSERT INTO `learning_record` VALUES (311, 2256, 3, '2026-03-23 11:00:00', NULL, 1, '2026-03-13 13:00:00');
INSERT INTO `learning_record` VALUES (312, 2256, 4, '2026-03-24 12:00:00', NULL, 0, '2026-03-14 10:00:00');
INSERT INTO `learning_record` VALUES (313, 2257, 5, '2026-03-26 08:00:00', 3, 0, '2026-03-16 11:00:00');
INSERT INTO `learning_record` VALUES (314, 2257, 6, '2026-03-27 09:00:00', 4, 1, '2026-03-17 12:00:00');
INSERT INTO `learning_record` VALUES (315, 2258, 7, '2026-03-29 10:00:00', 2, 1, '2026-03-19 13:00:00');
INSERT INTO `learning_record` VALUES (316, 2258, 8, '2026-03-30 11:00:00', 3, 1, '2026-03-20 10:00:00');
INSERT INTO `learning_record` VALUES (317, 2259, 1, '2026-03-24 09:00:00', 1, 1, '2026-03-14 11:00:00');
INSERT INTO `learning_record` VALUES (318, 2259, 2, NULL, 2, 1, '2026-03-15 12:00:00');
INSERT INTO `learning_record` VALUES (319, 2260, 3, '2026-03-27 11:00:00', 4, 1, '2026-03-17 13:00:00');
INSERT INTO `learning_record` VALUES (320, 2260, 4, '2026-03-28 12:00:00', 1, 1, '2026-03-18 10:00:00');
INSERT INTO `learning_record` VALUES (321, 2261, 5, '2026-03-30 08:00:00', 3, 1, '2026-03-20 11:00:00');
INSERT INTO `learning_record` VALUES (322, 2261, 6, '2026-03-31 09:00:00', 4, 1, '2026-03-21 12:00:00');
INSERT INTO `learning_record` VALUES (323, 2262, 7, '2026-03-05 10:00:00', 2, 1, '2026-03-23 13:00:00');
INSERT INTO `learning_record` VALUES (324, 2262, 8, '2026-03-06 11:00:00', 3, 1, '2026-03-24 10:00:00');
INSERT INTO `learning_record` VALUES (325, 2263, 1, '2026-03-28 09:00:00', 1, 1, '2026-03-18 11:00:00');
INSERT INTO `learning_record` VALUES (326, 2263, 2, '2026-03-29 10:00:00', 2, 1, '2026-03-19 12:00:00');
INSERT INTO `learning_record` VALUES (327, 2264, 3, '2026-03-31 11:00:00', 4, 1, '2026-03-21 13:00:00');
INSERT INTO `learning_record` VALUES (328, 2264, 4, '2026-03-04 12:00:00', NULL, 0, '2026-03-22 10:00:00');
INSERT INTO `learning_record` VALUES (329, 2265, 5, '2026-03-06 08:00:00', 3, 1, '2026-03-24 11:00:00');
INSERT INTO `learning_record` VALUES (330, 2265, 6, '2026-03-07 09:00:00', 4, 1, '2026-03-25 12:00:00');
INSERT INTO `learning_record` VALUES (331, 2266, 7, '2026-03-09 10:00:00', 2, 1, '2026-03-27 13:00:00');
INSERT INTO `learning_record` VALUES (332, 2266, 8, '2026-03-10 11:00:00', 3, 0, '2026-03-28 10:00:00');
INSERT INTO `learning_record` VALUES (333, 2267, 1, '2026-03-04 09:00:00', NULL, 0, '2026-03-22 11:00:00');
INSERT INTO `learning_record` VALUES (334, 2267, 2, '2026-03-05 10:00:00', 2, 1, '2026-03-23 12:00:00');
INSERT INTO `learning_record` VALUES (335, 2268, 3, '2026-03-07 11:00:00', 4, 1, '2026-03-25 13:00:00');
INSERT INTO `learning_record` VALUES (336, 2268, 4, '2026-03-08 12:00:00', NULL, 1, '2026-03-26 10:00:00');
INSERT INTO `learning_record` VALUES (337, 2269, 1, '2026-03-06 09:00:00', 3, 1, '2026-03-24 11:00:00');
INSERT INTO `learning_record` VALUES (338, 2269, 2, '2026-03-07 10:00:00', 4, 1, '2026-03-25 12:00:00');
INSERT INTO `learning_record` VALUES (339, 2270, 3, '2026-03-09 11:00:00', 2, 1, '2026-03-27 13:00:00');
INSERT INTO `learning_record` VALUES (340, 2270, 4, '2026-03-10 12:00:00', 3, 0, '2026-03-28 10:00:00');
INSERT INTO `learning_record` VALUES (341, 2271, 5, '2026-03-12 08:00:00', 1, 1, '2026-03-30 11:00:00');
INSERT INTO `learning_record` VALUES (342, 2271, 6, '2026-03-13 09:00:00', NULL, 1, '2026-03-31 12:00:00');
INSERT INTO `learning_record` VALUES (343, 2272, 7, '2026-03-15 10:00:00', 4, 1, '2026-04-02 13:00:00');
INSERT INTO `learning_record` VALUES (344, 2272, 8, NULL, 1, 0, '2026-03-04 10:00:00');
INSERT INTO `learning_record` VALUES (345, 2273, 1, '2026-03-10 09:00:00', 3, 0, '2026-03-28 11:00:00');
INSERT INTO `learning_record` VALUES (346, 2273, 2, '2026-03-11 10:00:00', 4, 1, '2026-03-29 12:00:00');
INSERT INTO `learning_record` VALUES (347, 2274, 3, '2026-03-13 11:00:00', NULL, 1, '2026-03-31 13:00:00');
INSERT INTO `learning_record` VALUES (348, 2274, 4, '2026-03-14 12:00:00', 3, 1, '2026-04-01 10:00:00');
INSERT INTO `learning_record` VALUES (349, 2275, 5, NULL, 1, 0, '2026-03-04 11:00:00');
INSERT INTO `learning_record` VALUES (350, 2275, 6, '2026-03-17 09:00:00', 2, 1, '2026-03-05 12:00:00');
INSERT INTO `learning_record` VALUES (351, 2276, 7, '2026-03-19 10:00:00', 4, 1, '2026-03-07 13:00:00');
INSERT INTO `learning_record` VALUES (352, 2276, 8, '2026-03-20 11:00:00', 1, 1, '2026-03-08 10:00:00');
INSERT INTO `learning_record` VALUES (353, 2277, 1, '2026-03-14 09:00:00', 3, 1, '2026-04-01 11:00:00');
INSERT INTO `learning_record` VALUES (354, 2277, 2, '2026-03-15 10:00:00', 4, 1, '2026-04-02 12:00:00');
INSERT INTO `learning_record` VALUES (355, 2278, 3, '2026-03-17 11:00:00', 2, 1, '2026-03-05 13:00:00');
INSERT INTO `learning_record` VALUES (356, 2278, 4, '2026-03-18 12:00:00', 3, 1, '2026-03-06 10:00:00');
INSERT INTO `learning_record` VALUES (357, 2279, 5, '2026-03-20 08:00:00', 1, 1, '2026-03-08 11:00:00');
INSERT INTO `learning_record` VALUES (358, 2279, 6, '2026-03-21 09:00:00', 2, 1, '2026-03-09 12:00:00');
INSERT INTO `learning_record` VALUES (359, 2280, 7, '2026-03-23 10:00:00', 4, 1, '2026-03-11 13:00:00');
INSERT INTO `learning_record` VALUES (360, 2280, 8, '2026-03-24 11:00:00', NULL, 1, '2026-03-12 10:00:00');
INSERT INTO `learning_record` VALUES (361, 2281, 1, '2026-03-18 09:00:00', 3, 1, '2026-03-06 11:00:00');
INSERT INTO `learning_record` VALUES (362, 2281, 2, '2026-03-19 10:00:00', 4, 1, '2026-03-07 12:00:00');
INSERT INTO `learning_record` VALUES (363, 2282, 3, '2026-03-21 11:00:00', 2, 1, '2026-03-09 13:00:00');
INSERT INTO `learning_record` VALUES (364, 2282, 4, '2026-03-22 12:00:00', NULL, 0, '2026-03-10 10:00:00');
INSERT INTO `learning_record` VALUES (365, 2283, 5, '2026-03-24 08:00:00', 1, 1, '2026-03-12 11:00:00');
INSERT INTO `learning_record` VALUES (366, 2283, 6, '2026-03-25 09:00:00', 2, 1, '2026-03-13 12:00:00');
INSERT INTO `learning_record` VALUES (367, 2284, 7, '2026-03-27 10:00:00', 4, 1, '2026-03-15 13:00:00');
INSERT INTO `learning_record` VALUES (368, 2284, 8, '2026-03-28 11:00:00', 1, 0, '2026-03-16 10:00:00');
INSERT INTO `learning_record` VALUES (369, 2285, 1, '2026-03-22 09:00:00', NULL, 0, '2026-03-10 11:00:00');
INSERT INTO `learning_record` VALUES (370, 2285, 2, '2026-03-23 10:00:00', 4, 1, '2026-03-11 12:00:00');
INSERT INTO `learning_record` VALUES (371, 2286, 3, '2026-03-25 11:00:00', 2, 1, '2026-03-13 13:00:00');
INSERT INTO `learning_record` VALUES (372, 2286, 4, '2026-03-26 12:00:00', 3, 1, '2026-03-14 10:00:00');
INSERT INTO `learning_record` VALUES (373, 2287, 5, '2026-03-28 08:00:00', NULL, 0, '2026-03-16 11:00:00');
INSERT INTO `learning_record` VALUES (374, 2287, 6, '2026-03-29 09:00:00', 2, 1, '2026-03-17 12:00:00');
INSERT INTO `learning_record` VALUES (375, 2288, 7, '2026-03-31 10:00:00', NULL, 1, '2026-03-19 13:00:00');
INSERT INTO `learning_record` VALUES (376, 2288, 8, '2026-03-04 11:00:00', 1, 1, '2026-03-20 10:00:00');
INSERT INTO `learning_record` VALUES (377, 2289, 1, '2026-03-26 09:00:00', 3, 1, '2026-03-14 11:00:00');
INSERT INTO `learning_record` VALUES (378, 2289, 2, '2026-03-27 10:00:00', 4, 1, '2026-03-15 12:00:00');
INSERT INTO `learning_record` VALUES (379, 2290, 3, '2026-03-29 11:00:00', 2, 1, '2026-03-17 13:00:00');
INSERT INTO `learning_record` VALUES (380, 2290, 4, '2026-03-30 12:00:00', 3, 1, '2026-03-18 10:00:00');
INSERT INTO `learning_record` VALUES (381, 2291, 5, '2026-03-04 08:00:00', NULL, 1, '2026-03-20 11:00:00');
INSERT INTO `learning_record` VALUES (382, 2291, 6, '2026-03-05 09:00:00', 2, 1, '2026-03-21 12:00:00');
INSERT INTO `learning_record` VALUES (383, 2292, 7, NULL, 4, 1, '2026-03-23 13:00:00');
INSERT INTO `learning_record` VALUES (384, 2292, 8, '2026-03-08 11:00:00', NULL, 0, '2026-03-24 10:00:00');
INSERT INTO `learning_record` VALUES (385, 2293, 1, '2026-03-30 09:00:00', 3, 1, '2026-03-18 11:00:00');
INSERT INTO `learning_record` VALUES (386, 2293, 2, '2026-03-31 10:00:00', NULL, 1, '2026-03-19 12:00:00');
INSERT INTO `learning_record` VALUES (387, 2294, 3, '2026-03-05 11:00:00', 2, 1, '2026-03-21 13:00:00');
INSERT INTO `learning_record` VALUES (388, 2294, 4, '2026-03-06 12:00:00', 3, 0, '2026-03-22 10:00:00');
INSERT INTO `learning_record` VALUES (389, 2295, 5, '2026-03-08 08:00:00', 1, 1, '2026-03-24 11:00:00');
INSERT INTO `learning_record` VALUES (390, 2295, 6, '2026-03-09 09:00:00', 2, 1, '2026-03-25 12:00:00');
INSERT INTO `learning_record` VALUES (391, 2296, 7, '2026-03-11 10:00:00', 4, 1, '2026-03-27 13:00:00');
INSERT INTO `learning_record` VALUES (392, 2296, 8, '2026-03-12 11:00:00', NULL, 0, '2026-03-28 10:00:00');
INSERT INTO `learning_record` VALUES (393, 2297, 1, '2026-03-06 09:00:00', 3, 0, '2026-03-22 11:00:00');
INSERT INTO `learning_record` VALUES (394, 2297, 2, NULL, 4, 1, '2026-03-23 12:00:00');
INSERT INTO `learning_record` VALUES (395, 2298, 3, '2026-03-09 11:00:00', 2, 1, '2026-03-25 13:00:00');
INSERT INTO `learning_record` VALUES (396, 2298, 4, '2026-03-10 12:00:00', 3, 1, '2026-03-26 10:00:00');
INSERT INTO `learning_record` VALUES (397, 2299, 5, '2026-03-12 08:00:00', NULL, 0, '2026-03-28 11:00:00');
INSERT INTO `learning_record` VALUES (398, 2299, 6, '2026-03-13 09:00:00', 2, 1, '2026-03-29 12:00:00');
INSERT INTO `learning_record` VALUES (399, 2300, 7, '2026-03-15 10:00:00', 4, 1, '2026-03-31 13:00:00');
INSERT INTO `learning_record` VALUES (400, 2300, 8, '2026-03-16 11:00:00', 1, 1, '2026-04-01 10:00:00');
INSERT INTO `learning_record` VALUES (401, 2301, 1, '2026-03-10 09:00:00', 3, 1, '2026-03-26 11:00:00');
INSERT INTO `learning_record` VALUES (402, 2301, 2, '2026-03-11 10:00:00', 4, 1, '2026-03-27 12:00:00');
INSERT INTO `learning_record` VALUES (403, 2302, 3, '2026-03-13 11:00:00', 2, 0, '2026-03-29 13:00:00');
INSERT INTO `learning_record` VALUES (404, 2302, 4, '2026-03-14 12:00:00', 3, 1, '2026-03-30 10:00:00');
INSERT INTO `learning_record` VALUES (405, 2303, 5, '2026-03-16 08:00:00', NULL, 1, '2026-04-01 11:00:00');
INSERT INTO `learning_record` VALUES (406, 2303, 6, '2026-03-17 09:00:00', 2, 1, '2026-04-02 12:00:00');
INSERT INTO `learning_record` VALUES (407, 2304, 7, '2026-03-19 10:00:00', 4, 1, '2026-03-05 13:00:00');
INSERT INTO `learning_record` VALUES (408, 2304, 8, '2026-03-20 11:00:00', NULL, 1, '2026-03-06 10:00:00');
INSERT INTO `learning_record` VALUES (409, 2305, 1, '2026-03-14 09:00:00', 3, 1, '2026-03-30 11:00:00');
INSERT INTO `learning_record` VALUES (410, 2305, 2, '2026-03-15 10:00:00', 4, 1, '2026-03-31 12:00:00');
INSERT INTO `learning_record` VALUES (411, 2306, 3, '2026-03-17 11:00:00', 2, 1, '2026-04-02 13:00:00');
INSERT INTO `learning_record` VALUES (412, 2306, 4, '2026-03-18 12:00:00', 3, 0, '2026-03-04 10:00:00');
INSERT INTO `learning_record` VALUES (413, 2307, 5, '2026-03-20 08:00:00', 1, 1, '2026-03-06 11:00:00');
INSERT INTO `learning_record` VALUES (414, 2307, 6, '2026-03-21 09:00:00', NULL, 1, '2026-03-07 12:00:00');
INSERT INTO `learning_record` VALUES (415, 2308, 7, '2026-03-23 10:00:00', 4, 1, '2026-03-09 13:00:00');
INSERT INTO `learning_record` VALUES (416, 2308, 8, '2026-03-24 11:00:00', 1, 0, '2026-03-10 10:00:00');
INSERT INTO `learning_record` VALUES (417, 2309, 1, '2026-03-18 09:00:00', 3, 0, '2026-03-04 11:00:00');
INSERT INTO `learning_record` VALUES (418, 2309, 2, '2026-03-19 10:00:00', 4, 1, '2026-03-05 12:00:00');
INSERT INTO `learning_record` VALUES (419, 2310, 3, '2026-03-21 11:00:00', NULL, 1, '2026-03-07 13:00:00');
INSERT INTO `learning_record` VALUES (420, 2310, 4, '2026-03-22 12:00:00', 3, 1, '2026-03-08 10:00:00');
INSERT INTO `learning_record` VALUES (421, 2311, 1, '2026-03-20 09:00:00', 1, 1, '2026-03-06 11:00:00');
INSERT INTO `learning_record` VALUES (422, 2311, 2, '2026-03-21 10:00:00', NULL, 1, '2026-03-07 12:00:00');
INSERT INTO `learning_record` VALUES (423, 2312, 3, '2026-03-23 11:00:00', 4, 1, '2026-03-09 13:00:00');
INSERT INTO `learning_record` VALUES (424, 2312, 4, '2026-03-24 12:00:00', 1, 0, '2026-03-10 10:00:00');
INSERT INTO `learning_record` VALUES (425, 2313, 5, NULL, 3, 1, '2026-03-12 11:00:00');
INSERT INTO `learning_record` VALUES (426, 2313, 6, '2026-03-27 09:00:00', 4, 1, '2026-03-13 12:00:00');
INSERT INTO `learning_record` VALUES (427, 2314, 7, '2026-03-29 10:00:00', 2, 1, '2026-03-15 13:00:00');
INSERT INTO `learning_record` VALUES (428, 2314, 8, '2026-03-30 11:00:00', NULL, 0, '2026-03-16 10:00:00');
INSERT INTO `learning_record` VALUES (429, 2315, 1, '2026-03-24 09:00:00', NULL, 0, '2026-03-10 11:00:00');
INSERT INTO `learning_record` VALUES (430, 2315, 2, '2026-03-25 10:00:00', 2, 1, '2026-03-11 12:00:00');
INSERT INTO `learning_record` VALUES (431, 2316, 3, '2026-03-27 11:00:00', 4, 1, '2026-03-13 13:00:00');
INSERT INTO `learning_record` VALUES (432, 2316, 4, '2026-03-28 12:00:00', 1, 1, '2026-03-14 10:00:00');
INSERT INTO `learning_record` VALUES (433, 2317, 5, '2026-03-30 08:00:00', NULL, 0, '2026-03-16 11:00:00');
INSERT INTO `learning_record` VALUES (434, 2317, 6, '2026-03-31 09:00:00', 4, 1, '2026-03-17 12:00:00');
INSERT INTO `learning_record` VALUES (435, 2318, 7, '2026-03-05 10:00:00', 2, 1, '2026-03-19 13:00:00');
INSERT INTO `learning_record` VALUES (436, 2318, 8, '2026-03-06 11:00:00', 3, 1, '2026-03-20 10:00:00');
INSERT INTO `learning_record` VALUES (437, 2319, 1, '2026-03-28 09:00:00', 1, 1, '2026-03-14 11:00:00');
INSERT INTO `learning_record` VALUES (438, 2319, 2, '2026-03-29 10:00:00', 2, 1, '2026-03-15 12:00:00');
INSERT INTO `learning_record` VALUES (439, 2320, 3, '2026-03-31 11:00:00', 4, 1, '2026-03-17 13:00:00');
INSERT INTO `learning_record` VALUES (440, 2320, 4, '2026-03-04 12:00:00', NULL, 1, '2026-03-18 10:00:00');
INSERT INTO `learning_record` VALUES (441, 2321, 5, '2026-03-06 08:00:00', 3, 1, '2026-03-20 11:00:00');
INSERT INTO `learning_record` VALUES (442, 2321, 6, '2026-03-07 09:00:00', 4, 1, '2026-03-21 12:00:00');
INSERT INTO `learning_record` VALUES (443, 2322, 7, '2026-03-09 10:00:00', 2, 1, '2026-03-23 13:00:00');
INSERT INTO `learning_record` VALUES (444, 2322, 8, '2026-03-10 11:00:00', 3, 1, '2026-03-24 10:00:00');
INSERT INTO `learning_record` VALUES (445, 2323, 1, '2026-03-04 09:00:00', 1, 1, '2026-03-18 11:00:00');
INSERT INTO `learning_record` VALUES (446, 2323, 2, '2026-03-05 10:00:00', 2, 1, '2026-03-19 12:00:00');
INSERT INTO `learning_record` VALUES (447, 2324, 3, '2026-03-07 11:00:00', 4, 1, '2026-03-21 13:00:00');
INSERT INTO `learning_record` VALUES (448, 2324, 4, '2026-03-08 12:00:00', NULL, 0, '2026-03-22 10:00:00');
INSERT INTO `learning_record` VALUES (449, 2325, 5, '2026-03-10 08:00:00', 3, 1, '2026-03-24 11:00:00');
INSERT INTO `learning_record` VALUES (450, 2325, 6, '2026-03-11 09:00:00', NULL, 1, '2026-03-25 12:00:00');
INSERT INTO `learning_record` VALUES (451, 2326, 7, '2026-03-13 10:00:00', 2, 1, '2026-03-27 13:00:00');
INSERT INTO `learning_record` VALUES (452, 2326, 8, '2026-03-14 11:00:00', 3, 0, '2026-03-28 10:00:00');
INSERT INTO `learning_record` VALUES (453, 2327, 1, '2026-03-08 09:00:00', NULL, 0, '2026-03-22 11:00:00');
INSERT INTO `learning_record` VALUES (454, 2327, 2, '2026-03-09 10:00:00', 2, 1, '2026-03-23 12:00:00');
INSERT INTO `learning_record` VALUES (455, 2328, 3, '2026-03-11 11:00:00', NULL, 1, '2026-03-25 13:00:00');
INSERT INTO `learning_record` VALUES (456, 2328, 4, '2026-03-12 12:00:00', NULL, 1, '2026-03-26 10:00:00');
INSERT INTO `learning_record` VALUES (457, 2329, 5, '2026-03-14 08:00:00', 3, 0, '2026-03-28 11:00:00');
INSERT INTO `learning_record` VALUES (458, 2329, 6, '2026-03-15 09:00:00', 4, 1, '2026-03-29 12:00:00');
INSERT INTO `learning_record` VALUES (459, 2330, 7, NULL, 2, 1, '2026-03-31 13:00:00');
INSERT INTO `learning_record` VALUES (460, 2330, 8, '2026-03-18 11:00:00', 3, 1, '2026-04-01 10:00:00');
INSERT INTO `learning_record` VALUES (461, 2331, 1, '2026-03-12 09:00:00', NULL, 1, '2026-03-26 11:00:00');
INSERT INTO `learning_record` VALUES (462, 2331, 2, '2026-03-13 10:00:00', 2, 1, '2026-03-27 12:00:00');
INSERT INTO `learning_record` VALUES (463, 2332, 3, '2026-03-15 11:00:00', 4, 1, '2026-03-29 13:00:00');
INSERT INTO `learning_record` VALUES (464, 2332, 4, '2026-03-16 12:00:00', 1, 1, '2026-03-30 10:00:00');
INSERT INTO `learning_record` VALUES (465, 2333, 5, '2026-03-18 08:00:00', 3, 1, '2026-04-01 11:00:00');
INSERT INTO `learning_record` VALUES (466, 2333, 6, '2026-03-19 09:00:00', 4, 1, '2026-04-02 12:00:00');
INSERT INTO `learning_record` VALUES (467, 2334, 7, '2026-03-21 10:00:00', 2, 1, '2026-03-05 13:00:00');
INSERT INTO `learning_record` VALUES (468, 2334, 8, '2026-03-22 11:00:00', 3, 1, '2026-03-06 10:00:00');
INSERT INTO `learning_record` VALUES (469, 2335, 1, '2026-03-16 09:00:00', NULL, 1, '2026-03-30 11:00:00');
INSERT INTO `learning_record` VALUES (470, 2335, 2, NULL, 2, 1, '2026-03-31 12:00:00');
INSERT INTO `learning_record` VALUES (471, 2336, 3, '2026-03-19 11:00:00', 4, 1, '2026-04-02 13:00:00');
INSERT INTO `learning_record` VALUES (472, 2336, 4, '2026-03-20 12:00:00', NULL, 0, '2026-03-04 10:00:00');
INSERT INTO `learning_record` VALUES (473, 2337, 5, '2026-03-22 08:00:00', 3, 1, '2026-03-06 11:00:00');
INSERT INTO `learning_record` VALUES (474, 2337, 6, '2026-03-23 09:00:00', 4, 1, '2026-03-07 12:00:00');
INSERT INTO `learning_record` VALUES (475, 2338, 7, '2026-03-25 10:00:00', 2, 1, '2026-03-09 13:00:00');
INSERT INTO `learning_record` VALUES (476, 2338, 8, '2026-03-26 11:00:00', 3, 0, '2026-03-10 10:00:00');
INSERT INTO `learning_record` VALUES (477, 2339, 1, '2026-03-20 09:00:00', NULL, 0, '2026-03-04 11:00:00');
INSERT INTO `learning_record` VALUES (478, 2339, 2, '2026-03-21 10:00:00', 2, 1, '2026-03-05 12:00:00');
INSERT INTO `learning_record` VALUES (479, 2340, 3, '2026-03-23 11:00:00', 4, 1, '2026-03-07 13:00:00');
INSERT INTO `learning_record` VALUES (480, 2340, 4, '2026-03-24 12:00:00', NULL, 1, '2026-03-08 10:00:00');
INSERT INTO `learning_record` VALUES (481, 2341, 5, '2026-03-26 08:00:00', 3, 0, '2026-03-10 11:00:00');
INSERT INTO `learning_record` VALUES (482, 2341, 6, '2026-03-27 09:00:00', 4, 1, '2026-03-11 12:00:00');
INSERT INTO `learning_record` VALUES (483, 2342, 7, '2026-03-29 10:00:00', NULL, 1, '2026-03-13 13:00:00');
INSERT INTO `learning_record` VALUES (484, 2342, 8, '2026-03-30 11:00:00', 3, 1, '2026-03-14 10:00:00');
INSERT INTO `learning_record` VALUES (485, 2343, 1, '2026-03-24 09:00:00', 1, 1, '2026-03-08 11:00:00');
INSERT INTO `learning_record` VALUES (486, 2343, 2, '2026-03-25 10:00:00', 2, 1, '2026-03-09 12:00:00');
INSERT INTO `learning_record` VALUES (487, 2344, 3, '2026-03-27 11:00:00', 4, 1, '2026-03-11 13:00:00');
INSERT INTO `learning_record` VALUES (488, 2344, 4, '2026-03-28 12:00:00', 1, 1, '2026-03-12 10:00:00');
INSERT INTO `learning_record` VALUES (489, 2345, 5, '2026-03-30 08:00:00', 3, 1, '2026-03-14 11:00:00');
INSERT INTO `learning_record` VALUES (490, 2345, 6, '2026-03-31 09:00:00', 4, 1, '2026-03-15 12:00:00');
INSERT INTO `learning_record` VALUES (491, 2346, 7, '2026-03-05 10:00:00', 2, 1, '2026-03-17 13:00:00');
INSERT INTO `learning_record` VALUES (492, 2346, 8, '2026-03-06 11:00:00', 3, 1, '2026-03-18 10:00:00');
INSERT INTO `learning_record` VALUES (493, 2347, 1, '2026-03-28 09:00:00', 1, 1, '2026-03-12 11:00:00');
INSERT INTO `learning_record` VALUES (494, 2347, 2, '2026-03-29 10:00:00', NULL, 1, '2026-03-13 12:00:00');
INSERT INTO `learning_record` VALUES (495, 2348, 3, '2026-03-31 11:00:00', 4, 1, '2026-03-15 13:00:00');
INSERT INTO `learning_record` VALUES (496, 2348, 4, '2026-03-04 12:00:00', 1, 0, '2026-03-16 10:00:00');
INSERT INTO `learning_record` VALUES (497, 2349, 5, '2026-03-06 08:00:00', 3, 1, '2026-03-18 11:00:00');
INSERT INTO `learning_record` VALUES (498, 2349, 6, '2026-03-07 09:00:00', 4, 1, '2026-03-19 12:00:00');
INSERT INTO `learning_record` VALUES (499, 2350, 7, '2026-03-09 10:00:00', 2, 1, '2026-03-21 13:00:00');
INSERT INTO `learning_record` VALUES (500, 2350, 8, '2026-03-10 11:00:00', NULL, 0, '2026-03-22 10:00:00');
INSERT INTO `learning_record` VALUES (501, 2351, 1, '2026-03-04 09:00:00', NULL, 0, '2026-03-16 11:00:00');
INSERT INTO `learning_record` VALUES (502, 2351, 2, '2026-03-05 10:00:00', 2, 1, '2026-03-17 12:00:00');
INSERT INTO `learning_record` VALUES (503, 2352, 3, '2026-03-07 11:00:00', 4, 1, '2026-03-19 13:00:00');
INSERT INTO `learning_record` VALUES (504, 2352, 4, NULL, NULL, 1, '2026-03-20 10:00:00');
INSERT INTO `learning_record` VALUES (505, 2353, 1, '2026-03-06 09:00:00', 3, 1, '2026-03-18 11:00:00');
INSERT INTO `learning_record` VALUES (506, 2353, 2, '2026-03-07 10:00:00', 4, 1, '2026-03-19 12:00:00');
INSERT INTO `learning_record` VALUES (507, 2354, 3, '2026-03-09 11:00:00', 2, 1, '2026-03-21 13:00:00');
INSERT INTO `learning_record` VALUES (508, 2354, 4, '2026-03-10 12:00:00', NULL, 0, '2026-03-22 10:00:00');
INSERT INTO `learning_record` VALUES (509, 2355, 5, '2026-03-12 08:00:00', 1, 1, '2026-03-24 11:00:00');
INSERT INTO `learning_record` VALUES (510, 2355, 6, '2026-03-13 09:00:00', 2, 1, '2026-03-25 12:00:00');
INSERT INTO `learning_record` VALUES (511, 2356, 7, '2026-03-15 10:00:00', 4, 1, '2026-03-27 13:00:00');
INSERT INTO `learning_record` VALUES (512, 2356, 8, '2026-03-16 11:00:00', 1, 0, '2026-03-28 10:00:00');
INSERT INTO `learning_record` VALUES (513, 2357, 1, '2026-03-10 09:00:00', NULL, 0, '2026-03-22 11:00:00');
INSERT INTO `learning_record` VALUES (514, 2357, 2, '2026-03-11 10:00:00', 4, 1, '2026-03-23 12:00:00');
INSERT INTO `learning_record` VALUES (515, 2358, 3, '2026-03-13 11:00:00', 2, 1, '2026-03-25 13:00:00');
INSERT INTO `learning_record` VALUES (516, 2358, 4, '2026-03-14 12:00:00', 3, 1, '2026-03-26 10:00:00');
INSERT INTO `learning_record` VALUES (517, 2359, 5, '2026-03-16 08:00:00', 1, 0, '2026-03-28 11:00:00');
INSERT INTO `learning_record` VALUES (518, 2359, 6, '2026-03-17 09:00:00', 2, 1, '2026-03-29 12:00:00');
INSERT INTO `learning_record` VALUES (519, 2360, 7, '2026-03-19 10:00:00', NULL, 1, '2026-03-31 13:00:00');
INSERT INTO `learning_record` VALUES (520, 2360, 8, '2026-03-20 11:00:00', 1, 1, '2026-04-01 10:00:00');
INSERT INTO `learning_record` VALUES (521, 2361, 1, '2026-03-14 09:00:00', 3, 1, '2026-03-26 11:00:00');
INSERT INTO `learning_record` VALUES (522, 2361, 2, '2026-03-15 10:00:00', 4, 1, '2026-03-27 12:00:00');
INSERT INTO `learning_record` VALUES (523, 2362, 3, '2026-03-17 11:00:00', 2, 0, '2026-03-29 13:00:00');
INSERT INTO `learning_record` VALUES (524, 2362, 4, '2026-03-18 12:00:00', 3, 1, '2026-03-30 10:00:00');
INSERT INTO `learning_record` VALUES (525, 2363, 5, '2026-03-20 08:00:00', 1, 1, '2026-04-01 11:00:00');
INSERT INTO `learning_record` VALUES (526, 2363, 6, '2026-03-21 09:00:00', 2, 1, '2026-04-02 12:00:00');
INSERT INTO `learning_record` VALUES (527, 2364, 7, '2026-03-23 10:00:00', 4, 1, '2026-03-05 13:00:00');
INSERT INTO `learning_record` VALUES (528, 2364, 8, '2026-03-24 11:00:00', NULL, 1, '2026-03-06 10:00:00');
INSERT INTO `learning_record` VALUES (529, 2365, 1, '2026-03-18 09:00:00', 3, 1, '2026-03-30 11:00:00');
INSERT INTO `learning_record` VALUES (530, 2365, 2, '2026-03-19 10:00:00', NULL, 1, '2026-03-31 12:00:00');
INSERT INTO `learning_record` VALUES (531, 2366, 3, '2026-03-21 11:00:00', 2, 1, '2026-04-02 13:00:00');
INSERT INTO `learning_record` VALUES (532, 2366, 4, '2026-03-22 12:00:00', 3, 0, '2026-03-04 10:00:00');
INSERT INTO `learning_record` VALUES (533, 2367, 5, '2026-03-24 08:00:00', 1, 1, '2026-03-06 11:00:00');
INSERT INTO `learning_record` VALUES (534, 2367, 6, '2026-03-25 09:00:00', 2, 1, '2026-03-07 12:00:00');
INSERT INTO `learning_record` VALUES (535, 2368, 7, NULL, 4, 1, '2026-03-09 13:00:00');
INSERT INTO `learning_record` VALUES (536, 2368, 8, '2026-03-28 11:00:00', NULL, 0, '2026-03-10 10:00:00');
INSERT INTO `learning_record` VALUES (537, 2369, 1, '2026-03-22 09:00:00', 3, 0, '2026-03-04 11:00:00');
INSERT INTO `learning_record` VALUES (538, 2369, 2, '2026-03-23 10:00:00', 4, 1, '2026-03-05 12:00:00');
INSERT INTO `learning_record` VALUES (539, 2370, 3, '2026-03-25 11:00:00', 2, 1, '2026-03-07 13:00:00');
INSERT INTO `learning_record` VALUES (540, 2370, 4, '2026-03-26 12:00:00', 3, 1, '2026-03-08 10:00:00');
INSERT INTO `learning_record` VALUES (541, 2371, 5, '2026-03-28 08:00:00', NULL, 0, '2026-03-10 11:00:00');
INSERT INTO `learning_record` VALUES (542, 2371, 6, '2026-03-29 09:00:00', 2, 1, '2026-03-11 12:00:00');
INSERT INTO `learning_record` VALUES (543, 2372, 7, '2026-03-31 10:00:00', 4, 1, '2026-03-13 13:00:00');
INSERT INTO `learning_record` VALUES (544, 2372, 8, '2026-03-04 11:00:00', 1, 1, '2026-03-14 10:00:00');
INSERT INTO `learning_record` VALUES (545, 2373, 1, '2026-03-26 09:00:00', 3, 1, '2026-03-08 11:00:00');
INSERT INTO `learning_record` VALUES (546, 2373, 2, NULL, 4, 1, '2026-03-09 12:00:00');
INSERT INTO `learning_record` VALUES (547, 2374, 3, '2026-03-29 11:00:00', 2, 1, '2026-03-11 13:00:00');
INSERT INTO `learning_record` VALUES (548, 2374, 4, '2026-03-30 12:00:00', 3, 1, '2026-03-12 10:00:00');
INSERT INTO `learning_record` VALUES (549, 2375, 5, '2026-03-04 08:00:00', NULL, 0, '2026-03-14 11:00:00');
INSERT INTO `learning_record` VALUES (550, 2375, 6, '2026-03-05 09:00:00', 2, 1, '2026-03-15 12:00:00');
INSERT INTO `learning_record` VALUES (551, 2376, 7, '2026-03-07 10:00:00', 4, 1, '2026-03-17 13:00:00');
INSERT INTO `learning_record` VALUES (552, 2376, 8, '2026-03-08 11:00:00', NULL, 1, '2026-03-18 10:00:00');
INSERT INTO `learning_record` VALUES (553, 2377, 1, '2026-03-30 09:00:00', 3, 1, '2026-03-12 11:00:00');
INSERT INTO `learning_record` VALUES (554, 2377, 2, '2026-03-31 10:00:00', 4, 1, '2026-03-13 12:00:00');
INSERT INTO `learning_record` VALUES (555, 2378, 3, '2026-03-05 11:00:00', 2, 1, '2026-03-15 13:00:00');
INSERT INTO `learning_record` VALUES (556, 2378, 4, '2026-03-06 12:00:00', 3, 0, '2026-03-16 10:00:00');
INSERT INTO `learning_record` VALUES (557, 2379, 5, '2026-03-08 08:00:00', 1, 1, '2026-03-18 11:00:00');
INSERT INTO `learning_record` VALUES (558, 2379, 6, '2026-03-09 09:00:00', NULL, 1, '2026-03-19 12:00:00');
INSERT INTO `learning_record` VALUES (559, 2380, 7, '2026-03-11 10:00:00', 4, 1, '2026-03-21 13:00:00');
INSERT INTO `learning_record` VALUES (560, 2380, 8, '2026-03-12 11:00:00', 1, 0, '2026-03-22 10:00:00');
INSERT INTO `learning_record` VALUES (561, 2381, 1, '2026-03-06 09:00:00', 3, 0, '2026-03-16 11:00:00');
INSERT INTO `learning_record` VALUES (562, 2381, 2, '2026-03-07 10:00:00', 4, 1, '2026-03-17 12:00:00');
INSERT INTO `learning_record` VALUES (563, 2382, 3, '2026-03-09 11:00:00', NULL, 1, '2026-03-19 13:00:00');
INSERT INTO `learning_record` VALUES (564, 2382, 4, '2026-03-10 12:00:00', 3, 1, '2026-03-20 10:00:00');
INSERT INTO `learning_record` VALUES (565, 2383, 5, '2026-03-12 08:00:00', 1, 0, '2026-03-22 11:00:00');
INSERT INTO `learning_record` VALUES (566, 2383, 6, '2026-03-13 09:00:00', 2, 1, '2026-03-23 12:00:00');
INSERT INTO `learning_record` VALUES (567, 2384, 7, '2026-03-15 10:00:00', 4, 1, '2026-03-25 13:00:00');
INSERT INTO `learning_record` VALUES (568, 2384, 8, '2026-03-16 11:00:00', 1, 1, '2026-03-26 10:00:00');
INSERT INTO `learning_record` VALUES (569, 2385, 1, '2026-03-10 09:00:00', 3, 1, '2026-03-20 11:00:00');
INSERT INTO `learning_record` VALUES (570, 2385, 2, '2026-03-11 10:00:00', 4, 1, '2026-03-21 12:00:00');
INSERT INTO `learning_record` VALUES (571, 2386, 3, '2026-03-13 11:00:00', 2, 1, '2026-03-23 13:00:00');
INSERT INTO `learning_record` VALUES (572, 2386, 4, '2026-03-14 12:00:00', 3, 0, '2026-03-24 10:00:00');
INSERT INTO `learning_record` VALUES (573, 2387, 5, '2026-03-16 08:00:00', NULL, 1, '2026-03-26 11:00:00');
INSERT INTO `learning_record` VALUES (574, 2387, 6, '2026-03-17 09:00:00', 2, 1, '2026-03-27 12:00:00');
INSERT INTO `learning_record` VALUES (575, 2388, 7, '2026-03-19 10:00:00', 4, 1, '2026-03-29 13:00:00');
INSERT INTO `learning_record` VALUES (576, 2388, 8, '2026-03-20 11:00:00', NULL, 1, '2026-03-30 10:00:00');
INSERT INTO `learning_record` VALUES (577, 2389, 1, '2026-03-14 09:00:00', 3, 1, '2026-03-24 11:00:00');
INSERT INTO `learning_record` VALUES (578, 2389, 2, '2026-03-15 10:00:00', 4, 1, '2026-03-25 12:00:00');
INSERT INTO `learning_record` VALUES (579, 2390, 3, '2026-03-17 11:00:00', 2, 1, '2026-03-27 13:00:00');
INSERT INTO `learning_record` VALUES (580, 2390, 4, NULL, NULL, 0, '2026-03-28 10:00:00');
INSERT INTO `learning_record` VALUES (581, 2391, 5, '2026-03-20 08:00:00', 1, 1, '2026-03-30 11:00:00');
INSERT INTO `learning_record` VALUES (582, 2391, 6, '2026-03-21 09:00:00', 2, 1, '2026-03-31 12:00:00');
INSERT INTO `learning_record` VALUES (583, 2392, 7, '2026-03-23 10:00:00', 4, 1, '2026-04-02 13:00:00');
INSERT INTO `learning_record` VALUES (584, 2392, 8, '2026-03-24 11:00:00', 1, 0, '2026-03-04 10:00:00');
INSERT INTO `learning_record` VALUES (585, 2393, 1, NULL, NULL, 0, '2026-03-28 11:00:00');
INSERT INTO `learning_record` VALUES (586, 2393, 2, '2026-03-19 10:00:00', 4, 1, '2026-03-29 12:00:00');
INSERT INTO `learning_record` VALUES (587, 2394, 3, '2026-03-21 11:00:00', 2, 1, '2026-03-31 13:00:00');
INSERT INTO `learning_record` VALUES (588, 2394, 4, '2026-03-22 12:00:00', 3, 1, '2026-04-01 10:00:00');
INSERT INTO `learning_record` VALUES (589, 2395, 1, '2026-03-20 09:00:00', 1, 1, '2026-03-30 11:00:00');
INSERT INTO `learning_record` VALUES (590, 2395, 2, '2026-03-21 10:00:00', 2, 1, '2026-03-31 12:00:00');
INSERT INTO `learning_record` VALUES (591, 2396, 3, '2026-03-23 11:00:00', 4, 1, '2026-04-02 13:00:00');
INSERT INTO `learning_record` VALUES (592, 2396, 4, '2026-03-24 12:00:00', 1, 0, '2026-03-04 10:00:00');
INSERT INTO `learning_record` VALUES (593, 2397, 5, '2026-03-26 08:00:00', 3, 1, '2026-03-06 11:00:00');
INSERT INTO `learning_record` VALUES (594, 2397, 6, '2026-03-27 09:00:00', NULL, 1, '2026-03-07 12:00:00');
INSERT INTO `learning_record` VALUES (595, 2398, 7, '2026-03-29 10:00:00', 2, 0, '2026-03-09 13:00:00');
INSERT INTO `learning_record` VALUES (596, 2398, 8, '2026-03-30 11:00:00', 3, 0, '2026-03-10 10:00:00');
INSERT INTO `learning_record` VALUES (597, 2399, 1, '2026-03-24 09:00:00', NULL, 0, '2026-03-04 11:00:00');
INSERT INTO `learning_record` VALUES (598, 2399, 2, '2026-03-25 10:00:00', 2, 1, '2026-03-05 12:00:00');
INSERT INTO `learning_record` VALUES (599, 2400, 3, '2026-03-27 11:00:00', NULL, 1, '2026-03-07 13:00:00');
INSERT INTO `learning_record` VALUES (600, 2400, 4, '2026-03-28 12:00:00', 1, 1, '2026-03-08 10:00:00');
INSERT INTO `learning_record` VALUES (601, 2401, 5, '2026-03-30 08:00:00', 3, 0, '2026-03-10 11:00:00');
INSERT INTO `learning_record` VALUES (602, 2401, 6, '2026-03-31 09:00:00', 4, 1, '2026-03-11 12:00:00');
INSERT INTO `learning_record` VALUES (603, 2402, 7, '2026-03-05 10:00:00', 2, 1, '2026-03-13 13:00:00');
INSERT INTO `learning_record` VALUES (604, 2402, 8, '2026-03-06 11:00:00', 3, 1, '2026-03-14 10:00:00');
INSERT INTO `learning_record` VALUES (605, 2403, 1, '2026-03-28 09:00:00', 1, 1, '2026-03-08 11:00:00');
INSERT INTO `learning_record` VALUES (606, 2403, 2, '2026-03-29 10:00:00', 2, 1, '2026-03-09 12:00:00');
INSERT INTO `learning_record` VALUES (607, 2404, 3, '2026-03-31 11:00:00', 4, 1, '2026-03-11 13:00:00');
INSERT INTO `learning_record` VALUES (608, 2404, 4, '2026-03-04 12:00:00', 1, 1, '2026-03-12 10:00:00');
INSERT INTO `learning_record` VALUES (609, 2405, 5, '2026-03-06 08:00:00', 3, 1, '2026-03-14 11:00:00');
INSERT INTO `learning_record` VALUES (610, 2405, 6, '2026-03-07 09:00:00', 4, 1, '2026-03-15 12:00:00');
INSERT INTO `learning_record` VALUES (611, 2406, 7, NULL, 2, 1, '2026-03-17 13:00:00');
INSERT INTO `learning_record` VALUES (612, 2406, 8, '2026-03-10 11:00:00', 3, 1, '2026-03-18 10:00:00');
INSERT INTO `learning_record` VALUES (613, 2407, 1, '2026-03-04 09:00:00', 1, 1, '2026-03-12 11:00:00');
INSERT INTO `learning_record` VALUES (614, 2407, 2, '2026-03-05 10:00:00', 2, 1, '2026-03-13 12:00:00');
INSERT INTO `learning_record` VALUES (615, 2408, 3, '2026-03-07 11:00:00', 4, 1, '2026-03-15 13:00:00');
INSERT INTO `learning_record` VALUES (616, 2408, 4, '2026-03-08 12:00:00', NULL, 0, '2026-03-16 10:00:00');
INSERT INTO `learning_record` VALUES (617, 2409, 5, '2026-03-10 08:00:00', 3, 1, '2026-03-18 11:00:00');
INSERT INTO `learning_record` VALUES (618, 2409, 6, '2026-03-11 09:00:00', 4, 1, '2026-03-19 12:00:00');
INSERT INTO `learning_record` VALUES (619, 2410, 7, '2026-03-13 10:00:00', 2, 1, '2026-03-21 13:00:00');
INSERT INTO `learning_record` VALUES (620, 2410, 8, '2026-03-14 11:00:00', 3, 0, '2026-03-22 10:00:00');
INSERT INTO `learning_record` VALUES (621, 2411, 1, '2026-03-08 09:00:00', NULL, 0, '2026-03-16 11:00:00');
INSERT INTO `learning_record` VALUES (622, 2411, 2, NULL, 2, 1, '2026-03-17 12:00:00');
INSERT INTO `learning_record` VALUES (623, 2412, 3, '2026-03-11 11:00:00', 4, 0, '2026-03-19 13:00:00');
INSERT INTO `learning_record` VALUES (624, 2412, 4, '2026-03-12 12:00:00', NULL, 1, '2026-03-20 10:00:00');
INSERT INTO `learning_record` VALUES (625, 2413, 5, '2026-03-14 08:00:00', 3, 0, '2026-03-22 11:00:00');
INSERT INTO `learning_record` VALUES (626, 2413, 6, '2026-03-15 09:00:00', 4, 1, '2026-03-23 12:00:00');
INSERT INTO `learning_record` VALUES (627, 2414, 7, '2026-03-17 10:00:00', NULL, 1, '2026-03-25 13:00:00');
INSERT INTO `learning_record` VALUES (628, 2414, 8, '2026-03-18 11:00:00', 3, 1, '2026-03-26 10:00:00');
INSERT INTO `learning_record` VALUES (629, 2415, 1, '2026-03-12 09:00:00', 1, 1, '2026-03-20 11:00:00');
INSERT INTO `learning_record` VALUES (630, 2415, 2, '2026-03-13 10:00:00', 2, 1, '2026-03-21 12:00:00');
INSERT INTO `learning_record` VALUES (631, 2416, 3, '2026-03-15 11:00:00', 4, 1, '2026-03-23 13:00:00');
INSERT INTO `learning_record` VALUES (632, 2416, 4, '2026-03-16 12:00:00', 1, 1, '2026-03-24 10:00:00');
INSERT INTO `learning_record` VALUES (633, 2417, 5, '2026-03-18 08:00:00', 3, 1, '2026-03-26 11:00:00');
INSERT INTO `learning_record` VALUES (634, 2417, 6, '2026-03-19 09:00:00', 4, 1, '2026-03-27 12:00:00');
INSERT INTO `learning_record` VALUES (635, 2418, 7, '2026-03-21 10:00:00', 2, 1, '2026-03-29 13:00:00');
INSERT INTO `learning_record` VALUES (636, 2418, 8, '2026-03-22 11:00:00', 3, 1, '2026-03-30 10:00:00');
INSERT INTO `learning_record` VALUES (637, 2419, 1, '2026-03-16 09:00:00', NULL, 1, '2026-03-24 11:00:00');
INSERT INTO `learning_record` VALUES (638, 2419, 2, '2026-03-17 10:00:00', NULL, 1, '2026-03-25 12:00:00');
INSERT INTO `learning_record` VALUES (639, 2420, 3, '2026-03-19 11:00:00', 4, 1, '2026-03-27 13:00:00');
INSERT INTO `learning_record` VALUES (640, 2420, 4, '2026-03-20 12:00:00', 1, 0, '2026-03-28 10:00:00');
INSERT INTO `learning_record` VALUES (641, 2421, 5, '2026-03-22 08:00:00', 3, 1, '2026-03-30 11:00:00');
INSERT INTO `learning_record` VALUES (642, 2421, 6, '2026-03-23 09:00:00', 4, 1, '2026-03-31 12:00:00');
INSERT INTO `learning_record` VALUES (643, 2422, 7, '2026-03-25 10:00:00', 2, 1, '2026-04-02 13:00:00');
INSERT INTO `learning_record` VALUES (644, 2422, 8, '2026-03-26 11:00:00', NULL, 0, '2026-03-04 10:00:00');
INSERT INTO `learning_record` VALUES (645, 2423, 1, '2026-03-20 09:00:00', NULL, 0, '2026-03-28 11:00:00');
INSERT INTO `learning_record` VALUES (646, 2423, 2, '2026-03-21 10:00:00', 2, 0, '2026-03-29 12:00:00');
INSERT INTO `learning_record` VALUES (647, 2424, 3, '2026-03-23 11:00:00', 4, 1, '2026-03-31 13:00:00');
INSERT INTO `learning_record` VALUES (648, 2424, 4, '2026-03-24 12:00:00', NULL, 1, '2026-04-01 10:00:00');
INSERT INTO `learning_record` VALUES (649, 2425, 5, '2026-03-26 08:00:00', NULL, 0, '2026-03-04 11:00:00');
INSERT INTO `learning_record` VALUES (650, 2425, 6, '2026-03-27 09:00:00', 4, 1, '2026-03-05 12:00:00');
INSERT INTO `learning_record` VALUES (651, 2426, 7, '2026-03-29 10:00:00', 2, 1, '2026-03-07 13:00:00');
INSERT INTO `learning_record` VALUES (652, 2426, 8, '2026-03-30 11:00:00', 3, 1, '2026-03-08 10:00:00');
INSERT INTO `learning_record` VALUES (653, 2427, 1, '2026-03-24 09:00:00', 1, 1, '2026-04-01 11:00:00');
INSERT INTO `learning_record` VALUES (654, 2427, 2, '2026-03-25 10:00:00', 2, 1, '2026-04-02 12:00:00');
INSERT INTO `learning_record` VALUES (655, 2428, 3, '2026-03-27 11:00:00', 4, 1, '2026-03-05 13:00:00');
INSERT INTO `learning_record` VALUES (656, 2428, 4, NULL, 1, 1, '2026-03-06 10:00:00');
INSERT INTO `learning_record` VALUES (657, 2429, 5, '2026-03-30 08:00:00', 3, 1, '2026-03-08 11:00:00');
INSERT INTO `learning_record` VALUES (658, 2429, 6, '2026-03-31 09:00:00', 4, 1, '2026-03-09 12:00:00');
INSERT INTO `learning_record` VALUES (659, 2430, 7, '2026-03-05 10:00:00', 2, 1, '2026-03-11 13:00:00');
INSERT INTO `learning_record` VALUES (660, 2430, 8, '2026-03-06 11:00:00', 3, 1, '2026-03-12 10:00:00');
INSERT INTO `learning_record` VALUES (661, 2431, 1, NULL, 1, 1, '2026-03-06 11:00:00');
INSERT INTO `learning_record` VALUES (662, 2431, 2, '2026-03-29 10:00:00', 2, 1, '2026-03-07 12:00:00');
INSERT INTO `learning_record` VALUES (663, 2432, 3, '2026-03-31 11:00:00', 4, 1, '2026-03-09 13:00:00');
INSERT INTO `learning_record` VALUES (664, 2432, 4, '2026-03-04 12:00:00', 1, 0, '2026-03-10 10:00:00');
INSERT INTO `learning_record` VALUES (665, 2433, 5, '2026-03-06 08:00:00', 3, 1, '2026-03-12 11:00:00');
INSERT INTO `learning_record` VALUES (666, 2433, 6, '2026-03-07 09:00:00', NULL, 1, '2026-03-13 12:00:00');
INSERT INTO `learning_record` VALUES (667, 2434, 7, '2026-03-09 10:00:00', 2, 1, '2026-03-15 13:00:00');
INSERT INTO `learning_record` VALUES (668, 2434, 8, '2026-03-10 11:00:00', 3, 0, '2026-03-16 10:00:00');
INSERT INTO `learning_record` VALUES (669, 2435, 1, '2026-03-04 09:00:00', NULL, 0, '2026-03-10 11:00:00');
INSERT INTO `learning_record` VALUES (670, 2435, 2, '2026-03-05 10:00:00', 2, 1, '2026-03-11 12:00:00');
INSERT INTO `learning_record` VALUES (671, 2436, 3, '2026-03-07 11:00:00', NULL, 1, '2026-03-13 13:00:00');
INSERT INTO `learning_record` VALUES (672, 2436, 4, '2026-03-08 12:00:00', NULL, 1, '2026-03-14 10:00:00');
INSERT INTO `learning_record` VALUES (673, 2437, 1, '2026-03-06 09:00:00', 3, 1, '2026-03-12 11:00:00');
INSERT INTO `learning_record` VALUES (674, 2437, 2, '2026-03-07 10:00:00', NULL, 1, '2026-03-13 12:00:00');
INSERT INTO `learning_record` VALUES (675, 2438, 3, '2026-03-09 11:00:00', 2, 1, '2026-03-15 13:00:00');
INSERT INTO `learning_record` VALUES (676, 2438, 4, '2026-03-10 12:00:00', 3, 0, '2026-03-16 10:00:00');
INSERT INTO `learning_record` VALUES (677, 2439, 5, '2026-03-12 08:00:00', 1, 1, '2026-03-18 11:00:00');
INSERT INTO `learning_record` VALUES (678, 2439, 6, '2026-03-13 09:00:00', 2, 1, '2026-03-19 12:00:00');
INSERT INTO `learning_record` VALUES (679, 2440, 7, '2026-03-15 10:00:00', 4, 1, '2026-03-21 13:00:00');
INSERT INTO `learning_record` VALUES (680, 2440, 8, '2026-03-16 11:00:00', NULL, 0, '2026-03-22 10:00:00');
INSERT INTO `learning_record` VALUES (681, 2441, 1, '2026-03-10 09:00:00', 3, 0, '2026-03-16 11:00:00');
INSERT INTO `learning_record` VALUES (682, 2441, 2, '2026-03-11 10:00:00', 4, 1, '2026-03-17 12:00:00');
INSERT INTO `learning_record` VALUES (683, 2442, 3, '2026-03-13 11:00:00', 2, 1, '2026-03-19 13:00:00');
INSERT INTO `learning_record` VALUES (684, 2442, 4, '2026-03-14 12:00:00', 3, 1, '2026-03-20 10:00:00');
INSERT INTO `learning_record` VALUES (685, 2443, 5, '2026-03-16 08:00:00', NULL, 0, '2026-03-22 11:00:00');
INSERT INTO `learning_record` VALUES (686, 2443, 6, '2026-03-17 09:00:00', 2, 1, '2026-03-23 12:00:00');
INSERT INTO `learning_record` VALUES (687, 2444, 7, NULL, 4, 1, '2026-03-25 13:00:00');
INSERT INTO `learning_record` VALUES (688, 2444, 8, '2026-03-20 11:00:00', 1, 1, '2026-03-26 10:00:00');
INSERT INTO `learning_record` VALUES (689, 2445, 1, '2026-03-14 09:00:00', 3, 1, '2026-03-20 11:00:00');
INSERT INTO `learning_record` VALUES (690, 2445, 2, '2026-03-15 10:00:00', 4, 1, '2026-03-21 12:00:00');
INSERT INTO `learning_record` VALUES (691, 2446, 3, '2026-03-17 11:00:00', 2, 1, '2026-03-23 13:00:00');
INSERT INTO `learning_record` VALUES (692, 2446, 4, '2026-03-18 12:00:00', 3, 0, '2026-03-24 10:00:00');
INSERT INTO `learning_record` VALUES (693, 2447, 5, '2026-03-20 08:00:00', 1, 1, '2026-03-26 11:00:00');
INSERT INTO `learning_record` VALUES (694, 2447, 6, '2026-03-21 09:00:00', 2, 1, '2026-03-27 12:00:00');
INSERT INTO `learning_record` VALUES (695, 2448, 7, '2026-03-23 10:00:00', 4, 1, '2026-03-29 13:00:00');
INSERT INTO `learning_record` VALUES (696, 2448, 8, '2026-03-24 11:00:00', 1, 1, '2026-03-30 10:00:00');
INSERT INTO `learning_record` VALUES (697, 2449, 1, '2026-03-18 09:00:00', 3, 1, '2026-03-24 11:00:00');
INSERT INTO `learning_record` VALUES (698, 2449, 2, NULL, 4, 1, '2026-03-25 12:00:00');
INSERT INTO `learning_record` VALUES (699, 2450, 3, '2026-03-21 11:00:00', 2, 1, '2026-03-27 13:00:00');
INSERT INTO `learning_record` VALUES (700, 2450, 4, '2026-03-22 12:00:00', 3, 0, '2026-03-28 10:00:00');
INSERT INTO `learning_record` VALUES (701, 2451, 5, '2026-03-24 08:00:00', 1, 1, '2026-03-30 11:00:00');
INSERT INTO `learning_record` VALUES (702, 2451, 6, '2026-03-25 09:00:00', NULL, 1, '2026-03-31 12:00:00');
INSERT INTO `learning_record` VALUES (703, 2452, 7, '2026-03-27 10:00:00', 4, 1, '2026-04-02 13:00:00');
INSERT INTO `learning_record` VALUES (704, 2452, 8, '2026-03-28 11:00:00', 1, 0, '2026-03-04 10:00:00');
INSERT INTO `learning_record` VALUES (705, 2453, 1, '2026-03-22 09:00:00', 3, 0, '2026-03-28 11:00:00');
INSERT INTO `learning_record` VALUES (706, 2453, 2, '2026-03-23 10:00:00', 4, 1, '2026-03-29 12:00:00');
INSERT INTO `learning_record` VALUES (707, 2454, 3, '2026-03-25 11:00:00', NULL, 1, '2026-03-31 13:00:00');
INSERT INTO `learning_record` VALUES (708, 2454, 4, '2026-03-26 12:00:00', 3, 1, '2026-04-01 10:00:00');
INSERT INTO `learning_record` VALUES (709, 2455, 5, '2026-03-28 08:00:00', 1, 0, '2026-03-04 11:00:00');
INSERT INTO `learning_record` VALUES (710, 2455, 6, '2026-03-29 09:00:00', 2, 1, '2026-03-05 12:00:00');
INSERT INTO `learning_record` VALUES (711, 2456, 7, '2026-03-31 10:00:00', 4, 1, '2026-03-07 13:00:00');
INSERT INTO `learning_record` VALUES (712, 2456, 8, '2026-03-04 11:00:00', 1, 1, '2026-03-08 10:00:00');
INSERT INTO `learning_record` VALUES (713, 2457, 1, '2026-03-26 09:00:00', 3, 1, '2026-04-01 11:00:00');
INSERT INTO `learning_record` VALUES (714, 2457, 2, '2026-03-27 10:00:00', 4, 1, '2026-04-02 12:00:00');
INSERT INTO `learning_record` VALUES (715, 2458, 3, '2026-03-29 11:00:00', 2, 1, '2026-03-05 13:00:00');
INSERT INTO `learning_record` VALUES (716, 2458, 4, '2026-03-30 12:00:00', 3, 1, '2026-03-06 10:00:00');
INSERT INTO `learning_record` VALUES (717, 2459, 5, '2026-03-04 08:00:00', 1, 1, '2026-03-08 11:00:00');
INSERT INTO `learning_record` VALUES (718, 2459, 6, '2026-03-05 09:00:00', 2, 1, '2026-03-09 12:00:00');
INSERT INTO `learning_record` VALUES (719, 2460, 7, '2026-03-07 10:00:00', 4, 1, '2026-03-11 13:00:00');
INSERT INTO `learning_record` VALUES (720, 2460, 8, '2026-03-08 11:00:00', NULL, 1, '2026-03-12 10:00:00');
INSERT INTO `learning_record` VALUES (721, 2461, 1, '2026-03-30 09:00:00', 3, 1, '2026-03-06 11:00:00');
INSERT INTO `learning_record` VALUES (722, 2461, 2, '2026-03-31 10:00:00', 4, 1, '2026-03-07 12:00:00');
INSERT INTO `learning_record` VALUES (723, 2462, 3, '2026-03-05 11:00:00', 2, 1, '2026-03-09 13:00:00');
INSERT INTO `learning_record` VALUES (724, 2462, 4, '2026-03-06 12:00:00', NULL, 0, '2026-03-10 10:00:00');
INSERT INTO `learning_record` VALUES (725, 2463, 5, '2026-03-08 08:00:00', 1, 1, '2026-03-12 11:00:00');
INSERT INTO `learning_record` VALUES (726, 2463, 6, '2026-03-09 09:00:00', 2, 1, '2026-03-13 12:00:00');
INSERT INTO `learning_record` VALUES (727, 2464, 7, '2026-03-11 10:00:00', 4, 1, '2026-03-15 13:00:00');
INSERT INTO `learning_record` VALUES (728, 2464, 8, '2026-03-12 11:00:00', 1, 0, '2026-03-16 10:00:00');
INSERT INTO `learning_record` VALUES (729, 2465, 1, '2026-03-06 09:00:00', NULL, 0, '2026-03-10 11:00:00');
INSERT INTO `learning_record` VALUES (730, 2465, 2, '2026-03-07 10:00:00', 4, 1, '2026-03-11 12:00:00');
INSERT INTO `learning_record` VALUES (731, 2466, 3, '2026-03-09 11:00:00', 2, 1, '2026-03-13 13:00:00');
INSERT INTO `learning_record` VALUES (732, 2466, 4, NULL, 3, 1, '2026-03-14 10:00:00');
INSERT INTO `learning_record` VALUES (733, 2467, 5, '2026-03-12 08:00:00', 1, 0, '2026-03-16 11:00:00');
INSERT INTO `learning_record` VALUES (734, 2467, 6, '2026-03-13 09:00:00', 2, 1, '2026-03-17 12:00:00');
INSERT INTO `learning_record` VALUES (735, 2468, 7, '2026-03-15 10:00:00', NULL, 1, '2026-03-19 13:00:00');
INSERT INTO `learning_record` VALUES (736, 2468, 8, '2026-03-16 11:00:00', 1, 1, '2026-03-20 10:00:00');
INSERT INTO `learning_record` VALUES (737, 2469, 1, NULL, 3, 1, '2026-03-14 11:00:00');
INSERT INTO `learning_record` VALUES (738, 2469, 2, '2026-03-11 10:00:00', 4, 1, '2026-03-15 12:00:00');
INSERT INTO `learning_record` VALUES (739, 2470, 3, '2026-03-13 11:00:00', 2, 1, '2026-03-17 13:00:00');
INSERT INTO `learning_record` VALUES (740, 2470, 4, '2026-03-14 12:00:00', 3, 1, '2026-03-18 10:00:00');
INSERT INTO `learning_record` VALUES (741, 2471, 5, '2026-03-16 08:00:00', NULL, 1, '2026-03-20 11:00:00');
INSERT INTO `learning_record` VALUES (742, 2471, 6, '2026-03-17 09:00:00', 2, 1, '2026-03-21 12:00:00');
INSERT INTO `learning_record` VALUES (743, 2472, 7, '2026-03-19 10:00:00', 4, 1, '2026-03-23 13:00:00');
INSERT INTO `learning_record` VALUES (744, 2472, 8, '2026-03-20 11:00:00', NULL, 1, '2026-03-24 10:00:00');
INSERT INTO `learning_record` VALUES (745, 2473, 1, '2026-03-14 09:00:00', 3, 1, '2026-03-18 11:00:00');
INSERT INTO `learning_record` VALUES (746, 2473, 2, '2026-03-15 10:00:00', NULL, 1, '2026-03-19 12:00:00');
INSERT INTO `learning_record` VALUES (747, 2474, 3, '2026-03-17 11:00:00', 2, 1, '2026-03-21 13:00:00');
INSERT INTO `learning_record` VALUES (748, 2474, 4, '2026-03-18 12:00:00', 3, 0, '2026-03-22 10:00:00');
INSERT INTO `learning_record` VALUES (749, 2475, 5, '2026-03-20 08:00:00', 1, 1, '2026-03-24 11:00:00');
INSERT INTO `learning_record` VALUES (750, 2475, 6, '2026-03-21 09:00:00', 2, 1, '2026-03-25 12:00:00');
INSERT INTO `learning_record` VALUES (751, 2476, 7, '2026-03-23 10:00:00', 4, 1, '2026-03-27 13:00:00');
INSERT INTO `learning_record` VALUES (752, 2476, 8, '2026-03-24 11:00:00', NULL, 0, '2026-03-28 10:00:00');
INSERT INTO `learning_record` VALUES (753, 2477, 1, '2026-03-18 09:00:00', 3, 0, '2026-03-22 11:00:00');
INSERT INTO `learning_record` VALUES (754, 2477, 2, '2026-03-19 10:00:00', 4, 1, '2026-03-23 12:00:00');
INSERT INTO `learning_record` VALUES (755, 2478, 1, '2026-03-19 09:00:00', 4, 1, '2026-03-23 11:00:00');
INSERT INTO `learning_record` VALUES (756, 2478, 2, '2026-03-20 10:00:00', 1, 1, '2026-03-24 12:00:00');
INSERT INTO `learning_record` VALUES (757, 2479, 3, '2026-03-22 11:00:00', 3, 1, '2026-03-26 13:00:00');
INSERT INTO `learning_record` VALUES (758, 2479, 4, '2026-03-23 12:00:00', 4, 1, '2026-03-27 10:00:00');
INSERT INTO `learning_record` VALUES (759, 2480, 5, '2026-03-25 08:00:00', 2, 1, '2026-03-29 11:00:00');
INSERT INTO `learning_record` VALUES (760, 2480, 6, '2026-03-26 09:00:00', 3, 1, '2026-03-30 12:00:00');
INSERT INTO `learning_record` VALUES (761, 2481, 7, '2026-03-28 10:00:00', 1, 1, '2026-04-01 13:00:00');
INSERT INTO `learning_record` VALUES (762, 2481, 8, NULL, 2, 1, '2026-04-02 10:00:00');
INSERT INTO `learning_record` VALUES (763, 2482, 1, '2026-03-23 09:00:00', 4, 1, '2026-03-27 11:00:00');
INSERT INTO `learning_record` VALUES (764, 2482, 2, '2026-03-24 10:00:00', NULL, 0, '2026-03-28 12:00:00');
INSERT INTO `learning_record` VALUES (765, 2483, 3, '2026-03-26 11:00:00', 3, 1, '2026-03-30 13:00:00');
INSERT INTO `learning_record` VALUES (766, 2483, 4, '2026-03-27 12:00:00', 4, 1, '2026-03-31 10:00:00');
INSERT INTO `learning_record` VALUES (767, 2484, 5, NULL, 2, 1, '2026-04-02 11:00:00');
INSERT INTO `learning_record` VALUES (768, 2484, 6, '2026-03-30 09:00:00', 3, 0, '2026-03-04 12:00:00');
INSERT INTO `learning_record` VALUES (769, 2485, 7, '2026-03-04 10:00:00', 1, 1, '2026-03-06 13:00:00');
INSERT INTO `learning_record` VALUES (770, 2485, 8, '2026-03-05 11:00:00', NULL, 1, '2026-03-07 10:00:00');
INSERT INTO `learning_record` VALUES (771, 2486, 1, '2026-03-27 09:00:00', 4, 1, '2026-03-31 11:00:00');
INSERT INTO `learning_record` VALUES (772, 2486, 2, '2026-03-28 10:00:00', 1, 1, '2026-04-01 12:00:00');
INSERT INTO `learning_record` VALUES (773, 2487, 3, '2026-03-30 11:00:00', 3, 0, '2026-03-04 13:00:00');
INSERT INTO `learning_record` VALUES (774, 2487, 4, '2026-03-31 12:00:00', 4, 1, '2026-03-05 10:00:00');
INSERT INTO `learning_record` VALUES (775, 2488, 5, '2026-03-05 08:00:00', NULL, 1, '2026-03-07 11:00:00');
INSERT INTO `learning_record` VALUES (776, 2488, 6, '2026-03-06 09:00:00', 3, 1, '2026-03-08 12:00:00');
INSERT INTO `learning_record` VALUES (777, 2489, 7, '2026-03-08 10:00:00', 1, 0, '2026-03-10 13:00:00');
INSERT INTO `learning_record` VALUES (778, 2489, 8, '2026-03-09 11:00:00', 2, 1, '2026-03-11 10:00:00');
INSERT INTO `learning_record` VALUES (779, 2490, 1, '2026-03-31 09:00:00', 4, 1, '2026-03-05 11:00:00');
INSERT INTO `learning_record` VALUES (780, 2490, 2, '2026-03-04 10:00:00', 1, 1, '2026-03-06 12:00:00');
INSERT INTO `learning_record` VALUES (781, 2491, 3, '2026-03-06 11:00:00', 3, 1, '2026-03-08 13:00:00');
INSERT INTO `learning_record` VALUES (782, 2491, 4, '2026-03-07 12:00:00', 4, 1, '2026-03-09 10:00:00');
INSERT INTO `learning_record` VALUES (783, 2492, 5, '2026-03-09 08:00:00', 2, 1, '2026-03-11 11:00:00');
INSERT INTO `learning_record` VALUES (784, 2492, 6, '2026-03-10 09:00:00', 3, 1, '2026-03-12 12:00:00');
INSERT INTO `learning_record` VALUES (785, 2493, 7, '2026-03-12 10:00:00', 1, 1, '2026-03-14 13:00:00');
INSERT INTO `learning_record` VALUES (786, 2493, 8, '2026-03-13 11:00:00', 2, 1, '2026-03-15 10:00:00');
INSERT INTO `learning_record` VALUES (787, 2494, 1, '2026-03-07 09:00:00', 4, 0, '2026-03-09 11:00:00');
INSERT INTO `learning_record` VALUES (788, 2494, 2, '2026-03-08 10:00:00', NULL, 0, '2026-03-10 12:00:00');
INSERT INTO `learning_record` VALUES (789, 2495, 3, '2026-03-10 11:00:00', 3, 1, '2026-03-12 13:00:00');
INSERT INTO `learning_record` VALUES (790, 2495, 4, '2026-03-11 12:00:00', 4, 1, '2026-03-13 10:00:00');
INSERT INTO `learning_record` VALUES (791, 2496, 5, '2026-03-13 08:00:00', 2, 1, '2026-03-15 11:00:00');
INSERT INTO `learning_record` VALUES (792, 2496, 6, '2026-03-14 09:00:00', NULL, 0, '2026-03-16 12:00:00');
INSERT INTO `learning_record` VALUES (793, 2497, 7, '2026-03-16 10:00:00', 1, 1, '2026-03-18 13:00:00');
INSERT INTO `learning_record` VALUES (794, 2497, 8, '2026-03-17 11:00:00', 2, 1, '2026-03-19 10:00:00');
INSERT INTO `learning_record` VALUES (795, 2498, 1, '2026-03-11 09:00:00', 4, 1, '2026-03-13 11:00:00');
INSERT INTO `learning_record` VALUES (796, 2498, 2, '2026-03-12 10:00:00', 1, 1, '2026-03-14 12:00:00');
INSERT INTO `learning_record` VALUES (797, 2499, 3, '2026-03-14 11:00:00', NULL, 0, '2026-03-16 13:00:00');
INSERT INTO `learning_record` VALUES (798, 2499, 4, '2026-03-15 12:00:00', 4, 1, '2026-03-17 10:00:00');
INSERT INTO `learning_record` VALUES (799, 2500, 5, '2026-03-17 08:00:00', 2, 1, '2026-03-19 11:00:00');
INSERT INTO `learning_record` VALUES (800, 2500, 6, '2026-03-18 09:00:00', 3, 1, '2026-03-20 12:00:00');
INSERT INTO `learning_record` VALUES (801, 2501, 7, NULL, 1, 0, '2026-03-22 13:00:00');
INSERT INTO `learning_record` VALUES (802, 2501, 8, '2026-03-21 11:00:00', 2, 1, '2026-03-23 10:00:00');
INSERT INTO `learning_record` VALUES (803, 2502, 1, '2026-03-15 09:00:00', 4, 1, '2026-03-17 11:00:00');
INSERT INTO `learning_record` VALUES (804, 2502, 2, '2026-03-16 10:00:00', 1, 1, '2026-03-18 12:00:00');
INSERT INTO `learning_record` VALUES (805, 2503, 3, '2026-03-18 11:00:00', 3, 1, '2026-03-20 13:00:00');
INSERT INTO `learning_record` VALUES (806, 2503, 4, '2026-03-19 12:00:00', 4, 1, '2026-03-21 10:00:00');
INSERT INTO `learning_record` VALUES (807, 2504, 5, '2026-03-21 08:00:00', 2, 1, '2026-03-23 11:00:00');
INSERT INTO `learning_record` VALUES (808, 2504, 6, '2026-03-22 09:00:00', 3, 1, '2026-03-24 12:00:00');
INSERT INTO `learning_record` VALUES (809, 2505, 7, '2026-03-24 10:00:00', 1, 1, '2026-03-26 13:00:00');
INSERT INTO `learning_record` VALUES (810, 2505, 8, '2026-03-25 11:00:00', 2, 1, '2026-03-27 10:00:00');
INSERT INTO `learning_record` VALUES (811, 2506, 1, '2026-03-19 09:00:00', 4, 1, '2026-03-21 11:00:00');
INSERT INTO `learning_record` VALUES (812, 2506, 2, NULL, NULL, 0, '2026-03-22 12:00:00');
INSERT INTO `learning_record` VALUES (813, 2507, 3, '2026-03-22 11:00:00', 3, 0, '2026-03-24 13:00:00');
INSERT INTO `learning_record` VALUES (814, 2507, 4, '2026-03-23 12:00:00', NULL, 1, '2026-03-25 10:00:00');
INSERT INTO `learning_record` VALUES (815, 2508, 5, '2026-03-25 08:00:00', 2, 1, '2026-03-27 11:00:00');
INSERT INTO `learning_record` VALUES (816, 2508, 6, '2026-03-26 09:00:00', 3, 0, '2026-03-28 12:00:00');
INSERT INTO `learning_record` VALUES (817, 2509, 7, '2026-03-28 10:00:00', 1, 1, '2026-03-30 13:00:00');
INSERT INTO `learning_record` VALUES (818, 2509, 8, '2026-03-29 11:00:00', 2, 1, '2026-03-31 10:00:00');
INSERT INTO `learning_record` VALUES (819, 2510, 1, '2026-03-23 09:00:00', NULL, 1, '2026-03-25 11:00:00');
INSERT INTO `learning_record` VALUES (820, 2510, 2, '2026-03-24 10:00:00', 1, 1, '2026-03-26 12:00:00');
INSERT INTO `learning_record` VALUES (821, 2511, 3, '2026-03-26 11:00:00', 3, 0, '2026-03-28 13:00:00');
INSERT INTO `learning_record` VALUES (822, 2511, 4, '2026-03-27 12:00:00', 4, 1, '2026-03-29 10:00:00');
INSERT INTO `learning_record` VALUES (823, 2512, 5, '2026-03-29 08:00:00', 2, 1, '2026-03-31 11:00:00');
INSERT INTO `learning_record` VALUES (824, 2512, 6, '2026-03-30 09:00:00', 3, 1, '2026-04-01 12:00:00');
INSERT INTO `learning_record` VALUES (825, 2513, 7, '2026-03-04 10:00:00', NULL, 0, '2026-03-04 13:00:00');
INSERT INTO `learning_record` VALUES (826, 2513, 8, '2026-03-05 11:00:00', 2, 1, '2026-03-05 10:00:00');
INSERT INTO `learning_record` VALUES (827, 2514, 1, '2026-03-27 09:00:00', 4, 1, '2026-03-29 11:00:00');
INSERT INTO `learning_record` VALUES (828, 2514, 2, '2026-03-28 10:00:00', 1, 1, '2026-03-30 12:00:00');
INSERT INTO `learning_record` VALUES (829, 2515, 3, '2026-03-30 11:00:00', 3, 1, '2026-04-01 13:00:00');
INSERT INTO `learning_record` VALUES (830, 2515, 4, '2026-03-31 12:00:00', 4, 1, '2026-04-02 10:00:00');
INSERT INTO `learning_record` VALUES (831, 2516, 5, '2026-03-05 08:00:00', 2, 1, '2026-03-05 11:00:00');
INSERT INTO `learning_record` VALUES (832, 2516, 6, '2026-03-06 09:00:00', 3, 1, '2026-03-06 12:00:00');
INSERT INTO `learning_record` VALUES (833, 2517, 7, '2026-03-08 10:00:00', 1, 1, '2026-03-08 13:00:00');
INSERT INTO `learning_record` VALUES (834, 2517, 8, '2026-03-09 11:00:00', 2, 1, '2026-03-09 10:00:00');
INSERT INTO `learning_record` VALUES (835, 2518, 1, '2026-03-31 09:00:00', 4, 1, '2026-04-02 11:00:00');
INSERT INTO `learning_record` VALUES (836, 2518, 2, '2026-03-04 10:00:00', NULL, 0, '2026-03-04 12:00:00');
INSERT INTO `learning_record` VALUES (837, 2519, 1, '2026-03-04 09:00:00', NULL, 0, '2026-03-04 11:00:00');
INSERT INTO `learning_record` VALUES (838, 2519, 2, '2026-03-05 10:00:00', 2, 1, '2026-03-05 12:00:00');
INSERT INTO `learning_record` VALUES (839, 2520, 3, '2026-03-07 11:00:00', 4, 1, '2026-03-07 13:00:00');
INSERT INTO `learning_record` VALUES (840, 2520, 4, '2026-03-08 12:00:00', NULL, 1, '2026-03-08 10:00:00');
INSERT INTO `learning_record` VALUES (841, 2521, 5, '2026-03-10 08:00:00', 3, 0, '2026-03-10 11:00:00');
INSERT INTO `learning_record` VALUES (842, 2521, 6, NULL, 4, 1, '2026-03-11 12:00:00');
INSERT INTO `learning_record` VALUES (843, 2522, 7, '2026-03-13 10:00:00', NULL, 1, '2026-03-13 13:00:00');
INSERT INTO `learning_record` VALUES (844, 2522, 8, '2026-03-14 11:00:00', 3, 1, '2026-03-14 10:00:00');
INSERT INTO `learning_record` VALUES (845, 2523, 1, '2026-03-08 09:00:00', 1, 1, '2026-03-08 11:00:00');
INSERT INTO `learning_record` VALUES (846, 2523, 2, '2026-03-09 10:00:00', 2, 1, '2026-03-09 12:00:00');
INSERT INTO `learning_record` VALUES (847, 2524, 3, NULL, 4, 1, '2026-03-11 13:00:00');
INSERT INTO `learning_record` VALUES (848, 2524, 4, '2026-03-12 12:00:00', 1, 1, '2026-03-12 10:00:00');
INSERT INTO `learning_record` VALUES (849, 2525, 5, '2026-03-14 08:00:00', 3, 1, '2026-03-14 11:00:00');
INSERT INTO `learning_record` VALUES (850, 2525, 6, '2026-03-15 09:00:00', 4, 1, '2026-03-15 12:00:00');
INSERT INTO `learning_record` VALUES (851, 2526, 7, '2026-03-17 10:00:00', 2, 1, '2026-03-17 13:00:00');
INSERT INTO `learning_record` VALUES (852, 2526, 8, '2026-03-18 11:00:00', 3, 1, '2026-03-18 10:00:00');
INSERT INTO `learning_record` VALUES (853, 2527, 1, '2026-03-12 09:00:00', 1, 1, '2026-03-12 11:00:00');
INSERT INTO `learning_record` VALUES (854, 2527, 2, '2026-03-13 10:00:00', NULL, 1, '2026-03-13 12:00:00');
INSERT INTO `learning_record` VALUES (855, 2528, 3, '2026-03-15 11:00:00', 4, 1, '2026-03-15 13:00:00');
INSERT INTO `learning_record` VALUES (856, 2528, 4, '2026-03-16 12:00:00', 1, 0, '2026-03-16 10:00:00');
INSERT INTO `learning_record` VALUES (857, 2529, 5, '2026-03-18 08:00:00', 3, 1, '2026-03-18 11:00:00');
INSERT INTO `learning_record` VALUES (858, 2529, 6, '2026-03-19 09:00:00', 4, 1, '2026-03-19 12:00:00');
INSERT INTO `learning_record` VALUES (859, 2530, 7, '2026-03-21 10:00:00', 2, 1, '2026-03-21 13:00:00');
INSERT INTO `learning_record` VALUES (860, 2530, 8, '2026-03-22 11:00:00', NULL, 0, '2026-03-22 10:00:00');
INSERT INTO `learning_record` VALUES (861, 2531, 1, '2026-03-16 09:00:00', NULL, 0, '2026-03-16 11:00:00');
INSERT INTO `learning_record` VALUES (862, 2531, 2, '2026-03-17 10:00:00', 2, 1, '2026-03-17 12:00:00');
INSERT INTO `learning_record` VALUES (863, 2532, 3, '2026-03-19 11:00:00', 4, 1, '2026-03-19 13:00:00');
INSERT INTO `learning_record` VALUES (864, 2532, 4, '2026-03-20 12:00:00', 1, 1, '2026-03-20 10:00:00');
INSERT INTO `learning_record` VALUES (865, 2533, 5, '2026-03-22 08:00:00', NULL, 0, '2026-03-22 11:00:00');
INSERT INTO `learning_record` VALUES (866, 2533, 6, '2026-03-23 09:00:00', 4, 1, '2026-03-23 12:00:00');
INSERT INTO `learning_record` VALUES (867, 2534, 7, '2026-03-25 10:00:00', 2, 1, '2026-03-25 13:00:00');
INSERT INTO `learning_record` VALUES (868, 2534, 8, '2026-03-26 11:00:00', 3, 1, '2026-03-26 10:00:00');
INSERT INTO `learning_record` VALUES (869, 2535, 1, '2026-03-20 09:00:00', 1, 1, '2026-03-20 11:00:00');
INSERT INTO `learning_record` VALUES (870, 2535, 2, '2026-03-21 10:00:00', 2, 1, '2026-03-21 12:00:00');
INSERT INTO `learning_record` VALUES (871, 2536, 3, '2026-03-23 11:00:00', 4, 1, '2026-03-23 13:00:00');
INSERT INTO `learning_record` VALUES (872, 2536, 4, '2026-03-24 12:00:00', 1, 1, '2026-03-24 10:00:00');
INSERT INTO `learning_record` VALUES (873, 2537, 5, '2026-03-26 08:00:00', 3, 1, '2026-03-26 11:00:00');
INSERT INTO `learning_record` VALUES (874, 2537, 6, '2026-03-27 09:00:00', 4, 1, '2026-03-27 12:00:00');
INSERT INTO `learning_record` VALUES (875, 2538, 7, '2026-03-29 10:00:00', 2, 1, '2026-03-29 13:00:00');
INSERT INTO `learning_record` VALUES (876, 2538, 8, NULL, 3, 1, '2026-03-30 10:00:00');
INSERT INTO `learning_record` VALUES (877, 2539, 1, '2026-03-24 09:00:00', 1, 1, '2026-03-24 11:00:00');
INSERT INTO `learning_record` VALUES (878, 2539, 2, '2026-03-25 10:00:00', 2, 1, '2026-03-25 12:00:00');
INSERT INTO `learning_record` VALUES (879, 2540, 3, '2026-03-27 11:00:00', 4, 1, '2026-03-27 13:00:00');
INSERT INTO `learning_record` VALUES (880, 2540, 4, '2026-03-28 12:00:00', 1, 0, '2026-03-28 10:00:00');
INSERT INTO `learning_record` VALUES (881, 2541, 5, NULL, 3, 1, '2026-03-30 11:00:00');
INSERT INTO `learning_record` VALUES (882, 2541, 6, '2026-03-31 09:00:00', NULL, 1, '2026-03-31 12:00:00');
INSERT INTO `learning_record` VALUES (883, 2542, 7, '2026-03-05 10:00:00', 2, 1, '2026-04-02 13:00:00');
INSERT INTO `learning_record` VALUES (884, 2542, 8, '2026-03-06 11:00:00', 3, 0, '2026-03-04 10:00:00');
INSERT INTO `learning_record` VALUES (885, 2543, 1, '2026-03-28 09:00:00', 1, 0, '2026-03-28 11:00:00');
INSERT INTO `learning_record` VALUES (886, 2543, 2, '2026-03-29 10:00:00', 2, 1, '2026-03-29 12:00:00');
INSERT INTO `learning_record` VALUES (887, 2544, 3, '2026-03-31 11:00:00', NULL, 1, '2026-03-31 13:00:00');
INSERT INTO `learning_record` VALUES (888, 2544, 4, '2026-03-04 12:00:00', NULL, 1, '2026-04-01 10:00:00');
INSERT INTO `learning_record` VALUES (889, 2545, 5, '2026-03-06 08:00:00', 3, 0, '2026-03-04 11:00:00');
INSERT INTO `learning_record` VALUES (890, 2545, 6, '2026-03-07 09:00:00', 4, 1, '2026-03-05 12:00:00');
INSERT INTO `learning_record` VALUES (891, 2546, 7, '2026-03-09 10:00:00', 2, 1, '2026-03-07 13:00:00');
INSERT INTO `learning_record` VALUES (892, 2546, 8, '2026-03-10 11:00:00', 3, 1, '2026-03-08 10:00:00');
INSERT INTO `learning_record` VALUES (893, 2547, 1, '2026-03-04 09:00:00', 1, 1, '2026-04-01 11:00:00');
INSERT INTO `learning_record` VALUES (894, 2547, 2, '2026-03-05 10:00:00', 2, 1, '2026-04-02 12:00:00');
INSERT INTO `learning_record` VALUES (895, 2548, 3, '2026-03-07 11:00:00', 4, 1, '2026-03-05 13:00:00');
INSERT INTO `learning_record` VALUES (896, 2548, 4, '2026-03-08 12:00:00', 1, 1, '2026-03-06 10:00:00');
INSERT INTO `learning_record` VALUES (897, 2549, 5, '2026-03-10 08:00:00', 3, 1, '2026-03-08 11:00:00');
INSERT INTO `learning_record` VALUES (898, 2549, 6, '2026-03-11 09:00:00', 4, 1, '2026-03-09 12:00:00');
INSERT INTO `learning_record` VALUES (899, 2550, 7, '2026-03-13 10:00:00', 2, 1, '2026-03-11 13:00:00');
INSERT INTO `learning_record` VALUES (900, 2550, 8, '2026-03-14 11:00:00', 3, 1, '2026-03-12 10:00:00');
INSERT INTO `learning_record` VALUES (901, 2551, 1, '2026-03-08 09:00:00', 1, 1, '2026-03-06 11:00:00');
INSERT INTO `learning_record` VALUES (902, 2551, 2, '2026-03-09 10:00:00', 2, 1, '2026-03-07 12:00:00');
INSERT INTO `learning_record` VALUES (903, 2552, 3, '2026-03-11 11:00:00', 4, 1, '2026-03-09 13:00:00');
INSERT INTO `learning_record` VALUES (904, 2552, 4, '2026-03-12 12:00:00', NULL, 0, '2026-03-10 10:00:00');
INSERT INTO `learning_record` VALUES (905, 2553, 5, '2026-03-14 08:00:00', 3, 1, '2026-03-12 11:00:00');
INSERT INTO `learning_record` VALUES (906, 2553, 6, '2026-03-15 09:00:00', 4, 1, '2026-03-13 12:00:00');
INSERT INTO `learning_record` VALUES (907, 2554, 7, '2026-03-17 10:00:00', 2, 1, '2026-03-15 13:00:00');
INSERT INTO `learning_record` VALUES (908, 2554, 8, '2026-03-18 11:00:00', 3, 0, '2026-03-16 10:00:00');
INSERT INTO `learning_record` VALUES (909, 2555, 1, '2026-03-12 09:00:00', NULL, 0, '2026-03-10 11:00:00');
INSERT INTO `learning_record` VALUES (910, 2555, 2, '2026-03-13 10:00:00', 2, 1, '2026-03-11 12:00:00');
INSERT INTO `learning_record` VALUES (911, 2556, 3, '2026-03-15 11:00:00', 4, 1, '2026-03-13 13:00:00');
INSERT INTO `learning_record` VALUES (912, 2556, 4, '2026-03-16 12:00:00', NULL, 1, '2026-03-14 10:00:00');
INSERT INTO `learning_record` VALUES (913, 2557, 5, '2026-03-18 08:00:00', 3, 0, '2026-03-16 11:00:00');
INSERT INTO `learning_record` VALUES (914, 2557, 6, '2026-03-19 09:00:00', 4, 1, '2026-03-17 12:00:00');
INSERT INTO `learning_record` VALUES (915, 2558, 7, NULL, NULL, 1, '2026-03-19 13:00:00');
INSERT INTO `learning_record` VALUES (916, 2558, 8, '2026-03-22 11:00:00', 3, 1, '2026-03-20 10:00:00');
INSERT INTO `learning_record` VALUES (917, 2559, 1, '2026-03-16 09:00:00', 1, 1, '2026-03-14 11:00:00');
INSERT INTO `learning_record` VALUES (918, 2559, 2, '2026-03-17 10:00:00', 2, 1, '2026-03-15 12:00:00');
INSERT INTO `learning_record` VALUES (919, 2560, 1, '2026-03-17 09:00:00', 2, 1, '2026-03-15 11:00:00');
INSERT INTO `learning_record` VALUES (920, 2560, 2, '2026-03-18 10:00:00', 3, 0, '2026-03-16 12:00:00');
INSERT INTO `learning_record` VALUES (921, 2561, 3, '2026-03-20 11:00:00', 1, 1, '2026-03-18 13:00:00');
INSERT INTO `learning_record` VALUES (922, 2561, 4, NULL, NULL, 1, '2026-03-19 10:00:00');
INSERT INTO `learning_record` VALUES (923, 2562, 5, '2026-03-23 08:00:00', 4, 1, '2026-03-21 11:00:00');
INSERT INTO `learning_record` VALUES (924, 2562, 6, '2026-03-24 09:00:00', 1, 0, '2026-03-22 12:00:00');
INSERT INTO `learning_record` VALUES (925, 2563, 7, '2026-03-26 10:00:00', 3, 1, '2026-03-24 13:00:00');
INSERT INTO `learning_record` VALUES (926, 2563, 8, '2026-03-27 11:00:00', 4, 1, '2026-03-25 10:00:00');
INSERT INTO `learning_record` VALUES (927, 2564, 1, NULL, NULL, 1, '2026-03-19 11:00:00');
INSERT INTO `learning_record` VALUES (928, 2564, 2, '2026-03-22 10:00:00', 3, 1, '2026-03-20 12:00:00');
INSERT INTO `learning_record` VALUES (929, 2565, 3, '2026-03-24 11:00:00', 1, 0, '2026-03-22 13:00:00');
INSERT INTO `learning_record` VALUES (930, 2565, 4, '2026-03-25 12:00:00', 2, 1, '2026-03-23 10:00:00');
INSERT INTO `learning_record` VALUES (931, 2566, 5, '2026-03-27 08:00:00', 4, 1, '2026-03-25 11:00:00');
INSERT INTO `learning_record` VALUES (932, 2566, 6, '2026-03-28 09:00:00', NULL, 1, '2026-03-26 12:00:00');
INSERT INTO `learning_record` VALUES (933, 2567, 7, '2026-03-30 10:00:00', NULL, 0, '2026-03-28 13:00:00');
INSERT INTO `learning_record` VALUES (934, 2567, 8, '2026-03-31 11:00:00', 4, 1, '2026-03-29 10:00:00');
INSERT INTO `learning_record` VALUES (935, 2568, 1, '2026-03-25 09:00:00', 2, 1, '2026-03-23 11:00:00');
INSERT INTO `learning_record` VALUES (936, 2568, 2, '2026-03-26 10:00:00', 3, 1, '2026-03-24 12:00:00');
INSERT INTO `learning_record` VALUES (937, 2569, 3, '2026-03-28 11:00:00', 1, 1, '2026-03-26 13:00:00');
INSERT INTO `learning_record` VALUES (938, 2569, 4, '2026-03-29 12:00:00', 2, 1, '2026-03-27 10:00:00');
INSERT INTO `learning_record` VALUES (939, 2570, 5, '2026-03-31 08:00:00', 4, 1, '2026-03-29 11:00:00');
INSERT INTO `learning_record` VALUES (940, 2570, 6, '2026-03-04 09:00:00', 1, 1, '2026-03-30 12:00:00');
INSERT INTO `learning_record` VALUES (941, 2571, 7, '2026-03-06 10:00:00', 3, 1, '2026-04-01 13:00:00');
INSERT INTO `learning_record` VALUES (942, 2571, 8, '2026-03-07 11:00:00', 4, 1, '2026-04-02 10:00:00');
INSERT INTO `learning_record` VALUES (943, 2572, 1, '2026-03-29 09:00:00', 2, 1, '2026-03-27 11:00:00');
INSERT INTO `learning_record` VALUES (944, 2572, 2, '2026-03-30 10:00:00', NULL, 0, '2026-03-28 12:00:00');
INSERT INTO `learning_record` VALUES (945, 2573, 3, '2026-03-04 11:00:00', 1, 1, '2026-03-30 13:00:00');
INSERT INTO `learning_record` VALUES (946, 2573, 4, '2026-03-05 12:00:00', 2, 1, '2026-03-31 10:00:00');
INSERT INTO `learning_record` VALUES (947, 2574, 5, '2026-03-07 08:00:00', 4, 1, '2026-04-02 11:00:00');
INSERT INTO `learning_record` VALUES (948, 2574, 6, '2026-03-08 09:00:00', 1, 0, '2026-03-04 12:00:00');
INSERT INTO `learning_record` VALUES (949, 2575, 7, '2026-03-10 10:00:00', 3, 1, '2026-03-06 13:00:00');
INSERT INTO `learning_record` VALUES (950, 2575, 8, '2026-03-11 11:00:00', NULL, 1, '2026-03-07 10:00:00');
INSERT INTO `learning_record` VALUES (951, 2576, 1, '2026-03-05 09:00:00', 2, 1, '2026-03-31 11:00:00');
INSERT INTO `learning_record` VALUES (952, 2576, 2, '2026-03-06 10:00:00', 3, 1, '2026-04-01 12:00:00');
INSERT INTO `learning_record` VALUES (953, 2577, 3, '2026-03-08 11:00:00', 1, 0, '2026-03-04 13:00:00');
INSERT INTO `learning_record` VALUES (954, 2577, 4, '2026-03-09 12:00:00', 2, 1, '2026-03-05 10:00:00');
INSERT INTO `learning_record` VALUES (955, 2578, 5, '2026-03-11 08:00:00', NULL, 1, '2026-03-07 11:00:00');
INSERT INTO `learning_record` VALUES (956, 2578, 6, NULL, NULL, 1, '2026-03-08 12:00:00');
INSERT INTO `learning_record` VALUES (957, 2579, 7, '2026-03-14 10:00:00', 3, 0, '2026-03-10 13:00:00');
INSERT INTO `learning_record` VALUES (958, 2579, 8, '2026-03-15 11:00:00', 4, 1, '2026-03-11 10:00:00');
INSERT INTO `learning_record` VALUES (959, 2580, 1, '2026-03-09 09:00:00', 2, 1, '2026-03-05 11:00:00');
INSERT INTO `learning_record` VALUES (960, 2580, 2, '2026-03-10 10:00:00', 3, 1, '2026-03-06 12:00:00');
INSERT INTO `learning_record` VALUES (961, 2581, 3, NULL, 1, 1, '2026-03-08 13:00:00');
INSERT INTO `learning_record` VALUES (962, 2581, 4, '2026-03-13 12:00:00', 2, 1, '2026-03-09 10:00:00');
INSERT INTO `learning_record` VALUES (963, 2582, 5, '2026-03-15 08:00:00', 4, 1, '2026-03-11 11:00:00');
INSERT INTO `learning_record` VALUES (964, 2582, 6, '2026-03-16 09:00:00', 1, 1, '2026-03-12 12:00:00');
INSERT INTO `learning_record` VALUES (965, 2583, 7, '2026-03-18 10:00:00', 3, 1, '2026-03-14 13:00:00');
INSERT INTO `learning_record` VALUES (966, 2583, 8, '2026-03-19 11:00:00', 4, 1, '2026-03-15 10:00:00');
INSERT INTO `learning_record` VALUES (967, 2584, 1, '2026-03-13 09:00:00', 2, 1, '2026-03-09 11:00:00');
INSERT INTO `learning_record` VALUES (968, 2584, 2, '2026-03-14 10:00:00', 3, 0, '2026-03-10 12:00:00');
INSERT INTO `learning_record` VALUES (969, 2585, 3, '2026-03-16 11:00:00', 1, 1, '2026-03-12 13:00:00');
INSERT INTO `learning_record` VALUES (970, 2585, 4, '2026-03-17 12:00:00', 2, 1, '2026-03-13 10:00:00');
INSERT INTO `learning_record` VALUES (971, 2586, 5, '2026-03-19 08:00:00', 4, 1, '2026-03-15 11:00:00');
INSERT INTO `learning_record` VALUES (972, 2586, 6, '2026-03-20 09:00:00', NULL, 0, '2026-03-16 12:00:00');
INSERT INTO `learning_record` VALUES (973, 2587, 7, '2026-03-22 10:00:00', 3, 1, '2026-03-18 13:00:00');
INSERT INTO `learning_record` VALUES (974, 2587, 8, '2026-03-23 11:00:00', 4, 1, '2026-03-19 10:00:00');
INSERT INTO `learning_record` VALUES (975, 2588, 1, '2026-03-17 09:00:00', 2, 1, '2026-03-13 11:00:00');
INSERT INTO `learning_record` VALUES (976, 2588, 2, '2026-03-18 10:00:00', 3, 1, '2026-03-14 12:00:00');
INSERT INTO `learning_record` VALUES (977, 2589, 3, '2026-03-20 11:00:00', NULL, 0, '2026-03-16 13:00:00');
INSERT INTO `learning_record` VALUES (978, 2589, 4, '2026-03-21 12:00:00', 2, 1, '2026-03-17 10:00:00');
INSERT INTO `learning_record` VALUES (979, 2590, 5, '2026-03-23 08:00:00', 4, 1, '2026-03-19 11:00:00');
INSERT INTO `learning_record` VALUES (980, 2590, 6, '2026-03-24 09:00:00', 1, 1, '2026-03-20 12:00:00');
INSERT INTO `learning_record` VALUES (981, 2591, 7, '2026-03-26 10:00:00', 3, 0, '2026-03-22 13:00:00');
INSERT INTO `learning_record` VALUES (982, 2591, 8, '2026-03-27 11:00:00', 4, 1, '2026-03-23 10:00:00');
INSERT INTO `learning_record` VALUES (983, 2592, 1, '2026-03-21 09:00:00', 2, 1, '2026-03-17 11:00:00');
INSERT INTO `learning_record` VALUES (984, 2592, 2, '2026-03-22 10:00:00', 3, 1, '2026-03-18 12:00:00');
INSERT INTO `learning_record` VALUES (985, 2593, 3, '2026-03-24 11:00:00', 1, 1, '2026-03-20 13:00:00');
INSERT INTO `learning_record` VALUES (986, 2593, 4, '2026-03-25 12:00:00', 2, 1, '2026-03-21 10:00:00');
INSERT INTO `learning_record` VALUES (987, 2594, 5, '2026-03-27 08:00:00', 4, 1, '2026-03-23 11:00:00');
INSERT INTO `learning_record` VALUES (988, 2594, 6, '2026-03-28 09:00:00', 1, 1, '2026-03-24 12:00:00');
INSERT INTO `learning_record` VALUES (989, 2595, 7, '2026-03-30 10:00:00', 3, 1, '2026-03-26 13:00:00');
INSERT INTO `learning_record` VALUES (990, 2595, 8, NULL, 4, 1, '2026-03-27 10:00:00');
INSERT INTO `learning_record` VALUES (991, 2596, 1, '2026-03-25 09:00:00', 2, 1, '2026-03-21 11:00:00');
INSERT INTO `learning_record` VALUES (992, 2596, 2, '2026-03-26 10:00:00', 3, 0, '2026-03-22 12:00:00');
INSERT INTO `learning_record` VALUES (993, 2597, 3, '2026-03-28 11:00:00', 1, 1, '2026-03-24 13:00:00');
INSERT INTO `learning_record` VALUES (994, 2597, 4, '2026-03-29 12:00:00', NULL, 1, '2026-03-25 10:00:00');
INSERT INTO `learning_record` VALUES (995, 2598, 5, NULL, 4, 1, '2026-03-27 11:00:00');
INSERT INTO `learning_record` VALUES (996, 2598, 6, '2026-03-04 09:00:00', 1, 0, '2026-03-28 12:00:00');
INSERT INTO `learning_record` VALUES (997, 2599, 7, '2026-03-06 10:00:00', 3, 1, '2026-03-30 13:00:00');
INSERT INTO `learning_record` VALUES (998, 2599, 8, '2026-03-07 11:00:00', 4, 1, '2026-03-31 10:00:00');
INSERT INTO `learning_record` VALUES (999, 2600, 1, '2026-03-29 09:00:00', NULL, 1, '2026-03-25 11:00:00');
INSERT INTO `learning_record` VALUES (1000, 2600, 2, '2026-03-30 10:00:00', 3, 1, '2026-03-26 12:00:00');

-- ----------------------------
-- Table structure for live_session
-- ----------------------------
DROP TABLE IF EXISTS `live_session`;
CREATE TABLE `live_session`  (
  `session_id` bigint NOT NULL AUTO_INCREMENT COMMENT '????ID',
  `course_id` bigint NOT NULL COMMENT '??ID',
  `teacher_id` bigint NOT NULL COMMENT '??ID?teacher.teacher_id?',
  `start_time` datetime NOT NULL COMMENT '????',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'scheduled' COMMENT '???scheduled/live/ended/cancelled',
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  PRIMARY KEY (`session_id`) USING BTREE,
  INDEX `idx_live_session_course_id`(`course_id` ASC) USING BTREE,
  INDEX `idx_live_session_teacher_id`(`teacher_id` ASC) USING BTREE,
  INDEX `idx_live_session_start_time`(`start_time` ASC) USING BTREE,
  INDEX `idx_live_session_status`(`status` ASC) USING BTREE,
  INDEX `fk_live_session_course_teacher`(`course_id` ASC, `teacher_id` ASC) USING BTREE,
  CONSTRAINT `fk_live_session_course_teacher` FOREIGN KEY (`course_id`, `teacher_id`) REFERENCES `course` (`course_id`, `teacher_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_live_session_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_live_session_status` CHECK (`status` in (_utf8mb4'scheduled',_utf8mb4'live',_utf8mb4'ended',_utf8mb4'cancelled'))
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '?????' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of live_session
-- ----------------------------
INSERT INTO `live_session` VALUES (1, 1, 1101, '2025-10-12 19:00:00', 'ended', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `live_session` VALUES (2, 2, 1102, '2026-03-16 20:00:00', 'scheduled', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `live_session` VALUES (3, 3, 1103, '2025-10-20 19:00:00', 'ended', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `live_session` VALUES (4, 4, 1104, '2026-03-22 19:00:00', 'scheduled', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `live_session` VALUES (5, 5, 1105, '2025-10-28 19:00:00', 'ended', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `live_session` VALUES (6, 6, 1106, '2026-03-28 18:00:00', 'scheduled', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `live_session` VALUES (7, 7, 1121, '2025-11-05 19:00:00', 'ended', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `live_session` VALUES (8, 8, 1130, '2026-04-03 20:00:00', 'live', '2026-03-18 11:04:01', '2026-03-18 11:04:01');

-- ----------------------------
-- Table structure for role_menu
-- ----------------------------
DROP TABLE IF EXISTS `role_menu`;
CREATE TABLE `role_menu`  (
  `role_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '?????student/teacher',
  `menu_id` bigint NOT NULL COMMENT '??ID',
  PRIMARY KEY (`role_code`, `menu_id`) USING BTREE,
  INDEX `idx_role_menu_menu_id`(`menu_id` ASC) USING BTREE,
  CONSTRAINT `fk_role_menu_menu` FOREIGN KEY (`menu_id`) REFERENCES `sys_menu` (`menu_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `ck_role_menu_role` CHECK (`role_code` in (_utf8mb4'student',_utf8mb4'teacher'))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '???????' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of role_menu
-- ----------------------------
INSERT INTO `role_menu` VALUES ('student', 2);
INSERT INTO `role_menu` VALUES ('teacher', 2);
INSERT INTO `role_menu` VALUES ('student', 3);
INSERT INTO `role_menu` VALUES ('teacher', 3);
INSERT INTO `role_menu` VALUES ('student', 4);
INSERT INTO `role_menu` VALUES ('teacher', 4);
INSERT INTO `role_menu` VALUES ('teacher', 5);
INSERT INTO `role_menu` VALUES ('teacher', 6);
INSERT INTO `role_menu` VALUES ('teacher', 7);

-- ----------------------------
-- Table structure for role_permission
-- ----------------------------
DROP TABLE IF EXISTS `role_permission`;
CREATE TABLE `role_permission`  (
  `role_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '?????student/teacher',
  `perm_id` bigint NOT NULL COMMENT '??ID',
  PRIMARY KEY (`role_code`, `perm_id`) USING BTREE,
  INDEX `idx_role_permission_perm_id`(`perm_id` ASC) USING BTREE,
  CONSTRAINT `fk_role_permission_perm` FOREIGN KEY (`perm_id`) REFERENCES `sys_permission` (`perm_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `ck_role_permission_role` CHECK (`role_code` in (_utf8mb4'student',_utf8mb4'teacher'))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '???????' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of role_permission
-- ----------------------------
INSERT INTO `role_permission` VALUES ('student', 201);
INSERT INTO `role_permission` VALUES ('teacher', 201);
INSERT INTO `role_permission` VALUES ('student', 202);
INSERT INTO `role_permission` VALUES ('teacher', 202);
INSERT INTO `role_permission` VALUES ('student', 203);
INSERT INTO `role_permission` VALUES ('teacher', 203);
INSERT INTO `role_permission` VALUES ('teacher', 301);
INSERT INTO `role_permission` VALUES ('teacher', 302);
INSERT INTO `role_permission` VALUES ('teacher', 303);
INSERT INTO `role_permission` VALUES ('teacher', 304);
INSERT INTO `role_permission` VALUES ('teacher', 305);

-- ----------------------------
-- Table structure for schema_migration_log
-- ----------------------------
DROP TABLE IF EXISTS `schema_migration_log`;
CREATE TABLE `schema_migration_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `migration_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `migration_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `executed_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_schema_migration_code`(`migration_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Schema migration log' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of schema_migration_log
-- ----------------------------
INSERT INTO `schema_migration_log` VALUES (1, 'ACADEMIC_20260317_V1', 'Academic analytics schema incremental upgrade', '2026-03-18 10:50:30');

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
  `student_id` bigint NOT NULL COMMENT '??ID??user.id??',
  `student_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '??',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '??',
  `college` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '??',
  `college_id` bigint NULL DEFAULT NULL,
  `major_id` bigint NULL DEFAULT NULL,
  `class_id` bigint NULL DEFAULT NULL,
  `grade_year` smallint NULL DEFAULT NULL,
  `learning_index` decimal(5, 2) NULL DEFAULT NULL COMMENT '??????',
  `comparison_last_month` decimal(5, 2) NULL DEFAULT NULL COMMENT '????',
  `total_warnings` int NOT NULL DEFAULT 0 COMMENT '??????',
  `resolved_warnings` int NOT NULL DEFAULT 0 COMMENT '??????',
  `learning_scores` decimal(5, 2) NULL DEFAULT NULL COMMENT '????',
  `average_course_scores` decimal(5, 2) NULL DEFAULT NULL COMMENT '?????',
  PRIMARY KEY (`student_id`) USING BTREE,
  UNIQUE INDEX `uq_student_student_no`(`student_no` ASC) USING BTREE,
  INDEX `idx_student_name`(`name` ASC) USING BTREE,
  INDEX `idx_student_college`(`college` ASC) USING BTREE,
  CONSTRAINT `fk_student_user` FOREIGN KEY (`student_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '????/????' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES (2101, '2025010001', '杨书萌', '马克思主义学院', 1, 1, 1, 2025, 4.79, 0.18, 0, 0, 65.90, 69.40);
INSERT INTO `student` VALUES (2102, '2024010002', '徐向宇', '马克思主义学院', 1, 1, 13, 2024, 5.19, 0.30, 0, 0, 69.80, 68.70);
INSERT INTO `student` VALUES (2103, '2023010003', '林安言', '马克思主义学院', 1, 1, 25, 2023, 5.49, 0.42, 0, 0, 73.40, 67.70);
INSERT INTO `student` VALUES (2104, '2022010004', '梁闻怡', '马克思主义学院', 1, 1, 37, 2022, 5.76, -0.52, 0, 0, 67.00, 66.50);
INSERT INTO `student` VALUES (2105, '2025010005', '王知文', '马克思主义学院', 1, 1, 1, 2025, 4.79, -0.20, 0, 0, 66.80, 70.35);
INSERT INTO `student` VALUES (2106, '2024010006', '赵星卓', '马克思主义学院', 1, 1, 13, 2024, 5.24, -0.30, 0, 0, 70.70, 69.65);
INSERT INTO `student` VALUES (2107, '2023010007', '孙若川', '马克思主义学院', 1, 1, 25, 2023, 5.58, -0.18, 0, 0, 74.30, 68.65);
INSERT INTO `student` VALUES (2108, '2022010008', '何可希', '马克思主义学院', 1, 1, 37, 2022, 5.84, -0.06, 0, 0, 67.90, 67.45);
INSERT INTO `student` VALUES (2109, '2025010009', '宋思昕', '马克思主义学院', 1, 1, 1, 2025, 4.51, 0.06, 0, 0, 67.70, 60.80);
INSERT INTO `student` VALUES (2110, '2024010010', '张景霖', '马克思主义学院', 1, 1, 13, 2024, 2.52, -1.44, 2, 1, 64.60, 64.40);
INSERT INTO `student` VALUES (2111, '2023010011', '黄明远', '马克思主义学院', 1, 1, 25, 2023, 3.20, -1.60, 2, 1, 58.50, 63.40);
INSERT INTO `student` VALUES (2112, '2022010012', '胡语轩', '马克思主义学院', 1, 1, 37, 2022, 5.06, 0.42, 0, 0, 61.80, 68.40);
INSERT INTO `student` VALUES (2113, '2025010013', '郭一睿', '马克思主义学院', 1, 1, 1, 2025, 4.24, 0.54, 0, 0, 68.60, 63.70);
INSERT INTO `student` VALUES (2114, '2024010014', '郑沐彤', '马克思主义学院', 1, 1, 13, 2024, 8.32, 0.66, 0, 0, 72.50, 71.55);
INSERT INTO `student` VALUES (2115, '2023010015', '刘泽诚', '马克思主义学院', 1, 1, 25, 2023, 4.75, -0.30, 0, 0, 66.20, 70.55);
INSERT INTO `student` VALUES (2116, '2022010016', '周清航', '马克思主义学院', 1, 1, 37, 2022, 5.02, -0.52, 0, 0, 69.70, 69.35);
INSERT INTO `student` VALUES (2117, '2025010017', '朱逸涵', '马克思主义学院', 1, 1, 1, 2025, 4.40, -0.20, 0, 0, 69.50, 64.65);
INSERT INTO `student` VALUES (2118, '2024010018', '马子扬', '马克思主义学院', 1, 1, 13, 2024, 4.60, 0.06, 0, 0, 73.40, 63.95);
INSERT INTO `student` VALUES (2119, '2023010019', '谢依晨', '马克思主义学院', 1, 1, 25, 2023, 8.67, 0.18, 0, 0, 67.10, 71.50);
INSERT INTO `student` VALUES (2120, '2022010020', '陈嘉宁', '马克思主义学院', 1, 1, 37, 2022, 2.39, -1.28, 3, 1, 67.20, 61.00);
INSERT INTO `student` VALUES (2121, '2025010021', '吴书萌', '马克思主义学院', 1, 1, 1, 2025, 1.97, -0.80, 3, 1, 67.92, 60.80);
INSERT INTO `student` VALUES (2122, '2024010022', '高向宇', '马克思主义学院', 1, 1, 13, 2024, 2.62, -0.80, 2, 1, 58.50, 60.80);
INSERT INTO `student` VALUES (2123, '2023010023', '罗安言', '马克思主义学院', 1, 1, 25, 2023, 7.94, -0.20, 0, 0, 61.00, 72.45);
INSERT INTO `student` VALUES (2124, '2022010024', '李闻怡', '马克思主义学院', 1, 1, 37, 2022, 8.34, -0.30, 0, 0, 64.50, 71.25);
INSERT INTO `student` VALUES (2125, '2025010025', '杨知文', '马克思主义学院', 1, 1, 1, 2025, 4.05, -0.18, 0, 0, 71.30, 66.55);
INSERT INTO `student` VALUES (2126, '2024010026', '徐星卓', '马克思主义学院', 1, 1, 13, 2024, 4.15, -0.06, 0, 0, 65.30, 65.85);
INSERT INTO `student` VALUES (2127, '2023010027', '林若川', '马克思主义学院', 1, 1, 25, 2023, 4.37, 0.06, 0, 0, 68.90, 64.85);
INSERT INTO `student` VALUES (2128, '2022010028', '梁可希', '马克思主义学院', 1, 1, 37, 2022, 7.69, -0.52, 0, 0, 72.40, 72.20);
INSERT INTO `student` VALUES (2129, '2025010029', '王思昕', '马克思主义学院', 1, 1, 1, 2025, 6.54, -0.20, 0, 0, 72.20, 67.50);
INSERT INTO `student` VALUES (2130, '2024010030', '赵景霖', '马克思主义学院', 1, 1, 13, 2024, 4.30, 0.42, 0, 0, 66.20, 66.80);
INSERT INTO `student` VALUES (2131, '2023010031', '孙明远', '马克思主义学院', 1, 1, 25, 2023, 2.01, -0.64, 3, 1, 61.44, 60.80);
INSERT INTO `student` VALUES (2132, '2022010032', '何语轩', '马克思主义学院', 1, 1, 37, 2022, 5.15, 0.66, 0, 0, 73.30, 66.95);
INSERT INTO `student` VALUES (2133, '2025010033', '宋一睿', '马克思主义学院', 1, 1, 1, 2025, 4.59, -0.30, 0, 0, 63.20, 62.25);
INSERT INTO `student` VALUES (2134, '2024010034', '张沐彤', '马克思主义学院', 1, 1, 13, 2024, 6.33, -0.52, 0, 0, 60.10, 67.75);
INSERT INTO `student` VALUES (2135, '2023010035', '黄泽诚', '马克思主义学院', 1, 1, 25, 2023, 4.05, -0.20, 0, 0, 63.70, 66.75);
INSERT INTO `student` VALUES (2136, '2022010036', '胡清航', '马克思主义学院', 1, 1, 37, 2022, 4.09, 0.06, 0, 0, 67.20, 65.55);
INSERT INTO `student` VALUES (2137, '2025010037', '郭逸涵', '马克思主义学院', 1, 1, 1, 2025, 5.54, 0.18, 0, 0, 64.10, 69.40);
INSERT INTO `student` VALUES (2138, '2024010038', '郑子扬', '马克思主义学院', 1, 1, 13, 2024, 6.29, 0.30, 0, 0, 68.00, 68.70);
INSERT INTO `student` VALUES (2139, '2023010039', '刘依晨', '马克思主义学院', 1, 1, 25, 2023, 6.64, 0.42, 0, 0, 71.60, 67.70);
INSERT INTO `student` VALUES (2140, '2022010040', '周嘉宁', '马克思主义学院', 1, 1, 37, 2022, 4.19, -0.80, 1, 0, 62.88, 66.44);
INSERT INTO `student` VALUES (2141, '2025010041', '朱书萌', '马克思主义学院', 1, 1, 1, 2025, 5.58, -0.20, 0, 0, 65.00, 70.35);
INSERT INTO `student` VALUES (2142, '2024010042', '马向宇', '马克思主义学院', 1, 1, 13, 2024, 4.35, -0.30, 0, 0, 68.90, 63.45);
INSERT INTO `student` VALUES (2143, '2025020043', '谢安言', '计算机科学与技术学院', 2, 2, 2, 2025, 4.34, -1.44, 1, 0, 68.64, 60.90);
INSERT INTO `student` VALUES (2144, '2024020044', '陈闻怡', '计算机科学与技术学院', 2, 2, 14, 2024, 4.70, -0.06, 0, 0, 64.90, 60.80);
INSERT INTO `student` VALUES (2145, '2023020045', '吴知文', '计算机科学与技术学院', 2, 2, 26, 2023, 3.33, -0.96, 2, 1, 68.50, 65.40);
INSERT INTO `student` VALUES (2146, '2022020046', '高星卓', '计算机科学与技术学院', 2, 2, 38, 2022, 6.38, -0.52, 0, 0, 65.00, 72.75);
INSERT INTO `student` VALUES (2147, '2025020047', '罗若川', '计算机科学与技术学院', 2, 2, 2, 2025, 5.10, -0.20, 0, 0, 64.80, 68.05);
INSERT INTO `student` VALUES (2148, '2024020048', '李可希', '计算机科学与技术学院', 2, 2, 14, 2024, 5.47, 0.42, 0, 0, 58.80, 67.35);
INSERT INTO `student` VALUES (2149, '2023020049', '杨思昕', '计算机科学与技术学院', 2, 2, 26, 2023, 5.76, 0.54, 0, 0, 69.40, 66.35);
INSERT INTO `student` VALUES (2150, '2022020050', '徐景霖', '计算机科学与技术学院', 2, 2, 38, 2022, 6.45, 0.66, 0, 0, 72.90, 73.70);
INSERT INTO `student` VALUES (2151, '2025020051', '林明远', '计算机科学与技术学院', 2, 2, 2, 2025, 5.05, -0.30, 0, 0, 72.70, 69.00);
INSERT INTO `student` VALUES (2152, '2024020052', '梁语轩', '计算机科学与技术学院', 2, 2, 14, 2024, 5.54, -0.52, 0, 0, 66.70, 68.30);
INSERT INTO `student` VALUES (2153, '2023020053', '王一睿', '计算机科学与技术学院', 2, 2, 26, 2023, 4.31, -0.96, 1, 0, 69.36, 61.10);
INSERT INTO `student` VALUES (2154, '2022020054', '赵沐彤', '计算机科学与技术学院', 2, 2, 38, 2022, 4.56, 0.06, 0, 0, 73.80, 60.80);
INSERT INTO `student` VALUES (2155, '2025020055', '孙泽诚', '计算机科学与技术学院', 2, 2, 2, 2025, 2.27, -0.64, 3, 1, 63.70, 63.72);
INSERT INTO `student` VALUES (2156, '2024020056', '何清航', '计算机科学与技术学院', 2, 2, 14, 2024, 4.71, 0.30, 0, 0, 67.60, 69.25);
INSERT INTO `student` VALUES (2157, '2023020057', '宋逸涵', '计算机科学与技术学院', 2, 2, 26, 2023, 5.07, 0.42, 0, 0, 71.20, 68.25);
INSERT INTO `student` VALUES (2158, '2022020058', '张子扬', '计算机科学与技术学院', 2, 2, 38, 2022, 5.38, -0.52, 0, 0, 67.70, 67.05);
INSERT INTO `student` VALUES (2159, '2025020059', '黄依晨', '计算机科学与技术学院', 2, 2, 2, 2025, 7.95, -0.20, 0, 0, 58.50, 70.90);
INSERT INTO `student` VALUES (2160, '2024020060', '胡嘉宁', '计算机科学与技术学院', 2, 2, 14, 2024, 4.71, -0.30, 0, 0, 61.50, 70.20);
INSERT INTO `student` VALUES (2161, '2023020061', '郭书萌', '计算机科学与技术学院', 2, 2, 26, 2023, 5.06, -0.18, 0, 0, 72.10, 69.20);
INSERT INTO `student` VALUES (2162, '2022020062', '郑向宇', '计算机科学与技术学院', 2, 2, 38, 2022, 5.30, -0.06, 0, 0, 75.60, 68.00);
INSERT INTO `student` VALUES (2163, '2025020063', '刘安言', '计算机科学与技术学院', 2, 2, 2, 2025, 4.59, 0.06, 0, 0, 65.50, 63.30);
INSERT INTO `student` VALUES (2164, '2024020064', '周闻怡', '计算机科学与技术学院', 2, 2, 14, 2024, 5.66, -0.52, 0, 0, 69.40, 64.95);
INSERT INTO `student` VALUES (2165, '2023020065', '朱知文', '计算机科学与技术学院', 2, 2, 26, 2023, 2.31, -1.60, 3, 1, 60.00, 63.95);
INSERT INTO `student` VALUES (2166, '2022020066', '马星卓', '计算机科学与技术学院', 2, 2, 38, 2022, 2.79, -0.96, 2, 1, 66.60, 62.75);
INSERT INTO `student` VALUES (2167, '2025020067', '谢若川', '计算机科学与技术学院', 2, 2, 2, 2025, 4.05, 0.54, 0, 0, 66.40, 64.25);
INSERT INTO `student` VALUES (2168, '2024020068', '陈可希', '计算机科学与技术学院', 2, 2, 14, 2024, 7.91, 0.66, 0, 0, 70.30, 72.10);
INSERT INTO `student` VALUES (2169, '2023020069', '吴思昕', '计算机科学与技术学院', 2, 2, 26, 2023, 8.38, -0.30, 0, 0, 73.90, 71.10);
INSERT INTO `student` VALUES (2170, '2022020070', '高景霖', '计算机科学与技术学院', 2, 2, 38, 2022, 4.51, -0.52, 0, 0, 60.50, 69.90);
INSERT INTO `student` VALUES (2171, '2025020071', '罗明远', '计算机科学与技术学院', 2, 2, 2, 2025, 4.15, -0.20, 0, 0, 60.30, 65.20);
INSERT INTO `student` VALUES (2172, '2024020072', '李语轩', '计算机科学与技术学院', 2, 2, 14, 2024, 4.32, 0.06, 0, 0, 64.20, 64.50);
INSERT INTO `student` VALUES (2173, '2023020073', '杨一睿', '计算机科学与技术学院', 2, 2, 26, 2023, 7.63, 0.18, 0, 0, 74.80, 72.05);
INSERT INTO `student` VALUES (2174, '2022020074', '徐沐彤', '计算机科学与技术学院', 2, 2, 38, 2022, 7.84, 0.30, 0, 0, 68.40, 70.85);
INSERT INTO `student` VALUES (2175, '2025020075', '林泽诚', '计算机科学与技术学院', 2, 2, 2, 2025, 1.78, -1.44, 3, 1, 63.60, 60.80);
INSERT INTO `student` VALUES (2176, '2024020076', '梁清航', '计算机科学与技术学院', 2, 2, 14, 2024, 2.06, -1.60, 3, 1, 65.04, 60.80);
INSERT INTO `student` VALUES (2177, '2023020077', '王逸涵', '计算机科学与技术学院', 2, 2, 26, 2023, 5.16, -0.20, 0, 0, 65.80, 66.80);
INSERT INTO `student` VALUES (2178, '2022020078', '赵子扬', '计算机科学与技术学院', 2, 2, 38, 2022, 7.23, -0.30, 0, 0, 69.30, 71.80);
INSERT INTO `student` VALUES (2179, '2025020079', '孙依晨', '计算机科学与技术学院', 2, 2, 2, 2025, 6.09, -0.18, 0, 0, 69.10, 67.10);
INSERT INTO `student` VALUES (2180, '2024020080', '何嘉宁', '计算机科学与技术学院', 2, 2, 14, 2024, 4.05, -1.12, 1, 0, 65.76, 61.00);
INSERT INTO `student` VALUES (2181, '2023020081', '宋书萌', '计算机科学与技术学院', 2, 2, 26, 2023, 4.12, 0.06, 0, 0, 66.70, 65.40);
INSERT INTO `student` VALUES (2182, '2022020082', '张向宇', '计算机科学与技术学院', 2, 2, 38, 2022, 7.25, -0.52, 0, 0, 63.20, 72.75);
INSERT INTO `student` VALUES (2183, '2025020083', '黄安言', '计算机科学与技术学院', 2, 2, 2, 2025, 5.83, -0.20, 0, 0, 63.00, 68.05);
INSERT INTO `student` VALUES (2184, '2024020084', '胡闻怡', '计算机科学与技术学院', 2, 2, 14, 2024, 6.53, 0.42, 0, 0, 66.90, 67.35);
INSERT INTO `student` VALUES (2185, '2025030085', '郭知文', '软件学院', 3, 3, 3, 2025, 2.88, -1.60, 2, 1, 60.00, 61.00);
INSERT INTO `student` VALUES (2186, '2024030086', '郑星卓', '软件学院', 3, 3, 15, 2024, 4.62, 0.66, 0, 0, 69.90, 66.45);
INSERT INTO `student` VALUES (2187, '2023030087', '刘若川', '软件学院', 3, 3, 27, 2023, 4.78, -0.30, 0, 0, 73.50, 65.45);
INSERT INTO `student` VALUES (2188, '2022030088', '周可希', '软件学院', 3, 3, 39, 2022, 5.02, -0.52, 0, 0, 67.10, 64.25);
INSERT INTO `student` VALUES (2189, '2025030089', '朱思昕', '软件学院', 3, 3, 3, 2025, 5.38, -0.20, 0, 0, 66.90, 65.75);
INSERT INTO `student` VALUES (2190, '2024030090', '马景霖', '软件学院', 3, 3, 15, 2024, 3.09, -0.64, 2, 1, 61.44, 65.05);
INSERT INTO `student` VALUES (2191, '2023030091', '谢明远', '软件学院', 3, 3, 27, 2023, 6.32, 0.18, 0, 0, 74.40, 72.60);
INSERT INTO `student` VALUES (2192, '2022030092', '陈语轩', '软件学院', 3, 3, 39, 2022, 6.66, 0.30, 0, 0, 68.00, 71.40);
INSERT INTO `student` VALUES (2193, '2025030093', '吴一睿', '软件学院', 3, 3, 3, 2025, 5.37, 0.42, 0, 0, 67.80, 66.70);
INSERT INTO `student` VALUES (2194, '2024030094', '高沐彤', '软件学院', 3, 3, 15, 2024, 5.75, -0.52, 0, 0, 64.70, 66.00);
INSERT INTO `student` VALUES (2195, '2023030095', '罗泽诚', '软件学院', 3, 3, 27, 2023, 5.88, -0.20, 0, 0, 68.30, 73.55);
INSERT INTO `student` VALUES (2196, '2022030096', '李清航', '软件学院', 3, 3, 39, 2022, 6.06, -0.30, 0, 0, 61.90, 72.35);
INSERT INTO `student` VALUES (2197, '2025030097', '杨逸涵', '软件学院', 3, 3, 3, 2025, 3.19, -0.80, 2, 1, 67.92, 61.45);
INSERT INTO `student` VALUES (2198, '2024030098', '徐子扬', '软件学院', 3, 3, 15, 2024, 3.67, -1.28, 1, 0, 67.20, 60.80);
INSERT INTO `student` VALUES (2199, '2023030099', '林依晨', '软件学院', 3, 3, 27, 2023, 4.68, 0.06, 0, 0, 66.30, 60.80);
INSERT INTO `student` VALUES (2200, '2022030100', '梁嘉宁', '软件学院', 3, 3, 39, 2022, 5.51, -0.52, 0, 0, 69.80, 73.30);
INSERT INTO `student` VALUES (2201, '2025030101', '王书萌', '软件学院', 3, 3, 3, 2025, 4.56, -0.20, 0, 0, 69.60, 68.60);
INSERT INTO `student` VALUES (2202, '2024030102', '赵向宇', '软件学院', 3, 3, 15, 2024, 4.97, 0.42, 0, 0, 73.50, 67.90);
INSERT INTO `student` VALUES (2203, '2023030103', '孙安言', '软件学院', 3, 3, 27, 2023, 5.36, 0.54, 0, 0, 67.20, 66.90);
INSERT INTO `student` VALUES (2204, '2022030104', '何闻怡', '软件学院', 3, 3, 39, 2022, 9.59, 0.66, 0, 0, 70.70, 74.25);
INSERT INTO `student` VALUES (2205, '2025030105', '宋知文', '软件学院', 3, 3, 3, 2025, 4.62, -0.30, 0, 0, 70.50, 69.55);
INSERT INTO `student` VALUES (2206, '2024030106', '张星卓', '软件学院', 3, 3, 15, 2024, 5.01, -0.52, 0, 0, 67.40, 68.85);
INSERT INTO `student` VALUES (2207, '2023030107', '黄若川', '软件学院', 3, 3, 27, 2023, 5.34, -0.20, 0, 0, 61.10, 67.85);
INSERT INTO `student` VALUES (2208, '2022030108', '胡可希', '软件学院', 3, 3, 39, 2022, 3.71, -1.12, 1, 0, 60.72, 60.80);
INSERT INTO `student` VALUES (2209, '2025030109', '郭思昕', '软件学院', 3, 3, 3, 2025, 5.53, 0.18, 0, 0, 71.40, 64.30);
INSERT INTO `student` VALUES (2210, '2024030110', '郑景霖', '软件学院', 3, 3, 15, 2024, 2.23, -0.80, 3, 1, 62.88, 61.00);
INSERT INTO `student` VALUES (2211, '2023030111', '刘明远', '软件学院', 3, 3, 27, 2023, 4.58, 0.42, 0, 0, 69.00, 68.80);
INSERT INTO `student` VALUES (2212, '2022030112', '周语轩', '软件学院', 3, 3, 39, 2022, 4.85, -0.52, 0, 0, 72.50, 67.60);
INSERT INTO `student` VALUES (2213, '2025030113', '朱一睿', '软件学院', 3, 3, 3, 2025, 7.69, -0.20, 0, 0, 72.30, 71.45);
INSERT INTO `student` VALUES (2214, '2024030114', '马沐彤', '软件学院', 3, 3, 15, 2024, 7.48, -0.30, 0, 0, 66.30, 70.75);
INSERT INTO `student` VALUES (2215, '2023030115', '谢泽诚', '软件学院', 3, 3, 27, 2023, 4.55, -0.18, 0, 0, 69.90, 69.75);
INSERT INTO `student` VALUES (2216, '2022030116', '陈清航', '软件学院', 3, 3, 39, 2022, 4.88, -0.06, 0, 0, 73.40, 68.55);
INSERT INTO `student` VALUES (2217, '2025030117', '吴逸涵', '软件学院', 3, 3, 3, 2025, 4.31, 0.06, 0, 0, 73.20, 63.85);
INSERT INTO `student` VALUES (2218, '2024030118', '高子扬', '软件学院', 3, 3, 15, 2024, 7.48, -0.52, 0, 0, 60.20, 71.70);
INSERT INTO `student` VALUES (2219, '2023030119', '罗依晨', '软件学院', 3, 3, 27, 2023, 5.54, -0.20, 0, 0, 63.80, 64.50);
INSERT INTO `student` VALUES (2220, '2022030120', '李嘉宁', '软件学院', 3, 3, 39, 2022, 2.19, -0.96, 3, 1, 67.30, 63.30);
INSERT INTO `student` VALUES (2221, '2025030121', '杨书萌', '软件学院', 3, 3, 3, 2025, 2.10, -1.44, 3, 1, 64.20, 60.80);
INSERT INTO `student` VALUES (2222, '2024030122', '徐向宇', '软件学院', 3, 3, 15, 2024, 7.51, 0.66, 0, 0, 68.10, 72.65);
INSERT INTO `student` VALUES (2223, '2023030123', '林安言', '软件学院', 3, 3, 27, 2023, 7.19, -0.30, 0, 0, 71.70, 71.65);
INSERT INTO `student` VALUES (2224, '2022030124', '梁闻怡', '软件学院', 3, 3, 39, 2022, 7.47, -0.52, 0, 0, 75.20, 70.45);
INSERT INTO `student` VALUES (2225, '2025030125', '王知文', '软件学院', 3, 3, 3, 2025, 3.45, -1.60, 1, 0, 60.00, 65.75);
INSERT INTO `student` VALUES (2226, '2024030126', '赵星卓', '软件学院', 3, 3, 15, 2024, 4.13, 0.06, 0, 0, 69.00, 65.05);
INSERT INTO `student` VALUES (2227, '2025040127', '孙若川', '电子与信息工程学院', 4, 4, 4, 2025, 6.47, 0.18, 0, 0, 71.00, 71.05);
INSERT INTO `student` VALUES (2228, '2024040128', '何可希', '电子与信息工程学院', 4, 4, 16, 2024, 7.05, 0.30, 0, 0, 74.90, 70.35);
INSERT INTO `student` VALUES (2229, '2023040129', '宋思昕', '电子与信息工程学院', 4, 4, 28, 2023, 7.46, 0.42, 0, 0, 68.60, 69.35);
INSERT INTO `student` VALUES (2230, '2022040130', '张景霖', '电子与信息工程学院', 4, 4, 40, 2022, 1.90, -0.96, 3, 1, 64.32, 61.00);
INSERT INTO `student` VALUES (2231, '2025040131', '黄明远', '电子与信息工程学院', 4, 4, 4, 2025, 4.48, -0.20, 0, 0, 64.90, 65.80);
INSERT INTO `student` VALUES (2232, '2024040132', '胡语轩', '电子与信息工程学院', 4, 4, 16, 2024, 4.79, -0.30, 0, 0, 58.90, 65.10);
INSERT INTO `student` VALUES (2233, '2023040133', '郭一睿', '电子与信息工程学院', 4, 4, 28, 2023, 6.62, -0.18, 0, 0, 69.50, 70.30);
INSERT INTO `student` VALUES (2234, '2022040134', '郑沐彤', '电子与信息工程学院', 4, 4, 40, 2022, 6.95, -0.06, 0, 0, 73.00, 69.10);
INSERT INTO `student` VALUES (2235, '2025040135', '刘泽诚', '电子与信息工程学院', 4, 4, 4, 2025, 2.60, -1.28, 2, 1, 62.16, 64.40);
INSERT INTO `student` VALUES (2236, '2024040136', '周清航', '电子与信息工程学院', 4, 4, 16, 2024, 6.31, -0.52, 0, 0, 66.80, 72.25);
INSERT INTO `student` VALUES (2237, '2023040137', '朱逸涵', '电子与信息工程学院', 4, 4, 28, 2023, 6.63, -0.20, 0, 0, 70.40, 71.25);
INSERT INTO `student` VALUES (2238, '2022040138', '马子扬', '电子与信息工程学院', 4, 4, 40, 2022, 6.96, 0.42, 0, 0, 73.90, 70.05);
INSERT INTO `student` VALUES (2239, '2025040139', '谢依晨', '电子与信息工程学院', 4, 4, 4, 2025, 5.73, 0.54, 0, 0, 73.70, 65.35);
INSERT INTO `student` VALUES (2240, '2024040140', '陈嘉宁', '电子与信息工程学院', 4, 4, 16, 2024, 5.90, 0.66, 0, 0, 67.70, 73.20);
INSERT INTO `student` VALUES (2241, '2023040141', '吴书萌', '电子与信息工程学院', 4, 4, 28, 2023, 4.48, -0.30, 0, 0, 71.30, 66.00);
INSERT INTO `student` VALUES (2242, '2022040142', '高向宇', '电子与信息工程学院', 4, 4, 40, 2022, 4.73, -0.52, 0, 0, 67.80, 64.80);
INSERT INTO `student` VALUES (2243, '2025040143', '罗安言', '电子与信息工程学院', 4, 4, 4, 2025, 3.75, -0.96, 1, 0, 58.50, 60.80);
INSERT INTO `student` VALUES (2244, '2024040144', '李闻怡', '电子与信息工程学院', 4, 4, 16, 2024, 5.26, 0.06, 0, 0, 61.60, 65.60);
INSERT INTO `student` VALUES (2245, '2023040145', '杨知文', '电子与信息工程学院', 4, 4, 28, 2023, 5.52, 0.18, 0, 0, 72.20, 73.15);
INSERT INTO `student` VALUES (2246, '2022040146', '徐星卓', '电子与信息工程学院', 4, 4, 40, 2022, 6.24, 0.30, 0, 0, 75.70, 71.95);
INSERT INTO `student` VALUES (2247, '2025040147', '林若川', '电子与信息工程学院', 4, 4, 4, 2025, 4.87, 0.42, 0, 0, 65.60, 67.25);
INSERT INTO `student` VALUES (2248, '2024040148', '梁可希', '电子与信息工程学院', 4, 4, 16, 2024, 5.25, -0.52, 0, 0, 69.50, 66.55);
INSERT INTO `student` VALUES (2249, '2023040149', '王思昕', '电子与信息工程学院', 4, 4, 28, 2023, 9.16, -0.20, 0, 0, 73.10, 74.10);
INSERT INTO `student` VALUES (2250, '2022040150', '赵景霖', '电子与信息工程学院', 4, 4, 40, 2022, 5.76, -0.30, 0, 0, 76.60, 72.90);
INSERT INTO `student` VALUES (2251, '2025040151', '孙明远', '电子与信息工程学院', 4, 4, 4, 2025, 4.82, -0.18, 0, 0, 66.50, 68.20);
INSERT INTO `student` VALUES (2252, '2024040152', '何语轩', '电子与信息工程学院', 4, 4, 16, 2024, 2.98, -1.44, 2, 1, 63.60, 61.30);
INSERT INTO `student` VALUES (2253, '2023040153', '宋一睿', '电子与信息工程学院', 4, 4, 28, 2023, 3.79, -0.80, 1, 0, 67.92, 60.80);
INSERT INTO `student` VALUES (2254, '2022040154', '张沐彤', '电子与信息工程学院', 4, 4, 40, 2022, 6.50, -0.52, 0, 0, 60.60, 67.65);
INSERT INTO `student` VALUES (2255, '2025040155', '黄泽诚', '电子与信息工程学院', 4, 4, 4, 2025, 4.19, -0.20, 0, 0, 60.40, 69.15);
INSERT INTO `student` VALUES (2256, '2024040156', '胡清航', '电子与信息工程学院', 4, 4, 16, 2024, 4.44, 0.42, 0, 0, 64.30, 68.45);
INSERT INTO `student` VALUES (2257, '2023040157', '郭逸涵', '电子与信息工程学院', 4, 4, 28, 2023, 4.86, 0.54, 0, 0, 74.90, 67.45);
INSERT INTO `student` VALUES (2258, '2022040158', '郑子扬', '电子与信息工程学院', 4, 4, 40, 2022, 8.97, 0.66, 0, 0, 68.50, 74.80);
INSERT INTO `student` VALUES (2259, '2025040159', '刘依晨', '电子与信息工程学院', 4, 4, 4, 2025, 7.26, -0.30, 0, 0, 68.30, 70.10);
INSERT INTO `student` VALUES (2260, '2024040160', '周嘉宁', '电子与信息工程学院', 4, 4, 16, 2024, 4.52, -0.52, 0, 0, 72.20, 69.40);
INSERT INTO `student` VALUES (2261, '2023040161', '朱书萌', '电子与信息工程学院', 4, 4, 28, 2023, 4.85, -0.20, 0, 0, 75.80, 68.40);
INSERT INTO `student` VALUES (2262, '2022040162', '马向宇', '电子与信息工程学院', 4, 4, 40, 2022, 5.09, 0.06, 0, 0, 69.40, 67.20);
INSERT INTO `student` VALUES (2263, '2025040163', '谢安言', '电子与信息工程学院', 4, 4, 4, 2025, 5.03, 0.18, 0, 0, 69.20, 64.85);
INSERT INTO `student` VALUES (2264, '2024040164', '陈闻怡', '电子与信息工程学院', 4, 4, 16, 2024, 5.44, 0.30, 0, 0, 73.10, 64.15);
INSERT INTO `student` VALUES (2265, '2023040165', '吴知文', '电子与信息工程学院', 4, 4, 28, 2023, 2.15, -1.12, 3, 1, 65.76, 63.15);
INSERT INTO `student` VALUES (2266, '2022040166', '高星卓', '电子与信息工程学院', 4, 4, 40, 2022, 4.28, -0.52, 0, 0, 63.30, 68.15);
INSERT INTO `student` VALUES (2267, '2025040167', '罗若川', '电子与信息工程学院', 4, 4, 4, 2025, 7.17, -0.20, 0, 0, 63.10, 72.00);
INSERT INTO `student` VALUES (2268, '2024040168', '李可希', '电子与信息工程学院', 4, 4, 16, 2024, 7.02, -0.30, 0, 0, 67.00, 71.30);
INSERT INTO `student` VALUES (2269, '2025050169', '杨思昕', '电气工程学院', 5, 5, 5, 2025, 6.81, -0.18, 0, 0, 66.10, 68.75);
INSERT INTO `student` VALUES (2270, '2024050170', '徐景霖', '电气工程学院', 5, 5, 17, 2024, 4.30, -0.06, 0, 0, 70.00, 68.05);
INSERT INTO `student` VALUES (2271, '2023050171', '林明远', '电气工程学院', 5, 5, 29, 2023, 4.48, 0.06, 0, 0, 73.60, 67.05);
INSERT INTO `student` VALUES (2272, '2022050172', '梁语轩', '电气工程学院', 5, 5, 41, 2022, 7.80, -0.52, 0, 0, 77.10, 74.40);
INSERT INTO `student` VALUES (2273, '2025050173', '王一睿', '电气工程学院', 5, 5, 5, 2025, 6.75, -0.20, 0, 0, 67.00, 69.70);
INSERT INTO `student` VALUES (2274, '2024050174', '赵沐彤', '电气工程学院', 5, 5, 17, 2024, 4.87, 0.42, 0, 0, 70.90, 62.80);
INSERT INTO `student` VALUES (2275, '2023050175', '孙泽诚', '电气工程学院', 5, 5, 29, 2023, 1.86, -1.12, 3, 1, 60.72, 61.80);
INSERT INTO `student` VALUES (2276, '2022050176', '何清航', '电气工程学院', 5, 5, 41, 2022, 5.38, 0.66, 0, 0, 68.10, 69.15);
INSERT INTO `student` VALUES (2277, '2025050177', '宋逸涵', '电气工程学院', 5, 5, 5, 2025, 6.09, -0.30, 0, 0, 67.90, 70.65);
INSERT INTO `student` VALUES (2278, '2024050178', '张子扬', '电气工程学院', 5, 5, 17, 2024, 6.49, -0.52, 0, 0, 64.80, 69.95);
INSERT INTO `student` VALUES (2279, '2023050179', '黄依晨', '电气工程学院', 5, 5, 29, 2023, 6.93, -0.20, 0, 0, 68.40, 68.95);
INSERT INTO `student` VALUES (2280, '2022050180', '胡嘉宁', '电气工程学院', 5, 5, 41, 2022, 4.18, 0.06, 0, 0, 62.00, 67.75);
INSERT INTO `student` VALUES (2281, '2025050181', '郭书萌', '电气工程学院', 5, 5, 5, 2025, 5.74, 0.18, 0, 0, 68.80, 71.60);
INSERT INTO `student` VALUES (2282, '2024050182', '郑向宇', '电气工程学院', 5, 5, 17, 2024, 6.43, 0.30, 0, 0, 72.70, 70.90);
INSERT INTO `student` VALUES (2283, '2023050183', '刘安言', '电气工程学院', 5, 5, 29, 2023, 6.90, 0.42, 0, 0, 76.30, 69.90);
INSERT INTO `student` VALUES (2284, '2022050184', '周闻怡', '电气工程学院', 5, 5, 41, 2022, 7.22, -0.52, 0, 0, 69.90, 68.70);
INSERT INTO `student` VALUES (2285, '2025050185', '朱知文', '电气工程学院', 5, 5, 5, 2025, 4.28, -1.28, 1, 0, 62.16, 66.35);
INSERT INTO `student` VALUES (2286, '2024050186', '马星卓', '电气工程学院', 5, 5, 17, 2024, 4.48, -0.30, 0, 0, 73.60, 65.65);
INSERT INTO `student` VALUES (2287, '2023050187', '谢若川', '电气工程学院', 5, 5, 29, 2023, 4.77, -0.18, 0, 0, 67.30, 64.65);
INSERT INTO `student` VALUES (2288, '2022050188', '陈可希', '电气工程学院', 5, 5, 41, 2022, 6.49, -0.06, 0, 0, 70.80, 69.65);
INSERT INTO `student` VALUES (2289, '2025050189', '吴思昕', '电气工程学院', 5, 5, 5, 2025, 5.14, 0.06, 0, 0, 70.60, 64.95);
INSERT INTO `student` VALUES (2290, '2024050190', '高景霖', '电气工程学院', 5, 5, 17, 2024, 5.48, -0.52, 0, 0, 67.50, 72.80);
INSERT INTO `student` VALUES (2291, '2023050191', '罗明远', '电气工程学院', 5, 5, 29, 2023, 5.75, -0.20, 0, 0, 61.20, 71.80);
INSERT INTO `student` VALUES (2292, '2022050192', '李语轩', '电气工程学院', 5, 5, 41, 2022, 6.44, 0.42, 0, 0, 64.70, 70.60);
INSERT INTO `student` VALUES (2293, '2025050193', '杨一睿', '电气工程学院', 5, 5, 5, 2025, 5.17, 0.54, 0, 0, 71.50, 65.90);
INSERT INTO `student` VALUES (2294, '2024050194', '徐沐彤', '电气工程学院', 5, 5, 17, 2024, 9.36, 0.66, 0, 0, 75.40, 73.75);
INSERT INTO `student` VALUES (2295, '2023050195', '林泽诚', '电气工程学院', 5, 5, 29, 2023, 5.81, -0.30, 0, 0, 69.10, 72.75);
INSERT INTO `student` VALUES (2296, '2022050196', '梁清航', '电气工程学院', 5, 5, 41, 2022, 4.39, -0.52, 0, 0, 72.60, 65.35);
INSERT INTO `student` VALUES (2297, '2025050197', '王逸涵', '电气工程学院', 5, 5, 5, 2025, 2.70, -0.64, 2, 1, 61.44, 60.80);
INSERT INTO `student` VALUES (2298, '2024050198', '赵子扬', '电气工程学院', 5, 5, 17, 2024, 3.83, -0.64, 1, 0, 61.44, 60.80);
INSERT INTO `student` VALUES (2299, '2023050199', '孙依晨', '电气工程学院', 5, 5, 29, 2023, 9.11, 0.18, 0, 0, 70.00, 73.70);
INSERT INTO `student` VALUES (2300, '2022050200', '何嘉宁', '电气工程学院', 5, 5, 41, 2022, 5.34, 0.30, 0, 0, 73.50, 72.50);
INSERT INTO `student` VALUES (2301, '2025050201', '宋书萌', '电气工程学院', 5, 5, 5, 2025, 4.38, 0.42, 0, 0, 73.30, 67.80);
INSERT INTO `student` VALUES (2302, '2024050202', '张向宇', '电气工程学院', 5, 5, 17, 2024, 4.81, -0.52, 0, 0, 60.30, 67.10);
INSERT INTO `student` VALUES (2303, '2023050203', '黄安言', '电气工程学院', 5, 5, 29, 2023, 8.74, -0.20, 0, 0, 63.90, 74.65);
INSERT INTO `student` VALUES (2304, '2022050204', '胡闻怡', '电气工程学院', 5, 5, 41, 2022, 8.93, -0.30, 0, 0, 67.40, 73.45);
INSERT INTO `student` VALUES (2305, '2025050205', '郭知文', '电气工程学院', 5, 5, 5, 2025, 4.56, -0.18, 0, 0, 74.20, 68.75);
INSERT INTO `student` VALUES (2306, '2024050206', '郑星卓', '电气工程学院', 5, 5, 17, 2024, 4.78, -0.06, 0, 0, 68.20, 68.05);
INSERT INTO `student` VALUES (2307, '2023050207', '刘若川', '电气工程学院', 5, 5, 29, 2023, 2.78, -1.12, 2, 1, 65.76, 60.85);
INSERT INTO `student` VALUES (2308, '2022050208', '周可希', '电气工程学院', 5, 5, 41, 2022, 5.95, -0.52, 0, 0, 75.30, 68.20);
INSERT INTO `student` VALUES (2309, '2025050209', '朱思昕', '电气工程学院', 5, 5, 5, 2025, 5.31, -0.20, 0, 0, 65.20, 63.50);
INSERT INTO `student` VALUES (2310, '2024050210', '马景霖', '电气工程学院', 5, 5, 17, 2024, 4.15, 0.42, 0, 0, 69.10, 69.00);
INSERT INTO `student` VALUES (2311, '2025060211', '谢明远', '机械工程学院', 6, 6, 6, 2025, 4.12, 0.54, 0, 0, 71.10, 66.45);
INSERT INTO `student` VALUES (2312, '2024060212', '陈语轩', '机械工程学院', 6, 6, 18, 2024, 7.95, 0.66, 0, 0, 75.00, 74.30);
INSERT INTO `student` VALUES (2313, '2023060213', '吴一睿', '机械工程学院', 6, 6, 30, 2023, 8.55, -0.30, 0, 0, 68.70, 73.30);
INSERT INTO `student` VALUES (2314, '2022060214', '高沐彤', '机械工程学院', 6, 6, 42, 2022, 8.71, -0.52, 0, 0, 65.20, 72.10);
INSERT INTO `student` VALUES (2315, '2025060215', '罗泽诚', '机械工程学院', 6, 6, 6, 2025, 4.24, -0.20, 0, 0, 65.00, 67.40);
INSERT INTO `student` VALUES (2316, '2024060216', '李清航', '机械工程学院', 6, 6, 18, 2024, 4.49, 0.06, 0, 0, 68.90, 66.70);
INSERT INTO `student` VALUES (2317, '2023060217', '杨逸涵', '机械工程学院', 6, 6, 30, 2023, 7.73, 0.18, 0, 0, 69.60, 74.25);
INSERT INTO `student` VALUES (2318, '2022060218', '徐子扬', '机械工程学院', 6, 6, 42, 2022, 5.75, 0.30, 0, 0, 73.10, 66.85);
INSERT INTO `student` VALUES (2319, '2025060219', '林依晨', '机械工程学院', 6, 6, 6, 2025, 4.84, 0.42, 0, 0, 72.90, 62.15);
INSERT INTO `student` VALUES (2320, '2024060220', '梁嘉宁', '机械工程学院', 6, 6, 18, 2024, 1.82, -1.28, 3, 1, 66.90, 61.45);
INSERT INTO `student` VALUES (2321, '2023060221', '王书萌', '机械工程学院', 6, 6, 30, 2023, 7.79, -0.20, 0, 0, 70.50, 75.20);
INSERT INTO `student` VALUES (2322, '2022060222', '赵向宇', '机械工程学院', 6, 6, 42, 2022, 7.41, -0.30, 0, 0, 74.00, 74.00);
INSERT INTO `student` VALUES (2323, '2025060223', '孙安言', '机械工程学院', 6, 6, 6, 2025, 6.22, -0.18, 0, 0, 73.80, 69.30);
INSERT INTO `student` VALUES (2324, '2024060224', '何闻怡', '机械工程学院', 6, 6, 18, 2024, 6.77, -0.06, 0, 0, 67.80, 68.60);
INSERT INTO `student` VALUES (2325, '2023060225', '宋知文', '机械工程学院', 6, 6, 30, 2023, 4.20, 0.06, 0, 0, 71.40, 67.60);
INSERT INTO `student` VALUES (2326, '2022060226', '张星卓', '机械工程学院', 6, 6, 42, 2022, 7.39, -0.52, 0, 0, 67.90, 74.95);
INSERT INTO `student` VALUES (2327, '2025060227', '黄若川', '机械工程学院', 6, 6, 6, 2025, 6.26, -0.20, 0, 0, 67.70, 70.25);
INSERT INTO `student` VALUES (2328, '2024060228', '胡可希', '机械工程学院', 6, 6, 18, 2024, 6.76, 0.42, 0, 0, 61.70, 69.55);
INSERT INTO `student` VALUES (2329, '2023060229', '郭思昕', '机械工程学院', 6, 6, 30, 2023, 4.82, 0.54, 0, 0, 72.30, 62.35);
INSERT INTO `student` VALUES (2330, '2022060230', '郑景霖', '机械工程学院', 6, 6, 42, 2022, 4.92, 0.66, 0, 0, 75.80, 69.70);
INSERT INTO `student` VALUES (2331, '2025060231', '刘明远', '机械工程学院', 6, 6, 6, 2025, 4.45, -0.30, 0, 0, 65.70, 65.00);
INSERT INTO `student` VALUES (2332, '2024060232', '周语轩', '机械工程学院', 6, 6, 18, 2024, 6.05, -0.52, 0, 0, 69.60, 70.50);
INSERT INTO `student` VALUES (2333, '2023060233', '朱一睿', '机械工程学院', 6, 6, 30, 2023, 6.29, -0.20, 0, 0, 73.20, 69.50);
INSERT INTO `student` VALUES (2334, '2022060234', '马沐彤', '机械工程学院', 6, 6, 42, 2022, 6.72, 0.06, 0, 0, 76.70, 68.30);
INSERT INTO `student` VALUES (2335, '2025060235', '谢泽诚', '机械工程学院', 6, 6, 6, 2025, 5.34, 0.18, 0, 0, 66.60, 72.15);
INSERT INTO `student` VALUES (2336, '2024060236', '陈清航', '机械工程学院', 6, 6, 18, 2024, 5.71, 0.30, 0, 0, 70.50, 71.45);
INSERT INTO `student` VALUES (2337, '2023060237', '吴逸涵', '机械工程学院', 6, 6, 30, 2023, 6.39, 0.42, 0, 0, 74.10, 70.45);
INSERT INTO `student` VALUES (2338, '2022060238', '高子扬', '机械工程学院', 6, 6, 42, 2022, 6.68, -0.52, 0, 0, 70.60, 69.25);
INSERT INTO `student` VALUES (2339, '2025060239', '罗依晨', '机械工程学院', 6, 6, 6, 2025, 8.84, -0.20, 0, 0, 60.50, 73.10);
INSERT INTO `student` VALUES (2340, '2024060240', '李嘉宁', '机械工程学院', 6, 6, 18, 2024, 3.54, -1.60, 1, 0, 64.40, 63.72);
INSERT INTO `student` VALUES (2341, '2023060241', '杨书萌', '机械工程学院', 6, 6, 30, 2023, 4.42, -0.18, 0, 0, 75.00, 65.20);
INSERT INTO `student` VALUES (2342, '2022060242', '徐向宇', '机械工程学院', 6, 6, 42, 2022, 4.56, -0.06, 0, 0, 68.60, 64.00);
INSERT INTO `student` VALUES (2343, '2025060243', '林安言', '机械工程学院', 6, 6, 6, 2025, 4.59, 0.06, 0, 0, 68.40, 65.50);
INSERT INTO `student` VALUES (2344, '2024060244', '梁闻怡', '机械工程学院', 6, 6, 18, 2024, 9.28, -0.52, 0, 0, 72.30, 73.35);
INSERT INTO `student` VALUES (2345, '2023060245', '王知文', '机械工程学院', 6, 6, 30, 2023, 5.33, -0.20, 0, 0, 75.90, 72.35);
INSERT INTO `student` VALUES (2346, '2022060246', '赵星卓', '机械工程学院', 6, 6, 42, 2022, 5.61, 0.42, 0, 0, 69.50, 71.15);
INSERT INTO `student` VALUES (2347, '2025060247', '孙若川', '机械工程学院', 6, 6, 6, 2025, 4.62, 0.54, 0, 0, 69.30, 66.45);
INSERT INTO `student` VALUES (2348, '2024060248', '何可希', '机械工程学院', 6, 6, 18, 2024, 8.84, 0.66, 0, 0, 73.20, 74.30);
INSERT INTO `student` VALUES (2349, '2023060249', '宋思昕', '机械工程学院', 6, 6, 30, 2023, 9.05, -0.30, 0, 0, 76.80, 73.30);
INSERT INTO `student` VALUES (2350, '2022060250', '张景霖', '机械工程学院', 6, 6, 42, 2022, 5.56, -0.52, 0, 0, 63.40, 72.10);
INSERT INTO `student` VALUES (2351, '2025060251', '黄明远', '机械工程学院', 6, 6, 6, 2025, 2.14, -1.28, 3, 1, 62.16, 61.20);
INSERT INTO `student` VALUES (2352, '2024060252', '胡语轩', '机械工程学院', 6, 6, 18, 2024, 2.74, -1.60, 2, 1, 65.04, 60.80);
INSERT INTO `student` VALUES (2353, '2025070253', '郭一睿', '能源与动力工程学院', 7, 7, 7, 2025, 5.70, 0.18, 0, 0, 66.20, 66.50);
INSERT INTO `student` VALUES (2354, '2024070254', '郑沐彤', '能源与动力工程学院', 7, 7, 19, 2024, 8.57, 0.30, 0, 0, 70.10, 72.00);
INSERT INTO `student` VALUES (2355, '2023070255', '刘泽诚', '能源与动力工程学院', 7, 7, 31, 2023, 4.80, 0.42, 0, 0, 73.70, 71.00);
INSERT INTO `student` VALUES (2356, '2022070256', '周清航', '能源与动力工程学院', 7, 7, 43, 2022, 5.03, -0.52, 0, 0, 77.20, 69.80);
INSERT INTO `student` VALUES (2357, '2025070257', '朱逸涵', '能源与动力工程学院', 7, 7, 7, 2025, 7.86, -0.20, 0, 0, 67.10, 73.65);
INSERT INTO `student` VALUES (2358, '2024070258', '马子扬', '能源与动力工程学院', 7, 7, 19, 2024, 8.48, -0.30, 0, 0, 71.00, 72.95);
INSERT INTO `student` VALUES (2359, '2023070259', '谢依晨', '能源与动力工程学院', 7, 7, 31, 2023, 8.40, -0.18, 0, 0, 74.60, 71.95);
INSERT INTO `student` VALUES (2360, '2022070260', '陈嘉宁', '能源与动力工程学院', 7, 7, 43, 2022, 5.11, -0.06, 0, 0, 78.10, 70.75);
INSERT INTO `student` VALUES (2361, '2025070261', '吴书萌', '能源与动力工程学院', 7, 7, 7, 2025, 4.46, 0.06, 0, 0, 68.00, 66.05);
INSERT INTO `student` VALUES (2362, '2024070262', '高向宇', '能源与动力工程学院', 7, 7, 19, 2024, 5.33, -0.52, 0, 0, 64.90, 67.70);
INSERT INTO `student` VALUES (2363, '2023070263', '罗安言', '能源与动力工程学院', 7, 7, 31, 2023, 5.69, -0.20, 0, 0, 68.50, 66.70);
INSERT INTO `student` VALUES (2364, '2022070264', '李闻怡', '能源与动力工程学院', 7, 7, 43, 2022, 5.93, 0.42, 0, 0, 62.10, 65.50);
INSERT INTO `student` VALUES (2365, '2025070265', '杨知文', '能源与动力工程学院', 7, 7, 7, 2025, 4.05, 0.54, 0, 0, 68.90, 67.00);
INSERT INTO `student` VALUES (2366, '2024070266', '徐星卓', '能源与动力工程学院', 7, 7, 19, 2024, 7.62, 0.66, 0, 0, 72.80, 74.85);
INSERT INTO `student` VALUES (2367, '2023070267', '林若川', '能源与动力工程学院', 7, 7, 31, 2023, 7.28, -0.30, 0, 0, 76.40, 73.85);
INSERT INTO `student` VALUES (2368, '2022070268', '梁可希', '能源与动力工程学院', 7, 7, 43, 2022, 7.62, -0.52, 0, 0, 70.00, 72.65);
INSERT INTO `student` VALUES (2369, '2025070269', '王思昕', '能源与动力工程学院', 7, 7, 7, 2025, 6.52, -0.20, 0, 0, 69.80, 67.95);
INSERT INTO `student` VALUES (2370, '2024070270', '赵景霖', '能源与动力工程学院', 7, 7, 19, 2024, 4.20, 0.06, 0, 0, 73.70, 67.25);
INSERT INTO `student` VALUES (2371, '2023070271', '孙明远', '能源与动力工程学院', 7, 7, 31, 2023, 7.32, 0.18, 0, 0, 77.30, 74.80);
INSERT INTO `student` VALUES (2372, '2022070272', '何语轩', '能源与动力工程学院', 7, 7, 43, 2022, 7.59, 0.30, 0, 0, 70.90, 73.60);
INSERT INTO `student` VALUES (2373, '2025070273', '宋一睿', '能源与动力工程学院', 7, 7, 7, 2025, 4.56, 0.42, 0, 0, 70.70, 62.70);
INSERT INTO `student` VALUES (2374, '2024070274', '张沐彤', '能源与动力工程学院', 7, 7, 19, 2024, 4.80, -0.52, 0, 0, 67.60, 62.00);
INSERT INTO `student` VALUES (2375, '2023070275', '黄泽诚', '能源与动力工程学院', 7, 7, 31, 2023, 4.98, -0.20, 0, 0, 61.30, 69.55);
INSERT INTO `student` VALUES (2376, '2022070276', '胡清航', '能源与动力工程学院', 7, 7, 43, 2022, 6.85, -0.30, 0, 0, 64.80, 74.55);
INSERT INTO `student` VALUES (2377, '2025070277', '郭逸涵', '能源与动力工程学院', 7, 7, 7, 2025, 5.61, -0.18, 0, 0, 71.60, 69.85);
INSERT INTO `student` VALUES (2378, '2024070278', '郑子扬', '能源与动力工程学院', 7, 7, 19, 2024, 6.25, -0.06, 0, 0, 75.50, 69.15);
INSERT INTO `student` VALUES (2379, '2023070279', '刘依晨', '能源与动力工程学院', 7, 7, 31, 2023, 6.64, 0.06, 0, 0, 69.20, 68.15);
INSERT INTO `student` VALUES (2380, '2022070280', '周嘉宁', '能源与动力工程学院', 7, 7, 43, 2022, 6.82, -0.52, 0, 0, 72.70, 75.50);
INSERT INTO `student` VALUES (2381, '2025070281', '朱书萌', '能源与动力工程学院', 7, 7, 7, 2025, 5.64, -0.20, 0, 0, 72.50, 70.80);
INSERT INTO `student` VALUES (2382, '2024070282', '马向宇', '能源与动力工程学院', 7, 7, 19, 2024, 6.25, 0.42, 0, 0, 76.40, 70.10);
INSERT INTO `student` VALUES (2383, '2023070283', '谢安言', '能源与动力工程学院', 7, 7, 31, 2023, 6.63, 0.54, 0, 0, 70.10, 69.10);
INSERT INTO `student` VALUES (2384, '2022070284', '陈闻怡', '能源与动力工程学院', 7, 7, 43, 2022, 7.87, 0.66, 0, 0, 73.60, 70.25);
INSERT INTO `student` VALUES (2385, '2025070285', '吴知文', '能源与动力工程学院', 7, 7, 7, 2025, 3.41, -0.64, 1, 0, 66.48, 63.72);
INSERT INTO `student` VALUES (2386, '2024070286', '高星卓', '能源与动力工程学院', 7, 7, 19, 2024, 4.43, -0.52, 0, 0, 60.40, 64.85);
INSERT INTO `student` VALUES (2387, '2023070287', '罗若川', '能源与动力工程学院', 7, 7, 31, 2023, 5.59, -0.20, 0, 0, 64.00, 70.05);
INSERT INTO `student` VALUES (2388, '2022070288', '李可希', '能源与动力工程学院', 7, 7, 43, 2022, 6.21, 0.06, 0, 0, 67.50, 68.85);
INSERT INTO `student` VALUES (2389, '2025070289', '杨思昕', '能源与动力工程学院', 7, 7, 7, 2025, 8.76, 0.18, 0, 0, 74.30, 72.70);
INSERT INTO `student` VALUES (2390, '2024070290', '徐景霖', '能源与动力工程学院', 7, 7, 19, 2024, 5.26, 0.30, 0, 0, 68.30, 72.00);
INSERT INTO `student` VALUES (2391, '2023070291', '林明远', '能源与动力工程学院', 7, 7, 31, 2023, 5.63, 0.42, 0, 0, 71.90, 71.00);
INSERT INTO `student` VALUES (2392, '2022070292', '梁语轩', '能源与动力工程学院', 7, 7, 43, 2022, 5.81, -0.52, 0, 0, 75.40, 69.80);
INSERT INTO `student` VALUES (2393, '2025070293', '王一睿', '能源与动力工程学院', 7, 7, 7, 2025, 8.82, -0.20, 0, 0, 75.20, 73.65);
INSERT INTO `student` VALUES (2394, '2024070294', '赵沐彤', '能源与动力工程学院', 7, 7, 19, 2024, 8.76, -0.30, 0, 0, 69.20, 72.95);
INSERT INTO `student` VALUES (2395, '2025080295', '孙泽诚', '经济与管理学院', 8, 8, 8, 2025, 2.43, -1.12, 3, 1, 60.72, 63.72);
INSERT INTO `student` VALUES (2396, '2024080296', '何清航', '经济与管理学院', 8, 8, 20, 2024, 3.28, -1.28, 2, 1, 62.16, 63.50);
INSERT INTO `student` VALUES (2397, '2023080297', '宋逸涵', '经济与管理学院', 8, 8, 32, 2023, 3.56, -1.44, 1, 0, 63.60, 62.50);
INSERT INTO `student` VALUES (2398, '2022080298', '张子扬', '经济与管理学院', 8, 8, 44, 2022, 9.43, 0.64, 0, 0, 65.30, 76.05);
INSERT INTO `student` VALUES (2399, '2025080299', '黄依晨', '经济与管理学院', 8, 8, 8, 2025, 8.55, -0.20, 0, 0, 65.10, 71.35);
INSERT INTO `student` VALUES (2400, '2024080300', '胡嘉宁', '经济与管理学院', 8, 8, 20, 2024, 4.76, 0.42, 0, 0, 69.00, 70.65);
INSERT INTO `student` VALUES (2401, '2023080301', '郭书萌', '经济与管理学院', 8, 8, 32, 2023, 5.06, 0.54, 0, 0, 69.70, 69.65);
INSERT INTO `student` VALUES (2402, '2022080302', '郑向宇', '经济与管理学院', 8, 8, 44, 2022, 8.89, 0.36, 0, 0, 73.20, 77.00);
INSERT INTO `student` VALUES (2403, '2025080303', '刘安言', '经济与管理学院', 8, 8, 8, 2025, 7.42, -0.30, 0, 0, 73.00, 72.30);
INSERT INTO `student` VALUES (2404, '2024080304', '周闻怡', '经济与管理学院', 8, 8, 20, 2024, 8.57, -0.52, 0, 0, 76.90, 71.60);
INSERT INTO `student` VALUES (2405, '2023080305', '朱知文', '经济与管理学院', 8, 8, 32, 2023, 5.03, -0.20, 0, 0, 70.60, 70.60);
INSERT INTO `student` VALUES (2406, '2022080306', '马星卓', '经济与管理学院', 8, 8, 44, 2022, 3.08, -0.96, 2, 1, 64.32, 61.00);
INSERT INTO `student` VALUES (2407, '2025080307', '谢若川', '经济与管理学院', 8, 8, 8, 2025, 5.26, 0.18, 0, 0, 73.90, 67.05);
INSERT INTO `student` VALUES (2408, '2024080308', '陈可希', '经济与管理学院', 8, 8, 20, 2024, 5.65, 0.30, 0, 0, 67.90, 66.35);
INSERT INTO `student` VALUES (2409, '2023080309', '吴思昕', '经济与管理学院', 8, 8, 32, 2023, 8.32, 0.42, 0, 0, 71.50, 71.55);
INSERT INTO `student` VALUES (2410, '2022080310', '高景霖', '经济与管理学院', 8, 8, 44, 2022, 4.58, -0.52, 0, 0, 68.00, 70.35);
INSERT INTO `student` VALUES (2411, '2025080311', '罗明远', '经济与管理学院', 8, 8, 8, 2025, 7.45, -0.20, 0, 0, 67.80, 74.20);
INSERT INTO `student` VALUES (2412, '2024080312', '李语轩', '经济与管理学院', 8, 8, 20, 2024, 7.20, -0.30, 0, 0, 61.80, 73.50);
INSERT INTO `student` VALUES (2413, '2023080313', '杨一睿', '经济与管理学院', 8, 8, 32, 2023, 7.59, -0.18, 0, 0, 72.40, 72.50);
INSERT INTO `student` VALUES (2414, '2022080314', '徐沐彤', '经济与管理学院', 8, 8, 44, 2022, 8.55, -0.06, 0, 0, 75.90, 71.30);
INSERT INTO `student` VALUES (2415, '2025080315', '林泽诚', '经济与管理学院', 8, 8, 8, 2025, 4.20, 0.06, 0, 0, 75.70, 66.60);
INSERT INTO `student` VALUES (2416, '2024080316', '梁清航', '经济与管理学院', 8, 8, 20, 2024, 7.21, -0.52, 0, 0, 69.70, 74.45);
INSERT INTO `student` VALUES (2417, '2023080317', '王逸涵', '经济与管理学院', 8, 8, 32, 2023, 5.28, -0.20, 0, 0, 73.30, 67.25);
INSERT INTO `student` VALUES (2418, '2022080318', '赵子扬', '经济与管理学院', 8, 8, 44, 2022, 5.55, 0.42, 0, 0, 76.80, 66.05);
INSERT INTO `student` VALUES (2419, '2025080319', '孙依晨', '经济与管理学院', 8, 8, 8, 2025, 4.78, 0.54, 0, 0, 66.70, 61.35);
INSERT INTO `student` VALUES (2420, '2024080320', '何嘉宁', '经济与管理学院', 8, 8, 20, 2024, 7.10, 0.66, 0, 0, 70.60, 75.40);
INSERT INTO `student` VALUES (2421, '2023080321', '宋书萌', '经济与管理学院', 8, 8, 32, 2023, 6.82, -0.30, 0, 0, 74.20, 74.40);
INSERT INTO `student` VALUES (2422, '2022080322', '张向宇', '经济与管理学院', 8, 8, 44, 2022, 7.14, -0.52, 0, 0, 70.70, 73.20);
INSERT INTO `student` VALUES (2423, '2025080323', '黄安言', '经济与管理学院', 8, 8, 8, 2025, 6.08, -0.20, 0, 0, 60.60, 68.50);
INSERT INTO `student` VALUES (2424, '2024080324', '胡闻怡', '经济与管理学院', 8, 8, 20, 2024, 6.49, 0.06, 0, 0, 64.50, 67.80);
INSERT INTO `student` VALUES (2425, '2023080325', '郭知文', '经济与管理学院', 8, 8, 32, 2023, 6.79, 0.18, 0, 0, 75.10, 75.35);
INSERT INTO `student` VALUES (2426, '2022080326', '郑星卓', '经济与管理学院', 8, 8, 44, 2022, 7.17, 0.30, 0, 0, 78.60, 74.15);
INSERT INTO `student` VALUES (2427, '2025080327', '刘若川', '经济与管理学院', 8, 8, 8, 2025, 5.89, 0.42, 0, 0, 68.50, 69.45);
INSERT INTO `student` VALUES (2428, '2024080328', '周可希', '经济与管理学院', 8, 8, 20, 2024, 4.51, -0.52, 0, 0, 72.40, 62.55);
INSERT INTO `student` VALUES (2429, '2023080329', '朱思昕', '经济与管理学院', 8, 8, 32, 2023, 7.82, -0.20, 0, 0, 76.00, 70.10);
INSERT INTO `student` VALUES (2430, '2022080330', '马景霖', '经济与管理学院', 8, 8, 44, 2022, 4.85, -0.30, 0, 0, 69.60, 68.90);
INSERT INTO `student` VALUES (2431, '2025080331', '谢明远', '经济与管理学院', 8, 8, 8, 2025, 5.16, -0.18, 0, 0, 69.40, 70.40);
INSERT INTO `student` VALUES (2432, '2024080332', '陈语轩', '经济与管理学院', 8, 8, 20, 2024, 5.60, -0.06, 0, 0, 73.30, 69.70);
INSERT INTO `student` VALUES (2433, '2023080333', '吴一睿', '经济与管理学院', 8, 8, 32, 2023, 6.14, 0.06, 0, 0, 76.90, 68.70);
INSERT INTO `student` VALUES (2434, '2022080334', '高沐彤', '经济与管理学院', 8, 8, 44, 2022, 9.66, 0.92, 0, 0, 63.50, 76.05);
INSERT INTO `student` VALUES (2435, '2025080335', '罗泽诚', '经济与管理学院', 8, 8, 8, 2025, 5.16, -0.20, 0, 0, 63.30, 71.35);
INSERT INTO `student` VALUES (2436, '2024080336', '李清航', '经济与管理学院', 8, 8, 20, 2024, 5.58, 0.42, 0, 0, 67.20, 70.65);
INSERT INTO `student` VALUES (2437, '2025090337', '杨逸涵', '人文社会科学学院', 9, 9, 9, 2025, 5.37, 0.54, 0, 0, 76.20, 68.10);
INSERT INTO `student` VALUES (2438, '2024090338', '徐子扬', '人文社会科学学院', 9, 9, 21, 2024, 9.24, 0.66, 0, 0, 70.20, 75.95);
INSERT INTO `student` VALUES (2439, '2023090339', '林依晨', '人文社会科学学院', 9, 9, 33, 2023, 6.72, -0.30, 0, 0, 73.80, 68.75);
INSERT INTO `student` VALUES (2440, '2022090340', '梁嘉宁', '人文社会科学学院', 9, 9, 45, 2022, 4.52, -0.52, 0, 0, 77.30, 67.55);
INSERT INTO `student` VALUES (2441, '2025090341', '王书萌', '人文社会科学学院', 9, 9, 9, 2025, 2.87, -0.64, 2, 1, 66.48, 62.85);
INSERT INTO `student` VALUES (2442, '2024090342', '赵向宇', '人文社会科学学院', 9, 9, 21, 2024, 5.03, 0.06, 0, 0, 71.10, 68.35);
INSERT INTO `student` VALUES (2443, '2023090343', '孙安言', '人文社会科学学院', 9, 9, 33, 2023, 9.07, 0.18, 0, 0, 74.70, 75.90);
INSERT INTO `student` VALUES (2444, '2022090344', '何闻怡', '人文社会科学学院', 9, 9, 45, 2022, 9.26, 0.30, 0, 0, 78.20, 74.70);
INSERT INTO `student` VALUES (2445, '2025090345', '宋知文', '人文社会科学学院', 9, 9, 9, 2025, 4.56, 0.42, 0, 0, 68.10, 70.00);
INSERT INTO `student` VALUES (2446, '2024090346', '张星卓', '人文社会科学学院', 9, 9, 21, 2024, 4.99, -0.52, 0, 0, 65.00, 69.30);
INSERT INTO `student` VALUES (2447, '2023090347', '黄若川', '人文社会科学学院', 9, 9, 33, 2023, 9.09, 0.36, 0, 0, 68.60, 76.85);
INSERT INTO `student` VALUES (2448, '2022090348', '胡可希', '人文社会科学学院', 9, 9, 45, 2022, 9.43, -0.30, 0, 0, 72.10, 75.65);
INSERT INTO `student` VALUES (2449, '2025090349', '郭思昕', '人文社会科学学院', 9, 9, 9, 2025, 8.34, -0.18, 0, 0, 69.00, 70.95);
INSERT INTO `student` VALUES (2450, '2024090350', '郑景霖', '人文社会科学学院', 9, 9, 21, 2024, 2.35, -1.44, 3, 1, 63.60, 64.05);
INSERT INTO `student` VALUES (2451, '2023090351', '刘明远', '人文社会科学学院', 9, 9, 33, 2023, 2.99, -1.28, 2, 1, 67.20, 63.05);
INSERT INTO `student` VALUES (2452, '2022090352', '周语轩', '人文社会科学学院', 9, 9, 45, 2022, 6.18, -0.52, 0, 0, 70.10, 70.40);
INSERT INTO `student` VALUES (2453, '2025090353', '朱一睿', '人文社会科学学院', 9, 9, 9, 2025, 7.64, -0.20, 0, 0, 69.90, 71.90);
INSERT INTO `student` VALUES (2454, '2024090354', '马沐彤', '人文社会科学学院', 9, 9, 21, 2024, 8.23, 0.42, 0, 0, 73.80, 71.20);
INSERT INTO `student` VALUES (2455, '2023090355', '谢泽诚', '人文社会科学学院', 9, 9, 33, 2023, 4.55, 0.54, 0, 0, 77.40, 70.20);
INSERT INTO `student` VALUES (2456, '2022090356', '陈清航', '人文社会科学学院', 9, 9, 45, 2022, 9.05, 0.08, 0, 0, 71.00, 77.55);
INSERT INTO `student` VALUES (2457, '2025090357', '吴逸涵', '人文社会科学学院', 9, 9, 9, 2025, 6.97, -0.30, 0, 0, 70.80, 72.85);
INSERT INTO `student` VALUES (2458, '2024090358', '高子扬', '人文社会科学学院', 9, 9, 21, 2024, 7.41, -0.52, 0, 0, 67.70, 72.15);
INSERT INTO `student` VALUES (2459, '2023090359', '罗依晨', '人文社会科学学院', 9, 9, 33, 2023, 8.17, -0.20, 0, 0, 71.30, 71.15);
INSERT INTO `student` VALUES (2460, '2022090360', '李嘉宁', '人文社会科学学院', 9, 9, 45, 2022, 4.87, 0.06, 0, 0, 64.90, 69.95);
INSERT INTO `student` VALUES (2461, '2025090361', '杨书萌', '人文社会科学学院', 9, 9, 9, 2025, 4.80, 0.18, 0, 0, 71.70, 67.60);
INSERT INTO `student` VALUES (2462, '2024090362', '徐向宇', '人文社会科学学院', 9, 9, 21, 2024, 5.12, 0.30, 0, 0, 75.60, 66.90);
INSERT INTO `student` VALUES (2463, '2023090363', '林安言', '人文社会科学学院', 9, 9, 33, 2023, 5.51, 0.42, 0, 0, 69.30, 65.90);
INSERT INTO `student` VALUES (2464, '2022090364', '梁闻怡', '人文社会科学学院', 9, 9, 45, 2022, 7.94, -0.52, 0, 0, 72.80, 70.90);
INSERT INTO `student` VALUES (2465, '2025090365', '王知文', '人文社会科学学院', 9, 9, 9, 2025, 6.86, -0.20, 0, 0, 72.60, 74.75);
INSERT INTO `student` VALUES (2466, '2024090366', '赵星卓', '人文社会科学学院', 9, 9, 21, 2024, 6.68, -0.30, 0, 0, 76.50, 74.05);
INSERT INTO `student` VALUES (2467, '2023090367', '孙若川', '人文社会科学学院', 9, 9, 33, 2023, 7.08, -0.18, 0, 0, 70.20, 73.05);
INSERT INTO `student` VALUES (2468, '2022090368', '何可希', '人文社会科学学院', 9, 9, 45, 2022, 7.40, -0.06, 0, 0, 73.70, 71.85);
INSERT INTO `student` VALUES (2469, '2025090369', '宋思昕', '人文社会科学学院', 9, 9, 9, 2025, 6.24, 0.06, 0, 0, 73.50, 67.15);
INSERT INTO `student` VALUES (2470, '2024090370', '张景霖', '人文社会科学学院', 9, 9, 21, 2024, 6.63, -0.52, 0, 0, 70.40, 75.00);
INSERT INTO `student` VALUES (2471, '2023090371', '黄明远', '人文社会科学学院', 9, 9, 33, 2023, 7.10, -0.20, 0, 0, 64.10, 74.00);
INSERT INTO `student` VALUES (2472, '2022090372', '胡语轩', '人文社会科学学院', 9, 9, 45, 2022, 5.01, 0.42, 0, 0, 67.60, 66.60);
INSERT INTO `student` VALUES (2473, '2025090373', '郭一睿', '人文社会科学学院', 9, 9, 9, 2025, 4.45, 0.54, 0, 0, 74.40, 61.90);
INSERT INTO `student` VALUES (2474, '2024090374', '郑沐彤', '人文社会科学学院', 9, 9, 21, 2024, 7.75, 0.66, 0, 0, 68.40, 69.75);
INSERT INTO `student` VALUES (2475, '2023090375', '刘泽诚', '人文社会科学学院', 9, 9, 33, 2023, 6.35, -0.30, 0, 0, 72.00, 74.95);
INSERT INTO `student` VALUES (2476, '2022090376', '周清航', '人文社会科学学院', 9, 9, 45, 2022, 6.61, -0.52, 0, 0, 75.50, 73.75);
INSERT INTO `student` VALUES (2477, '2025090377', '朱逸涵', '人文社会科学学院', 9, 9, 9, 2025, 5.44, -0.20, 0, 0, 75.30, 69.05);
INSERT INTO `student` VALUES (2478, '2025100378', '马子扬', '数学与统计学院', 10, 10, 10, 2025, 5.66, 0.06, 0, 0, 68.60, 67.70);
INSERT INTO `student` VALUES (2479, '2024100379', '谢依晨', '数学与统计学院', 10, 10, 22, 2024, 9.30, 0.18, 0, 0, 72.50, 75.55);
INSERT INTO `student` VALUES (2480, '2023100380', '陈嘉宁', '数学与统计学院', 10, 10, 34, 2023, 6.47, 0.30, 0, 0, 76.10, 74.55);
INSERT INTO `student` VALUES (2481, '2022100381', '吴书萌', '数学与统计学院', 10, 10, 46, 2022, 6.89, 0.42, 0, 0, 79.60, 73.35);
INSERT INTO `student` VALUES (2482, '2025100382', '高向宇', '数学与统计学院', 10, 10, 10, 2025, 5.70, -0.52, 0, 0, 62.50, 68.65);
INSERT INTO `student` VALUES (2483, '2024100383', '罗安言', '数学与统计学院', 10, 10, 22, 2024, 7.21, -0.20, 0, 0, 66.40, 70.30);
INSERT INTO `student` VALUES (2484, '2023100384', '李闻怡', '数学与统计学院', 10, 10, 34, 2023, 6.93, -0.30, 0, 0, 70.00, 69.30);
INSERT INTO `student` VALUES (2485, '2022100385', '杨知文', '数学与统计学院', 10, 10, 46, 2022, 4.73, -0.18, 0, 0, 70.60, 68.10);
INSERT INTO `student` VALUES (2486, '2025100386', '徐星卓', '数学与统计学院', 10, 10, 10, 2025, 4.86, -0.06, 0, 0, 70.40, 69.60);
INSERT INTO `student` VALUES (2487, '2024100387', '林若川', '数学与统计学院', 10, 10, 22, 2024, 5.27, 0.06, 0, 0, 74.30, 68.90);
INSERT INTO `student` VALUES (2488, '2023100388', '梁可希', '数学与统计学院', 10, 10, 34, 2023, 9.45, 0.64, 0, 0, 77.90, 76.45);
INSERT INTO `student` VALUES (2489, '2022100389', '王思昕', '数学与统计学院', 10, 10, 46, 2022, 9.57, -0.20, 0, 0, 71.50, 75.25);
INSERT INTO `student` VALUES (2490, '2025100390', '赵景霖', '数学与统计学院', 10, 10, 10, 2025, 4.84, 0.42, 0, 0, 71.30, 70.55);
INSERT INTO `student` VALUES (2491, '2024100391', '孙明远', '数学与统计学院', 10, 10, 22, 2024, 5.32, 0.54, 0, 0, 75.20, 69.85);
INSERT INTO `student` VALUES (2492, '2023100392', '何语轩', '数学与统计学院', 10, 10, 34, 2023, 8.95, 0.36, 0, 0, 78.80, 77.40);
INSERT INTO `student` VALUES (2493, '2022100393', '宋一睿', '数学与统计学院', 10, 10, 46, 2022, 9.24, 0.64, 0, 0, 72.40, 76.20);
INSERT INTO `student` VALUES (2494, '2025100394', '张沐彤', '数学与统计学院', 10, 10, 10, 2025, 5.77, -0.52, 0, 0, 65.20, 65.30);
INSERT INTO `student` VALUES (2495, '2024100395', '黄泽诚', '数学与统计学院', 10, 10, 22, 2024, 2.80, -0.80, 2, 1, 62.88, 64.60);
INSERT INTO `student` VALUES (2496, '2023100396', '胡清航', '数学与统计学院', 10, 10, 34, 2023, 3.32, -1.12, 2, 1, 62.80, 63.60);
INSERT INTO `student` VALUES (2497, '2022100397', '郭逸涵', '数学与统计学院', 10, 10, 46, 2022, 9.28, 0.36, 0, 0, 73.30, 77.15);
INSERT INTO `student` VALUES (2498, '2025100398', '郑子扬', '数学与统计学院', 10, 10, 10, 2025, 7.79, 0.30, 0, 0, 73.10, 72.45);
INSERT INTO `student` VALUES (2499, '2024100399', '刘依晨', '数学与统计学院', 10, 10, 22, 2024, 8.38, 0.42, 0, 0, 77.00, 71.75);
INSERT INTO `student` VALUES (2500, '2023100400', '周嘉宁', '数学与统计学院', 10, 10, 34, 2023, 4.86, -0.52, 0, 0, 70.70, 70.75);
INSERT INTO `student` VALUES (2501, '2022100401', '朱书萌', '数学与统计学院', 10, 10, 46, 2022, 8.88, 0.08, 0, 0, 74.20, 78.10);
INSERT INTO `student` VALUES (2502, '2025100402', '马向宇', '数学与统计学院', 10, 10, 10, 2025, 7.10, -0.30, 0, 0, 74.00, 73.40);
INSERT INTO `student` VALUES (2503, '2024100403', '谢安言', '数学与统计学院', 10, 10, 22, 2024, 7.66, -0.18, 0, 0, 77.90, 72.70);
INSERT INTO `student` VALUES (2504, '2023100404', '陈闻怡', '数学与统计学院', 10, 10, 34, 2023, 8.69, -0.06, 0, 0, 71.60, 71.70);
INSERT INTO `student` VALUES (2505, '2022100405', '吴知文', '数学与统计学院', 10, 10, 46, 2022, 2.47, -0.96, 3, 1, 64.32, 64.30);
INSERT INTO `student` VALUES (2506, '2025100406', '高星卓', '数学与统计学院', 10, 10, 10, 2025, 5.01, -0.52, 0, 0, 67.90, 68.15);
INSERT INTO `student` VALUES (2507, '2024100407', '罗若川', '数学与统计学院', 10, 10, 22, 2024, 5.41, -0.20, 0, 0, 61.90, 67.45);
INSERT INTO `student` VALUES (2508, '2023100408', '李可希', '数学与统计学院', 10, 10, 34, 2023, 7.88, 0.42, 0, 0, 65.50, 72.65);
INSERT INTO `student` VALUES (2509, '2022100409', '杨思昕', '数学与统计学院', 10, 10, 46, 2022, 8.40, 0.54, 0, 0, 76.00, 71.45);
INSERT INTO `student` VALUES (2510, '2025100410', '徐景霖', '数学与统计学院', 10, 10, 10, 2025, 7.03, 0.66, 0, 0, 75.80, 75.30);
INSERT INTO `student` VALUES (2511, '2024100411', '林明远', '数学与统计学院', 10, 10, 22, 2024, 6.90, -0.30, 0, 0, 69.80, 74.60);
INSERT INTO `student` VALUES (2512, '2023100412', '梁语轩', '数学与统计学院', 10, 10, 34, 2023, 7.27, -0.52, 0, 0, 73.40, 73.60);
INSERT INTO `student` VALUES (2513, '2022100413', '王一睿', '数学与统计学院', 10, 10, 46, 2022, 7.62, -0.20, 0, 0, 76.90, 72.40);
INSERT INTO `student` VALUES (2514, '2025100414', '赵沐彤', '数学与统计学院', 10, 10, 10, 2025, 6.42, 0.06, 0, 0, 76.70, 67.70);
INSERT INTO `student` VALUES (2515, '2024100415', '孙泽诚', '数学与统计学院', 10, 10, 22, 2024, 6.89, 0.18, 0, 0, 70.70, 75.55);
INSERT INTO `student` VALUES (2516, '2023100416', '何清航', '数学与统计学院', 10, 10, 34, 2023, 5.03, 0.30, 0, 0, 74.30, 68.35);
INSERT INTO `student` VALUES (2517, '2022100417', '宋逸涵', '数学与统计学院', 10, 10, 46, 2022, 5.31, 0.42, 0, 0, 77.80, 67.15);
INSERT INTO `student` VALUES (2518, '2025100418', '张子扬', '数学与统计学院', 10, 10, 10, 2025, 4.62, -0.52, 0, 0, 60.70, 62.45);
INSERT INTO `student` VALUES (2519, '2025110419', '黄依晨', '外国语学院', 11, 11, 11, 2025, 9.66, -0.20, 0, 0, 63.90, 75.85);
INSERT INTO `student` VALUES (2520, '2024110420', '胡嘉宁', '外国语学院', 11, 11, 23, 2024, 6.38, -0.30, 0, 0, 67.80, 75.15);
INSERT INTO `student` VALUES (2521, '2023110421', '郭书萌', '外国语学院', 11, 11, 35, 2023, 6.85, -0.18, 0, 0, 78.40, 74.15);
INSERT INTO `student` VALUES (2522, '2022110422', '郑向宇', '外国语学院', 11, 11, 47, 2022, 7.15, -0.06, 0, 0, 72.00, 72.95);
INSERT INTO `student` VALUES (2523, '2025110423', '刘安言', '外国语学院', 11, 11, 11, 2025, 5.82, 0.06, 0, 0, 71.80, 68.25);
INSERT INTO `student` VALUES (2524, '2024110424', '周闻怡', '外国语学院', 11, 11, 23, 2024, 9.66, 0.92, 0, 0, 75.70, 76.10);
INSERT INTO `student` VALUES (2525, '2023110425', '朱知文', '外国语学院', 11, 11, 35, 2023, 6.77, -0.20, 0, 0, 79.30, 75.10);
INSERT INTO `student` VALUES (2526, '2022110426', '马星卓', '外国语学院', 11, 11, 47, 2022, 7.11, 0.42, 0, 0, 72.90, 73.90);
INSERT INTO `student` VALUES (2527, '2025110427', '谢若川', '外国语学院', 11, 11, 11, 2025, 4.33, -0.64, 1, 0, 66.48, 63.00);
INSERT INTO `student` VALUES (2528, '2024110428', '陈可希', '外国语学院', 11, 11, 23, 2024, 7.48, 0.66, 0, 0, 76.60, 70.85);
INSERT INTO `student` VALUES (2529, '2023110429', '吴思昕', '外国语学院', 11, 11, 35, 2023, 7.16, -0.30, 0, 0, 70.30, 69.85);
INSERT INTO `student` VALUES (2530, '2022110430', '高景霖', '外国语学院', 11, 11, 47, 2022, 6.28, -0.52, 0, 0, 66.80, 74.85);
INSERT INTO `student` VALUES (2531, '2025110431', '罗明远', '外国语学院', 11, 11, 11, 2025, 5.12, -0.20, 0, 0, 66.60, 70.15);
INSERT INTO `student` VALUES (2532, '2024110432', '李语轩', '外国语学院', 11, 11, 23, 2024, 5.57, 0.06, 0, 0, 70.50, 69.45);
INSERT INTO `student` VALUES (2533, '2023110433', '杨一睿', '外国语学院', 11, 11, 35, 2023, 9.63, 0.64, 0, 0, 71.20, 77.00);
INSERT INTO `student` VALUES (2534, '2022110434', '徐沐彤', '外国语学院', 11, 11, 47, 2022, 9.30, 0.30, 0, 0, 74.70, 75.80);
INSERT INTO `student` VALUES (2535, '2025110435', '林泽诚', '外国语学院', 11, 11, 11, 2025, 5.12, 0.42, 0, 0, 74.50, 71.10);
INSERT INTO `student` VALUES (2536, '2024110436', '梁清航', '外国语学院', 11, 11, 23, 2024, 5.53, -0.52, 0, 0, 78.40, 70.40);
INSERT INTO `student` VALUES (2537, '2023110437', '王逸涵', '外国语学院', 11, 11, 35, 2023, 9.43, 0.36, 0, 0, 72.10, 77.95);
INSERT INTO `student` VALUES (2538, '2022110438', '赵子扬', '外国语学院', 11, 11, 47, 2022, 6.76, -0.30, 0, 0, 75.60, 70.55);
INSERT INTO `student` VALUES (2539, '2025110439', '孙依晨', '外国语学院', 11, 11, 11, 2025, 5.95, -0.18, 0, 0, 75.40, 65.85);
INSERT INTO `student` VALUES (2540, '2024110440', '何嘉宁', '外国语学院', 11, 11, 23, 2024, 3.21, -1.44, 2, 1, 68.64, 61.00);
INSERT INTO `student` VALUES (2541, '2023110441', '宋书萌', '外国语学院', 11, 11, 35, 2023, 5.11, 0.06, 0, 0, 73.00, 70.35);
INSERT INTO `student` VALUES (2542, '2022110442', '张向宇', '外国语学院', 11, 11, 47, 2022, 9.16, 0.36, 0, 0, 69.50, 77.70);
INSERT INTO `student` VALUES (2543, '2025110443', '黄安言', '外国语学院', 11, 11, 11, 2025, 8.28, -0.20, 0, 0, 69.30, 73.00);
INSERT INTO `student` VALUES (2544, '2024110444', '胡闻怡', '外国语学院', 11, 11, 23, 2024, 8.72, 0.42, 0, 0, 63.30, 72.30);
INSERT INTO `student` VALUES (2545, '2023110445', '郭知文', '外国语学院', 11, 11, 35, 2023, 5.09, 0.54, 0, 0, 73.90, 71.30);
INSERT INTO `student` VALUES (2546, '2022110446', '郑星卓', '外国语学院', 11, 11, 47, 2022, 9.20, 0.08, 0, 0, 77.40, 78.65);
INSERT INTO `student` VALUES (2547, '2025110447', '刘若川', '外国语学院', 11, 11, 11, 2025, 7.37, -0.30, 0, 0, 77.20, 73.95);
INSERT INTO `student` VALUES (2548, '2024110448', '周可希', '外国语学院', 11, 11, 23, 2024, 8.19, -0.52, 0, 0, 71.20, 73.25);
INSERT INTO `student` VALUES (2549, '2023110449', '朱思昕', '外国语学院', 11, 11, 35, 2023, 5.94, -0.20, 0, 0, 74.80, 66.05);
INSERT INTO `student` VALUES (2550, '2022110450', '马景霖', '外国语学院', 11, 11, 47, 2022, 3.01, -1.12, 2, 1, 60.72, 64.85);
INSERT INTO `student` VALUES (2551, '2025110451', '谢明远', '外国语学院', 11, 11, 11, 2025, 5.25, 0.18, 0, 0, 68.20, 68.70);
INSERT INTO `student` VALUES (2552, '2024110452', '陈语轩', '外国语学院', 11, 11, 23, 2024, 7.78, 0.30, 0, 0, 72.10, 74.20);
INSERT INTO `student` VALUES (2553, '2023110453', '吴一睿', '外国语学院', 11, 11, 35, 2023, 8.57, 0.42, 0, 0, 75.70, 73.20);
INSERT INTO `student` VALUES (2554, '2022110454', '高沐彤', '外国语学院', 11, 11, 47, 2022, 8.92, -0.52, 0, 0, 72.20, 72.00);
INSERT INTO `student` VALUES (2555, '2025110455', '罗泽诚', '外国语学院', 11, 11, 11, 2025, 7.38, -0.20, 0, 0, 62.10, 75.85);
INSERT INTO `student` VALUES (2556, '2024110456', '李清航', '外国语学院', 11, 11, 23, 2024, 7.14, -0.30, 0, 0, 66.00, 75.15);
INSERT INTO `student` VALUES (2557, '2023110457', '杨逸涵', '外国语学院', 11, 11, 35, 2023, 7.53, -0.18, 0, 0, 76.60, 74.15);
INSERT INTO `student` VALUES (2558, '2022110458', '徐子扬', '外国语学院', 11, 11, 47, 2022, 8.23, -0.06, 0, 0, 80.10, 72.95);
INSERT INTO `student` VALUES (2559, '2025110459', '林依晨', '外国语学院', 11, 11, 11, 2025, 6.68, 0.06, 0, 0, 70.00, 68.25);
INSERT INTO `student` VALUES (2560, '2025120460', '梁嘉宁', '航空航天学院', 12, 12, 12, 2025, 4.77, -0.52, 0, 0, 73.20, 69.25);
INSERT INTO `student` VALUES (2561, '2024120461', '王书萌', '航空航天学院', 12, 12, 24, 2024, 5.08, -0.20, 0, 0, 77.10, 68.55);
INSERT INTO `student` VALUES (2562, '2023120462', '赵向宇', '航空航天学院', 12, 12, 36, 2023, 5.42, 0.42, 0, 0, 70.80, 67.55);
INSERT INTO `student` VALUES (2563, '2022120463', '孙安言', '航空航天学院', 12, 12, 48, 2022, 7.91, 0.54, 0, 0, 74.30, 72.55);
INSERT INTO `student` VALUES (2564, '2025120464', '何闻怡', '航空航天学院', 12, 12, 12, 2025, 9.66, 0.92, 0, 0, 74.10, 76.40);
INSERT INTO `student` VALUES (2565, '2024120465', '宋知文', '航空航天学院', 12, 12, 24, 2024, 6.61, -0.30, 0, 0, 78.00, 75.70);
INSERT INTO `student` VALUES (2566, '2023120466', '张星卓', '航空航天学院', 12, 12, 36, 2023, 7.05, -0.52, 0, 0, 64.70, 74.70);
INSERT INTO `student` VALUES (2567, '2022120467', '黄若川', '航空航天学院', 12, 12, 48, 2022, 7.34, -0.20, 0, 0, 68.20, 73.50);
INSERT INTO `student` VALUES (2568, '2025120468', '胡可希', '航空航天学院', 12, 12, 12, 2025, 6.18, 0.06, 0, 0, 68.00, 68.80);
INSERT INTO `student` VALUES (2569, '2024120469', '郭思昕', '航空航天学院', 12, 12, 24, 2024, 9.41, 0.92, 0, 0, 78.90, 76.65);
INSERT INTO `student` VALUES (2570, '2023120470', '郑景霖', '航空航天学院', 12, 12, 36, 2023, 6.98, 0.30, 0, 0, 72.60, 75.65);
INSERT INTO `student` VALUES (2571, '2022120471', '刘明远', '航空航天学院', 12, 12, 48, 2022, 5.02, 0.42, 0, 0, 76.10, 68.25);
INSERT INTO `student` VALUES (2572, '2025120472', '周语轩', '航空航天学院', 12, 12, 12, 2025, 4.44, -0.52, 0, 0, 75.90, 63.55);
INSERT INTO `student` VALUES (2573, '2024120473', '朱一睿', '航空航天学院', 12, 12, 24, 2024, 7.63, -0.20, 0, 0, 69.90, 71.40);
INSERT INTO `student` VALUES (2574, '2023120474', '马沐彤', '航空航天学院', 12, 12, 36, 2023, 9.74, 0.92, 0, 0, 73.50, 76.60);
INSERT INTO `student` VALUES (2575, '2022120475', '谢泽诚', '航空航天学院', 12, 12, 48, 2022, 6.52, -0.18, 0, 0, 77.00, 75.40);
INSERT INTO `student` VALUES (2576, '2025120476', '陈清航', '航空航天学院', 12, 12, 12, 2025, 5.40, -0.06, 0, 0, 76.80, 70.70);
INSERT INTO `student` VALUES (2577, '2024120477', '吴逸涵', '航空航天学院', 12, 12, 24, 2024, 5.73, 0.06, 0, 0, 70.80, 70.00);
INSERT INTO `student` VALUES (2578, '2023120478', '高子扬', '航空航天学院', 12, 12, 36, 2023, 9.47, 0.64, 0, 0, 67.40, 77.55);
INSERT INTO `student` VALUES (2579, '2022120479', '罗依晨', '航空航天学院', 12, 12, 48, 2022, 9.66, 0.92, 0, 0, 70.90, 76.35);
INSERT INTO `student` VALUES (2580, '2025120480', '李嘉宁', '航空航天学院', 12, 12, 12, 2025, 5.45, 0.42, 0, 0, 70.70, 71.65);
INSERT INTO `student` VALUES (2581, '2024120481', '杨书萌', '航空航天学院', 12, 12, 24, 2024, 5.77, 0.54, 0, 0, 71.70, 70.95);
INSERT INTO `student` VALUES (2582, '2023120482', '徐向宇', '航空航天学院', 12, 12, 36, 2023, 7.34, 0.66, 0, 0, 75.30, 72.30);
INSERT INTO `student` VALUES (2583, '2022120483', '林安言', '航空航天学院', 12, 12, 48, 2022, 6.96, -0.30, 0, 0, 78.80, 71.10);
INSERT INTO `student` VALUES (2584, '2025120484', '梁闻怡', '航空航天学院', 12, 12, 12, 2025, 5.95, -0.52, 0, 0, 68.70, 66.40);
INSERT INTO `student` VALUES (2585, '2024120485', '王知文', '航空航天学院', 12, 12, 24, 2024, 5.04, -0.20, 0, 0, 72.60, 71.90);
INSERT INTO `student` VALUES (2586, '2023120486', '赵星卓', '航空航天学院', 12, 12, 36, 2023, 5.37, 0.06, 0, 0, 76.20, 70.90);
INSERT INTO `student` VALUES (2587, '2022120487', '孙若川', '航空航天学院', 12, 12, 48, 2022, 9.53, 0.36, 0, 0, 79.70, 78.25);
INSERT INTO `student` VALUES (2588, '2025120488', '何可希', '航空航天学院', 12, 12, 12, 2025, 8.71, 0.30, 0, 0, 69.60, 73.55);
INSERT INTO `student` VALUES (2589, '2024120489', '宋思昕', '航空航天学院', 12, 12, 24, 2024, 9.11, 0.42, 0, 0, 73.50, 72.85);
INSERT INTO `student` VALUES (2590, '2023120490', '张景霖', '航空航天学院', 12, 12, 36, 2023, 5.40, -0.52, 0, 0, 70.10, 71.85);
INSERT INTO `student` VALUES (2591, '2022120491', '黄明远', '航空航天学院', 12, 12, 48, 2022, 9.05, 0.08, 0, 0, 73.60, 79.20);
INSERT INTO `student` VALUES (2592, '2025120492', '胡语轩', '航空航天学院', 12, 12, 12, 2025, 8.13, -0.30, 0, 0, 63.50, 74.50);
INSERT INTO `student` VALUES (2593, '2024120493', '郭一睿', '航空航天学院', 12, 12, 24, 2024, 5.87, -0.18, 0, 0, 74.40, 67.60);
INSERT INTO `student` VALUES (2594, '2023120494', '郑沐彤', '航空航天学院', 12, 12, 36, 2023, 6.06, -0.06, 0, 0, 78.00, 66.60);
INSERT INTO `student` VALUES (2595, '2022120495', '刘泽诚', '航空航天学院', 12, 12, 48, 2022, 3.37, -0.80, 2, 1, 62.88, 61.00);
INSERT INTO `student` VALUES (2596, '2025120496', '周清航', '航空航天学院', 12, 12, 12, 2025, 7.60, -0.52, 0, 0, 71.40, 75.45);
INSERT INTO `student` VALUES (2597, '2024120497', '朱逸涵', '航空航天学院', 12, 12, 24, 2024, 8.11, -0.20, 0, 0, 75.30, 74.75);
INSERT INTO `student` VALUES (2598, '2023120498', '马子扬', '航空航天学院', 12, 12, 36, 2023, 8.57, 0.42, 0, 0, 78.90, 73.75);
INSERT INTO `student` VALUES (2599, '2022120499', '谢依晨', '航空航天学院', 12, 12, 48, 2022, 8.72, 0.54, 0, 0, 72.50, 72.55);
INSERT INTO `student` VALUES (2600, '2025120500', '陈嘉宁', '航空航天学院', 12, 12, 12, 2025, 7.59, -0.20, 0, 0, 72.30, 76.40);
INSERT INTO `student` VALUES (2601, 'S0002601', '赵梓元', NULL, NULL, NULL, NULL, NULL, 1.77, NULL, 0, 0, NULL, NULL);

-- ----------------------------
-- Table structure for student_enrollment
-- ----------------------------
DROP TABLE IF EXISTS `student_enrollment`;
CREATE TABLE `student_enrollment`  (
  `enrollment_id` bigint NOT NULL AUTO_INCREMENT,
  `student_id` bigint NOT NULL,
  `college_id` bigint NULL DEFAULT NULL,
  `major_id` bigint NULL DEFAULT NULL,
  `class_id` bigint NULL DEFAULT NULL,
  `grade_year` smallint NULL DEFAULT NULL,
  `start_term_id` bigint NULL DEFAULT NULL,
  `end_term_id` bigint NULL DEFAULT NULL,
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'active',
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`enrollment_id`) USING BTREE,
  INDEX `idx_student_enrollment_student`(`student_id` ASC) USING BTREE,
  INDEX `idx_student_enrollment_status`(`status` ASC) USING BTREE,
  INDEX `idx_student_enrollment_college_major_class`(`college_id` ASC, `major_id` ASC, `class_id` ASC) USING BTREE,
  INDEX `fk_student_enrollment_major`(`major_id` ASC) USING BTREE,
  INDEX `fk_student_enrollment_class`(`class_id` ASC) USING BTREE,
  INDEX `fk_student_enrollment_start_term`(`start_term_id` ASC) USING BTREE,
  INDEX `fk_student_enrollment_end_term`(`end_term_id` ASC) USING BTREE,
  CONSTRAINT `fk_student_enrollment_class` FOREIGN KEY (`class_id`) REFERENCES `dim_class` (`class_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_student_enrollment_college` FOREIGN KEY (`college_id`) REFERENCES `dim_college` (`college_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_student_enrollment_end_term` FOREIGN KEY (`end_term_id`) REFERENCES `dim_term` (`term_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_student_enrollment_major` FOREIGN KEY (`major_id`) REFERENCES `dim_major` (`major_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_student_enrollment_start_term` FOREIGN KEY (`start_term_id`) REFERENCES `dim_term` (`term_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_student_enrollment_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1535 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Student enrollment history' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of student_enrollment
-- ----------------------------
INSERT INTO `student_enrollment` VALUES (1024, 2101, 1, 1, 1, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1025, 2102, 1, 1, 13, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1026, 2103, 1, 1, 25, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1027, 2104, 1, 1, 37, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1028, 2105, 1, 1, 1, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1029, 2106, 1, 1, 13, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1030, 2107, 1, 1, 25, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1031, 2108, 1, 1, 37, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1032, 2109, 1, 1, 1, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1033, 2110, 1, 1, 13, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1034, 2111, 1, 1, 25, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1035, 2112, 1, 1, 37, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1036, 2113, 1, 1, 1, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1037, 2114, 1, 1, 13, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1038, 2115, 1, 1, 25, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1039, 2116, 1, 1, 37, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1040, 2117, 1, 1, 1, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1041, 2118, 1, 1, 13, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1042, 2119, 1, 1, 25, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1043, 2120, 1, 1, 37, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1044, 2121, 1, 1, 1, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1045, 2122, 1, 1, 13, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1046, 2123, 1, 1, 25, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1047, 2124, 1, 1, 37, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1048, 2125, 1, 1, 1, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1049, 2126, 1, 1, 13, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1050, 2127, 1, 1, 25, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1051, 2128, 1, 1, 37, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1052, 2129, 1, 1, 1, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1053, 2130, 1, 1, 13, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1054, 2131, 1, 1, 25, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1055, 2132, 1, 1, 37, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1056, 2133, 1, 1, 1, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1057, 2134, 1, 1, 13, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1058, 2135, 1, 1, 25, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1059, 2136, 1, 1, 37, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1060, 2137, 1, 1, 1, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1061, 2138, 1, 1, 13, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1062, 2139, 1, 1, 25, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1063, 2140, 1, 1, 37, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1064, 2141, 1, 1, 1, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1065, 2142, 1, 1, 13, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1066, 2143, 2, 2, 2, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1067, 2144, 2, 2, 14, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1068, 2145, 2, 2, 26, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1069, 2146, 2, 2, 38, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1070, 2147, 2, 2, 2, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1071, 2148, 2, 2, 14, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1072, 2149, 2, 2, 26, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1073, 2150, 2, 2, 38, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1074, 2151, 2, 2, 2, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1075, 2152, 2, 2, 14, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1076, 2153, 2, 2, 26, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1077, 2154, 2, 2, 38, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1078, 2155, 2, 2, 2, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1079, 2156, 2, 2, 14, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1080, 2157, 2, 2, 26, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1081, 2158, 2, 2, 38, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1082, 2159, 2, 2, 2, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1083, 2160, 2, 2, 14, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1084, 2161, 2, 2, 26, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1085, 2162, 2, 2, 38, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1086, 2163, 2, 2, 2, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1087, 2164, 2, 2, 14, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1088, 2165, 2, 2, 26, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1089, 2166, 2, 2, 38, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1090, 2167, 2, 2, 2, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1091, 2168, 2, 2, 14, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1092, 2169, 2, 2, 26, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1093, 2170, 2, 2, 38, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1094, 2171, 2, 2, 2, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1095, 2172, 2, 2, 14, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1096, 2173, 2, 2, 26, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1097, 2174, 2, 2, 38, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1098, 2175, 2, 2, 2, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1099, 2176, 2, 2, 14, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1100, 2177, 2, 2, 26, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1101, 2178, 2, 2, 38, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1102, 2179, 2, 2, 2, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1103, 2180, 2, 2, 14, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1104, 2181, 2, 2, 26, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1105, 2182, 2, 2, 38, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1106, 2183, 2, 2, 2, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1107, 2184, 2, 2, 14, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1108, 2185, 3, 3, 3, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1109, 2186, 3, 3, 15, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1110, 2187, 3, 3, 27, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1111, 2188, 3, 3, 39, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1112, 2189, 3, 3, 3, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1113, 2190, 3, 3, 15, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1114, 2191, 3, 3, 27, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1115, 2192, 3, 3, 39, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1116, 2193, 3, 3, 3, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1117, 2194, 3, 3, 15, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1118, 2195, 3, 3, 27, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1119, 2196, 3, 3, 39, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1120, 2197, 3, 3, 3, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1121, 2198, 3, 3, 15, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1122, 2199, 3, 3, 27, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1123, 2200, 3, 3, 39, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1124, 2201, 3, 3, 3, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1125, 2202, 3, 3, 15, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1126, 2203, 3, 3, 27, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1127, 2204, 3, 3, 39, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1128, 2205, 3, 3, 3, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1129, 2206, 3, 3, 15, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1130, 2207, 3, 3, 27, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1131, 2208, 3, 3, 39, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1132, 2209, 3, 3, 3, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1133, 2210, 3, 3, 15, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1134, 2211, 3, 3, 27, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1135, 2212, 3, 3, 39, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1136, 2213, 3, 3, 3, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1137, 2214, 3, 3, 15, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1138, 2215, 3, 3, 27, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1139, 2216, 3, 3, 39, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1140, 2217, 3, 3, 3, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1141, 2218, 3, 3, 15, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1142, 2219, 3, 3, 27, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1143, 2220, 3, 3, 39, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1144, 2221, 3, 3, 3, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1145, 2222, 3, 3, 15, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1146, 2223, 3, 3, 27, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1147, 2224, 3, 3, 39, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1148, 2225, 3, 3, 3, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1149, 2226, 3, 3, 15, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1150, 2227, 4, 4, 4, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1151, 2228, 4, 4, 16, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1152, 2229, 4, 4, 28, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1153, 2230, 4, 4, 40, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1154, 2231, 4, 4, 4, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1155, 2232, 4, 4, 16, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1156, 2233, 4, 4, 28, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1157, 2234, 4, 4, 40, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1158, 2235, 4, 4, 4, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1159, 2236, 4, 4, 16, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1160, 2237, 4, 4, 28, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1161, 2238, 4, 4, 40, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1162, 2239, 4, 4, 4, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1163, 2240, 4, 4, 16, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1164, 2241, 4, 4, 28, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1165, 2242, 4, 4, 40, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1166, 2243, 4, 4, 4, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1167, 2244, 4, 4, 16, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1168, 2245, 4, 4, 28, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1169, 2246, 4, 4, 40, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1170, 2247, 4, 4, 4, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1171, 2248, 4, 4, 16, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1172, 2249, 4, 4, 28, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1173, 2250, 4, 4, 40, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1174, 2251, 4, 4, 4, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1175, 2252, 4, 4, 16, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1176, 2253, 4, 4, 28, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1177, 2254, 4, 4, 40, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1178, 2255, 4, 4, 4, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1179, 2256, 4, 4, 16, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1180, 2257, 4, 4, 28, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1181, 2258, 4, 4, 40, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1182, 2259, 4, 4, 4, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1183, 2260, 4, 4, 16, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1184, 2261, 4, 4, 28, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1185, 2262, 4, 4, 40, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1186, 2263, 4, 4, 4, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1187, 2264, 4, 4, 16, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1188, 2265, 4, 4, 28, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1189, 2266, 4, 4, 40, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1190, 2267, 4, 4, 4, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1191, 2268, 4, 4, 16, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1192, 2269, 5, 5, 5, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1193, 2270, 5, 5, 17, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1194, 2271, 5, 5, 29, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1195, 2272, 5, 5, 41, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1196, 2273, 5, 5, 5, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1197, 2274, 5, 5, 17, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1198, 2275, 5, 5, 29, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1199, 2276, 5, 5, 41, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1200, 2277, 5, 5, 5, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1201, 2278, 5, 5, 17, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1202, 2279, 5, 5, 29, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1203, 2280, 5, 5, 41, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1204, 2281, 5, 5, 5, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1205, 2282, 5, 5, 17, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1206, 2283, 5, 5, 29, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1207, 2284, 5, 5, 41, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1208, 2285, 5, 5, 5, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1209, 2286, 5, 5, 17, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1210, 2287, 5, 5, 29, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1211, 2288, 5, 5, 41, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1212, 2289, 5, 5, 5, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1213, 2290, 5, 5, 17, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1214, 2291, 5, 5, 29, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1215, 2292, 5, 5, 41, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1216, 2293, 5, 5, 5, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1217, 2294, 5, 5, 17, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1218, 2295, 5, 5, 29, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1219, 2296, 5, 5, 41, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1220, 2297, 5, 5, 5, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1221, 2298, 5, 5, 17, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1222, 2299, 5, 5, 29, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1223, 2300, 5, 5, 41, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1224, 2301, 5, 5, 5, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1225, 2302, 5, 5, 17, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1226, 2303, 5, 5, 29, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1227, 2304, 5, 5, 41, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1228, 2305, 5, 5, 5, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1229, 2306, 5, 5, 17, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1230, 2307, 5, 5, 29, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1231, 2308, 5, 5, 41, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1232, 2309, 5, 5, 5, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1233, 2310, 5, 5, 17, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1234, 2311, 6, 6, 6, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1235, 2312, 6, 6, 18, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1236, 2313, 6, 6, 30, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1237, 2314, 6, 6, 42, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1238, 2315, 6, 6, 6, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1239, 2316, 6, 6, 18, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1240, 2317, 6, 6, 30, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1241, 2318, 6, 6, 42, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1242, 2319, 6, 6, 6, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1243, 2320, 6, 6, 18, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1244, 2321, 6, 6, 30, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1245, 2322, 6, 6, 42, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1246, 2323, 6, 6, 6, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1247, 2324, 6, 6, 18, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1248, 2325, 6, 6, 30, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1249, 2326, 6, 6, 42, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1250, 2327, 6, 6, 6, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1251, 2328, 6, 6, 18, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1252, 2329, 6, 6, 30, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1253, 2330, 6, 6, 42, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1254, 2331, 6, 6, 6, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1255, 2332, 6, 6, 18, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1256, 2333, 6, 6, 30, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1257, 2334, 6, 6, 42, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1258, 2335, 6, 6, 6, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1259, 2336, 6, 6, 18, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1260, 2337, 6, 6, 30, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1261, 2338, 6, 6, 42, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1262, 2339, 6, 6, 6, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1263, 2340, 6, 6, 18, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1264, 2341, 6, 6, 30, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1265, 2342, 6, 6, 42, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1266, 2343, 6, 6, 6, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1267, 2344, 6, 6, 18, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1268, 2345, 6, 6, 30, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1269, 2346, 6, 6, 42, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1270, 2347, 6, 6, 6, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1271, 2348, 6, 6, 18, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1272, 2349, 6, 6, 30, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1273, 2350, 6, 6, 42, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1274, 2351, 6, 6, 6, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1275, 2352, 6, 6, 18, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1276, 2353, 7, 7, 7, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1277, 2354, 7, 7, 19, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1278, 2355, 7, 7, 31, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1279, 2356, 7, 7, 43, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1280, 2357, 7, 7, 7, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1281, 2358, 7, 7, 19, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1282, 2359, 7, 7, 31, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1283, 2360, 7, 7, 43, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1284, 2361, 7, 7, 7, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1285, 2362, 7, 7, 19, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1286, 2363, 7, 7, 31, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1287, 2364, 7, 7, 43, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1288, 2365, 7, 7, 7, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1289, 2366, 7, 7, 19, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1290, 2367, 7, 7, 31, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1291, 2368, 7, 7, 43, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1292, 2369, 7, 7, 7, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1293, 2370, 7, 7, 19, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1294, 2371, 7, 7, 31, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1295, 2372, 7, 7, 43, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1296, 2373, 7, 7, 7, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1297, 2374, 7, 7, 19, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1298, 2375, 7, 7, 31, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1299, 2376, 7, 7, 43, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1300, 2377, 7, 7, 7, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1301, 2378, 7, 7, 19, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1302, 2379, 7, 7, 31, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1303, 2380, 7, 7, 43, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1304, 2381, 7, 7, 7, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1305, 2382, 7, 7, 19, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1306, 2383, 7, 7, 31, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1307, 2384, 7, 7, 43, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1308, 2385, 7, 7, 7, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1309, 2386, 7, 7, 19, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1310, 2387, 7, 7, 31, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1311, 2388, 7, 7, 43, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1312, 2389, 7, 7, 7, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1313, 2390, 7, 7, 19, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1314, 2391, 7, 7, 31, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1315, 2392, 7, 7, 43, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1316, 2393, 7, 7, 7, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1317, 2394, 7, 7, 19, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1318, 2395, 8, 8, 8, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1319, 2396, 8, 8, 20, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1320, 2397, 8, 8, 32, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1321, 2398, 8, 8, 44, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1322, 2399, 8, 8, 8, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1323, 2400, 8, 8, 20, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1324, 2401, 8, 8, 32, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1325, 2402, 8, 8, 44, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1326, 2403, 8, 8, 8, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1327, 2404, 8, 8, 20, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1328, 2405, 8, 8, 32, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1329, 2406, 8, 8, 44, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1330, 2407, 8, 8, 8, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1331, 2408, 8, 8, 20, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1332, 2409, 8, 8, 32, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1333, 2410, 8, 8, 44, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1334, 2411, 8, 8, 8, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1335, 2412, 8, 8, 20, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1336, 2413, 8, 8, 32, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1337, 2414, 8, 8, 44, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1338, 2415, 8, 8, 8, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1339, 2416, 8, 8, 20, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1340, 2417, 8, 8, 32, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1341, 2418, 8, 8, 44, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1342, 2419, 8, 8, 8, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1343, 2420, 8, 8, 20, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1344, 2421, 8, 8, 32, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1345, 2422, 8, 8, 44, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1346, 2423, 8, 8, 8, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1347, 2424, 8, 8, 20, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1348, 2425, 8, 8, 32, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1349, 2426, 8, 8, 44, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1350, 2427, 8, 8, 8, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1351, 2428, 8, 8, 20, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1352, 2429, 8, 8, 32, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1353, 2430, 8, 8, 44, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1354, 2431, 8, 8, 8, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1355, 2432, 8, 8, 20, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1356, 2433, 8, 8, 32, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1357, 2434, 8, 8, 44, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1358, 2435, 8, 8, 8, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1359, 2436, 8, 8, 20, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1360, 2437, 9, 9, 9, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1361, 2438, 9, 9, 21, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1362, 2439, 9, 9, 33, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1363, 2440, 9, 9, 45, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1364, 2441, 9, 9, 9, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1365, 2442, 9, 9, 21, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1366, 2443, 9, 9, 33, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1367, 2444, 9, 9, 45, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1368, 2445, 9, 9, 9, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1369, 2446, 9, 9, 21, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1370, 2447, 9, 9, 33, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1371, 2448, 9, 9, 45, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1372, 2449, 9, 9, 9, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1373, 2450, 9, 9, 21, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1374, 2451, 9, 9, 33, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1375, 2452, 9, 9, 45, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1376, 2453, 9, 9, 9, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1377, 2454, 9, 9, 21, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1378, 2455, 9, 9, 33, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1379, 2456, 9, 9, 45, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1380, 2457, 9, 9, 9, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1381, 2458, 9, 9, 21, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1382, 2459, 9, 9, 33, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1383, 2460, 9, 9, 45, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1384, 2461, 9, 9, 9, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1385, 2462, 9, 9, 21, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1386, 2463, 9, 9, 33, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1387, 2464, 9, 9, 45, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1388, 2465, 9, 9, 9, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1389, 2466, 9, 9, 21, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1390, 2467, 9, 9, 33, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1391, 2468, 9, 9, 45, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1392, 2469, 9, 9, 9, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1393, 2470, 9, 9, 21, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1394, 2471, 9, 9, 33, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1395, 2472, 9, 9, 45, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1396, 2473, 9, 9, 9, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1397, 2474, 9, 9, 21, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1398, 2475, 9, 9, 33, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1399, 2476, 9, 9, 45, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1400, 2477, 9, 9, 9, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1401, 2478, 10, 10, 10, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1402, 2479, 10, 10, 22, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1403, 2480, 10, 10, 34, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1404, 2481, 10, 10, 46, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1405, 2482, 10, 10, 10, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1406, 2483, 10, 10, 22, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1407, 2484, 10, 10, 34, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1408, 2485, 10, 10, 46, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1409, 2486, 10, 10, 10, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1410, 2487, 10, 10, 22, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1411, 2488, 10, 10, 34, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1412, 2489, 10, 10, 46, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1413, 2490, 10, 10, 10, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1414, 2491, 10, 10, 22, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1415, 2492, 10, 10, 34, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1416, 2493, 10, 10, 46, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1417, 2494, 10, 10, 10, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1418, 2495, 10, 10, 22, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1419, 2496, 10, 10, 34, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1420, 2497, 10, 10, 46, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1421, 2498, 10, 10, 10, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1422, 2499, 10, 10, 22, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1423, 2500, 10, 10, 34, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1424, 2501, 10, 10, 46, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1425, 2502, 10, 10, 10, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1426, 2503, 10, 10, 22, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1427, 2504, 10, 10, 34, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1428, 2505, 10, 10, 46, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1429, 2506, 10, 10, 10, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1430, 2507, 10, 10, 22, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1431, 2508, 10, 10, 34, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1432, 2509, 10, 10, 46, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1433, 2510, 10, 10, 10, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1434, 2511, 10, 10, 22, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1435, 2512, 10, 10, 34, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1436, 2513, 10, 10, 46, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1437, 2514, 10, 10, 10, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1438, 2515, 10, 10, 22, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1439, 2516, 10, 10, 34, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1440, 2517, 10, 10, 46, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1441, 2518, 10, 10, 10, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1442, 2519, 11, 11, 11, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1443, 2520, 11, 11, 23, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1444, 2521, 11, 11, 35, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1445, 2522, 11, 11, 47, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1446, 2523, 11, 11, 11, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1447, 2524, 11, 11, 23, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1448, 2525, 11, 11, 35, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1449, 2526, 11, 11, 47, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1450, 2527, 11, 11, 11, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1451, 2528, 11, 11, 23, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1452, 2529, 11, 11, 35, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1453, 2530, 11, 11, 47, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1454, 2531, 11, 11, 11, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1455, 2532, 11, 11, 23, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1456, 2533, 11, 11, 35, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1457, 2534, 11, 11, 47, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1458, 2535, 11, 11, 11, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1459, 2536, 11, 11, 23, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1460, 2537, 11, 11, 35, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1461, 2538, 11, 11, 47, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1462, 2539, 11, 11, 11, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1463, 2540, 11, 11, 23, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1464, 2541, 11, 11, 35, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1465, 2542, 11, 11, 47, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1466, 2543, 11, 11, 11, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1467, 2544, 11, 11, 23, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1468, 2545, 11, 11, 35, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1469, 2546, 11, 11, 47, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1470, 2547, 11, 11, 11, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1471, 2548, 11, 11, 23, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1472, 2549, 11, 11, 35, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1473, 2550, 11, 11, 47, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1474, 2551, 11, 11, 11, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1475, 2552, 11, 11, 23, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1476, 2553, 11, 11, 35, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1477, 2554, 11, 11, 47, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1478, 2555, 11, 11, 11, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1479, 2556, 11, 11, 23, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1480, 2557, 11, 11, 35, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1481, 2558, 11, 11, 47, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1482, 2559, 11, 11, 11, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1483, 2560, 12, 12, 12, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1484, 2561, 12, 12, 24, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1485, 2562, 12, 12, 36, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1486, 2563, 12, 12, 48, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1487, 2564, 12, 12, 12, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1488, 2565, 12, 12, 24, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1489, 2566, 12, 12, 36, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1490, 2567, 12, 12, 48, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1491, 2568, 12, 12, 12, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1492, 2569, 12, 12, 24, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1493, 2570, 12, 12, 36, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1494, 2571, 12, 12, 48, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1495, 2572, 12, 12, 12, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1496, 2573, 12, 12, 24, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1497, 2574, 12, 12, 36, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1498, 2575, 12, 12, 48, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1499, 2576, 12, 12, 12, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1500, 2577, 12, 12, 24, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1501, 2578, 12, 12, 36, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1502, 2579, 12, 12, 48, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1503, 2580, 12, 12, 12, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1504, 2581, 12, 12, 24, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1505, 2582, 12, 12, 36, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1506, 2583, 12, 12, 48, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1507, 2584, 12, 12, 12, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1508, 2585, 12, 12, 24, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1509, 2586, 12, 12, 36, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1510, 2587, 12, 12, 48, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1511, 2588, 12, 12, 12, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1512, 2589, 12, 12, 24, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1513, 2590, 12, 12, 36, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1514, 2591, 12, 12, 48, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1515, 2592, 12, 12, 12, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1516, 2593, 12, 12, 24, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1517, 2594, 12, 12, 36, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1518, 2595, 12, 12, 48, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1519, 2596, 12, 12, 12, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1520, 2597, 12, 12, 24, 2024, 2, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1521, 2598, 12, 12, 36, 2023, 1, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1522, 2599, 12, 12, 48, 2022, NULL, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `student_enrollment` VALUES (1523, 2600, 12, 12, 12, 2025, 4, NULL, 'active', '2026-03-18 11:04:01', '2026-03-18 11:04:01');

-- ----------------------------
-- Table structure for student_portrait
-- ----------------------------
DROP TABLE IF EXISTS `student_portrait`;
CREATE TABLE `student_portrait`  (
  `portrait_id` bigint NOT NULL AUTO_INCREMENT,
  `student_id` bigint NOT NULL,
  `learning_index` decimal(6, 2) NULL DEFAULT NULL,
  `cumulative_avg_score` decimal(5, 2) NULL DEFAULT NULL,
  `cumulative_gpa` decimal(4, 2) NULL DEFAULT NULL,
  `total_credits` decimal(6, 2) NULL DEFAULT NULL,
  `passed_credits` decimal(6, 2) NULL DEFAULT NULL,
  `failed_course_count` int NULL DEFAULT NULL,
  `risk_level` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `portrait_json` json NULL,
  `snapshot_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`portrait_id`) USING BTREE,
  UNIQUE INDEX `uq_student_portrait_student`(`student_id` ASC) USING BTREE,
  INDEX `idx_student_portrait_risk`(`risk_level` ASC) USING BTREE,
  CONSTRAINT `fk_student_portrait_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1025 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Student portrait snapshot' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student_portrait
-- ----------------------------

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '??ID',
  `menu_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '????',
  `menu_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '????',
  `route_path` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '????',
  `sort_no` int NOT NULL DEFAULT 0 COMMENT '??',
  `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '????',
  PRIMARY KEY (`menu_id`) USING BTREE,
  UNIQUE INDEX `uq_sys_menu_code`(`menu_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '?????' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, 'USER_MANAGEMENT', '用户管理', '/admin/user', 1, 1);
INSERT INTO `sys_menu` VALUES (2, 'AI_ASSISTANT', 'AI助理教学', '/ai-assistant', 2, 1);
INSERT INTO `sys_menu` VALUES (3, 'ONLINE_LEARNING', '在线学习', '/online-learning', 3, 1);
INSERT INTO `sys_menu` VALUES (4, 'PERSONAL_CENTER', '个人中心', '/personal-center', 4, 1);
INSERT INTO `sys_menu` VALUES (5, 'COURSE_MANAGEMENT', '课程管理', '/course-management', 5, 1);
INSERT INTO `sys_menu` VALUES (6, 'LIVE_SESSION', '直播管理', '/live-session', 6, 1);
INSERT INTO `sys_menu` VALUES (7, 'COURSE_VISIT', '学习统计', '/course-visit', 7, 1);

-- ----------------------------
-- Table structure for sys_menu_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu_permission`;
CREATE TABLE `sys_menu_permission`  (
  `menu_id` bigint NOT NULL COMMENT '??ID',
  `perm_id` bigint NOT NULL COMMENT '??ID',
  PRIMARY KEY (`menu_id`, `perm_id`) USING BTREE,
  INDEX `idx_sys_menu_permission_perm_id`(`perm_id` ASC) USING BTREE,
  CONSTRAINT `fk_sys_menu_permission_menu` FOREIGN KEY (`menu_id`) REFERENCES `sys_menu` (`menu_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_sys_menu_permission_perm` FOREIGN KEY (`perm_id`) REFERENCES `sys_permission` (`perm_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '??-?????' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu_permission
-- ----------------------------
INSERT INTO `sys_menu_permission` VALUES (1, 101);
INSERT INTO `sys_menu_permission` VALUES (1, 102);
INSERT INTO `sys_menu_permission` VALUES (1, 103);
INSERT INTO `sys_menu_permission` VALUES (2, 201);
INSERT INTO `sys_menu_permission` VALUES (3, 202);
INSERT INTO `sys_menu_permission` VALUES (4, 203);
INSERT INTO `sys_menu_permission` VALUES (5, 301);
INSERT INTO `sys_menu_permission` VALUES (5, 302);
INSERT INTO `sys_menu_permission` VALUES (6, 303);
INSERT INTO `sys_menu_permission` VALUES (6, 304);
INSERT INTO `sys_menu_permission` VALUES (7, 305);

-- ----------------------------
-- Table structure for sys_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission`  (
  `perm_id` bigint NOT NULL AUTO_INCREMENT COMMENT '??ID',
  `perm_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '????',
  `perm_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '????',
  `resource_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '?????api/button',
  `resource_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '?????????',
  `http_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'HTTP??',
  `rule_json` json NULL COMMENT '??????????role??',
  `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '????',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '??',
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  PRIMARY KEY (`perm_id`) USING BTREE,
  UNIQUE INDEX `uq_sys_permission_code`(`perm_code` ASC) USING BTREE,
  INDEX `idx_sys_permission_enabled`(`enabled` ASC) USING BTREE,
  CONSTRAINT `ck_sys_permission_enabled` CHECK (`enabled` in (0,1)),
  CONSTRAINT `ck_sys_permission_resource_type` CHECK (`resource_type` in (_utf8mb4'api',_utf8mb4'button'))
) ENGINE = InnoDB AUTO_INCREMENT = 306 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '???????' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_permission
-- ----------------------------
INSERT INTO `sys_permission` VALUES (101, 'USER_QUERY', '查询用户列表', 'api', '/api/user/list', 'GET', NULL, 1, '管理员查询学生/教师列表', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `sys_permission` VALUES (102, 'USER_DETAIL', '查看用户详情', 'api', '/api/user/detail', 'GET', NULL, 1, '管理员查看单个用户详情', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `sys_permission` VALUES (103, 'USER_ROLE_UPDATE', '修改用户角色', 'api', '/api/user/updateRole', 'PUT', '{\"field\": \"role\", \"allowedValues\": [\"student\", \"teacher\"]}', 1, '管理员可修改 student / teacher', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `sys_permission` VALUES (201, 'AI_ASSISTANT_USE', '使用AI助理教学', 'api', '/api/ai/chat', 'POST', NULL, 1, '使用 AI 助理教学', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `sys_permission` VALUES (202, 'ONLINE_LEARNING_VIEW', '查看在线学习', 'api', '/api/course/online', 'GET', NULL, 1, '查看在线学习课程', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `sys_permission` VALUES (203, 'PERSONAL_CENTER_VIEW', '查看个人中心', 'api', '/api/user/profile', 'GET', NULL, 1, '查看个人中心', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `sys_permission` VALUES (301, 'COURSE_MANAGEMENT_VIEW', '查看课程管理', 'api', '/api/course/listByTeacher', 'GET', '{\"scope\": \"self\"}', 1, '教师查看自己的课程', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `sys_permission` VALUES (302, 'COURSE_MANAGEMENT_EDIT', '编辑课程', 'api', '/api/course/save', 'POST', '{\"scope\": \"self\"}', 1, '教师维护自己的课程', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `sys_permission` VALUES (303, 'LIVE_SESSION_VIEW', '查看直播管理', 'api', '/api/liveSession/listByTeacher', 'GET', '{\"scope\": \"self\"}', 1, '教师查看自己的直播', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `sys_permission` VALUES (304, 'LIVE_SESSION_EDIT', '编辑直播课次', 'api', '/api/liveSession/save', 'POST', '{\"scope\": \"self\"}', 1, '教师维护自己的直播课次', '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `sys_permission` VALUES (305, 'COURSE_VISIT_VIEW', '查看学习统计', 'api', '/api/coursevisit/list', 'GET', '{\"scope\": \"self_course\"}', 1, '教师查看自己课程的学习统计', '2026-03-18 11:04:01', '2026-03-18 11:04:01');

-- ----------------------------
-- Table structure for teacher
-- ----------------------------
DROP TABLE IF EXISTS `teacher`;
CREATE TABLE `teacher`  (
  `teacher_id` bigint NOT NULL COMMENT '??ID??user.id??',
  `teacher_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '????',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '??????????',
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '??',
  PRIMARY KEY (`teacher_id`) USING BTREE,
  UNIQUE INDEX `uq_teacher_teacher_no`(`teacher_no` ASC) USING BTREE,
  CONSTRAINT `fk_teacher_user` FOREIGN KEY (`teacher_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '?????' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of teacher
-- ----------------------------
INSERT INTO `teacher` VALUES (1101, 'T2026001', '黄彦钰', '教授');
INSERT INTO `teacher` VALUES (1102, 'T2026002', '高雨博', '副教授');
INSERT INTO `teacher` VALUES (1103, 'T2026003', '宋可涵', '副教授');
INSERT INTO `teacher` VALUES (1104, 'T2026004', '陈书萌', '副教授');
INSERT INTO `teacher` VALUES (1105, 'T2026005', '孙知睿', '讲师');
INSERT INTO `teacher` VALUES (1106, 'T2026006', '马泽晨', '讲师');
INSERT INTO `teacher` VALUES (1107, 'T2026007', '王嘉宁', '讲师');
INSERT INTO `teacher` VALUES (1108, 'T2026008', '周向扬', '讲师');
INSERT INTO `teacher` VALUES (1109, 'T2026009', '林安怡', '助教');
INSERT INTO `teacher` VALUES (1110, 'T2026010', '郑景彤', '助教');
INSERT INTO `teacher` VALUES (1111, 'T2026011', '杨亦希', '教授');
INSERT INTO `teacher` VALUES (1112, 'T2026012', '胡若婷', '副教授');
INSERT INTO `teacher` VALUES (1113, 'T2026013', '罗星霖', '副教授');
INSERT INTO `teacher` VALUES (1114, 'T2026014', '张明轩', '副教授');
INSERT INTO `teacher` VALUES (1115, 'T2026015', '吴子诚', '讲师');
INSERT INTO `teacher` VALUES (1116, 'T2026016', '何清航', '讲师');
INSERT INTO `teacher` VALUES (1117, 'T2026017', '谢晨雯', '讲师');
INSERT INTO `teacher` VALUES (1118, 'T2026018', '赵思远', '讲师');
INSERT INTO `teacher` VALUES (1119, 'T2026019', '朱彦钰', '助教');
INSERT INTO `teacher` VALUES (1120, 'T2026020', '梁雨博', '助教');
INSERT INTO `teacher` VALUES (1121, 'T2026021', '刘可涵', '教授');
INSERT INTO `teacher` VALUES (1122, 'T2026022', '徐书萌', '副教授');
INSERT INTO `teacher` VALUES (1123, 'T2026023', '郭知睿', '副教授');
INSERT INTO `teacher` VALUES (1124, 'T2026024', '李泽晨', '副教授');
INSERT INTO `teacher` VALUES (1125, 'T2026025', '黄嘉宁', '讲师');
INSERT INTO `teacher` VALUES (1126, 'T2026026', '高向扬', '讲师');
INSERT INTO `teacher` VALUES (1127, 'T2026027', '宋安怡', '讲师');
INSERT INTO `teacher` VALUES (1128, 'T2026028', '陈景彤', '讲师');
INSERT INTO `teacher` VALUES (1129, 'T2026029', '孙亦希', '助教');
INSERT INTO `teacher` VALUES (1130, 'T2026030', '马若婷', '助教');
INSERT INTO `teacher` VALUES (1131, 'T2026031', '王星霖', '教授');
INSERT INTO `teacher` VALUES (1132, 'T2026032', '周明轩', '副教授');
INSERT INTO `teacher` VALUES (1133, 'T2026033', '林子诚', '副教授');
INSERT INTO `teacher` VALUES (1134, 'T2026034', '郑清航', '副教授');
INSERT INTO `teacher` VALUES (1135, 'T2026035', '杨晨雯', '讲师');
INSERT INTO `teacher` VALUES (1136, 'T2026036', '胡思远', '讲师');
INSERT INTO `teacher` VALUES (1137, 'T2026037', '罗彦钰', '讲师');
INSERT INTO `teacher` VALUES (1138, 'T2026038', '张雨博', '讲师');
INSERT INTO `teacher` VALUES (1139, 'T2026039', '吴可涵', '助教');
INSERT INTO `teacher` VALUES (1140, 'T2026040', '何书萌', '助教');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??ID',
  `login_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '???',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '??',
  `role` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '???student/teacher',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '??',
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '??',
  `department_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '??/????',
  `avatar` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '??',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '??????',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '?????0=??1=??',
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_user_login_name`(`login_name` ASC) USING BTREE,
  UNIQUE INDEX `uq_user_email`(`email` ASC) USING BTREE,
  INDEX `idx_user_role_is_deleted`(`role` ASC, `is_deleted` ASC) USING BTREE,
  INDEX `idx_user_is_deleted_department`(`is_deleted` ASC, `department_name` ASC) USING BTREE,
  CONSTRAINT `ck_user_role` CHECK (`role` in (_utf8mb4'student',_utf8mb4'teacher'))
) ENGINE = InnoDB AUTO_INCREMENT = 2602 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '????????/???' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1101, 't2026001', '120000:iVv3JzGCsXQe9+1S4CxT9g==:9XvHBuN/88NLfXZ3XEolqZGLZnoU1Iur+ITlEGAqaV8=', 'teacher', '黄彦钰', 't2026001@xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-19 09:16:10', 0, '2026-03-18 11:04:01', '2026-03-18 14:41:45');
INSERT INTO `user` VALUES (1102, 't2026002', '123456', 'teacher', '高雨博', 't2026002@xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-11 14:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1103, 't2026003', '123456', 'teacher', '宋可涵', 't2026003@xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-16 17:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1104, 't2026004', '123456', 'teacher', '陈书萌', 't2026004@xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-01 10:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1105, 't2026005', '123456', 'teacher', '孙知睿', 't2026005@xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-06 13:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1106, 't2026006', '123456', 'teacher', '马泽晨', 't2026006@xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-11 16:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1107, 't2026007', '123456', 'teacher', '王嘉宁', 't2026007@xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-16 09:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1108, 't2026008', '123456', 'teacher', '周向扬', 't2026008@xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-01 12:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1109, 't2026009', '123456', 'teacher', '林安怡', 't2026009@xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-06 15:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1110, 't2026010', '123456', 'teacher', '郑景彤', 't2026010@xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-11 08:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1111, 't2026011', '123456', 'teacher', '杨亦希', 't2026011@xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-16 11:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1112, 't2026012', '123456', 'teacher', '胡若婷', 't2026012@xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-01 14:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1113, 't2026013', '123456', 'teacher', '罗星霖', 't2026013@xjtu.edu.cn', '软件学院', NULL, '2026-03-06 17:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1114, 't2026014', '123456', 'teacher', '张明轩', 't2026014@xjtu.edu.cn', '软件学院', NULL, '2026-03-11 10:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1115, 't2026015', '123456', 'teacher', '吴子诚', 't2026015@xjtu.edu.cn', '软件学院', NULL, '2026-03-16 13:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1116, 't2026016', '123456', 'teacher', '何清航', 't2026016@xjtu.edu.cn', '软件学院', NULL, '2026-03-01 16:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1117, 't2026017', '123456', 'teacher', '谢晨雯', 't2026017@xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-06 09:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1118, 't2026018', '123456', 'teacher', '赵思远', 't2026018@xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-11 12:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1119, 't2026019', '123456', 'teacher', '朱彦钰', 't2026019@xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-16 15:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1120, 't2026020', '123456', 'teacher', '梁雨博', 't2026020@xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-01 08:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1121, 't2026021', '123456', 'teacher', '刘可涵', 't2026021@xjtu.edu.cn', '电气工程学院', NULL, '2026-03-06 11:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1122, 't2026022', '123456', 'teacher', '徐书萌', 't2026022@xjtu.edu.cn', '电气工程学院', NULL, '2026-03-11 14:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1123, 't2026023', '123456', 'teacher', '郭知睿', 't2026023@xjtu.edu.cn', '电气工程学院', NULL, '2026-03-16 17:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1124, 't2026024', '123456', 'teacher', '李泽晨', 't2026024@xjtu.edu.cn', '机械工程学院', NULL, '2026-03-01 10:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1125, 't2026025', '123456', 'teacher', '黄嘉宁', 't2026025@xjtu.edu.cn', '机械工程学院', NULL, '2026-03-06 13:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1126, 't2026026', '123456', 'teacher', '高向扬', 't2026026@xjtu.edu.cn', '机械工程学院', NULL, '2026-03-11 16:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1127, 't2026027', '123456', 'teacher', '宋安怡', 't2026027@xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-16 09:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1128, 't2026028', '123456', 'teacher', '陈景彤', 't2026028@xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-01 12:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1129, 't2026029', '123456', 'teacher', '孙亦希', 't2026029@xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-06 15:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1130, 't2026030', '123456', 'teacher', '马若婷', 't2026030@xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-11 08:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1131, 't2026031', '123456', 'teacher', '王星霖', 't2026031@xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-16 11:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1132, 't2026032', '123456', 'teacher', '周明轩', 't2026032@xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-01 14:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1133, 't2026033', '123456', 'teacher', '林子诚', 't2026033@xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-06 17:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1134, 't2026034', '123456', 'teacher', '郑清航', 't2026034@xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-11 10:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1135, 't2026035', '123456', 'teacher', '杨晨雯', 't2026035@xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-16 13:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1136, 't2026036', '123456', 'teacher', '胡思远', 't2026036@xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-01 16:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1137, 't2026037', '123456', 'teacher', '罗彦钰', 't2026037@xjtu.edu.cn', '外国语学院', NULL, '2026-03-06 09:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1138, 't2026038', '123456', 'teacher', '张雨博', 't2026038@xjtu.edu.cn', '外国语学院', NULL, '2026-03-11 12:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1139, 't2026039', '123456', 'teacher', '吴可涵', 't2026039@xjtu.edu.cn', '航空航天学院', NULL, '2026-03-16 15:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (1140, 't2026040', '123456', 'teacher', '何书萌', 't2026040@xjtu.edu.cn', '航空航天学院', NULL, '2026-03-01 08:00:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2101, '2025010001', '123456', 'student', '杨书萌', '2025010001@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-09 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2102, '2024010002', '123456', 'student', '徐向宇', '2024010002@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-16 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2103, '2023010003', '123456', 'student', '林安言', '2023010003@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-23 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2104, '2022010004', '123456', 'student', '梁闻怡', '2022010004@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-06 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2105, '2025010005', '123456', 'student', '王知文', '2025010005@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-13 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2106, '2024010006', '123456', 'student', '赵星卓', '2024010006@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-20 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2107, '2023010007', '123456', 'student', '孙若川', '2023010007@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-03 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2108, '2022010008', '123456', 'student', '何可希', '2022010008@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-10 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2109, '2025010009', '123456', 'student', '宋思昕', '2025010009@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-17 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2110, '2024010010', '123456', 'student', '张景霖', '2024010010@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-24 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2111, '2023010011', '123456', 'student', '黄明远', '2023010011@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-07 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2112, '2022010012', '123456', 'student', '胡语轩', '2022010012@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-14 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2113, '2025010013', '123456', 'student', '郭一睿', '2025010013@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-21 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2114, '2024010014', '123456', 'student', '郑沐彤', '2024010014@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-04 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2115, '2023010015', '123456', 'student', '刘泽诚', '2023010015@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-11 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2116, '2022010016', '123456', 'student', '周清航', '2022010016@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-18 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2117, '2025010017', '123456', 'student', '朱逸涵', '2025010017@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-25 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2118, '2024010018', '123456', 'student', '马子扬', '2024010018@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-08 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2119, '2023010019', '123456', 'student', '谢依晨', '2023010019@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-15 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2120, '2022010020', '123456', 'student', '陈嘉宁', '2022010020@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-22 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2121, '2025010021', '123456', 'student', '吴书萌', '2025010021@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-05 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2122, '2024010022', '123456', 'student', '高向宇', '2024010022@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-12 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2123, '2023010023', '123456', 'student', '罗安言', '2023010023@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-19 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2124, '2022010024', '123456', 'student', '李闻怡', '2022010024@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-02 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2125, '2025010025', '123456', 'student', '杨知文', '2025010025@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-09 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2126, '2024010026', '123456', 'student', '徐星卓', '2024010026@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-16 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2127, '2023010027', '123456', 'student', '林若川', '2023010027@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-23 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2128, '2022010028', '123456', 'student', '梁可希', '2022010028@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-06 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2129, '2025010029', '123456', 'student', '王思昕', '2025010029@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-13 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2130, '2024010030', '123456', 'student', '赵景霖', '2024010030@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-20 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2131, '2023010031', '123456', 'student', '孙明远', '2023010031@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-03 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2132, '2022010032', '123456', 'student', '何语轩', '2022010032@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-10 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2133, '2025010033', '123456', 'student', '宋一睿', '2025010033@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-17 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2134, '2024010034', '123456', 'student', '张沐彤', '2024010034@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-24 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2135, '2023010035', '123456', 'student', '黄泽诚', '2023010035@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-07 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2136, '2022010036', '123456', 'student', '胡清航', '2022010036@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-14 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2137, '2025010037', '123456', 'student', '郭逸涵', '2025010037@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-21 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2138, '2024010038', '123456', 'student', '郑子扬', '2024010038@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-04 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2139, '2023010039', '123456', 'student', '刘依晨', '2023010039@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-11 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2140, '2022010040', '123456', 'student', '周嘉宁', '2022010040@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-18 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2141, '2025010041', '123456', 'student', '朱书萌', '2025010041@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-25 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2142, '2024010042', '123456', 'student', '马向宇', '2024010042@stu.xjtu.edu.cn', '马克思主义学院', NULL, '2026-03-08 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2143, '2025020043', '123456', 'student', '谢安言', '2025020043@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-15 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2144, '2024020044', '123456', 'student', '陈闻怡', '2024020044@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-22 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2145, '2023020045', '123456', 'student', '吴知文', '2023020045@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-05 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2146, '2022020046', '123456', 'student', '高星卓', '2022020046@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-12 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2147, '2025020047', '123456', 'student', '罗若川', '2025020047@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-19 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2148, '2024020048', '123456', 'student', '李可希', '2024020048@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-02 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2149, '2023020049', '123456', 'student', '杨思昕', '2023020049@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-09 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2150, '2022020050', '123456', 'student', '徐景霖', '2022020050@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-16 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2151, '2025020051', '123456', 'student', '林明远', '2025020051@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-23 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2152, '2024020052', '123456', 'student', '梁语轩', '2024020052@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-06 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2153, '2023020053', '123456', 'student', '王一睿', '2023020053@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-13 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2154, '2022020054', '123456', 'student', '赵沐彤', '2022020054@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-20 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2155, '2025020055', '123456', 'student', '孙泽诚', '2025020055@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-03 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2156, '2024020056', '123456', 'student', '何清航', '2024020056@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-10 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2157, '2023020057', '123456', 'student', '宋逸涵', '2023020057@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-17 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2158, '2022020058', '123456', 'student', '张子扬', '2022020058@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-24 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2159, '2025020059', '123456', 'student', '黄依晨', '2025020059@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-07 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2160, '2024020060', '123456', 'student', '胡嘉宁', '2024020060@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-14 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2161, '2023020061', '123456', 'student', '郭书萌', '2023020061@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-21 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2162, '2022020062', '123456', 'student', '郑向宇', '2022020062@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-04 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2163, '2025020063', '123456', 'student', '刘安言', '2025020063@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-11 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2164, '2024020064', '123456', 'student', '周闻怡', '2024020064@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-18 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2165, '2023020065', '123456', 'student', '朱知文', '2023020065@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-25 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2166, '2022020066', '123456', 'student', '马星卓', '2022020066@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-08 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2167, '2025020067', '123456', 'student', '谢若川', '2025020067@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-15 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2168, '2024020068', '123456', 'student', '陈可希', '2024020068@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-22 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2169, '2023020069', '123456', 'student', '吴思昕', '2023020069@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-05 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2170, '2022020070', '123456', 'student', '高景霖', '2022020070@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-12 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2171, '2025020071', '123456', 'student', '罗明远', '2025020071@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-19 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2172, '2024020072', '123456', 'student', '李语轩', '2024020072@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-02 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2173, '2023020073', '123456', 'student', '杨一睿', '2023020073@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-09 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2174, '2022020074', '123456', 'student', '徐沐彤', '2022020074@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-16 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2175, '2025020075', '123456', 'student', '林泽诚', '2025020075@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-23 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2176, '2024020076', '123456', 'student', '梁清航', '2024020076@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-06 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2177, '2023020077', '123456', 'student', '王逸涵', '2023020077@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-13 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2178, '2022020078', '123456', 'student', '赵子扬', '2022020078@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-20 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2179, '2025020079', '123456', 'student', '孙依晨', '2025020079@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-03 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2180, '2024020080', '123456', 'student', '何嘉宁', '2024020080@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-10 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2181, '2023020081', '123456', 'student', '宋书萌', '2023020081@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-17 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2182, '2022020082', '123456', 'student', '张向宇', '2022020082@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-24 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2183, '2025020083', '123456', 'student', '黄安言', '2025020083@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-07 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2184, '2024020084', '123456', 'student', '胡闻怡', '2024020084@stu.xjtu.edu.cn', '计算机科学与技术学院', NULL, '2026-03-14 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2185, '2025030085', '123456', 'student', '郭知文', '2025030085@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-21 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2186, '2024030086', '123456', 'student', '郑星卓', '2024030086@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-04 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2187, '2023030087', '123456', 'student', '刘若川', '2023030087@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-11 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2188, '2022030088', '123456', 'student', '周可希', '2022030088@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-18 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2189, '2025030089', '123456', 'student', '朱思昕', '2025030089@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-25 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2190, '2024030090', '123456', 'student', '马景霖', '2024030090@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-08 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2191, '2023030091', '123456', 'student', '谢明远', '2023030091@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-15 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2192, '2022030092', '123456', 'student', '陈语轩', '2022030092@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-22 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2193, '2025030093', '123456', 'student', '吴一睿', '2025030093@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-05 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2194, '2024030094', '123456', 'student', '高沐彤', '2024030094@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-12 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2195, '2023030095', '123456', 'student', '罗泽诚', '2023030095@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-19 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2196, '2022030096', '123456', 'student', '李清航', '2022030096@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-02 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2197, '2025030097', '123456', 'student', '杨逸涵', '2025030097@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-09 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2198, '2024030098', '123456', 'student', '徐子扬', '2024030098@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-16 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2199, '2023030099', '123456', 'student', '林依晨', '2023030099@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-23 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2200, '2022030100', '123456', 'student', '梁嘉宁', '2022030100@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-06 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2201, '2025030101', '123456', 'student', '王书萌', '2025030101@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-13 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2202, '2024030102', '123456', 'student', '赵向宇', '2024030102@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-20 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2203, '2023030103', '123456', 'student', '孙安言', '2023030103@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-03 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2204, '2022030104', '123456', 'student', '何闻怡', '2022030104@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-10 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2205, '2025030105', '123456', 'student', '宋知文', '2025030105@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-17 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2206, '2024030106', '123456', 'student', '张星卓', '2024030106@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-24 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2207, '2023030107', '123456', 'student', '黄若川', '2023030107@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-07 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2208, '2022030108', '123456', 'student', '胡可希', '2022030108@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-14 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2209, '2025030109', '123456', 'student', '郭思昕', '2025030109@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-21 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2210, '2024030110', '123456', 'student', '郑景霖', '2024030110@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-04 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2211, '2023030111', '123456', 'student', '刘明远', '2023030111@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-11 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2212, '2022030112', '123456', 'student', '周语轩', '2022030112@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-18 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2213, '2025030113', '123456', 'student', '朱一睿', '2025030113@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-25 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2214, '2024030114', '123456', 'student', '马沐彤', '2024030114@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-08 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2215, '2023030115', '123456', 'student', '谢泽诚', '2023030115@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-15 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2216, '2022030116', '123456', 'student', '陈清航', '2022030116@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-22 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2217, '2025030117', '123456', 'student', '吴逸涵', '2025030117@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-05 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2218, '2024030118', '123456', 'student', '高子扬', '2024030118@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-12 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2219, '2023030119', '123456', 'student', '罗依晨', '2023030119@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-19 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2220, '2022030120', '123456', 'student', '李嘉宁', '2022030120@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-02 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2221, '2025030121', '123456', 'student', '杨书萌', '2025030121@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-09 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2222, '2024030122', '123456', 'student', '徐向宇', '2024030122@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-16 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2223, '2023030123', '123456', 'student', '林安言', '2023030123@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-23 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2224, '2022030124', '123456', 'student', '梁闻怡', '2022030124@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-06 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2225, '2025030125', '123456', 'student', '王知文', '2025030125@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-13 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2226, '2024030126', '123456', 'student', '赵星卓', '2024030126@stu.xjtu.edu.cn', '软件学院', NULL, '2026-03-20 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2227, '2025040127', '123456', 'student', '孙若川', '2025040127@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-03 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2228, '2024040128', '123456', 'student', '何可希', '2024040128@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-10 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2229, '2023040129', '123456', 'student', '宋思昕', '2023040129@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-17 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2230, '2022040130', '123456', 'student', '张景霖', '2022040130@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-24 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2231, '2025040131', '123456', 'student', '黄明远', '2025040131@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-07 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2232, '2024040132', '123456', 'student', '胡语轩', '2024040132@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-14 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2233, '2023040133', '123456', 'student', '郭一睿', '2023040133@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-21 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2234, '2022040134', '123456', 'student', '郑沐彤', '2022040134@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-04 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2235, '2025040135', '123456', 'student', '刘泽诚', '2025040135@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-11 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2236, '2024040136', '123456', 'student', '周清航', '2024040136@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-18 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2237, '2023040137', '123456', 'student', '朱逸涵', '2023040137@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-25 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2238, '2022040138', '123456', 'student', '马子扬', '2022040138@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-08 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2239, '2025040139', '123456', 'student', '谢依晨', '2025040139@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-15 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2240, '2024040140', '123456', 'student', '陈嘉宁', '2024040140@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-22 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2241, '2023040141', '123456', 'student', '吴书萌', '2023040141@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-05 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2242, '2022040142', '123456', 'student', '高向宇', '2022040142@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-12 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2243, '2025040143', '123456', 'student', '罗安言', '2025040143@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-19 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2244, '2024040144', '123456', 'student', '李闻怡', '2024040144@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-02 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2245, '2023040145', '123456', 'student', '杨知文', '2023040145@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-09 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2246, '2022040146', '123456', 'student', '徐星卓', '2022040146@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-16 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2247, '2025040147', '123456', 'student', '林若川', '2025040147@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-23 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2248, '2024040148', '123456', 'student', '梁可希', '2024040148@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-06 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2249, '2023040149', '123456', 'student', '王思昕', '2023040149@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-13 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2250, '2022040150', '123456', 'student', '赵景霖', '2022040150@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-20 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2251, '2025040151', '123456', 'student', '孙明远', '2025040151@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-03 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2252, '2024040152', '123456', 'student', '何语轩', '2024040152@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-10 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2253, '2023040153', '123456', 'student', '宋一睿', '2023040153@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-17 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2254, '2022040154', '123456', 'student', '张沐彤', '2022040154@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-24 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2255, '2025040155', '123456', 'student', '黄泽诚', '2025040155@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-07 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2256, '2024040156', '123456', 'student', '胡清航', '2024040156@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-14 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2257, '2023040157', '123456', 'student', '郭逸涵', '2023040157@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-21 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2258, '2022040158', '123456', 'student', '郑子扬', '2022040158@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-04 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2259, '2025040159', '123456', 'student', '刘依晨', '2025040159@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-11 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2260, '2024040160', '123456', 'student', '周嘉宁', '2024040160@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-18 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2261, '2023040161', '123456', 'student', '朱书萌', '2023040161@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-25 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2262, '2022040162', '123456', 'student', '马向宇', '2022040162@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-08 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2263, '2025040163', '123456', 'student', '谢安言', '2025040163@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-15 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2264, '2024040164', '123456', 'student', '陈闻怡', '2024040164@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-22 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2265, '2023040165', '123456', 'student', '吴知文', '2023040165@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-05 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2266, '2022040166', '123456', 'student', '高星卓', '2022040166@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-12 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2267, '2025040167', '123456', 'student', '罗若川', '2025040167@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-19 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2268, '2024040168', '123456', 'student', '李可希', '2024040168@stu.xjtu.edu.cn', '电子与信息工程学院', NULL, '2026-03-02 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2269, '2025050169', '123456', 'student', '杨思昕', '2025050169@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-09 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2270, '2024050170', '123456', 'student', '徐景霖', '2024050170@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-16 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2271, '2023050171', '123456', 'student', '林明远', '2023050171@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-23 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2272, '2022050172', '123456', 'student', '梁语轩', '2022050172@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-06 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2273, '2025050173', '123456', 'student', '王一睿', '2025050173@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-13 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2274, '2024050174', '123456', 'student', '赵沐彤', '2024050174@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-20 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2275, '2023050175', '123456', 'student', '孙泽诚', '2023050175@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-03 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2276, '2022050176', '123456', 'student', '何清航', '2022050176@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-10 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2277, '2025050177', '123456', 'student', '宋逸涵', '2025050177@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-17 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2278, '2024050178', '123456', 'student', '张子扬', '2024050178@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-24 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2279, '2023050179', '123456', 'student', '黄依晨', '2023050179@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-07 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2280, '2022050180', '123456', 'student', '胡嘉宁', '2022050180@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-14 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2281, '2025050181', '123456', 'student', '郭书萌', '2025050181@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-21 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2282, '2024050182', '123456', 'student', '郑向宇', '2024050182@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-04 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2283, '2023050183', '123456', 'student', '刘安言', '2023050183@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-11 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2284, '2022050184', '123456', 'student', '周闻怡', '2022050184@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-18 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2285, '2025050185', '123456', 'student', '朱知文', '2025050185@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-25 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2286, '2024050186', '123456', 'student', '马星卓', '2024050186@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-08 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2287, '2023050187', '123456', 'student', '谢若川', '2023050187@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-15 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2288, '2022050188', '123456', 'student', '陈可希', '2022050188@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-22 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2289, '2025050189', '123456', 'student', '吴思昕', '2025050189@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-05 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2290, '2024050190', '123456', 'student', '高景霖', '2024050190@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-12 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2291, '2023050191', '123456', 'student', '罗明远', '2023050191@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-19 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2292, '2022050192', '123456', 'student', '李语轩', '2022050192@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-02 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2293, '2025050193', '123456', 'student', '杨一睿', '2025050193@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-09 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2294, '2024050194', '123456', 'student', '徐沐彤', '2024050194@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-16 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2295, '2023050195', '123456', 'student', '林泽诚', '2023050195@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-23 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2296, '2022050196', '123456', 'student', '梁清航', '2022050196@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-06 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2297, '2025050197', '123456', 'student', '王逸涵', '2025050197@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-13 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2298, '2024050198', '123456', 'student', '赵子扬', '2024050198@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-20 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2299, '2023050199', '123456', 'student', '孙依晨', '2023050199@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-03 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2300, '2022050200', '123456', 'student', '何嘉宁', '2022050200@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-10 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2301, '2025050201', '123456', 'student', '宋书萌', '2025050201@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-17 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2302, '2024050202', '123456', 'student', '张向宇', '2024050202@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-24 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2303, '2023050203', '123456', 'student', '黄安言', '2023050203@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-07 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2304, '2022050204', '123456', 'student', '胡闻怡', '2022050204@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-14 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2305, '2025050205', '123456', 'student', '郭知文', '2025050205@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-21 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2306, '2024050206', '123456', 'student', '郑星卓', '2024050206@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-04 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2307, '2023050207', '123456', 'student', '刘若川', '2023050207@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-11 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2308, '2022050208', '123456', 'student', '周可希', '2022050208@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-18 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2309, '2025050209', '123456', 'student', '朱思昕', '2025050209@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-25 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2310, '2024050210', '123456', 'student', '马景霖', '2024050210@stu.xjtu.edu.cn', '电气工程学院', NULL, '2026-03-08 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2311, '2025060211', '123456', 'student', '谢明远', '2025060211@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-15 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2312, '2024060212', '123456', 'student', '陈语轩', '2024060212@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-22 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2313, '2023060213', '123456', 'student', '吴一睿', '2023060213@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-05 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2314, '2022060214', '123456', 'student', '高沐彤', '2022060214@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-12 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2315, '2025060215', '123456', 'student', '罗泽诚', '2025060215@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-19 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2316, '2024060216', '123456', 'student', '李清航', '2024060216@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-02 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2317, '2023060217', '123456', 'student', '杨逸涵', '2023060217@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-09 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2318, '2022060218', '123456', 'student', '徐子扬', '2022060218@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-16 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2319, '2025060219', '123456', 'student', '林依晨', '2025060219@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-23 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2320, '2024060220', '123456', 'student', '梁嘉宁', '2024060220@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-06 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2321, '2023060221', '123456', 'student', '王书萌', '2023060221@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-13 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2322, '2022060222', '123456', 'student', '赵向宇', '2022060222@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-20 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2323, '2025060223', '123456', 'student', '孙安言', '2025060223@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-03 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2324, '2024060224', '123456', 'student', '何闻怡', '2024060224@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-10 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2325, '2023060225', '123456', 'student', '宋知文', '2023060225@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-17 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2326, '2022060226', '123456', 'student', '张星卓', '2022060226@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-24 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2327, '2025060227', '123456', 'student', '黄若川', '2025060227@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-07 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2328, '2024060228', '123456', 'student', '胡可希', '2024060228@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-14 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2329, '2023060229', '123456', 'student', '郭思昕', '2023060229@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-21 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2330, '2022060230', '123456', 'student', '郑景霖', '2022060230@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-04 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2331, '2025060231', '123456', 'student', '刘明远', '2025060231@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-11 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2332, '2024060232', '123456', 'student', '周语轩', '2024060232@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-18 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2333, '2023060233', '123456', 'student', '朱一睿', '2023060233@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-25 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2334, '2022060234', '123456', 'student', '马沐彤', '2022060234@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-08 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2335, '2025060235', '123456', 'student', '谢泽诚', '2025060235@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-15 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2336, '2024060236', '123456', 'student', '陈清航', '2024060236@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-22 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2337, '2023060237', '123456', 'student', '吴逸涵', '2023060237@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-05 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2338, '2022060238', '123456', 'student', '高子扬', '2022060238@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-12 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2339, '2025060239', '123456', 'student', '罗依晨', '2025060239@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-19 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2340, '2024060240', '123456', 'student', '李嘉宁', '2024060240@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-02 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2341, '2023060241', '123456', 'student', '杨书萌', '2023060241@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-09 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2342, '2022060242', '123456', 'student', '徐向宇', '2022060242@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-16 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2343, '2025060243', '123456', 'student', '林安言', '2025060243@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-23 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2344, '2024060244', '123456', 'student', '梁闻怡', '2024060244@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-06 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2345, '2023060245', '123456', 'student', '王知文', '2023060245@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-13 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2346, '2022060246', '123456', 'student', '赵星卓', '2022060246@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-20 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2347, '2025060247', '123456', 'student', '孙若川', '2025060247@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-03 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2348, '2024060248', '123456', 'student', '何可希', '2024060248@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-10 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2349, '2023060249', '123456', 'student', '宋思昕', '2023060249@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-17 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2350, '2022060250', '123456', 'student', '张景霖', '2022060250@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-24 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2351, '2025060251', '123456', 'student', '黄明远', '2025060251@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-07 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2352, '2024060252', '123456', 'student', '胡语轩', '2024060252@stu.xjtu.edu.cn', '机械工程学院', NULL, '2026-03-14 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2353, '2025070253', '123456', 'student', '郭一睿', '2025070253@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-21 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2354, '2024070254', '123456', 'student', '郑沐彤', '2024070254@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-04 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2355, '2023070255', '123456', 'student', '刘泽诚', '2023070255@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-11 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2356, '2022070256', '123456', 'student', '周清航', '2022070256@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-18 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2357, '2025070257', '123456', 'student', '朱逸涵', '2025070257@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-25 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2358, '2024070258', '123456', 'student', '马子扬', '2024070258@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-08 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2359, '2023070259', '123456', 'student', '谢依晨', '2023070259@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-15 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2360, '2022070260', '123456', 'student', '陈嘉宁', '2022070260@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-22 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2361, '2025070261', '123456', 'student', '吴书萌', '2025070261@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-05 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2362, '2024070262', '123456', 'student', '高向宇', '2024070262@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-12 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2363, '2023070263', '123456', 'student', '罗安言', '2023070263@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-19 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2364, '2022070264', '123456', 'student', '李闻怡', '2022070264@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-02 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2365, '2025070265', '123456', 'student', '杨知文', '2025070265@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-09 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2366, '2024070266', '123456', 'student', '徐星卓', '2024070266@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-16 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2367, '2023070267', '123456', 'student', '林若川', '2023070267@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-23 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2368, '2022070268', '123456', 'student', '梁可希', '2022070268@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-06 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2369, '2025070269', '123456', 'student', '王思昕', '2025070269@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-13 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2370, '2024070270', '123456', 'student', '赵景霖', '2024070270@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-20 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2371, '2023070271', '123456', 'student', '孙明远', '2023070271@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-03 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2372, '2022070272', '123456', 'student', '何语轩', '2022070272@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-10 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2373, '2025070273', '123456', 'student', '宋一睿', '2025070273@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-17 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2374, '2024070274', '123456', 'student', '张沐彤', '2024070274@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-24 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2375, '2023070275', '123456', 'student', '黄泽诚', '2023070275@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-07 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2376, '2022070276', '123456', 'student', '胡清航', '2022070276@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-14 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2377, '2025070277', '123456', 'student', '郭逸涵', '2025070277@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-21 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2378, '2024070278', '123456', 'student', '郑子扬', '2024070278@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-04 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2379, '2023070279', '123456', 'student', '刘依晨', '2023070279@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-11 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2380, '2022070280', '123456', 'student', '周嘉宁', '2022070280@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-18 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2381, '2025070281', '123456', 'student', '朱书萌', '2025070281@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-25 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2382, '2024070282', '123456', 'student', '马向宇', '2024070282@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-08 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2383, '2023070283', '123456', 'student', '谢安言', '2023070283@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-15 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2384, '2022070284', '123456', 'student', '陈闻怡', '2022070284@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-22 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2385, '2025070285', '123456', 'student', '吴知文', '2025070285@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-05 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2386, '2024070286', '123456', 'student', '高星卓', '2024070286@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-12 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2387, '2023070287', '123456', 'student', '罗若川', '2023070287@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-19 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2388, '2022070288', '123456', 'student', '李可希', '2022070288@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-02 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2389, '2025070289', '123456', 'student', '杨思昕', '2025070289@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-09 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2390, '2024070290', '123456', 'student', '徐景霖', '2024070290@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-16 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2391, '2023070291', '123456', 'student', '林明远', '2023070291@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-23 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2392, '2022070292', '123456', 'student', '梁语轩', '2022070292@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-06 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2393, '2025070293', '123456', 'student', '王一睿', '2025070293@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-13 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2394, '2024070294', '123456', 'student', '赵沐彤', '2024070294@stu.xjtu.edu.cn', '能源与动力工程学院', NULL, '2026-03-20 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2395, '2025080295', '123456', 'student', '孙泽诚', '2025080295@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-03 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2396, '2024080296', '123456', 'student', '何清航', '2024080296@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-10 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2397, '2023080297', '123456', 'student', '宋逸涵', '2023080297@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-17 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2398, '2022080298', '123456', 'student', '张子扬', '2022080298@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-24 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2399, '2025080299', '123456', 'student', '黄依晨', '2025080299@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-07 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2400, '2024080300', '123456', 'student', '胡嘉宁', '2024080300@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-14 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2401, '2023080301', '123456', 'student', '郭书萌', '2023080301@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-21 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2402, '2022080302', '123456', 'student', '郑向宇', '2022080302@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-04 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2403, '2025080303', '123456', 'student', '刘安言', '2025080303@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-11 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2404, '2024080304', '123456', 'student', '周闻怡', '2024080304@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-18 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2405, '2023080305', '123456', 'student', '朱知文', '2023080305@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-25 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2406, '2022080306', '123456', 'student', '马星卓', '2022080306@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-08 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2407, '2025080307', '123456', 'student', '谢若川', '2025080307@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-15 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2408, '2024080308', '123456', 'student', '陈可希', '2024080308@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-22 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2409, '2023080309', '123456', 'student', '吴思昕', '2023080309@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-05 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2410, '2022080310', '123456', 'student', '高景霖', '2022080310@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-12 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2411, '2025080311', '123456', 'student', '罗明远', '2025080311@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-19 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2412, '2024080312', '123456', 'student', '李语轩', '2024080312@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-02 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2413, '2023080313', '123456', 'student', '杨一睿', '2023080313@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-09 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2414, '2022080314', '123456', 'student', '徐沐彤', '2022080314@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-16 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2415, '2025080315', '123456', 'student', '林泽诚', '2025080315@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-23 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2416, '2024080316', '123456', 'student', '梁清航', '2024080316@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-06 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2417, '2023080317', '123456', 'student', '王逸涵', '2023080317@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-13 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2418, '2022080318', '123456', 'student', '赵子扬', '2022080318@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-20 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2419, '2025080319', '123456', 'student', '孙依晨', '2025080319@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-03 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2420, '2024080320', '123456', 'student', '何嘉宁', '2024080320@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-10 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2421, '2023080321', '123456', 'student', '宋书萌', '2023080321@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-17 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2422, '2022080322', '123456', 'student', '张向宇', '2022080322@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-24 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2423, '2025080323', '123456', 'student', '黄安言', '2025080323@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-07 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2424, '2024080324', '123456', 'student', '胡闻怡', '2024080324@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-14 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2425, '2023080325', '123456', 'student', '郭知文', '2023080325@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-21 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2426, '2022080326', '123456', 'student', '郑星卓', '2022080326@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-04 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2427, '2025080327', '123456', 'student', '刘若川', '2025080327@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-11 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2428, '2024080328', '123456', 'student', '周可希', '2024080328@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-18 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2429, '2023080329', '123456', 'student', '朱思昕', '2023080329@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-25 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2430, '2022080330', '123456', 'student', '马景霖', '2022080330@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-08 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2431, '2025080331', '123456', 'student', '谢明远', '2025080331@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-15 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2432, '2024080332', '123456', 'student', '陈语轩', '2024080332@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-22 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2433, '2023080333', '123456', 'student', '吴一睿', '2023080333@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-05 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2434, '2022080334', '123456', 'student', '高沐彤', '2022080334@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-12 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2435, '2025080335', '123456', 'student', '罗泽诚', '2025080335@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-19 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2436, '2024080336', '123456', 'student', '李清航', '2024080336@stu.xjtu.edu.cn', '经济与管理学院', NULL, '2026-03-02 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2437, '2025090337', '123456', 'student', '杨逸涵', '2025090337@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-09 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2438, '2024090338', '123456', 'student', '徐子扬', '2024090338@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-16 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2439, '2023090339', '123456', 'student', '林依晨', '2023090339@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-23 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2440, '2022090340', '123456', 'student', '梁嘉宁', '2022090340@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-06 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2441, '2025090341', '123456', 'student', '王书萌', '2025090341@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-13 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2442, '2024090342', '123456', 'student', '赵向宇', '2024090342@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-20 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2443, '2023090343', '123456', 'student', '孙安言', '2023090343@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-03 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2444, '2022090344', '123456', 'student', '何闻怡', '2022090344@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-10 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2445, '2025090345', '123456', 'student', '宋知文', '2025090345@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-17 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2446, '2024090346', '123456', 'student', '张星卓', '2024090346@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-24 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2447, '2023090347', '123456', 'student', '黄若川', '2023090347@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-07 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2448, '2022090348', '123456', 'student', '胡可希', '2022090348@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-14 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2449, '2025090349', '123456', 'student', '郭思昕', '2025090349@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-21 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2450, '2024090350', '123456', 'student', '郑景霖', '2024090350@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-04 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2451, '2023090351', '123456', 'student', '刘明远', '2023090351@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-11 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2452, '2022090352', '123456', 'student', '周语轩', '2022090352@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-18 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2453, '2025090353', '123456', 'student', '朱一睿', '2025090353@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-25 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2454, '2024090354', '123456', 'student', '马沐彤', '2024090354@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-08 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2455, '2023090355', '123456', 'student', '谢泽诚', '2023090355@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-15 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2456, '2022090356', '123456', 'student', '陈清航', '2022090356@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-22 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2457, '2025090357', '123456', 'student', '吴逸涵', '2025090357@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-05 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2458, '2024090358', '123456', 'student', '高子扬', '2024090358@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-12 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2459, '2023090359', '123456', 'student', '罗依晨', '2023090359@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-19 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2460, '2022090360', '123456', 'student', '李嘉宁', '2022090360@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-02 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2461, '2025090361', '123456', 'student', '杨书萌', '2025090361@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-09 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2462, '2024090362', '123456', 'student', '徐向宇', '2024090362@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-16 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2463, '2023090363', '123456', 'student', '林安言', '2023090363@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-23 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2464, '2022090364', '123456', 'student', '梁闻怡', '2022090364@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-06 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2465, '2025090365', '123456', 'student', '王知文', '2025090365@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-13 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2466, '2024090366', '123456', 'student', '赵星卓', '2024090366@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-20 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2467, '2023090367', '123456', 'student', '孙若川', '2023090367@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-03 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2468, '2022090368', '123456', 'student', '何可希', '2022090368@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-10 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2469, '2025090369', '123456', 'student', '宋思昕', '2025090369@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-17 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2470, '2024090370', '123456', 'student', '张景霖', '2024090370@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-24 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2471, '2023090371', '123456', 'student', '黄明远', '2023090371@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-07 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2472, '2022090372', '123456', 'student', '胡语轩', '2022090372@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-14 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2473, '2025090373', '123456', 'student', '郭一睿', '2025090373@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-21 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2474, '2024090374', '123456', 'student', '郑沐彤', '2024090374@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-04 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2475, '2023090375', '123456', 'student', '刘泽诚', '2023090375@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-11 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2476, '2022090376', '123456', 'student', '周清航', '2022090376@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-18 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2477, '2025090377', '123456', 'student', '朱逸涵', '2025090377@stu.xjtu.edu.cn', '人文社会科学学院', NULL, '2026-03-25 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2478, '2025100378', '123456', 'student', '马子扬', '2025100378@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-08 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2479, '2024100379', '123456', 'student', '谢依晨', '2024100379@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-15 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2480, '2023100380', '123456', 'student', '陈嘉宁', '2023100380@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-22 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2481, '2022100381', '123456', 'student', '吴书萌', '2022100381@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-05 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2482, '2025100382', '123456', 'student', '高向宇', '2025100382@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-12 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2483, '2024100383', '123456', 'student', '罗安言', '2024100383@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-19 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2484, '2023100384', '123456', 'student', '李闻怡', '2023100384@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-02 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2485, '2022100385', '123456', 'student', '杨知文', '2022100385@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-09 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2486, '2025100386', '123456', 'student', '徐星卓', '2025100386@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-16 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2487, '2024100387', '123456', 'student', '林若川', '2024100387@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-23 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2488, '2023100388', '123456', 'student', '梁可希', '2023100388@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-06 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2489, '2022100389', '123456', 'student', '王思昕', '2022100389@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-13 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2490, '2025100390', '123456', 'student', '赵景霖', '2025100390@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-20 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2491, '2024100391', '123456', 'student', '孙明远', '2024100391@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-03 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2492, '2023100392', '123456', 'student', '何语轩', '2023100392@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-10 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2493, '2022100393', '123456', 'student', '宋一睿', '2022100393@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-17 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2494, '2025100394', '123456', 'student', '张沐彤', '2025100394@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-24 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2495, '2024100395', '123456', 'student', '黄泽诚', '2024100395@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-07 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2496, '2023100396', '123456', 'student', '胡清航', '2023100396@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-14 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2497, '2022100397', '123456', 'student', '郭逸涵', '2022100397@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-21 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2498, '2025100398', '123456', 'student', '郑子扬', '2025100398@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-04 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2499, '2024100399', '123456', 'student', '刘依晨', '2024100399@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-11 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2500, '2023100400', '123456', 'student', '周嘉宁', '2023100400@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-18 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2501, '2022100401', '123456', 'student', '朱书萌', '2022100401@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-25 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2502, '2025100402', '123456', 'student', '马向宇', '2025100402@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-08 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2503, '2024100403', '123456', 'student', '谢安言', '2024100403@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-15 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2504, '2023100404', '123456', 'student', '陈闻怡', '2023100404@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-22 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2505, '2022100405', '123456', 'student', '吴知文', '2022100405@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-05 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2506, '2025100406', '123456', 'student', '高星卓', '2025100406@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-12 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2507, '2024100407', '123456', 'student', '罗若川', '2024100407@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-19 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2508, '2023100408', '123456', 'student', '李可希', '2023100408@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-02 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2509, '2022100409', '123456', 'student', '杨思昕', '2022100409@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-09 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2510, '2025100410', '123456', 'student', '徐景霖', '2025100410@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-16 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2511, '2024100411', '123456', 'student', '林明远', '2024100411@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-23 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2512, '2023100412', '123456', 'student', '梁语轩', '2023100412@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-06 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2513, '2022100413', '123456', 'student', '王一睿', '2022100413@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-13 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2514, '2025100414', '123456', 'student', '赵沐彤', '2025100414@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-20 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2515, '2024100415', '123456', 'student', '孙泽诚', '2024100415@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-03 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2516, '2023100416', '123456', 'student', '何清航', '2023100416@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-10 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2517, '2022100417', '123456', 'student', '宋逸涵', '2022100417@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-17 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2518, '2025100418', '123456', 'student', '张子扬', '2025100418@stu.xjtu.edu.cn', '数学与统计学院', NULL, '2026-03-24 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2519, '2025110419', '123456', 'student', '黄依晨', '2025110419@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-07 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2520, '2024110420', '123456', 'student', '胡嘉宁', '2024110420@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-14 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2521, '2023110421', '123456', 'student', '郭书萌', '2023110421@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-21 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2522, '2022110422', '123456', 'student', '郑向宇', '2022110422@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-04 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2523, '2025110423', '123456', 'student', '刘安言', '2025110423@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-11 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2524, '2024110424', '123456', 'student', '周闻怡', '2024110424@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-18 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2525, '2023110425', '123456', 'student', '朱知文', '2023110425@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-25 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2526, '2022110426', '123456', 'student', '马星卓', '2022110426@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-08 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2527, '2025110427', '123456', 'student', '谢若川', '2025110427@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-15 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2528, '2024110428', '123456', 'student', '陈可希', '2024110428@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-22 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2529, '2023110429', '123456', 'student', '吴思昕', '2023110429@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-05 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2530, '2022110430', '123456', 'student', '高景霖', '2022110430@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-12 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2531, '2025110431', '123456', 'student', '罗明远', '2025110431@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-19 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2532, '2024110432', '123456', 'student', '李语轩', '2024110432@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-02 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2533, '2023110433', '123456', 'student', '杨一睿', '2023110433@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-09 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2534, '2022110434', '123456', 'student', '徐沐彤', '2022110434@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-16 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2535, '2025110435', '123456', 'student', '林泽诚', '2025110435@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-23 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2536, '2024110436', '123456', 'student', '梁清航', '2024110436@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-06 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2537, '2023110437', '123456', 'student', '王逸涵', '2023110437@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-13 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2538, '2022110438', '123456', 'student', '赵子扬', '2022110438@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-20 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2539, '2025110439', '123456', 'student', '孙依晨', '2025110439@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-03 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2540, '2024110440', '123456', 'student', '何嘉宁', '2024110440@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-10 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2541, '2023110441', '123456', 'student', '宋书萌', '2023110441@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-17 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2542, '2022110442', '123456', 'student', '张向宇', '2022110442@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-24 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2543, '2025110443', '123456', 'student', '黄安言', '2025110443@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-07 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2544, '2024110444', '123456', 'student', '胡闻怡', '2024110444@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-14 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2545, '2023110445', '123456', 'student', '郭知文', '2023110445@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-21 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2546, '2022110446', '123456', 'student', '郑星卓', '2022110446@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-04 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2547, '2025110447', '123456', 'student', '刘若川', '2025110447@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-11 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2548, '2024110448', '123456', 'student', '周可希', '2024110448@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-18 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2549, '2023110449', '123456', 'student', '朱思昕', '2023110449@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-25 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2550, '2022110450', '123456', 'student', '马景霖', '2022110450@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-08 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2551, '2025110451', '123456', 'student', '谢明远', '2025110451@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-15 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2552, '2024110452', '123456', 'student', '陈语轩', '2024110452@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-22 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2553, '2023110453', '123456', 'student', '吴一睿', '2023110453@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-05 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2554, '2022110454', '123456', 'student', '高沐彤', '2022110454@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-12 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2555, '2025110455', '123456', 'student', '罗泽诚', '2025110455@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-19 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2556, '2024110456', '123456', 'student', '李清航', '2024110456@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-02 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2557, '2023110457', '123456', 'student', '杨逸涵', '2023110457@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-09 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2558, '2022110458', '123456', 'student', '徐子扬', '2022110458@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-16 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2559, '2025110459', '123456', 'student', '林依晨', '2025110459@stu.xjtu.edu.cn', '外国语学院', NULL, '2026-03-23 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2560, '2025120460', '123456', 'student', '梁嘉宁', '2025120460@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-06 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2561, '2024120461', '123456', 'student', '王书萌', '2024120461@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-13 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2562, '2023120462', '123456', 'student', '赵向宇', '2023120462@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-20 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2563, '2022120463', '123456', 'student', '孙安言', '2022120463@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-03 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2564, '2025120464', '123456', 'student', '何闻怡', '2025120464@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-10 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2565, '2024120465', '123456', 'student', '宋知文', '2024120465@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-17 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2566, '2023120466', '123456', 'student', '张星卓', '2023120466@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-24 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2567, '2022120467', '123456', 'student', '黄若川', '2022120467@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-07 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2568, '2025120468', '123456', 'student', '胡可希', '2025120468@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-14 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2569, '2024120469', '123456', 'student', '郭思昕', '2024120469@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-21 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2570, '2023120470', '123456', 'student', '郑景霖', '2023120470@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-04 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2571, '2022120471', '123456', 'student', '刘明远', '2022120471@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-11 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2572, '2025120472', '123456', 'student', '周语轩', '2025120472@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-18 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2573, '2024120473', '123456', 'student', '朱一睿', '2024120473@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-25 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2574, '2023120474', '123456', 'student', '马沐彤', '2023120474@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-08 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2575, '2022120475', '123456', 'student', '谢泽诚', '2022120475@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-15 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2576, '2025120476', '123456', 'student', '陈清航', '2025120476@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-22 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2577, '2024120477', '123456', 'student', '吴逸涵', '2024120477@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-05 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2578, '2023120478', '123456', 'student', '高子扬', '2023120478@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-12 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2579, '2022120479', '123456', 'student', '罗依晨', '2022120479@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-19 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2580, '2025120480', '123456', 'student', '李嘉宁', '2025120480@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-02 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2581, '2024120481', '123456', 'student', '杨书萌', '2024120481@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-09 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2582, '2023120482', '123456', 'student', '徐向宇', '2023120482@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-16 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2583, '2022120483', '123456', 'student', '林安言', '2022120483@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-23 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2584, '2025120484', '123456', 'student', '梁闻怡', '2025120484@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-06 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2585, '2024120485', '123456', 'student', '王知文', '2024120485@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-13 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2586, '2023120486', '123456', 'student', '赵星卓', '2023120486@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-20 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2587, '2022120487', '123456', 'student', '孙若川', '2022120487@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-03 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2588, '2025120488', '123456', 'student', '何可希', '2025120488@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-10 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2589, '2024120489', '123456', 'student', '宋思昕', '2024120489@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-17 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2590, '2023120490', '123456', 'student', '张景霖', '2023120490@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-24 08:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2591, '2022120491', '123456', 'student', '黄明远', '2022120491@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-07 10:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2592, '2025120492', '123456', 'student', '胡语轩', '2025120492@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-14 12:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2593, '2024120493', '123456', 'student', '郭一睿', '2024120493@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-21 14:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2594, '2023120494', '123456', 'student', '郑沐彤', '2023120494@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-04 16:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2595, '2022120495', '123456', 'student', '刘泽诚', '2022120495@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-11 07:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2596, '2025120496', '123456', 'student', '周清航', '2025120496@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-18 09:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2597, '2024120497', '123456', 'student', '朱逸涵', '2024120497@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-25 11:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2598, '2023120498', '123456', 'student', '马子扬', '2023120498@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-08 13:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2599, '2022120499', '123456', 'student', '谢依晨', '2022120499@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-15 15:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2600, '2025120500', '123456', 'student', '陈嘉宁', '2025120500@stu.xjtu.edu.cn', '航空航天学院', NULL, '2026-03-22 17:30:00', 0, '2026-03-18 11:04:01', '2026-03-18 11:04:01');
INSERT INTO `user` VALUES (2601, 's20261117', '120000:JGoF0UHjDDahq2k9Kqf0Ow==:qLEjY/tLQet4B/SvvaJnyg874yx6wbX05Ws1vSG5+Q4=', 'student', '赵梓元', NULL, NULL, NULL, '2026-03-18 14:54:20', 1, '2026-03-18 14:54:05', '2026-03-18 14:55:51');

SET FOREIGN_KEY_CHECKS = 1;
