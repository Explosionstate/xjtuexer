package com.example.mybatisplusdemo.model.domain;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("coursevisit")
public class OnlineCourse {
    @TableId
    private String coursename;
    private Integer today;
    private Integer thisweek;
    private Integer thismonth;
    private Integer thisyear;
}