package com.example.mybatisplusdemo.model.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("learning_record")
public class LearningRecord {
    @TableId(type = IdType.AUTO)
    private Long recordId;

    @TableField("user_id")
    private Long userId;

    @TableField("course_id")
    private Long courseId;

    @TableField("check_in_time")
    private LocalDateTime checkInTime;

    @TableField("task_point_id")
    private Long taskPointId;

    @TableField("is_online")
    private Integer isOnline;

    @TableField("last_updated")
    private LocalDateTime lastUpdated;
}
