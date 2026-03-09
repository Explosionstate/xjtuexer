package com.example.mybatisplusdemo.model.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("live_session")
public class LiveSession {
    @TableId(type = IdType.AUTO)
    private Long sessionId;
    private Long courseId;
    private Long teacherId;
    private LocalDateTime startTime;
    private String status;
    private LocalDateTime gmtCreated;
    private LocalDateTime gmtModified;
}