package com.example.mybatisplusdemo.model.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class LiveSessionDTO {
    private Long id;
    private String courseName;
    private String teacher;
    private LocalDateTime startTime;
    private String status;

    @JsonProperty("teacherName")
    public String getTeacherName() {
        return teacher;
    }

    @JsonProperty("teacherName")
    public void setTeacherName(String teacherName) {
        this.teacher = teacherName;
    }
}
