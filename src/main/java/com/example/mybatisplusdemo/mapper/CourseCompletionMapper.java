package com.example.mybatisplusdemo.mapper;

import com.example.mybatisplusdemo.model.dto.CourseCompletionDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;


import java.util.List;

@Mapper
public interface CourseCompletionMapper {
    @Select("<script>" +
            "SELECT c1.course_name AS courseName, c1.college AS college, c1.semester AS semester, " +
            "c1.task_completion_rate AS taskCompletionRate, c1.video_completion_rate AS videoCompletionRate, " +
            "c1.quiz_completion_rate AS quizCompletionRate, c1.assignment_completion_rate AS assignmentCompletionRate, " +
            "c1.exam_completion_rate AS examCompletionRate, c1.chapter_study_count AS chapterStudyCount, " +
            "c1.checkin_completion_rate AS checkinCompletionRate, " +
            "c2.task_completion_rate AS schoolTaskCompletionRate, c2.video_completion_rate AS schoolVideoCompletionRate, " +
            "c2.quiz_completion_rate AS schoolQuizCompletionRate, c2.assignment_completion_rate AS schoolAssignmentCompletionRate, " +
            "c2.exam_completion_rate AS schoolExamCompletionRate, c2.chapter_study_count AS schoolChapterStudyCount, " +
            "c2.checkin_completion_rate AS schoolCheckinCompletionRate " +
            "FROM course_completion c1 " +
            "LEFT JOIN course_completion c2 ON c2.course_name = c1.course_name AND c2.semester = c1.semester AND c2.college = '全校' " +
            "WHERE (c1.college = #{group1College} AND c1.semester = #{group1Semester} " +
            "<if test='group1Course != null and group1Course != \"\"'> AND c1.course_name = #{group1Course} </if>) " +
            "OR (c1.college = #{group2College} AND c1.semester = #{group2Semester} " +
            "<if test='group2Course != null and group2Course != \"\"'> AND c1.course_name = #{group2Course} </if>) " +
            "</script>")
    List<CourseCompletionDTO> selectCompletions(String group1College, String group2College, String group1Course, String group2Course, String group1Semester, String group2Semester);
}