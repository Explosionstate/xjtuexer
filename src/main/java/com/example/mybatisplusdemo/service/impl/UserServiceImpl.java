package com.example.mybatisplusdemo.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.mybatisplusdemo.common.PageResult;
import com.example.mybatisplusdemo.common.security.PasswordHasher;
import com.example.mybatisplusdemo.common.utls.SessionUtils;
import com.example.mybatisplusdemo.mapper.AdminUserMenuMapper;
import com.example.mybatisplusdemo.mapper.AdminUserPermissionMapper;
import com.example.mybatisplusdemo.mapper.RolePermissionMapper;
import com.example.mybatisplusdemo.mapper.SysMenuMapper;
import com.example.mybatisplusdemo.mapper.SysPermissionMapper;
import com.example.mybatisplusdemo.mapper.UserMapper;
import com.example.mybatisplusdemo.model.domain.AdminUserMenu;
import com.example.mybatisplusdemo.model.domain.AdminUserPermission;
import com.example.mybatisplusdemo.model.domain.RolePermission;
import com.example.mybatisplusdemo.model.domain.SysMenu;
import com.example.mybatisplusdemo.model.domain.SysPermission;
import com.example.mybatisplusdemo.model.domain.User;
import com.example.mybatisplusdemo.model.dto.PageDTO;
import com.example.mybatisplusdemo.model.dto.QueryDTO;
import com.example.mybatisplusdemo.service.IUserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.Set;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {

    private static final String ADMIN_MENU_SESSION_KEY = "sessionAdminMenus";
    private static final String ADMIN_PERMISSION_SESSION_KEY = "sessionAdminPermissions";

    private final UserMapper userMapper;
    private final PasswordHasher passwordHasher;
    private final AdminUserMenuMapper adminUserMenuMapper;
    private final AdminUserPermissionMapper adminUserPermissionMapper;
    private final RolePermissionMapper rolePermissionMapper;
    private final SysMenuMapper sysMenuMapper;
    private final SysPermissionMapper sysPermissionMapper;

    public UserServiceImpl(
            UserMapper userMapper,
            PasswordHasher passwordHasher,
            AdminUserMenuMapper adminUserMenuMapper,
            AdminUserPermissionMapper adminUserPermissionMapper,
            RolePermissionMapper rolePermissionMapper,
            SysMenuMapper sysMenuMapper,
            SysPermissionMapper sysPermissionMapper
    ) {
        this.userMapper = userMapper;
        this.passwordHasher = passwordHasher;
        this.adminUserMenuMapper = adminUserMenuMapper;
        this.adminUserPermissionMapper = adminUserPermissionMapper;
        this.rolePermissionMapper = rolePermissionMapper;
        this.sysMenuMapper = sysMenuMapper;
        this.sysPermissionMapper = sysPermissionMapper;
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

        SessionUtils.clearBiz();
        clearSessionKey("sessionBizMenus");
        clearSessionKey("sessionBizPermissions");
        SessionUtils.saveCurrentAdminUserInfo(sessionUser);
        loadAndSaveAdminMenus(db.getId());
        loadAndSaveAdminPermissions(db.getId());

        db.setPassword(null);
        return db;
    }

    private void loadAndSaveAdminMenus(Long adminUserId) {
        if (adminUserId == null) {
            saveAdminMenusToSession(List.of());
            return;
        }
        List<AdminUserMenu> rels = adminUserMenuMapper.selectList(new LambdaQueryWrapper<AdminUserMenu>()
                .eq(AdminUserMenu::getAdminUserId, adminUserId));
        if (rels == null || rels.isEmpty()) {
            saveAdminMenusToSession(List.of());
            return;
        }

        List<Long> menuIds = rels.stream()
                .map(AdminUserMenu::getMenuId)
                .filter(Objects::nonNull)
                .distinct()
                .toList();

        if (menuIds.isEmpty()) {
            saveAdminMenusToSession(List.of());
            return;
        }

        List<SysMenu> menus = sysMenuMapper.selectList(new LambdaQueryWrapper<SysMenu>()
                .in(SysMenu::getMenuId, menuIds)
                .eq(SysMenu::getEnabled, 1)
                .orderByAsc(SysMenu::getSortNo));

        saveAdminMenusToSession(menus);
    }

    private void loadAndSaveAdminPermissions(Long adminUserId) {
        List<String> permissionList = getAdminPermissionCodes(adminUserId);
        saveAdminPermissionsToSession(permissionList);
    }

    private void saveAdminMenusToSession(List<SysMenu> menus) {
        ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attr == null) {
            return;
        }
        HttpSession session = attr.getRequest().getSession(true);
        session.setAttribute(ADMIN_MENU_SESSION_KEY, menus);
    }

    private void saveAdminPermissionsToSession(List<String> permissionList) {
        ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attr == null) {
            return;
        }
        HttpSession session = attr.getRequest().getSession(true);
        session.setAttribute(ADMIN_PERMISSION_SESSION_KEY, permissionList);
    }

    private void clearSessionKey(String key) {
        ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attr == null) {
            return;
        }
        HttpSession session = attr.getRequest().getSession(false);
        if (session == null) {
            return;
        }
        session.removeAttribute(key);
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

    @Override
    public List<String> getAdminPermissionCodes(Long adminUserId) {
        if (adminUserId == null) {
            return List.of();
        }
        List<String> permissionList = adminUserPermissionMapper.selectEnabledPermCodesByAdminUserId(adminUserId);
        return permissionList == null ? List.of() : permissionList;
    }

    @Override
    public List<String> getRolePermissionCodes(String roleCode) {
        if (!StringUtils.hasText(roleCode)) {
            return List.of();
        }
        String normalized = roleCode.trim().toLowerCase();
        if (!"student".equals(normalized) && !"teacher".equals(normalized)) {
            return List.of();
        }
        List<String> permissionList = rolePermissionMapper.selectEnabledPermCodesByRoleCode(normalized);
        return permissionList == null ? List.of() : permissionList;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateAdminPermissions(Long adminUserId, List<Long> permIds) {
        if (adminUserId == null) {
            return false;
        }

        User admin = userMapper.selectOne(new LambdaQueryWrapper<User>()
                .eq(User::getId, adminUserId)
                .eq(User::getDeleted, false));
        if (admin == null) {
            return false;
        }

        Set<Long> normalizedPermIds = normalizeAndValidatePermIds(permIds);
        if (normalizedPermIds == null) {
            return false;
        }

        adminUserPermissionMapper.deleteByAdminUserId(adminUserId);
        for (Long permId : normalizedPermIds) {
            AdminUserPermission row = new AdminUserPermission();
            row.setAdminUserId(adminUserId);
            row.setPermId(permId);
            adminUserPermissionMapper.insert(row);
        }
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateRolePermissions(String roleCode, List<Long> permIds) {
        if (!StringUtils.hasText(roleCode)) {
            return false;
        }

        String normalizedRole = roleCode.trim().toLowerCase();
        if (!"student".equals(normalizedRole) && !"teacher".equals(normalizedRole)) {
            return false;
        }

        Set<Long> normalizedPermIds = normalizeAndValidatePermIds(permIds);
        if (normalizedPermIds == null) {
            return false;
        }

        rolePermissionMapper.deleteByRoleCode(normalizedRole);
        for (Long permId : normalizedPermIds) {
            RolePermission row = new RolePermission();
            row.setRoleCode(normalizedRole);
            row.setPermId(permId);
            rolePermissionMapper.insert(row);
        }
        return true;
    }

    private Set<Long> normalizeAndValidatePermIds(List<Long> permIds) {
        Set<Long> normalized = new HashSet<>();
        if (permIds != null) {
            permIds.stream().filter(Objects::nonNull).forEach(normalized::add);
        }
        if (normalized.isEmpty()) {
            return normalized;
        }

        List<SysPermission> enabledPerms = sysPermissionMapper.selectList(new LambdaQueryWrapper<SysPermission>()
                .in(SysPermission::getPermId, normalized)
                .eq(SysPermission::getEnabled, 1));
        if (enabledPerms == null || enabledPerms.size() != normalized.size()) {
            return null;
        }
        return normalized;
    }
}
