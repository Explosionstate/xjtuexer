package com.example.mybatisplusdemo.model.domain;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@TableName("admin_user")
@ApiModel(value = "User对象", description = "管理员账户（后台）")
public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @ApiModelProperty(value = "用户名")
    @TableField("login_name")
    private String loginName;

    @ApiModelProperty(value = "密码（BCrypt哈希，仅写入不返回）")
    @TableField("password")
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;

    @TableField("last_login_time")
    private LocalDateTime lastLoginTime;

    @TableField("remark")
    private String remark;

    @ApiModelProperty(value = "是否删除")
    @TableField("is_deleted")
    @TableLogic(value = "0", delval = "1")
    private Boolean deleted;

    @TableField(value = "gmt_created", fill = FieldFill.INSERT)
    private LocalDateTime gmtCreated;

    @TableField(value = "gmt_modified", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime gmtModified;

    @ApiModelProperty(value = "头像")
    @TableField("avatar")
    private String avatar;

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

    public Long getId() {
        return id;
    }

    public User setId(Long id) {
        this.id = id;
        return this;
    }

    public String getLoginName() {
        return loginName;
    }

    public User setLoginName(String loginName) {
        this.loginName = loginName;
        return this;
    }

    public String getPassword() {
        return password;
    }

    public User setPassword(String password) {
        this.password = password;
        return this;
    }

    public LocalDateTime getLastLoginTime() {
        return lastLoginTime;
    }

    public User setLastLoginTime(LocalDateTime lastLoginTime) {
        this.lastLoginTime = lastLoginTime;
        return this;
    }

    public String getRemark() {
        return remark;
    }

    public User setRemark(String remark) {
        this.remark = remark;
        return this;
    }

    public Boolean getDeleted() {
        return deleted;
    }

    public User setDeleted(Boolean deleted) {
        this.deleted = deleted;
        return this;
    }

    public LocalDateTime getGmtCreated() {
        return gmtCreated;
    }

    public User setGmtCreated(LocalDateTime gmtCreated) {
        this.gmtCreated = gmtCreated;
        return this;
    }

    public LocalDateTime getGmtModified() {
        return gmtModified;
    }

    public User setGmtModified(LocalDateTime gmtModified) {
        this.gmtModified = gmtModified;
        return this;
    }

    public String getAvatar() {
        return avatar;
    }

    public User setAvatar(String avatar) {
        this.avatar = avatar;
        return this;
    }
}
