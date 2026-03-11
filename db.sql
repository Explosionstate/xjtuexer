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

 Date: 11/03/2026 15:56:58
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin_user
-- ----------------------------
DROP TABLE IF EXISTS `admin_user`;
CREATE TABLE `admin_user`  (
                               `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                               `login_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '管理员登录名',
                               `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码（当前按项目演示先保留明文；如启用Spring Security可改为{id}encodedPassword）',
                               `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
                               `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
                               `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除（0=否，1=是）',
                               `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                               `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                               `avatar` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '头像',
                               PRIMARY KEY (`id`) USING BTREE,
                               UNIQUE INDEX `uq_admin_user_login_name`(`login_name` ASC) USING BTREE,
                               INDEX `idx_admin_user_is_deleted`(`is_deleted` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin_user
-- ----------------------------
INSERT INTO `admin_user` VALUES (1, 'admin', '120000:eKMsKz2cqkZDfyAQ7pi5Sw==:+MsZrqRRkxN4kCJnATJxy6Fkg4ASoF/rhoKMLA5ai5c=', '2026-03-11 15:40:00', '系统管理员', 0, '2026-03-11 11:21:45', '2026-03-11 11:21:45', NULL);
INSERT INTO `admin_user` VALUES (2, 'student03', '120000:1Sork82vJXovaq0Caj6yjQ==:0anxib0QB0h8JVgf+dmE98c7FIZtEsK3QFrxmos6MIw=', NULL, NULL, 0, '2026-03-11 15:42:36', '2026-03-11 15:42:36', NULL);

-- ----------------------------
-- Table structure for admin_user_menu
-- ----------------------------
DROP TABLE IF EXISTS `admin_user_menu`;
CREATE TABLE `admin_user_menu`  (
                                    `admin_user_id` bigint NOT NULL COMMENT '管理员ID（admin_user.id）',
                                    `menu_id` bigint NOT NULL COMMENT '菜单ID（sys_menu.menu_id）',
                                    PRIMARY KEY (`admin_user_id`, `menu_id`) USING BTREE,
                                    INDEX `fk_admin_user_menu_menu`(`menu_id` ASC) USING BTREE,
                                    CONSTRAINT `fk_admin_user_menu_admin` FOREIGN KEY (`admin_user_id`) REFERENCES `admin_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
                                    CONSTRAINT `fk_admin_user_menu_menu` FOREIGN KEY (`menu_id`) REFERENCES `sys_menu` (`menu_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin_user_menu
-- ----------------------------
INSERT INTO `admin_user_menu` VALUES (1, 1);

-- ----------------------------
-- Table structure for admin_user_permission
-- ----------------------------
DROP TABLE IF EXISTS `admin_user_permission`;
CREATE TABLE `admin_user_permission`  (
                                          `admin_user_id` bigint NOT NULL COMMENT '管理员ID',
                                          `perm_id` bigint NOT NULL COMMENT '权限ID',
                                          PRIMARY KEY (`admin_user_id`, `perm_id`) USING BTREE,
                                          INDEX `idx_admin_user_permission_perm_id`(`perm_id` ASC) USING BTREE,
                                          CONSTRAINT `fk_admin_user_permission_admin` FOREIGN KEY (`admin_user_id`) REFERENCES `admin_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
                                          CONSTRAINT `fk_admin_user_permission_perm` FOREIGN KEY (`perm_id`) REFERENCES `sys_permission` (`perm_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员操作权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin_user_permission
-- ----------------------------
INSERT INTO `admin_user_permission` VALUES (1, 101);
INSERT INTO `admin_user_permission` VALUES (1, 102);
INSERT INTO `admin_user_permission` VALUES (1, 103);

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
                           `course_id` bigint NOT NULL AUTO_INCREMENT COMMENT '课程ID',
                           `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '课程标题',
                           `teacher_id` bigint NOT NULL COMMENT '教师ID（teacher.teacher_id）',
                           `chapters` json NULL COMMENT '章节列表（JSON数组）',
                           `materials` json NULL COMMENT '资料列表（JSON数组）',
                           `task_points` json NULL COMMENT '任务点列表（JSON数组）',
                           `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                           `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                           `chapters_count` int GENERATED ALWAYS AS (json_length(`chapters`)) VIRTUAL COMMENT '章节数(生成列)' NULL,
                           `materials_count` int GENERATED ALWAYS AS (json_length(`materials`)) VIRTUAL COMMENT '资料数(生成列)' NULL,
                           `task_points_count` int GENERATED ALWAYS AS (json_length(`task_points`)) VIRTUAL COMMENT '任务点数(生成列)' NULL,
                           PRIMARY KEY (`course_id`) USING BTREE,
                           UNIQUE INDEX `uq_course_course_teacher`(`course_id` ASC, `teacher_id` ASC) USING BTREE,
                           INDEX `idx_course_teacher_id`(`teacher_id` ASC) USING BTREE,
                           INDEX `idx_course_chapters_count`(`chapters_count` ASC) USING BTREE,
                           INDEX `idx_course_materials_count`(`materials_count` ASC) USING BTREE,
                           INDEX `idx_course_task_points_count`(`task_points_count` ASC) USING BTREE,
                           CONSTRAINT `fk_course_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES (1, '马克思主义基本原理', 1001, '[\"导论\", \"世界的物质性\", \"实践与认识\"]', '[\"课件PPT\", \"课程讲义\", \"拓展阅读\"]', '[\"课堂签到\", \"章节测验\", \"课后讨论\"]', '2026-03-11 11:21:45', '2026-03-11 11:21:45', DEFAULT, DEFAULT, DEFAULT);
INSERT INTO `course` VALUES (2, '中国近现代史纲要', 1002, '[\"近代中国的社会性质\", \"辛亥革命\", \"新中国成立\"]', '[\"教学课件\", \"教学视频\"]', '[\"课堂提问\", \"学习打卡\"]', '2026-03-11 11:21:45', '2026-03-11 11:21:45', DEFAULT, DEFAULT, DEFAULT);

-- ----------------------------
-- Table structure for coursevisit
-- ----------------------------
DROP TABLE IF EXISTS `coursevisit`;
CREATE TABLE `coursevisit`  (
                                `course_id` bigint NOT NULL COMMENT '课程ID（course.course_id）',
                                `coursename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '课程名（兼容现有代码）',
                                `today` int NOT NULL DEFAULT 0 COMMENT '今日访问次数',
                                `thisweek` int NOT NULL DEFAULT 0 COMMENT '本周访问次数',
                                `thismonth` int NOT NULL DEFAULT 0 COMMENT '本月访问次数',
                                `thisyear` int NOT NULL DEFAULT 0 COMMENT '本年访问次数',
                                PRIMARY KEY (`coursename`) USING BTREE,
                                UNIQUE INDEX `uq_coursevisit_course_id`(`course_id` ASC) USING BTREE,
                                INDEX `idx_coursevisit_today`(`today` ASC) USING BTREE,
                                INDEX `idx_coursevisit_thisweek`(`thisweek` ASC) USING BTREE,
                                INDEX `idx_coursevisit_thismonth`(`thismonth` ASC) USING BTREE,
                                INDEX `idx_coursevisit_thisyear`(`thisyear` ASC) USING BTREE,
                                CONSTRAINT `fk_coursevisit_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程访问统计' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of coursevisit
-- ----------------------------
INSERT INTO `coursevisit` VALUES (2, '中国近现代史纲要', 9, 42, 167, 167);
INSERT INTO `coursevisit` VALUES (1, '马克思主义基本原理', 13, 59, 211, 211);

-- ----------------------------
-- Table structure for learning_record
-- ----------------------------
DROP TABLE IF EXISTS `learning_record`;
CREATE TABLE `learning_record`  (
                                    `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '学习记录ID',
                                    `user_id` bigint NOT NULL COMMENT '学生ID（student.student_id）',
                                    `course_id` bigint NOT NULL COMMENT '课程ID（course.course_id）',
                                    `check_in_time` datetime NULL DEFAULT NULL COMMENT '签到时间',
                                    `task_point_id` bigint NULL DEFAULT NULL COMMENT '任务点ID（与course.task_points弱关联，暂不做外键）',
                                    `is_online` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否在线（0=否，1=是）',
                                    `last_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
                                    PRIMARY KEY (`record_id`) USING BTREE,
                                    INDEX `idx_learning_record_course_id`(`course_id` ASC) USING BTREE,
                                    INDEX `idx_learning_record_is_online`(`is_online` ASC) USING BTREE,
                                    INDEX `idx_learning_record_check_in_time`(`check_in_time` ASC) USING BTREE,
                                    INDEX `idx_learning_record_user_course`(`user_id` ASC, `course_id` ASC) USING BTREE,
                                    CONSTRAINT `fk_learning_record_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
                                    CONSTRAINT `fk_learning_record_student` FOREIGN KEY (`user_id`) REFERENCES `student` (`student_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学习记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_record
-- ----------------------------
INSERT INTO `learning_record` VALUES (1, 2001, 1, '2026-03-11 11:21:45', 1, 1, '2026-03-11 11:21:45');
INSERT INTO `learning_record` VALUES (2, 2002, 2, '2026-03-11 11:21:45', 1, 0, '2026-03-11 11:21:45');

-- ----------------------------
-- Table structure for live_session
-- ----------------------------
DROP TABLE IF EXISTS `live_session`;
CREATE TABLE `live_session`  (
                                 `session_id` bigint NOT NULL AUTO_INCREMENT COMMENT '直播课次ID',
                                 `course_id` bigint NOT NULL COMMENT '课程ID',
                                 `teacher_id` bigint NOT NULL COMMENT '教师ID（teacher.teacher_id）',
                                 `start_time` datetime NOT NULL COMMENT '开始时间',
                                 `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'scheduled' COMMENT '状态：scheduled/live/ended/cancelled',
                                 `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                 `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                 PRIMARY KEY (`session_id`) USING BTREE,
                                 INDEX `idx_live_session_course_id`(`course_id` ASC) USING BTREE,
                                 INDEX `idx_live_session_teacher_id`(`teacher_id` ASC) USING BTREE,
                                 INDEX `idx_live_session_start_time`(`start_time` ASC) USING BTREE,
                                 INDEX `idx_live_session_status`(`status` ASC) USING BTREE,
                                 INDEX `fk_live_session_course_teacher`(`course_id` ASC, `teacher_id` ASC) USING BTREE,
                                 CONSTRAINT `fk_live_session_course_teacher` FOREIGN KEY (`course_id`, `teacher_id`) REFERENCES `course` (`course_id`, `teacher_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
                                 CONSTRAINT `fk_live_session_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
                                 CONSTRAINT `ck_live_session_status` CHECK (`status` in (_utf8mb4'scheduled',_utf8mb4'live',_utf8mb4'ended',_utf8mb4'cancelled'))
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '直播课次表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of live_session
-- ----------------------------
INSERT INTO `live_session` VALUES (1, 1, 1001, '2026-03-15 19:00:00', 'scheduled', '2026-03-11 11:21:45', '2026-03-11 11:21:45');
INSERT INTO `live_session` VALUES (2, 2, 1002, '2026-03-16 19:30:00', 'scheduled', '2026-03-11 11:21:45', '2026-03-11 11:21:45');

-- ----------------------------
-- Table structure for role_menu
-- ----------------------------
DROP TABLE IF EXISTS `role_menu`;
CREATE TABLE `role_menu`  (
                              `role_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色编码：student/teacher',
                              `menu_id` bigint NOT NULL COMMENT '菜单ID',
                              PRIMARY KEY (`role_code`, `menu_id`) USING BTREE,
                              INDEX `idx_role_menu_menu_id`(`menu_id` ASC) USING BTREE,
                              CONSTRAINT `fk_role_menu_menu` FOREIGN KEY (`menu_id`) REFERENCES `sys_menu` (`menu_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
                              CONSTRAINT `ck_role_menu_role` CHECK (`role_code` in (_utf8mb4'student',_utf8mb4'teacher'))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色菜单关联表' ROW_FORMAT = Dynamic;

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
                                    `role_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色编码：student/teacher',
                                    `perm_id` bigint NOT NULL COMMENT '权限ID',
                                    PRIMARY KEY (`role_code`, `perm_id`) USING BTREE,
                                    INDEX `idx_role_permission_perm_id`(`perm_id` ASC) USING BTREE,
                                    CONSTRAINT `fk_role_permission_perm` FOREIGN KEY (`perm_id`) REFERENCES `sys_permission` (`perm_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
                                    CONSTRAINT `ck_role_permission_role` CHECK (`role_code` in (_utf8mb4'student',_utf8mb4'teacher'))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色操作权限表' ROW_FORMAT = Dynamic;

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
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
                            `student_id` bigint NOT NULL COMMENT '学生ID，与user.id一致',
                            `student_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '学号',
                            `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '姓名',
                            `college` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学院',
                            `learning_index` decimal(5, 2) NULL DEFAULT NULL COMMENT '学情分析指数',
                            `comparison_last_month` decimal(5, 2) NULL DEFAULT NULL COMMENT '对比上月',
                            `total_warnings` int NOT NULL DEFAULT 0 COMMENT '累计预警次数',
                            `resolved_warnings` int NOT NULL DEFAULT 0 COMMENT '累计解除次数',
                            `learning_scores` decimal(5, 2) NULL DEFAULT NULL COMMENT '学习成绩',
                            `average_course_scores` decimal(5, 2) NULL DEFAULT NULL COMMENT '课程平均分',
                            PRIMARY KEY (`student_id`) USING BTREE,
                            UNIQUE INDEX `uq_student_student_no`(`student_no` ASC) USING BTREE,
                            INDEX `idx_student_name`(`name` ASC) USING BTREE,
                            INDEX `idx_student_college`(`college` ASC) USING BTREE,
                            CONSTRAINT `fk_student_user` FOREIGN KEY (`student_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学生画像/分析指标' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES (2001, 'S2026001', '王同学', '计算机学院', 82.50, 2.10, 1, 1, 88.00, 85.00);
INSERT INTO `student` VALUES (2002, 'S2026002', '刘同学', '软件学院', 79.00, 1.20, 0, 0, 84.00, 82.00);

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
                             `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
                             `menu_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单编码',
                             `menu_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
                             `route_path` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '前端路由',
                             `sort_no` int NOT NULL DEFAULT 0 COMMENT '排序',
                             `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
                             PRIMARY KEY (`menu_id`) USING BTREE,
                             UNIQUE INDEX `uq_sys_menu_code`(`menu_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统菜单表' ROW_FORMAT = Dynamic;

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
                                        `menu_id` bigint NOT NULL COMMENT '菜单ID',
                                        `perm_id` bigint NOT NULL COMMENT '权限ID',
                                        PRIMARY KEY (`menu_id`, `perm_id`) USING BTREE,
                                        INDEX `idx_sys_menu_permission_perm_id`(`perm_id` ASC) USING BTREE,
                                        CONSTRAINT `fk_sys_menu_permission_menu` FOREIGN KEY (`menu_id`) REFERENCES `sys_menu` (`menu_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
                                        CONSTRAINT `fk_sys_menu_permission_perm` FOREIGN KEY (`perm_id`) REFERENCES `sys_permission` (`perm_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单-权限关联表' ROW_FORMAT = Dynamic;

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
                                   `perm_id` bigint NOT NULL AUTO_INCREMENT COMMENT '权限ID',
                                   `perm_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '权限编码',
                                   `perm_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '权限名称',
                                   `resource_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '资源类型：api/button',
                                   `resource_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '接口路径或按钮编码',
                                   `http_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'HTTP方法',
                                   `rule_json` json NULL COMMENT '附加规则，如可修改的role范围',
                                   `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
                                   `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
                                   `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                   `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                   PRIMARY KEY (`perm_id`) USING BTREE,
                                   UNIQUE INDEX `uq_sys_permission_code`(`perm_code` ASC) USING BTREE,
                                   INDEX `idx_sys_permission_enabled`(`enabled` ASC) USING BTREE,
                                   CONSTRAINT `ck_sys_permission_enabled` CHECK (`enabled` in (0,1)),
                                   CONSTRAINT `ck_sys_permission_resource_type` CHECK (`resource_type` in (_utf8mb4'api',_utf8mb4'button'))
) ENGINE = InnoDB AUTO_INCREMENT = 306 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统操作权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_permission
-- ----------------------------
INSERT INTO `sys_permission` VALUES (101, 'USER_QUERY', '查询用户列表', 'api', '/api/user/list', 'GET', NULL, 1, '管理员查询学生/教师列表', '2026-03-11 15:56:26', '2026-03-11 15:56:26');
INSERT INTO `sys_permission` VALUES (102, 'USER_DETAIL', '查看用户详情', 'api', '/api/user/detail', 'GET', NULL, 1, '管理员查看单个用户详情', '2026-03-11 15:56:26', '2026-03-11 15:56:26');
INSERT INTO `sys_permission` VALUES (103, 'USER_ROLE_UPDATE', '修改用户角色', 'api', '/api/user/updateRole', 'PUT', '{\"field\": \"role\", \"allowedValues\": [\"student\", \"teacher\"]}', 1, '管理员只能把用户角色改为 student / teacher', '2026-03-11 15:56:26', '2026-03-11 15:56:26');
INSERT INTO `sys_permission` VALUES (201, 'AI_ASSISTANT_USE', '使用AI助理教学', 'api', '/api/ai/chat', 'POST', NULL, 1, '进入AI助理教学模块并发起问答', '2026-03-11 15:56:26', '2026-03-11 15:56:26');
INSERT INTO `sys_permission` VALUES (202, 'ONLINE_LEARNING_VIEW', '查看在线学习', 'api', '/api/course/online', 'GET', NULL, 1, '查看在线学习课程', '2026-03-11 15:56:26', '2026-03-11 15:56:26');
INSERT INTO `sys_permission` VALUES (203, 'PERSONAL_CENTER_VIEW', '查看个人中心', 'api', '/api/user/profile', 'GET', NULL, 1, '查看个人中心', '2026-03-11 15:56:26', '2026-03-11 15:56:26');
INSERT INTO `sys_permission` VALUES (301, 'COURSE_MANAGEMENT_VIEW', '查看课程管理', 'api', '/api/course/listByTeacher', 'GET', '{\"scope\": \"self\"}', 1, '教师查看自己的课程', '2026-03-11 15:56:26', '2026-03-11 15:56:26');
INSERT INTO `sys_permission` VALUES (302, 'COURSE_MANAGEMENT_EDIT', '编辑课程', 'api', '/api/course/save', 'POST', '{\"scope\": \"self\"}', 1, '教师新增/修改自己的课程', '2026-03-11 15:56:26', '2026-03-11 15:56:26');
INSERT INTO `sys_permission` VALUES (303, 'LIVE_SESSION_VIEW', '查看直播管理', 'api', '/api/liveSession/listByTeacher', 'GET', '{\"scope\": \"self\"}', 1, '教师查看自己的直播', '2026-03-11 15:56:26', '2026-03-11 15:56:26');
INSERT INTO `sys_permission` VALUES (304, 'LIVE_SESSION_EDIT', '编辑直播课次', 'api', '/api/liveSession/save', 'POST', '{\"scope\": \"self\"}', 1, '教师新增/修改自己的直播课次', '2026-03-11 15:56:26', '2026-03-11 15:56:26');
INSERT INTO `sys_permission` VALUES (305, 'COURSE_VISIT_VIEW', '查看学习统计', 'api', '/api/coursevisit/list', 'GET', '{\"scope\": \"self_course\"}', 1, '教师查看自己课程的学习统计', '2026-03-11 15:56:26', '2026-03-11 15:56:26');

-- ----------------------------
-- Table structure for teacher
-- ----------------------------
DROP TABLE IF EXISTS `teacher`;
CREATE TABLE `teacher`  (
                            `teacher_id` bigint NOT NULL COMMENT '教师ID，与user.id一致',
                            `teacher_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '教师工号',
                            `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '教师姓名（兼容展示）',
                            `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '职称',
                            PRIMARY KEY (`teacher_id`) USING BTREE,
                            UNIQUE INDEX `uq_teacher_teacher_no`(`teacher_no` ASC) USING BTREE,
                            CONSTRAINT `fk_teacher_user` FOREIGN KEY (`teacher_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '教师信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of teacher
-- ----------------------------
INSERT INTO `teacher` VALUES (1001, 'T2026001', '张老师', '讲师');
INSERT INTO `teacher` VALUES (1002, 'T2026002', '李老师', '副教授');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
                         `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                         `login_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '登录名',
                         `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
                         `role` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色：student/teacher',
                         `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '姓名',
                         `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
                         `department_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '部门/学院名称',
                         `avatar` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '头像',
                         `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
                         `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除（0=否，1=是）',
                         `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                         `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                         PRIMARY KEY (`id`) USING BTREE,
                         UNIQUE INDEX `uq_user_login_name`(`login_name` ASC) USING BTREE,
                         UNIQUE INDEX `uq_user_email`(`email` ASC) USING BTREE,
                         INDEX `idx_user_role_is_deleted`(`role` ASC, `is_deleted` ASC) USING BTREE,
                         INDEX `idx_user_is_deleted_department`(`is_deleted` ASC, `department_name` ASC) USING BTREE,
                         CONSTRAINT `ck_user_role` CHECK (`role` in (_utf8mb4'student',_utf8mb4'teacher'))
) ENGINE = InnoDB AUTO_INCREMENT = 2003 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '业务用户表（学生/教师）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1001, 'teacher01', '123456', 'teacher', '张老师', 'teacher01@cloud.com', '马克思主义学院', NULL, NULL, 0, '2026-03-11 11:21:45', '2026-03-11 11:21:45');
INSERT INTO `user` VALUES (1002, 'teacher02', '123456', 'teacher', '李老师', 'teacher02@cloud.com', '马克思主义学院', NULL, NULL, 0, '2026-03-11 11:21:45', '2026-03-11 11:21:45');
INSERT INTO `user` VALUES (2001, 'student01', '123456', 'student', '王同学', 'student01@cloud.com', '计算机学院', NULL, NULL, 0, '2026-03-11 11:21:45', '2026-03-11 11:21:45');
INSERT INTO `user` VALUES (2002, 'student02', '123456', 'student', '刘同学', 'student02@cloud.com', '软件学院', NULL, NULL, 0, '2026-03-11 11:21:45', '2026-03-11 11:21:45');

SET FOREIGN_KEY_CHECKS = 1;
