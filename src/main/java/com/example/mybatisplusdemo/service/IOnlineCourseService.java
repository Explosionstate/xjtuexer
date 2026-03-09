package com.example.mybatisplusdemo.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.mybatisplusdemo.model.domain.OnlineCourse;
import java.util.List;

public interface IOnlineCourseService extends IService<OnlineCourse> {
    List<OnlineCourse> getAllCourses();
    void incrementVisitCount(String coursename);
}