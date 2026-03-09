package com.example.mybatisplusdemo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.mybatisplusdemo.model.domain.LiveSession;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface LiveSessionMapper extends BaseMapper<LiveSession> {
    List<LiveSession> selectListMy();
}