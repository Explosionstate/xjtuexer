package com.example.mybatisplusdemo.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.mybatisplusdemo.common.PageResult;
import com.example.mybatisplusdemo.common.security.PasswordHasher;
import com.example.mybatisplusdemo.common.utls.SessionUtils;
import com.example.mybatisplusdemo.mapper.RoleMenuMapper;
import com.example.mybatisplusdemo.mapper.RolePermissionMapper;
import com.example.mybatisplusdemo.mapper.StudentMapper;
import com.example.mybatisplusdemo.mapper.SysMenuMapper;
import com.example.mybatisplusdemo.mapper.TeacherMapper;
import com.example.mybatisplusdemo.mapper.UserMapper;
import com.example.mybatisplusdemo.mapper.UsersMapper;
import com.example.mybatisplusdemo.model.domain.RoleMenu;
import com.example.mybatisplusdemo.model.domain.Student;
import com.example.mybatisplusdemo.model.domain.SysMenu;
import com.example.mybatisplusdemo.model.domain.Teacher;
import com.example.mybatisplusdemo.model.domain.User;
import com.example.mybatisplusdemo.model.domain.Users;
import com.example.mybatisplusdemo.model.dto.PageDTO;
import com.example.mybatisplusdemo.model.dto.QueryDTO;
import com.example.mybatisplusdemo.service.IUsersService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

@Service
public class UsersServiceImpl extends ServiceImpl<UsersMapper, Users> implements IUsersService {

    private static final String BIZ_SESSION_KEY = "sessionBizUser";
    private static final String BIZ_MENU_SESSION_KEY = "sessionBizMenus";
    private static final String BIZ_PERMISSION_SESSION_KEY = "sessionBizPermissions";

    private final UsersMapper usersMapper;
    private final UserMapper userMapper;
    private final PasswordHasher passwordHasher;
    private final StudentMapper studentMapper;
    private final TeacherMapper teacherMapper;
    private final RoleMenuMapper roleMenuMapper;
    private final RolePermissionMapper rolePermissionMapper;
    private final SysMenuMapper sysMenuMapper;

    public UsersServiceImpl(
            UsersMapper usersMapper,
            UserMapper userMapper,
            PasswordHasher passwordHasher,
            StudentMapper studentMapper,
            TeacherMapper teacherMapper,
            RoleMenuMapper roleMenuMapper,
            RolePermissionMapper rolePermissionMapper,
            SysMenuMapper sysMenuMapper
    ) {
        this.usersMapper = usersMapper;
        this.userMapper = userMapper;
        this.passwordHasher = passwordHasher;
        this.studentMapper = studentMapper;
        this.teacherMapper = teacherMapper;
        this.roleMenuMapper = roleMenuMapper;
        this.rolePermissionMapper = rolePermissionMapper;
        this.sysMenuMapper = sysMenuMapper;
    }

    @Override
    public Users getByIdMy(Long id) {
        Users u = usersMapper.selectByIdMy(id);
        if (u != null) {
            enrichBizUserProfile(u);
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
        usersPage.getRecords().forEach(u -> {
            enrichBizUserProfile(u);
            u.setPassword(null);
        });

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
        list.forEach(u -> {
            enrichBizUserProfile(u);
            u.setPassword(null);
        });
        return list;
    }

    @Override
    public Users login(Users req) {
        if (req == null || !StringUtils.hasText(req.getLoginName()) || !StringUtils.hasText(req.getPassword())) {
            throw new IllegalArgumentException("loginName/password 不能为空");
        }

        Users db = usersMapper.selectOne(new LambdaQueryWrapper<Users>()
                .eq(Users::getIsDeleted, 0)
                .eq(Users::getLoginName, req.getLoginName())
                .in(Users::getRole, List.of("student", "teacher")));

        if (db == null) {
            throw new RuntimeException("用户名或密码错误");
        }

        if (!passwordMatchesAndMaybeUpgrade(req.getPassword(), db.getPassword(), db)) {
            throw new RuntimeException("用户名或密码错误");
        }

        db.setLastLoginTime(LocalDateTime.now());
        usersMapper.updateById(db);
        enrichBizUserProfile(db);

        SessionUtils.clearAdmin();
        clearSessionKey("sessionAdminMenus");
        clearSessionKey("sessionAdminPermissions");
        saveBizSessionUser(buildSessionUser(db));
        loadAndSaveRoleMenus(db.getRole());
        loadAndSaveRolePermissions(db.getRole());

        db.setPassword(null);
        return db;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Users register(Users req) {
        if (req == null || !StringUtils.hasText(req.getLoginName()) || !StringUtils.hasText(req.getPassword())) {
            throw new IllegalArgumentException("loginName/password 不能为空");
        }

        String loginName = req.getLoginName().trim();
        String role = normalizeBizRole(req.getRole());

        Long bizExists = usersMapper.selectCount(new LambdaQueryWrapper<Users>()
                .eq(Users::getLoginName, loginName));
        if (bizExists != null && bizExists > 0) {
            return null;
        }

        Long adminExists = userMapper.selectCount(new LambdaQueryWrapper<User>()
                .eq(User::getLoginName, loginName));
        if (adminExists != null && adminExists > 0) {
            return null;
        }

        Users toSave = new Users();
        toSave.setLoginName(loginName);
        toSave.setPassword(passwordHasher.hash(req.getPassword()));
        toSave.setRole(role);
        toSave.setName(StringUtils.hasText(req.getName()) ? req.getName() : loginName);
        toSave.setEmail(req.getEmail());
        toSave.setDepartmentName(req.getDepartmentName());
        toSave.setAvatar(req.getAvatar());
        toSave.setIsDeleted(0);

        boolean saved = this.save(toSave);
        if (!saved || toSave.getId() == null) {
            return null;
        }

        syncRoleExtension(toSave.getId(), role, toSave.getName(), toSave.getDepartmentName());
        toSave.setPassword(null);
        return toSave;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateUserRole(Long userId, String roleCode) {
        if (userId == null) {
            return false;
        }
        if (!StringUtils.hasText(roleCode)) {
            return false;
        }
        String role = normalizeBizRole(roleCode);

        Users db = usersMapper.selectOne(new LambdaQueryWrapper<Users>()
                .eq(Users::getId, userId)
                .eq(Users::getIsDeleted, 0));
        if (db == null) {
            return false;
        }

        if (!role.equals(db.getRole())) {
            db.setRole(role);
            usersMapper.updateById(db);
        }
        syncRoleExtension(db.getId(), role, db.getName(), db.getDepartmentName());
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateById(Users req) {
        if (req == null || req.getId() == null) {
            return false;
        }

        Users db = usersMapper.selectOne(new LambdaQueryWrapper<Users>()
                .eq(Users::getId, req.getId())
                .eq(Users::getIsDeleted, 0));
        if (db == null) {
            return false;
        }

        if (StringUtils.hasText(req.getLoginName())) {
            String newLoginName = req.getLoginName().trim();
            if (!newLoginName.equals(db.getLoginName())) {
                Long bizDup = usersMapper.selectCount(new LambdaQueryWrapper<Users>()
                        .eq(Users::getLoginName, newLoginName)
                        .ne(Users::getId, db.getId()));
                if (bizDup != null && bizDup > 0) {
                    return false;
                }
                Long adminDup = userMapper.selectCount(new LambdaQueryWrapper<User>()
                        .eq(User::getLoginName, newLoginName));
                if (adminDup != null && adminDup > 0) {
                    return false;
                }
                db.setLoginName(newLoginName);
            }
        }
        if (req.getName() != null) {
            db.setName(req.getName());
        }
        if (req.getEmail() != null) {
            db.setEmail(req.getEmail());
        }
        if (req.getDepartmentName() != null) {
            db.setDepartmentName(req.getDepartmentName());
        }
        if (req.getAvatar() != null) {
            db.setAvatar(req.getAvatar());
        }
        if (StringUtils.hasText(req.getPassword())) {
            db.setPassword(passwordHasher.hash(req.getPassword()));
        }
        if (StringUtils.hasText(req.getRole())) {
            db.setRole(normalizeBizRole(req.getRole()));
        }

        int rows = usersMapper.updateById(db);
        if (rows <= 0) {
            return false;
        }

        syncRoleExtension(db.getId(), db.getRole(), db.getName(), db.getDepartmentName());

        Users currentBiz = SessionUtils.getCurrentBizUserInfo();
        if (currentBiz != null && Objects.equals(currentBiz.getId(), db.getId())) {
            saveBizSessionUser(buildSessionUser(db));
            loadAndSaveRoleMenus(db.getRole());
            loadAndSaveRolePermissions(db.getRole());
        }
        return true;
    }

    @Override
    public Page<Users> listPage(PageDTO pageDTO, Users users) {
        Page<Users> page = new Page<>(pageDTO.getPageNum(), pageDTO.getPageSize());
        String name = users == null ? null : users.getName();
        String loginName = users == null ? null : users.getLoginName();
        Page<Users> result = usersMapper.selectPage(page, new LambdaQueryWrapper<Users>()
                .eq(Users::getIsDeleted, 0)
                .like(StringUtils.hasText(name), Users::getName, name)
                .like(StringUtils.hasText(loginName), Users::getLoginName, loginName));
        result.getRecords().forEach(u -> {
            enrichBizUserProfile(u);
            u.setPassword(null);
        });
        return result;
    }

    private Users buildSessionUser(Users db) {
        Users sessionUser = new Users();
        sessionUser.setId(db.getId());
        sessionUser.setLoginName(db.getLoginName());
        sessionUser.setRole(db.getRole());
        sessionUser.setName(db.getName());
        sessionUser.setDepartmentName(db.getDepartmentName());
        sessionUser.setAvatar(db.getAvatar());
        sessionUser.setLastLoginTime(db.getLastLoginTime());
        return sessionUser;
    }

    private void saveBizSessionUser(Users sessionUser) {
        ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
        HttpSession session = attr.getRequest().getSession(true);
        session.setAttribute(BIZ_SESSION_KEY, sessionUser);
    }

    private void loadAndSaveRoleMenus(String roleCode) {
        if (!StringUtils.hasText(roleCode)) {
            saveBizMenusToSession(List.of());
            return;
        }

        List<RoleMenu> rels = roleMenuMapper.selectList(new LambdaQueryWrapper<RoleMenu>()
                .eq(RoleMenu::getRoleCode, roleCode));
        if (rels == null || rels.isEmpty()) {
            saveBizMenusToSession(List.of());
            return;
        }

        List<Long> menuIds = rels.stream()
                .map(RoleMenu::getMenuId)
                .filter(Objects::nonNull)
                .distinct()
                .toList();

        if (menuIds.isEmpty()) {
            saveBizMenusToSession(List.of());
            return;
        }

        List<SysMenu> menus = sysMenuMapper.selectList(new LambdaQueryWrapper<SysMenu>()
                .in(SysMenu::getMenuId, menuIds)
                .eq(SysMenu::getEnabled, 1)
                .orderByAsc(SysMenu::getSortNo));

        saveBizMenusToSession(menus);
    }

    private void loadAndSaveRolePermissions(String roleCode) {
        if (!StringUtils.hasText(roleCode)) {
            saveBizPermissionsToSession(List.of());
            return;
        }
        List<String> permissionList = rolePermissionMapper.selectEnabledPermCodesByRoleCode(roleCode);
        if (permissionList == null) {
            permissionList = List.of();
        }
        saveBizPermissionsToSession(permissionList);
    }

    private void saveBizMenusToSession(List<SysMenu> menus) {
        ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
        HttpSession session = attr.getRequest().getSession(true);
        session.setAttribute(BIZ_MENU_SESSION_KEY, menus);
    }

    private void saveBizPermissionsToSession(List<String> permissionList) {
        ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
        HttpSession session = attr.getRequest().getSession(true);
        session.setAttribute(BIZ_PERMISSION_SESSION_KEY, permissionList);
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

    private void enrichBizUserProfile(Users user) {
        if (user == null || user.getId() == null) {
            return;
        }

        if ("student".equalsIgnoreCase(user.getRole())) {
            Student student = studentMapper.selectById(user.getId());
            if (student != null) {
                if (!StringUtils.hasText(user.getName()) && StringUtils.hasText(student.getName())) {
                    user.setName(student.getName());
                }
                if (!StringUtils.hasText(user.getDepartmentName()) && StringUtils.hasText(student.getCollege())) {
                    user.setDepartmentName(student.getCollege());
                }
                if (user.getLearningIndex() == null) {
                    user.setLearningIndex(student.getLearningIndex());
                }
            }
            return;
        }

        if ("teacher".equalsIgnoreCase(user.getRole())) {
            Teacher teacher = teacherMapper.selectById(user.getId());
            if (teacher != null && StringUtils.hasText(teacher.getName())) {
                user.setName(teacher.getName());
            }
        }
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

    private String normalizeBizRole(String role) {
        if (!StringUtils.hasText(role)) {
            return "student";
        }
        String normalized = role.trim().toLowerCase();
        if (!"student".equals(normalized) && !"teacher".equals(normalized)) {
            throw new IllegalArgumentException("role 仅支持 student/teacher");
        }
        return normalized;
    }

    private void syncRoleExtension(Long userId, String role, String name, String departmentName) {
        if (userId == null) {
            return;
        }
        if ("teacher".equals(role)) {
            ensureTeacherProfile(userId, name);
            return;
        }
        ensureStudentProfile(userId, name, departmentName);
    }

    private void ensureStudentProfile(Long userId, String name, String departmentName) {
        Student student = studentMapper.selectById(userId);
        if (student == null) {
            Student newStudent = new Student();
            newStudent.setStudentId(userId);
            newStudent.setStudentNo(buildStudentNo(userId));
            newStudent.setName(StringUtils.hasText(name) ? name : ("student-" + userId));
            newStudent.setCollege(departmentName);
            studentMapper.insert(newStudent);
            return;
        }

        boolean changed = false;
        if (StringUtils.hasText(name) && !Objects.equals(student.getName(), name)) {
            student.setName(name);
            changed = true;
        }
        if (departmentName != null && !Objects.equals(student.getCollege(), departmentName)) {
            student.setCollege(departmentName);
            changed = true;
        }
        if (changed) {
            studentMapper.updateById(student);
        }
    }

    private void ensureTeacherProfile(Long userId, String name) {
        Teacher teacher = teacherMapper.selectById(userId);
        if (teacher == null) {
            Teacher newTeacher = new Teacher();
            newTeacher.setTeacherId(userId);
            newTeacher.setTeacherNo(buildTeacherNo(userId));
            newTeacher.setName(StringUtils.hasText(name) ? name : ("teacher-" + userId));
            teacherMapper.insert(newTeacher);
            return;
        }

        if (StringUtils.hasText(name) && !Objects.equals(teacher.getName(), name)) {
            teacher.setName(name);
            teacherMapper.updateById(teacher);
        }
    }

    private String buildStudentNo(Long userId) {
        return "S" + String.format("%07d", userId);
    }

    private String buildTeacherNo(Long userId) {
        return "T" + String.format("%07d", userId);
    }
}
