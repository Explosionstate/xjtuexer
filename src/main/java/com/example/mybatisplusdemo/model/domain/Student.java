package com.example.mybatisplusdemo.model.domain;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.math.BigDecimal;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@TableName("student")
public class Student implements Serializable {
    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "姓名")
    @TableField("name")
    private String name;

    @ApiModelProperty(value = "学号")
    @TableId(value = "student_id", type = IdType.INPUT)
    private Long studentId;

    @TableField("student_no")
    private String studentNo;

    @ApiModelProperty(value = "学院")
    @TableField("college")
    private String college;

    @ApiModelProperty(value = "学情分析")
    @TableField("learning_index")
    private BigDecimal learningIndex;

    @ApiModelProperty(value = "对比上月")
    @TableField("comparison_last_month")
    private BigDecimal comparisonLastMonth;

    @ApiModelProperty(value = "累计预警次数")
    @TableField("total_warnings")
    private Integer totalWarnings;

    @ApiModelProperty(value = "累计解除次数")
    @TableField("resolved_warnings")
    private Integer resolvedWarnings;

    @ApiModelProperty(value = "学习成绩")
    @TableField("learning_scores")
    private BigDecimal learningScores;

    @ApiModelProperty(value = "课程平均分")
    @TableField("average_course_scores")
    private BigDecimal averageCourseScores;
}
