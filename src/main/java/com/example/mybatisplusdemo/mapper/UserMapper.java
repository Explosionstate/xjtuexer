package com.example.mybatisplusdemo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.mybatisplusdemo.model.domain.User;
import com.example.mybatisplusdemo.model.vo.UserVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;


public interface UserMapper extends BaseMapper<User> {


    //mapper的接口，一个方法必须对应一条sql，sql卸载对应的mapper.xml
    User selectByIdMy(@Param("id") int i);

    User selectByIdMy2(@Param("id") int i,@Param("user")User byId);
    List<User> selectListMy();

    Page<User> selectPageMy(@Param("page") Page<User> page);
    UserVO selectWithOrder(@Param("id") int i);

    List<User> selectListOwn(@Param("user") User user);
     void deleteByIdsMy(@Param("list") List<Long> list);

    int batchInsertUsers(List<User> userList);

    Page<User> listPage(@Param("page") Page<User> page, @Param("user") User user);
}
