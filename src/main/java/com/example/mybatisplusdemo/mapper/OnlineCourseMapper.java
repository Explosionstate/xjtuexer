package com.example.mybatisplusdemo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.mybatisplusdemo.model.domain.OnlineCourse;
import org.apache.ibatis.annotations.Update;

public interface OnlineCourseMapper extends BaseMapper<OnlineCourse> {
    @Update("UPDATE coursevisit SET today = today + 1, thisweek = thisweek + 1, thismonth = thismonth + 1, thisyear = thisyear + 1 WHERE coursename = #{coursename}")
    int incrementVisitCount(String coursename);
}