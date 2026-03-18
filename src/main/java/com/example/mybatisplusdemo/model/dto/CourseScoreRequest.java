package com.example.mybatisplusdemo.model.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class CourseScoreRequest {
    private Long courseId;
    private Long studentId;
    private Long termId;
    private BigDecimal usualScore;
    private BigDecimal finalScore;
    private BigDecimal gpaPoint;
    private Boolean passed;
}
