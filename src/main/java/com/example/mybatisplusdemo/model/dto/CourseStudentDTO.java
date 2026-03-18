package com.example.mybatisplusdemo.model.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class CourseStudentDTO {
    private Long relationId;
    private Long courseId;
    private Long studentId;
    private String studentNo;
    private String studentName;
    private String college;
    private Long scoreId;
    private Long termId;
    private String termName;
    private BigDecimal usualScore;
    private BigDecimal finalScore;
    private BigDecimal gpaPoint;
    private Boolean passed;
    private Boolean linkedLearningRecord;
}
