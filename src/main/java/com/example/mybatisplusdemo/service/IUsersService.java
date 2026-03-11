package com.example.mybatisplusdemo.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.example.mybatisplusdemo.common.PageResult;
import com.example.mybatisplusdemo.model.domain.Users;
import com.example.mybatisplusdemo.model.dto.PageDTO;
import com.example.mybatisplusdemo.model.dto.QueryDTO;

import java.util.List;

public interface IUsersService extends IService<Users> {

    Users getByIdMy(Long id);

    PageResult<Users> getUsersPage(QueryDTO queryDTO);

    List<Users> listByKey(String key);

    Users login(Users users);

    Page<Users> listPage(PageDTO pageDTO, Users users);

    Users register(Users users);

    boolean updateUserRole(Long userId, String roleCode);
}
