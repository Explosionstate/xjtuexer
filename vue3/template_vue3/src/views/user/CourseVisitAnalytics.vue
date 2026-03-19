<template>
  <div class="analytics-page">
    <div class="analytics-wrapper">
      <header class="page-header">
        <h1 class="page-title">课程访问排行榜</h1>
        <p class="page-desc">按时间范围查看课程访问热度 Top 10，支持快速识别高关注课程。</p>
      </header>

      <el-card class="panel-card" shadow="never">
        <template #header>
          <div class="card-header">
            <h2>课程访问排行榜 Top 10</h2>
          </div>
        </template>

        <div class="filter-row">
          <el-select v-model="timeRange" placeholder="选择时间范围">
            <el-option label="今日" value="today" />
            <el-option label="本周" value="week" />
            <el-option label="本月" value="month" />
            <el-option label="本年" value="year" />
          </el-select>
        </div>

        <div id="visitChart" class="chart-box"></div>

        <el-table v-if="visitData.length" :data="visitData" class="table-box">
          <el-table-column prop="courseName" label="课程名称" min-width="120" />
          <el-table-column prop="visitCount" label="访问量" width="140" />
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
  name: 'CourseVisitAnalytics',
  setup() {
    const timeRange = ref('today');
    const visitData = ref([]);
    let visitChartInstance = null;

    const initChart = () => {
      visitChartInstance = echarts.init(document.getElementById('visitChart'));
    };

    const setVisitChartOption = () => {
      if (!visitChartInstance) {
        return;
      }
      visitChartInstance.setOption({
        title: { text: '课程访问排行榜 Top 10', left: 'center' },
        tooltip: { trigger: 'axis', formatter: '{b}: {c} 次' },
        grid: { bottom: 80 },
        xAxis: {
          type: 'category',
          data: visitData.value.map((item) => item.courseName),
          axisLabel: {
            rotate: 30,
            interval: 0,
            fontSize: 11,
            width: 70,
            overflow: 'truncate',
          },
        },
        yAxis: { type: 'value', name: '访问量' },
        series: [
          {
            name: '访问量',
            type: 'bar',
            data: visitData.value.map((item) => item.visitCount),
            itemStyle: { color: '#4B5EAA' },
            barMaxWidth: 40,
          },
        ],
      });
    };

    const fetchTop10Visits = async () => {
      try {
        const response = await axios.get('/api/coursevisit/top10Visits', {
          params: { timeRange: timeRange.value },
        });
        if (response.data.status && response.data.code === 0) {
          visitData.value = response.data.data || [];
          setVisitChartOption();
        } else {
          ElMessage.error(response.data.message || '获取课程访问排行榜失败');
        }
      } catch (error) {
        ElMessage.error(`请求失败: ${error.message}`);
      }
    };

    onMounted(() => {
      initChart();
      fetchTop10Visits();
    });

    onUnmounted(() => {
      if (visitChartInstance) {
        visitChartInstance.dispose();
      }
    });

    watch(timeRange, fetchTop10Visits);

    return {
      timeRange,
      visitData,
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
  letter-spacing: 0.4px;
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
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-bottom: 18px;
}

.filter-row :deep(.el-select) {
  width: 220px;
}

.chart-box {
  width: 100%;
  height: 480px;
}

.table-box {
  margin-top: 18px;
}

.empty-block {
  margin-top: 16px;
  padding: 16px;
  border-radius: 10px;
  background: #f7f9fc;
  color: #8b96a6;
  text-align: center;
}

@media (max-width: 768px) {
  .analytics-page {
    padding: 16px;
  }

  .page-title {
    font-size: 23px;
  }

  .filter-row :deep(.el-select) {
    width: 100%;
  }

  .chart-box {
    height: 360px;
  }
}
</style>
