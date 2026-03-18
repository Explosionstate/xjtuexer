package com.example.mybatisplusdemo.model.dto;

import lombok.Data;

import java.util.List;

@Data
public class CourseManagementMetaDTO {
    private List<CourseSummaryDTO> courses;
    private List<TeacherOptionDTO> teachers;
    private List<String> colleges;
    private List<TermOptionDTO> terms;
    private List<String> academicYears;
    private Long currentTermId;
    private String currentTermName;
}
