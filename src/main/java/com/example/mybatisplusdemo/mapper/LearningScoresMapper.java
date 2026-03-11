package com.example.mybatisplusdemo.mapper;

import com.example.mybatisplusdemo.model.dto.ScoreDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface LearningScoresMapper {

    @Select({
            "<script>",
            "SELECT",
            "    c.title AS courseName,",
            "    ROUND(AVG(st.learning_scores), 2) AS avgTotalScore,",
            "    ROUND(AVG(st.average_course_scores), 2) AS avgAssignmentScore,",
            "    ROUND(AVG((IFNULL(st.learning_scores, 0) + IFNULL(st.average_course_scores, 0)) / 2), 2) AS avgExamScore,",
            "    ROUND(AVG(st.average_course_scores), 2) AS avgQuizScore,",
            "    ROUND(AVG(IFNULL(JSON_LENGTH(c.chapters), 0)), 2) AS courseCredit",
            "FROM (SELECT DISTINCT course_id, user_id, check_in_time FROM learning_record) lr",
            "JOIN course c ON c.course_id = lr.course_id",
            "JOIN student st ON st.student_id = lr.user_id",
            "JOIN `user` u ON u.id = st.student_id AND u.role = 'student' AND u.is_deleted = 0",
            "WHERE (#{course} IS NULL OR c.title = #{course})",
            "  AND (#{college} IS NULL OR u.department_name = #{college})",
            "  AND (#{startDate} IS NULL OR DATE(lr.check_in_time) &gt;= #{startDate})",
            "  AND (#{endDate} IS NULL OR DATE(lr.check_in_time) &lt;= #{endDate})",
            "GROUP BY c.title",
            "</script>"
    })
    List<ScoreDTO> selectCourseScores(
            @Param("course") String course,
            @Param("college") String college,
            @Param("startDate") String startDate,
            @Param("endDate") String endDate
    );
}
