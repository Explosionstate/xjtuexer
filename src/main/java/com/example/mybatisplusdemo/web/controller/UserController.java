package com.example.mybatisplusdemo.web.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.mybatisplusdemo.common.JsonResponse;
import com.example.mybatisplusdemo.common.PageResult;
import com.example.mybatisplusdemo.common.utls.SessionUtils;
import com.example.mybatisplusdemo.model.domain.User;
import com.example.mybatisplusdemo.model.dto.PageDTO;
import com.example.mybatisplusdemo.model.dto.QueryDTO;
import com.example.mybatisplusdemo.service.IUserService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user")
public class UserController {

    private final IUserService userService;

    public UserController(IUserService userService) {
        this.userService = userService;
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
        return JsonResponse.success(userService.login(user));
    }

    @GetMapping("getInfo")
    public JsonResponse getInfo() {
        return JsonResponse.success(SessionUtils.getCurrentAdminUserInfo());
    }

    @GetMapping("listPage")
    public JsonResponse listPage(PageDTO pageDTO, User user) {
        Page<User> page = userService.listpage(pageDTO, user);
        return JsonResponse.success(page);
    }

    /** 新推荐：DELETE */
    @DeleteMapping("{id}")
    public JsonResponse remove(@PathVariable Long id) {
        boolean ok = userService.removeById(id);
        return JsonResponse.success(ok);
    }

    /** 兼容旧前端：GET removeById */
    @GetMapping("removeById")
    public JsonResponse removeByIdLegacy(Long id) {
        return remove(id);
    }

    @PostMapping("updateById")
    public JsonResponse updateById(@RequestBody User user) {
        boolean ok = userService.updateById(user);
        return JsonResponse.success(ok);
    }

    @PostMapping("register")
    public JsonResponse register(@RequestBody User user) {
        User registeredUser = userService.register(user);
        if (registeredUser == null) {
            return JsonResponse.error("Username already exists");
        }
        return JsonResponse.success(registeredUser);
    }
}
