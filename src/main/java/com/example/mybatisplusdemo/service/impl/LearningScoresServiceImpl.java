package com.example.mybatisplusdemo.service.impl;

import com.example.mybatisplusdemo.mapper.LearningScoresMapper;
import com.example.mybatisplusdemo.model.dto.ScoreDTO;
import com.example.mybatisplusdemo.service.ILearningScoresService;
import com.example.mybatisplusdemo.service.support.SchemaInspectorService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class LearningScoresServiceImpl implements ILearningScoresService {

    private final LearningScoresMapper learningScoresMapper;
    private final SchemaInspectorService schemaInspectorService;

    public LearningScoresServiceImpl(LearningScoresMapper learningScoresMapper,
                                     SchemaInspectorService schemaInspectorService) {
        this.learningScoresMapper = learningScoresMapper;
        this.schemaInspectorService = schemaInspectorService;
    }

    @Override
    public List<ScoreDTO> getCourseScores(String course, String college, String startDate, String endDate) {
        String normalizedCourse = normalize(course);
        String normalizedCollege = normalize(college);
        String normalizedStartDate = normalize(startDate);
        String normalizedEndDate = normalize(endDate);
        boolean useFactScoreTable = schemaInspectorService.hasTable("fact_course_score");

        List<ScoreDTO> legacyScores = learningScoresMapper.selectCourseScores(
                normalizedCourse, normalizedCollege, normalizedStartDate, normalizedEndDate);
        List<ScoreDTO> legacySchoolScores = learningScoresMapper.selectCourseScores(
                normalizedCourse, null, normalizedStartDate, normalizedEndDate);

        List<ScoreDTO> scores = legacyScores;
        List<ScoreDTO> schoolScores = legacySchoolScores;
        try {
            if (useFactScoreTable) {
                List<ScoreDTO> factScores = learningScoresMapper.selectCourseScoresFromFact(
                        normalizedCourse, normalizedCollege, normalizedStartDate, normalizedEndDate);
                List<ScoreDTO> factSchoolScores = learningScoresMapper.selectCourseScoresFromFact(
                        normalizedCourse, null, normalizedStartDate, normalizedEndDate);
                scores = mergeScores(legacyScores, factScores);
                schoolScores = mergeScores(legacySchoolScores, factSchoolScores);
            }
        } catch (Exception ignored) {
            scores = legacyScores;
            schoolScores = legacySchoolScores;
        }

        Map<String, ScoreDTO> schoolScoreMap = new LinkedHashMap<>();
        for (ScoreDTO school : schoolScores) {
            if (school == null || school.getCourseName() == null) {
                continue;
            }
            schoolScoreMap.put(school.getCourseName(), school);
        }

        for (ScoreDTO dto : scores) {
            if (dto == null || dto.getCourseName() == null) {
                continue;
            }
            ScoreDTO school = schoolScoreMap.get(dto.getCourseName());
            if (school == null) {
                continue;
            }
            dto.setSchoolAvgTotalScore(school.getAvgTotalScore());
            dto.setSchoolAvgAssignmentScore(school.getAvgAssignmentScore());
            dto.setSchoolAvgExamScore(school.getAvgExamScore());
            dto.setSchoolAvgQuizScore(school.getAvgQuizScore());
            dto.setSchoolAvgCourseCredit(school.getCourseCredit());
        }

        return scores;
    }

    private String normalize(String value) {
        if (!StringUtils.hasText(value)) {
            return null;
        }
        return value.trim();
    }

    private List<ScoreDTO> mergeScores(List<ScoreDTO> legacyScores, List<ScoreDTO> factScores) {
        Map<String, ScoreDTO> merged = new LinkedHashMap<>();
        putScores(merged, legacyScores);
        putScores(merged, factScores);
        return new ArrayList<>(merged.values());
    }

    private void putScores(Map<String, ScoreDTO> target, List<ScoreDTO> source) {
        if (source == null) {
            return;
        }
        for (ScoreDTO dto : source) {
            if (dto == null || dto.getCourseName() == null) {
                continue;
            }
            target.put(dto.getCourseName(), dto);
        }
    }
}
