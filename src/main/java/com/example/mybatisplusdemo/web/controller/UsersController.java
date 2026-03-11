package com.example.mybatisplusdemo.web.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.mybatisplusdemo.common.JsonResponse;
import com.example.mybatisplusdemo.common.PageResult;
import com.example.mybatisplusdemo.common.utls.SessionUtils;
import com.example.mybatisplusdemo.model.domain.SysMenu;
import com.example.mybatisplusdemo.model.domain.User;
import com.example.mybatisplusdemo.model.domain.Users;
import com.example.mybatisplusdemo.model.dto.PageDTO;
import com.example.mybatisplusdemo.model.dto.QueryDTO;
import com.example.mybatisplusdemo.service.IUserService;
import com.example.mybatisplusdemo.service.IUsersService;
import jakarta.servlet.http.HttpSession;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;

@RestController
@RequestMapping("/api/users")
public class UsersController {

    private final IUsersService usersService;
    private final IUserService userService;

    public UsersController(IUsersService usersService, IUserService userService) {
        this.usersService = usersService;
        this.userService = userService;
    }

    @GetMapping("getById")
    public JsonResponse getById(Long id) {
        return JsonResponse.success(usersService.getByIdMy(id));
    }

    @PostMapping("page")
    public JsonResponse page(@RequestBody QueryDTO queryDTO) {
        PageResult<Users> pageResult = usersService.getUsersPage(queryDTO);
        return JsonResponse.success(pageResult);
    }

    @GetMapping("listByKey")
    public JsonResponse listByKey(String key) {
        List<Users> usersList = usersService.listByKey(key);
        return JsonResponse.success(usersList);
    }

    @PostMapping("login")
    public JsonResponse login(@RequestBody Users users) {
        return JsonResponse.success(usersService.login(users));
    }

    @GetMapping("getInfo")
    public JsonResponse getInfo() {
        Users current = SessionUtils.getCurrentBizUserInfo();
        List<SysMenu> menus = getSessionMenus("sessionBizMenus");
        List<String> permissionList = getSessionPermissionList("sessionBizPermissions");
        return JsonResponse.success(current)
                .addOtherData("menus", menus)
                .addOtherData("menuList", menus)
                .addOtherData("permissionList", permissionList);
    }

    @GetMapping("listPage")
    public JsonResponse listPage(PageDTO pageDTO, Users users) {
        User currentAdmin = SessionUtils.getCurrentAdminUserInfo();
        if (currentAdmin != null) {
            return JsonResponse.success(listAdminManagedPage(pageDTO, users));
        }
        Page<Users> page = usersService.listPage(pageDTO, users);
        return JsonResponse.success(page);
    }

    @DeleteMapping("{id}")
    public JsonResponse remove(@PathVariable Long id, String role) {
        User currentAdmin = SessionUtils.getCurrentAdminUserInfo();
        if (currentAdmin == null) {
            return JsonResponse.error("only admin can access");
        }
        boolean ok = removeManagedUser(id, role);
        return JsonResponse.success(ok);
    }

    @GetMapping("removeById")
    public JsonResponse removeByIdLegacy(Long id, String role) {
        return remove(id, role);
    }

    @PostMapping("updateById")
    @Transactional(rollbackFor = Exception.class)
    public JsonResponse updateById(@RequestBody Users users) {
        User currentAdmin = SessionUtils.getCurrentAdminUserInfo();
        if (currentAdmin != null) {
            boolean ok = saveManagedUser(users);
            return JsonResponse.success(ok);
        }

        Users currentBiz = SessionUtils.getCurrentBizUserInfo();
        if (currentBiz == null) {
            return JsonResponse.error("Not logged in");
        }

        Long requestId = users.getId() == null ? currentBiz.getId() : users.getId();
        if (!Objects.equals(requestId, currentBiz.getId())) {
            return JsonResponse.error("only self can update");
        }

        users.setId(requestId);
        users.setRole(null);
        boolean ok = usersService.updateById(users);
        return JsonResponse.success(ok);
    }

    private boolean saveManagedUser(Users req) {
        if (req == null) {
            return false;
        }

        String targetRole = normalizeRole(req.getRole());
        if (!StringUtils.hasText(targetRole)) {
            return false;
        }

        if (req.getId() == null) {
            return createManagedUser(req, targetRole);
        }

        String sourceRole = normalizeRole(req.getOriginalRole());
        if (!StringUtils.hasText(sourceRole)) {
            sourceRole = detectRoleById(req.getId());
        }
        if (!StringUtils.hasText(sourceRole)) {
            return false;
        }

        boolean sourceAdmin = isAdminRole(sourceRole);
        boolean targetAdmin = isAdminRole(targetRole);
        if (sourceAdmin == targetAdmin) {
            if (sourceAdmin) {
                return updateAdminUser(req);
            }
            req.setRole(targetRole);
            return usersService.updateById(req);
        }

        return migrateUser(req, sourceRole, targetRole);
    }

    private boolean createManagedUser(Users req, String targetRole) {
        if (!StringUtils.hasText(req.getLoginName()) || !StringUtils.hasText(req.getPassword())) {
            return false;
        }

        String loginName = req.getLoginName().trim();
        if (isLoginNameTaken(loginName, null, null)) {
            return false;
        }

        if (isAdminRole(targetRole)) {
            User newAdmin = new User()
                    .setLoginName(loginName)
                    .setPassword(req.getPassword())
                    .setRemark(req.getName())
                    .setAvatar(req.getAvatar())
                    .setDeleted(false);
            return userService.register(newAdmin) != null;
        }

        Users newBiz = new Users();
        newBiz.setLoginName(loginName);
        newBiz.setPassword(req.getPassword());
        newBiz.setRole(targetRole);
        newBiz.setName(req.getName());
        newBiz.setEmail(req.getEmail());
        newBiz.setDepartmentName(req.getDepartmentName());
        newBiz.setAvatar(req.getAvatar());
        return usersService.register(newBiz) != null;
    }

    private boolean updateAdminUser(Users req) {
        if (req.getId() == null) {
            return false;
        }

        User db = userService.getById(req.getId());
        if (db == null || Boolean.TRUE.equals(db.getDeleted())) {
            return false;
        }

        User patch = new User().setId(db.getId());

        if (StringUtils.hasText(req.getLoginName())) {
            String newLoginName = req.getLoginName().trim();
            if (!newLoginName.equals(db.getLoginName()) && isLoginNameTaken(newLoginName, null, db.getId())) {
                return false;
            }
            patch.setLoginName(newLoginName);
        }

        if (req.getName() != null) {
            patch.setRemark(req.getName());
        }
        if (req.getAvatar() != null) {
            patch.setAvatar(req.getAvatar());
        }
        if (StringUtils.hasText(req.getPassword())) {
            patch.setPassword(req.getPassword());
        }

        return userService.updateById(patch);
    }

    private boolean migrateUser(Users req, String sourceRole, String targetRole) {
        if (isAdminRole(sourceRole)) {
            return migrateAdminToBiz(req, targetRole);
        }
        return migrateBizToAdmin(req);
    }

    private boolean migrateAdminToBiz(Users req, String targetRole) {
        User source = userService.getById(req.getId());
        if (source == null || Boolean.TRUE.equals(source.getDeleted())) {
            return false;
        }

        String loginName = StringUtils.hasText(req.getLoginName()) ? req.getLoginName().trim() : source.getLoginName();
        if (!StringUtils.hasText(loginName)) {
            return false;
        }
        if (isLoginNameTaken(loginName, null, source.getId())) {
            return false;
        }

        boolean created;
        if (StringUtils.hasText(req.getPassword())) {
            Users reg = new Users();
            reg.setLoginName(loginName);
            reg.setPassword(req.getPassword());
            reg.setRole(targetRole);
            reg.setName(req.getName() != null ? req.getName() : source.getRemark());
            reg.setDepartmentName(req.getDepartmentName());
            reg.setEmail(req.getEmail());
            reg.setAvatar(req.getAvatar() != null ? req.getAvatar() : source.getAvatar());
            created = usersService.register(reg) != null;
        } else {
            Users toSave = new Users();
            toSave.setLoginName(loginName);
            toSave.setPassword(source.getPassword());
            toSave.setRole(targetRole);
            toSave.setName(req.getName() != null ? req.getName() : source.getRemark());
            toSave.setDepartmentName(req.getDepartmentName());
            toSave.setEmail(req.getEmail());
            toSave.setAvatar(req.getAvatar() != null ? req.getAvatar() : source.getAvatar());
            toSave.setIsDeleted(0);
            created = usersService.save(toSave);
            if (created) {
                usersService.updateUserRole(toSave.getId(), targetRole);
            }
        }

        if (!created) {
            return false;
        }

        return userService.removeById(source.getId());
    }

    private boolean migrateBizToAdmin(Users req) {
        Users source = usersService.getById(req.getId());
        if (source == null || source.getIsDeleted() == null || source.getIsDeleted() != 0) {
            return false;
        }

        String loginName = StringUtils.hasText(req.getLoginName()) ? req.getLoginName().trim() : source.getLoginName();
        if (!StringUtils.hasText(loginName)) {
            return false;
        }
        if (isLoginNameTaken(loginName, source.getId(), null)) {
            return false;
        }

        boolean created;
        if (StringUtils.hasText(req.getPassword())) {
            User reg = new User()
                    .setLoginName(loginName)
                    .setPassword(req.getPassword())
                    .setRemark(req.getName() != null ? req.getName() : source.getName())
                    .setAvatar(req.getAvatar() != null ? req.getAvatar() : source.getAvatar())
                    .setDeleted(false);
            created = userService.register(reg) != null;
        } else {
            User toSave = new User()
                    .setLoginName(loginName)
                    .setPassword(source.getPassword())
                    .setRemark(req.getName() != null ? req.getName() : source.getName())
                    .setAvatar(req.getAvatar() != null ? req.getAvatar() : source.getAvatar())
                    .setDeleted(false);
            created = userService.save(toSave);
        }

        if (!created) {
            return false;
        }

        return usersService.removeById(source.getId());
    }

    private boolean removeManagedUser(Long id, String role) {
        if (id == null) {
            return false;
        }

        String normalizedRole = normalizeRole(role);
        if (isAdminRole(normalizedRole)) {
            return userService.removeById(id);
        }
        if ("student".equals(normalizedRole) || "teacher".equals(normalizedRole)) {
            return usersService.removeById(id);
        }

        boolean bizRemoved = usersService.removeById(id);
        if (bizRemoved) {
            return true;
        }
        return userService.removeById(id);
    }

    private Page<Users> listAdminManagedPage(PageDTO pageDTO, Users query) {
        long current = resolveCurrent(pageDTO);
        long size = resolveSize(pageDTO);

        String loginName = query == null ? null : query.getLoginName();
        String name = query == null ? null : query.getName();

        List<Users> merged = new ArrayList<>();

        List<Users> bizUsers = usersService.list(new LambdaQueryWrapper<Users>()
                .eq(Users::getIsDeleted, 0)
                .like(StringUtils.hasText(loginName), Users::getLoginName, loginName)
                .like(StringUtils.hasText(name), Users::getName, name));
        for (Users biz : bizUsers) {
            biz.setPassword(null);
            biz.setOriginalRole(biz.getRole());
            merged.add(biz);
        }

        List<User> adminUsers = userService.list(new LambdaQueryWrapper<User>()
                .eq(User::getDeleted, false)
                .like(StringUtils.hasText(loginName), User::getLoginName, loginName)
                .like(StringUtils.hasText(name), User::getRemark, name));
        for (User admin : adminUsers) {
            merged.add(mapAdminToUsers(admin));
        }

        merged.sort(Comparator
                .comparing(Users::getId, Comparator.nullsLast(Long::compareTo))
                .thenComparing(Users::getRole, Comparator.nullsLast(String::compareTo)));

        int fromIndex = (int) Math.min((current - 1) * size, merged.size());
        int toIndex = (int) Math.min(fromIndex + size, merged.size());
        List<Users> records = merged.subList(fromIndex, toIndex);

        Page<Users> page = new Page<>(current, size, merged.size());
        page.setRecords(records);
        return page;
    }

    private Users mapAdminToUsers(User admin) {
        Users row = new Users();
        row.setId(admin.getId());
        row.setLoginName(admin.getLoginName());
        row.setRole("admin");
        row.setOriginalRole("admin");
        row.setName(admin.getRemark());
        row.setAvatar(admin.getAvatar());
        row.setLastLoginTime(admin.getLastLoginTime());
        row.setIsDeleted(Boolean.TRUE.equals(admin.getDeleted()) ? 1 : 0);
        row.setGmtCreated(admin.getGmtCreated());
        row.setGmtModified(admin.getGmtModified());
        row.setPassword(null);
        return row;
    }

    private long resolveCurrent(PageDTO pageDTO) {
        if (pageDTO == null) {
            return 1L;
        }
        Integer pageNum = pageDTO.getPageNum();
        Integer pageNo = pageDTO.getPageNo();
        long value = pageNum != null ? pageNum : (pageNo != null ? pageNo : 1);
        return value > 0 ? value : 1L;
    }

    private long resolveSize(PageDTO pageDTO) {
        if (pageDTO == null || pageDTO.getPageSize() == null || pageDTO.getPageSize() <= 0) {
            return 10L;
        }
        return pageDTO.getPageSize();
    }

    private String detectRoleById(Long id) {
        if (id == null) {
            return null;
        }

        User admin = userService.getById(id);
        if (admin != null && !Boolean.TRUE.equals(admin.getDeleted())) {
            return "admin";
        }

        Users biz = usersService.getById(id);
        if (biz != null && biz.getIsDeleted() != null && biz.getIsDeleted() == 0) {
            return normalizeRole(biz.getRole());
        }
        return null;
    }

    private boolean isLoginNameTaken(String loginName, Long excludeBizId, Long excludeAdminId) {
        if (!StringUtils.hasText(loginName)) {
            return true;
        }
        String normalized = loginName.trim();

        LambdaQueryWrapper<Users> bizWrapper = new LambdaQueryWrapper<Users>()
                .eq(Users::getLoginName, normalized)
                .eq(Users::getIsDeleted, 0);
        if (excludeBizId != null) {
            bizWrapper.ne(Users::getId, excludeBizId);
        }
        if (usersService.count(bizWrapper) > 0) {
            return true;
        }

        LambdaQueryWrapper<User> adminWrapper = new LambdaQueryWrapper<User>()
                .eq(User::getLoginName, normalized)
                .eq(User::getDeleted, false);
        if (excludeAdminId != null) {
            adminWrapper.ne(User::getId, excludeAdminId);
        }

        return userService.count(adminWrapper) > 0;
    }

    private boolean isAdminRole(String role) {
        return "admin".equals(role);
    }

    private String normalizeRole(String role) {
        if (!StringUtils.hasText(role)) {
            return null;
        }
        String normalized = role.trim().toLowerCase();
        if ("student".equals(normalized)) {
            return "student";
        }
        if ("teacher".equals(normalized)) {
            return "teacher";
        }
        if ("admin".equals(normalized)) {
            return "admin";
        }
        return null;
    }
    @SuppressWarnings("unchecked")
    private List<SysMenu> getSessionMenus(String key) {
        ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attr == null) {
            return List.of();
        }
        HttpSession session = attr.getRequest().getSession(false);
        if (session == null) {
            return List.of();
        }
        Object value = session.getAttribute(key);
        if (value instanceof List<?>) {
            return (List<SysMenu>) value;
        }
        return List.of();
    }

    @SuppressWarnings("unchecked")
    private List<String> getSessionPermissionList(String key) {
        ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attr == null) {
            return List.of();
        }
        HttpSession session = attr.getRequest().getSession(false);
        if (session == null) {
            return List.of();
        }
        Object value = session.getAttribute(key);
        if (value instanceof List<?>) {
            return (List<String>) value;
        }
        return List.of();
    }
}
