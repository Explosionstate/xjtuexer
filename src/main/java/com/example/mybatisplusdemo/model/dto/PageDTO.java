package com.example.mybatisplusdemo.model.dto;
import lombok.Data;

@Data
public class PageDTO {
    private Integer pageNum =1;
    private Integer pageNo =1;
    private Integer pageSize =10;

    public PageDTO(Integer pageNum, Integer pageSize) {
        this.pageNum = pageNum;
        this.pageSize = pageSize;
    }
}
