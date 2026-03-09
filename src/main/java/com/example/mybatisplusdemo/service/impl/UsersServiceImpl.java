package com.example.mybatisplusdemo.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.mybatisplusdemo.common.PageResult;
import com.example.mybatisplusdemo.common.utls.SessionUtils;
import com.example.mybatisplusdemo.model.domain.Users;
import com.example.mybatisplusdemo.mapper.UsersMapper;
import com.example.mybatisplusdemo.model.dto.PageDTO;
import com.example.mybatisplusdemo.model.dto.QueryDTO;
import com.example.mybatisplusdemo.service.IUsersService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List; // 添加 import
import java.util.stream.Collectors; // 添加 import

@Service
public class UsersServiceImpl extends ServiceImpl<UsersMapper, Users> implements IUsersService {

    @Autowired
    private UsersMapper usersMapper;

    @Override
    public Users getByIdMy(Long id) {
        return usersMapper.selectByIdMy(id);
    }

    @Override
    public PageResult<Users> getUsersPage(QueryDTO queryDTO) {
        Page<Users> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        LambdaQueryWrapper<Users> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Users::getIsDeleted, 0);
        if (queryDTO.getId() != null) {
            wrapper.eq(Users::getId, queryDTO.getId());
        }
        if (StringUtils.hasText(queryDTO.getLoginName())) {
            wrapper.like(Users::getLoginName, queryDTO.getLoginName());
        }
        IPage<Users> usersPage = usersMapper.selectPage(page, wrapper);
        return new PageResult<>(
                usersPage.getTotal(),
                (int) usersPage.getPages(),
                (int) usersPage.getCurrent(),
                (int) usersPage.getSize(),
                usersPage.getRecords()
        );
    }

    @Override
    public List<Users> listByKey(String key) {
        LambdaQueryWrapper<Users> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Users::getIsDeleted, 0)
                .like(StringUtils.hasText(key), Users::getLoginName, key);
        return usersMapper.selectList(wrapper);
    }

    @Override
    public Users login(Users users) {
        LambdaQueryWrapper<Users> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Users::getIsDeleted, 0)
                .eq(Users::getLoginName, users.getLoginName())
                .eq(Users::getPassword, users.getPassword());
        Users one = usersMapper.selectOne(wrapper);
        if (one == null) {
            throw new RuntimeException("Login failed");
        }
        SessionUtils.saveCurrentUsersInfo(one);
        return one;
    }

    @Override
    public Page<Users> listPage(PageDTO pageDTO, Users users) {
        Page<Users> page = new Page<>(pageDTO.getPageNum(), pageDTO.getPageSize());
        return usersMapper.selectPage(page, new LambdaQueryWrapper<Users>()
                        .like(users.getName() != null, Users::getName, users.getName())
                .eq(Users::getIsDeleted, 0)
                .like(users.getLoginName() != null, Users::getLoginName, users.getLoginName()));

    }
}