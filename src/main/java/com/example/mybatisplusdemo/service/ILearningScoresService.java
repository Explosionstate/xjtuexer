package com.example.mybatisplusdemo.service;

import com.example.mybatisplusdemo.model.dto.ScoreDTO;

import java.util.List;


public interface ILearningScoresService {
    List<ScoreDTO> getCourseScores(String course, String college, String startDate, String endDate);
}