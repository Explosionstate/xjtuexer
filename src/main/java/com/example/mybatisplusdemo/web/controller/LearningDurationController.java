package com.example.mybatisplusdemo.web.controller;

import com.example.mybatisplusdemo.common.JsonResponse;
import com.example.mybatisplusdemo.model.dto.DurationDTO;
import com.example.mybatisplusdemo.service.ILearningDurationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/learningduration")
public class LearningDurationController {

    @Autowired
    private ILearningDurationService learningDurationService;

    @GetMapping("/durations")
    public JsonResponse getDurations(
            @RequestParam(required = false) String courseName,
            @RequestParam(required = false) String collegeName) {
        List<DurationDTO> durations = learningDurationService.getDurations(courseName, collegeName);
        return JsonResponse.success(durations);
    }
}