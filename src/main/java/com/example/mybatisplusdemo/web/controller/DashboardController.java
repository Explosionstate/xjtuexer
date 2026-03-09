package com.example.mybatisplusdemo.web.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.mybatisplusdemo.common.JsonResponse;
import com.example.mybatisplusdemo.model.domain.Users;
import com.example.mybatisplusdemo.model.dto.*;
import com.example.mybatisplusdemo.service.IDashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    @Autowired
    private IDashboardService dashboardService;

    @GetMapping("/stats")
    public JsonResponse<StatsDTO> getStats() {
        return JsonResponse.success(dashboardService.getStats());
    }

    @GetMapping("/learning-index")
    public JsonResponse<List<LearningIndexDTO>> getLearningIndex() {
        return JsonResponse.success(dashboardService.getLearningIndex());
    }

    @GetMapping("/learning-index-list")
    public JsonResponse<Page<Users>> getLearningIndexList(@RequestParam Double min, @RequestParam Double max, @RequestParam("pageNum") Integer pageNum, @RequestParam("pageSize") Integer pageSize) {
        PageDTO page = new PageDTO(pageNum,pageSize);
        return JsonResponse.success(dashboardService.getLearningIndexList(min, max, page));
    }

    @GetMapping("/department-ranking")
    public JsonResponse<List<DepartmentRankingDTO>> getDepartmentRanking() {
        return JsonResponse.success(dashboardService.getDepartmentRanking());
    }

    @GetMapping("/live-sessions")
    public JsonResponse<List<LiveSessionDTO>> getLiveSessions() {
        return JsonResponse.success(dashboardService.getLiveSessions());
    }
}