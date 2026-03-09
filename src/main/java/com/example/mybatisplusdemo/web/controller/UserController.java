package com.example.mybatisplusdemo.web.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

import com.example.mybatisplusdemo.common.PageResult;
import com.example.mybatisplusdemo.common.utls.SessionUtils;
import com.example.mybatisplusdemo.mapper.UserMapper;
import com.example.mybatisplusdemo.model.dto.QueryDTO;
import com.example.mybatisplusdemo.model.dto.UserDTO;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.example.mybatisplusdemo.common.JsonResponse;
import com.example.mybatisplusdemo.service.IUserService;
import com.example.mybatisplusdemo.model.domain.User;
import com.example.mybatisplusdemo.model.dto.PageDTO;
import java.util.List;


/**
 *
 *  前端控制器
 *
 *
 * @author lxp
 * @since 2025-06-17
 * @version v1.0
 */
@RestController //等于@controller+@responsebody
@RequestMapping("/api/user")
public class UserController {
    private final UserMapper userMapper;
    private final IUserService iUserService;


    public UserController(UserMapper userMapper, IUserService iUserService) {
        this.userMapper = userMapper;
        this.iUserService = iUserService;
    }

    @Autowired
    private IUserService userService;

    //协议+ip+port+url
    @RequestMapping("hello")
    public void hello() {

    }
    //接受请求 发出响应(同意相应）
    //请求类型 get post /put delete
    //请求格式

    // get: url?x=y&a=b&c=d url?id=1&name=zhangsan
    //最简单的参数接收方式：前端怎么传 后端怎么借 要求请求参数名匹配方法参数列表
    @GetMapping("getdemo1")
    public String s(Long id, String name) {
        System.out.println(id);
        System.out.println(name);
        return "hello";
    }

    //适配性搞得接收方式：用对象接受 要求请求参数名匹配对象的属性名
    //当前controller所属的实体类不满足前端传递参数的要求 创建一个dto对象
    @GetMapping("getdemo2")
    public String s2(UserDTO userDTO, QueryDTO queryDTO) {
        System.out.println(userDTO.getId());
        System.out.println(userDTO.getLoginName());
        return "hello";
    }

    //占位符传参 getdemo3/{xx}" =getdemo3?xx=1
    @GetMapping("getdemo3/{xx}")
    public String s3(@PathVariable("xx") Long xx) {
        System.out.println(xx);
        return "hello";
    }

    //post:表单数据 和get请求传参数据一致
    // json数据（前后端分离必备参数请求类型） 必须以对象去接 前端参数名匹配对象属性名！！！并且对象要用json转换注解
    @PostMapping("postdemo1")
    public JsonResponse s4(@RequestBody UserDTO userDTO) {
        System.out.println(userDTO);

        return JsonResponse.success("HELLO");
    }

    //只有明文规定为post的请求为post请求 其余都为get
    //前端穿id，数据库获取对应的数据响应给前端
    @GetMapping("getById")
    public JsonResponse getById(Long id) {
        User user = userService.getByIdMy(id);
        return JsonResponse.success(user);

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
        User login = userService.login(user);
        return JsonResponse.success(login);
    }

    @GetMapping("getInfo")
    public JsonResponse getInfo() {
        User user = SessionUtils.getCurrentUserInfo();
        return JsonResponse.success(user);
    }

    @GetMapping("listPage")
    public JsonResponse listPage(PageDTO pageDTO, User user) {
//        Page<User> page =userService.listpage(pageDTO,user);
        Page<User> page = userService.listpage(pageDTO, user);
        return JsonResponse.success(page);
    }

    @GetMapping("removeById")
    public JsonResponse removeById(Long id) {
        iUserService.removeById(id);
        boolean b = userService.removeById(id);
        return JsonResponse.success(b);
    }

    @PostMapping("updateById")
    public JsonResponse updateById(@RequestBody User user) {
        boolean b = userService.updateById(user);
        return JsonResponse.success(b);


    }
    @PostMapping("register")
    public JsonResponse register(@RequestBody User user) {
        User registeredUser = userService.register(user);
        if (registeredUser == null) {
            return JsonResponse.error("Username already exists");
        } else {
            return JsonResponse.success(registeredUser);
        }
    }
}
