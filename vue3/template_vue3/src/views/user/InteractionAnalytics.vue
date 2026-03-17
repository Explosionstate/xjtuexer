<template>
  <div class="analytics-page">
    <div class="analytics-wrapper">
      <header class="page-header">
        <h1 class="page-title">课堂互动情况</h1>
        <p class="page-desc">查看课堂互动类型分布，支持按课程、学院、时间范围筛选。</p>
      </header>

      <el-card class="panel-card" shadow="never">
        <template #header>
          <div class="card-header">
            <h2>课堂互动分析</h2>
          </div>
        </template>

        <div class="filter-grid">
          <el-input v-model="courseName" placeholder="课程名称" clearable />
          <el-input v-model="collegeName" placeholder="学院名称" clearable />
          <el-date-picker v-model="startTime" type="date" placeholder="开始日期" value-format="YYYY-MM-DD" />
          <el-date-picker v-model="endTime" type="date" placeholder="结束日期" value-format="YYYY-MM-DD" />
        </div>

        <div id="interactionChart" class="chart-box"></div>

        <el-table v-if="interactionData.length" :data="interactionData" border stripe class="table-box">
          <el-table-column prop="interactionType" label="互动类型" min-width="220" />
          <el-table-column prop="interactionCount" label="次数" width="120" />
          <el-table-column prop="percentage" label="占比（%）" width="140" :formatter="(row) => row.percentage.toFixed(2)" />
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
  name: 'InteractionAnalytics',
  setup() {
    const courseName = ref('');
    const collegeName = ref('');
    const startTime = ref('');
    const endTime = ref('');
    const interactionData = ref([]);
    let interactionChartInstance = null;

    const decodeUnicodeLiteral = (value) => {
      if (value === null || value === undefined) {
        return '';
      }
      const raw = String(value);
      // 兼容 `u7b7eu5230` 与 `\\u7b7e\\u5230` 两种历史脏数据格式
      return raw.replace(/\\?u([0-9a-fA-F]{4})/g, (_, hex) =>
        String.fromCharCode(parseInt(hex, 16))
      );
    };

    const initChart = () => {
      interactionChartInstance = echarts.init(document.getElementById('interactionChart'));
    };

    const setInteractionChartOption = () => {
      if (!interactionChartInstance) {
        return;
      }
      interactionChartInstance.setOption({
        title: { text: '课堂互动情况', left: 'center' },
        tooltip: {
          trigger: 'item',
          formatter: '{b}: {c} 次 ({d}%)',
        },
        series: [
          {
            name: '互动次数',
            type: 'pie',
            radius: ['42%', '70%'],
            data: interactionData.value.map((item) => ({
              value: item.interactionCount,
              name: decodeUnicodeLiteral(item.interactionType),
            })),
            itemStyle: {
              color: (params) => ['#4B5EAA', '#F4A261', '#2A9D8F', '#E76F51', '#E63946', '#457B9D'][params.dataIndex],
            },
          },
        ],
      });
    };

    const fetchInteractions = async () => {
      try {
        const response = await axios.get('/api/interaction/interactions', {
          params: {
            courseName: courseName.value,
            collegeName: collegeName.value,
            startTime: startTime.value ? new Date(startTime.value).toISOString().split('T')[0] : '',
            endTime: endTime.value ? new Date(endTime.value).toISOString().split('T')[0] : '',
          },
        });
        if (response.data.status && response.data.code === 0) {
          interactionData.value = (response.data.data || []).map((item) => ({
            ...item,
            interactionType: decodeUnicodeLiteral(item.interactionType),
          }));
          setInteractionChartOption();
        } else {
          ElMessage.error(response.data.message || '获取课堂互动数据失败');
        }
      } catch (error) {
        ElMessage.error(`请求失败: ${error.message}`);
      }
    };

    onMounted(() => {
      initChart();
      fetchInteractions();
    });

    onUnmounted(() => {
      if (interactionChartInstance) {
        interactionChartInstance.dispose();
      }
    });

    watch([courseName, collegeName, startTime, endTime], fetchInteractions);

    return {
      courseName,
      collegeName,
      startTime,
      endTime,
      interactionData,
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

.chart-box {
  width: 100%;
  height: 420px;
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

  .filter-grid {
    grid-template-columns: 1fr;
  }

  .chart-box {
    height: 350px;
  }
}
</style>
