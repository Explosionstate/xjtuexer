package com.example.mybatisplusdemo.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.mybatisplusdemo.model.domain.Course;

public interface ICourseService extends IService<Course> {
    Course insertCourse(Course course);
}