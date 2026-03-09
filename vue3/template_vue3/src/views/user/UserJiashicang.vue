
<template>
  <div>
    <!-- 统计数据 -->
    <h2>统计数据</h2>
    <div class="stats-container">
      <el-card v-if="stats && Object.keys(stats).length" class="stats-card">
        <div>签到完成: {{ stats.checkInCompleted ?? 0 }}</div>
        <div>在线用户: {{ stats.onlineUsers ?? 0 }}</div>
        <div>总学生数: {{ stats.totalUsers ?? 0 }}</div>
        <div>任务点完成: {{ stats.taskPointsCompleted ?? 0 }}</div>
        <div>教师数: {{ stats.teachers ?? 0 }}</div>
        <div>课程数: {{ stats.courses ?? 0 }}</div>
        <div>章节资源: {{ stats.chapterResources ?? 0 }}</div>
        <div>课程材料: {{ stats.courseMaterials ?? 0 }}</div>
        <div>任务点: {{ stats.taskPoints ?? 0 }}</div>
      </el-card>
      <div v-else>加载统计数据中...</div>
    </div>

    <el-button type="primary" class="register" @click="courseinsert">添加课程</el-button>

    <!-- 学情指数分布（饼状图） -->
    <h2>学情指数分布</h2>
    <div id="learningIndexChart" style="width: 500px; height: 400px;"></div>

    <!-- 学情指数分析 -->
    <h2>学情指数分析</h2>
    <el-table :data="learningIndexList" style="width: 100%" v-if="learningIndexList.length">
      <el-table-column prop="name" label="姓名" />
      <el-table-column prop="loginName" label="登录名" />
      <el-table-column prop="learningIndex" label="学情指数" />
      <el-table-column prop="departmentName" label="院系" />
    </el-table>
    <div v-else>暂无数据</div>
    <div style="width: 100%; z-index: 1000">
      <el-pagination
          v-if="page.total > 0"
          :background="true"
          v-model:current-page="page.pageNum"
          v-model:page-size="page.pageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="page.total"
          @size-change="handleSizeChange"
          @current-change="pageNumChange"
          style="display: flex; justify-content: right;"
      />
    </div>
    <div>
      <el-button @click="fetchLearningIndexList(0, 2)">极差 (0-2)</el-button>
      <el-button @click="fetchLearningIndexList(2, 4)">较差 (2-4)</el-button>
      <el-button @click="fetchLearningIndexList(4, 6)">一般 (4-6)</el-button>
      <el-button @click="fetchLearningIndexList(6, 8)">较好 (6-8)</el-button>
      <el-button @click="fetchLearningIndexList(8, 10)">极好 (8-10)</el-button>
    </div>
    <!-- 院系排名 -->
    <h2>院系排名</h2>
    <el-table :data="departmentRanking" style="width: 100%" v-if="departmentRanking.length">
      <el-table-column prop="name" label="院系名称" />
      <el-table-column prop="visits" label="访问量" />
    </el-table>

    <!-- 直播课 -->
    <h2>直播课</h2>
    <el-table :data="liveSessions" style="width: 100%" v-if="liveSessions.length">
      <el-table-column prop="courseName" label="课程名称" />
      <el-table-column prop="teacher" label="教师" />
      <el-table-column prop="startTime" label="开始时间" />
      <el-table-column prop="status" label="状态" />
    </el-table>

  </div>
</template>

<script>
import {
  getDashboardStats,
  getLearningIndex,
  getLearningIndexList,
  getDepartmentRanking,
  getLiveSessions,
} from '@/api/api.js';
import * as echarts from 'echarts';
import { ref, onMounted, onUnmounted } from 'vue';
import router from "@/router";

export default {
  name: 'UserJiashicang',
  setup() {
    const learningIndexList = ref([]);
    const learningIndex = ref([]);
    let myChart = null;

    const initChart = () => {
      const chartDom = document.getElementById('learningIndexChart');
      if (chartDom) {
        myChart = echarts.init(chartDom);
      }
    };

    const setChartOption = (data) => {
      if (!myChart) return;
      const option = {
        title: {
          text: '学情指数分布',
          subtext: '学生学情指数分布数据',
          left: 'center',
        },
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c}% ({d}%)',
        },
        legend: {
          orient: 'vertical',
          left: 'left',
        },
        series: [
          {
            name: '学情指数',
            type: 'pie',
            radius: '50%',
            data: data.map(item => ({
              value: item.percentage || 0,
              name: item.label || '未知',
            })),
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: 'rgba(0, 0, 0, 0.5)',
              },
            },
          },
        ],
      };
      myChart.setOption(option);
    };

    onMounted(() => {
      initChart();
    });

    onUnmounted(() => {
      if (myChart) {
        myChart.dispose();
        myChart = null;
      }
    });

    return { learningIndexList, learningIndex, setChartOption };
  },
  data() {
    return {
      stats: null,
      departmentRanking: [],
      liveSessions: [],
      page: {
        pageNum: 1,
        pageSize: 10,
        total: 0
      },
      query: {
        min: 0,
        max: 2
      }
    };
  },
  mounted() {
    this.fetchDashboardStats();
    this.fetchLearningIndex();
    this.fetchLearningIndexList(8, 10); // 默认加载 8-10 区间
    this.fetchDepartmentRanking();
    this.fetchLiveSessions();
  },
  methods: {

    async fetchDashboardStats() {
      try {
        const response = await getDashboardStats();
        console.log('Stats Response:', response);
        if (response.status === true && response.code === 0) {
          this.stats = response.data || {};
          console.log('Stats Assigned:', this.stats);
        } else if (response.code === 70005) {
          this.$message.error('请先登录');
          this.$router.push('/login');
        } else {
          this.$message.error(response.message || '获取统计数据失败');
        }
      } catch (error) {
        console.error('fetchDashboardStats Error:', error);
        this.$message.error('请求失败: ' + error.message);
      }
    },

    async fetchLearningIndex() {
      try {
        const response = await getLearningIndex();
        console.log('LearningIndex Response:', response);
        if (response.status === true && response.code === 0 && Array.isArray(response.data)) {
          this.learningIndex = response.data;
          this.setChartOption(response.data);
          console.log('Chart Data Updated:', this.learningIndex);
        } else if (response.code === 70005) {
          this.$message.error('请先登录');
          this.$router.push('/login');
        } else {
          this.$message.error(response.message || '获取学情指数分布失败');
        }
      } catch (error) {
        console.error('fetchLearningIndex Error:', error);
        this.$message.error('请求失败: ' + error.message);
      }
    },
    async fetchLearningIndexList(min, max) {
      try {
        this.query.min = min
        this.query.max = max
        const param = {
          min: min,
          max: max,
          pageNum: this.page.pageNum || 1,
          pageSize: this.page.pageSize
        }
        console.log(`Fetching LearningIndexList with min: ${min}, max: ${max}`);
        const response = await getLearningIndexList(param);
        console.log('LearningIndexList Response:', response);
        if (response.status === true && response.code === 0) {
          this.learningIndexList = response.data.records || [];
          this.page.total = response.data.total || 0
          console.log('Updated learningIndexList:', this.learningIndexList);
        } else if (response.code === 70005) {
          this.$message.error('请先登录');
          this.$router.push('/login');
        } else {
          this.$message.error(response.message || '获取学情指数失败');
        }
      } catch (error) {
        console.error('fetchLearningIndexList Error:', error);
        this.$message.error('请求失败: ' + error.message);
      }
    },
    async fetchDepartmentRanking() {
      try {
        const response = await getDepartmentRanking();
        console.log('DepartmentRanking Response:', response);
        if (response.status === true && response.code === 0) {
          this.departmentRanking = response.data || [];
        } else if (response.code === 70005) {
          this.$message.error('请先登录');
          this.$router.push('/login');
        } else {
          this.$message.error(response.message || '获取院系排名失败');
        }
      } catch (error) {
        console.error('fetchDepartmentRanking Error:', error);
        this.$message.error('请求失败: ' + error.message);
      }
    },
    async fetchLiveSessions() {
      try {
        const response = await getLiveSessions();
        console.log('LiveSessions Response:', response);
        if (response.status === true && response.code === 0) {
          this.liveSessions = response.data || [];
        } else if (response.code === 70005) {
          this.$message.error('请先登录');
          this.$router.push('/login');
        } else {
          this.$message.error(response.message || '获取直播课数据失败');
        }
      } catch (error) {
        console.error('fetchLiveSessions Error:', error);
        this.$message.error('请求失败: ' + error.message);
      }
    },
    async handleSizeChange () {
      const param = {
        pageNum: this.page.pageNum,
        pageSize: this.page.pageSize,
        min: this.query.min,
        max: this.query.max
      }
      const response = await getLearningIndexList(param);
      this.learningIndexList = response.data.records || [];
      this.page.total = response.data.total || 0

    },
    async pageNumChange(){

      const param = {
        pageNum: this.page.pageNum,
        pageSize: this.page.pageSize,
        min: this.query.min,
        max: this.query.max
      }
      const response = await getLearningIndexList(param);
      this.learningIndexList = response.data.records || [];
      this.page.total = response.data.total || 0
    },
    async courseinsert(){
      await router.push({path: '../user/courseinsert'});
    }
  },

};
</script>

<style scoped>
.stats-container {
  margin-bottom: 20px;
}
.stats-card {
  padding: 20px;
  margin-bottom: 20px;
}
h2 {
  margin-top: 20px;
}
.el-table {
  margin-top: 20px;
}
.el-button {
  margin: 10px;
}
</style>
