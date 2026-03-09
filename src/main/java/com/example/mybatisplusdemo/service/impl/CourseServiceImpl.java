package com.example.mybatisplusdemo.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.mybatisplusdemo.mapper.CourseMapper;
import com.example.mybatisplusdemo.mapper.UsersMapper;
import com.example.mybatisplusdemo.model.domain.Course;
import com.example.mybatisplusdemo.model.domain.Users;
import com.example.mybatisplusdemo.service.ICourseService;
import org.springframework.stereotype.Service;

@Service
public class CourseServiceImpl extends ServiceImpl<CourseMapper, Course> implements ICourseService {

    private final UsersMapper usersMapper;

    public CourseServiceImpl(UsersMapper usersMapper) {
        this.usersMapper = usersMapper;
    }

    @Override
    public Course insertCourse(Course course) {
        if (course == null || course.getTeacherId() == null) {
            throw new IllegalArgumentException("teacherId 不能为空");
        }

        // 规范：课程教师来自 users 表，并要求 role=teacher 且未删除
        Users teacher = usersMapper.selectOne(new LambdaQueryWrapper<Users>()
                .eq(Users::getId, course.getTeacherId())
                .eq(Users::getRole, "teacher")
                .eq(Users::getIsDeleted, 0));

        if (teacher == null) {
            throw new RuntimeException("教师ID不存在或不是教师(role!=teacher)或已删除");
        }

        this.save(course);
        return course;
    }
}
