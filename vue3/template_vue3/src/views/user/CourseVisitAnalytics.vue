<template>
  <div class="p-6 bg-gray-100 min-h-screen">
    <h1 class="text-2xl font-bold mb-6">课程访问排行榜</h1>

    <!-- 课程访问排行榜 -->
    <el-card class="mb-6">
      <h2 class="text-xl font-bold mb-4">课程访问排行榜 Top 10</h2>
      <div class="mb-4 flex items-center">
        <el-select v-model="timeRange" placeholder="选择时间范围" class="mr-4">
          <el-option label="今日" value="today" />
          <el-option label="本周" value="week" />
          <el-option label="本月" value="month" />
          <el-option label="本年" value="year" />
        </el-select>
      </div>
      <div id="visitChart" style="width: 100%; height: 400px;"></div>
      <el-table :data="visitData" style="width: 100%" class="mt-4" v-if="visitData.length">
        <el-table-column prop="courseName" label="课程名称" />
        <el-table-column prop="visitCount" label="访问量" />
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
  name: 'CourseVisitAnalytics',
  setup() {
    const timeRange = ref('today');
    const visitData = ref([]);
    let visitChartInstance = null;

    const initChart = () => {
      visitChartInstance = echarts.init(document.getElementById('visitChart'));
    };


    const setVisitChartOption = () => {
      visitChartInstance.setOption({
        title: { text: '课程访问排行榜 Top 10', left: 'center' },
        tooltip: { trigger: 'axis', formatter: '{b}: {c} 次' },
        xAxis: {
          type: 'category',
          data: visitData.value.map(item => item.courseName),
          axisLabel: { rotate: 45, interval: 0 },
        },
        yAxis: { type: 'value', name: '访问量' },
        series: [{
          name: '访问量',
          type: 'bar',
          data: visitData.value.map(item => item.visitCount),
          itemStyle: { color: '#4B5EAA' },
        }],
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
        ElMessage.error('请求失败: ' + error.message);
      }
    };

    onMounted(() => {
      initChart();
      fetchTop10Visits();
    });

    onUnmounted(() => {
      if (visitChartInstance) visitChartInstance.dispose();
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
.el-card {
  margin-bottom: 20px;
}
h2 {
  margin-bottom: 20px;
}
</style>