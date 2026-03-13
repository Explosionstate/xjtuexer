package com.example.mybatisplusdemo.service.impl;

import com.example.mybatisplusdemo.mapper.InteractionMapper;
import com.example.mybatisplusdemo.model.dto.InteractionDTO;
import com.example.mybatisplusdemo.service.IInteractionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.lang.reflect.Field;
import java.util.List;

@Service
public class InteractionServiceImpl implements IInteractionService {


    @Autowired
    private InteractionMapper interactionMapper;

    @Override
    public List<InteractionDTO> getInteractions(String courseName, String collegeName, String startTime, String endTime) {
        List<InteractionDTO> interactions = interactionMapper.selectInteractions(
                courseName.isEmpty() ? null : courseName,
                collegeName.isEmpty() ? null : collegeName,
                startTime.isEmpty() ? null : startTime,
                endTime.isEmpty() ? null : endTime
        );

        long total = interactions.stream()
                .mapToLong(dto -> readLongField(dto, "interactionCount"))
                .sum();

        interactions.forEach(dto -> {
            long count = readLongField(dto, "interactionCount");
            double percentage = total > 0 ? Math.round(count * 10000.0 / total) / 100.0 : 0.0;
            writeField(dto, "percentage", percentage);
        });

        return interactions;
    }

    private long readLongField(Object target, String fieldName) {
        Object value = readField(target, fieldName);
        if (value instanceof Number number) {
            return number.longValue();
        }
        return 0L;
    }

    private Object readField(Object target, String fieldName) {
        if (target == null || fieldName == null || fieldName.isBlank()) {
            return null;
        }
        Class<?> type = target.getClass();
        while (type != null) {
            try {
                Field field = type.getDeclaredField(fieldName);
                field.setAccessible(true);
                return field.get(target);
            } catch (NoSuchFieldException ignored) {
                type = type.getSuperclass();
            } catch (IllegalAccessException ignored) {
                return null;
            }
        }
        return null;
    }

    private void writeField(Object target, String fieldName, Object value) {
        if (target == null || fieldName == null || fieldName.isBlank()) {
            return;
        }
        Class<?> type = target.getClass();
        while (type != null) {
            try {
                Field field = type.getDeclaredField(fieldName);
                field.setAccessible(true);
                field.set(target, value);
                return;
            } catch (NoSuchFieldException ignored) {
                type = type.getSuperclass();
            } catch (IllegalAccessException ignored) {
                return;
            }
        }
    }
}
