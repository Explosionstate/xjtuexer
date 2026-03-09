package com.example.mybatisplusdemo.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.mybatisplusdemo.common.PageResult;
import com.example.mybatisplusdemo.common.security.Pbkdf2PasswordHasher;
import com.example.mybatisplusdemo.common.utls.SessionUtils;
import com.example.mybatisplusdemo.mapper.UserMapper;
import com.example.mybatisplusdemo.model.domain.User;
import com.example.mybatisplusdemo.model.dto.PageDTO;
import com.example.mybatisplusdemo.model.dto.QueryDTO;
import com.example.mybatisplusdemo.service.IUserService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {

    private final UserMapper userMapper;
    private final Pbkdf2PasswordHasher passwordHasher;

    public UserServiceImpl(UserMapper userMapper, Pbkdf2PasswordHasher passwordHasher) {
        this.userMapper = userMapper;
        this.passwordHasher = passwordHasher;
    }

    @Override
    public User getByIdMy(Long id) {
        User u = userMapper.selectById(id);
        if (u != null) {
            u.setPassword(null);
        }
        return u;
    }

    @Override
    public PageResult<User> getUserPage(QueryDTO queryDTO) {
        Page<User> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());

        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        if (queryDTO.getId() != null) {
            wrapper.eq(User::getId, queryDTO.getId());
        }
        if (StringUtils.hasText(queryDTO.getLoginName())) {
            wrapper.like(User::getLoginName, queryDTO.getLoginName());
        }

        IPage<User> userPage = userMapper.selectPage(page, wrapper);
        userPage.getRecords().forEach(u -> u.setPassword(null));

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
        users.forEach(u -> u.setPassword(null));
        return users;
    }

    @Override
    public User login(User req) {
        if (req == null || !StringUtils.hasText(req.getLoginName()) || !StringUtils.hasText(req.getPassword())) {
            throw new IllegalArgumentException("loginName/password 不能为空");
        }

        User db = userMapper.selectOne(new LambdaQueryWrapper<User>()
                .eq(User::getLoginName, req.getLoginName())
                .eq(User::getDeleted, false));

        if (db == null) {
            throw new RuntimeException("用户名或密码错误");
        }

        String stored = db.getPassword();
        if (!passwordMatchesAndMaybeUpgrade(req.getPassword(), stored, db)) {
            throw new RuntimeException("用户名或密码错误");
        }

        db.setLastLoginTime(LocalDateTime.now());
        userMapper.updateById(db);

        User sessionUser = new User()
                .setId(db.getId())
                .setLoginName(db.getLoginName())
                .setLastLoginTime(db.getLastLoginTime())
                .setRemark(db.getRemark())
                .setAvatar(db.getAvatar());

        SessionUtils.saveCurrentAdminUserInfo(sessionUser);

        db.setPassword(null);
        return db;
    }

    private boolean passwordMatchesAndMaybeUpgrade(String raw, String stored, User dbRow) {
        if (!StringUtils.hasText(stored)) {
            return false;
        }
        boolean looksPbkdf2 = stored.split(":").length == 3;
        if (looksPbkdf2) {
            return passwordHasher.matches(raw, stored);
        }

        boolean legacyOk = stored.equals(raw);
        if (legacyOk) {
            dbRow.setPassword(passwordHasher.hash(raw));
            userMapper.updateById(dbRow);
        }
        return legacyOk;
    }

    @Override
    public Page<User> listpage(PageDTO pageDTO, User user) {
        Page<User> page = new Page<>(pageDTO.getPageNo(), pageDTO.getPageSize());
        Page<User> result = userMapper.listPage(page, user);
        result.getRecords().forEach(u -> u.setPassword(null));
        return result;
    }

    @Override
    public User register(User user) {
        if (user == null || !StringUtils.hasText(user.getLoginName()) || !StringUtils.hasText(user.getPassword())) {
            throw new IllegalArgumentException("loginName/password 不能为空");
        }

        long count = this.count(new QueryWrapper<User>().eq("login_name", user.getLoginName()));
        if (count > 0) {
            return null;
        }

        user.setPassword(passwordHasher.hash(user.getPassword()));
        user.setDeleted(false);

        boolean saved = this.save(user);
        if (!saved) {
            return null;
        }
        user.setPassword(null);
        return user;
    }
}

