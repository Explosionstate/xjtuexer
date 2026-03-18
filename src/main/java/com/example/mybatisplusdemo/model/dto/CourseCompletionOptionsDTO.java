package com.example.mybatisplusdemo.model.dto;

import lombok.Data;

import java.util.List;

@Data
public class CourseCompletionOptionsDTO {
    private List<String> colleges;
    private List<String> courses;
    private List<String> semesters;
}
