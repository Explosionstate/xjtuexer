package com.example.mybatisplusdemo.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface SchemaInspectorMapper {

    @Select("""
        SELECT COUNT(1)
        FROM information_schema.tables
        WHERE table_schema = DATABASE()
          AND table_name = #{tableName}
        """)
    Integer countTable(@Param("tableName") String tableName);
}
