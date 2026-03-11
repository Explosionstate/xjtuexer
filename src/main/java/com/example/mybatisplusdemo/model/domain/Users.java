package com.example.mybatisplusdemo.model.domain;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.FieldStrategy;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("`user`")
public class Users {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @TableField("login_name")
    private String loginName;

    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    @TableField("password")
    private String password;

    @TableField("role")
    private String role;

    @TableField("name")
    private String name;

    @TableField("email")
    private String email;

    @TableField(
            value = "(SELECT s.learning_index FROM student s WHERE s.student_id = id)",
            insertStrategy = FieldStrategy.NEVER,
            updateStrategy = FieldStrategy.NEVER
    )
    private BigDecimal learningIndex;

    @TableField("department_name")
    private String departmentName;

    @TableField("last_login_time")
    private LocalDateTime lastLoginTime;

    @TableField("is_deleted")
    @TableLogic(value = "0", delval = "1")
    private Integer isDeleted;

    @TableField(value = "gmt_created", fill = FieldFill.INSERT)
    private LocalDateTime gmtCreated;

    @TableField(value = "gmt_modified", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime gmtModified;

    @TableField("avatar")
    private String avatar;

    @TableField(exist = false)
    private String originalRole;

    /**
     * 兼容前端历史字段拼写：advater -> avatar
     */
    @JsonProperty("advater")
    public String getAdvater() {
        return avatar;
    }

    @JsonProperty("advater")
    public void setAdvater(String advater) {
        this.avatar = advater;
    }
}
