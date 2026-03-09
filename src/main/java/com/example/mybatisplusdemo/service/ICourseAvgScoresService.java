package com.example.mybatisplusdemo.service;

import com.example.mybatisplusdemo.model.dto.CourseAvgScoreDTO;

import java.util.List;

public interface ICourseAvgScoresService {
    List<CourseAvgScoreDTO> getCourseAvgScores(String college, String semester);
}