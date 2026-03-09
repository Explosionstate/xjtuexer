package com.example.mybatisplusdemo.common;

import lombok.Data;
import java.util.List;

@Data
public class PageResult<T> {
    private long total; // 总记录数
    private int totalPages; // 总页数
    private int currentPage; // 当前页
    private int pageSize; // 页面大小
    private List<T> data; // 数据列表

    public PageResult(long total, int totalPages, int currentPage, int pageSize, List<T> data) {
        this.total = total;
        this.totalPages = totalPages;
        this.currentPage = currentPage;
        this.pageSize = pageSize;
        this.data = data;
    }
}