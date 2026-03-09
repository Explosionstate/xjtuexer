package com.example.mybatisplusdemo.service.impl;

import com.example.mybatisplusdemo.mapper.CourseVisitMapper;
import com.example.mybatisplusdemo.model.dto.CourseVisitDTO;
import com.example.mybatisplusdemo.service.ICourseVisitService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class CourseVisitServiceImpl implements ICourseVisitService {

    @Autowired
    private CourseVisitMapper courseVisitMapper;

    @Override
    public List<CourseVisitDTO> getTop10Visits(String timeRange) {
        String validTimeRange = switch (timeRange) {
            case "today" -> "today";
            case "week" -> "thisweek";
            case "month" -> "thismonth";
            case "year" -> "thisyear";
            default -> "thisyear";
        };
        return courseVisitMapper.selectTop10Visits(validTimeRange);
    }
}