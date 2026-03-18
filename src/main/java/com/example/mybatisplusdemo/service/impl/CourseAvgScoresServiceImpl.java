package com.example.mybatisplusdemo.service.impl;

import com.example.mybatisplusdemo.mapper.CourseAvgScoresMapper;
import com.example.mybatisplusdemo.model.dto.CourseAvgScoreDTO;
import com.example.mybatisplusdemo.service.ICourseAvgScoresService;
import com.example.mybatisplusdemo.service.support.SchemaInspectorService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class CourseAvgScoresServiceImpl implements ICourseAvgScoresService {

    private final CourseAvgScoresMapper avgScoresMapper;
    private final SchemaInspectorService schemaInspectorService;

    public CourseAvgScoresServiceImpl(CourseAvgScoresMapper avgScoresMapper,
                                      SchemaInspectorService schemaInspectorService) {
        this.avgScoresMapper = avgScoresMapper;
        this.schemaInspectorService = schemaInspectorService;
    }

    @Override
    public List<CourseAvgScoreDTO> getCourseAvgScores(String college, String semester) {
        String normalizedCollege = normalize(college);
        String normalizedSemester = normalize(semester);
        boolean useFact = schemaInspectorService.hasTable("fact_course_score");
        try {
            if (useFact) {
                return avgScoresMapper.selectCourseAvgScoresFromFact(normalizedCollege, normalizedSemester);
            }
            return avgScoresMapper.selectCourseAvgScores(normalizedCollege, normalizedSemester);
        } catch (Exception ignored) {
            if (useFact) {
                return avgScoresMapper.selectCourseAvgScores(normalizedCollege, normalizedSemester);
            }
            throw ignored;
        }
    }

    private String normalize(String value) {
        if (!StringUtils.hasText(value)) {
            return null;
        }
        return value.trim();
    }
}
