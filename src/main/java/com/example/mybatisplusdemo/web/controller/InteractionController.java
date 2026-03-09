package com.example.mybatisplusdemo.web.controller;

import com.example.mybatisplusdemo.common.JsonResponse;
import com.example.mybatisplusdemo.model.dto.InteractionDTO;
import com.example.mybatisplusdemo.service.IInteractionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/interaction")
public class InteractionController {

    @Autowired
    private IInteractionService interactionService;

    @GetMapping("/interactions")
    public JsonResponse getInteractions(
            @RequestParam(required = false, defaultValue = "") String courseName,
            @RequestParam(required = false, defaultValue = "") String collegeName,
            @RequestParam(required = false, defaultValue = "") String startTime,
            @RequestParam(required = false, defaultValue = "") String endTime
    ) {
        List<InteractionDTO> interactions = interactionService.getInteractions(courseName, collegeName, startTime, endTime);
        return JsonResponse.success(interactions);
    }
}