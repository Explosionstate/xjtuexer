package com.example.mybatisplusdemo.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.mybatisplusdemo.common.PageResult;
import com.example.mybatisplusdemo.common.security.Pbkdf2PasswordHasher;
import com.example.mybatisplusdemo.mapper.UsersMapper;
import com.example.mybatisplusdemo.model.domain.Users;
import com.example.mybatisplusdemo.model.dto.PageDTO;
import com.example.mybatisplusdemo.model.dto.QueryDTO;
import com.example.mybatisplusdemo.service.IUsersService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class UsersServiceImpl extends ServiceImpl<UsersMapper, Users> implements IUsersService {

    private static final String BIZ_SESSION_KEY = "sessionBizUser";

    private final UsersMapper usersMapper;
    private final Pbkdf2PasswordHasher passwordHasher;

    public UsersServiceImpl(UsersMapper usersMapper, Pbkdf2PasswordHasher passwordHasher) {
        this.usersMapper = usersMapper;
        this.passwordHasher = passwordHasher;
    }

    @Override
    public Users getByIdMy(Long id) {
        Users u = usersMapper.selectByIdMy(id);
        if (u != null) {
            u.setPassword(null);
        }
        return u;
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
        usersPage.getRecords().forEach(u -> u.setPassword(null));

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

        List<Users> list = usersMapper.selectList(wrapper);
        list.forEach(u -> u.setPassword(null));
        return list;
    }

    @Override
    public Users login(Users req) {
        if (req == null || !StringUtils.hasText(req.getLoginName()) || !StringUtils.hasText(req.getPassword())) {
            throw new IllegalArgumentException("loginName/password 不能为空");
        }

        Users db = usersMapper.selectOne(new LambdaQueryWrapper<Users>()
                .eq(Users::getIsDeleted, 0)
                .eq(Users::getLoginName, req.getLoginName()));

        if (db == null) {
            throw new RuntimeException("用户名或密码错误");
        }

        if (!passwordMatchesAndMaybeUpgrade(req.getPassword(), db.getPassword(), db)) {
            throw new RuntimeException("用户名或密码错误");
        }

        db.setLastLoginTime(LocalDateTime.now());
        usersMapper.updateById(db);

        Users sessionUser = new Users();
        sessionUser.setId(db.getId());
        sessionUser.setLoginName(db.getLoginName());
        sessionUser.setRole(db.getRole());
        sessionUser.setName(db.getName());
        sessionUser.setDepartmentName(db.getDepartmentName());
        sessionUser.setLastLoginTime(db.getLastLoginTime());
        saveBizSessionUser(sessionUser);

        db.setPassword(null);
        return db;
    }

    private void saveBizSessionUser(Users sessionUser) {
        ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
        HttpSession session = attr.getRequest().getSession(true);
        session.setAttribute(BIZ_SESSION_KEY, sessionUser);
    }

    private boolean passwordMatchesAndMaybeUpgrade(String raw, String stored, Users dbRow) {
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
            usersMapper.updateById(dbRow);
        }
        return legacyOk;
    }

    @Override
    public Page<Users> listPage(PageDTO pageDTO, Users users) {
        Page<Users> page = new Page<>(pageDTO.getPageNum(), pageDTO.getPageSize());
        Page<Users> result = usersMapper.selectPage(page, new LambdaQueryWrapper<Users>()
                .eq(Users::getIsDeleted, 0)
                .like(StringUtils.hasText(users.getName()), Users::getName, users.getName())
                .like(StringUtils.hasText(users.getLoginName()), Users::getLoginName, users.getLoginName()));
        result.getRecords().forEach(u -> u.setPassword(null));
        return result;
    }
}
