package com.example.mybatisplusdemo.service.impl;

import com.example.mybatisplusdemo.mapper.CourseCompletionMapper;
import com.example.mybatisplusdemo.model.dto.CourseCompletionDTO;
import com.example.mybatisplusdemo.service.ICourseCompletionService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class CourseCompletionServiceImpl implements ICourseCompletionService {

    private static final Pattern ACADEMIC_YEAR_PATTERN = Pattern.compile("^(\\d{4})-(\\d{4})学年$");

    private final CourseCompletionMapper courseCompletionMapper;

    public CourseCompletionServiceImpl(CourseCompletionMapper courseCompletionMapper) {
        this.courseCompletionMapper = courseCompletionMapper;
    }

    @Override
    public List<CourseCompletionDTO> getCompletions(String group1College,
                                                    String group2College,
                                                    String group1Course,
                                                    String group2Course,
                                                    String group1Semester,
                                                    String group2Semester) {
        List<CourseCompletionDTO> result = new ArrayList<>(2);
        result.add(selectCompletion(group1College, group1Course, group1Semester));
        result.add(selectCompletion(group2College, group2Course, group2Semester));
        return result;
    }

    private CourseCompletionDTO selectCompletion(String college, String course, String semester) {
        AcademicYearRange range = resolveAcademicYearRange(semester);
        return courseCompletionMapper.selectCompletion(
                normalize(college),
                normalize(course),
                range.displayValue(),
                range.startDate().toString(),
                range.endDate().toString()
        );
    }

    private String normalize(String value) {
        if (!StringUtils.hasText(value)) {
            return null;
        }
        return value.trim();
    }

    private AcademicYearRange resolveAcademicYearRange(String semester) {
        String normalized = normalize(semester);
        if (normalized != null) {
            Matcher matcher = ACADEMIC_YEAR_PATTERN.matcher(normalized);
            if (matcher.matches()) {
                int startYear = Integer.parseInt(matcher.group(1));
                int endYear = Integer.parseInt(matcher.group(2));
                if (endYear == startYear + 1) {
                    return new AcademicYearRange(
                            normalized,
                            LocalDate.of(startYear, 9, 1),
                            LocalDate.of(endYear, 8, 31)
                    );
                }
            }
        }

        LocalDate today = LocalDate.now();
        int startYear = today.getMonthValue() >= 9 ? today.getYear() : today.getYear() - 1;
        int endYear = startYear + 1;
        return new AcademicYearRange(
                startYear + "-" + endYear + "学年",
                LocalDate.of(startYear, 9, 1),
                LocalDate.of(endYear, 8, 31)
        );
    }

    private record AcademicYearRange(String displayValue, LocalDate startDate, LocalDate endDate) {
    }
}
