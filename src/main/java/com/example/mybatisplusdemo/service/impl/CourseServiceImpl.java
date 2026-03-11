package com.example.mybatisplusdemo.service.impl;

import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.mybatisplusdemo.mapper.CourseMapper;
import com.example.mybatisplusdemo.mapper.TeacherMapper;
import com.example.mybatisplusdemo.mapper.UsersMapper;
import com.example.mybatisplusdemo.model.domain.Course;
import com.example.mybatisplusdemo.model.domain.Teacher;
import com.example.mybatisplusdemo.model.domain.Users;
import com.example.mybatisplusdemo.service.ICourseService;

@Service
public class CourseServiceImpl extends ServiceImpl<CourseMapper, Course> implements ICourseService {

    private final UsersMapper usersMapper;
    private final TeacherMapper teacherMapper;

    public CourseServiceImpl(UsersMapper usersMapper, TeacherMapper teacherMapper) {
        this.usersMapper = usersMapper;
        this.teacherMapper = teacherMapper;
    }

    @Override
    public Course insertCourse(Course course) {
        if (course == null || course.getTeacherId() == null) {
            throw new IllegalArgumentException("teacherId 不能为空");
        }

        Teacher teacher = teacherMapper.selectById(course.getTeacherId());
        if (teacher == null) {
            throw new RuntimeException("教师ID不存在或不是教师或已删除");
        }

        Users teacherUser = usersMapper.selectOne(new LambdaQueryWrapper<Users>()
                .eq(Users::getId, course.getTeacherId())
                .eq(Users::getRole, "teacher")
                .eq(Users::getIsDeleted, 0));

        if (teacherUser == null) {
            throw new RuntimeException("教师ID不存在或不是教师或已删除");
        }

        this.save(course);
        return course;
    }
}
