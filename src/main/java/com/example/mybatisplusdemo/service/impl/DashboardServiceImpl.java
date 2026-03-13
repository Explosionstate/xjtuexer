package com.example.mybatisplusdemo.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.mybatisplusdemo.mapper.CourseMapper;
import com.example.mybatisplusdemo.mapper.LearningRecordMapper;
import com.example.mybatisplusdemo.mapper.LiveSessionMapper;
import com.example.mybatisplusdemo.mapper.TeacherMapper;
import com.example.mybatisplusdemo.mapper.UsersMapper;
import com.example.mybatisplusdemo.model.domain.Course;
import com.example.mybatisplusdemo.model.domain.LearningRecord;
import com.example.mybatisplusdemo.model.domain.LiveSession;
import com.example.mybatisplusdemo.model.domain.Teacher;
import com.example.mybatisplusdemo.model.domain.Users;
import com.example.mybatisplusdemo.model.dto.DepartmentRankingDTO;
import com.example.mybatisplusdemo.model.dto.LearningIndexDTO;
import com.example.mybatisplusdemo.model.dto.LiveSessionDTO;
import com.example.mybatisplusdemo.model.dto.PageDTO;
import com.example.mybatisplusdemo.model.dto.StatsDTO;
import com.example.mybatisplusdemo.service.IDashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.lang.reflect.Field;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class DashboardServiceImpl implements IDashboardService {

    @Autowired
    private UsersMapper usersMapper;
    @Autowired
    private CourseMapper courseMapper;
    @Autowired
    private LearningRecordMapper learningRecordMapper;
    @Autowired
    private LiveSessionMapper liveSessionMapper;
    @Autowired
    private TeacherMapper teacherMapper;

    @Override
    public StatsDTO getStats() {
        StatsDTO stats = new StatsDTO();
        setFieldValue(stats, "checkInCompleted", learningRecordMapper.selectCount(new QueryWrapper<LearningRecord>()
                .isNotNull("check_in_time")));
        setFieldValue(stats, "onlineUsers", learningRecordMapper.selectCount(new QueryWrapper<LearningRecord>()
                .eq("is_online", 1)));
        setFieldValue(stats, "totalUsers", usersMapper.selectCount(new QueryWrapper<Users>()
                .eq("is_deleted", 0)
                .eq("role", "student")));
        setFieldValue(stats, "taskPointsCompleted", learningRecordMapper.selectCount(new QueryWrapper<LearningRecord>()
                .isNotNull("task_point_id")));
        setFieldValue(stats, "teachers", usersMapper.selectCount(new QueryWrapper<Users>()
                .eq("is_deleted", 0)
                .eq("role", "teacher")));

        List<Course> courses = courseMapper.selectListMy();
        setFieldValue(stats, "courses", (long) courses.size());
        setFieldValue(stats, "chapterResources", courses.stream()
                .mapToLong(course -> sizeOfListField(course, "chapters"))
                .sum());
        setFieldValue(stats, "courseMaterials", courses.stream()
                .mapToLong(course -> sizeOfListField(course, "materials"))
                .sum());
        setFieldValue(stats, "taskPoints", courses.stream()
                .mapToLong(course -> sizeOfListField(course, "taskPoints"))
                .sum());
        return stats;
    }

    @Override
    public List<LearningIndexDTO> getLearningIndex() {
        Long totalStudents = usersMapper.selectCount(new QueryWrapper<Users>()
                .eq("is_deleted", 0)
                .eq("role", "student"));
        return List.of(
                createLearningIndexDTO("极差 (0-2)", 0.0, 2.0, totalStudents),
                createLearningIndexDTO("较差 (2-4)", 2.0, 4.0, totalStudents),
                createLearningIndexDTO("一般 (4-6)", 4.0, 6.0, totalStudents),
                createLearningIndexDTO("较好 (6-8)", 6.0, 8.0, totalStudents),
                createLearningIndexDTO("极好 (8-10)", 8.0, 10.0, totalStudents)
        );
    }

    private LearningIndexDTO createLearningIndexDTO(String label, Double min, Double max, Long totalStudents) {
        Long count = usersMapper.selectCount(new QueryWrapper<Users>()
                .eq("is_deleted", 0)
                .eq("role", "student")
                .ge("learning_index", min)
                .lt("learning_index", max));
        LearningIndexDTO dto = new LearningIndexDTO();
        setFieldValue(dto, "label", label);
        setFieldValue(dto, "count", count);
        setFieldValue(dto, "percentage", totalStudents > 0 ? Math.round(count * 10000.0 / totalStudents) / 100.0 : 0.0);
        return dto;
    }

    @Override
    public Page<Users> getLearningIndexList(Double min, Double max, PageDTO page) {
        long pageNum = resolvePageNum(page);
        long pageSize = resolvePageSize(page);
        Page<Users> resultPage = new Page<>(pageNum, pageSize);
        return usersMapper.selectPage(resultPage, new QueryWrapper<Users>()
                .eq("is_deleted", 0)
                .eq("role", "student")
                .ge("learning_index", min)
                .lt("learning_index", max));
    }

    @Override
    public List<DepartmentRankingDTO> getDepartmentRanking() {
        return usersMapper.selectDepartmentRanking();
    }

    @Override
    public List<LiveSessionDTO> getLiveSessions() {
        return liveSessionMapper.selectListMy()
                .stream()
                .map(ls -> {
                    LiveSessionDTO dto = new LiveSessionDTO();
                    Long sessionId = readLongField(ls, "sessionId");
                    Long courseId = readLongField(ls, "courseId");
                    Long teacherId = readLongField(ls, "teacherId");
                    LocalDateTime startTime = readLocalDateTimeField(ls, "startTime");
                    String status = readStringField(ls, "status");
                    setFieldValue(dto, "id", sessionId);

                    Course course = courseMapper.selectByIdMy(courseId);
                    setFieldValue(dto, "courseName", readStringField(course, "title"));

                    Teacher teacher = teacherMapper.selectById(teacherId);
                    Users teacherUser = usersMapper.selectOne(new QueryWrapper<Users>()
                            .eq("id", teacherId)
                            .eq("role", "teacher")
                            .eq("is_deleted", 0));

                    String teacherName = "";
                    String teacherFromTeacher = readStringField(teacher, "name");
                    String teacherFromUser = readStringField(teacherUser, "name");
                    if (StringUtils.hasText(teacherFromTeacher)) {
                        teacherName = teacherFromTeacher;
                    } else if (StringUtils.hasText(teacherFromUser)) {
                        teacherName = teacherFromUser;
                    }

                    setFieldValue(dto, "teacher", teacherName);
                    setFieldValue(dto, "startTime", startTime);
                    setFieldValue(dto, "status", status);
                    return dto;
                }).collect(Collectors.toList());
    }

    private long resolvePageNum(PageDTO page) {
        Integer pageNum = readIntegerField(page, "pageNum");
        if (pageNum == null || pageNum <= 0) {
            pageNum = readIntegerField(page, "pageNo");
        }
        return (pageNum == null || pageNum <= 0) ? 1L : pageNum.longValue();
    }

    private long resolvePageSize(PageDTO page) {
        Integer pageSize = readIntegerField(page, "pageSize");
        return (pageSize == null || pageSize <= 0) ? 10L : pageSize.longValue();
    }

    private long sizeOfListField(Object target, String fieldName) {
        Object value = readFieldValue(target, fieldName);
        if (value instanceof List<?> list) {
            return list.size();
        }
        return 0L;
    }

    private Long readLongField(Object target, String fieldName) {
        Object value = readFieldValue(target, fieldName);
        if (value instanceof Number number) {
            return number.longValue();
        }
        return null;
    }

    private Integer readIntegerField(Object target, String fieldName) {
        Object value = readFieldValue(target, fieldName);
        if (value instanceof Number number) {
            return number.intValue();
        }
        return null;
    }

    private String readStringField(Object target, String fieldName) {
        Object value = readFieldValue(target, fieldName);
        return value == null ? "" : String.valueOf(value);
    }

    private LocalDateTime readLocalDateTimeField(Object target, String fieldName) {
        Object value = readFieldValue(target, fieldName);
        if (value instanceof LocalDateTime localDateTime) {
            return localDateTime;
        }
        return null;
    }

    private Object readFieldValue(Object target, String fieldName) {
        if (target == null || !StringUtils.hasText(fieldName)) {
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

    private void setFieldValue(Object target, String fieldName, Object value) {
        if (target == null || !StringUtils.hasText(fieldName)) {
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
