package com.example.mybatisplusdemo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.mybatisplusdemo.model.domain.Users;
import com.example.mybatisplusdemo.model.dto.DepartmentRankingDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface UsersMapper extends BaseMapper<Users> {
    Users selectByIdMy(Long id);
    List<Users> selectListMy();
    List<Users> selectPageMy();
    List<Users> selectListOwn(Users users);
    List<Users> listPage(Users users);
    @Select("SELECT department_name AS name, COUNT(*) AS visits " +
            "FROM users " +
            "WHERE is_deleted = 0 AND department_name IS NOT NULL " +
            "GROUP BY department_name " +
            "ORDER BY department_name DESC " +
            "LIMIT 10")
    List<DepartmentRankingDTO> selectDepartmentRanking();
}