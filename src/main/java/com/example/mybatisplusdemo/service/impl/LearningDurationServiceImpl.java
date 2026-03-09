package com.example.mybatisplusdemo.service.impl;

import com.example.mybatisplusdemo.mapper.LearningDurationMapper;
import com.example.mybatisplusdemo.model.dto.DurationDTO;
import com.example.mybatisplusdemo.service.ILearningDurationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LearningDurationServiceImpl implements ILearningDurationService {

    @Autowired
    private LearningDurationMapper learningDurationMapper;

    @Override
    public List<DurationDTO> getDurations(String courseName, String collegeName) {
        List<DurationDTO> durations = learningDurationMapper.selectDurations(courseName, collegeName);
        // 计算总时长并设置百分比
        long totalMinutes = durations.stream().mapToLong(DurationDTO::getDurationMinutes).sum();
        durations.forEach(dto -> {
            double percentage = totalMinutes > 0 ? Math.round(dto.getDurationMinutes() * 10000.0 / totalMinutes) / 100.0 : 0.0;
            dto.setPercentage(percentage);
        });
        return durations;
    }
}