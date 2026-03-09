package com.example.mybatisplusdemo.model.dto;

import lombok.Data;


@Data
public class ScoreDTO {
    private String courseName;
    private Double avgTotalScore;
    private Double avgAssignmentScore;
    private Double avgExamScore;
    private Double avgQuizScore;
    private Double courseCredit;
    private Double schoolAvgTotalScore;
    private Double schoolAvgAssignmentScore;
    private Double schoolAvgExamScore;
    private Double schoolAvgQuizScore;
    private Double schoolAvgCourseCredit;
}