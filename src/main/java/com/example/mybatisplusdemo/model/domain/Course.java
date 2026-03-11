package com.example.mybatisplusdemo.model.domain;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@TableName(value = "course", autoResultMap = true)
public class Course {

    @TableId(value = "course_id", type = IdType.AUTO)
    private Long courseId;

    @TableField("title")
    private String title;

    @TableField("teacher_id")
    private Long teacherId;

    @TableField(value = "chapters", typeHandler = JacksonTypeHandler.class)
    private List<Object> chapters;

    @TableField(value = "materials", typeHandler = JacksonTypeHandler.class)
    private List<Object> materials;

    @TableField(value = "task_points", typeHandler = JacksonTypeHandler.class)
    private List<Object> taskPoints;

    @TableField(value = "gmt_created", fill = FieldFill.INSERT)
    private LocalDateTime gmtCreated;

    @TableField(value = "gmt_modified", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime gmtModified;

}
