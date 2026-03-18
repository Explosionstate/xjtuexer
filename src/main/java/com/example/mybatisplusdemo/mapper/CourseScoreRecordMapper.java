package com.example.mybatisplusdemo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.mybatisplusdemo.model.domain.CourseScoreRecord;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CourseScoreRecordMapper extends BaseMapper<CourseScoreRecord> {
}
