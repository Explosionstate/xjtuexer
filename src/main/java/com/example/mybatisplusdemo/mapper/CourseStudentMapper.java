package com.example.mybatisplusdemo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.mybatisplusdemo.model.domain.CourseStudent;
import com.example.mybatisplusdemo.model.dto.CourseStudentDTO;
import com.example.mybatisplusdemo.model.dto.CourseSummaryDTO;
import com.example.mybatisplusdemo.model.dto.TeacherOptionDTO;
import com.example.mybatisplusdemo.model.dto.TermOptionDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CourseStudentMapper extends BaseMapper<CourseStudent> {
    List<CourseSummaryDTO> selectCourseSummaries();

    List<TeacherOptionDTO> selectTeacherOptions();

    List<String> selectCollegeOptions();

    List<TermOptionDTO> selectTermOptions();

    List<CourseStudentDTO> selectCourseStudents(Long courseId);
}
