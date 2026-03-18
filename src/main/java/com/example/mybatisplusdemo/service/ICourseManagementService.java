package com.example.mybatisplusdemo.service;

import com.example.mybatisplusdemo.model.dto.CourseManagementMetaDTO;
import com.example.mybatisplusdemo.model.dto.CourseScoreRequest;
import com.example.mybatisplusdemo.model.dto.CourseStudentDTO;
import com.example.mybatisplusdemo.model.dto.CourseStudentRequest;

import java.util.List;

public interface ICourseManagementService {
    CourseManagementMetaDTO getMeta();

    List<CourseStudentDTO> getCourseStudents(Long courseId);

    void addStudentToCourse(CourseStudentRequest request);

    CourseStudentDTO saveCourseScore(CourseScoreRequest request);
}
