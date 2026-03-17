package com.example.mybatisplusdemo.model.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
@TableName("student")
public class Student implements Serializable {
    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "Name")
    @TableField("name")
    private String name;

    @ApiModelProperty(value = "Student ID")
    @TableId(value = "student_id", type = IdType.INPUT)
    private Long studentId;

    @TableField("student_no")
    private String studentNo;

    @ApiModelProperty(value = "College")
    @TableField("college")
    private String college;

    @ApiModelProperty(value = "College ID")
    @TableField("college_id")
    private Long collegeId;

    @ApiModelProperty(value = "Major ID")
    @TableField("major_id")
    private Long majorId;

    @ApiModelProperty(value = "Class ID")
    @TableField("class_id")
    private Long classId;

    @ApiModelProperty(value = "Grade Year")
    @TableField("grade_year")
    private Integer gradeYear;

    @ApiModelProperty(value = "Major Name")
    @TableField(exist = false)
    private String majorName;

    @ApiModelProperty(value = "Class Name")
    @TableField(exist = false)
    private String className;

    @ApiModelProperty(value = "Learning Index")
    @TableField("learning_index")
    private BigDecimal learningIndex;

    @ApiModelProperty(value = "Comparison Last Month")
    @TableField("comparison_last_month")
    private BigDecimal comparisonLastMonth;

    @ApiModelProperty(value = "Total Warnings")
    @TableField("total_warnings")
    private Integer totalWarnings;

    @ApiModelProperty(value = "Resolved Warnings")
    @TableField("resolved_warnings")
    private Integer resolvedWarnings;

    @ApiModelProperty(value = "Learning Scores")
    @TableField("learning_scores")
    private BigDecimal learningScores;

    @ApiModelProperty(value = "Average Course Scores")
    @TableField("average_course_scores")
    private BigDecimal averageCourseScores;
}
