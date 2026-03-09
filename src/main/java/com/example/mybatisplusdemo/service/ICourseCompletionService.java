package com.example.mybatisplusdemo.service;

import com.example.mybatisplusdemo.model.dto.CourseCompletionDTO;

import java.util.List;

public interface ICourseCompletionService {
    List<CourseCompletionDTO> getCompletions(String group1College, String group2College, String group1Course, String group2Course, String group1Semester, String group2Semester);
}