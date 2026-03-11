package com.example.mybatisplusdemo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.mybatisplusdemo.model.domain.RolePermission;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface RolePermissionMapper extends BaseMapper<RolePermission> {

    @Select("""
        SELECT p.perm_code
        FROM role_permission rp
        JOIN sys_permission p ON p.perm_id = rp.perm_id
        WHERE rp.role_code = #{roleCode}
          AND p.enabled = 1
        ORDER BY p.perm_id
        """)
    List<String> selectEnabledPermCodesByRoleCode(@Param("roleCode") String roleCode);

    @Delete("DELETE FROM role_permission WHERE role_code = #{roleCode}")
    int deleteByRoleCode(@Param("roleCode") String roleCode);
}
