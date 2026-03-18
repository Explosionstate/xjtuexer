<template>
  <div class="analytics-page">
    <div class="analytics-wrapper">
      <header class="page-header">
        <h1 class="page-title">学习成绩情况</h1>
        <p class="page-desc">支持按课程、学院、日期筛选，查看本群体与全校平均成绩对比。</p>
      </header>

      <el-card class="panel-card" shadow="never">
        <template #header>
          <div class="card-header">
            <h2>学习成绩分析</h2>
          </div>
        </template>

        <div class="filter-grid">
          <el-input v-model="course" placeholder="课程名称" clearable />
          <el-input v-model="college" placeholder="学院名称" clearable />
          <el-date-picker v-model="startDate" type="date" placeholder="开始日期" value-format="YYYY-MM-DD" />
          <el-date-picker v-model="endDate" type="date" placeholder="结束日期" value-format="YYYY-MM-DD" />
        </div>

        <div class="chart-grid">
          <section class="chart-panel">
            <h3>平均综合成绩</h3>
            <div id="totalScoreChart" class="chart-box"></div>
          </section>

          <section class="chart-panel">
            <h3>作业平均分</h3>
            <div id="assignmentScoreChart" class="chart-box"></div>
          </section>

          <section class="chart-panel">
            <h3>考试平均分</h3>
            <div id="examScoreChart" class="chart-box"></div>
          </section>

          <section class="chart-panel">
            <h3>章节测验平均分</h3>
            <div id="quizScoreChart" class="chart-box"></div>
          </section>

          <section class="chart-panel chart-panel-full">
            <h3>课程积分</h3>
            <div id="courseCreditChart" class="chart-box chart-box-wide"></div>
          </section>
        </div>

        <el-table v-if="scoreData.length" :data="scoreData" border stripe class="table-box">
          <el-table-column prop="courseName" label="课程名称" min-width="220" fixed="left" />
          <el-table-column prop="avgTotalScore" label="平均综合成绩" :formatter="(row) => formatScore(row.avgTotalScore)" min-width="130" />
          <el-table-column prop="schoolAvgTotalScore" label="全校平均综合成绩" :formatter="(row) => formatScore(row.schoolAvgTotalScore)" min-width="150" />
          <el-table-column prop="avgAssignmentScore" label="作业平均分" :formatter="(row) => formatScore(row.avgAssignmentScore)" min-width="120" />
          <el-table-column prop="schoolAvgAssignmentScore" label="全校作业平均分" :formatter="(row) => formatScore(row.schoolAvgAssignmentScore)" min-width="140" />
          <el-table-column prop="avgExamScore" label="考试平均分" :formatter="(row) => formatScore(row.avgExamScore)" min-width="120" />
          <el-table-column prop="schoolAvgExamScore" label="全校考试平均分" :formatter="(row) => formatScore(row.schoolAvgExamScore)" min-width="140" />
          <el-table-column prop="avgQuizScore" label="章节测验平均分" :formatter="(row) => formatScore(row.avgQuizScore)" min-width="140" />
          <el-table-column prop="schoolAvgQuizScore" label="全校章节测验平均分" :formatter="(row) => formatScore(row.schoolAvgQuizScore)" min-width="170" />
          <el-table-column prop="courseCredit" label="课程积分" :formatter="(row) => formatScore(row.courseCredit)" min-width="100" />
          <el-table-column prop="schoolAvgCourseCredit" label="全校平均课程积分" :formatter="(row) => formatScore(row.schoolAvgCourseCredit)" min-width="150" />
        </el-table>
        <div v-else class="empty-block">暂无数据</div>
      </el-card>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, onUnmounted, watch } from 'vue';
import * as echarts from 'echarts';
import { ElMessage } from 'element-plus';
import axios from 'axios';

export default {
  name: 'ScoreAnalytics',
  setup() {
    const course = ref('');
    const college = ref('');
    const startDate = ref('');
    const endDate = ref('');
    const scoreData = ref([]);
    let totalScoreChartInstance = null;
    let assignmentScoreChartInstance = null;
    let examScoreChartInstance = null;
    let quizScoreChartInstance = null;
    let courseCreditChartInstance = null;

    const initCharts = () => {
      totalScoreChartInstance = echarts.init(document.getElementById('totalScoreChart'));
      assignmentScoreChartInstance = echarts.init(document.getElementById('assignmentScoreChart'));
      examScoreChartInstance = echarts.init(document.getElementById('examScoreChart'));
      quizScoreChartInstance = echarts.init(document.getElementById('quizScoreChart'));
      courseCreditChartInstance = echarts.init(document.getElementById('courseCreditChart'));
    };

    const setChartOption = (chartInstance, title, groupField, schoolField) => {
      if (!chartInstance) {
        return;
      }
      chartInstance.setOption({
        title: { text: title, left: 'center' },
        tooltip: { trigger: 'axis' },
        legend: { data: ['本群体', '全校平均'], top: 30 },
        xAxis: {
          type: 'category',
          data: scoreData.value.map((item) => item.courseName),
          axisLabel: { rotate: 30, interval: 0 },
        },
        yAxis: { type: 'value', name: '分数', max: groupField.includes('Credit') ? 5 : 100 },
        series: [
          {
            name: '本群体',
            type: 'bar',
            data: scoreData.value.map((item) => item[groupField]),
            itemStyle: { color: '#4B5EAA' },
            barMaxWidth: 38,
          },
          {
            name: '全校平均',
            type: 'bar',
            data: scoreData.value.map((item) => item[schoolField]),
            itemStyle: { color: '#F4A261' },
            barMaxWidth: 38,
          },
        ],
      });
    };

    const updateCharts = () => {
      setChartOption(totalScoreChartInstance, '平均综合成绩', 'avgTotalScore', 'schoolAvgTotalScore');
      setChartOption(assignmentScoreChartInstance, '作业平均分', 'avgAssignmentScore', 'schoolAvgAssignmentScore');
      setChartOption(examScoreChartInstance, '考试平均分', 'avgExamScore', 'schoolAvgExamScore');
      setChartOption(quizScoreChartInstance, '章节测验平均分', 'avgQuizScore', 'schoolAvgQuizScore');
      setChartOption(courseCreditChartInstance, '课程积分', 'courseCredit', 'schoolAvgCourseCredit');
    };

    const fetchCourseScores = async () => {
      try {
        const response = await axios.get('/api/scores/courseScores', {
          params: {
            course: course.value,
            college: college.value,
            startDate: startDate.value ? new Date(startDate.value).toISOString().split('T')[0] : '',
            endDate: endDate.value ? new Date(endDate.value).toISOString().split('T')[0] : '',
          },
        });
        if (response.data.status && response.data.code === 0) {
          scoreData.value = response.data.data || [];
          updateCharts();
        } else {
          ElMessage.error(response.data.message || '获取学习成绩数据失败');
        }
      } catch (error) {
        ElMessage.error(`请求失败: ${error.message}`);
      }
    };

    const formatScore = (value) => {
      const num = Number(value);
      return Number.isFinite(num) ? num.toFixed(2) : '0.00';
    };

    onMounted(() => {
      initCharts();
      fetchCourseScores();
    });

    onUnmounted(() => {
      if (totalScoreChartInstance) totalScoreChartInstance.dispose();
      if (assignmentScoreChartInstance) assignmentScoreChartInstance.dispose();
      if (examScoreChartInstance) examScoreChartInstance.dispose();
      if (quizScoreChartInstance) quizScoreChartInstance.dispose();
      if (courseCreditChartInstance) courseCreditChartInstance.dispose();
    });

    watch([course, college, startDate, endDate], fetchCourseScores);

    return {
      course,
      college,
      startDate,
      endDate,
      scoreData,
      formatScore,
    };
  },
};
</script>

<style scoped>
.analytics-page {
  min-height: calc(100vh - 125px);
  background: #f5f7fb;
  padding: 24px;
}

.analytics-wrapper {
  max-width: 1360px;
  margin: 0 auto;
}

.page-header {
  margin-bottom: 18px;
}

.page-title {
  margin: 0;
  font-size: 28px;
  font-weight: 700;
  color: #1f2d3d;
}

.page-desc {
  margin: 8px 0 0;
  color: #5f6b7a;
  font-size: 14px;
  line-height: 1.6;
}

.panel-card {
  border-radius: 12px;
  border: 1px solid #e4e9f2;
  box-shadow: 0 6px 18px rgba(31, 45, 61, 0.05);
}

.card-header h2 {
  margin: 0;
  font-size: 19px;
  font-weight: 600;
  color: #1f2d3d;
}

.filter-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 12px;
  margin-bottom: 18px;
}

.chart-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14px;
}

.chart-panel {
  border: 1px solid #edf1f7;
  background: #fafcff;
  border-radius: 10px;
  padding: 12px;
}

.chart-panel h3 {
  margin: 0 0 8px;
  font-size: 15px;
  color: #364152;
}

.chart-panel-full {
  grid-column: 1 / -1;
}

.chart-box {
  width: 100%;
  height: 320px;
}

.chart-box-wide {
  height: 360px;
}

.table-box {
  margin-top: 16px;
}

.empty-block {
  margin-top: 16px;
  padding: 16px;
  border-radius: 10px;
  background: #f7f9fc;
  color: #8b96a6;
  text-align: center;
}

@media (max-width: 1200px) {
  .filter-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 768px) {
  .analytics-page {
    padding: 16px;
  }

  .page-title {
    font-size: 23px;
  }

  .filter-grid,
  .chart-grid {
    grid-template-columns: 1fr;
  }

  .chart-box,
  .chart-box-wide {
    height: 300px;
  }
}
</style>
