package com.example.mybatisplusdemo.model.domain;

import lombok.Data;


@Data
public class CourseVisit {
    private String courseName;
    private Integer today;
    private Integer thisWeek;
    private Integer thisMonth;
    private Integer thisYear;
}