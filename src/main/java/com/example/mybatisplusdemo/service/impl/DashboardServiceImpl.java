package com.example.mybatisplusdemo.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.mybatisplusdemo.mapper.CourseMapper;
import com.example.mybatisplusdemo.mapper.LearningRecordMapper;
import com.example.mybatisplusdemo.mapper.LiveSessionMapper;
import com.example.mybatisplusdemo.mapper.UsersMapper;
import com.example.mybatisplusdemo.model.domain.*;
import com.example.mybatisplusdemo.model.dto.*;
import com.example.mybatisplusdemo.service.IDashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors; // 添加 import

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

    @Override
    public StatsDTO getStats() {
        StatsDTO stats = new StatsDTO();
        stats.setCheckInCompleted(learningRecordMapper.selectCount(new LambdaQueryWrapper<LearningRecord>()
                .isNotNull(LearningRecord::getCheckInTime)));
        stats.setOnlineUsers(learningRecordMapper.selectCount(new LambdaQueryWrapper<LearningRecord>()
                .eq(LearningRecord::getIsOnline, 1)));
        stats.setTotalUsers(usersMapper.selectCount(new LambdaQueryWrapper<Users>()
                .eq(Users::getIsDeleted, 0)
                .eq(Users::getRole, "student")));
        stats.setTaskPointsCompleted(learningRecordMapper.selectCount(new LambdaQueryWrapper<LearningRecord>()
                .isNotNull(LearningRecord::getTaskPointId)));
        stats.setTeachers(usersMapper.selectCount(new LambdaQueryWrapper<Users>()
                .eq(Users::getIsDeleted, 0)
                .eq(Users::getRole, "teacher")));
        List<Course> courses = courseMapper.selectListMy();
        stats.setCourses((long) courses.size());
        stats.setChapterResources(courses.stream()
                .map(Course::getChapters)
                .mapToLong(chapters -> chapters != null ? chapters.size() : 0)
                .sum());
        stats.setCourseMaterials(courses.stream()
                .map(Course::getMaterials)
                .mapToLong(materials -> materials != null ? materials.size() : 0)
                .sum());
        stats.setTaskPoints(courses.stream()
                .map(Course::getTaskPoints)
                .mapToLong(taskPoints -> taskPoints != null ? taskPoints.size() : 0)
                .sum());
        return stats;
    }

    @Override
    public List<LearningIndexDTO> getLearningIndex() {
        Long totalStudents = usersMapper.selectCount(new LambdaQueryWrapper<Users>()
                .eq(Users::getIsDeleted, 0)
                .eq(Users::getRole, "student"));
        List<LearningIndexDTO> result = List.of(
                createLearningIndexDTO("极差 (0-2)", 0.0, 2.0, totalStudents),
                createLearningIndexDTO("较差 (2-4)", 2.0, 4.0, totalStudents),
                createLearningIndexDTO("一般 (4-6)", 4.0, 6.0, totalStudents),
                createLearningIndexDTO("较好 (6-8)", 6.0, 8.0, totalStudents),
                createLearningIndexDTO("极好 (8-10)", 8.0, 10.0, totalStudents)
        );
        return result;
    }

    private LearningIndexDTO createLearningIndexDTO(String label, Double min, Double max, Long totalStudents) {
        Long count = usersMapper.selectCount(new LambdaQueryWrapper<Users>()
                .eq(Users::getIsDeleted, 0)
                .eq(Users::getRole, "student")
                .ge(Users::getLearningIndex, min)
                .lt(Users::getLearningIndex, max));
        LearningIndexDTO dto = new LearningIndexDTO();
        dto.setLabel(label);
        dto.setCount(count);
        dto.setPercentage(totalStudents > 0 ? Math.round(count * 10000.0 / totalStudents) / 100.0 : 0.0);
        return dto;
    }

    @Override
    public Page<Users> getLearningIndexList(Double min, Double max, PageDTO page) {
        Page<Users> resultPage = new Page<>(page.getPageNum(), page.getPageSize());
        return usersMapper.selectPage(resultPage, new LambdaQueryWrapper<Users>()
                .eq(Users::getIsDeleted, 0)
                .eq(Users::getRole, "student")
                .ge(Users::getLearningIndex, min)
                .lt(Users::getLearningIndex, max));
//        return usersMapper.s(resultPage, new LambdaQueryWrapper<Users>()
//                .eq(Users::getIsDeleted, 0)
//                .eq(Users::getRole, "student")
//                .ge(Users::getLearningIndex, min)
//                .lt(Users::getLearningIndex, max));
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
                    dto.setId(ls.getSessionId());
                    Course course = courseMapper.selectByIdMy(ls.getCourseId());
                    Users users = usersMapper.selectByIdMy(ls.getTeacherId());
                    dto.setCourseName(course != null ? course.getTitle() : "");
                    dto.setTeacher(users != null ? users.getName() : "");
                    dto.setStartTime(ls.getStartTime());
                    dto.setStatus(ls.getStatus());
                    return dto;
                }).collect(Collectors.toList());
    }
}