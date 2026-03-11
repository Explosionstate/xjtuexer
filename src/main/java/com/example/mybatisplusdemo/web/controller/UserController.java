package com.example.mybatisplusdemo.web.controller;

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
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/user")
public class UserController {

    private final IUserService userService;
    private final IUsersService usersService;

    public UserController(IUserService userService, IUsersService usersService) {
        this.userService = userService;
        this.usersService = usersService;
    }

    @GetMapping("getById")
    public JsonResponse getById(Long id) {
        return JsonResponse.success(userService.getByIdMy(id));
    }

    @PostMapping("page")
    public JsonResponse page(@RequestBody QueryDTO queryDTO) {
        PageResult<User> pageResult = userService.getUserPage(queryDTO);
        return JsonResponse.success(pageResult);
    }

    @GetMapping("listByKey")
    public JsonResponse listByKey(String key) {
        List<User> userList = userService.listByKey(key);
        return JsonResponse.success(userList);
    }

    @PostMapping("login")
    public JsonResponse login(@RequestBody User user) {
        if (user == null) {
            throw new IllegalArgumentException("loginName/password must not be empty");
        }
        try {
            return JsonResponse.success(userService.login(user));
        } catch (RuntimeException ex) {
            Users req = new Users();
            req.setLoginName(user.getLoginName());
            req.setPassword(user.getPassword());
            try {
                return JsonResponse.success(usersService.login(req));
            } catch (RuntimeException ex2) {
                throw new RuntimeException("Invalid loginName or password");
            }
        }
    }

    @GetMapping("getInfo")
    public JsonResponse getInfo() {
        User currentAdmin = SessionUtils.getCurrentAdminUserInfo();
        if (currentAdmin != null) {
            List<SysMenu> menus = getSessionMenus("sessionAdminMenus");
            List<String> permissionList = getSessionPermissionList("sessionAdminPermissions");
            return JsonResponse.success(currentAdmin)
                    .addOtherData("menus", menus)
                    .addOtherData("menuList", menus)
                    .addOtherData("permissionList", permissionList);
        }

        Users currentBiz = SessionUtils.getCurrentBizUserInfo();
        if (currentBiz != null) {
            List<SysMenu> menus = getSessionMenus("sessionBizMenus");
            List<String> permissionList = getSessionPermissionList("sessionBizPermissions");
            return JsonResponse.success(currentBiz)
                    .addOtherData("menus", menus)
                    .addOtherData("menuList", menus)
                    .addOtherData("permissionList", permissionList);
        }

        return JsonResponse.success(null)
                .addOtherData("menus", List.of())
                .addOtherData("menuList", List.of())
                .addOtherData("permissionList", List.of());
    }

    @GetMapping("listPage")
    public JsonResponse listPage(PageDTO pageDTO, User user) {
        Page<User> page = userService.listpage(pageDTO, user);
        return JsonResponse.success(page);
    }

    @DeleteMapping("{id}")
    public JsonResponse remove(@PathVariable Long id) {
        boolean ok = userService.removeById(id);
        return JsonResponse.success(ok);
    }

    @GetMapping("removeById")
    public JsonResponse removeByIdLegacy(Long id) {
        return remove(id);
    }

    @PostMapping("updateById")
    public JsonResponse updateById(@RequestBody User user) {
        User currentAdmin = SessionUtils.getCurrentAdminUserInfo();
        if (currentAdmin != null) {
            boolean ok = userService.updateById(user);
            return JsonResponse.success(ok);
        }

        Users currentBiz = SessionUtils.getCurrentBizUserInfo();
        if (currentBiz == null) {
            return JsonResponse.error("Not logged in");
        }

        Long targetId = user.getId() != null ? user.getId() : currentBiz.getId();
        if (!targetId.equals(currentBiz.getId())) {
            return JsonResponse.error("only self can update");
        }

        Users patch = new Users();
        patch.setId(targetId);
        patch.setLoginName(user.getLoginName());
        patch.setPassword(user.getPassword());
        patch.setAvatar(user.getAvatar());
        boolean ok = usersService.updateById(patch);
        return JsonResponse.success(ok);
    }

    @PostMapping("register")
    public JsonResponse register(@RequestBody Users users) {
        Users registeredUser = usersService.register(users);
        if (registeredUser == null) {
            return JsonResponse.error("Username already exists");
        }
        return JsonResponse.success(registeredUser);
    }

    @GetMapping("list")
    public JsonResponse list(PageDTO pageDTO, Users users) {
        if (!isCurrentAdmin()) {
            return JsonResponse.error("only admin can access");
        }
        return JsonResponse.success(usersService.listPage(pageDTO, users));
    }

    @GetMapping("detail")
    public JsonResponse detail(Long id) {
        if (!isCurrentAdmin()) {
            return JsonResponse.error("only admin can access");
        }
        return JsonResponse.success(usersService.getByIdMy(id));
    }

    @PutMapping("updateRole")
    public JsonResponse updateRole(@RequestBody Map<String, Object> request) {
        if (!isCurrentAdmin()) {
            return JsonResponse.error("only admin can access");
        }
        Long userId = parseLong(request.get("userId"));
        String role = request.get("role") == null ? null : String.valueOf(request.get("role"));
        boolean ok = usersService.updateUserRole(userId, role);
        return JsonResponse.success(ok);
    }

    @GetMapping("permissions/admin")
    public JsonResponse getAdminPermissions(Long adminUserId) {
        if (!isCurrentAdmin()) {
            return JsonResponse.error("only admin can access");
        }
        return JsonResponse.success(userService.getAdminPermissionCodes(adminUserId));
    }

    @PutMapping("permissions/admin")
    public JsonResponse updateAdminPermissions(@RequestBody Map<String, Object> request) {
        if (!isCurrentAdmin()) {
            return JsonResponse.error("only admin can access");
        }
        Long adminUserId = parseLong(request.get("adminUserId"));
        boolean ok = userService.updateAdminPermissions(adminUserId, parseLongList(request.get("permIds")));
        return JsonResponse.success(ok);
    }

    @GetMapping("permissions/role")
    public JsonResponse getRolePermissions(String roleCode) {
        if (!isCurrentAdmin()) {
            return JsonResponse.error("only admin can access");
        }
        return JsonResponse.success(userService.getRolePermissionCodes(roleCode));
    }

    @PutMapping("permissions/role")
    public JsonResponse updateRolePermissions(@RequestBody Map<String, Object> request) {
        if (!isCurrentAdmin()) {
            return JsonResponse.error("only admin can access");
        }
        String roleCode = request.get("roleCode") == null ? null : String.valueOf(request.get("roleCode"));
        boolean ok = userService.updateRolePermissions(roleCode, parseLongList(request.get("permIds")));
        return JsonResponse.success(ok);
    }

    private boolean isCurrentAdmin() {
        return SessionUtils.getCurrentAdminUserInfo() != null;
    }

    private Long parseLong(Object value) {
        if (value == null) {
            return null;
        }
        if (value instanceof Number number) {
            return number.longValue();
        }
        try {
            return Long.parseLong(String.valueOf(value));
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private List<Long> parseLongList(Object value) {
        if (!(value instanceof List<?> list)) {
            return List.of();
        }
        List<Long> result = new ArrayList<>();
        for (Object item : list) {
            Long parsed = parseLong(item);
            if (parsed != null) {
                result.add(parsed);
            }
        }
        return result;
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
