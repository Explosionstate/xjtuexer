package com.example.mybatisplusdemo.service.impl;

import com.example.mybatisplusdemo.mapper.InteractionMapper;
import com.example.mybatisplusdemo.model.dto.InteractionDTO;
import com.example.mybatisplusdemo.service.IInteractionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class InteractionServiceImpl implements IInteractionService {


    @Autowired
    private InteractionMapper interactionMapper;

    @Override
    public List<InteractionDTO> getInteractions(String courseName, String collegeName, String startTime, String endTime) {
        List<InteractionDTO> interactions = interactionMapper.selectInteractions(
                courseName.isEmpty() ? null : courseName,
                collegeName.isEmpty() ? null : collegeName,
                startTime.isEmpty() ? null : startTime,
                endTime.isEmpty() ? null : endTime
        );
        long total = interactions.stream().mapToLong(InteractionDTO::getInteractionCount).sum();
        interactions.forEach(dto -> dto.setPercentage(total > 0 ? Math.round(dto.getInteractionCount() * 10000.0 / total) / 100.0 : 0.0));
        return interactions;
    }
}