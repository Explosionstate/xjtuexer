package com.example.mybatisplusdemo.web.controller;

import com.example.mybatisplusdemo.common.JsonResponse;
import com.example.mybatisplusdemo.model.dto.CourseVisitDTO;
import com.example.mybatisplusdemo.service.ICourseVisitService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/coursevisit")
public class CourseVisitController {

    @Autowired
    private ICourseVisitService courseVisitService;

    @GetMapping("/top10Visits")
    public JsonResponse getTop10Visits(@RequestParam String timeRange) {
        List<CourseVisitDTO> visits = courseVisitService.getTop10Visits(timeRange);
        return JsonResponse.success(visits);
    }
}