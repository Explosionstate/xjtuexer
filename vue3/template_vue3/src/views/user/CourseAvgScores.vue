<template>
  <div class="p-6 bg-gray-100 min-h-screen">
    <h1 class="text-2xl font-bold mb-6">课程平均分</h1>
    <el-card class="mb-6">
      <h2 class="text-xl font-bold mb-4">课程平均分对比</h2>
      <div class="mb-4 flex items-center">
        <el-select
            v-model="college"
            placeholder="选择学院"
            clearable
            class="mr-4 w-1/4"
        >
          <el-option label="全部学院" value="" />
          <el-option label="计算机学院" value="计算机学院" />
          <el-option label="外国语学院" value="外国语学院" />
          <el-option label="自动化学院" value="自动化学院" />
          <el-option label="经济管理学院" value="经济管理学院" />
        </el-select>
        <el-select
            v-model="semester"
            placeholder="选择学期"
            class="w-1/4"
        >
          <el-option label="2024-2025秋" value="2024-2025秋" />
          <el-option label="2024-2025春" value="2024-2025春" />
          <el-option label="2023-2024秋" value="2023-2024秋" />
        </el-select>
      </div>
      <div id="scoreChart" style="width: 100%; height: 450px;"></div>
    </el-card>
  </div>
</template>

<script>
import { ref, onMounted, onUnmounted, watch } from 'vue';
import * as echarts from 'echarts';
import { ElMessage } from 'element-plus';
import { getCourseAvgScores } from '@/api/api';

export default {
  name: 'CourseAvgScores',
  setup() {
    const college = ref(''); // 默认空，表示全部学院
    const semester = ref('2024-2025秋'); // 默认最新学期
    const scoreData = ref([]);
    let scoreChartInstance = null;

    const initChart = () => {
      scoreChartInstance = echarts.init(document.getElementById('scoreChart'));
    };

    const setScoreChartOption = () => {
      // 课程名称列表
      const courses = [
        '毛泽东思想和中国特色社会主义理论体系概论',
        '形式与政策课',
        '马克思主义基本原理概论',
        '思想道德休养与法律基础'
      ];

      // 按学院分组数据
      const colleges = college.value ? [college.value] : ['计算机学院', '外国语学院', '自动化学院', '经济管理学院'];
      const schoolData = scoreData.value.filter(item => item.college === '全校');

      // 构造本群体平均分（按学院聚合）
      const groupScores = courses.map(course => {
        const collegeData = scoreData.value.filter(item => colleges.includes(item.college) && item.courseName === course);
        if (collegeData.length === 0) return 0;
        const totalScore = collegeData.reduce((sum, item) => sum + (item.avgScoreGroup || 0), 0);
        return Math.round((totalScore / collegeData.length) * 100) / 100; // 保留两位小数
      });

      // 构造全校平均分
      const schoolScores = courses.map(course => {
        const record = schoolData.find(item => item.courseName === course) || {};
        return record.avgScoreSchool || 0;
      });

      scoreChartInstance.setOption({
        title: { text: '课程平均分对比', left: 'center' },
        tooltip: {
          trigger: 'axis',
          formatter: params => {
            const course = params[0].name;
            let result = `${course}<br/>`;
            params.forEach(item => {
              result += `${item.seriesName}: ${item.value.toFixed(2)}<br/>`;
            });
            return result;
          },
        },
        legend: { data: ['本群体', '全校平均'], top: 30 },
        grid: {
          bottom: 150, // 底部高度，确保长名称完整显示
          left: 50,
          right: 50,
          containLabel: true,
        },
        xAxis: {
          type: 'category',
          data: courses,
          axisLabel: {
            interval: 0,
            rotate: 0, // 水平显示
            fontSize: 9, // 减小字体大小
            // 移除截断逻辑，确保完整显示
          },
        },
        yAxis: { type: 'value', name: '分数', max: 100, min: 0 },
        series: [
          {
            name: '本群体',
            type: 'bar',
            data: groupScores,
            itemStyle: { color: '#4B5EAA' },
            barWidth: '40%',
          },
          {
            name: '全校平均',
            type: 'bar',
            data: schoolScores,
            itemStyle: { color: '#F4A261' },
            barWidth: '40%',
            barGap: '10%',
          },
        ],
      });
    };

    const fetchCourseAvgScores = async () => {
      try {
        const response = await getCourseAvgScores({
          college: college.value,
          semester: semester.value,
        });
        if (response.data.status && response.data.code === 0) {
          scoreData.value = response.data.data || [];
          setScoreChartOption();
        } else {
          ElMessage.error(response.data.message || '获取课程平均分数据失败');
        }
      } catch (error) {
        ElMessage.error('请求失败: ' + error.message);
      }
    };

    onMounted(() => {
      initChart();
      fetchCourseAvgScores();
    });

    onUnmounted(() => {
      if (scoreChartInstance) scoreChartInstance.dispose();
    });

    watch([college, semester], fetchCourseAvgScores);

    return {
      college,
      semester,
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