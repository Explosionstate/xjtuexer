package com.example.mybatisplusdemo.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.mybatisplusdemo.mapper.CourseMapper;
import com.example.mybatisplusdemo.mapper.CourseScoreRecordMapper;
import com.example.mybatisplusdemo.mapper.CourseStudentMapper;
import com.example.mybatisplusdemo.mapper.LearningRecordMapper;
import com.example.mybatisplusdemo.mapper.StudentMapper;
import com.example.mybatisplusdemo.model.domain.Course;
import com.example.mybatisplusdemo.model.domain.CourseScoreRecord;
import com.example.mybatisplusdemo.model.domain.CourseStudent;
import com.example.mybatisplusdemo.model.domain.LearningRecord;
import com.example.mybatisplusdemo.model.domain.Student;
import com.example.mybatisplusdemo.model.dto.CourseManagementMetaDTO;
import com.example.mybatisplusdemo.model.dto.CourseScoreRequest;
import com.example.mybatisplusdemo.model.dto.CourseStudentDTO;
import com.example.mybatisplusdemo.model.dto.CourseStudentRequest;
import com.example.mybatisplusdemo.model.dto.TermOptionDTO;
import com.example.mybatisplusdemo.service.ICourseManagementService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class CourseManagementServiceImpl implements ICourseManagementService {

    private static final Pattern ACADEMIC_YEAR_PATTERN = Pattern.compile("^(\\d{4}-\\d{4}学年)");

    private final CourseStudentMapper courseStudentMapper;
    private final CourseScoreRecordMapper courseScoreRecordMapper;
    private final CourseMapper courseMapper;
    private final StudentMapper studentMapper;
    private final LearningRecordMapper learningRecordMapper;

    public CourseManagementServiceImpl(CourseStudentMapper courseStudentMapper,
                                       CourseScoreRecordMapper courseScoreRecordMapper,
                                       CourseMapper courseMapper,
                                       StudentMapper studentMapper,
                                       LearningRecordMapper learningRecordMapper) {
        this.courseStudentMapper = courseStudentMapper;
        this.courseScoreRecordMapper = courseScoreRecordMapper;
        this.courseMapper = courseMapper;
        this.studentMapper = studentMapper;
        this.learningRecordMapper = learningRecordMapper;
    }

    @Override
    public CourseManagementMetaDTO getMeta() {
        CourseManagementMetaDTO meta = new CourseManagementMetaDTO();
        meta.setCourses(courseStudentMapper.selectCourseSummaries());
        meta.setTeachers(courseStudentMapper.selectTeacherOptions());
        meta.setColleges(courseStudentMapper.selectCollegeOptions());

        List<TermOptionDTO> terms = courseStudentMapper.selectTermOptions();
        meta.setTerms(terms);
        Set<String> academicYears = new LinkedHashSet<>();
        Long currentTermId = null;
        String currentTermName = null;
        for (TermOptionDTO term : terms) {
            if (term == null || !StringUtils.hasText(term.getTermName())) {
                continue;
            }
            Matcher matcher = ACADEMIC_YEAR_PATTERN.matcher(term.getTermName());
            if (matcher.find()) {
                academicYears.add(matcher.group(1));
            }
            if ("current".equalsIgnoreCase(term.getStatus()) && currentTermId == null) {
                currentTermId = term.getTermId();
                currentTermName = term.getTermName();
            }
        }
        if (currentTermId == null && !terms.isEmpty()) {
            TermOptionDTO fallback = terms.get(0);
            currentTermId = fallback.getTermId();
            currentTermName = fallback.getTermName();
        }
        meta.setAcademicYears(List.copyOf(academicYears));
        meta.setCurrentTermId(currentTermId);
        meta.setCurrentTermName(currentTermName);
        return meta;
    }

    @Override
    public List<CourseStudentDTO> getCourseStudents(Long courseId) {
        if (courseId == null) {
            throw new IllegalArgumentException("courseId 不能为空");
        }
        ensureCourseExists(courseId);
        return courseStudentMapper.selectCourseStudents(courseId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void addStudentToCourse(CourseStudentRequest request) {
        if (request == null || request.getCourseId() == null || request.getStudentId() == null) {
            throw new IllegalArgumentException("课程和学生不能为空");
        }

        ensureCourseExists(request.getCourseId());
        ensureStudentExists(request.getStudentId());

        boolean exists = courseStudentMapper.selectCount(new LambdaQueryWrapper<CourseStudent>()
                .eq(CourseStudent::getCourseId, request.getCourseId())
                .eq(CourseStudent::getStudentId, request.getStudentId())) > 0;
        if (!exists) {
            CourseStudent relation = new CourseStudent();
            relation.setCourseId(request.getCourseId());
            relation.setStudentId(request.getStudentId());
            courseStudentMapper.insert(relation);
        }

        ensureLearningRecordExists(request.getCourseId(), request.getStudentId());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public CourseStudentDTO saveCourseScore(CourseScoreRequest request) {
        if (request == null || request.getCourseId() == null || request.getStudentId() == null) {
            throw new IllegalArgumentException("课程和学生不能为空");
        }
        if (request.getFinalScore() == null) {
            throw new IllegalArgumentException("成绩不能为空");
        }

        ensureCourseExists(request.getCourseId());
        ensureStudentExists(request.getStudentId());

        CourseStudentRequest relationRequest = new CourseStudentRequest();
        relationRequest.setCourseId(request.getCourseId());
        relationRequest.setStudentId(request.getStudentId());
        addStudentToCourse(relationRequest);

        Long termId = request.getTermId() != null ? request.getTermId() : getDefaultTermId();
        if (termId == null) {
            throw new IllegalStateException("未找到可用学期，请先初始化 dim_term");
        }

        LambdaQueryWrapper<CourseScoreRecord> wrapper = new LambdaQueryWrapper<CourseScoreRecord>()
                .eq(CourseScoreRecord::getCourseId, request.getCourseId())
                .eq(CourseScoreRecord::getStudentId, request.getStudentId())
                .eq(CourseScoreRecord::getTermId, termId);
        CourseScoreRecord record = courseScoreRecordMapper.selectOne(wrapper);
        if (record == null) {
            record = new CourseScoreRecord();
            record.setCourseId(request.getCourseId());
            record.setStudentId(request.getStudentId());
            record.setTermId(termId);
        }

        BigDecimal finalScore = request.getFinalScore().setScale(2, RoundingMode.HALF_UP);
        BigDecimal usualScore = request.getUsualScore() == null
                ? finalScore
                : request.getUsualScore().setScale(2, RoundingMode.HALF_UP);
        record.setFinalScore(finalScore);
        record.setUsualScore(usualScore);
        record.setGpaPoint(resolveGpaPoint(request.getGpaPoint(), finalScore));
        record.setIsPassed(request.getPassed() != null ? request.getPassed() : finalScore.compareTo(BigDecimal.valueOf(60)) >= 0);

        if (record.getScoreId() == null) {
            courseScoreRecordMapper.insert(record);
        } else {
            courseScoreRecordMapper.updateById(record);
        }

        return courseStudentMapper.selectCourseStudents(request.getCourseId()).stream()
                .filter(item -> request.getStudentId().equals(item.getStudentId()))
                .findFirst()
                .orElse(null);
    }

    private void ensureCourseExists(Long courseId) {
        Course course = courseMapper.selectById(courseId);
        if (course == null) {
            throw new IllegalArgumentException("课程不存在");
        }
    }

    private void ensureStudentExists(Long studentId) {
        Student student = studentMapper.selectById(studentId);
        if (student == null) {
            throw new IllegalArgumentException("学生不存在");
        }
    }

    private void ensureLearningRecordExists(Long courseId, Long studentId) {
        boolean exists = learningRecordMapper.selectCount(new LambdaQueryWrapper<LearningRecord>()
                .eq(LearningRecord::getCourseId, courseId)
                .eq(LearningRecord::getUserId, studentId)) > 0;
        if (exists) {
            return;
        }

        LearningRecord learningRecord = new LearningRecord();
        learningRecord.setCourseId(courseId);
        learningRecord.setUserId(studentId);
        learningRecord.setIsOnline(0);
        learningRecord.setLastUpdated(LocalDateTime.now());
        learningRecordMapper.insert(learningRecord);
    }

    private Long getDefaultTermId() {
        List<TermOptionDTO> terms = courseStudentMapper.selectTermOptions();
        for (TermOptionDTO term : terms) {
            if ("current".equalsIgnoreCase(term.getStatus())) {
                return term.getTermId();
            }
        }
        return terms.isEmpty() ? null : terms.get(0).getTermId();
    }

    private BigDecimal resolveGpaPoint(BigDecimal requestGpaPoint, BigDecimal finalScore) {
        if (requestGpaPoint != null) {
            return requestGpaPoint.setScale(2, RoundingMode.HALF_UP);
        }
        double value = Math.max(0D, Math.min(4D, (finalScore.doubleValue() - 50D) / 10D));
        return BigDecimal.valueOf(value).setScale(2, RoundingMode.HALF_UP);
    }
}
