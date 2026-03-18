package com.example.mybatisplusdemo.service.impl;

import com.example.mybatisplusdemo.mapper.LearningScoresMapper;
import com.example.mybatisplusdemo.model.dto.ScoreDTO;
import com.example.mybatisplusdemo.service.ILearningScoresService;
import com.example.mybatisplusdemo.service.support.SchemaInspectorService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

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

        List<ScoreDTO> scores = useFactScoreTable
                ? learningScoresMapper.selectCourseScoresFromFact(
                normalizedCourse, normalizedCollege, normalizedStartDate, normalizedEndDate)
                : learningScoresMapper.selectCourseScores(
                normalizedCourse, normalizedCollege, normalizedStartDate, normalizedEndDate);

        List<ScoreDTO> schoolScores = useFactScoreTable
                ? learningScoresMapper.selectCourseScoresFromFact(
                normalizedCourse, null, normalizedStartDate, normalizedEndDate)
                : learningScoresMapper.selectCourseScores(
                normalizedCourse, null, normalizedStartDate, normalizedEndDate);

        scores.forEach(dto -> {
            schoolScores.stream()
                    .filter(s -> s.getCourseName().equals(dto.getCourseName()))
                    .findFirst()
                    .ifPresent(s -> {
                        dto.setSchoolAvgTotalScore(s.getAvgTotalScore());
                        dto.setSchoolAvgAssignmentScore(s.getAvgAssignmentScore());
                        dto.setSchoolAvgExamScore(s.getAvgExamScore());
                        dto.setSchoolAvgQuizScore(s.getAvgQuizScore());
                        dto.setSchoolAvgCourseCredit(s.getCourseCredit());
                    });
        });

        return scores;
    }

    private String normalize(String value) {
        if (!StringUtils.hasText(value)) {
            return null;
        }
        return value.trim();
    }
}
