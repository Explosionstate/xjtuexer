package com.example.mybatisplusdemo.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.core.metadata.OrderItem;
import com.example.mybatisplusdemo.common.PageResult;
import com.example.mybatisplusdemo.mapper.StudentMapper;
import com.example.mybatisplusdemo.mapper.UsersMapper;
import com.example.mybatisplusdemo.model.domain.Student;
import com.example.mybatisplusdemo.model.domain.Users;
import com.example.mybatisplusdemo.model.dto.PageDTO;
import com.example.mybatisplusdemo.model.dto.QueryDTO;
import com.example.mybatisplusdemo.model.dto.StudentDTO;
import com.example.mybatisplusdemo.service.IStudentService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.Collections;
import java.util.List;

@Service
public class StudentServiceImpl extends ServiceImpl<StudentMapper, Student> implements IStudentService {

    @Autowired
    private StudentMapper studentMapper;
    @Autowired
    private UsersMapper usersMapper;

    @Override
    public Student getByIdMy(Long studentId) {
        Users user = usersMapper.selectOne(new LambdaQueryWrapper<Users>()
                .eq(Users::getId, studentId)
                .eq(Users::getRole, "student")
                .eq(Users::getIsDeleted, 0));
        if (user == null) {
            return null;
        }

        Student student = studentMapper.selectById(studentId);
        if (student == null) {
            return null;
        }

        if (!StringUtils.hasText(student.getName()) && StringUtils.hasText(user.getName())) {
            student.setName(user.getName());
        }
        if (!StringUtils.hasText(student.getCollege()) && StringUtils.hasText(user.getDepartmentName())) {
            student.setCollege(user.getDepartmentName());
        }
        if (student.getLearningIndex() == null) {
            student.setLearningIndex(user.getLearningIndex());
        }
        return student;
    }

    @Override
    public Page<Student> listPage(PageDTO pageDTO, Student student) {
        Page<Student> page = new Page<>(pageDTO.getPageNum(), pageDTO.getPageSize());
        return studentMapper.listPage(page, student);
    }

    @Override
    public Page<Student> listPageWithSort(QueryDTO queryDTO) {
        Page<Student> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        Student student = new Student();
        if (StringUtils.hasText(queryDTO.getLoginName())) {
            student.setName(queryDTO.getLoginName());
        }
        if (queryDTO.getId() != null) {
            student.setStudentId(queryDTO.getId());
        }
        if (StringUtils.hasText(queryDTO.getCollege())) {
            student.setCollege(queryDTO.getCollege());
        }
        return studentMapper.listPage(page, student);
    }

    @Override
    public List<Student> listByKey(String key) {
        LambdaQueryWrapper<Student> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(Student::getName, key);
        return studentMapper.selectList(wrapper);
    }

    @Override
    public Page<Student> selectByListOwn(StudentDTO studentDTO) {
        Page<Student> page = new Page<>(studentDTO.getPageNum(), studentDTO.getPageSize());

        if (StringUtils.hasText(studentDTO.getSortField()) && StringUtils.hasText(studentDTO.getSortOrder())) {
            String column = studentDTO.getSortField();
            if ("studentId".equals(column)) {
                column = "student_id";
            } else if ("learningIndex".equals(column)) {
                column = "learning_index";
            } else if ("comparisonLastMonth".equals(column)) {
                column = "comparison_last_month";
            }
            OrderItem orderItem = new OrderItem();
            orderItem.setColumn(column);
            orderItem.setAsc("asc".equalsIgnoreCase(studentDTO.getSortOrder()));
            page.setOrders(Collections.singletonList(orderItem));
        }

        return studentMapper.selectByList(page, studentDTO);
    }
}
