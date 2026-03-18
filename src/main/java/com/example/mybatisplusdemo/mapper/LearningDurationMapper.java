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
            "SELECT base.durationType AS durationType, IFNULL(agg.durationMinutes, 0) AS durationMinutes",
            "FROM (",
            "    SELECT '\\u89c6\\u9891' AS durationType",
            "    UNION ALL SELECT '\\u76f4\\u64ad'",
            "    UNION ALL SELECT '\\u9605\\u8bfb'",
            ") base",
            "LEFT JOIN (",
            "    SELECT",
            "        CASE",
            "            WHEN lr.task_point_id IS NOT NULL THEN '\\u89c6\\u9891'",
            "            WHEN lr.is_online = 1 THEN '\\u76f4\\u64ad'",
            "            ELSE '\\u9605\\u8bfb'",
            "        END AS durationType,",
            "        SUM(",
            "            CASE",
            "                WHEN lr.check_in_time IS NULL THEN 0",
            "                ELSE GREATEST(TIMESTAMPDIFF(MINUTE, lr.check_in_time, COALESCE(lr.last_updated, lr.check_in_time)), 0)",
            "            END",
            "        ) AS durationMinutes",
            "    FROM learning_record lr",
            "    JOIN course c ON c.course_id = lr.course_id",
            "    JOIN `user` u ON u.id = lr.user_id AND u.role = 'student' AND u.is_deleted = 0",
            "    WHERE (#{courseName} IS NULL OR c.title LIKE CONCAT('%', #{courseName}, '%'))",
            "      AND (#{collegeName} IS NULL OR u.department_name LIKE CONCAT('%', #{collegeName}, '%'))",
            "    GROUP BY CASE",
            "        WHEN lr.task_point_id IS NOT NULL THEN '\\u89c6\\u9891'",
            "        WHEN lr.is_online = 1 THEN '\\u76f4\\u64ad'",
            "        ELSE '\\u9605\\u8bfb'",
            "    END",
            ") agg ON agg.durationType = base.durationType",
            "</script>"
    })
    List<DurationDTO> selectDurations(@Param("courseName") String courseName, @Param("collegeName") String collegeName);
}
