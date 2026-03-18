<template>
  <div class="analytics-page">
    <div class="analytics-wrapper">
      <header class="page-header">
        <h1 class="page-title">学习时长分布情况</h1>
        <p class="page-desc">从视频、直播、阅读三个维度查看学习时长构成，支持课程与学院筛选。</p>
      </header>

      <el-card class="panel-card" shadow="never">
        <template #header>
          <div class="card-header">
            <h2>学习时长分析</h2>
          </div>
        </template>

        <div class="filter-row">
          <el-input v-model="courseName" placeholder="课程名称" clearable />
          <el-input v-model="collegeName" placeholder="学院名称" clearable />
          <el-button type="primary" @click="fetchDurations">查询</el-button>
        </div>

        <div v-show="showCharts" class="charts-container">
          <section class="chart-panel">
            <h3>视频时长</h3>
            <div id="videoChart" class="chart-box"></div>
          </section>

          <section class="chart-panel">
            <h3>直播时长</h3>
            <div id="liveChart" class="chart-box"></div>
          </section>

          <section class="chart-panel">
            <h3>阅读时长</h3>
            <div id="readingChart" class="chart-box"></div>
          </section>
        </div>

        <el-table v-if="durationData.length" :data="durationData" border stripe class="table-box">
          <el-table-column prop="durationType" label="时长类型" min-width="160" />
          <el-table-column prop="durationMinutes" label="时长（分钟）" min-width="130" />
          <el-table-column prop="percentage" label="占比（%）" min-width="110" />
        </el-table>
        <div v-else class="empty-block">暂无数据</div>
      </el-card>
    </div>
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
    const videoChartInstance = ref(null);
    const liveChartInstance = ref(null);
    const readingChartInstance = ref(null);

    const initCharts = () => {
      const videoChartElement = document.getElementById('videoChart');
      const liveChartElement = document.getElementById('liveChart');
      const readingChartElement = document.getElementById('readingChart');

      if (videoChartElement && liveChartElement && readingChartElement) {
        videoChartInstance.value = echarts.init(videoChartElement);
        liveChartInstance.value = echarts.init(liveChartElement);
        readingChartInstance.value = echarts.init(readingChartElement);
      }
    };

    const setChartOption = (chartInstance, title, value, total, color) => {
      if (!chartInstance) {
        return;
      }
      const remaining = Math.max(0, total - value);
      chartInstance.setOption({
        title: { text: title, left: 'center', top: 16 },
        tooltip: {
          trigger: 'item',
          formatter: '{b}: {c} 分钟 ({d}%)',
        },
        series: [
          {
            name: title,
            type: 'pie',
            radius: ['52%', '72%'],
            data: [
              { value, name: title, itemStyle: { color } },
              { value: remaining, name: '其他', itemStyle: { color: '#E0E0E0' } },
            ],
            label: { show: false },
          },
        ],
      });
      chartInstance.resize();
    };

    const updateCharts = () => {
      const video = durationData.value.find((d) => d.durationType === '视频') || { durationMinutes: 0 };
      const live = durationData.value.find((d) => d.durationType === '直播') || { durationMinutes: 0 };
      const reading = durationData.value.find((d) => d.durationType === '阅读') || { durationMinutes: 0 };
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
          await nextTick();
          updateCharts();
        } else {
          ElMessage.error(response.data.message || '获取学习时长数据失败');
          showCharts.value = false;
        }
      } catch (error) {
        ElMessage.error(`请求失败: ${error.message}`);
        showCharts.value = false;
      }
    };

    onMounted(() => {
      initCharts();
      fetchDurations();
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

.filter-row {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px;
  margin-bottom: 18px;
}

.charts-container {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 14px;
  margin-bottom: 16px;
}

.chart-panel {
  border: 1px solid #edf1f7;
  background: #fafcff;
  border-radius: 10px;
  padding: 10px;
}

.chart-panel h3 {
  margin: 0 0 8px;
  font-size: 15px;
  color: #364152;
  text-align: center;
}

.chart-box {
  width: 100%;
  height: 280px;
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

  .charts-container {
    grid-template-columns: 1fr;
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
    height: 260px;
  }
}
</style>
