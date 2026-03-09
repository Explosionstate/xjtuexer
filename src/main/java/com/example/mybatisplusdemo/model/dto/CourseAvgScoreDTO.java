package com.example.mybatisplusdemo.model.dto;

import lombok.Data;

@Data
public class CourseAvgScoreDTO {
    private String courseName;
    private String college;
    private String semester;
    private Float avgScoreGroup;
    private Float avgScoreSchool;
}