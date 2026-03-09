package com.example.mybatisplusdemo.model.dto;

import lombok.Data;


@Data
public class InteractionDTO {
    private String interactionType;
    private Long interactionCount;
    private Double percentage;
}