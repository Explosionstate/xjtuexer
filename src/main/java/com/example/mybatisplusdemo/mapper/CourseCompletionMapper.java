package com.example.mybatisplusdemo.mapper;

import com.example.mybatisplusdemo.model.dto.CourseCompletionDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface CourseCompletionMapper {

    CourseCompletionDTO selectCompletion(
            @Param("college") String college,
            @Param("course") String course,
            @Param("semester") String semester,
            @Param("startDate") String startDate,
            @Param("endDate") String endDate
    );
}
