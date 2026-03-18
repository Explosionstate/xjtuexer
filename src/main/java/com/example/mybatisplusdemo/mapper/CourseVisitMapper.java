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
            cv.course_id AS courseId,
            COALESCE(c.title, cv.coursename) AS courseName,
            CASE
                WHEN #{timeRange} = 'today' THEN cv.today
                WHEN #{timeRange} = 'week'  THEN cv.thisweek
                WHEN #{timeRange} = 'month' THEN cv.thismonth
                WHEN #{timeRange} = 'year'  THEN cv.thisyear
                ELSE cv.thisyear
            END AS visitCount
        FROM coursevisit cv
        LEFT JOIN course c ON c.course_id = cv.course_id
        ORDER BY
            CASE
                WHEN #{timeRange} = 'today' THEN cv.today
                WHEN #{timeRange} = 'week'  THEN cv.thisweek
                WHEN #{timeRange} = 'month' THEN cv.thismonth
                WHEN #{timeRange} = 'year'  THEN cv.thisyear
                ELSE cv.thisyear
            END DESC
        LIMIT 10
        """)
    List<CourseVisitDTO> selectTop10Visits(@Param("timeRange") String timeRange);
}
