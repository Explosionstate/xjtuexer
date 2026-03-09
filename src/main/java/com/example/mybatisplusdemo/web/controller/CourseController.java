package com.example.mybatisplusdemo.web.controller;

import com.example.mybatisplusdemo.common.JsonResponse;
import com.example.mybatisplusdemo.model.domain.Course;
import com.example.mybatisplusdemo.service.ICourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/course")
public class CourseController {



    @Autowired
    private ICourseService courseService;

    @PostMapping("insert")
    public JsonResponse insertCourse(@RequestBody Course course) {
        try {
            Course insertedCourse = courseService.insertCourse(course);
            return JsonResponse.success(insertedCourse);
        } catch (RuntimeException e) {
            return JsonResponse.error(e.getMessage());
        }
    }
}