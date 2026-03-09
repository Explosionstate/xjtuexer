package com.example.mybatisplusdemo.model.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("users")
public class Users {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String loginName;
    private String password;
    private String role;
    private String name;
    private String email;
    private BigDecimal learningIndex;
    private String departmentName;
    private LocalDateTime lastLoginTime;
    private Integer isDeleted;
    private LocalDateTime gmtCreated;
    private LocalDateTime gmtModified;
}