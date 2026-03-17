<script setup>
import {ref, computed, onMounted, onBeforeUnmount} from "vue";
import { pageStudents } from "@/api/student";
import * as XLSX from "xlsx";

const students = ref([]);
const pageNum = ref(1);
const pageSize = ref(10);
const name = ref('');
const total = ref(0);
const college = ref('');
const dateRange = ref([]);
const sortField = ref('');
const sortOrder = ref('');
//预警与标识
const currentPeriod = ref('day');
const currentDateTime = ref('');
const clockTimer = ref(null);
//查看详情
const showDetailModal = ref(false);
const selectedStudent = ref({});

const exportExcel = () => {
  const headers = {
    name: "姓名",
    studentId: "学号",
    college: "学院",
    learningIndex: "学情指数",
    comparisonLastMonth: "对比上月",
    totalWarnings: "累计预警次数",
    resolvedWarnings: "累计解除次数"
  };

  const data = students.value.map(student => ({
    [headers.name]: student.name,
    [headers.studentId]: student.studentId,
    [headers.college]: student.college,
    [headers.learningIndex]: student.learningIndex,
    [headers.comparisonLastMonth]: student.comparisonLastMonth,
    [headers.totalWarnings]: student.totalWarnings,
    [headers.resolvedWarnings]: student.resolvedWarnings
  }));

  const worksheet = XLSX.utils.json_to_sheet(data);
  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, worksheet, "学生学情表");

  XLSX.writeFile(workbook, "学生学情表.xlsx");
};

const toNumber = (value, fallback = 0) => {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : fallback;
};

const unresolvedCount = (student) => {
  const totalWarnings = toNumber(student?.totalWarnings, 0);
  const resolvedWarnings = toNumber(student?.resolvedWarnings, 0);
  return Math.max(0, totalWarnings - resolvedWarnings);
};

const warningCount = computed(() => (
  students.value.filter((student) => unresolvedCount(student) > 0).length
));

const changeCount = computed(() => (
  students.value.reduce((sum, student) => sum + unresolvedCount(student), 0)
));

const isPositive = computed(() => changeCount.value > 0);

// 日期显示模块
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
  return `${periodMap[currentPeriod.value]}预警人数：${warningCount.value} 人`;
});

const changeText = computed(() => `当前未解除预警：${changeCount.value} 人次`);

const changePeriod = (period) => {
  currentPeriod.value = period;
};

changePeriod('day');

const formatScore = (value) => {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed.toFixed(2) : '--';
};

const getStudents = () => {
  const query = {
    pageNum: pageNum.value,
    pageSize: pageSize.value,
    name: name.value,
    college: college.value,
    sortField: sortField.value,
    sortOrder: sortOrder.value,
  };
  pageStudents(query).then((res) => {
    students.value = res?.data?.records || [];
    total.value = res?.data?.total || 0;
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
        <el-input v-model="name" placeholder="请输入学生姓名查询" clearable/>
      </el-form-item>
      <el-form-item>
        <el-select v-model="college" placeholder="-请选择院系-" clearable style="width: 200px;">
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

    <el-form-item class="stats-title">
      <div>
        <span class="warning-count">{{ warningText }}</span>
        <span :class="['change-count', isPositive ? 'negative' : 'positive']" style="margin-left: 20px">
          {{ changeText }}
        </span>
      </div>
      <div class="datetime-module">
        {{ currentDateTime }}
      </div>
    </el-form-item>

    <el-table :data="students" style="width: 100%" @sort-change="handleSortChange">
      <el-table-column prop="name" label="姓名">
        <template #header>
          <div class="cell">姓名<span class="caret-wrapper"></span></div>
        </template>
      </el-table-column>
      <el-table-column prop="studentId" label="学号" sortable="custom">
        <template #header>
          <div class="cell">学号<span class="caret-wrapper">
            </span>
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="college" label="学院">
        <template #header>
          <div class="cell">学院<span class="caret-wrapper"></span></div>
        </template>
      </el-table-column>
      <el-table-column prop="learningIndex" label="学情指数" align="center" sortable="custom">
        <template #header>
          <div class="cell">学情指数<span class="caret-wrapper">
            </span>
          </div>
        </template>
        <template #default="{row}">
          <div style="display: flex; align-items: center; justify-content: center;">
      <span
          class="learning-index-circle"
          :class="{'low-score': toNumber(row.learningIndex, 0) < 4, 'high-score': toNumber(row.learningIndex, 0) >= 4}"
      ></span>
            <span style="margin-left: 8px;">{{ formatScore(row.learningIndex) }}</span>
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="comparisonLastMonth" label="对比上月" align="center" sortable="custom">
        <template #header>
          <div class="cell">对比上月<span class="caret-wrapper">
            </span>
          </div>
        </template>
        <template #default="{row}">
          <div style="display: flex; align-items: center; justify-content: center;">
            <span v-if="toNumber(row.comparisonLastMonth, 0) > 0" style="color: green;">▲ {{ formatScore(row.comparisonLastMonth) }}</span>
            <span v-else-if="toNumber(row.comparisonLastMonth, 0) < 0" style="color: red;">▼ {{ formatScore(Math.abs(toNumber(row.comparisonLastMonth, 0))) }}</span>
            <span v-else>{{ formatScore(row.comparisonLastMonth) }}</span>
            <span style="margin-left: 4px;">%</span>
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="totalWarnings" label="累计预警次数" align="center">
        <template #header>
          <div class="cell">累计预警次数<span class="caret-wrapper"></span></div>
        </template>
      </el-table-column>
      <el-table-column prop="resolvedWarnings" label="累计解除次数" align="center">
        <template #header>
          <div class="cell">累计解除次数<span class="caret-wrapper"></span></div>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="180" align="center">
        <template #default="scope">
          <el-button type="text" @click="handleViewDetail(scope.row)">查看详情</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="showDetailModal" title="学生详情" width="30%" align-center>
      <div style="text-align: center;">
        <p>姓名: {{ selectedStudent.name }}</p>
        <p>学号: {{ selectedStudent.studentId }}</p>
        <p>学院: {{ selectedStudent.college }}</p>
        <p>专业: {{ selectedStudent.majorName || '--' }}</p>
        <p>班级: {{ selectedStudent.className || '--' }}</p>
        <p>年级: {{ selectedStudent.gradeYear || '--' }}</p>
        <p>学情指数: {{ formatScore(selectedStudent.learningIndex) }}</p>
        <p>
          对比上月:
          <span v-if="toNumber(selectedStudent.comparisonLastMonth, 0) > 0" style="color: green;">
            +{{ formatScore(selectedStudent.comparisonLastMonth) }}%
          </span>
          <span v-else-if="toNumber(selectedStudent.comparisonLastMonth, 0) < 0" style="color: red;">
            -{{ formatScore(Math.abs(toNumber(selectedStudent.comparisonLastMonth, 0))) }}%
          </span>
          <span v-else>
            {{ formatScore(selectedStudent.comparisonLastMonth) }}%
          </span>
        </p>
        <p>学习成绩: {{ formatScore(selectedStudent.learningScores) }}</p>
        <p>课程平均分: {{ formatScore(selectedStudent.averageCourseScores) }}</p>
      </div>
      <template #footer>
        <el-button @click="showDetailModal = false">关闭</el-button>
      </template>
    </el-dialog>

    <el-pagination
        :background="true"
        v-model:current-page="pageNum"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total"
        @size-change="handleSizeChange"
        @current-change="pageNumChange"
        style="display: flex; justify-content: right;"
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

.stats-title {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px;
  background-color: #f5f7fa;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  margin-top: 20px;
}

.warning-count {
  font-weight: bold;
  font-size: 16px;
  margin-right: 15px;
}

.change-count {
  font-weight: bold;
  font-size: 16px;
}

.datetime-module {
  font-size: 16px;
  color: #444;
  font-weight: 500;
  margin-left: auto;
}

.positive {
  color: #67c23a;
}

.negative {
  color: #f56c6c;
}

.el-dialog {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  border-radius: 10px;
}

.learning-index-circle {
  display: inline-block;
  width: 16px;
  height: 16px;
  border-radius: 50%;
}

.low-score {
  background-color: #ff4757;
}

.high-score {
  background-color: #2ed573;
}
</style>
