package com.example.mybatisplusdemo.model.dto;
import lombok.Data;

@Data
public class PageDTO {
    private Integer pageNum =1;
    private Integer pageNo =1;
    private Integer pageSize =10;

    public PageDTO() {
    }

    public PageDTO(Integer pageNum, Integer pageSize) {
        this.pageNum = pageNum;
        this.pageSize = pageSize;
    }

    public Integer getPageNum() {
        return pageNum;
    }

    public void setPageNum(Integer pageNum) {
        this.pageNum = pageNum;
    }

    public Integer getPageNo() {
        return pageNo;
    }

    public void setPageNo(Integer pageNo) {
        this.pageNo = pageNo;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }
}
