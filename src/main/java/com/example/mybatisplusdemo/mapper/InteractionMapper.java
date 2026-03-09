package com.example.mybatisplusdemo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.mybatisplusdemo.model.dto.InteractionDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;


@Mapper
public interface InteractionMapper extends BaseMapper<InteractionDTO> {
    @Select("SELECT interaction_type AS interactionType, COUNT(*) AS interactionCount " +
            "FROM interaction " +
            "WHERE status = 1 " +
            "AND (#{courseName} IS NULL OR course_name = #{courseName}) " +
            "AND (#{collegeName} IS NULL OR college_name = #{collegeName}) " +
            "AND (#{startTime} IS NULL OR interaction_time >= #{startTime}) " +
            "AND (#{endTime} IS NULL OR interaction_time <= #{endTime}) " +
            "GROUP BY interaction_type")
    List<InteractionDTO> selectInteractions(String courseName, String collegeName, String startTime, String endTime);
}