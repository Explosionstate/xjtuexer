package com.example.mybatisplusdemo.web.controller;

import com.example.mybatisplusdemo.common.JsonResponse;
import com.example.mybatisplusdemo.model.dto.CourseAvgScoreDTO;
import com.example.mybatisplusdemo.service.ICourseAvgScoresService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/avgScores")
public class CourseAvgScoresController {

    @Autowired
    private ICourseAvgScoresService avgScoresService;

    @GetMapping("/courseAvgScores")
    public JsonResponse getCourseAvgScores(
            @RequestParam(required = false) String college,
            @RequestParam(required = false) String semester) {
        List<CourseAvgScoreDTO> scores = avgScoresService.getCourseAvgScores(college, semester);
        return JsonResponse.success(scores);
    }
}