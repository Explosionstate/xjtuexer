package com.example.mybatisplusdemo.model.dto;

import com.example.mybatisplusdemo.model.domain.Student;
import lombok.Data;

@Data
public class StudentDTO extends Student {
    private Integer pageNum=1;
    private Integer pageSize=1;
    private String name;
    private String college;
    private Long studentId;
    private String sortField;
    private String sortOrder;
}