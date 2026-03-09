package com.example.mybatisplusdemo.model.dto;

import lombok.Data;

@Data
public class QueryDTO {
    private String key;
    private Long id;
    private String loginName;
    private String college;
    private Integer pageNum = 1;
    private Integer pageSize = 10;
}