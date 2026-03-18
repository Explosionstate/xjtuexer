package com.example.mybatisplusdemo.web.controller;

import com.example.mybatisplusdemo.common.JsonResponse;
import com.example.mybatisplusdemo.model.dto.CourseCompletionDTO;
import com.example.mybatisplusdemo.service.ICourseCompletionService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/completion")
public class CourseCompletionController {

    private final ICourseCompletionService courseCompletionService;

    public CourseCompletionController(ICourseCompletionService courseCompletionService) {
        this.courseCompletionService = courseCompletionService;
    }

    @GetMapping("/completions")
    public JsonResponse<List<CourseCompletionDTO>> getCompletions(
            @RequestParam(name = "group1College", required = false, defaultValue = "全校") String group1College,
            @RequestParam(name = "group2College", required = false, defaultValue = "全校") String group2College,
            @RequestParam(name = "group1Course", required = false) String group1Course,
            @RequestParam(name = "group2Course", required = false) String group2Course,
            @RequestParam("group1Semester") String group1Semester,
            @RequestParam("group2Semester") String group2Semester) {
        List<CourseCompletionDTO> completions = courseCompletionService.getCompletions(
                group1College, group2College, group1Course, group2Course, group1Semester, group2Semester);
        return JsonResponse.success(completions);
    }
}
