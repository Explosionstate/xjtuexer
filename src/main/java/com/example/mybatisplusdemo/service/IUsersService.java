package com.example.mybatisplusdemo.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.mybatisplusdemo.common.PageResult;
import com.example.mybatisplusdemo.model.domain.Users;
import com.example.mybatisplusdemo.model.dto.PageDTO;
import com.example.mybatisplusdemo.model.dto.QueryDTO;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List; // 添加 import

public interface IUsersService extends IService<Users> {
    Users getByIdMy(Long id);
    PageResult<Users> getUsersPage(QueryDTO queryDTO);
    List<Users> listByKey(String key); // 确保返回 List<Users>
    Users login(Users users);
    Page<Users> listPage(PageDTO pageDTO, Users users);
}