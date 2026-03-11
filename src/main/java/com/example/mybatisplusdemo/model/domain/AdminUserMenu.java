package com.example.mybatisplusdemo.model.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;

@Data
@TableName("admin_user_menu")
public class AdminUserMenu implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "admin_user_id", type = IdType.INPUT)
    private Long adminUserId;

    @TableField("menu_id")
    private Long menuId;
}
