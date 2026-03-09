<template>
  <div class="p-6 bg-gray-100 min-h-screen">
    <h1 class="text-2xl font-bold mb-6">课堂互动情况</h1>

    <!-- 课堂互动情况 -->
    <el-card class="mb-6">
      <h2 class="text-xl font-bold mb-4">课堂互动情况</h2>
      <div class="mb-4 flex items-center">
        <el-input v-model="courseName" placeholder="课程名称" class="mr-4 w-1/4" />
        <el-input v-model="collegeName" placeholder="学院名称" class="mr-4 w-1/4" />
        <el-date-picker v-model="startTime" type="date" placeholder="开始日期" class="mr-4" />
        <el-date-picker v-model="endTime" type="date" placeholder="结束日期" />
      </div>
      <div id="interactionChart" style="width: 100%; height: 400px;"></div>
      <el-table :data="interactionData" style="width: 100%" class="mt-4" v-if="interactionData.length">
        <el-table-column prop="interactionType" label="互动类型" />
        <el-table-column prop="interactionCount" label="次数" />
        <el-table-column prop="percentage" label="占比 (%)" :formatter="row => row.percentage.toFixed(2)" />
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
  name: 'InteractionAnalytics',
  setup() {
    const courseName = ref('');
    const collegeName = ref('');
    const startTime = ref('');
    const endTime = ref('');
    const interactionData = ref([]);
    let interactionChartInstance = null;

    const initChart = () => {
      interactionChartInstance = echarts.init(document.getElementById('interactionChart'));
    };

    const setInteractionChartOption = () => {
      interactionChartInstance.setOption({
        title: { text: '课堂互动情况', left: 'center' },
        tooltip: {
          trigger: 'item',
          formatter: '{b}: {c} 次 ({d}%)',
        },
        series: [{
          name: '互动次数',
          type: 'pie',
          radius: ['40%', '70%'],
          data: interactionData.value.map(item => ({
            value: item.interactionCount,
            name: item.interactionType,
          })),
          itemStyle: {
            color: params => ['#4B5EAA', '#F4A261', '#2A9D8F', '#E76F51', '#E63946', '#457B9D'][params.dataIndex],
          },
        }],
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
          interactionData.value = response.data.data || [];
          setInteractionChartOption();
        } else {
          ElMessage.error(response.data.message || '获取课堂互动数据失败');
        }
      } catch (error) {
        ElMessage.error('请求失败: ' + error.message);
      }
    };

    onMounted(() => {
      initChart();
      fetchInteractions();
    });

    onUnmounted(() => {
      if (interactionChartInstance) interactionChartInstance.dispose();
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
.el-card {
  margin-bottom: 20px;
}
h2 {
  margin-bottom: 20px;
}
</style>