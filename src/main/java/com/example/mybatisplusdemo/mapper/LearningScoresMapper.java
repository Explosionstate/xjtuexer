package com.example.mybatisplusdemo.mapper;

import com.example.mybatisplusdemo.model.dto.ScoreDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;


@Mapper
public interface LearningScoresMapper {
    @Select("SELECT course AS courseName, " +
            "AVG(avg_total_score) AS avgTotalScore, " +
            "AVG(avg_assignment_score) AS avgAssignmentScore, " +
            "AVG(avg_exam_score) AS avgExamScore, " +
            "AVG(avg_quiz_score) AS avgQuizScore, " +
            "AVG(course_credit) AS courseCredit " +
            "FROM learning_scores " +
            "WHERE (#{course} IS NULL OR course = #{course}) " +
            "AND (#{college} IS NULL OR college = #{college}) " +
            "AND (#{startDate} IS NULL OR record_date >= #{startDate}) " +
            "AND (#{endDate} IS NULL OR record_date <= #{endDate}) " +
            "GROUP BY course")
    List<ScoreDTO> selectCourseScores(String course, String college, String startDate, String endDate);
}