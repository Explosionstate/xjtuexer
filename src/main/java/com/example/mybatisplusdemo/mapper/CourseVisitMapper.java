package com.example.mybatisplusdemo.mapper;

import com.example.mybatisplusdemo.model.dto.CourseVisitDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface CourseVisitMapper {

    /**
     * 安全写法：不拼接列名，改用 CASE 按 timeRange 选择列值。
     */
    @Select("""
        SELECT
            coursename AS courseName,
            CASE
                WHEN #{timeRange} = 'today' THEN today
                WHEN #{timeRange} = 'week'  THEN thisweek
                WHEN #{timeRange} = 'month' THEN thismonth
                WHEN #{timeRange} = 'year'  THEN thisyear
                ELSE thisyear
            END AS visitCount
        FROM coursevisit
        ORDER BY
            CASE
                WHEN #{timeRange} = 'today' THEN today
                WHEN #{timeRange} = 'week'  THEN thisweek
                WHEN #{timeRange} = 'month' THEN thismonth
                WHEN #{timeRange} = 'year'  THEN thisyear
                ELSE thisyear
            END DESC
        LIMIT 10
        """)
    List<CourseVisitDTO> selectTop10Visits(@Param("timeRange") String timeRange);
}
