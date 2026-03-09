package com.example.mybatisplusdemo.model.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class LiveSessionDTO {
    private Long id;
    private String courseName;
    private String teacher;
    private LocalDateTime startTime;
    private String status;
}