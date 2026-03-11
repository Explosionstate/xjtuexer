package com.example.mybatisplusdemo.mapper;

import com.example.mybatisplusdemo.model.dto.CourseAvgScoreDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface CourseAvgScoresMapper {

    @Select({
            "<script>",
            "SELECT",
            "    g.course_name AS courseName,",
            "    g.college AS college,",
            "    COALESCE(NULLIF(#{semester}, ''), 'current') AS semester,",
            "    ROUND(g.avg_score_group, 2) AS avgScoreGroup,",
            "    ROUND(s.avg_score_school, 2) AS avgScoreSchool",
            "FROM (",
            "    SELECT",
            "        c.title AS course_name,",
            "        u.department_name AS college,",
            "        AVG(st.average_course_scores) AS avg_score_group",
            "    FROM (SELECT DISTINCT course_id, user_id FROM learning_record) lr",
            "    JOIN student st ON st.student_id = lr.user_id",
            "    JOIN `user` u ON u.id = st.student_id AND u.role = 'student' AND u.is_deleted = 0",
            "    JOIN course c ON c.course_id = lr.course_id",
            "    WHERE st.average_course_scores IS NOT NULL",
            "    GROUP BY c.title, u.department_name",
            ") g",
            "JOIN (",
            "    SELECT",
            "        c.title AS course_name,",
            "        AVG(st.average_course_scores) AS avg_score_school",
            "    FROM (SELECT DISTINCT course_id, user_id FROM learning_record) lr",
            "    JOIN student st ON st.student_id = lr.user_id",
            "    JOIN `user` u ON u.id = st.student_id AND u.role = 'student' AND u.is_deleted = 0",
            "    JOIN course c ON c.course_id = lr.course_id",
            "    WHERE st.average_course_scores IS NOT NULL",
            "    GROUP BY c.title",
            ") s ON s.course_name = g.course_name",
            "<if test='college != null and college != \"\"'>",
            "    WHERE g.college = #{college}",
            "</if>",
            "UNION ALL",
            "SELECT",
            "    s.course_name AS courseName,",
            "    '\\u5168\\u6821' AS college,",
            "    COALESCE(NULLIF(#{semester}, ''), 'current') AS semester,",
            "    ROUND(s.avg_score_school, 2) AS avgScoreGroup,",
            "    ROUND(s.avg_score_school, 2) AS avgScoreSchool",
            "FROM (",
            "    SELECT",
            "        c.title AS course_name,",
            "        AVG(st.average_course_scores) AS avg_score_school",
            "    FROM (SELECT DISTINCT course_id, user_id FROM learning_record) lr",
            "    JOIN student st ON st.student_id = lr.user_id",
            "    JOIN `user` u ON u.id = st.student_id AND u.role = 'student' AND u.is_deleted = 0",
            "    JOIN course c ON c.course_id = lr.course_id",
            "    WHERE st.average_course_scores IS NOT NULL",
            "    GROUP BY c.title",
            ") s",
            "ORDER BY courseName, college",
            "</script>"
    })
    List<CourseAvgScoreDTO> selectCourseAvgScores(@Param("college") String college, @Param("semester") String semester);
}