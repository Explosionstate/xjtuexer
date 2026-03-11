package com.example.mybatisplusdemo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.mybatisplusdemo.model.domain.AdminUserPermission;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface AdminUserPermissionMapper extends BaseMapper<AdminUserPermission> {

    @Select("""
        SELECT p.perm_code
        FROM admin_user_permission aup
        JOIN sys_permission p ON p.perm_id = aup.perm_id
        WHERE aup.admin_user_id = #{adminUserId}
          AND p.enabled = 1
        ORDER BY p.perm_id
        """)
    List<String> selectEnabledPermCodesByAdminUserId(@Param("adminUserId") Long adminUserId);

    @Delete("DELETE FROM admin_user_permission WHERE admin_user_id = #{adminUserId}")
    int deleteByAdminUserId(@Param("adminUserId") Long adminUserId);
}
