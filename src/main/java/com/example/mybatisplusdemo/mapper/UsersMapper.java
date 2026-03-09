package com.example.mybatisplusdemo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.mybatisplusdemo.model.domain.Users;
import com.example.mybatisplusdemo.model.dto.DepartmentRankingDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface UsersMapper extends BaseMapper<Users> {
    Users selectByIdMy(Long id);
    List<Users> selectListMy();
    List<Users> selectPageMy();
    List<Users> selectListOwn(Users users);
    List<Users> listPage(Users users);

    List<DepartmentRankingDTO> selectDepartmentRanking();
}
