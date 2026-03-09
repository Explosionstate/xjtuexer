package com.example.mybatisplusdemo.service;

import com.example.mybatisplusdemo.model.dto.InteractionDTO;

import java.util.List;


public interface IInteractionService {
    List<InteractionDTO> getInteractions(String courseName, String collegeName, String startTime, String endTime);
}