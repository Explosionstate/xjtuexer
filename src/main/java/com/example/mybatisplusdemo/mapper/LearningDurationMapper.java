package com.example.mybatisplusdemo.mapper;

import com.example.mybatisplusdemo.model.dto.DurationDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface LearningDurationMapper {

    @Select({
            "<script>",
            "SELECT '\\u89c6\\u9891' AS durationType, IFNULL(SUM(CASE WHEN lr.task_point_id IS NOT NULL THEN 20 ELSE 0 END), 0) AS durationMinutes",
            "FROM learning_record lr",
            "JOIN course c ON c.course_id = lr.course_id",
            "JOIN `user` u ON u.id = lr.user_id AND u.role = 'student' AND u.is_deleted = 0",
            "WHERE (#{courseName} IS NULL OR c.title = #{courseName})",
            "  AND (#{collegeName} IS NULL OR u.department_name = #{collegeName})",
            "UNION ALL",
            "SELECT '\\u76f4\\u64ad' AS durationType, IFNULL(SUM(CASE WHEN lr.is_online = 1 THEN 45 ELSE 0 END), 0) AS durationMinutes",
            "FROM learning_record lr",
            "JOIN course c ON c.course_id = lr.course_id",
            "JOIN `user` u ON u.id = lr.user_id AND u.role = 'student' AND u.is_deleted = 0",
            "WHERE (#{courseName} IS NULL OR c.title = #{courseName})",
            "  AND (#{collegeName} IS NULL OR u.department_name = #{collegeName})",
            "UNION ALL",
            "SELECT '\\u9605\\u8bfb' AS durationType, IFNULL(SUM(CASE WHEN lr.check_in_time IS NOT NULL THEN 15 ELSE 0 END), 0) AS durationMinutes",
            "FROM learning_record lr",
            "JOIN course c ON c.course_id = lr.course_id",
            "JOIN `user` u ON u.id = lr.user_id AND u.role = 'student' AND u.is_deleted = 0",
            "WHERE (#{courseName} IS NULL OR c.title = #{courseName})",
            "  AND (#{collegeName} IS NULL OR u.department_name = #{collegeName})",
            "</script>"
    })
    List<DurationDTO> selectDurations(@Param("courseName") String courseName, @Param("collegeName") String collegeName);
}