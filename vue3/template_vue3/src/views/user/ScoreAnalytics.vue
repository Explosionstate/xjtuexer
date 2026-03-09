<template>
  <div class="p-6 bg-gray-100 min-h-screen">
    <h1 class="text-2xl font-bold mb-6">学习成绩情况</h1>

    <!-- 筛选条件 -->
    <el-card class="mb-6">
      <h2 class="text-xl font-bold mb-4">学习成绩分析</h2>
      <div class="mb-4 flex items-center">
        <el-input v-model="course" placeholder="课程名称" class="mr-4 w-1/4" />
        <el-input v-model="college" placeholder="学院名称" class="mr-4 w-1/4" />
        <el-date-picker v-model="startDate" type="date" placeholder="开始日期" class="mr-4" />
        <el-date-picker v-model="endDate" type="date" placeholder="结束日期" />
      </div>

      <!-- 平均综合成绩 -->
      <div class="mb-6">
        <h3 class="text-lg font-semibold mb-2">平均综合成绩</h3>
        <div id="totalScoreChart" style="width: 100%; height: 400px;"></div>
      </div>

      <!-- 作业平均分 -->
      <div class="mb-6">
        <h3 class="text-lg font-semibold mb-2">作业平均分</h3>
        <div id="assignmentScoreChart" style="width: 100%; height: 400px;"></div>
      </div>

      <!-- 考试平均分 -->
      <div class="mb-6">
        <h3 class="text-lg font-semibold mb-2">考试平均分</h3>
        <div id="examScoreChart" style="width: 100%; height: 400px;"></div>
      </div>

      <!-- 章节测验平均分 -->
      <div class="mb-6">
        <h3 class="text-lg font-semibold mb-2">章节测验平均分</h3>
        <div id="quizScoreChart" style="width: 100%; height: 400px;"></div>
      </div>

      <!-- 课程积分 -->
      <div class="mb-6">
        <h3 class="text-lg font-semibold mb-2">课程积分</h3>
        <div id="courseCreditChart" style="width: 100%; height: 400px;"></div>
      </div>

      <!-- 数据表格 -->
      <el-table :data="scoreData" style="width: 100%" class="mt-4" v-if="scoreData.length">
        <el-table-column prop="courseName" label="课程名称" />
        <el-table-column prop="avgTotalScore" label="平均综合成绩" :formatter="row => row.avgTotalScore.toFixed(2)" />
        <el-table-column prop="schoolAvgTotalScore" label="全校平均综合成绩" :formatter="row => row.schoolAvgTotalScore.toFixed(2)" />
        <el-table-column prop="avgAssignmentScore" label="作业平均分" :formatter="row => row.avgAssignmentScore.toFixed(2)" />
        <el-table-column prop="schoolAvgAssignmentScore" label="全校作业平均分" :formatter="row => row.schoolAvgAssignmentScore.toFixed(2)" />
        <el-table-column prop="avgExamScore" label="考试平均分" :formatter="row => row.avgExamScore.toFixed(2)" />
        <el-table-column prop="schoolAvgExamScore" label="全校考试平均分" :formatter="row => row.schoolAvgExamScore.toFixed(2)" />
        <el-table-column prop="avgQuizScore" label="章节测验平均分" :formatter="row => row.avgQuizScore.toFixed(2)" />
        <el-table-column prop="schoolAvgQuizScore" label="全校章节测验平均分" :formatter="row => row.schoolAvgQuizScore.toFixed(2)" />
        <el-table-column prop="courseCredit" label="课程积分" :formatter="row => row.courseCredit.toFixed(2)" />
        <el-table-column prop="schoolAvgCourseCredit" label="全校平均课程积分" :formatter="row => row.schoolAvgCourseCredit.toFixed(2)" />
      </el-table>
      <div v-else>暂无数据</div>
    </el-card>
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
      chartInstance.setOption({
        title: { text: title, left: 'center' },
        tooltip: { trigger: 'axis' },
        legend: { data: ['本群体', '全校平均'], top: 30 },
        xAxis: {
          type: 'category',
          data: scoreData.value.map(item => item.courseName),
          axisLabel: { rotate: 45, interval: 0 },
        },
        yAxis: { type: 'value', name: '分数', max: groupField.includes('Credit') ? 5 : 100 },
        series: [
          {
            name: '本群体',
            type: 'bar',
            data: scoreData.value.map(item => item[groupField]),
            itemStyle: { color: '#4B5EAA' },
          },
          {
            name: '全校平均',
            type: 'bar',
            data: scoreData.value.map(item => item[schoolField]),
            itemStyle: { color: '#F4A261' },
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
        ElMessage.error('请求失败: ' + error.message);
      }
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
    };
  },
};
</script>


<style scoped>
.el-card {
  margin-bottom: 20px;
}
h2, h3 {
  margin-bottom: 20px;
}
</style>