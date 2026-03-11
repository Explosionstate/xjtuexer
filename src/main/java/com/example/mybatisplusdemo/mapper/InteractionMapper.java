package com.example.mybatisplusdemo.mapper;

import com.example.mybatisplusdemo.model.dto.InteractionDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface InteractionMapper {

    @Select({
            "<script>",
            "SELECT t.interactionType, t.interactionCount",
            "FROM (",
            "    SELECT '\\u7b7e\\u5230' AS interactionType, COUNT(*) AS interactionCount",
            "    FROM learning_record lr",
            "    JOIN course c ON c.course_id = lr.course_id",
            "    JOIN `user` u ON u.id = lr.user_id AND u.role = 'student' AND u.is_deleted = 0",
            "    WHERE lr.check_in_time IS NOT NULL",
            "      AND (#{courseName} IS NULL OR c.title = #{courseName})",
            "      AND (#{collegeName} IS NULL OR u.department_name = #{collegeName})",
            "      AND (#{startTime} IS NULL OR lr.last_updated &gt;= #{startTime})",
            "      AND (#{endTime} IS NULL OR lr.last_updated &lt;= #{endTime})",
            "    UNION ALL",
            "    SELECT '\\u4efb\\u52a1\\u70b9' AS interactionType, COUNT(*) AS interactionCount",
            "    FROM learning_record lr",
            "    JOIN course c ON c.course_id = lr.course_id",
            "    JOIN `user` u ON u.id = lr.user_id AND u.role = 'student' AND u.is_deleted = 0",
            "    WHERE lr.task_point_id IS NOT NULL",
            "      AND (#{courseName} IS NULL OR c.title = #{courseName})",
            "      AND (#{collegeName} IS NULL OR u.department_name = #{collegeName})",
            "      AND (#{startTime} IS NULL OR lr.last_updated &gt;= #{startTime})",
            "      AND (#{endTime} IS NULL OR lr.last_updated &lt;= #{endTime})",
            "    UNION ALL",
            "    SELECT '\\u5728\\u7ebf' AS interactionType, COUNT(*) AS interactionCount",
            "    FROM learning_record lr",
            "    JOIN course c ON c.course_id = lr.course_id",
            "    JOIN `user` u ON u.id = lr.user_id AND u.role = 'student' AND u.is_deleted = 0",
            "    WHERE lr.is_online = 1",
            "      AND (#{courseName} IS NULL OR c.title = #{courseName})",
            "      AND (#{collegeName} IS NULL OR u.department_name = #{collegeName})",
            "      AND (#{startTime} IS NULL OR lr.last_updated &gt;= #{startTime})",
            "      AND (#{endTime} IS NULL OR lr.last_updated &lt;= #{endTime})",
            ") t",
            "WHERE t.interactionCount &gt; 0",
            "</script>"
    })
    List<InteractionDTO> selectInteractions(
            @Param("courseName") String courseName,
            @Param("collegeName") String collegeName,
            @Param("startTime") String startTime,
            @Param("endTime") String endTime
    );
}