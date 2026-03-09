package com.example.mybatisplusdemo.service.impl;

import com.example.mybatisplusdemo.mapper.CourseAvgScoresMapper;
import com.example.mybatisplusdemo.model.dto.CourseAvgScoreDTO;
import com.example.mybatisplusdemo.service.ICourseAvgScoresService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CourseAvgScoresServiceImpl implements ICourseAvgScoresService {

    @Autowired
    private CourseAvgScoresMapper avgScoresMapper;

    @Override
    public List<CourseAvgScoreDTO> getCourseAvgScores(String college, String semester) {
        // 默认使用最新学期 2024-2025秋
        if (semester == null || semester.isEmpty()) {
            semester = "2024-2025秋";
        }
        return avgScoresMapper.selectCourseAvgScores(college, semester);
    }
}