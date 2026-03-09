package com.example.mybatisplusdemo.model.dto;

import lombok.Data;

@Data
public class StatsDTO {
    private Long checkInCompleted;
    private Long onlineUsers;
    private Long totalUsers;
    private Long taskPointsCompleted;
    private Long teachers;
    private Long courseMaterials;
    private Long chapterResources;
    private Long courses;
    private Long taskPoints;
}