package com.example.mybatisplusdemo.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.mybatisplusdemo.model.dto.*;
import com.example.mybatisplusdemo.model.domain.Users;

import java.util.List;

public interface IDashboardService {
    StatsDTO getStats();
    List<LearningIndexDTO> getLearningIndex();
    Page<Users> getLearningIndexList(Double min, Double max, PageDTO page); // 确保返回 List<User>
    List<DepartmentRankingDTO> getDepartmentRanking();
    List<LiveSessionDTO> getLiveSessions();
}