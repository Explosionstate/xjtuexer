package com.example.mybatisplusdemo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.mybatisplusdemo.model.domain.Student;
import com.example.mybatisplusdemo.model.dto.StudentDTO;
import org.apache.ibatis.annotations.Param;

public interface StudentMapper extends BaseMapper<Student> {
    Page<Student> listPage(
            @Param("page") Page<Student> page,
            @Param("student") Student student
    );

    Page<Student> selectByList(@Param("page") Page<Student> page,@Param("student") StudentDTO studentDTO);
}