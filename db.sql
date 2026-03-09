SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
                           `course_id` bigint NOT NULL AUTO_INCREMENT COMMENT '课程ID',
                           `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '课程标题',
                           `teacher_id` bigint NOT NULL COMMENT '教师ID（当前代码校验指向 user.id）',
                           `chapters` json NULL COMMENT '章节列表（JSON数组；由JacksonTypeHandler序列化）',
                           `materials` json NULL COMMENT '资料列表（JSON数组）',
                           `task_points` json NULL COMMENT '任务点列表（JSON数组）',
                           `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                           `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                           PRIMARY KEY (`course_id`) USING BTREE,
                           INDEX `idx_course_teacher_id`(`teacher_id` ASC) USING BTREE,
                           CONSTRAINT `fk_course_teacher_user` FOREIGN KEY (`teacher_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程（JSON字段存章节/资料/任务点）' ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `coursevisit`;
CREATE TABLE `coursevisit`  (
                                `coursename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '课程名（主键；由代码直接以coursename定位并自增计数）',
                                `today` int NOT NULL DEFAULT 0 COMMENT '今日访问次数',
                                `thisweek` int NOT NULL DEFAULT 0 COMMENT '本周访问次数',
                                `thismonth` int NOT NULL DEFAULT 0 COMMENT '本月访问次数',
                                `thisyear` int NOT NULL DEFAULT 0 COMMENT '本年访问次数',
                                PRIMARY KEY (`coursename`) USING BTREE,
                                INDEX `idx_coursevisit_today`(`today` ASC) USING BTREE,
                                INDEX `idx_coursevisit_thisweek`(`thisweek` ASC) USING BTREE,
                                INDEX `idx_coursevisit_thismonth`(`thismonth` ASC) USING BTREE,
                                INDEX `idx_coursevisit_thisyear`(`thisyear` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程访问统计（用于榜单/仪表盘）' ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `dict_live_session_status`;
CREATE TABLE `dict_live_session_status`  (
                                             `status_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态编码',
                                             `status_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态名称',
                                             `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
                                             PRIMARY KEY (`status_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '直播课次状态字典（建议与live_session.status对齐）' ROW_FORMAT = Dynamic;

INSERT INTO `dict_live_session_status` VALUES ('cancelled', '已取消', '直播取消/下线');
INSERT INTO `dict_live_session_status` VALUES ('ended', '已结束', '直播已结束');
INSERT INTO `dict_live_session_status` VALUES ('live', '直播中', '正在直播');
INSERT INTO `dict_live_session_status` VALUES ('scheduled', '已排期', '尚未开始');

DROP TABLE IF EXISTS `dict_user_role`;
CREATE TABLE `dict_user_role`  (
                                   `role_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色编码',
                                   `role_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
                                   `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
                                   PRIMARY KEY (`role_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户角色字典（建议与users.role对齐）' ROW_FORMAT = Dynamic;

INSERT INTO `dict_user_role` VALUES ('admin', '管理员', '系统管理员（若将来与user表统一，可使用）');
INSERT INTO `dict_user_role` VALUES ('student', '学生', '业务用户：学习者');
INSERT INTO `dict_user_role` VALUES ('teacher', '教师', '业务用户：授课者');

DROP TABLE IF EXISTS `learning_record`;
CREATE TABLE `learning_record`  (
                                    `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '学习记录ID',
                                    `user_id` bigint NOT NULL COMMENT '业务用户ID（建议指向 users.id）',
                                    `course_id` bigint NOT NULL COMMENT '课程ID（course.course_id）',
                                    `check_in_time` datetime NULL DEFAULT NULL COMMENT '签到时间（非空表示已签到）',
                                    `task_point_id` bigint NULL DEFAULT NULL COMMENT '任务点ID（当前与course.task_points JSON弱关联）',
                                    `is_online` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否在线（0=否，1=是）',
                                    `last_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
                                    PRIMARY KEY (`record_id`) USING BTREE,
                                    INDEX `idx_learning_record_user_id`(`user_id` ASC) USING BTREE,
                                    INDEX `idx_learning_record_course_id`(`course_id` ASC) USING BTREE,
                                    INDEX `idx_learning_record_is_online`(`is_online` ASC) USING BTREE,
                                    INDEX `idx_learning_record_check_in_time`(`check_in_time` ASC) USING BTREE,
                                    INDEX `idx_learning_record_user_course`(`user_id` ASC, `course_id` ASC) USING BTREE,
                                    CONSTRAINT `fk_learning_record_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
                                    CONSTRAINT `fk_learning_record_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学习记录（签到、在线、任务点完成等）' ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `live_session`;
CREATE TABLE `live_session`  (
                                 `session_id` bigint NOT NULL AUTO_INCREMENT COMMENT '直播课次ID',
                                 `course_id` bigint NOT NULL COMMENT '课程ID（course.course_id）',
                                 `teacher_id` bigint NOT NULL COMMENT '教师ID（Dashboard按 users.id 解析教师姓名）',
                                 `start_time` datetime NOT NULL COMMENT '开始时间',
                                 `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'scheduled' COMMENT '状态（建议用字典表：scheduled/live/ended/cancelled）',
                                 `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                 `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                 PRIMARY KEY (`session_id`) USING BTREE,
                                 INDEX `idx_live_session_course_id`(`course_id` ASC) USING BTREE,
                                 INDEX `idx_live_session_teacher_id`(`teacher_id` ASC) USING BTREE,
                                 INDEX `idx_live_session_start_time`(`start_time` ASC) USING BTREE,
                                 INDEX `idx_live_session_status`(`status` ASC) USING BTREE,
                                 CONSTRAINT `fk_live_session_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
                                 CONSTRAINT `fk_live_session_teacher_users` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '直播课次（用于Dashboard展示）' ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
                           `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID',
                           `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单名称/描述',
                           `user_id` bigint NOT NULL COMMENT '关联用户ID（user.id）',
                           PRIMARY KEY (`id`) USING BTREE,
                           INDEX `idx_orders_user_id`(`user_id` ASC) USING BTREE,
                           CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单（示例表，OrdersMapper与User做关联查询）' ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
                            `student_id` bigint NOT NULL AUTO_INCREMENT COMMENT '学号/学生ID（自增主键）',
                            `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '姓名',
                            `college` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学院',
                            `learning_index` decimal(5, 2) NULL DEFAULT NULL COMMENT '学情分析指数',
                            `comparison_last_month` decimal(5, 2) NULL DEFAULT NULL COMMENT '对比上月',
                            `total_warnings` int NOT NULL DEFAULT 0 COMMENT '累计预警次数',
                            `resolved_warnings` int NOT NULL DEFAULT 0 COMMENT '累计解除次数',
                            `learning_scores` decimal(5, 2) NULL DEFAULT NULL COMMENT '学习成绩（实体存在，Mapper可能未覆盖）',
                            `average_course_scores` decimal(5, 2) NULL DEFAULT NULL COMMENT '课程平均分（实体存在，Mapper可能未覆盖）',
                            PRIMARY KEY (`student_id`) USING BTREE,
                            INDEX `idx_student_name`(`name` ASC) USING BTREE,
                            INDEX `idx_student_college`(`college` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学生画像/分析指标' ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `sys_audit_log`;
CREATE TABLE `sys_audit_log`  (
                                  `log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '审计日志ID',
                                  `actor_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作者类型（user/users/system）',
                                  `actor_id` bigint NULL DEFAULT NULL COMMENT '操作者ID（根据actor_type解释）',
                                  `action` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '动作（login/create/update/delete等）',
                                  `object_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '对象类型（table/entity）',
                                  `object_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '对象ID（字符串化，兼容多表）',
                                  `request_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'HTTP方法',
                                  `request_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求路径',
                                  `request_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求IP',
                                  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'User-Agent',
                                  `success` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否成功',
                                  `status_code` int NULL DEFAULT NULL COMMENT 'HTTP状态码',
                                  `error_message` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '错误信息',
                                  `extra` json NULL COMMENT '扩展字段（JSON）',
                                  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录时间',
                                  PRIMARY KEY (`log_id`) USING BTREE,
                                  INDEX `idx_audit_actor`(`actor_type` ASC, `actor_id` ASC) USING BTREE,
                                  INDEX `idx_audit_action`(`action` ASC) USING BTREE,
                                  INDEX `idx_audit_time`(`gmt_created` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审计/操作日志（建议扩展）' ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
                               `config_id` bigint NOT NULL AUTO_INCREMENT COMMENT '配置ID',
                               `config_key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置键（唯一）',
                               `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '配置值',
                               `value_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '值类型（string/number/json等）',
                               `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
                               `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
                               `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                               `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                               PRIMARY KEY (`config_id`) USING BTREE,
                               UNIQUE INDEX `uq_sys_config_key`(`config_key` ASC) USING BTREE,
                               INDEX `idx_sys_config_is_deleted`(`is_deleted` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '配置中心（建议扩展）' ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission`  (
                                   `perm_id` bigint NOT NULL AUTO_INCREMENT COMMENT '权限ID',
                                   `perm_code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '权限编码（唯一）',
                                   `perm_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '权限名称',
                                   `resource` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '资源标识（如URL/方法名）',
                                   `http_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'HTTP方法（GET/POST/PUT/DELETE等）',
                                   `perm_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限类型（menu/button/api等）',
                                   `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
                                   `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                   `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                   PRIMARY KEY (`perm_id`) USING BTREE,
                                   UNIQUE INDEX `uq_sys_perm_code`(`perm_code` ASC) USING BTREE,
                                   INDEX `idx_sys_perm_is_deleted`(`is_deleted` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'RBAC：权限表（建议扩展）' ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
                             `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
                             `role_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色编码（唯一）',
                             `role_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
                             `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
                             `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
                             `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                             `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                             PRIMARY KEY (`role_id`) USING BTREE,
                             UNIQUE INDEX `uq_sys_role_code`(`role_code` ASC) USING BTREE,
                             INDEX `idx_sys_role_is_deleted`(`is_deleted` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'RBAC：角色表（建议扩展）' ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `sys_role_permission`;
CREATE TABLE `sys_role_permission`  (
                                        `role_id` bigint NOT NULL COMMENT '角色ID',
                                        `perm_id` bigint NOT NULL COMMENT '权限ID',
                                        PRIMARY KEY (`role_id`, `perm_id`) USING BTREE,
                                        INDEX `fk_sys_rp_perm`(`perm_id` ASC) USING BTREE,
                                        CONSTRAINT `fk_sys_rp_perm` FOREIGN KEY (`perm_id`) REFERENCES `sys_permission` (`perm_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
                                        CONSTRAINT `fk_sys_rp_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`role_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'RBAC：角色-权限关联（建议扩展）' ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
                                  `users_id` bigint NOT NULL COMMENT '业务用户ID（users.id）',
                                  `role_id` bigint NOT NULL COMMENT '角色ID（sys_role.role_id）',
                                  PRIMARY KEY (`users_id`, `role_id`) USING BTREE,
                                  INDEX `fk_sys_ur_role`(`role_id` ASC) USING BTREE,
                                  CONSTRAINT `fk_sys_ur_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`role_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
                                  CONSTRAINT `fk_sys_ur_users` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'RBAC：用户-角色关联（建议扩展）' ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
                         `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                         `login_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
                         `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'BCrypt hash or legacy',
                         `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
                         `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
                         `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除（0=否，1=是）',
                         `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                         `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                         `avatar` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '头像',
                         PRIMARY KEY (`id`) USING BTREE,
                         UNIQUE INDEX `uq_user_login_name`(`login_name` ASC) USING BTREE,
                         INDEX `idx_user_is_deleted`(`is_deleted` ASC) USING BTREE,
                         INDEX `idx_user_last_login_time`(`last_login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员/登录账户' ROW_FORMAT = Dynamic;

INSERT INTO `user` VALUES (1, 'admin', '120000:wB6CHdYqrXOAfyqajAoXww==:GP0LgYmg3l6vzCM04ZktSbdS+qxy0uGSklPI8t4p3Q0=', '2026-03-09 16:27:31', '测试数据:管理员用户', 0, '2026-03-09 11:33:15', '2026-03-09 11:33:15', NULL);

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
                          `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                          `login_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '登录名',
                          `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'BCrypt hash or legacy',
                          `role` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色（典型值：student/teacher；建议使用字典表约束）',
                          `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '姓名',
                          `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
                          `learning_index` decimal(5, 2) NULL DEFAULT NULL COMMENT '学情指数（0-10区间常见）',
                          `department_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '部门/学院名称',
                          `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
                          `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除（0=否，1=是）',
                          `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                          `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                          PRIMARY KEY (`id`) USING BTREE,
                          UNIQUE INDEX `uq_users_login_name`(`login_name` ASC) USING BTREE,
                          UNIQUE INDEX `uq_users_email`(`email` ASC) USING BTREE,
                          INDEX `idx_users_is_deleted`(`is_deleted` ASC) USING BTREE,
                          INDEX `idx_users_role_is_deleted`(`role` ASC, `is_deleted` ASC) USING BTREE,
                          INDEX `idx_users_is_deleted_department`(`is_deleted` ASC, `department_name` ASC) USING BTREE,
                          INDEX `idx_users_is_deleted_role_learning_index`(`is_deleted` ASC, `role` ASC, `learning_index` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '业务用户（学生/教师等）' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;