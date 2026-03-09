package com.example.mybatisplusdemo.service;

import com.example.mybatisplusdemo.model.dto.DurationDTO;

import java.util.List;

public interface ILearningDurationService {
    List<DurationDTO> getDurations(String courseName, String collegeName);
}