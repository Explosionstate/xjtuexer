package com.example.mybatisplusdemo.model.dto;

import lombok.Data;

@Data
public class CourseStudentRequest {
    private Long courseId;
    private Long studentId;
}
