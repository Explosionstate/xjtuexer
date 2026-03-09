package com.example.mybatisplusdemo.service.impl;

import com.example.mybatisplusdemo.mapper.CourseVisitMapper;
import com.example.mybatisplusdemo.model.dto.CourseVisitDTO;
import com.example.mybatisplusdemo.service.ICourseVisitService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Set;

@Service
public class CourseVisitServiceImpl implements ICourseVisitService {

    private static final Set<String> ALLOWED = Set.of("today", "week", "month", "year");

    private final CourseVisitMapper courseVisitMapper;

    public CourseVisitServiceImpl(CourseVisitMapper courseVisitMapper) {
        this.courseVisitMapper = courseVisitMapper;
    }

    @Override
    public List<CourseVisitDTO> getTop10Visits(String timeRange) {
        String tr = (StringUtils.hasText(timeRange) ? timeRange.trim().toLowerCase() : "year");
        if (!ALLOWED.contains(tr)) {
            tr = "year";
        }
        return courseVisitMapper.selectTop10Visits(tr);
    }
}
