<template>
  <div class="analytics-page">
    <div class="analytics-wrapper">
      <header class="page-header">
        <h1 class="page-title">课程完成情况</h1>
        <p class="page-desc">对比不同学院、课程、学期的课程完成情况与学习行为指标。</p>
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
                <el-option label="全校" value="全校" />
                <el-option label="电气工程学院" value="电气工程学院" />
                <el-option label="机械工程学院" value="机械工程学院" />
                <el-option label="外国语学院" value="外国语学院" />
              </el-select>
              <el-select v-model="group1Course" placeholder="选择课程" clearable>
                <el-option label="思想道德与法治" value="思想道德与法治" />
                <el-option label="中国近现代史纲要" value="中国近现代史纲要" />
                <el-option label="形势与政策" value="形势与政策" />
                <el-option label="马克思主义基本原理" value="马克思主义基本原理" />
              </el-select>
              <el-select v-model="group1Semester" placeholder="选择学期">
                <el-option label="2024-2025学年" value="2024-2025学年" />
                <el-option label="2025-2026学年" value="2025-2026学年" />
              </el-select>
            </div>
          </el-tab-pane>

          <el-tab-pane label="对比对象2" name="group2">
            <div class="filter-row">
              <el-select v-model="group2College" placeholder="选择学院" clearable>
                <el-option label="全校" value="全校" />
                <el-option label="电气工程学院" value="电气工程学院" />
                <el-option label="机械工程学院" value="机械工程学院" />
                <el-option label="外国语学院" value="外国语学院" />
              </el-select>
              <el-select v-model="group2Course" placeholder="选择课程" clearable>
                <el-option label="思想道德与法治" value="思想道德与法治" />
                <el-option label="中国近现代史纲要" value="中国近现代史纲要" />
                <el-option label="形势与政策" value="形势与政策" />
                <el-option label="马克思主义基本原理" value="马克思主义基本原理" />
              </el-select>
              <el-select v-model="group2Semester" placeholder="选择学期">
                <el-option label="2024-2025学年" value="2024-2025学年" />
                <el-option label="2025-2026学年" value="2025-2026学年" />
              </el-select>
            </div>
          </el-tab-pane>
        </el-tabs>

        <div id="completionChart" class="chart-box"></div>

        <el-table v-if="completionData.length" :data="completionData" border stripe class="table-box">
          <el-table-column prop="courseName" label="课程名称" min-width="160" fixed="left" />
          <el-table-column prop="college" label="学院" min-width="110" />
          <el-table-column prop="semester" label="学期" min-width="120" />
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
import { ref, onMounted, onUnmounted, watch } from 'vue';
import * as echarts from 'echarts';
import { ElMessage } from 'element-plus';
import { getCompletions } from '../../api/api';

export default {
  name: 'CourseCompletionAnalytics',
  setup() {
    const activeTab = ref('group1');
    const group1College = ref('全校');
    const group1Course = ref('');
    const group1Semester = ref('2025-2026学年');
    const group2College = ref('全校');
    const group2Course = ref('');
    const group2Semester = ref('2025-2026学年');
    const completionData = ref([]);
    let completionChartInstance = null;

    const initChart = () => {
      completionChartInstance = echarts.init(document.getElementById('completionChart'));
    };

    const setCompletionChartOption = () => {
      if (!completionChartInstance) {
        return;
      }

      const group1Data =
        completionData.value.find(
          (d) =>
            d.college === group1College.value &&
            (!group1Course.value || d.courseName === group1Course.value) &&
            d.semester === group1Semester.value
        ) || {};
      const group2Data =
        completionData.value.find(
          (d) =>
            d.college === group2College.value &&
            (!group2Course.value || d.courseName === group2Course.value) &&
            d.semester === group2Semester.value
        ) || {};

      const isChapterStudy = group1Data.chapterStudyCount || group2Data.chapterStudyCount;
      const yAxis = isChapterStudy
        ? [
            { type: 'value', name: '完成率(%)', max: 100, position: 'left' },
            { type: 'value', name: '章节学习次数', position: 'right' },
          ]
        : [{ type: 'value', name: '完成率(%)', max: 100 }];

      const getSeriesData = (data) => [
        { value: data.taskCompletionRate || 0, yAxisIndex: 0 },
        { value: data.videoCompletionRate || 0, yAxisIndex: 0 },
        { value: data.quizCompletionRate || 0, yAxisIndex: 0 },
        { value: data.assignmentCompletionRate || 0, yAxisIndex: 0 },
        { value: data.examCompletionRate || 0, yAxisIndex: 0 },
        { value: data.chapterStudyCount || 0, yAxisIndex: isChapterStudy ? 1 : 0 },
        { value: data.checkinCompletionRate || 0, yAxisIndex: 0 },
      ];

      completionChartInstance.setOption({
        title: { text: '课程完成情况对比', left: 'center' },
        tooltip: {
          trigger: 'axis',
          formatter: (params) => {
            const param1 = params[0] || {};
            const param2 = params[1] || {};
            const name = param1.name || param2.name;
            return `${name}<br/>${param1.seriesName || ''}: ${param1.value || 0}<br/>${param2.seriesName || ''}: ${param2.value || 0}`;
          },
        },
        legend: {
          data: [
            `${group1College.value}${group1Course.value ? `(${group1Course.value})` : ''}(${group1Semester.value})`,
            `${group2College.value}${group2Course.value ? `(${group2Course.value})` : ''}(${group2Semester.value})`,
          ],
          top: 30,
        },
        xAxis: {
          type: 'category',
          data: [
            '任务点完成率(%)',
            '视频任务点完成率(%)',
            '章节测验完成率(%)',
            '作业完成率(%)',
            '考试完成率(%)',
            '章节学习次数',
            '签到完成率(%)',
          ],
          axisLabel: { rotate: 30, interval: 0 },
        },
        yAxis,
        series: [
          {
            name: `${group1College.value}${group1Course.value ? `(${group1Course.value})` : ''}(${group1Semester.value})`,
            type: 'bar',
            data: getSeriesData(group1Data),
            itemStyle: { color: '#4B5EAA' },
            barMaxWidth: 36,
          },
          {
            name: `${group2College.value}${group2Course.value ? `(${group2Course.value})` : ''}(${group2Semester.value})`,
            type: 'bar',
            data: getSeriesData(group2Data),
            itemStyle: { color: '#F4A261' },
            barMaxWidth: 36,
          },
        ],
      });
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
          if (completionData.value.length === 0) {
            ElMessage.warning('没有找到匹配的数据');
          }
          setCompletionChartOption();
        } else {
          ElMessage.error(response.data.message || '获取课程完成情况失败');
        }
      } catch (error) {
        ElMessage.error(`请求失败: ${error.message}`);
      }
    };

    onMounted(() => {
      initChart();
      fetchCompletions();
    });

    onUnmounted(() => {
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
