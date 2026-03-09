package com.example.mybatisplusdemo.web.controller;

import com.example.mybatisplusdemo.common.JsonResponse;
import com.example.mybatisplusdemo.model.dto.ScoreDTO;
import com.example.mybatisplusdemo.service.ILearningScoresService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/scores")
public class LearningScoresController {

    @Autowired
    private ILearningScoresService learningScoresService;

    @GetMapping("/courseScores")
    public JsonResponse getCourseScores(
            @RequestParam(required = false, defaultValue = "") String course,
            @RequestParam(required = false, defaultValue = "") String college,
            @RequestParam(required = false, defaultValue = "") String startDate,
            @RequestParam(required = false, defaultValue = "") String endDate
    ) {
        List<ScoreDTO> scores = learningScoresService.getCourseScores(course, college, startDate, endDate);
        return JsonResponse.success(scores);
    }
}