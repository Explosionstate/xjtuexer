package com.example.mybatisplusdemo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.mybatisplusdemo.model.dto.DurationDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;


@Mapper
public interface LearningDurationMapper extends BaseMapper<DurationDTO> {
    @Select({
            "<script>",
            "SELECT '视频' AS durationType, SUM(video_duration) AS durationMinutes ",
            "FROM learning_duration ",
            "<where>",
            "<if test='courseName != null'> AND course_name = #{courseName} </if>",
            "<if test='collegeName != null'> AND college_name = #{collegeName} </if>",
            "</where>",
            "UNION ALL ",
            "SELECT '直播' AS durationType, SUM(live_duration) AS durationMinutes ",
            "FROM learning_duration ",
            "<where>",
            "<if test='courseName != null'> AND course_name = #{courseName} </if>",
            "<if test='collegeName != null'> AND college_name = #{collegeName} </if>",
            "</where>",
            "UNION ALL ",
            "SELECT '阅读' AS durationType, SUM(reading_duration) AS durationMinutes ",
            "FROM learning_duration ",
            "<where>",
            "<if test='courseName != null'> AND course_name = #{courseName} </if>",
            "<if test='collegeName != null'> AND college_name = #{collegeName} </if>",
            "</where>",
            "</script>"
    })
    List<DurationDTO> selectDurations(String courseName, String collegeName);
}