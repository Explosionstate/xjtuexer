package com.example.mybatisplusdemo.model.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CourseSummaryDTO {
    private Long courseId;
    private String title;
    private Long teacherId;
    private String teacherName;
    private Long studentCount;
    private Long scoreCount;
    private LocalDateTime gmtCreated;
}
