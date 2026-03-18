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
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class DashboardServiceImpl implements IDashboardService {

    private final UsersMapper usersMapper;
    private final CourseMapper courseMapper;
    private final LearningRecordMapper learningRecordMapper;
    private final LiveSessionMapper liveSessionMapper;
    private final TeacherMapper teacherMapper;

    public DashboardServiceImpl(UsersMapper usersMapper,
                                CourseMapper courseMapper,
                                LearningRecordMapper learningRecordMapper,
                                LiveSessionMapper liveSessionMapper,
                                TeacherMapper teacherMapper) {
        this.usersMapper = usersMapper;
        this.courseMapper = courseMapper;
        this.learningRecordMapper = learningRecordMapper;
        this.liveSessionMapper = liveSessionMapper;
        this.teacherMapper = teacherMapper;
    }

    @Override
    public StatsDTO getStats() {
        StatsDTO stats = new StatsDTO();
        stats.setCheckInCompleted(learningRecordMapper.selectCount(new QueryWrapper<LearningRecord>()
                .isNotNull("check_in_time")));
        stats.setOnlineUsers(learningRecordMapper.selectCount(new QueryWrapper<LearningRecord>()
                .eq("is_online", 1)));
        stats.setTotalUsers(usersMapper.selectCount(new QueryWrapper<Users>()
                .eq("is_deleted", 0)
                .eq("role", "student")));
        stats.setTaskPointsCompleted(learningRecordMapper.selectCount(new QueryWrapper<LearningRecord>()
                .isNotNull("task_point_id")));
        stats.setTeachers(usersMapper.selectCount(new QueryWrapper<Users>()
                .eq("is_deleted", 0)
                .eq("role", "teacher")));

        List<Course> courses = courseMapper.selectListMy();
        stats.setCourses((long) courses.size());
        stats.setChapterResources(courses.stream().mapToLong(this::safeChapterCount).sum());
        stats.setCourseMaterials(courses.stream().mapToLong(this::safeMaterialCount).sum());
        stats.setTaskPoints(courses.stream().mapToLong(this::safeTaskPointCount).sum());
        return stats;
    }

    @Override
    public List<LearningIndexDTO> getLearningIndex() {
        List<Users> students = usersMapper.selectListMy().stream()
                .filter(this::isActiveStudent)
                .collect(Collectors.toList());
        long totalStudents = students.size();
        List<LearningIndexDTO> result = new ArrayList<>();
        result.add(createLearningIndexDTO(students, "极差 (0-2)", 0.0, 2.0, totalStudents, false));
        result.add(createLearningIndexDTO(students, "较差 (2-4)", 2.0, 4.0, totalStudents, false));
        result.add(createLearningIndexDTO(students, "一般 (4-6)", 4.0, 6.0, totalStudents, false));
        result.add(createLearningIndexDTO(students, "较好 (6-8)", 6.0, 8.0, totalStudents, false));
        result.add(createLearningIndexDTO(students, "极好 (8-10)", 8.0, 10.0, totalStudents, true));
        return result;
    }

    @Override
    public Page<Users> getLearningIndexList(Double min, Double max, PageDTO page) {
        long pageNum = resolvePageNum(page);
        long pageSize = resolvePageSize(page);
        List<Users> students = usersMapper.selectListMy().stream()
                .filter(this::isActiveStudent)
                .filter(item -> inRange(item.getLearningIndex(), min, max))
                .sorted(Comparator.comparing(
                        Users::getLearningIndex,
                        Comparator.nullsLast(Comparator.reverseOrder())
                ))
                .collect(Collectors.toList());

        int total = students.size();
        int from = (int) Math.max(0, (pageNum - 1) * pageSize);
        int to = (int) Math.min(total, from + pageSize);
        List<Users> records = from >= to ? new ArrayList<>() : students.subList(from, to);

        Page<Users> resultPage = new Page<>(pageNum, pageSize, total);
        resultPage.setRecords(records);
        return resultPage;
    }

    @Override
    public List<DepartmentRankingDTO> getDepartmentRanking() {
        return usersMapper.selectDepartmentRanking();
    }

    @Override
    public List<LiveSessionDTO> getLiveSessions() {
        List<LiveSessionDTO> result = new ArrayList<>();
        for (LiveSession liveSession : liveSessionMapper.selectListMy()) {
            LiveSessionDTO dto = new LiveSessionDTO();
            dto.setId(liveSession.getSessionId());

            Course course = courseMapper.selectByIdMy(liveSession.getCourseId());
            dto.setCourseName(course == null ? "" : course.getTitle());

            String teacherName = "";
            Teacher teacher = teacherMapper.selectById(liveSession.getTeacherId());
            if (teacher != null && StringUtils.hasText(teacher.getName())) {
                teacherName = teacher.getName();
            } else {
                Users teacherUser = usersMapper.selectOne(new QueryWrapper<Users>()
                        .eq("id", liveSession.getTeacherId())
                        .eq("role", "teacher")
                        .eq("is_deleted", 0));
                if (teacherUser != null && StringUtils.hasText(teacherUser.getName())) {
                    teacherName = teacherUser.getName();
                }
            }
            dto.setTeacher(teacherName);
            dto.setStartTime(liveSession.getStartTime());
            dto.setStatus(liveSession.getStatus());
            result.add(dto);
        }
        return result;
    }

    private LearningIndexDTO createLearningIndexDTO(List<Users> students,
                                                     String label,
                                                     Double min,
                                                     Double max,
                                                     Long totalStudents,
                                                     boolean includeUpperBound) {
        long count = students.stream()
                .filter(item -> inRange(item.getLearningIndex(), min, max, includeUpperBound))
                .count();
        LearningIndexDTO dto = new LearningIndexDTO();
        dto.setLabel(label);
        dto.setCount(count);
        dto.setPercentage(totalStudents != null && totalStudents > 0
                ? Math.round(count * 10000.0 / totalStudents) / 100.0
                : 0.0);
        return dto;
    }

    private long resolvePageNum(PageDTO page) {
        if (page == null) {
            return 1L;
        }
        Integer pageNum = page.getPageNum();
        if (pageNum == null || pageNum <= 0) {
            pageNum = page.getPageNo();
        }
        return (pageNum == null || pageNum <= 0) ? 1L : pageNum.longValue();
    }

    private long resolvePageSize(PageDTO page) {
        if (page == null || page.getPageSize() == null || page.getPageSize() <= 0) {
            return 10L;
        }
        return page.getPageSize().longValue();
    }

    private long safeChapterCount(Course course) {
        return course != null && course.getChapters() != null ? course.getChapters().size() : 0L;
    }

    private long safeMaterialCount(Course course) {
        return course != null && course.getMaterials() != null ? course.getMaterials().size() : 0L;
    }

    private long safeTaskPointCount(Course course) {
        return course != null && course.getTaskPoints() != null ? course.getTaskPoints().size() : 0L;
    }

    private boolean isActiveStudent(Users user) {
        if (user == null) {
            return false;
        }
        return "student".equalsIgnoreCase(user.getRole())
                && (user.getIsDeleted() == null || user.getIsDeleted() == 0);
    }

    private boolean inRange(BigDecimal value, Double min, Double max) {
        return inRange(value, min, max, max != null && max >= 10.0);
    }

    private boolean inRange(BigDecimal value, Double min, Double max, boolean includeUpperBound) {
        if (value == null) {
            return false;
        }
        double minVal = min == null ? 0.0 : min;
        double maxVal = max == null ? Double.MAX_VALUE : max;
        boolean geMin = value.compareTo(BigDecimal.valueOf(minVal)) >= 0;
        boolean upperOk = includeUpperBound
                ? value.compareTo(BigDecimal.valueOf(maxVal)) <= 0
                : value.compareTo(BigDecimal.valueOf(maxVal)) < 0;
        return geMin && upperOk;
    }
}
