package com.example.mybatisplusdemo.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.mybatisplusdemo.model.domain.Student;
import com.example.mybatisplusdemo.model.dto.PageDTO;
import com.example.mybatisplusdemo.model.dto.QueryDTO;
import com.baomidou.mybatisplus.extension.service.IService;
import com.example.mybatisplusdemo.model.dto.StudentDTO;

import java.util.List;

public interface IStudentService extends IService<Student> {
    Student getByIdMy(Long studentId);

    Page<Student> listPage(PageDTO pageDTO, Student student);

    Page<Student> listPageWithSort(QueryDTO queryDTO);

    List<Student> listByKey(String key);

    Page<Student> selectByListOwn(StudentDTO studentDTO);
}