package com.example.mybatisplusdemo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.mybatisplusdemo.model.domain.LearningRecord;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface LearningRecordMapper extends BaseMapper<LearningRecord> {
    List<LearningRecord> selectListMy();
}