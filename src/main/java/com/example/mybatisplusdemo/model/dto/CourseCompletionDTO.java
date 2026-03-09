package com.example.mybatisplusdemo.model.dto;

import lombok.Data;

@Data
public class CourseCompletionDTO {
    private String courseName;
    private String college;
    private String semester;
    private Double taskCompletionRate;
    private Double videoCompletionRate;
    private Double quizCompletionRate;
    private Double assignmentCompletionRate;
    private Double examCompletionRate;
    private Integer chapterStudyCount;
    private Double checkinCompletionRate;
    private Double schoolTaskCompletionRate;
    private Double schoolVideoCompletionRate;
    private Double schoolQuizCompletionRate;
    private Double schoolAssignmentCompletionRate;
    private Double schoolExamCompletionRate;
    private Integer schoolChapterStudyCount;
    private Double schoolCheckinCompletionRate;
}