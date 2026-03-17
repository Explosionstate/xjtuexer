<script setup>
import {ref, computed, onMounted, onBeforeUnmount, watch} from "vue";
import { pageStudents } from "@/api/student";
import * as XLSX from "xlsx";

// ============= 数据状态 =============
const students = ref([]);
const pageNum = ref(1);
const pageSize = ref(10);
const name = ref('');
const total = ref(0);
const college = ref('');
const dateRange = ref([]);
const sortField = ref('');
const sortOrder = ref('');

// ============= 预警和时间 =============
const currentPeriod = ref('day');
const currentDateTime = ref('');
const clockTimer = ref(null);

// ============= 详情模态框 =============
const showDetailModal = ref(false);
const selectedStudent = ref({});

// ============= 工具函数 =============

/**
 * 安全的数字转换
 * @param {*} value - 要转换的值
 * @param {number} fallback - 转换失败时的默认值
 * @returns {number} 转换后的数字
 */
const toNumber = (value, fallback = 0) => {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : fallback;
};

/**
 * 格式化分数显示
 * @param {*} value - 分数值
 * @returns {string} 格式化后的字符串
 */
const formatScore = (value) => {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed.toFixed(2) : '--';
};

/**
 * 获取学情指数等级（改进版）
 * @param {*} index - 学情指数值
 * @returns {string} 等级名称
 */
const getLearningIndexLevel = (index) => {
  const value = toNumber(index, -1);

  // 数据缺失
  if (value === -1) return 'missing';

  // 根据分数范围返回等级
  // 假设分数范围是 0-5
  if (value >= 4.5) return 'excellent';   // 优秀
  if (value >= 3.5) return 'good';        // 良好
  if (value >= 2.5) return 'fair';        // 一般
  if (value >= 0) return 'poor';          // 较差

  return 'invalid';  // 无效数据
};

/**
 * 获取学情指数等级的显示文本
 */
const getLearningIndexLevelText = (index) => {
  const level = getLearningIndexLevel(index);
  const levelMap = {
    excellent: '优秀',
    good: '良好',
    fair: '一般',
    poor: '较差',
    missing: '--',
    invalid: '异常',
  };
  return levelMap[level] || '--';
};

/**
 * 计算学生的未解除预警次数
 * @param {Object} student - 学生对象
 * @returns {number} 未解除预警次数
 */
const unresolvedCount = (student) => {
  const totalWarnings = toNumber(student?.totalWarnings, 0);
  const resolvedWarnings = toNumber(student?.resolvedWarnings, 0);

  // 数据验证：解除次数不能超过总次数
  if (resolvedWarnings > totalWarnings) {
    console.warn(`学生 ${student?.name} 的预警数据异常: 解除(${resolvedWarnings}) > 总计(${totalWarnings})`);
  }

  return Math.max(0, totalWarnings - resolvedWarnings);
};

/**
 * 数据验证函数
 * @param {Object} student - 学生对象
 * @returns {Object} 验证结果和错误信息
 */
const validateStudentData = (student) => {
  const errors = [];

  // 验证学情指数
  const learningIndex = toNumber(student?.learningIndex, null);
  if (learningIndex === null) {
    errors.push('学情指数缺失');
  } else if (learningIndex < 0 || learningIndex > 5) {
    errors.push(`学情指数超出范围(0-5): ${learningIndex}`);
  }

  // 验证预警数据一致性
  const totalWarnings = toNumber(student?.totalWarnings, 0);
  const resolvedWarnings = toNumber(student?.resolvedWarnings, 0);
  if (resolvedWarnings > totalWarnings) {
    errors.push(`解除(${resolvedWarnings})超过总计(${totalWarnings})`);
  }

  // 验证对比百分比
  const comparison = toNumber(student?.comparisonLastMonth, null);
  if (comparison !== null && (comparison < -100 || comparison > 100)) {
    errors.push(`对比百分比异常: ${comparison}%`);
  }

  return {
    isValid: errors.length === 0,
    errors: errors,
    severity: errors.length > 0 ? (errors.length > 1 ? 'error' : 'warning') : 'success'
  };
};

// ============= 统计计算 =============

/**
 * 预警统计信息（改进版 - 区分人和次）
 */
const warningStatistics = computed(() => {
  const stats = {
    studentsWithWarnings: 0,      // 有未解除预警的学生数
    totalUnresolvedWarnings: 0,   // 未解除预警总次数
    warningRate: 0,               // 预警率（百分比）
  };

  students.value.forEach((student) => {
    const unresolved = unresolvedCount(student);
    if (unresolved > 0) {
      stats.studentsWithWarnings += 1;
      stats.totalUnresolvedWarnings += unresolved;
    }
  });

  // 计算预警率
  if (students.value.length > 0) {
    stats.warningRate = ((stats.studentsWithWarnings / students.value.length) * 100).toFixed(2);
  }

  return stats;
});

/**
 * 学情指数统计
 */
const learningIndexStatistics = computed(() => {
  if (students.value.length === 0) {
    return {
      average: 0,
      max: 0,
      min: 0,
      excellent: 0,    // >= 4.5
      good: 0,         // >= 3.5
      fair: 0,         // >= 2.5
      poor: 0,         // < 2.5
    };
  }

  const indices = students.value
      .map(s => toNumber(s.learningIndex, -1))
      .filter(idx => idx >= 0);

  if (indices.length === 0) {
    return { average: 0, max: 0, min: 0, excellent: 0, good: 0, fair: 0, poor: 0 };
  }

  const stats = {
    average: (indices.reduce((a, b) => a + b) / indices.length).toFixed(2),
    max: Math.max(...indices).toFixed(2),
    min: Math.min(...indices).toFixed(2),
    excellent: indices.filter(idx => idx >= 4.5).length,
    good: indices.filter(idx => idx >= 3.5 && idx < 4.5).length,
    fair: indices.filter(idx => idx >= 2.5 && idx < 3.5).length,
    poor: indices.filter(idx => idx < 2.5).length,
  };

  return stats;
});

/**
 * 过期的计算属性（保留以兼容旧代码）
 */
const warningCount = computed(() => warningStatistics.value.studentsWithWarnings);
const changeCount = computed(() => warningStatistics.value.totalUnresolvedWarnings);
const isPositive = computed(() => changeCount.value > 0);

// ============= 日期和时间 =============

onMounted(() => {
  const updateDateTime = () => {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const weekday = ['日', '一', '二', '三', '四', '五', '六'][now.getDay()];
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const seconds = String(now.getSeconds()).padStart(2, '0');
    currentDateTime.value = `${year}-${month}-${day} 星期${weekday} ${hours}:${minutes}:${seconds}`;
  };

  updateDateTime();
  clockTimer.value = window.setInterval(updateDateTime, 1000);
});

onBeforeUnmount(() => {
  if (clockTimer.value) {
    window.clearInterval(clockTimer.value);
    clockTimer.value = null;
  }
});

const warningText = computed(() => {
  const periodMap = { day: '今日', weak: '本周', month: '本月', year: '本年' };
  return `${periodMap[currentPeriod.value]}预警学生数：${warningCount.value} 人`;
});

const changeText = computed(() => `当前未解除预警：${changeCount.value} 次`);

const changePeriod = (period) => {
  currentPeriod.value = period;
  dateRange.value = [];  // 切换时期时清空日期范围
};

// ============= API 调用 =============

/**
 * 获取学生列表 - 改进版（包含日期参数）
 */
const getStudents = () => {
  const query = {
    pageNum: pageNum.value,
    pageSize: pageSize.value,
    name: name.value,
    college: college.value,
    sortField: sortField.value,
    sortOrder: sortOrder.value,
    // ✅ 新增：时间相关参数
    currentPeriod: currentPeriod.value,
    startDate: dateRange.value?.[0] || null,
    endDate: dateRange.value?.[1] || null,
  };

  pageStudents(query).then((res) => {
    // 在获取数据后添加验证信息
    students.value = (res?.data?.records || []).map(student => ({
      ...student,
      _validation: validateStudentData(student),  // 添加验证信息
    }));
    total.value = res?.data?.total || 0;
  }).catch((error) => {
    console.error('获取学生列表失败:', error);
    students.value = [];
    total.value = 0;
  });
};

const handleSortChange = ({ prop, order }) => {
  if (order) {
    sortField.value = prop;
    sortOrder.value = order === 'ascending' ? 'asc' : 'desc';
  } else {
    sortField.value = '';
    sortOrder.value = '';
  }
  pageNum.value = 1;  // 排序时重置页码
  getStudents();
};

const handleSizeChange = (value) => {
  pageSize.value = value;
  pageNum.value = 1;
  getStudents();
};

const pageNumChange = (value) => {
  pageNum.value = value;
  getStudents();
};

const handleViewDetail = (row) => {
  selectedStudent.value = row;
  showDetailModal.value = true;
};

// ============= Excel 导出 =============

const exportExcel = () => {
  const headers = {
    name: "姓名",
    studentId: "学号",
    college: "学院",
    learningIndex: "学情指数",
    learningIndexLevel: "学情等级",
    comparisonLastMonth: "对比上月",
    totalWarnings: "累计预警次数",
    resolvedWarnings: "累计解除次数",
    unresolvedWarnings: "未解除次数",
  };

  const data = students.value.map(student => ({
    [headers.name]: student.name,
    [headers.studentId]: student.studentId,
    [headers.college]: student.college,
    [headers.learningIndex]: formatScore(student.learningIndex),
    [headers.learningIndexLevel]: getLearningIndexLevelText(student.learningIndex),
    [headers.comparisonLastMonth]: formatScore(student.comparisonLastMonth),
    [headers.totalWarnings]: student.totalWarnings,
    [headers.resolvedWarnings]: student.resolvedWarnings,
    [headers.unresolvedWarnings]: unresolvedCount(student),
  }));

  const worksheet = XLSX.utils.json_to_sheet(data);
  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, worksheet, "学生学情表");

  XLSX.writeFile(workbook, "学生学情表.xlsx");
};

// ============= 初始化 =============

// 默认设置为"今日"
changePeriod('day');

// 监听时期变化，自动查询
watch(currentPeriod, () => {
  getStudents();
});

// 初始加载
getStudents();
</script>

<template>
  <el-card class="page-container">
    <template #header>
      <div class="header">
        <span class="title">学情预警</span>
      </div>
    </template>

    <el-form :inline="true" class="demo-form-inline">
      <el-form-item>
        <el-input v-model="name" placeholder="请输入学生姓名查询" clearable @keyup.enter="getStudents"/>
      </el-form-item>
      <el-form-item>
        <el-select v-model="college" placeholder="-请选择院系-" clearable style="width: 200px;" @change="getStudents">
          <el-option label="计算机科学与技术学院" value="计算机科学与技术学院" class="custom-option"/>
          <el-option label="电子工程学院" value="电子工程学院" class="custom-option"/>
          <el-option label="机械工程学院" value="机械工程学院" class="custom-option"/>
          <el-option label="经济管理学院" value="经济管理学院" class="custom-option"/>
          <el-option label="外国语学院" value="外国语学院" class="custom-option"/>
          <el-option label="法学院" value="法学院" class="custom-option"/>
          <el-option label="医学院" value="医学院" class="custom-option"/>
          <el-option label="艺术学院" value="艺术学院" class="custom-option"/>
          <el-option label="建筑学院" value="建筑学院" class="custom-option"/>
          <el-option label="环境科学与工程学院" value="环境科学与工程学院" class="custom-option"/>
          <el-option label="材料科学与工程学院" value="材料科学与工程学院" class="custom-option"/>
          <el-option label="化学与化工学院" value="化学与化工学院" class="custom-option"/>
          <el-option label="数学学院" value="数学学院" class="custom-option"/>
          <el-option label="物理学院" value="物理学院" class="custom-option"/>
          <el-option label="生命科学学院" value="生命科学学院" class="custom-option"/>
          <el-option label="土木工程学院" value="土木工程学院" class="custom-option"/>
          <el-option label="信息工程学院" value="信息工程学院" class="custom-option"/>
          <el-option label="自动化学院" value="自动化学院" class="custom-option"/>
          <el-option label="能源与动力工程学院" value="能源与动力工程学院" class="custom-option"/>
          <el-option label="航空航天学院" value="航空航天学院" class="custom-option"/>
          <el-option label="软件学院" value="软件学院" class="custom-option"/>
        </el-select>
      </el-form-item>
      <el-form-item class="query-bar">
        <el-row :gutter="20" type="flex" align="middle">
          <el-col :span="9" align="middle" >
            <el-button-group>
              <el-button type="primary" plain @click="changePeriod('day')">今日</el-button>
              <el-button type="primary" plain @click="changePeriod('weak')">本周</el-button>
              <el-button type="primary" plain @click="changePeriod('month')">本月</el-button>
              <el-button type="primary" plain @click="changePeriod('year')">本年</el-button>
            </el-button-group>
          </el-col>
          <el-col :span="10">
            <el-date-picker
                v-model="dateRange"
                type="daterange"
                range-separator="—"
                start-placeholder="开始日期"
                end-placeholder="结束日期"
                format="YYYY.MM.DD"
                value-format="YYYY.MM.DD"
                style="width: 100%; padding-right: 0px;"
                @change="getStudents"
            ></el-date-picker>
          </el-col>
          <el-col :span="2">
            <el-button type="primary" @click="getStudents" style="width: 100%; margin-left: 10px;">查询</el-button>
          </el-col>
          <el-col :span="3">
            <el-button type="primary" @click="exportExcel" style="width: 100%; margin-left: 10px;">导出Excel</el-button>
          </el-col>
        </el-row>
      </el-form-item>
    </el-form>

    <!-- 统计信息区域（改进版） -->
    <el-form-item class="stats-container">
      <div class="stats-main">
        <div class="stats-item">
          <span class="stats-label">预警学生数：</span>
          <span class="stats-value warning">{{ warningStatistics.studentsWithWarnings }}</span>
          <span class="stats-unit">人</span>
        </div>
        <div class="stats-item">
          <span class="stats-label">未解除预警：</span>
          <span class="stats-value alert">{{ warningStatistics.totalUnresolvedWarnings }}</span>
          <span class="stats-unit">次</span>
        </div>
        <div class="stats-item">
          <span class="stats-label">预警率：</span>
          <span class="stats-value">{{ warningStatistics.warningRate }}</span>
          <span class="stats-unit">%</span>
        </div>
        <div class="divider"></div>
        <div class="stats-item">
          <span class="stats-label">学情指数平均：</span>
          <span class="stats-value">{{ learningIndexStatistics.average }}</span>
        </div>
        <div class="stats-item">
          <span class="stats-label">优秀/良好/一般/较差：</span>
          <span class="stats-value">{{ learningIndexStatistics.excellent }}/{{ learningIndexStatistics.good }}/{{ learningIndexStatistics.fair }}/{{ learningIndexStatistics.poor }}</span>
        </div>
      </div>
      <div class="datetime-module">
        {{ currentDateTime }}
      </div>
    </el-form-item>

    <!-- 表格 -->
    <el-table :data="students" style="width: 100%" @sort-change="handleSortChange" stripe>
      <el-table-column prop="name" label="姓名">
        <template #header>
          <div class="cell">姓名<span class="caret-wrapper"></span></div>
        </template>
      </el-table-column>
      <el-table-column prop="studentId" label="学号" sortable="custom">
        <template #header>
          <div class="cell">学号<span class="caret-wrapper"></span></div>
        </template>
      </el-table-column>
      <el-table-column prop="college" label="学院">
        <template #header>
          <div class="cell">学院<span class="caret-wrapper"></span></div>
        </template>
      </el-table-column>
      <el-table-column prop="learningIndex" label="学情指数" align="center" sortable="custom" width="120">
        <template #header>
          <div class="cell">学情指数<span class="caret-wrapper"></span></div>
        </template>
        <template #default="{row}">
          <div style="display: flex; align-items: center; justify-content: center;">
            <el-tag
                :type="getLearningIndexLevel(row.learningIndex)"
                :effect="'light'"
            >
              {{ formatScore(row.learningIndex) }}
            </el-tag>
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="comparisonLastMonth" label="对比上月" align="center" sortable="custom" width="120">
        <template #header>
          <div class="cell">对比上月<span class="caret-wrapper"></span></div>
        </template>
        <template #default="{row}">
          <div style="display: flex; align-items: center; justify-content: center;">
            <span v-if="toNumber(row.comparisonLastMonth, 0) > 0" style="color: green;">
              ▲ {{ formatScore(row.comparisonLastMonth) }}%
            </span>
            <span v-else-if="toNumber(row.comparisonLastMonth, 0) < 0" style="color: red;">
              ▼ {{ formatScore(Math.abs(toNumber(row.comparisonLastMonth, 0))) }}%
            </span>
            <span v-else>{{ formatScore(row.comparisonLastMonth) }}%</span>
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="totalWarnings" label="累计预警" align="center" width="100">
        <template #header>
          <div class="cell">累计预警<span class="caret-wrapper"></span></div>
        </template>
      </el-table-column>
      <el-table-column prop="resolvedWarnings" label="累计解除" align="center" width="100">
        <template #header>
          <div class="cell">累计解除<span class="caret-wrapper"></span></div>
        </template>
      </el-table-column>
      <el-table-column label="未解除" align="center" width="80">
        <template #default="{row}">
          <el-tag type="danger" v-if="unresolvedCount(row) > 0">
            {{ unresolvedCount(row) }}
          </el-tag>
          <span v-else style="color: #999;">0</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" width="80">
        <template #default="{row}">
          <el-tag v-if="row._validation.isValid" type="success">正常</el-tag>
          <el-tooltip v-else effect="dark" placement="top">
            <template #content>
              <div v-for="error in row._validation.errors" :key="error">
                {{ error }}
              </div>
            </template>
            <el-tag type="danger">异常</el-tag>
          </el-tooltip>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="120" align="center" fixed="right">
        <template #default="scope">
          <el-button type="text" @click="handleViewDetail(scope.row)">查看详情</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 详情对话框 -->
    <el-dialog v-model="showDetailModal" title="学生详情" width="35%" align-center destroy-on-close>
      <div class="detail-content">
        <el-row :gutter="20">
          <el-col :span="12">
            <div class="detail-item">
              <span class="detail-label">姓名：</span>
              <span class="detail-value">{{ selectedStudent.name }}</span>
            </div>
          </el-col>
          <el-col :span="12">
            <div class="detail-item">
              <span class="detail-label">学号：</span>
              <span class="detail-value">{{ selectedStudent.studentId }}</span>
            </div>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <div class="detail-item">
              <span class="detail-label">学院：</span>
              <span class="detail-value">{{ selectedStudent.college }}</span>
            </div>
          </el-col>
          <el-col :span="12">
            <div class="detail-item">
              <span class="detail-label">专业：</span>
              <span class="detail-value">{{ selectedStudent.majorName || '--' }}</span>
            </div>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <div class="detail-item">
              <span class="detail-label">班级：</span>
              <span class="detail-value">{{ selectedStudent.className || '--' }}</span>
            </div>
          </el-col>
          <el-col :span="12">
            <div class="detail-item">
              <span class="detail-label">年级：</span>
              <span class="detail-value">{{ selectedStudent.gradeYear || '--' }}</span>
            </div>
          </el-col>
        </el-row>
        <el-divider />
        <el-row :gutter="20">
          <el-col :span="24">
            <div class="detail-item">
              <span class="detail-label">学情指数：</span>
              <el-tag :type="getLearningIndexLevel(selectedStudent.learningIndex)">
                {{ formatScore(selectedStudent.learningIndex) }} ({{ getLearningIndexLevelText(selectedStudent.learningIndex) }})
              </el-tag>
            </div>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="24">
            <div class="detail-item">
              <span class="detail-label">对比上月：</span>
              <span v-if="toNumber(selectedStudent.comparisonLastMonth, 0) > 0" style="color: green;">
                +{{ formatScore(selectedStudent.comparisonLastMonth) }}%
              </span>
              <span v-else-if="toNumber(selectedStudent.comparisonLastMonth, 0) < 0" style="color: red;">
                {{ formatScore(selectedStudent.comparisonLastMonth) }}%
              </span>
              <span v-else>
                {{ formatScore(selectedStudent.comparisonLastMonth) }}%
              </span>
            </div>
          </el-col>
        </el-row>
        <el-divider />
        <el-row :gutter="20">
          <el-col :span="12">
            <div class="detail-item">
              <span class="detail-label">学习成绩：</span>
              <span class="detail-value">{{ formatScore(selectedStudent.learningScores) }}</span>
            </div>
          </el-col>
          <el-col :span="12">
            <div class="detail-item">
              <span class="detail-label">课程平均分：</span>
              <span class="detail-value">{{ formatScore(selectedStudent.averageCourseScores) }}</span>
            </div>
          </el-col>
        </el-row>
        <el-divider />
        <el-row :gutter="20">
          <el-col :span="12">
            <div class="detail-item">
              <span class="detail-label">累计预警：</span>
              <span class="detail-value">{{ selectedStudent.totalWarnings }}</span>
            </div>
          </el-col>
          <el-col :span="12">
            <div class="detail-item">
              <span class="detail-label">累计解除：</span>
              <span class="detail-value">{{ selectedStudent.resolvedWarnings }}</span>
            </div>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="24">
            <div class="detail-item">
              <span class="detail-label">未解除预警：</span>
              <el-tag type="danger" v-if="unresolvedCount(selectedStudent) > 0">
                {{ unresolvedCount(selectedStudent) }}
              </el-tag>
              <span v-else style="color: #999;">0</span>
            </div>
          </el-col>
        </el-row>
      </div>
      <template #footer>
        <el-button @click="showDetailModal = false">关闭</el-button>
      </template>
    </el-dialog>

    <!-- 分页 -->
    <el-pagination
        :background="true"
        v-model:current-page="pageNum"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total"
        @size-change="handleSizeChange"
        @current-change="pageNumChange"
        style="display: flex; justify-content: flex-end; margin-top: 20px;"
    />
  </el-card>
</template>

<style scoped>
.page-container {
  background: linear-gradient(135deg, #e6f0fa, #ffffff);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  border-radius: 10px;
  padding: 20px;
}

.header {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 15px 0;
  width: 100%;
  background: linear-gradient(135deg, #2a6eb6, #1e87d7, #0d9cf2);
  border-radius: 10px 10px 0 0;
}

.title {
  color: rgba(0, 255, 255, 0.9);
  font-family: "SimSun", serif;
  font-size: 46px;
  font-weight: bold;
  letter-spacing: 2px;
  text-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
}

.demo-form-inline {
  background-color: #ffffff;
  padding: 15px;
  border-radius: 8px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
  margin-top: 20px;
}

/* 改进的统计区域 */
.stats-container {
  display: flex !important;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  background-color: #f5f7fa;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  margin-top: 20px;
  flex-wrap: wrap;
}

.stats-main {
  display: flex;
  gap: 20px;
  flex: 1;
  flex-wrap: wrap;
  align-items: center;
}

.stats-item {
  display: flex;
  align-items: center;
  gap: 5px;
}

.stats-label {
  font-weight: 500;
  color: #666;
}

.stats-value {
  font-size: 18px;
  font-weight: bold;
}

.stats-value.warning {
  color: #f56c6c;
}

.stats-value.alert {
  color: #ff9800;
}

.stats-unit {
  color: #999;
}

.divider {
  width: 1px;
  height: 24px;
  background-color: #ddd;
}

.datetime-module {
  font-size: 14px;
  color: #666;
  white-space: nowrap;
}

/* 详情对话框样式 */
.detail-content {
  padding: 10px 0;
}

.detail-item {
  padding: 8px 0;
  display: flex;
  align-items: center;
  gap: 10px;
}

.detail-label {
  font-weight: 500;
  min-width: 100px;
  color: #666;
}

.detail-value {
  color: #333;
}

/* El-tag 类型映射 */
:deep(.el-tag) {
  &.excellent {
    background-color: #f0f9ff;
    border-color: #67c23a;
    color: #67c23a;
  }
  &.good {
    background-color: #ecf5ff;
    border-color: #409eff;
    color: #409eff;
  }
  &.fair {
    background-color: #fdf6ec;
    border-color: #e6a23c;
    color: #e6a23c;
  }
  &.poor {
    background-color: #fef0f0;
    border-color: #f56c6c;
    color: #f56c6c;
  }
  &.missing {
    background-color: #f5f7fa;
    border-color: #999;
    color: #999;
  }
}
</style>
