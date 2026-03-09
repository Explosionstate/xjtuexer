package com.example.mybatisplusdemo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.mybatisplusdemo.model.dto.CourseAvgScoreDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface CourseAvgScoresMapper extends BaseMapper<CourseAvgScoreDTO> {
    @Select("SELECT course_name, college, semester, avg_score_group, avg_score_school " +
            "FROM course_avg_scores " +
            "WHERE semester = #{semester} " +
            "AND (#{college} IS NULL OR college = #{college} OR college = '全校')")
    List<CourseAvgScoreDTO> selectCourseAvgScores(String college, String semester);
}