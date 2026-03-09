package com.example.mybatisplusdemo.service.impl;

import com.example.mybatisplusdemo.mapper.CourseCompletionMapper;
import com.example.mybatisplusdemo.model.dto.CourseCompletionDTO;
import com.example.mybatisplusdemo.service.ICourseCompletionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CourseCompletionServiceImpl implements ICourseCompletionService {

    @Autowired
    private CourseCompletionMapper courseCompletionMapper;

    @Override
    public List<CourseCompletionDTO> getCompletions(String group1College, String group2College, String group1Course, String group2Course, String group1Semester, String group2Semester) {
        // 验证学期参数
        String validGroup1Semester = switch (group1Semester) {
            case "2024-2025学年", "2025-2026学年" -> group1Semester;
            default -> "2025-2026学年";
        };
        String validGroup2Semester = switch (group2Semester) {
            case "2024-2025学年", "2025-2026学年" -> group2Semester;
            default -> "2025-2026学年";
        };
        return courseCompletionMapper.selectCompletions(group1College, group2College, group1Course, group2Course, validGroup1Semester, validGroup2Semester);
    }
}