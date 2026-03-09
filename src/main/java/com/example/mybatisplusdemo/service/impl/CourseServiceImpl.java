package com.example.mybatisplusdemo.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.mybatisplusdemo.mapper.CourseMapper;
import com.example.mybatisplusdemo.mapper.UserMapper;
import com.example.mybatisplusdemo.model.domain.Course;
import com.example.mybatisplusdemo.model.domain.User;
import com.example.mybatisplusdemo.service.ICourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CourseServiceImpl extends ServiceImpl<CourseMapper, Course> implements ICourseService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public Course insertCourse(Course course) {
        // 验证教师ID是否存在
        User teacher = userMapper.selectById(course.getTeacherId());
        if (teacher == null) {
            throw new RuntimeException("教师ID不存在");
        }
        // 保存课程
        this.save(course);
        return course;
    }
}