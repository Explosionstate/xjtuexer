package com.example.mybatisplusdemo.model.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModel;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import java.io.Serializable;

/**
 * Compatibility placeholder for legacy /api/orders endpoint.
 * It is mapped to coursevisit because table orders does not exist in latest db.sql.
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@TableName("coursevisit")
@ApiModel(value = "Orders", description = "Compatibility object")
public class Orders implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId("course_id")
    private Long id;

    @TableField("coursename")
    private String name;

    @TableField(exist = false)
    private Long userId;
}