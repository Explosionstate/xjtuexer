<template>
  <div class="analytics-page">
    <div class="analytics-wrapper">
      <header class="page-header">
        <h1 class="page-title">课程完成情况</h1>
        <p class="page-desc">对比不同学院、课程、学年的课程完成情况与学习行为指标。</p>
      </header>

      <el-card class="panel-card" shadow="never">
        <template #header>
          <div class="card-header">
            <h2>课程完成情况对比</h2>
          </div>
        </template>

        <el-tabs v-model="activeTab" type="card" class="compare-tabs">
          <el-tab-pane label="对比对象1" name="group1">
            <div class="filter-row">
              <el-select v-model="group1College" placeholder="选择学院" clearable>
                <el-option v-for="item in collegeOptions" :key="item" :label="item" :value="item" />
              </el-select>
              <el-select v-model="group1Course" placeholder="选择课程" clearable>
                <el-option v-for="item in courseOptions" :key="item.courseId" :label="item.title" :value="item.title" />
              </el-select>
              <el-select v-model="group1Semester" placeholder="选择学年">
                <el-option v-for="item in semesterOptions" :key="item" :label="item" :value="item" />
              </el-select>
            </div>
          </el-tab-pane>

          <el-tab-pane label="对比对象2" name="group2">
            <div class="filter-row">
              <el-select v-model="group2College" placeholder="选择学院" clearable>
                <el-option v-for="item in collegeOptions" :key="item" :label="item" :value="item" />
              </el-select>
              <el-select v-model="group2Course" placeholder="选择课程" clearable>
                <el-option v-for="item in courseOptions" :key="item.courseId" :label="item.title" :value="item.title" />
              </el-select>
              <el-select v-model="group2Semester" placeholder="选择学年">
                <el-option v-for="item in semesterOptions" :key="item" :label="item" :value="item" />
              </el-select>
            </div>
          </el-tab-pane>
        </el-tabs>

        <div id="completionChart" class="chart-box"></div>

        <el-table v-if="completionData.length" :data="completionData" border stripe class="table-box">
          <el-table-column prop="courseName" label="课程名称" min-width="160" fixed="left" />
          <el-table-column prop="college" label="学院" min-width="110" />
          <el-table-column prop="semester" label="学年" min-width="120" />
          <el-table-column prop="taskCompletionRate" label="任务点完成率(%)" min-width="140" />
          <el-table-column prop="videoCompletionRate" label="视频任务点完成率(%)" min-width="170" />
          <el-table-column prop="quizCompletionRate" label="章节测验完成率(%)" min-width="150" />
          <el-table-column prop="assignmentCompletionRate" label="作业完成率(%)" min-width="130" />
          <el-table-column prop="examCompletionRate" label="考试完成率(%)" min-width="130" />
          <el-table-column prop="chapterStudyCount" label="章节学习次数" min-width="130" />
          <el-table-column prop="checkinCompletionRate" label="签到完成率(%)" min-width="130" />
        </el-table>
        <div v-else class="empty-block">暂无数据</div>
      </el-card>
    </div>
  </div>
</template>

<script>
import { nextTick, onMounted, onUnmounted, ref, watch } from 'vue';
import * as echarts from 'echarts';
import { ElMessage } from 'element-plus';
import { getCompletions, getCourseManagementMeta } from '../../api/api';

const DEFAULT_ACADEMIC_YEARS = ['2025-2026学年', '2024-2025学年'];

export default {
  name: 'CourseCompletionAnalytics',
  setup() {
    const activeTab = ref('group1');
    const group1College = ref('全校');
    const group1Course = ref('');
    const group1Semester = ref(DEFAULT_ACADEMIC_YEARS[0]);
    const group2College = ref('全校');
    const group2Course = ref('');
    const group2Semester = ref(DEFAULT_ACADEMIC_YEARS[0]);
    const completionData = ref([]);
    const collegeOptions = ref(['全校']);
    const courseOptions = ref([]);
    const semesterOptions = ref([...DEFAULT_ACADEMIC_YEARS]);
    let completionChartInstance = null;
    let resizeHandler = null;

    const getLegendLabel = (college, course, semester) =>
      `${college || '全校'}${course ? `(${course})` : ''}(${semester})`;

    const initChart = () => {
      const chartDom = document.getElementById('completionChart');
      if (!chartDom) {
        return;
      }
      completionChartInstance = echarts.init(chartDom);
    };

    const setEmptyChartOption = (title) => {
      if (!completionChartInstance) {
        return;
      }
      completionChartInstance.clear();
      completionChartInstance.setOption({
        title: {
          text: title,
          left: 'center',
          top: 'middle',
          textStyle: { color: '#8b96a6', fontSize: 16 },
        },
      });
      completionChartInstance.resize();
    };

    const setCompletionChartOption = () => {
      if (!completionChartInstance) {
        return;
      }
      if (!completionData.value.length) {
        setEmptyChartOption('暂无课程完成情况数据');
        return;
      }

      const group1Data =
        completionData.value.find(
          (d) =>
            d.college === group1College.value &&
            (!group1Course.value || d.courseName === group1Course.value) &&
            d.semester === group1Semester.value
        ) || null;
      const group2Data =
        completionData.value.find(
          (d) =>
            d.college === group2College.value &&
            (!group2Course.value || d.courseName === group2Course.value) &&
            d.semester === group2Semester.value
        ) || null;

      if (!group1Data && !group2Data) {
        setEmptyChartOption('当前筛选暂无匹配数据');
        return;
      }

      const categories = [
        '任务点完成率(%)',
        '视频任务点完成率(%)',
        '章节测验完成率(%)',
        '作业完成率(%)',
        '考试完成率(%)',
        '章节学习次数',
        '签到完成率(%)',
      ];

      const getSeriesData = (data) => [
        data?.taskCompletionRate ?? 0,
        data?.videoCompletionRate ?? 0,
        data?.quizCompletionRate ?? 0,
        data?.assignmentCompletionRate ?? 0,
        data?.examCompletionRate ?? 0,
        data?.chapterStudyCount ?? 0,
        data?.checkinCompletionRate ?? 0,
      ];

      const group1Label = getLegendLabel(group1College.value, group1Course.value, group1Semester.value);
      const group2Label = getLegendLabel(group2College.value, group2Course.value, group2Semester.value);
      const maxValue = Math.max(
        100,
        ...getSeriesData(group1Data),
        ...getSeriesData(group2Data),
      );

      completionChartInstance.setOption({
        title: { text: '课程完成情况对比', left: 'center' },
        tooltip: { trigger: 'axis' },
        legend: { data: [group1Label, group2Label], top: 30 },
        xAxis: {
          type: 'category',
          data: categories,
          axisLabel: { rotate: 30, interval: 0 },
        },
        yAxis: { type: 'value', name: '数值', max: Math.ceil(maxValue / 10) * 10 },
        series: [
          {
            name: group1Label,
            type: 'bar',
            data: getSeriesData(group1Data),
            itemStyle: { color: '#4B5EAA' },
            barMaxWidth: 36,
          },
          {
            name: group2Label,
            type: 'bar',
            data: getSeriesData(group2Data),
            itemStyle: { color: '#F4A261' },
            barMaxWidth: 36,
          },
        ],
      });
      completionChartInstance.resize();
    };

    const fetchMeta = async () => {
      try {
        const response = await getCourseManagementMeta();
        const meta = response?.data || {};
        courseOptions.value = meta.courses || [];
        collegeOptions.value = ['全校', ...(meta.colleges || [])];
        semesterOptions.value = meta.academicYears?.length ? meta.academicYears : [...DEFAULT_ACADEMIC_YEARS];
        if (!semesterOptions.value.includes(group1Semester.value)) {
          group1Semester.value = semesterOptions.value[0];
        }
        if (!semesterOptions.value.includes(group2Semester.value)) {
          group2Semester.value = semesterOptions.value[0];
        }
      } catch (error) {
        ElMessage.error(error?.message || '获取课程筛选项失败');
      }
    };

    const fetchCompletions = async () => {
      try {
        const response = await getCompletions({
          group1College: group1College.value || '全校',
          group2College: group2College.value || '全校',
          group1Course: group1Course.value,
          group2Course: group2Course.value,
          group1Semester: group1Semester.value,
          group2Semester: group2Semester.value,
        });
        if (response.data.status && response.data.code === 0) {
          completionData.value = response.data.data || [];
          await nextTick();
          setCompletionChartOption();
        } else {
          ElMessage.error(response.data.message || '获取课程完成情况失败');
        }
      } catch (error) {
        ElMessage.error(`请求失败: ${error.message}`);
      }
    };

    onMounted(async () => {
      initChart();
      await fetchMeta();
      await fetchCompletions();
      resizeHandler = () => completionChartInstance?.resize();
      window.addEventListener('resize', resizeHandler);
    });

    onUnmounted(() => {
      if (resizeHandler) {
        window.removeEventListener('resize', resizeHandler);
      }
      if (completionChartInstance) {
        completionChartInstance.dispose();
      }
    });

    watch(
      [group1College, group1Course, group1Semester, group2College, group2Course, group2Semester],
      fetchCompletions,
      { deep: true }
    );

    return {
      activeTab,
      group1College,
      group1Course,
      group1Semester,
      group2College,
      group2Course,
      group2Semester,
      completionData,
      collegeOptions,
      courseOptions,
      semesterOptions,
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

.compare-tabs {
  margin-bottom: 12px;
}

.filter-row {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px;
  margin-top: 4px;
}

.chart-box {
  width: 100%;
  height: 520px;
  margin-top: 10px;
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
  .filter-row {
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

  .filter-row {
    grid-template-columns: 1fr;
  }

  .chart-box {
    height: 380px;
  }
}
</style>
