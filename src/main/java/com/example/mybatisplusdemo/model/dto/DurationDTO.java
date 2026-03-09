package com.example.mybatisplusdemo.model.dto;

import lombok.Data;

@Data
public class DurationDTO {
    private String durationType; // 时长类型：视频、直播、阅读
    private Long durationMinutes; // 时长（分钟）
    private Double percentage; // 占比（%）
}