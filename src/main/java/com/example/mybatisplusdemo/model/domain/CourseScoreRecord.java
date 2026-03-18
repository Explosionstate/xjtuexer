package com.example.mybatisplusdemo.model.domain;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("fact_course_score")
public class CourseScoreRecord {

    @TableId(value = "score_id", type = IdType.AUTO)
    private Long scoreId;

    @TableField("student_id")
    private Long studentId;

    @TableField("course_id")
    private Long courseId;

    @TableField("term_id")
    private Long termId;

    @TableField("offering_id")
    private Long offeringId;

    @TableField("usual_score")
    private BigDecimal usualScore;

    @TableField("final_score")
    private BigDecimal finalScore;

    @TableField("gpa_point")
    private BigDecimal gpaPoint;

    @TableField("rank_in_class")
    private Integer rankInClass;

    @TableField("rank_in_major")
    private Integer rankInMajor;

    @TableField("is_passed")
    private Boolean isPassed;

    @TableField(value = "gmt_created", fill = FieldFill.INSERT)
    private LocalDateTime gmtCreated;

    @TableField(value = "gmt_modified", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime gmtModified;
}
