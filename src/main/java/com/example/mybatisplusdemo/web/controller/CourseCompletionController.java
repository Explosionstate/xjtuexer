package com.example.mybatisplusdemo.web.controller;

import com.example.mybatisplusdemo.common.JsonResponse;
import com.example.mybatisplusdemo.model.dto.CourseCompletionDTO;
import com.example.mybatisplusdemo.service.ICourseCompletionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/completion")
public class CourseCompletionController {

    @Autowired
    private ICourseCompletionService courseCompletionService;

    @GetMapping("/completions")
    public JsonResponse getCompletions(
            @RequestParam(required = false, defaultValue = "全校") String group1College,
            @RequestParam(required = false, defaultValue = "全校") String group2College,
            @RequestParam(required = false) String group1Course,
            @RequestParam(required = false) String group2Course,
            @RequestParam String group1Semester,
            @RequestParam String group2Semester) {
        List<CourseCompletionDTO> completions = courseCompletionService.getCompletions(
                group1College, group2College, group1Course, group2Course, group1Semester, group2Semester);
        return JsonResponse.success(completions);
    }
}