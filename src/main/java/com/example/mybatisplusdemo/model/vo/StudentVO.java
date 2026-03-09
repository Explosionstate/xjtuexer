package com.example.mybatisplusdemo.model.vo;

import com.example.mybatisplusdemo.model.domain.Student;
import lombok.Data;

import java.util.List;

@Data
public class StudentVO extends Student {
    private List<String> warningHistory; // 假设存储预警历史记录
}