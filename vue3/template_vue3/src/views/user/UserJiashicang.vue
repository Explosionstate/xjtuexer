<template>
  <div class="cockpit-page">
    <div class="cockpit-wrapper">
      <header class="page-header">
        <div>
          <h1 class="page-title">教学驾驶舱</h1>
          <p class="page-desc">保留原有统计概览，并补充课程、学生和成绩的录入维护能力。</p>
        </div>
      </header>

      <section class="stats-grid">
        <el-card v-for="item in statCards" :key="item.key" class="stat-card" shadow="never">
          <span class="stat-label">{{ item.label }}</span>
          <strong class="stat-value">{{ item.value }}</strong>
        </el-card>
      </section>

      <section class="overview-grid">
        <el-card class="panel-card" shadow="never">
          <template #header>
            <div class="card-header">
              <h2>学情指数分布</h2>
              <div class="segment-actions">
                <el-button
                  v-for="segment in learningIndexSegments"
                  :key="segment.label"
                  size="small"
                  :type="currentSegmentLabel === segment.label ? 'primary' : 'default'"
                  @click="changeLearningIndexSegment(segment)"
                >
                  {{ segment.label }}
                </el-button>
              </div>
            </div>
          </template>

          <div id="learningIndexChart" class="chart-box"></div>

          <el-table v-if="learningIndexList.length" :data="learningIndexList" border stripe class="compact-table">
            <el-table-column prop="name" label="姓名" min-width="120" />
            <el-table-column label="学号" min-width="120">
              <template #default="{ row }">
                {{ row.loginName || row.id }}
              </template>
            </el-table-column>
            <el-table-column prop="learningIndex" label="学情指数" min-width="110" />
            <el-table-column prop="departmentName" label="学院" min-width="140" />
          </el-table>
          <div v-else class="empty-block">当前区间暂无学生</div>

          <div class="pagination-wrap">
            <el-pagination
              v-if="learningIndexPage.total > 0"
              :background="true"
              v-model:current-page="learningIndexPage.pageNum"
              v-model:page-size="learningIndexPage.pageSize"
              :page-sizes="[10, 20, 50, 100]"
              layout="total, sizes, prev, pager, next, jumper"
              :total="learningIndexPage.total"
              @size-change="refreshLearningIndexList"
              @current-change="refreshLearningIndexList"
            />
          </div>
        </el-card>

        <div class="stack-panel">
          <el-card class="panel-card" shadow="never">
            <template #header>
              <div class="card-header">
                <h2>学院访问排行</h2>
              </div>
            </template>

            <el-table v-if="departmentRanking.length" :data="departmentRanking" border stripe class="compact-table">
              <el-table-column prop="name" label="学院" min-width="140" />
              <el-table-column prop="visits" label="访问量" min-width="90" />
            </el-table>
            <div v-else class="empty-block">暂无排行数据</div>
          </el-card>

          <el-card class="panel-card" shadow="never">
            <template #header>
              <div class="card-header">
                <h2>直播课情况</h2>
              </div>
            </template>

            <el-table v-if="liveSessions.length" :data="liveSessions" border stripe class="compact-table">
              <el-table-column prop="courseName" label="课程名称" min-width="160" />
              <el-table-column prop="teacher" label="教师" min-width="120" />
              <el-table-column prop="startTime" label="开始时间" min-width="160">
                <template #default="{ row }">
                  {{ formatLiveSessionStartTime(row.startTime) }}
                </template>
              </el-table-column>
              <el-table-column prop="status" label="状态" min-width="100">
                <template #default="{ row }">
                  {{ formatLiveSessionStatus(row.status) }}
                </template>
              </el-table-column>
            </el-table>
            <div v-else class="empty-block">暂无直播课数据</div>
          </el-card>
        </div>
      </section>

      <el-card class="panel-card management-card" shadow="never">
        <template #header>
          <div class="card-header">
            <div>
              <h2>课程管理</h2>
              <p class="card-tip">先选课程，再添加学生、录入成绩或修改成绩。</p>
            </div>
            <div class="toolbar-actions">
              <el-button type="primary" @click="openCourseDialog">添加课程</el-button>
              <el-button :disabled="!selectedCourseId" @click="openStudentDialog">为课程添加学生</el-button>
              <el-button :disabled="!selectedCourseId" @click="refreshCourseStudents">刷新当前课程</el-button>
            </div>
          </div>
        </template>

        <div class="management-layout">
          <section class="course-column">
            <div class="section-head">
              <div class="section-title">课程列表</div>
              <span class="section-meta">共 {{ courseList.length }} 门</span>
            </div>
            <el-table
              :data="courseList"
              border
              stripe
              highlight-current-row
              row-key="courseId"
              :current-row-key="selectedCourseId"
              @current-change="handleCourseChange"
              class="course-table"
              :max-height="managementTableMaxHeight"
            >
              <el-table-column prop="title" label="课程" min-width="180" />
              <el-table-column prop="teacherName" label="教师" min-width="120" />
              <el-table-column prop="studentCount" label="学生数" width="88" />
              <el-table-column prop="scoreCount" label="成绩数" width="88" />
            </el-table>
          </section>

          <section class="student-column">
            <div class="section-head">
              <div class="section-title">当前课程学生与成绩</div>
              <span v-if="selectedCourseId" class="section-meta">共 {{ courseStudents.length }} 人</span>
            </div>

            <div v-if="selectedCourse" class="course-summary">
              <div class="summary-item">
                <span>课程</span>
                <strong>{{ selectedCourse.title }}</strong>
              </div>
              <div class="summary-item">
                <span>教师</span>
                <strong>{{ selectedCourse.teacherName || '--' }}</strong>
              </div>
              <div class="summary-item">
                <span>学生数</span>
                <strong>{{ selectedCourse.studentCount ?? 0 }}</strong>
              </div>
              <div class="summary-item">
                <span>成绩数</span>
                <strong>{{ selectedCourse.scoreCount ?? 0 }}</strong>
              </div>
            </div>

            <div v-if="selectedCourseId" class="student-table-wrap">
              <el-table
                v-if="courseStudents.length"
                :data="pagedCourseStudents"
                border
                stripe
                class="student-table"
                :max-height="managementTableMaxHeight"
              >
                <el-table-column prop="studentNo" label="学号" min-width="120" />
                <el-table-column prop="studentName" label="姓名" min-width="120" />
                <el-table-column prop="college" label="学院" min-width="140" />
                <el-table-column prop="termName" label="学期" min-width="170">
                  <template #default="{ row }">
                    {{ row.termName || currentTermName || '--' }}
                  </template>
                </el-table-column>
                <el-table-column prop="usualScore" label="平时分" min-width="90">
                  <template #default="{ row }">
                    {{ formatScore(row.usualScore) }}
                  </template>
                </el-table-column>
                <el-table-column prop="finalScore" label="期末分" min-width="90">
                  <template #default="{ row }">
                    {{ formatScore(row.finalScore) }}
                  </template>
                </el-table-column>
                <el-table-column prop="gpaPoint" label="绩点" min-width="80">
                  <template #default="{ row }">
                    {{ formatScore(row.gpaPoint) }}
                  </template>
                </el-table-column>
                <el-table-column prop="passed" label="状态" min-width="90">
                  <template #default="{ row }">
                    <el-tag :type="row.passed === false ? 'danger' : 'success'">
                      {{ row.scoreId ? (row.passed === false ? '未通过' : '已录入') : '未录入' }}
                    </el-tag>
                  </template>
                </el-table-column>
                <el-table-column label="操作" width="160" fixed="right">
                  <template #default="{ row }">
                    <el-button type="primary" link @click="openScoreDialog(row)">
                      {{ row.scoreId ? '修改成绩' : '录入成绩' }}
                    </el-button>
                  </template>
                </el-table-column>
              </el-table>
              <div v-if="courseStudents.length" class="pagination-wrap management-pagination">
                <el-pagination
                  :background="true"
                  v-model:current-page="courseStudentPage.pageNum"
                  v-model:page-size="courseStudentPage.pageSize"
                  :page-sizes="[6, 8, 10, 12]"
                  layout="total, sizes, prev, pager, next, jumper"
                  :total="courseStudents.length"
                  @size-change="handleCourseStudentPageSizeChange"
                  @current-change="handleCourseStudentPageChange"
                />
              </div>
              <div v-else class="empty-block">当前课程还没有学生，请先添加学生。</div>
            </div>
            <div v-else class="empty-block">请先在左侧选择一门课程。</div>
          </section>
        </div>
      </el-card>
    </div>

    <el-dialog v-model="courseDialogVisible" title="添加课程" width="640px" destroy-on-close>
      <el-form label-width="96px" class="dialog-form">
        <el-form-item label="课程名称">
          <el-input v-model="courseForm.title" placeholder="请输入课程名称" />
        </el-form-item>
        <el-form-item label="授课教师">
          <el-select v-model="courseForm.teacherId" placeholder="请选择教师" filterable>
            <el-option
              v-for="item in teacherOptions"
              :key="item.teacherId"
              :label="item.teacherName"
              :value="item.teacherId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="章节 JSON">
          <el-input v-model="courseForm.chaptersText" type="textarea" :rows="4" />
        </el-form-item>
        <el-form-item label="资料 JSON">
          <el-input v-model="courseForm.materialsText" type="textarea" :rows="4" />
        </el-form-item>
        <el-form-item label="任务点 JSON">
          <el-input v-model="courseForm.taskPointsText" type="textarea" :rows="4" />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="courseDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submittingCourse" @click="submitCourse">保存课程</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="studentDialogVisible" title="为课程添加学生" width="880px" destroy-on-close>
      <div class="dialog-toolbar">
        <el-input v-model="studentQuery.name" placeholder="按姓名搜索学生" clearable @keyup.enter="fetchCandidateStudents" />
        <el-select v-model="studentQuery.college" placeholder="学院筛选" clearable @change="fetchCandidateStudents">
          <el-option v-for="item in collegeOptionsWithoutAll" :key="item" :label="item" :value="item" />
        </el-select>
        <el-button type="primary" @click="fetchCandidateStudents">查询</el-button>
      </div>

      <el-table :data="candidateStudents" border stripe class="candidate-table">
        <el-table-column prop="studentNo" label="学号" min-width="120">
          <template #default="{ row }">
            {{ row.studentNo || row.studentId }}
          </template>
        </el-table-column>
        <el-table-column prop="name" label="姓名" min-width="120" />
        <el-table-column prop="college" label="学院" min-width="140" />
        <el-table-column prop="learningIndex" label="学情指数" min-width="100" />
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <el-button
              type="primary"
              link
              :disabled="assignedStudentIdSet.has(row.studentId)"
              @click="handleAddStudent(row)"
            >
              {{ assignedStudentIdSet.has(row.studentId) ? '已添加' : '添加' }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-wrap">
        <el-pagination
          :background="true"
          v-model:current-page="studentQuery.pageNum"
          v-model:page-size="studentQuery.pageSize"
          :page-sizes="[10, 20, 50]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="candidateTotal"
          @size-change="fetchCandidateStudents"
          @current-change="fetchCandidateStudents"
        />
      </div>
    </el-dialog>

    <el-dialog v-model="scoreDialogVisible" :title="scoreDialogTitle" width="520px" destroy-on-close>
      <el-form label-width="96px" class="dialog-form">
        <el-form-item label="学生">
          <el-input :model-value="scoreStudentLabel" disabled />
        </el-form-item>
        <el-form-item label="学期">
          <el-select v-model="scoreForm.termId" placeholder="请选择学期" filterable>
            <el-option v-for="item in termOptions" :key="item.termId" :label="item.termName" :value="item.termId" />
          </el-select>
        </el-form-item>
        <el-form-item label="平时分">
          <el-input-number v-model="scoreForm.usualScore" :min="0" :max="100" :precision="2" controls-position="right" />
        </el-form-item>
        <el-form-item label="期末分">
          <el-input-number v-model="scoreForm.finalScore" :min="0" :max="100" :precision="2" controls-position="right" />
        </el-form-item>
        <el-form-item label="绩点">
          <el-input-number v-model="scoreForm.gpaPoint" :min="0" :max="4" :step="0.1" :precision="2" controls-position="right" />
        </el-form-item>
        <el-form-item label="是否通过">
          <el-switch v-model="scoreForm.passed" />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="scoreDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submittingScore" @click="submitScore">保存成绩</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, nextTick, onMounted, onUnmounted, reactive, ref, watch } from 'vue';
import * as echarts from 'echarts';
import { ElMessage } from 'element-plus';
import {
  addStudentToCourse,
  getCourseManagementMeta,
  getCourseStudents,
  getDashboardStats,
  getDepartmentRanking,
  getLearningIndex,
  getLearningIndexList,
  getLiveSessions,
  insertCourse,
  saveCourseScore,
} from '@/api/api.js';
import { pageStudents } from '@/api/student';

const stats = ref({});
const learningIndex = ref([]);
const learningIndexList = ref([]);
const departmentRanking = ref([]);
const liveSessions = ref([]);
const courseList = ref([]);
const teacherOptions = ref([]);
const collegeOptions = ref(['全校']);
const termOptions = ref([]);
const currentTermId = ref(null);
const currentTermName = ref('');
const selectedCourseId = ref(null);
const courseStudents = ref([]);
const candidateStudents = ref([]);
const candidateTotal = ref(0);
const currentSegmentLabel = ref('极好');

const learningIndexPage = reactive({
  pageNum: 1,
  pageSize: 10,
  total: 0,
});
const courseStudentPage = reactive({
  pageNum: 1,
  pageSize: 8,
});
const learningIndexQuery = reactive({
  min: 8,
  max: 10,
});
const studentQuery = reactive({
  pageNum: 1,
  pageSize: 10,
  name: '',
  college: '',
});
const courseDialogVisible = ref(false);
const submittingCourse = ref(false);
const studentDialogVisible = ref(false);
const scoreDialogVisible = ref(false);
const submittingScore = ref(false);
const editingStudent = ref(null);
const courseForm = reactive({
  title: '',
  teacherId: null,
  chaptersText: '[{"id":1,"title":"章节1"}]',
  materialsText: '[{"id":1,"title":"资料1"}]',
  taskPointsText: '[{"id":1,"title":"任务点1"}]',
});
const scoreForm = reactive({
  courseId: null,
  studentId: null,
  termId: null,
  usualScore: null,
  finalScore: null,
  gpaPoint: null,
  passed: true,
});

const learningIndexSegments = [
  { label: '极差', min: 0, max: 2 },
  { label: '较差', min: 2, max: 4 },
  { label: '一般', min: 4, max: 6 },
  { label: '较好', min: 6, max: 8 },
  { label: '极好', min: 8, max: 10 },
];
const managementTableMaxHeight = 520;

let learningIndexChartInstance = null;
let resizeHandler = null;

const formatScore = (value) => {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed.toFixed(2) : '--';
};

const formatLiveSessionStatus = (status) => {
  const statusMap = {
    ended: '已结束',
    scheduled: '未开始',
    live: '直播中',
  };
  return statusMap[status] || status || '--';
};

const formatLiveSessionStartTime = (value) => {
  if (!value) {
    return '--';
  }
  return String(value).replace('T', ' ');
};

const statCards = computed(() => [
  { key: 'checkInCompleted', label: '签到完成', value: stats.value?.checkInCompleted ?? 0 },
  { key: 'onlineUsers', label: '在线学习记录', value: stats.value?.onlineUsers ?? 0 },
  { key: 'totalUsers', label: '学生总数', value: stats.value?.totalUsers ?? 0 },
  { key: 'taskPointsCompleted', label: '任务点完成', value: stats.value?.taskPointsCompleted ?? 0 },
  { key: 'teachers', label: '教师总数', value: stats.value?.teachers ?? 0 },
  { key: 'courses', label: '课程总数', value: stats.value?.courses ?? 0 },
  { key: 'chapterResources', label: '章节资源', value: stats.value?.chapterResources ?? 0 },
  { key: 'courseMaterials', label: '课程资料', value: stats.value?.courseMaterials ?? 0 },
  { key: 'taskPoints', label: '任务点数', value: stats.value?.taskPoints ?? 0 },
]);

const selectedCourse = computed(() =>
  courseList.value.find((item) => item.courseId === selectedCourseId.value) || null
);

const pagedCourseStudents = computed(() => {
  const start = (courseStudentPage.pageNum - 1) * courseStudentPage.pageSize;
  const end = start + courseStudentPage.pageSize;
  return courseStudents.value.slice(start, end);
});

const assignedStudentIdSet = computed(() => new Set(courseStudents.value.map((item) => item.studentId)));

const collegeOptionsWithoutAll = computed(() =>
  collegeOptions.value.filter((item) => item !== '全校')
);

const scoreDialogTitle = computed(() => (editingStudent.value?.scoreId ? '修改成绩' : '录入成绩'));
const scoreStudentLabel = computed(() => {
  if (!editingStudent.value) {
    return '';
  }
  return `${editingStudent.value.studentName} (${editingStudent.value.studentNo})`;
});

const initChart = () => {
  const chartDom = document.getElementById('learningIndexChart');
  if (!chartDom) {
    return;
  }
  learningIndexChartInstance = echarts.init(chartDom);
};

const renderLearningIndexChart = (data = []) => {
  if (!learningIndexChartInstance) {
    return;
  }
  if (!data.length) {
    learningIndexChartInstance.clear();
    learningIndexChartInstance.setOption({
      title: {
        text: '暂无学情指数数据',
        left: 'center',
        top: 'middle',
        textStyle: { color: '#8b96a6', fontSize: 16 },
      },
    });
    learningIndexChartInstance.resize();
    return;
  }

  learningIndexChartInstance.setOption({
    title: { text: '学情指数分布', left: 'center' },
    tooltip: { trigger: 'item', formatter: '{b}: {c}% ({d}%)' },
    legend: { orient: 'vertical', left: 'left' },
    series: [
      {
        name: '学情指数',
        type: 'pie',
        radius: ['42%', '68%'],
        data: data.map((item) => ({
          value: item.percentage || 0,
          name: item.label || '未知',
        })),
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.25)',
          },
        },
      },
    ],
  });
  learningIndexChartInstance.resize();
};

const fetchDashboardStats = async () => {
  try {
    const response = await getDashboardStats();
    stats.value = response.data || {};
  } catch (error) {
    ElMessage.error(error?.message || '获取统计数据失败');
  }
};

const fetchLearningIndex = async () => {
  try {
    const response = await getLearningIndex();
    learningIndex.value = response.data || [];
    await nextTick();
    renderLearningIndexChart(learningIndex.value);
  } catch (error) {
    ElMessage.error(error?.message || '获取学情指数分布失败');
  }
};

const refreshLearningIndexList = async () => {
  try {
    const response = await getLearningIndexList({
      min: learningIndexQuery.min,
      max: learningIndexQuery.max,
      pageNum: learningIndexPage.pageNum,
      pageSize: learningIndexPage.pageSize,
    });
    learningIndexList.value = response.data?.records || [];
    learningIndexPage.total = response.data?.total || 0;
  } catch (error) {
    ElMessage.error(error?.message || '获取学情学生列表失败');
  }
};

const changeLearningIndexSegment = (segment) => {
  currentSegmentLabel.value = segment.label;
  learningIndexQuery.min = segment.min;
  learningIndexQuery.max = segment.max;
  learningIndexPage.pageNum = 1;
  refreshLearningIndexList();
};

const fetchDepartmentRanking = async () => {
  try {
    const response = await getDepartmentRanking();
    departmentRanking.value = response.data || [];
  } catch (error) {
    ElMessage.error(error?.message || '获取学院排行失败');
  }
};

const fetchLiveSessions = async () => {
  try {
    const response = await getLiveSessions();
    liveSessions.value = response.data || [];
  } catch (error) {
    ElMessage.error(error?.message || '获取直播课数据失败');
  }
};

const fetchMeta = async () => {
  try {
    const response = await getCourseManagementMeta();
    const meta = response.data || {};
    courseList.value = meta.courses || [];
    teacherOptions.value = meta.teachers || [];
    collegeOptions.value = ['全校', ...(meta.colleges || [])];
    termOptions.value = meta.terms || [];
    currentTermId.value = meta.currentTermId || null;
    currentTermName.value = meta.currentTermName || '';

    if (!selectedCourseId.value && courseList.value.length) {
      selectedCourseId.value = courseList.value[0].courseId;
    } else if (
      selectedCourseId.value &&
      !courseList.value.some((item) => item.courseId === selectedCourseId.value)
    ) {
      selectedCourseId.value = courseList.value[0]?.courseId || null;
    }
  } catch (error) {
    ElMessage.error(error?.message || '获取课程元数据失败');
  }
};

const normalizeCourseStudentPage = () => {
  const totalPages = Math.max(1, Math.ceil(courseStudents.value.length / courseStudentPage.pageSize));
  if (courseStudentPage.pageNum > totalPages) {
    courseStudentPage.pageNum = totalPages;
  }
};

const refreshCourseStudents = async () => {
  if (!selectedCourseId.value) {
    courseStudents.value = [];
    courseStudentPage.pageNum = 1;
    return;
  }
  try {
    const response = await getCourseStudents(selectedCourseId.value);
    courseStudents.value = response.data || [];
    normalizeCourseStudentPage();
  } catch (error) {
    ElMessage.error(error?.message || '获取课程学生列表失败');
  }
};

const handleCourseStudentPageSizeChange = () => {
  courseStudentPage.pageNum = 1;
  normalizeCourseStudentPage();
};

const handleCourseStudentPageChange = (page) => {
  courseStudentPage.pageNum = page;
};

const handleCourseChange = (row) => {
  selectedCourseId.value = row?.courseId || null;
};

const resetCourseForm = () => {
  courseForm.title = '';
  courseForm.teacherId = teacherOptions.value[0]?.teacherId || null;
  courseForm.chaptersText = '[{"id":1,"title":"章节1"}]';
  courseForm.materialsText = '[{"id":1,"title":"资料1"}]';
  courseForm.taskPointsText = '[{"id":1,"title":"任务点1"}]';
};

const openCourseDialog = () => {
  resetCourseForm();
  courseDialogVisible.value = true;
};

const parseJsonText = (text, fieldLabel) => {
  const content = (text || '').trim() || '[]';
  try {
    const parsed = JSON.parse(content);
    if (!Array.isArray(parsed)) {
      throw new Error(`${fieldLabel} 需要是数组`);
    }
    return parsed;
  } catch (error) {
    throw new Error(`${fieldLabel} JSON 格式错误`);
  }
};

const submitCourse = async () => {
  if (!courseForm.title.trim()) {
    ElMessage.warning('请输入课程名称');
    return;
  }
  if (!courseForm.teacherId) {
    ElMessage.warning('请选择授课教师');
    return;
  }

  let chapters;
  let materials;
  let taskPoints;
  try {
    chapters = parseJsonText(courseForm.chaptersText, '章节');
    materials = parseJsonText(courseForm.materialsText, '资料');
    taskPoints = parseJsonText(courseForm.taskPointsText, '任务点');
  } catch (error) {
    ElMessage.warning(error.message);
    return;
  }

  submittingCourse.value = true;
  try {
    const response = await insertCourse({
      title: courseForm.title.trim(),
      teacherId: courseForm.teacherId,
      chapters,
      materials,
      taskPoints,
    });
    courseDialogVisible.value = false;
    await fetchMeta();
    selectedCourseId.value = response.data?.courseId || selectedCourseId.value;
    await refreshCourseStudents();
    ElMessage.success('课程已添加');
  } catch (error) {
    ElMessage.error(error?.message || '保存课程失败');
  } finally {
    submittingCourse.value = false;
  }
};

const openStudentDialog = async () => {
  if (!selectedCourseId.value) {
    ElMessage.warning('请先选择课程');
    return;
  }
  studentQuery.pageNum = 1;
  studentDialogVisible.value = true;
  await fetchCandidateStudents();
};

const fetchCandidateStudents = async () => {
  try {
    const response = await pageStudents({
      pageNum: studentQuery.pageNum,
      pageSize: studentQuery.pageSize,
      name: studentQuery.name,
      college: studentQuery.college,
    });
    candidateStudents.value = response.data?.records || [];
    candidateTotal.value = response.data?.total || 0;
  } catch (error) {
    ElMessage.error(error?.message || '获取学生列表失败');
  }
};

const handleAddStudent = async (row) => {
  if (!selectedCourseId.value || !row?.studentId) {
    return;
  }
  try {
    await addStudentToCourse({
      courseId: selectedCourseId.value,
      studentId: row.studentId,
    });
    await Promise.all([fetchMeta(), refreshCourseStudents(), fetchCandidateStudents()]);
    ElMessage.success('学生已加入课程');
  } catch (error) {
    ElMessage.error(error?.message || '添加学生失败');
  }
};

const openScoreDialog = (row) => {
  editingStudent.value = row;
  scoreForm.courseId = selectedCourseId.value;
  scoreForm.studentId = row.studentId;
  scoreForm.termId = row.termId || currentTermId.value;
  scoreForm.usualScore = row.usualScore == null ? null : Number(row.usualScore);
  scoreForm.finalScore = row.finalScore == null ? null : Number(row.finalScore);
  scoreForm.gpaPoint = row.gpaPoint == null ? null : Number(row.gpaPoint);
  scoreForm.passed = row.passed == null ? true : Boolean(row.passed);
  scoreDialogVisible.value = true;
};

const submitScore = async () => {
  if (!scoreForm.courseId || !scoreForm.studentId) {
    ElMessage.warning('缺少课程或学生信息');
    return;
  }
  if (scoreForm.finalScore == null) {
    ElMessage.warning('请输入期末分');
    return;
  }

  submittingScore.value = true;
  try {
    await saveCourseScore({
      courseId: scoreForm.courseId,
      studentId: scoreForm.studentId,
      termId: scoreForm.termId,
      usualScore: scoreForm.usualScore,
      finalScore: scoreForm.finalScore,
      gpaPoint: scoreForm.gpaPoint,
      passed: scoreForm.passed,
    });
    scoreDialogVisible.value = false;
    await Promise.all([fetchMeta(), refreshCourseStudents()]);
    ElMessage.success('成绩已保存');
  } catch (error) {
    ElMessage.error(error?.message || '保存成绩失败');
  } finally {
    submittingScore.value = false;
  }
};

watch(selectedCourseId, () => {
  courseStudentPage.pageNum = 1;
  refreshCourseStudents();
});

watch(() => courseStudentPage.pageSize, () => {
  courseStudentPage.pageNum = 1;
  normalizeCourseStudentPage();
});

onMounted(async () => {
  initChart();
  await Promise.all([
    fetchDashboardStats(),
    fetchLearningIndex(),
    refreshLearningIndexList(),
    fetchDepartmentRanking(),
    fetchLiveSessions(),
    fetchMeta(),
  ]);
  resizeHandler = () => learningIndexChartInstance?.resize();
  window.addEventListener('resize', resizeHandler);
});

onUnmounted(() => {
  if (resizeHandler) {
    window.removeEventListener('resize', resizeHandler);
  }
  if (learningIndexChartInstance) {
    learningIndexChartInstance.dispose();
    learningIndexChartInstance = null;
  }
});
</script>

<style scoped>
.cockpit-page {
  min-height: calc(100vh - 125px);
  background: #f5f7fb;
  padding: 24px;
}

.cockpit-wrapper {
  max-width: 1440px;
  margin: 0 auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 16px;
  margin-bottom: 18px;
}

.page-title {
  margin: 0;
  font-size: 30px;
  font-weight: 700;
  color: #1f2d3d;
}

.page-desc {
  margin: 8px 0 0;
  color: #5f6b7a;
  font-size: 14px;
  line-height: 1.6;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 14px;
  margin-bottom: 18px;
}

.stat-card,
.panel-card {
  border-radius: 14px;
  border: 1px solid #e4e9f2;
  box-shadow: 0 8px 24px rgba(31, 45, 61, 0.05);
}

.stat-card :deep(.el-card__body) {
  display: flex;
  flex-direction: column;
  gap: 10px;
  min-height: 112px;
}

.stat-label {
  color: #667085;
  font-size: 14px;
}

.stat-value {
  font-size: 28px;
  color: #1d4ed8;
  font-weight: 700;
}

.overview-grid {
  display: grid;
  grid-template-columns: 1.35fr 1fr;
  gap: 16px;
  margin-bottom: 18px;
}

.stack-panel {
  display: grid;
  gap: 16px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 12px;
}

.card-header h2 {
  margin: 0;
  font-size: 18px;
  color: #1f2d3d;
}

.card-tip {
  margin: 6px 0 0;
  color: #7a8699;
  font-size: 13px;
}

.segment-actions,
.toolbar-actions,
.dialog-toolbar {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.chart-box {
  width: 100%;
  height: 320px;
  margin-bottom: 14px;
}

.compact-table {
  width: 100%;
}

.pagination-wrap {
  display: flex;
  justify-content: flex-end;
  margin-top: 14px;
}

.empty-block {
  padding: 22px;
  border-radius: 12px;
  background: #f7f9fc;
  color: #8b96a6;
  text-align: center;
}

.management-card {
  margin-bottom: 24px;
}

.management-layout {
  display: grid;
  grid-template-columns: minmax(320px, 0.95fr) minmax(0, 1.4fr);
  gap: 16px;
  align-items: stretch;
}

.course-column,
.student-column {
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 16px;
  border-radius: 12px;
  border: 1px solid #e6edf5;
  background: linear-gradient(180deg, #fbfdff 0%, #f7f9fc 100%);
}

.section-head {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
}

.section-title {
  margin: 0;
  font-size: 15px;
  font-weight: 600;
  color: #344054;
}

.section-meta {
  display: inline-flex;
  align-items: center;
  padding: 4px 10px;
  border-radius: 999px;
  background: #eef4ff;
  color: #3658b3;
  font-size: 12px;
  font-weight: 600;
  white-space: nowrap;
}

.course-table,
.student-table,
.candidate-table {
  width: 100%;
}

.student-table-wrap {
  display: flex;
  flex: 1;
  flex-direction: column;
  min-height: 0;
}

.course-summary {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 12px;
  margin-bottom: 14px;
}

.summary-item {
  display: flex;
  flex-direction: column;
  gap: 6px;
  padding: 12px 14px;
  border-radius: 12px;
  background: #f8fafc;
  border: 1px solid #e6edf5;
}

.summary-item span {
  color: #667085;
  font-size: 13px;
}

.summary-item strong {
  color: #0f172a;
  font-size: 16px;
}

.dialog-form :deep(.el-select),
.dialog-form :deep(.el-input-number) {
  width: 100%;
}

.dialog-toolbar {
  margin-bottom: 14px;
}

.dialog-toolbar :deep(.el-input),
.dialog-toolbar :deep(.el-select) {
  width: 240px;
}

.management-pagination {
  margin-top: 14px;
}

@media (max-width: 1280px) {
  .stats-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .overview-grid,
  .management-layout {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .cockpit-page {
    padding: 16px;
  }

  .page-title {
    font-size: 24px;
  }

  .stats-grid,
  .course-summary {
    grid-template-columns: 1fr;
  }

  .chart-box {
    height: 280px;
  }

  .dialog-toolbar {
    flex-direction: column;
  }

  .dialog-toolbar :deep(.el-input),
  .dialog-toolbar :deep(.el-select) {
    width: 100%;
  }
}
</style>
