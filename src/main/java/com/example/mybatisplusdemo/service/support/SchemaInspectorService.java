package com.example.mybatisplusdemo.service.support;

import com.example.mybatisplusdemo.mapper.SchemaInspectorMapper;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class SchemaInspectorService {

    private final SchemaInspectorMapper schemaInspectorMapper;
    private final Map<String, Boolean> tableCache = new ConcurrentHashMap<>();

    public SchemaInspectorService(SchemaInspectorMapper schemaInspectorMapper) {
        this.schemaInspectorMapper = schemaInspectorMapper;
    }

    public boolean hasTable(String tableName) {
        if (!StringUtils.hasText(tableName)) {
            return false;
        }
        String key = tableName.trim().toLowerCase();
        return tableCache.computeIfAbsent(key, this::queryTableExists);
    }

    private boolean queryTableExists(String tableName) {
        Integer count = schemaInspectorMapper.countTable(tableName);
        return count != null && count > 0;
    }
}
