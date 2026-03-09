package com.example.mybatisplusdemo.web.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.mybatisplusdemo.common.JsonResponse;
import com.example.mybatisplusdemo.model.domain.Student;
import com.example.mybatisplusdemo.model.dto.PageDTO;
import com.example.mybatisplusdemo.model.dto.QueryDTO;
import com.example.mybatisplusdemo.model.dto.StudentDTO;
import com.example.mybatisplusdemo.service.IStudentService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/student")
public class StudentController {
    private final IStudentService studentService;

    public StudentController(IStudentService studentService) {
        this.studentService = studentService;
    }

    // 保留原有接口
    @GetMapping("listPage")
    public JsonResponse listPage(StudentDTO studentDTO) {
        Page<Student> page = new Page<>(studentDTO.getPageNum(), studentDTO.getPageSize());
        Page<Student> resultPage = studentService.selectByListOwn(studentDTO);
        return JsonResponse.success(resultPage);
    }
}