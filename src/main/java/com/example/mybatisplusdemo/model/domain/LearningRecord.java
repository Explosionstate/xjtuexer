package com.example.mybatisplusdemo.model.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("learning_record")
public class LearningRecord {
    @TableId(type = IdType.AUTO)
    private Long recordId;
    private Long userId;
    private Long courseId;
    private LocalDateTime checkInTime;
    private Long taskPointId;
    private Integer isOnline;
    private LocalDateTime lastUpdated;
}