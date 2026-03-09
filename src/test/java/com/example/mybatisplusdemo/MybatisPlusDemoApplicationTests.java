package com.example.mybatisplusdemo;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.mybatisplusdemo.mapper.OrdersMapper;
import com.example.mybatisplusdemo.mapper.UserMapper;
import com.example.mybatisplusdemo.model.domain.Orders;
import com.example.mybatisplusdemo.model.domain.User;
import com.example.mybatisplusdemo.model.vo.OrdersVO;
import com.example.mybatisplusdemo.model.vo.UserVO;
import com.example.mybatisplusdemo.service.IUserService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@SpringBootTest
class MybatisPlusDemoApplicationTests {
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private IUserService userService;
    @Autowired
    private OrdersMapper ordersMapper;
    @Test
    public void hh(){
//       User user = userMapper.selectById(1);
//        System.out.println(user);
//        User user = new User().setPassword("111").setLoginName("ZHANGSAN");
//        userMapper.insert(user);
//        for(int i=0;i<100;i++){
//            User user =new User().setPassword("111").setLoginName("zhangsan"+i);
//            userMapper.insert(user);
//        }
//对应的是数据表的字段名
//        QueryWrapper<User> wrapper = new QueryWrapper<>();
//        wrapper.eq("login_name","zhangsan01").eq("password","hello");
//        userMapper.selectList(wrapper);

        //对应的实体的属性名
//        LambdaQueryWrapper<User> lambdaQueryWrapper =new LambdaQueryWrapper<>();
//        lambdaQueryWrapper.eq(User::getLoginName,"zhangsan01").eq(User::getPassword,"hello");
//        userMapper.selectList(lambdaQueryWrapper);

//       分页
        Integer pageNo =11;
        Integer pageSize =10;
//      Page<User> page = new Page<>(pageNo, pageSize);
//        Page<User> userPage = userMapper.selectPage(page, null);
//        List<User> records = userPage.getRecords();
//        User byId =userService.getById(1);
//        long count = userService.count();
        LambdaQueryWrapper<User> lambdaQueryWrapper = new LambdaQueryWrapper<>();
        lambdaQueryWrapper.ge(User::getPassword, "pass")
                .ne(User::getLoginName, "zhangsan01");
        Page<User> page = new Page<>(pageNo, pageSize);
        Page<User> userPage = userMapper.selectPage(page, lambdaQueryWrapper);
    }

    //多表联查
    @Test
    void jj(){
        //alt+enter自动纠错
        //不管什么类型参数，不管多少个参数，统统取别名
       User user= userMapper.selectByIdMy(66);
       User byId =new User().setId(66L);
       User user1 =userMapper.selectByIdMy2(66,byId);
       Page<User> page = new Page<>(11,10);
       page =userMapper.selectPageMy(page);
    }
    //查询id为1的订单 包括下单人信息 1-1
    //1-1关联查询
    //在要查的对象的vo对象中创建要查的顺带的对象
    @Test
    void qq(){

        OrdersVO vo = ordersMapper.selectVOById(1);
        System.out.println(vo);
    }
    //1-n
    //查询id为66客户下了哪些单
    @Test
    void qq1(){
        UserVO vo = userMapper.selectWithOrder(66);
        System.out.println(vo);
    }
    @Test
    void qq2(){
       Orders o =new Orders().setName("suibian").setUserId(1l);
       ordersMapper.insert(o);
    }
    @Test
    void qq3(){
        User user= new User().setId(1L).setLoginName("11");
        List<User> list =userMapper.selectListOwn(user);
    }
    //删除id为1234
    //delete from user where id in (1,2,3,4)
    @Test
    void qq4(){
        List<Long> list = Arrays.asList(101L,102L,103L);
        userMapper.deleteByIdsMy(list);
    }

    //insert into user(login_name,password) values(?,?),(?,?)
//    @Test
//    void qq5(){
//        List<User> userList = Arrays.asList(
//                new User().setId(101L).setLoginName("111").setPassword("1111"),
//                new User().setId(102L).setLoginName("111").setPassword("1111"),
//                new User().setId(103L).setLoginName("111").setPassword("1111")
//        );
//        int insertRows =userMapper.batchInsertUsers(userList);
//        System.out.println("成功添加记录"+insertRows);
//        List<Long> ids =userList.stream().map(User::getId).collect(Collectors.toList());
//        List<User> insertedUsers =userMapper.selectList(Wrappers.<User>query().in("id",ids));
//        System.out.println("插入的用户数据");
//        insertedUsers.forEach(System.out::println);
//    }
}

