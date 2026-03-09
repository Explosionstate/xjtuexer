<template>
  <div class="p-6 bg-gray-100 min-h-screen">
    <h1 class="text-2xl font-bold mb-6">学习时长分布情况</h1>

    <!-- 学习时长分布 -->
    <el-card class="mb-6">
      <h2 class="text-xl font-bold mb-4">学习时长分布情况</h2>
      <div class="mb-4 flex items-center gap-4">
        <el-input v-model="courseName" placeholder="课程名称" class="w-1/4" />
        <el-input v-model="collegeName" placeholder="学院名称" class="w-1/4" />
        <el-button type="primary" @click="fetchDurations">查询</el-button>
      </div>
      <div v-show="showCharts" class="charts-container flex justify-between gap-4">
        <div id="videoChart" class="chart-box"></div>
        <div id="liveChart" class="chart-box"></div>
        <div id="readingChart" class="chart-box"></div>
      </div>
      <el-table :data="durationData" style="width: 100%" class="mt-4" v-if="durationData.length">
        <el-table-column prop="durationType" label="时长类型" />
        <el-table-column prop="durationMinutes" label="时长（分钟）" />
        <el-table-column prop="percentage" label="占比（%）" />
      </el-table>
      <div v-else>暂无数据</div>
    </el-card>
  </div>
</template>

<script>
import { ref, onMounted, onUnmounted, nextTick } from 'vue';
import * as echarts from 'echarts';
import { ElMessage } from 'element-plus';
import axios from 'axios';

export default {
  name: 'LearningDurationAnalytics',
  setup() {
    const courseName = ref('');
    const collegeName = ref('');
    const durationData = ref([]);
    const showCharts = ref(false);
    let videoChartInstance = ref(null);
    let liveChartInstance = ref(null);
    let readingChartInstance = ref(null);

    const initCharts = () => {
      const videoChartElement = document.getElementById('videoChart');
      const liveChartElement = document.getElementById('liveChart');
      const readingChartElement = document.getElementById('readingChart');

      if (videoChartElement && liveChartElement && readingChartElement) {
        videoChartInstance.value = echarts.init(videoChartElement);
        liveChartInstance.value = echarts.init(liveChartElement);
        readingChartInstance.value = echarts.init(readingChartElement);
      } else {
        console.error('Chart elements not found during initialization');
      }
    };

    const setChartOption = (chartInstance, title, value, total, color) => {
      if (chartInstance) {
        chartInstance.setOption({
          title: { text: title, left: 'center', top: 20 },
          tooltip: {
            trigger: 'item',
            formatter: '{b}: {c} 分钟 ({d}%)',
          },
          series: [{
            name: title,
            type: 'pie',
            radius: ['50%', '70%'],
            data: [
              { value: value, name: title, itemStyle: { color } },
              { value: total - value, name: '其他', itemStyle: { color: '#E0E0E0' } },
            ],
            label: { show: false },
          }],
        });
        chartInstance.resize(); // 强制重绘图表
      }
    };

    const updateCharts = () => {
      const video = durationData.value.find(d => d.durationType === '视频') || { durationMinutes: 0, percentage: 0 };
      const live = durationData.value.find(d => d.durationType === '直播') || { durationMinutes: 0, percentage: 0 };
      const reading = durationData.value.find(d => d.durationType === '阅读') || { durationMinutes: 0, percentage: 0 };
      const total = durationData.value.reduce((sum, d) => sum + d.durationMinutes, 0);

      setChartOption(videoChartInstance.value, '视频时长', video.durationMinutes, total, '#4B5EAA');
      setChartOption(liveChartInstance.value, '直播时长', live.durationMinutes, total, '#F4A261');
      setChartOption(readingChartInstance.value, '阅读时长', reading.durationMinutes, total, '#2A9D8F');
    };

    const fetchDurations = async () => {
      try {
        const response = await axios.get('/api/learningduration/durations', {
          params: {
            courseName: courseName.value || null,
            collegeName: collegeName.value || null,
          },
        });
        if (response.data.status && response.data.code === 0) {
          durationData.value = response.data.data || [];
          showCharts.value = true;
          await nextTick(); // 等待 DOM 更新
          updateCharts();
        } else {
          ElMessage.error(response.data.message || '获取学习时长数据失败');
          showCharts.value = false;
        }
      } catch (error) {
        ElMessage.error('请求失败: ' + error.message);
        showCharts.value = false;
      }
    };

    onMounted(() => {
      initCharts();
    });

    onUnmounted(() => {
      if (videoChartInstance.value) videoChartInstance.value.dispose();
      if (liveChartInstance.value) liveChartInstance.value.dispose();
      if (readingChartInstance.value) readingChartInstance.value.dispose();
    });

    return {
      courseName,
      collegeName,
      durationData,
      showCharts,
      fetchDurations,
    };
  },
};
</script>

<style scoped>
.el-card {
  margin-bottom: 20px;
}
h2 {
  margin-bottom: 20px;
}
.charts-container {
  display: flex;
  flex-wrap: nowrap;
  justify-content: space-between;
  gap: 16px;
}
.chart-box {
  flex: 1;
  height: 300px;
  min-width: 0;
}
</style>