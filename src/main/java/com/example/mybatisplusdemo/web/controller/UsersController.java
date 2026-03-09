package com.example.mybatisplusdemo.web.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.mybatisplusdemo.common.JsonResponse;
import com.example.mybatisplusdemo.common.PageResult;
import com.example.mybatisplusdemo.common.utls.SessionUtils;
import com.example.mybatisplusdemo.model.domain.Users;
import com.example.mybatisplusdemo.model.dto.PageDTO;
import com.example.mybatisplusdemo.model.dto.QueryDTO;
import com.example.mybatisplusdemo.service.IUsersService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UsersController {

    private final IUsersService usersService;

    public UsersController(IUsersService usersService) {
        this.usersService = usersService;
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
        return JsonResponse.success(SessionUtils.getCurrentBizUserInfo());
    }

    @GetMapping("listPage")
    public JsonResponse listPage(PageDTO pageDTO, Users users) {
        Page<Users> page = usersService.listPage(pageDTO, users);
        return JsonResponse.success(page);
    }

    @DeleteMapping("{id}")
    public JsonResponse remove(@PathVariable Long id) {
        boolean ok = usersService.removeById(id);
        return JsonResponse.success(ok);
    }

    @GetMapping("removeById")
    public JsonResponse removeByIdLegacy(Long id) {
        return remove(id);
    }

    @PostMapping("updateById")
    public JsonResponse updateById(@RequestBody Users users) {
        boolean ok = usersService.updateById(users);
        return JsonResponse.success(ok);
    }
}
