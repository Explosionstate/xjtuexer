package com.example.mybatisplusdemo.model.domain;

import com.baomidou.mybatisplus.annotation.*;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@TableName("course")
public class Course {
    @TableId(type = IdType.AUTO)
    private Long courseId;

    @TableField("title")
    private String title;

    @TableField("teacher_id")
    private Long teacherId;

    @TableField(value = "chapters", typeHandler = JacksonTypeHandler.class)
    private List<Chapter> chapters;

    @TableField(value = "materials", typeHandler = JacksonTypeHandler.class)
    private List<Material> materials;

    @TableField(value = "task_points", typeHandler = JacksonTypeHandler.class)
    private List<TaskPoint> taskPoints;

    @TableField(value = "gmt_created", fill = FieldFill.INSERT)
    private LocalDateTime gmtCreated;

    @TableField(value = "gmt_modified", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime gmtModified;

    @Data
    public static class Chapter {
        private Long id;
        private String title;
    }

    @Data
    public static class Material {
        private Long id;
        private String title;
    }

    @Data
    public static class TaskPoint {
        private Long id;
        private String title;
    }
}