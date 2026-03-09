package com.example.mybatisplusdemo.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.mybatisplusdemo.mapper.OnlineCourseMapper;
import com.example.mybatisplusdemo.model.domain.OnlineCourse;
import com.example.mybatisplusdemo.service.IOnlineCourseService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class OnlineCourseServiceImpl extends ServiceImpl<OnlineCourseMapper, OnlineCourse> implements IOnlineCourseService {
    @Override
    public List<OnlineCourse> getAllCourses() {
        return list();
    }

    @Override
    @Transactional
    public void incrementVisitCount(String coursename) {
        baseMapper.incrementVisitCount(coursename);
    }
}