package com.example.mybatisplusdemo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.mybatisplusdemo.model.domain.CourseVisit;
import com.example.mybatisplusdemo.model.dto.CourseVisitDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;


@Mapper
public interface CourseVisitMapper extends BaseMapper<CourseVisit> {
    @Select("SELECT coursename AS courseName, ${timeRange} AS visitCount " +
            "FROM coursevisit " +
            "ORDER BY ${timeRange} DESC LIMIT 10")
    List<CourseVisitDTO> selectTop10Visits(String timeRange);
}