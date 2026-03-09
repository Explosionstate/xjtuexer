package com.example.mybatisplusdemo.web.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.mybatisplusdemo.common.JsonResponse;
import com.example.mybatisplusdemo.common.utls.SessionUtils;
import com.example.mybatisplusdemo.mapper.UsersMapper;
import com.example.mybatisplusdemo.model.dto.QueryDTO;
import com.example.mybatisplusdemo.model.dto.UserDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.example.mybatisplusdemo.common.PageResult;
import com.example.mybatisplusdemo.service.IUsersService;
import com.example.mybatisplusdemo.model.domain.Users;
import com.example.mybatisplusdemo.model.dto.PageDTO;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UsersController {

    private final UsersMapper usersMapper;
    private final IUsersService usersService;

    @Autowired
    private IUsersService iUsersService;

    public UsersController(UsersMapper usersMapper, IUsersService usersService) {
        this.usersMapper = usersMapper;
        this.usersService = usersService;
    }

    @RequestMapping("hello")
    public void hello() {}

    @GetMapping("getdemo1")
    public String s(Long id, String name) {
        System.out.println(id);
        System.out.println(name);
        return "hello";
    }

    @GetMapping("getdemo2")
    public String s2(UserDTO userDTO, QueryDTO queryDTO) {
        System.out.println(userDTO.getId());
        System.out.println(userDTO.getLoginName());
        return "hello";
    }

    @GetMapping("getdemo3/{xx}")
    public String s3(@PathVariable("xx") Long xx) {
        System.out.println(xx);
        return "hello";
    }

    @PostMapping("postdemo1")
    public JsonResponse s4(@RequestBody UserDTO userDTO) {
        System.out.println(userDTO);
        return JsonResponse.success("HELLO");
    }

    @GetMapping("getById")
    public JsonResponse getById(Long id) {
        Users users = usersService.getByIdMy(id);
        return JsonResponse.success(users);
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
        Users one = usersService.login(users);
        return JsonResponse.success(one);
    }

    @GetMapping("getInfo")
    public JsonResponse getInfo() {
        Users users = SessionUtils.getCurrentUsersInfo();
        return JsonResponse.success(users);
    }


    @GetMapping("listPage")
    public JsonResponse listPage(PageDTO pageDTO, Users users) {
        Page<Users> page = usersService.listPage(pageDTO, users);
        return JsonResponse.success(page);
    }

    @GetMapping("removeById")
    public JsonResponse removeById(Long id) {
        usersService.removeById(id);
        boolean b = iUsersService.removeById(id);
        return JsonResponse.success(b);
    }

    @PostMapping("updateById")
    public JsonResponse updateById(@RequestBody Users users) {
        boolean b = usersService.updateById(users);
        return JsonResponse.success(b);
    }
}