package com.example.mybatisplusdemo.service;

import com.example.mybatisplusdemo.model.dto.CourseVisitDTO;

import java.util.List;


public interface ICourseVisitService {
    List<CourseVisitDTO> getTop10Visits(String timeRange);
}