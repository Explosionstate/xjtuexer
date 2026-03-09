package com.example.mybatisplusdemo.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.mybatisplusdemo.common.PageResult;
import com.example.mybatisplusdemo.common.utls.SessionUtils;
import com.example.mybatisplusdemo.model.domain.User;
import com.example.mybatisplusdemo.mapper.UserMapper;
import com.example.mybatisplusdemo.model.dto.PageDTO;
import com.example.mybatisplusdemo.model.dto.QueryDTO;
import com.example.mybatisplusdemo.service.IUserService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;


@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {

@Autowired
private UserMapper userMapper;
    @Override
    public User getByIdMy(Long id) {
        User user = userMapper.selectById(id);
        return user;
    }
    @Override
    public PageResult<User> getUserPage(QueryDTO queryDTO) {
        // 设置分页参数
        Page<User> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());

        // 动态构建查询条件
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        if (queryDTO.getId() != null) {
            wrapper.eq(User::getId, queryDTO.getId());
        }
        if (StringUtils.hasText(queryDTO.getLoginName())) {
            wrapper.like(User::getLoginName, queryDTO.getLoginName());
        }

        // 执行分页查询
        IPage<User> userPage = userMapper.selectPage(page, wrapper);

        // 封装分页结果
        return new PageResult<>(
                userPage.getTotal(),
                (int) userPage.getPages(),
                (int) userPage.getCurrent(),
                (int) userPage.getSize(),
                userPage.getRecords()
        );
    }

    @Override
    public List<User> listByKey(String key) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(User::getLoginName, key);
        List<User> users = userMapper.selectList(wrapper);
        return users;
    }

    @Override
    public User login(User user) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getLoginName, user.getLoginName()).eq(User::getPassword, user.getPassword());
        User one =userMapper.selectOne(wrapper);
        SessionUtils .saveCurrentUserInfo(one);
        return one;
    }



    @Override
    public Page<User> listpage(PageDTO pageDTO, User user) {
        Page<User> page = new Page<>(pageDTO.getPageNo(), pageDTO.getPageSize());
       page = userMapper.listPage(page,user);
        return page;
    }

    @Override
    public User register(User user) {
        long count = this.count(new QueryWrapper<User>().eq("login_name", user.getLoginName()));
        if (count > 0) {
            return null;
        }
        user.setGmtCreated(LocalDateTime.now());
        user.setGmtModified(LocalDateTime.now());
        user.setDeleted(false);
        boolean saved = this.save(user);
        if (saved) {
            return user;
        } else {
            return null;
        }
    }

}
