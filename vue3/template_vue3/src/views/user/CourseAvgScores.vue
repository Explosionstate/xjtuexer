<template>
  <div class="analytics-page">
    <div class="analytics-wrapper">
      <header class="page-header">
        <h1 class="page-title">课程平均分</h1>
        <p class="page-desc">按学院与学期查看课程均分对比，支持本群体与全校平均的横向分析。</p>
      </header>

      <el-card class="panel-card" shadow="never">
        <template #header>
          <div class="card-header">
            <h2>课程平均分对比</h2>
          </div>
        </template>

        <div class="filter-row">
          <el-select v-model="college" placeholder="选择学院" clearable>
            <el-option label="全部学院" value="" />
            <el-option label="计算机学院" value="计算机学院" />
            <el-option label="外国语学院" value="外国语学院" />
            <el-option label="自动化学院" value="自动化学院" />
            <el-option label="经济管理学院" value="经济管理学院" />
          </el-select>

          <el-select v-model="semester" placeholder="选择学期">
            <el-option label="2024-2025秋" value="2024-2025秋" />
            <el-option label="2024-2025春" value="2024-2025春" />
            <el-option label="2023-2024秋" value="2023-2024秋" />
          </el-select>
        </div>

        <div id="scoreChart" class="chart-box"></div>
      </el-card>
    </div>
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
    const college = ref('');
    const semester = ref('2024-2025秋');
    const scoreData = ref([]);
    let scoreChartInstance = null;

    const initChart = () => {
      scoreChartInstance = echarts.init(document.getElementById('scoreChart'));
    };

    const setScoreChartOption = () => {
      if (!scoreChartInstance) {
        return;
      }

      const courses = [
        '毛泽东思想和中国特色社会主义理论体系概论',
        '形势与政策课',
        '马克思主义基本原理概论',
        '思想道德修养与法律基础',
      ];

      const colleges = college.value ? [college.value] : ['计算机学院', '外国语学院', '自动化学院', '经济管理学院'];
      const schoolData = scoreData.value.filter((item) => item.college === '全校');

      const groupScores = courses.map((courseName) => {
        const collegeData = scoreData.value.filter(
          (item) => colleges.includes(item.college) && item.courseName === courseName
        );
        if (collegeData.length === 0) {
          return 0;
        }
        const totalScore = collegeData.reduce((sum, item) => sum + (item.avgScoreGroup || 0), 0);
        return Math.round((totalScore / collegeData.length) * 100) / 100;
      });

      const schoolScores = courses.map((courseName) => {
        const record = schoolData.find((item) => item.courseName === courseName) || {};
        return record.avgScoreSchool || 0;
      });

      scoreChartInstance.setOption({
        title: { text: '课程平均分对比', left: 'center' },
        tooltip: {
          trigger: 'axis',
          formatter: (params) => {
            const courseName = params[0].name;
            let result = `${courseName}<br/>`;
            params.forEach((item) => {
              result += `${item.seriesName}: ${Number(item.value).toFixed(2)}<br/>`;
            });
            return result;
          },
        },
        legend: { data: ['本群体', '全校平均'], top: 30 },
        grid: {
          bottom: 130,
          left: 50,
          right: 50,
          containLabel: true,
        },
        xAxis: {
          type: 'category',
          data: courses,
          axisLabel: {
            interval: 0,
            rotate: 0,
            fontSize: 11,
            lineHeight: 16,
          },
        },
        yAxis: { type: 'value', name: '分数', max: 100, min: 0 },
        series: [
          {
            name: '本群体',
            type: 'bar',
            data: groupScores,
            itemStyle: { color: '#4B5EAA' },
            barWidth: '34%',
          },
          {
            name: '全校平均',
            type: 'bar',
            data: schoolScores,
            itemStyle: { color: '#F4A261' },
            barWidth: '34%',
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
        ElMessage.error(`请求失败: ${error.message}`);
      }
    };

    onMounted(() => {
      initChart();
      fetchCourseAvgScores();
    });

    onUnmounted(() => {
      if (scoreChartInstance) {
        scoreChartInstance.dispose();
      }
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
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-bottom: 18px;
}

.filter-row :deep(.el-select) {
  width: 240px;
}

.chart-box {
  width: 100%;
  height: 470px;
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
    height: 380px;
  }
}
</style>
