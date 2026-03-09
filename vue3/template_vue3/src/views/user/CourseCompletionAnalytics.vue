<template>
  <div class="p-6 bg-gray-100 min-h-screen">
    <h1 class="text-2xl font-bold mb-6">课程完成情况</h1>

    <!-- 课程完成情况 -->
    <el-card class="mb-6">
      <h2 class="text-xl font-bold mb-4">课程完成情况对比</h2>
      <el-tabs v-model="activeTab" type="card" class="mb-4">
        <el-tab-pane label="对比对象1" name="group1">
          <el-select v-model="group1College" placeholder="选择学院" clearable>
            <el-option label="全校" value="全校" />
            <el-option label="电气学院" value="电气学院" />
            <el-option label="机械学院" value="机械学院" />
            <el-option label="外语学院" value="外语学院" />
          </el-select>
          <el-select v-model="group1Course" placeholder="选择课程" clearable class="ml-4">
            <el-option label="高等数学" value="高等数学" />
            <el-option label="大学英语" value="大学英语" />
            <el-option label="大学生职业规划" value="大学生职业规划" />
          </el-select>
          <el-select v-model="group1Semester" placeholder="选择学期" class="ml-4">
            <el-option label="2024-2025学年" value="2024-2025学年" />
            <el-option label="2025-2026学年" value="2025-2026学年" />
          </el-select>
        </el-tab-pane>
        <el-tab-pane label="对比对象2" name="group2">
          <el-select v-model="group2College" placeholder="选择学院" clearable>
            <el-option label="全校" value="全校" />
            <el-option label="电气学院" value="电气学院" />
            <el-option label="机械学院" value="机械学院" />
            <el-option label="外语学院" value="外语学院" />
          </el-select>
          <el-select v-model="group2Course" placeholder="选择课程" clearable class="ml-4">
            <el-option label="高等数学" value="高等数学" />
            <el-option label="大学英语" value="大学英语" />
            <el-option label="大学生职业规划" value="大学生职业规划" />
          </el-select>
          <el-select v-model="group2Semester" placeholder="选择学期" class="ml-4">
            <el-option label="2024-2025学年" value="2024-2025学年" />
            <el-option label="2025-2026学年" value="2025-2026学年" />
          </el-select>
        </el-tab-pane>
      </el-tabs>
      <div id="completionChart" style="width: 100%; height: 600px;"></div>
      <el-table :data="completionData" style="width: 100%" class="mt-4" v-if="completionData.length">
        <el-table-column prop="courseName" label="课程名称" />
        <el-table-column prop="college" label="学院" />
        <el-table-column prop="semester" label="学期" />
        <el-table-column prop="taskCompletionRate" label="任务点完成率(%)" />
        <el-table-column prop="videoCompletionRate" label="视频任务点完成率(%)" />
        <el-table-column prop="quizCompletionRate" label="章节测验完成率(%)" />
        <el-table-column prop="assignmentCompletionRate" label="作业完成率(%)" />
        <el-table-column prop="examCompletionRate" label="考试完成率(%)" />
        <el-table-column prop="chapterStudyCount" label="章节学习次数" />
        <el-table-column prop="checkinCompletionRate" label="签到完成率(%)" />
      </el-table>
      <div v-else>暂无数据</div>
    </el-card>
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
      const group1Data = completionData.value.find(
          d => d.college === group1College.value &&
              (!group1Course.value || d.courseName === group1Course.value) &&
              d.semester === group1Semester.value
      ) || {};
      const group2Data = completionData.value.find(
          d => d.college === group2College.value &&
              (!group2Course.value || d.courseName === group2Course.value) &&
              d.semester === group2Semester.value
      ) || {};

      const isChapterStudy = group1Data.chapterStudyCount || group2Data.chapterStudyCount;
      const yAxis = isChapterStudy
          ? [
            { type: 'value', name: '完成率(%)', max: 100, position: 'left' },
            { type: 'value', name: '章节学习次数', position: 'right' }
          ]
          : [{ type: 'value', name: '完成率(%)', max: 100 }];

      const getSeriesData = (data) => [
        { value: data.taskCompletionRate || 0, yAxisIndex: isChapterStudy ? 0 : 0 },
        { value: data.videoCompletionRate || 0, yAxisIndex: isChapterStudy ? 0 : 0 },
        { value: data.quizCompletionRate || 0, yAxisIndex: isChapterStudy ? 0 : 0 },
        { value: data.assignmentCompletionRate || 0, yAxisIndex: isChapterStudy ? 0 : 0 },
        { value: data.examCompletionRate || 0, yAxisIndex: isChapterStudy ? 0 : 0 },
        { value: data.chapterStudyCount || 0, yAxisIndex: isChapterStudy ? 1 : 0 },
        { value: data.checkinCompletionRate || 0, yAxisIndex: isChapterStudy ? 0 : 0 }
      ];

      completionChartInstance.setOption({
        title: { text: '课程完成情况对比', left: 'center' },
        tooltip: {
          trigger: 'axis',
          formatter: params => {
            const param1 = params[0] || {};
            const param2 = params[1] || {};
            const name = param1.name || param2.name;
            return `${name}<br/>${param1.seriesName || ''}: ${param1.value || 0}<br/>${param2.seriesName || ''}: ${param2.value || 0}`;
          }
        },
        legend: {
          data: [
            group1College.value + (group1Course.value ? `(${group1Course.value})` : '') + `(${group1Semester.value})`,
            group2College.value + (group2Course.value ? `(${group2Course.value})` : '') + `(${group2Semester.value})`
          ],
          top: 30
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
            '签到完成率(%)'
          ],
          axisLabel: { rotate: 45, interval: 0 }
        },
        yAxis: yAxis,
        series: [
          {
            name: group1College.value + (group1Course.value ? `(${group1Course.value})` : '') + `(${group1Semester.value})`,
            type: 'bar',
            data: getSeriesData(group1Data),
            itemStyle: { color: '#4B5EAA' }
          },
          {
            name: group2College.value + (group2Course.value ? `(${group2Course.value})` : '') + `(${group2Semester.value})`,
            type: 'bar',
            data: getSeriesData(group2Data),
            itemStyle: { color: '#F4A261' }
          }
        ]
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
          group2Semester: group2Semester.value
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
        ElMessage.error('请求失败: ' + error.message);
      }
    };

    onMounted(() => {
      initChart();
      fetchCompletions();
    });

    onUnmounted(() => {
      if (completionChartInstance) completionChartInstance.dispose();
    });

    watch([group1College, group1Course, group1Semester, group2College, group2Course, group2Semester], fetchCompletions, { deep: true });

    return {
      activeTab,
      group1College,
      group1Course,
      group1Semester,
      group2College,
      group2Course,
      group2Semester,
      completionData
    };
  }
};
</script>

<style scoped>
.el-card {
  margin-bottom: 20px;
}
h2 {
  margin-bottom: 20px;
}
</style>