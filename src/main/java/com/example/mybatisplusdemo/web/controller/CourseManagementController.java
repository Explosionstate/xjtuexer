package com.example.mybatisplusdemo.web.controller;

import com.example.mybatisplusdemo.common.JsonResponse;
import com.example.mybatisplusdemo.model.dto.CourseManagementMetaDTO;
import com.example.mybatisplusdemo.model.dto.CourseScoreRequest;
import com.example.mybatisplusdemo.model.dto.CourseStudentDTO;
import com.example.mybatisplusdemo.model.dto.CourseStudentRequest;
import com.example.mybatisplusdemo.service.ICourseManagementService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/course-management")
public class CourseManagementController {

    private final ICourseManagementService courseManagementService;

    public CourseManagementController(ICourseManagementService courseManagementService) {
        this.courseManagementService = courseManagementService;
    }

    @GetMapping("/meta")
    public JsonResponse<CourseManagementMetaDTO> getMeta() {
        return JsonResponse.success(courseManagementService.getMeta());
    }

    @GetMapping("/course-students")
    public JsonResponse<List<CourseStudentDTO>> getCourseStudents(@RequestParam("courseId") Long courseId) {
        return JsonResponse.success(courseManagementService.getCourseStudents(courseId));
    }

    @PostMapping("/course-students")
    public JsonResponse<Boolean> addStudentToCourse(@RequestBody CourseStudentRequest request) {
        courseManagementService.addStudentToCourse(request);
        return JsonResponse.success(true);
    }

    @PostMapping("/course-scores")
    public JsonResponse<CourseStudentDTO> saveCourseScore(@RequestBody CourseScoreRequest request) {
        return JsonResponse.success(courseManagementService.saveCourseScore(request));
    }
}
