package com.example.mybatisplusdemo.model.dto;

import lombok.Data;


@Data
public class CourseVisitDTO {
    private Long courseId;
    private String courseName;
    private Long visitCount;
}
