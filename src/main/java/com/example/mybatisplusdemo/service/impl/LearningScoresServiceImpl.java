package com.example.mybatisplusdemo.service.impl;

import com.example.mybatisplusdemo.mapper.LearningScoresMapper;
import com.example.mybatisplusdemo.model.dto.ScoreDTO;
import com.example.mybatisplusdemo.service.ILearningScoresService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LearningScoresServiceImpl implements ILearningScoresService {

    @Autowired
    private LearningScoresMapper learningScoresMapper;

    @Override
    public List<ScoreDTO> getCourseScores(String course, String college, String startDate, String endDate) {
        // 获取筛选结果的平均成绩
        List<ScoreDTO> scores = learningScoresMapper.selectCourseScores(
                course.isEmpty() ? null : course,
                college.isEmpty() ? null : college,
                startDate.isEmpty() ? null : startDate,
                endDate.isEmpty() ? null : endDate
        );

        // 获取全校平均成绩（无学院筛选）
        List<ScoreDTO> schoolScores = learningScoresMapper.selectCourseScores(
                course.isEmpty() ? null : course,
                null,
                startDate.isEmpty() ? null : startDate,
                endDate.isEmpty() ? null : endDate
        );


        // 合并全校平均成绩到结果中
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
}