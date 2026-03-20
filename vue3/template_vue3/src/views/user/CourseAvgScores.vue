<template>
  <div class="analytics-page">
    <div class="analytics-wrapper">
      <header class="page-header">
        <div class="header-content">
          <h1 class="page-title">
            <span class="title-icon">📊</span>
            课程平均分
          </h1>
          <p class="page-desc">按学院与学期查看课程均分对比，支持本群体与全校平均的横向分析</p>
        </div>
      </header>

      <el-card class="panel-card" shadow="never">
        <template #header>
          <div class="card-header">
            <h2>课程平均分对比</h2>
            <div class="header-actions">
              <el-button
                  type="primary"
                  :icon="Refresh"
                  circle
                  size="small"
                  @click="fetchCourseAvgScores"
                  :loading="loading"
              />
            </div>
          </div>
        </template>

        <div class="filter-row">
          <el-select
              v-model="college"
              placeholder="选择学院"
              clearable
              class="filter-select"
          >
            <el-option label="全部学院" value="" />
            <el-option label="马克思主义学院" value="马克思主义学院" />
            <el-option label="计算机科学与技术学院" value="计算机科学与技术学院" />
            <el-option label="软件学院" value="软件学院" />
            <el-option label="外国语学院" value="外国语学院" />
            <el-option label="电气工程学院" value="电气工程学院" />
            <el-option label="机械工程学院" value="机械工程学院" />
          </el-select>

          <el-select
              v-model="semester"
              placeholder="选择学期"
              clearable
              class="filter-select"
          >
            <el-option label="全部学期" value="" />
            <el-option label="2024-2025学年第一学期" value="2024-2025学年第一学期" />
            <el-option label="2024-2025学年第二学期" value="2024-2025学年第二学期" />
            <el-option label="2025-2026学年第一学期" value="2025-2026学年第一学期" />
            <el-option label="2025-2026学年第二学期" value="2025-2026学年第二学期" />
          </el-select>
        </div>

        <!-- 加载状态 -->
        <div v-if="loading" class="loading-container">
          <el-icon class="loading-icon"><Loading /></el-icon>
          <span>数据加载中...</span>
        </div>

        <!-- 空数据状态 -->
        <div v-else-if="!scoreData.length" class="empty-container">
          <el-empty description="暂无数据">
            <template #image>
              <div class="empty-icon">📉</div>
            </template>
            <el-button type="primary" @click="loadMockData">加载示例数据</el-button>
          </el-empty>
        </div>

        <!-- 图表区域 -->
        <div v-else class="chart-container">
          <div ref="scoreChartRef" class="chart-box"></div>

          <!-- 数据统计卡片 -->
          <div class="stats-row">
            <div class="stat-card">
              <div class="stat-value">{{ courseCount }}</div>
              <div class="stat-label">课程数量</div>
            </div>
            <div class="stat-card">
              <div class="stat-value">{{ avgGroupScore }}</div>
              <div class="stat-label">本群体平均</div>
            </div>
            <div class="stat-card">
              <div class="stat-value">{{ avgSchoolScore }}</div>
              <div class="stat-label">全校平均</div>
            </div>
            <div class="stat-card" :class="scoreDiffClass">
              <div class="stat-value">{{ scoreDiff }}</div>
              <div class="stat-label">差异值</div>
            </div>
          </div>
        </div>
      </el-card>

      <!-- 调试信息面板（开发时可用） -->
      <el-card v-if="showDebug" class="debug-card" shadow="never">
        <template #header>
          <div class="card-header">
            <h3>调试信息</h3>
            <el-switch v-model="showDebug" />
          </div>
        </template>
        <pre class="debug-content">{{ JSON.stringify(scoreData, null, 2) }}</pre>
      </el-card>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted, onUnmounted, watch, nextTick } from 'vue';
import * as echarts from 'echarts';
import { ElMessage } from 'element-plus';
import { Refresh, Loading } from '@element-plus/icons-vue';
// import { getCourseAvgScores } from '@/api/api';

export default {
  name: 'CourseAvgScores',
  components: {
    Refresh,
    Loading,
  },
  setup() {
    const college = ref('');
    const semester = ref('');
    const scoreData = ref([]);
    const loading = ref(false);
    const showDebug = ref(false);
    const scoreChartRef = ref(null);
    let scoreChartInstance = null;
    let resizeObserver = null;

    // 模拟数据（用于测试和演示）
    const mockData = [
      { courseName: '高等数学', college: '计算机科学与技术学院', avgScoreGroup: 78.5, avgScoreSchool: 75.2, semester: '2024-2025学年第二学期' },
      { courseName: '高等数学', college: '全校', avgScoreGroup: 75.2, avgScoreSchool: 75.2, semester: '2024-2025学年第二学期' },
      { courseName: '大学英语', college: '计算机科学与技术学院', avgScoreGroup: 82.3, avgScoreSchool: 80.1, semester: '2024-2025学年第二学期' },
      { courseName: '大学英语', college: '全校', avgScoreGroup: 80.1, avgScoreSchool: 80.1, semester: '2024-2025学年第二学期' },
      { courseName: '程序设计基础', college: '计算机科学与技术学院', avgScoreGroup: 85.7, avgScoreSchool: 78.9, semester: '2024-2025学年第二学期' },
      { courseName: '程序设计基础', college: '全校', avgScoreGroup: 78.9, avgScoreSchool: 78.9, semester: '2024-2025学年第二学期' },
      { courseName: '线性代数', college: '计算机科学与技术学院', avgScoreGroup: 76.2, avgScoreSchool: 74.5, semester: '2024-2025学年第二学期' },
      { courseName: '线性代数', college: '全校', avgScoreGroup: 74.5, avgScoreSchool: 74.5, semester: '2024-2025学年第二学期' },
      { courseName: '大学物理', college: '计算机科学与技术学院', avgScoreGroup: 72.8, avgScoreSchool: 71.3, semester: '2024-2025学年第二学期' },
      { courseName: '大学物理', college: '全校', avgScoreGroup: 71.3, avgScoreSchool: 71.3, semester: '2024-2025学年第二学期' },
      { courseName: '思想道德修养', college: '马克思主义学院', avgScoreGroup: 88.5, avgScoreSchool: 85.2, semester: '2024-2025学年第二学期' },
      { courseName: '思想道德修养', college: '全校', avgScoreGroup: 85.2, avgScoreSchool: 85.2, semester: '2024-2025学年第二学期' },
      { courseName: '马克思主义原理', college: '马克思主义学院', avgScoreGroup: 86.3, avgScoreSchool: 82.7, semester: '2024-2025学年第二学期' },
      { courseName: '马克思主义原理', college: '全校', avgScoreGroup: 82.7, avgScoreSchool: 82.7, semester: '2024-2025学年第二学期' },
    ];

    // 计算统计数据
    const courseCount = computed(() => {
      const courses = [...new Set(scoreData.value.map(item => item.courseName))];
      return courses.length;
    });

    const avgGroupScore = computed(() => {
      const groupData = scoreData.value.filter(item => item.college !== '全校');
      if (!groupData.length) return '--';
      const avg = groupData.reduce((sum, item) => sum + (item.avgScoreGroup || 0), 0) / groupData.length;
      return avg.toFixed(1);
    });

    const avgSchoolScore = computed(() => {
      const schoolData = scoreData.value.filter(item => item.college === '全校');
      if (!schoolData.length) return '--';
      const avg = schoolData.reduce((sum, item) => sum + (item.avgScoreSchool || 0), 0) / schoolData.length;
      return avg.toFixed(1);
    });

    const scoreDiff = computed(() => {
      if (avgGroupScore.value === '--' || avgSchoolScore.value === '--') return '--';
      const diff = parseFloat(avgGroupScore.value) - parseFloat(avgSchoolScore.value);
      return (diff > 0 ? '+' : '') + diff.toFixed(1);
    });

    const scoreDiffClass = computed(() => {
      if (scoreDiff.value === '--') return '';
      return parseFloat(scoreDiff.value) >= 0 ? 'positive' : 'negative';
    });

    // 初始化图表
    const initChart = () => {
      if (!scoreChartRef.value) return;

      // 确保容器有尺寸
      const container = scoreChartRef.value;
      if (container.offsetWidth === 0 || container.offsetHeight === 0) {
        console.warn('图表容器尺寸为0，延迟初始化');
        return;
      }

      scoreChartInstance = echarts.init(container);

      // 监听容器大小变化
      resizeObserver = new ResizeObserver(() => {
        scoreChartInstance?.resize();
      });
      resizeObserver.observe(container);
    };

    // 设置图表配置
    const setScoreChartOption = () => {
      if (!scoreChartInstance) {
        console.warn('图表实例不存在');
        return;
      }

      // 获取所有课程名称
      const courses = [...new Set(scoreData.value.map(item => item.courseName))];

      if (!courses.length) {
        scoreChartInstance.clear();
        scoreChartInstance.setOption({
          title: {
            text: '暂无数据',
            left: 'center',
            top: 'center',
            textStyle: { color: '#999', fontSize: 16 }
          }
        });
        return;
      }

      // 根据筛选条件获取群体数据
      const selectedCollege = college.value;
      const defaultColleges = ['计算机科学与技术学院', '软件学院', '外国语学院', '电气工程学院', '机械工程学院', '马克思主义学院'];
      const targetColleges = selectedCollege ? [selectedCollege] : defaultColleges;

      // 计算每门课程的群体平均分
      const groupScores = courses.map(courseName => {
        const courseData = scoreData.value.filter(
            item => targetColleges.includes(item.college) && item.courseName === courseName
        );
        if (!courseData.length) return 0;
        const total = courseData.reduce((sum, item) => sum + (item.avgScoreGroup || 0), 0);
        return Math.round((total / courseData.length) * 100) / 100;
      });

      // 获取全校平均分
      const schoolScores = courses.map(courseName => {
        const schoolRecord = scoreData.value.find(
            item => item.college === '全校' && item.courseName === courseName
        );
        return schoolRecord?.avgScoreSchool || 0;
      });

      // 配置图表
      const option = {
        title: {
          text: '课程平均分对比',
          left: 'center',
          top: 10,
          textStyle: {
            fontSize: 18,
            fontWeight: 600,
            color: '#1f2d3d'
          }
        },
        tooltip: {
          trigger: 'axis',
          backgroundColor: 'rgba(255, 255, 255, 0.95)',
          borderColor: '#e4e9f2',
          borderWidth: 1,
          textStyle: { color: '#1f2d3d' },
          axisPointer: {
            type: 'shadow',
            shadowStyle: { color: 'rgba(75, 94, 170, 0.08)' }
          },
          formatter: (params) => {
            const courseName = params[0].name;
            let result = `<div style="font-weight:600;margin-bottom:8px;">${courseName}</div>`;
            params.forEach(item => {
              const color = item.seriesName === '本群体' ? '#4B5EAA' : '#F4A261';
              result += `<div style="display:flex;align-items:center;margin:4px 0;">
                <span style="display:inline-block;width:10px;height:10px;border-radius:2px;background:${color};margin-right:8px;"></span>
                <span>${item.seriesName}：</span>
                <span style="font-weight:600;margin-left:auto;">${Number(item.value).toFixed(2)} 分</span>
              </div>`;
            });
            return result;
          }
        },
        legend: {
          data: ['本群体', '全校平均'],
          top: 45,
          itemWidth: 16,
          itemHeight: 10,
          itemGap: 24,
          textStyle: { fontSize: 13, color: '#5f6b7a' }
        },
        grid: {
          top: 90,
          bottom: 80,
          left: 60,
          right: 40,
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: courses,
          axisLine: { lineStyle: { color: '#e4e9f2' } },
          axisTick: { show: false },
          axisLabel: {
            interval: 0,
            rotate: courses.length > 5 ? 25 : 0,
            fontSize: 12,
            color: '#5f6b7a',
            margin: 12
          }
        },
        yAxis: {
          type: 'value',
          name: '分数',
          nameTextStyle: { color: '#5f6b7a', fontSize: 12, padding: [0, 40, 0, 0] },
          min: 0,
          max: 100,
          splitNumber: 5,
          axisLine: { show: false },
          axisTick: { show: false },
          splitLine: { lineStyle: { color: '#f0f2f5', type: 'dashed' } },
          axisLabel: { color: '#5f6b7a', fontSize: 12 }
        },
        series: [
          {
            name: '本群体',
            type: 'bar',
            data: groupScores,
            barWidth: '30%',
            barGap: '20%',
            itemStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                { offset: 0, color: '#6B7FCC' },
                { offset: 1, color: '#4B5EAA' }
              ]),
              borderRadius: [4, 4, 0, 0]
            },
            emphasis: {
              itemStyle: {
                color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                  { offset: 0, color: '#8294D8' },
                  { offset: 1, color: '#5A6DBB' }
                ])
              }
            },
            label: {
              show: true,
              position: 'top',
              fontSize: 11,
              color: '#4B5EAA',
              formatter: '{c}'
            }
          },
          {
            name: '全校平均',
            type: 'bar',
            data: schoolScores,
            barWidth: '30%',
            itemStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                { offset: 0, color: '#F7B98A' },
                { offset: 1, color: '#F4A261' }
              ]),
              borderRadius: [4, 4, 0, 0]
            },
            emphasis: {
              itemStyle: {
                color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                  { offset: 0, color: '#F9CBA5' },
                  { offset: 1, color: '#F5B072' }
                ])
              }
            },
            label: {
              show: true,
              position: 'top',
              fontSize: 11,
              color: '#E8924D',
              formatter: '{c}'
            }
          }
        ],
        animationDuration: 800,
        animationEasing: 'cubicOut'
      };

      scoreChartInstance.setOption(option, true);
    };

    // 加载模拟数据
    const loadMockData = () => {
      loading.value = true;
      setTimeout(() => {
        scoreData.value = mockData;
        loading.value = false;
        nextTick(() => {
          if (!scoreChartInstance) {
            initChart();
          }
          setScoreChartOption();
        });
        ElMessage.success('已加载示例数据');
      }, 500);
    };

    // 获取课程平均分数据
    const fetchCourseAvgScores = async () => {
      loading.value = true;
      try {
        // 如果有真实 API，使用以下代码：
        // const response = await getCourseAvgScores({
        //   college: college.value,
        //   semester: semester.value,
        // });
        // if (response.data.status && response.data.code === 0) {
        //   scoreData.value = response.data.data || [];
        // }

        // 模拟 API 请求
        await new Promise(resolve => setTimeout(resolve, 500));

        // 根据筛选条件过滤模拟数据
        let filteredData = [...mockData];
        if (semester.value) {
          filteredData = filteredData.filter(item => item.semester === semester.value);
        }
        if (college.value) {
          filteredData = filteredData.filter(
              item => item.college === college.value || item.college === '全校'
          );
        }

        scoreData.value = filteredData;

        await nextTick();
        if (!scoreChartInstance && scoreChartRef.value) {
          initChart();
        }
        setScoreChartOption();

      } catch (error) {
        console.error('获取数据失败:', error);
        ElMessage.error(`请求失败: ${error.message || '未知错误'}`);
      } finally {
        loading.value = false;
      }
    };

    // 生命周期钩子
    onMounted(() => {
      // 初始加载数据
      fetchCourseAvgScores();
    });

    onUnmounted(() => {
      if (resizeObserver) {
        resizeObserver.disconnect();
      }
      if (scoreChartInstance) {
        scoreChartInstance.dispose();
        scoreChartInstance = null;
      }
    });

    // 监听筛选条件变化
    watch([college, semester], () => {
      fetchCourseAvgScores();
    });

    return {
      college,
      semester,
      scoreData,
      loading,
      showDebug,
      scoreChartRef,
      courseCount,
      avgGroupScore,
      avgSchoolScore,
      scoreDiff,
      scoreDiffClass,
      fetchCourseAvgScores,
      loadMockData,
      Refresh,
      Loading,
    };
  },
};
</script>

<style scoped>
.analytics-page {
  min-height: calc(100vh - 125px);
  background: linear-gradient(135deg, #f5f7fb 0%, #e8ecf4 100%);
  padding: 24px;
}

.analytics-wrapper {
  max-width: 1400px;
  margin: 0 auto;
}

.page-header {
  margin-bottom: 24px;
}

.header-content {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.page-title {
  margin: 0;
  font-size: 28px;
  font-weight: 700;
  color: #1f2d3d;
  display: flex;
  align-items: center;
  gap: 12px;
}

.title-icon {
  font-size: 32px;
}

.page-desc {
  margin: 0;
  color: #5f6b7a;
  font-size: 15px;
  line-height: 1.6;
}

.panel-card {
  border-radius: 16px;
  border: none;
  box-shadow: 0 4px 24px rgba(31, 45, 61, 0.08);
  overflow: hidden;
}

.panel-card :deep(.el-card__header) {
  background: linear-gradient(135deg, #fafbfc 0%, #f5f7fb 100%);
  border-bottom: 1px solid #e4e9f2;
  padding: 16px 24px;
}

.panel-card :deep(.el-card__body) {
  padding: 24px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header h2 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #1f2d3d;
}

.header-actions {
  display: flex;
  gap: 8px;
}

.filter-row {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  margin-bottom: 24px;
  padding-bottom: 20px;
  border-bottom: 1px solid #f0f2f5;
}

.filter-select {
  width: 260px;
}

.filter-select :deep(.el-input__wrapper) {
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.filter-select :deep(.el-input__wrapper:hover) {
  box-shadow: 0 2px 12px rgba(75, 94, 170, 0.12);
}

/* 加载状态 */
.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 400px;
  color: #5f6b7a;
  gap: 16px;
}

.loading-icon {
  font-size: 40px;
  color: #4B5EAA;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

/* 空数据状态 */
.empty-container {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 400px;
}

.empty-icon {
  font-size: 80px;
  opacity: 0.6;
}

/* 图表容器 */
.chart-container {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.chart-box {
  width: 100%;
  height: 480px;
  background: #fff;
  border-radius: 12px;
  border: 1px solid #f0f2f5;
}

/* 统计卡片 */
.stats-row {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
}

.stat-card {
  background: linear-gradient(135deg, #fafbfc 0%, #f5f7fb 100%);
  border-radius: 12px;
  padding: 20px;
  text-align: center;
  border: 1px solid #e4e9f2;
  transition: all 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(75, 94, 170, 0.1);
}

.stat-card.positive {
  background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
  border-color: #a5d6a7;
}

.stat-card.positive .stat-value {
  color: #2e7d32;
}

.stat-card.negative {
  background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
  border-color: #ef9a9a;
}

.stat-card.negative .stat-value {
  color: #c62828;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #4B5EAA;
  margin-bottom: 6px;
}

.stat-label {
  font-size: 13px;
  color: #5f6b7a;
}

/* 调试面板 */
.debug-card {
  margin-top: 24px;
  border-radius: 12px;
}

.debug-card h3 {
  margin: 0;
  font-size: 14px;
  color: #5f6b7a;
}

.debug-content {
  margin: 0;
  padding: 16px;
  background: #f5f7fb;
  border-radius: 8px;
  font-size: 12px;
  line-height: 1.5;
  overflow-x: auto;
  max-height: 300px;
}

/* 响应式适配 */
@media (max-width: 1024px) {
  .stats-row {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .analytics-page {
    padding: 16px;
  }

  .page-title {
    font-size: 22px;
  }

  .title-icon {
    font-size: 26px;
  }

  .filter-select {
    width: 100%;
  }

  .chart-box {
    height: 350px;
  }

  .stats-row {
    grid-template-columns: 1fr;
  }

  .stat-value {
    font-size: 24px;
  }
}
</style>
