package com.example.mybatisplusdemo.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.mybatisplusdemo.common.PageResult;
import com.example.mybatisplusdemo.model.domain.User;
import com.baomidou.mybatisplus.extension.service.IService;
import com.example.mybatisplusdemo.model.dto.PageDTO;
import com.example.mybatisplusdemo.model.dto.QueryDTO;

import java.util.List;

public interface IUserService extends IService<User> {

    User getByIdMy(Long id);
    PageResult<User> getUserPage(QueryDTO queryDTO);

    List<User> listByKey(String key);

    User login(User user);

    Page<User> listpage(PageDTO pageDTO, User user);

    User register(User user);

}
