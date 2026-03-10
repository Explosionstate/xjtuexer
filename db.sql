/* =========================================================
   数据库重建脚本：springboot_demo
   目标：MySQL 8.x 可直接执行
   默认：utf8mb4 / utf8mb4_general_ci / InnoDB
   说明：
   - 本脚本包含：DROP DATABASE / CREATE DATABASE / USE
   - 包含必要的外键、索引、默认值与注释
   - 表名 `user` 为关键字风险表名，统一使用反引号
   ========================================================= */

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS springboot_demo;

CREATE DATABASE springboot_demo
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE springboot_demo;

/* =========================================================
   核心表：管理员用户表 user
   ========================================================= */
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `login_name` VARCHAR(64) NOT NULL COMMENT '用户名',
  `password` VARCHAR(255) NOT NULL COMMENT '密码（建议存储哈希；当前代码为明文比对）',
  `last_login_time` DATETIME NULL COMMENT '最后登录时间',
  `remark` VARCHAR(255) NULL COMMENT '备注',
  `is_deleted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否删除（0=否，1=是）',
  `gmt_created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `advater` VARCHAR(512) NULL COMMENT '头像（字段名沿用源码：advater，疑似avatar拼写）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_user_login_name` (`login_name`),
  KEY `idx_user_is_deleted` (`is_deleted`),
  KEY `idx_user_last_login_time` (`last_login_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='管理员/登录账户';

/* 示例数据：管理员用户（与仓库db.sql语义一致，但补齐字段） */
INSERT INTO `user` (`login_name`, `password`, `remark`, `is_deleted`)
VALUES ('admin', 'admin', '测试数据:管理员用户', 0);

/* =========================================================
   核心表：业务用户/人员表 users
   ========================================================= */
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `login_name` VARCHAR(64) NOT NULL COMMENT '登录名',
  `password` VARCHAR(255) NOT NULL COMMENT '密码（建议哈希）',
  `role` VARCHAR(32) NOT NULL COMMENT '角色（典型值：student/teacher；建议使用字典表约束）',
  `name` VARCHAR(64) NULL COMMENT '姓名',
  `email` VARCHAR(128) NULL COMMENT '邮箱',
  `learning_index` DECIMAL(5,2) NULL COMMENT '学情指数（0-10区间常见）',
  `department_name` VARCHAR(128) NULL COMMENT '部门/学院名称',
  `last_login_time` DATETIME NULL COMMENT '最后登录时间',
  `is_deleted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否删除（0=否，1=是）',
  `gmt_created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_login_name` (`login_name`),
  UNIQUE KEY `uq_users_email` (`email`),
  KEY `idx_users_is_deleted` (`is_deleted`),
  KEY `idx_users_role_is_deleted` (`role`, `is_deleted`),
  KEY `idx_users_is_deleted_department` (`is_deleted`, `department_name`),
  KEY `idx_users_is_deleted_role_learning_index` (`is_deleted`, `role`, `learning_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='业务用户（学生/教师等）';

/* =========================================================
   核心表：学生画像 student
   ========================================================= */
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student` (
  `student_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '学号/学生ID（自增主键）',
  `name` VARCHAR(64) NOT NULL COMMENT '姓名',
  `college` VARCHAR(128) NULL COMMENT '学院',
  `learning_index` DECIMAL(5,2) NULL COMMENT '学情分析指数',
  `comparison_last_month` DECIMAL(5,2) NULL COMMENT '对比上月',
  `total_warnings` INT NOT NULL DEFAULT 0 COMMENT '累计预警次数',
  `resolved_warnings` INT NOT NULL DEFAULT 0 COMMENT '累计解除次数',
  `learning_scores` DECIMAL(5,2) NULL COMMENT '学习成绩（实体存在，Mapper可能未覆盖）',
  `average_course_scores` DECIMAL(5,2) NULL COMMENT '课程平均分（实体存在，Mapper可能未覆盖）',
  PRIMARY KEY (`student_id`),
  KEY `idx_student_name` (`name`),
  KEY `idx_student_college` (`college`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='学生画像/分析指标';

/* =========================================================
   核心表：课程 course（含JSON字段）
   ========================================================= */
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course` (
  `course_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `title` VARCHAR(255) NOT NULL COMMENT '课程标题',
  `teacher_id` BIGINT NOT NULL COMMENT '教师ID（当前代码校验指向 user.id）',
  `chapters` JSON NULL COMMENT '章节列表（JSON数组；由JacksonTypeHandler序列化）',
  `materials` JSON NULL COMMENT '资料列表（JSON数组）',
  `task_points` JSON NULL COMMENT '任务点列表（JSON数组）',
  `gmt_created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`course_id`),
  KEY `idx_course_teacher_id` (`teacher_id`),
  CONSTRAINT `fk_course_teacher_user`
    FOREIGN KEY (`teacher_id`) REFERENCES `user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='课程（JSON字段存章节/资料/任务点）';

/* =========================================================
   核心表：课程访问统计 coursevisit
   ========================================================= */
DROP TABLE IF EXISTS `coursevisit`;
CREATE TABLE `coursevisit` (
  `coursename` VARCHAR(255) NOT NULL COMMENT '课程名（主键；由代码直接以coursename定位并自增计数）',
  `today` INT NOT NULL DEFAULT 0 COMMENT '今日访问次数',
  `thisweek` INT NOT NULL DEFAULT 0 COMMENT '本周访问次数',
  `thismonth` INT NOT NULL DEFAULT 0 COMMENT '本月访问次数',
  `thisyear` INT NOT NULL DEFAULT 0 COMMENT '本年访问次数',
  PRIMARY KEY (`coursename`),
  KEY `idx_coursevisit_today` (`today`),
  KEY `idx_coursevisit_thisweek` (`thisweek`),
  KEY `idx_coursevisit_thismonth` (`thismonth`),
  KEY `idx_coursevisit_thisyear` (`thisyear`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='课程访问统计（用于榜单/仪表盘）';

/* =========================================================
   核心表：订单 orders（示例：与 user 表关联）
   ========================================================= */
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `name` VARCHAR(255) NOT NULL COMMENT '订单名称/描述',
  `user_id` BIGINT NOT NULL COMMENT '关联用户ID（user.id）',
  PRIMARY KEY (`id`),
  KEY `idx_orders_user_id` (`user_id`),
  CONSTRAINT `fk_orders_user`
    FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='订单（示例表，OrdersMapper与User做关联查询）';

/* =========================================================
   核心表：学习记录 learning_record
   ========================================================= */
DROP TABLE IF EXISTS `learning_record`;
CREATE TABLE `learning_record` (
  `record_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '学习记录ID',
  `user_id` BIGINT NOT NULL COMMENT '业务用户ID（建议指向 users.id）',
  `course_id` BIGINT NOT NULL COMMENT '课程ID（course.course_id）',
  `check_in_time` DATETIME NULL COMMENT '签到时间（非空表示已签到）',
  `task_point_id` BIGINT NULL COMMENT '任务点ID（当前与course.task_points JSON弱关联）',
  `is_online` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否在线（0=否，1=是）',
  `last_updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  PRIMARY KEY (`record_id`),
  KEY `idx_learning_record_user_id` (`user_id`),
  KEY `idx_learning_record_course_id` (`course_id`),
  KEY `idx_learning_record_is_online` (`is_online`),
  KEY `idx_learning_record_check_in_time` (`check_in_time`),
  KEY `idx_learning_record_user_course` (`user_id`, `course_id`),
  CONSTRAINT `fk_learning_record_users`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_learning_record_course`
    FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='学习记录（签到、在线、任务点完成等）';

/* =========================================================
   核心表：直播课次 live_session
   ========================================================= */
DROP TABLE IF EXISTS `live_session`;
CREATE TABLE `live_session` (
  `session_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '直播课次ID',
  `course_id` BIGINT NOT NULL COMMENT '课程ID（course.course_id）',
  `teacher_id` BIGINT NOT NULL COMMENT '教师ID（Dashboard按 users.id 解析教师姓名）',
  `start_time` DATETIME NOT NULL COMMENT '开始时间',
  `status` VARCHAR(32) NOT NULL DEFAULT 'scheduled' COMMENT '状态（建议用字典表：scheduled/live/ended/cancelled）',
  `gmt_created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`session_id`),
  KEY `idx_live_session_course_id` (`course_id`),
  KEY `idx_live_session_teacher_id` (`teacher_id`),
  KEY `idx_live_session_start_time` (`start_time`),
  KEY `idx_live_session_status` (`status`),
  CONSTRAINT `fk_live_session_course`
    FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_live_session_teacher_users`
    FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='直播课次（用于Dashboard展示）';

/* =========================================================
   字典表示例（仓库未显式提供，但代码存在“枚举式字符串”）
   - 不强加外键，避免影响现有代码写入
   ========================================================= */
DROP TABLE IF EXISTS `dict_user_role`;
CREATE TABLE `dict_user_role` (
  `role_code` VARCHAR(32) NOT NULL COMMENT '角色编码',
  `role_name` VARCHAR(64) NOT NULL COMMENT '角色名称',
  `description` VARCHAR(255) NULL COMMENT '描述',
  PRIMARY KEY (`role_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户角色字典（建议与users.role对齐）';

INSERT INTO `dict_user_role` (`role_code`, `role_name`, `description`) VALUES
('student', '学生', '业务用户：学习者'),
('teacher', '教师', '业务用户：授课者'),
('admin', '管理员', '系统管理员（若将来与user表统一，可使用）');

DROP TABLE IF EXISTS `dict_live_session_status`;
CREATE TABLE `dict_live_session_status` (
  `status_code` VARCHAR(32) NOT NULL COMMENT '状态编码',
  `status_name` VARCHAR(64) NOT NULL COMMENT '状态名称',
  `description` VARCHAR(255) NULL COMMENT '描述',
  PRIMARY KEY (`status_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='直播课次状态字典（建议与live_session.status对齐）';

INSERT INTO `dict_live_session_status` (`status_code`, `status_name`, `description`) VALUES
('scheduled', '已排期', '尚未开始'),
('live', '直播中', '正在直播'),
('ended', '已结束', '直播已结束'),
('cancelled', '已取消', '直播取消/下线');

/* =========================================================
   扩展模块建议（仓库未包含，建议添加）
   - 角色/权限（RBAC）
   - 审计/操作日志
   - 配置中心（键值对）
   这些表不影响现有代码运行，但为后续演进预留
   ========================================================= */

DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `role_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_code` VARCHAR(64) NOT NULL COMMENT '角色编码（唯一）',
  `role_name` VARCHAR(128) NOT NULL COMMENT '角色名称',
  `remark` VARCHAR(255) NULL COMMENT '备注',
  `is_deleted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  `gmt_created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `uq_sys_role_code` (`role_code`),
  KEY `idx_sys_role_is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='RBAC：角色表（建议扩展）';

DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission` (
  `perm_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '权限ID',
  `perm_code` VARCHAR(128) NOT NULL COMMENT '权限编码（唯一）',
  `perm_name` VARCHAR(255) NOT NULL COMMENT '权限名称',
  `resource` VARCHAR(255) NULL COMMENT '资源标识（如URL/方法名）',
  `http_method` VARCHAR(16) NULL COMMENT 'HTTP方法（GET/POST/PUT/DELETE等）',
  `perm_type` VARCHAR(32) NULL COMMENT '权限类型（menu/button/api等）',
  `is_deleted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  `gmt_created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`perm_id`),
  UNIQUE KEY `uq_sys_perm_code` (`perm_code`),
  KEY `idx_sys_perm_is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='RBAC：权限表（建议扩展）';

DROP TABLE IF EXISTS `sys_role_permission`;
CREATE TABLE `sys_role_permission` (
  `role_id` BIGINT NOT NULL COMMENT '角色ID',
  `perm_id` BIGINT NOT NULL COMMENT '权限ID',
  PRIMARY KEY (`role_id`, `perm_id`),
  CONSTRAINT `fk_sys_rp_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`role_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_sys_rp_perm` FOREIGN KEY (`perm_id`) REFERENCES `sys_permission` (`perm_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='RBAC：角色-权限关联（建议扩展）';

DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `users_id` BIGINT NOT NULL COMMENT '业务用户ID（users.id）',
  `role_id` BIGINT NOT NULL COMMENT '角色ID（sys_role.role_id）',
  PRIMARY KEY (`users_id`, `role_id`),
  CONSTRAINT `fk_sys_ur_users` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_sys_ur_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`role_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='RBAC：用户-角色关联（建议扩展）';

DROP TABLE IF EXISTS `sys_audit_log`;
CREATE TABLE `sys_audit_log` (
  `log_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '审计日志ID',
  `actor_type` VARCHAR(32) NOT NULL COMMENT '操作者类型（user/users/system）',
  `actor_id` BIGINT NULL COMMENT '操作者ID（根据actor_type解释）',
  `action` VARCHAR(128) NOT NULL COMMENT '动作（login/create/update/delete等）',
  `object_type` VARCHAR(64) NULL COMMENT '对象类型（table/entity）',
  `object_id` VARCHAR(64) NULL COMMENT '对象ID（字符串化，兼容多表）',
  `request_method` VARCHAR(16) NULL COMMENT 'HTTP方法',
  `request_path` VARCHAR(255) NULL COMMENT '请求路径',
  `request_ip` VARCHAR(64) NULL COMMENT '请求IP',
  `user_agent` VARCHAR(512) NULL COMMENT 'User-Agent',
  `success` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否成功',
  `status_code` INT NULL COMMENT 'HTTP状态码',
  `error_message` VARCHAR(1024) NULL COMMENT '错误信息',
  `extra` JSON NULL COMMENT '扩展字段（JSON）',
  `gmt_created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录时间',
  PRIMARY KEY (`log_id`),
  KEY `idx_audit_actor` (`actor_type`, `actor_id`),
  KEY `idx_audit_action` (`action`),
  KEY `idx_audit_time` (`gmt_created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='审计/操作日志（建议扩展）';

DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config` (
  `config_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `config_key` VARCHAR(128) NOT NULL COMMENT '配置键（唯一）',
  `config_value` TEXT NULL COMMENT '配置值',
  `value_type` VARCHAR(32) NULL COMMENT '值类型（string/number/json等）',
  `description` VARCHAR(255) NULL COMMENT '描述',
  `is_deleted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  `gmt_created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`config_id`),
  UNIQUE KEY `uq_sys_config_key` (`config_key`),
  KEY `idx_sys_config_is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='配置中心（建议扩展）';

SET FOREIGN_KEY_CHECKS = 1;



-- V20260309__backend_hardening.sql
-- 目标库：springboot_demo
-- 注意：执行前请备份数据库；涉及外键变更时请确认现存数据满足约束。

USE springboot_demo;

-- 1) 扩展 password 长度（BCrypt + 未来扩展更安全）
ALTER TABLE `user`  MODIFY COLUMN `password` VARCHAR(255) NULL COMMENT 'BCrypt hash or legacy';
-- users 表若存在
ALTER TABLE `users` MODIFY COLUMN `password` VARCHAR(255) NULL COMMENT 'BCrypt hash or legacy';

-- 2) advater -> avatar 兼容迁移：新增 avatar 列并回填（保留 advater 以兼容老数据）
-- 若 avatar 已存在会报错；如你需要更稳健，可改用 information_schema + PREPARE 动态判断。
ALTER TABLE `user`
  ADD COLUMN `avatar` VARCHAR(512) NULL COMMENT '头像' AFTER `advater`;

UPDATE `user`
SET `avatar` = `advater`
WHERE `avatar` IS NULL AND `advater` IS NOT NULL;

-- 3) course.teacher_id 外键规范化：引用  users.id
-- 如你之前生成的 DDL 中 fk 名不同，请按实际 fk 名调整。
-- 先尝试删除旧外键（可能不存在）
-- ALTER TABLE `course` DROP FOREIGN KEY `fk_course_teacher_user`;

-- 新增外键（要求 users 表存在）
ALTER TABLE `course`
  ADD INDEX `idx_course_teacher_id` (`teacher_id`);

ALTER TABLE `course`
  ADD CONSTRAINT `fk_course_teacher_users`
  FOREIGN KEY (`teacher_id`) REFERENCES `users`(`id`)
  ON UPDATE RESTRICT ON DELETE RESTRICT;

-- 4) 审计表（若不存在则创建）
CREATE TABLE IF NOT EXISTS `sys_audit_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `actor_type` VARCHAR(32) NULL COMMENT '操作者类型：admin/biz/anonymous',
  `actor_id` BIGINT NULL COMMENT '操作者ID',
  `request_method` VARCHAR(16) NULL COMMENT 'HTTP方法',
  `request_path` VARCHAR(255) NULL COMMENT '请求路径',
  `success` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否成功',
  `error_message` VARCHAR(512) NULL COMMENT '错误摘要',
  `cost_ms` INT NULL COMMENT '耗时ms',
  `gmt_created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  INDEX `idx_audit_actor` (`actor_type`, `actor_id`),
  INDEX `idx_audit_path` (`request_path`),
  INDEX `idx_audit_created` (`gmt_created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='审计日志';

-- 5) JSON 索引：生成列 + 索引（要求 chapters/materials/task_points 为 JSON）
-- 如列不是 JSON，请先 ALTER TABLE course MODIFY chapters JSON ... 再执行。
ALTER TABLE `course`
  ADD COLUMN `chapters_count` INT GENERATED ALWAYS AS (JSON_LENGTH(`chapters`)) STORED COMMENT '章节数(生成列)',
  ADD COLUMN `materials_count` INT GENERATED ALWAYS AS (JSON_LENGTH(`materials`)) STORED COMMENT '资料数(生成列)',
  ADD COLUMN `task_points_count` INT GENERATED ALWAYS AS (JSON_LENGTH(`task_points`)) STORED COMMENT '任务点数(生成列)',
  ADD INDEX `idx_course_chapters_count` (`chapters_count`),
  ADD INDEX `idx_course_materials_count` (`materials_count`),
  ADD INDEX `idx_course_task_points_count` (`task_points_count`);



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

 Date: 09/03/2026 16:48:59
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for course
-- ----------------------------
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

-- ----------------------------
-- Records of course
-- ----------------------------

-- ----------------------------
-- Table structure for coursevisit
-- ----------------------------
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

-- ----------------------------
-- Records of coursevisit
-- ----------------------------

-- ----------------------------
-- Table structure for dict_live_session_status
-- ----------------------------
DROP TABLE IF EXISTS `dict_live_session_status`;
CREATE TABLE `dict_live_session_status`  (
  `status_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态编码',
  `status_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`status_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '直播课次状态字典（建议与live_session.status对齐）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dict_live_session_status
-- ----------------------------
INSERT INTO `dict_live_session_status` VALUES ('cancelled', '已取消', '直播取消/下线');
INSERT INTO `dict_live_session_status` VALUES ('ended', '已结束', '直播已结束');
INSERT INTO `dict_live_session_status` VALUES ('live', '直播中', '正在直播');
INSERT INTO `dict_live_session_status` VALUES ('scheduled', '已排期', '尚未开始');

-- ----------------------------
-- Table structure for dict_user_role
-- ----------------------------
DROP TABLE IF EXISTS `dict_user_role`;
CREATE TABLE `dict_user_role`  (
  `role_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色编码',
  `role_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`role_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户角色字典（建议与users.role对齐）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dict_user_role
-- ----------------------------
INSERT INTO `dict_user_role` VALUES ('admin', '管理员', '系统管理员（若将来与user表统一，可使用）');
INSERT INTO `dict_user_role` VALUES ('student', '学生', '业务用户：学习者');
INSERT INTO `dict_user_role` VALUES ('teacher', '教师', '业务用户：授课者');

-- ----------------------------
-- Table structure for learning_record
-- ----------------------------
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

-- ----------------------------
-- Records of learning_record
-- ----------------------------

-- ----------------------------
-- Table structure for live_session
-- ----------------------------
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

-- ----------------------------
-- Records of live_session
-- ----------------------------

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单名称/描述',
  `user_id` bigint NOT NULL COMMENT '关联用户ID（user.id）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_orders_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单（示例表，OrdersMapper与User做关联查询）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------

-- ----------------------------
-- Table structure for student
-- ----------------------------
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

-- ----------------------------
-- Records of student
-- ----------------------------

-- ----------------------------
-- Table structure for sys_audit_log
-- ----------------------------
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

-- ----------------------------
-- Records of sys_audit_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
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

-- ----------------------------
-- Records of sys_config
-- ----------------------------

-- ----------------------------
-- Table structure for sys_permission
-- ----------------------------
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

-- ----------------------------
-- Records of sys_permission
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
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

-- ----------------------------
-- Records of sys_role
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_permission`;
CREATE TABLE `sys_role_permission`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `perm_id` bigint NOT NULL COMMENT '权限ID',
  PRIMARY KEY (`role_id`, `perm_id`) USING BTREE,
  INDEX `fk_sys_rp_perm`(`perm_id` ASC) USING BTREE,
  CONSTRAINT `fk_sys_rp_perm` FOREIGN KEY (`perm_id`) REFERENCES `sys_permission` (`perm_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_sys_rp_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`role_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'RBAC：角色-权限关联（建议扩展）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_permission
-- ----------------------------

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `users_id` bigint NOT NULL COMMENT '业务用户ID（users.id）',
  `role_id` bigint NOT NULL COMMENT '角色ID（sys_role.role_id）',
  PRIMARY KEY (`users_id`, `role_id`) USING BTREE,
  INDEX `fk_sys_ur_role`(`role_id` ASC) USING BTREE,
  CONSTRAINT `fk_sys_ur_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`role_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_sys_ur_users` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'RBAC：用户-角色关联（建议扩展）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
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

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '120000:wB6CHdYqrXOAfyqajAoXww==:GP0LgYmg3l6vzCM04ZktSbdS+qxy0uGSklPI8t4p3Q0=', '2026-03-09 16:27:31', '测试数据:管理员用户', 0, '2026-03-09 11:33:15', '2026-03-09 11:33:15', NULL);

-- ----------------------------
-- Table structure for users
-- ----------------------------
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

-- ----------------------------
-- Records of users
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
