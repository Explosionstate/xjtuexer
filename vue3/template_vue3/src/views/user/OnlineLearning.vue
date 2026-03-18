<template>
  <div class="learning-container">
    <!-- 横幅区域 -->
    <div class="banner-section">
      <div class="banner-overlay"></div>
      <div class="banner-content">
        <h1 class="banner-title">在线学习</h1>
        <p class="banner-subtitle">深化理论学习，筑牢思想基础</p>
        <div class="banner-wave">
          <svg viewBox="0 0 1200 120" preserveAspectRatio="none">
            <path d="M0,0V46.29c47.79,22.2,103.59,32.17,158,28,70.36-5.37,136.33-33.31,206.8-37.5C438.64,32.43,512.34,53.67,583,72.05c69.27,18,138.3,24.88,209.4,13.08,36.15-6,69.85-17.84,104.45-29.34C989.49,25,1113-14.29,1200,52.47V0Z" opacity=".25" fill="currentColor"></path>
            <path d="M0,0V15.81C13,36.92,27.64,56.86,47.69,72.05,99.41,111.27,165,111,224.58,91.58c31.15-10.15,60.09-26.07,89.67-39.8,40.92-19,84.73-46,130.83-49.67,36.26-2.85,70.9,9.42,98.6,31.56,31.77,25.39,62.32,62,103.63,73,40.44,10.79,81.35-6.69,119.13-24.28s75.16-39,116.92-43.05c59.73-5.85,113.28,22.88,168.9,38.84,30.2,8.66,59,6.17,87.09-7.5,22.43-10.89,48-26.93,60.65-49.24V0Z" opacity=".5" fill="currentColor"></path>
            <path d="M0,0V5.63C149.93,59,314.09,71.32,475.83,42.57c43-7.64,84.23-20.12,127.61-26.46,59-8.63,112.48,12.24,165.56,35.4C827.93,77.22,886,95.24,951.2,90c86.53-7,172.46-45.71,248.8-84.81V0Z" fill="currentColor"></path>
          </svg>
        </div>
      </div>
    </div>

    <!-- 主要内容区域 -->
    <div class="page-wrapper">
      <!-- 课程选择区域 -->
      <div class="courses-section">
        <div class="section-header">
          <div class="header-content">
            <div class="header-icon">📚</div>
            <div>
              <h2 class="section-title">选择课程</h2>
              <p class="section-desc">选择您感兴趣的课程开始学习</p>
            </div>
          </div>
          <div class="progress-indicator">
            <span class="progress-text">已选：{{ selectedCourse || '未选择' }}</span>
          </div>
        </div>

        <div class="courses-scroll-container">
          <div
              v-for="course in courses"
              :key="course.coursename"
              class="course-card-horizontal"
              :class="{ active: selectedCourse === course.coursename }"
              @click="selectCourse(course.coursename)"
          >
            <div class="course-card-inner">
              <div class="course-card-top">
                <div class="course-icon-large" :style="getCardGradient(course.coursename)">
                  <i :class="getCourseIcon(course.coursename)"></i>
                </div>
                <div class="course-badge" v-if="getSectionCount(course.coursename)">
                  {{ getSectionCount(course.coursename) }} 节
                </div>
              </div>
              <div class="course-card-bottom">
                <h3 class="course-name-vertical">{{ course.coursename }}</h3>
                <div class="course-meta">
                  <span class="course-tag" :style="getTagStyle(course.coursename)">理论学习</span>
                  <span class="course-level">初级</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div v-if="selectedCourse" class="learning-content">
        <div class="content-grid">
          <div class="sections-panel">
            <div class="sections-card">
              <div class="card-header-wrapper">
                <div class="card-header">
                  <span class="header-title">📖 章节列表</span>
                  <el-tag type="primary" effect="light" size="small">
                    {{ sections.length }} 章
                  </el-tag>
                </div>
              </div>
              <div class="sections-directory">
                <div
                    v-for="(section, index) in sections"
                    :key="section.id"
                    class="section-entry"
                    :class="{
                    active: activeSection === section.id,
                    completed: isSectionCompleted(section.id)
                  }"
                    @click="selectSection(section)"
                >
                  <div class="section-indicator">
                    <div class="section-number">{{ index + 1 }}</div>
                    <div class="section-status" v-if="isSectionCompleted(section.id)">
                      <i class="el-icon-check"></i>
                    </div>
                  </div>
                  <div class="section-text">
                    <div class="section-label">第 {{ index + 1 }} 章</div>
                    <div class="section-title">{{ section.name }}</div>
                  </div>
                  <div class="section-duration">
                    <i class="el-icon-time"></i>
                    <span>15min</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- 右侧内容区域 -->
          <div class="content-main">
            <!-- 视频播放区 -->
            <div class="video-card">
              <div class="card-header-wrapper">
                <div class="card-header">
                  <span class="header-title">🎬 视频播放</span>
                  <div class="video-controls">
                    <span class="video-quality">HD 1080P</span>
                    <el-button type="text" size="small" @click="togglePlaybackSpeed">
                      倍速: {{ playbackSpeed }}x
                    </el-button>
                  </div>
                </div>
              </div>
              <div class="video-container">
                <div v-if="currentVideo" class="video-wrapper">
                  <video
                      ref="videoPlayer"
                      controls
                      class="video-player"
                      :src="currentVideo"
                      @error="handleVideoError"
                      @timeupdate="handleVideoProgress"
                  >
                    您的浏览器不支持视频播放。
                  </video>
                  <div class="video-overlay" v-if="showVideoOverlay">
                    <i class="el-icon-video-play overlay-icon"></i>
                  </div>
                </div>
                <div v-else class="video-placeholder">
                  <div class="placeholder-icon">
                    <i class="el-icon-video-play"></i>
                  </div>
                  <p>请选择章节开始学习</p>
                  <p class="placeholder-hint">点击左侧章节列表选择学习内容</p>
                </div>
              </div>
            </div>

            <!-- 信息卡片区域 -->
            <div class="info-cards-grid">
              <div class="info-card course-info">
                <div class="card-header-wrapper">
                  <div class="card-header">
                    <span class="header-title">📋 课程信息</span>
                    <el-tag type="info" effect="plain" size="small">进行中</el-tag>
                  </div>
                </div>
                <div class="info-content">
                  <div class="info-item">
                    <span class="info-label">
                      <i class="el-icon-notebook-2"></i>
                      课程名称
                    </span>
                    <span class="info-value">{{ selectedCourse }}</span>
                  </div>
                  <div class="info-item">
                    <span class="info-label">
                      <i class="el-icon-document"></i>
                      当前章节
                    </span>
                    <span class="info-value">{{ currentSection?.name || '未选择' }}</span>
                  </div>
                  <div class="info-item">
                    <span class="info-label">
                      <i class="el-icon-tickets"></i>
                      课程类型
                    </span>
                    <el-tag type="primary" effect="light" size="small">视频课程</el-tag>
                  </div>
                  <div class="info-item">
                    <span class="info-label">
                      <i class="el-icon-star-off"></i>
                      课程难度
                    </span>
                    <el-rate
                        v-model="difficultyScore"
                        disabled
                        show-score
                        score-template="{value} 星"
                    />
                  </div>
                </div>
              </div>

              <div class="info-card progress-info">
                <div class="card-header-wrapper">
                  <div class="card-header">
                    <span class="header-title">📊 学习进度</span>
                    <el-button type="text" size="small" @click="resetProgress">
                      重置
                    </el-button>
                  </div>
                </div>
                <div class="info-content">
                  <div class="progress-item">
                    <div class="progress-header">
                      <span class="progress-label">整体进度</span>
                      <span class="progress-percentage">{{ overallProgress }}%</span>
                    </div>
                    <el-progress
                        :percentage="overallProgress"
                        :color="customColors"
                        :show-text="false"
                        stroke-width="8"
                    />
                  </div>
                  <div class="progress-item">
                    <div class="progress-header">
                      <span class="progress-label">当前章节</span>
                      <span class="progress-percentage">{{ currentSectionProgress }}%</span>
                    </div>
                    <el-progress
                        :percentage="currentSectionProgress"
                        color="#7e57c2"
                        :show-text="false"
                        stroke-width="6"
                    />
                  </div>
                  <div class="progress-stats">
                    <div class="stat-item">
                      <div class="stat-value">{{ completedSections }}</div>
                      <div class="stat-label">已完成</div>
                    </div>
                    <div class="stat-item">
                      <div class="stat-value">{{ sections.length }}</div>
                      <div class="stat-label">总章节</div>
                    </div>
                    <div class="stat-item">
                      <div class="stat-value">{{ studyTime }}</div>
                      <div class="stat-label">学习时间</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- 学习建议卡片 -->
            <div class="suggestion-card">
              <div class="card-header-wrapper">
                <div class="card-header">
                  <span class="header-title">💡 学习建议</span>
                  <el-button type="text" size="small" @click="showMoreTips">
                    更多建议
                  </el-button>
                </div>
              </div>
              <div class="suggestion-content">
                <p class="suggestion-intro">为了获得更好的学习效果，建议您：</p>
                <ul class="suggestion-list">
                  <li v-for="(tip, index) in learningTips" :key="index" class="suggestion-item">
                    <i class="el-icon-check tip-icon"></i>
                    {{ tip }}
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div v-else class="empty-state">
        <div class="empty-content">
          <div class="empty-icon">
            <i class="el-icon-notebook-2"></i>
          </div>
          <p class="empty-title">请选择课程开始学习</p>
          <p class="empty-desc">从上侧课程列表中选择一门课程开始您的学习之旅</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, computed } from 'vue';
import { ElMessage } from 'element-plus';
import axios from 'axios';

export default {
  name: 'OnlineLearning',
  setup() {
    const courses = ref([]);
    const selectedCourse = ref('');
    const activeSection = ref('');
    const currentVideo = ref('');
    const currentSection = ref(null);
    const sections = ref([]);
    const completedSections = ref(0);
    const difficultyScore = ref(4);
    const playbackSpeed = ref(1.0);
    const studyTime = ref('0分钟');
    const completedSectionsList = ref(new Set());
    const videoPlayer = ref(null);
    const showVideoOverlay = ref(false);

    const learningTips = [
      '每次集中学习45-60分钟，避免过度疲劳',
      '边看视频边做笔记，加深理解和印象',
      '完成每章节后进行自我检测和总结',
      '遇到疑难问题可查阅相关参考资料',
      '定期复习已学内容，巩固学习效果'
    ];

    const courseSections = {
      '马克思主义基本原理': [
        { id: '1', name: '历史唯物主义基础', video: '/api/online-course/video/31.mp4' },
        { id: '2', name: '物质与意识', video: '/api/online-course/video/32.mp4' },
        { id: '3', name: '社会发展规律', video: '/api/online-course/video/33.mp4' },
        { id: '4', name: '阶级斗争理论', video: '/api/online-course/video/34.mp4' },
      ],
      '中国近现代史纲要': [
        { id: '1', name: '鸦片战争与近代史开端', video: '/api/online-course/video/21.mp4' },
        { id: '2', name: '辛亥革命与民国建立', video: '/api/online-course/video/22.mp4' },
        { id: '3', name: '新中国成立与建设', video: '/api/online-course/video/23.mp4' },
        { id: '4', name: '改革开放与现代化', video: '/api/online-course/video/24.mp4' },
      ],
    };

    const overallProgress = computed(() => {
      return sections.value.length > 0
          ? Math.round((completedSections.value / sections.value.length) * 100)
          : 0;
    });

    const currentSectionProgress = computed(() => {
      if (!videoPlayer.value) return 0;
      const video = videoPlayer.value;
      if (video.duration) {
        return Math.round((video.currentTime / video.duration) * 100);
      }
      return 0;
    });

    const customColors = computed(() => [
      { color: '#f44336', percentage: 20 },
      { color: '#e91e63', percentage: 40 },
      { color: '#9c27b0', percentage: 60 },
      { color: '#673ab7', percentage: 80 },
      { color: '#3f51b5', percentage: 100 }
    ]);

    const getCourseIcon = (coursename) => {
      const icons = {
        '马克思主义基本原理': 'el-icon-s-promotion',
        '中国近现代史纲要': 'el-icon-s-management',
      };
      return icons[coursename] || 'el-icon-s-open';
    };

    const getCardGradient = (coursename) => {
      const gradients = {
        '马克思主义基本原理': 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
        '中国近现代史纲要': 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
      };
      return { background: gradients[coursename] || 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)' };
    };

    const getTagStyle = (coursename) => {
      const colors = {
        '马克思主义基本原理': { background: 'rgba(102, 126, 234, 0.1)', color: '#667eea' },
        '中国近现代史纲要': { background: 'rgba(240, 147, 251, 0.1)', color: '#f093fb' },
      };
      return colors[coursename] || { background: 'rgba(79, 172, 254, 0.1)', color: '#4facfe' };
    };

    const getSectionCount = (coursename) => {
      return courseSections[coursename]?.length || 0;
    };

    const isSectionCompleted = (sectionId) => {
      return completedSectionsList.value.has(sectionId);
    };

    const fetchCourses = async () => {
      try {
        const response = await axios.get('http://localhost:8080/api/online-course/courses');
        if (response.data.code === 0 && response.data.data.length > 0) {
          courses.value = response.data.data;
        } else {
          courses.value = [
            { coursename: '马克思主义基本原理' },
            { coursename: '中国近现代史纲要' }
          ];
          ElMessage.warning('使用默认课程数据');
        }
      } catch (error) {
        courses.value = [
          { coursename: '马克思主义基本原理' },
          { coursename: '中国近现代史纲要' }
        ];
        ElMessage.warning('无法连接服务器，使用本地课程数据');
      }
    };

    const selectCourse = async (coursename) => {
      try {
        await axios.post('http://localhost:8080/api/online-course/increment-visit', null, {
          params: { coursename },
        });
        selectedCourse.value = coursename;
        sections.value = courseSections[coursename] || [];
        activeSection.value = '';
        currentVideo.value = '';
        currentSection.value = null;
        completedSections.value = 0;
        completedSectionsList.value.clear();

        if (sections.value.length === 0) {
          ElMessage.error('未找到该课程的章节内容');
        } else {
          ElMessage.success(`已选择《${coursename}》课程`);
        }
      } catch (error) {
        selectedCourse.value = coursename;
        sections.value = courseSections[coursename] || [];
        ElMessage.error('更新访问量失败，使用本地数据');
      }
    };

    const selectSection = (section) => {
      activeSection.value = section.id;
      currentVideo.value = section.video;
      currentSection.value = section;
      showVideoOverlay.value = true;

      setTimeout(() => {
        showVideoOverlay.value = false;
      }, 1000);
    };

    const togglePlaybackSpeed = () => {
      const speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
      const currentIndex = speeds.indexOf(playbackSpeed.value);
      const nextIndex = (currentIndex + 1) % speeds.length;
      playbackSpeed.value = speeds[nextIndex];

      if (videoPlayer.value) {
        videoPlayer.value.playbackRate = playbackSpeed.value;
      }

      ElMessage.info(`播放速度已调整为 ${playbackSpeed.value}x`);
    };

    const handleVideoError = (event) => {
      ElMessage.error('视频加载失败，请检查网络或文件路径');
      console.error('Video load error:', event);
    };

    const handleVideoProgress = () => {
      const video = videoPlayer.value;
      if (video && video.currentTime / video.duration > 0.9 && !isSectionCompleted(activeSection.value)) {
        completedSectionsList.value.add(activeSection.value);
        completedSections.value = completedSectionsList.value.size;

        if (!video.progressUpdated) {
          ElMessage.success('恭喜完成本章节学习！');
          video.progressUpdated = true;
        }
      }
    };

    const resetProgress = () => {
      completedSectionsList.value.clear();
      completedSections.value = 0;
      ElMessage.success('学习进度已重置');
    };

    const showMoreTips = () => {
      ElMessage.info('更多学习建议功能开发中...');
    };

    onMounted(() => {
      fetchCourses();
    });

    return {
      courses,
      selectedCourse,
      sections,
      activeSection,
      currentVideo,
      currentSection,
      overallProgress,
      currentSectionProgress,
      completedSections,
      difficultyScore,
      playbackSpeed,
      studyTime,
      learningTips,
      videoPlayer,
      showVideoOverlay,
      customColors,
      getCourseIcon,
      getCardGradient,
      getTagStyle,
      getSectionCount,
      isSectionCompleted,
      selectCourse,
      selectSection,
      togglePlaybackSpeed,
      handleVideoError,
      handleVideoProgress,
      resetProgress,
      showMoreTips,
    };
  },
};
</script>

<style scoped>
/* 全局样式变量 */
:root {
  --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  --accent-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  --success-gradient: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  --warning-gradient: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
  --card-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
  --card-shadow-hover: 0 20px 40px rgba(0, 0, 0, 0.12);
  --transition-smooth: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

* {
  box-sizing: border-box;
}

.learning-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4edf5 100%);
  font-family: 'Inter', 'PingFang SC', 'Microsoft YaHei', sans-serif;
}

/* 横幅区域 */
.banner-section {
  background: linear-gradient(135deg, #2c3e50 0%, #34495e 50%, #2c3e50 100%);
  color: white;
  padding: 60px 20px 100px;
  position: relative;
  overflow: hidden;
  margin-bottom: 40px;
}

.banner-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background:
      radial-gradient(circle at 20% 80%, rgba(103, 58, 183, 0.3) 0%, transparent 50%),
      radial-gradient(circle at 80% 20%, rgba(233, 30, 99, 0.3) 0%, transparent 50%);
}

.banner-content {
  max-width: 1200px;
  margin: 0 auto;
  position: relative;
  z-index: 2;
  text-align: center;
}

.banner-title {
  font-size: 48px;
  font-weight: 800;
  margin: 0 0 16px 0;
  background: linear-gradient(135deg, #fff 0%, #e3f2fd 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  letter-spacing: -0.5px;
}

.banner-subtitle {
  font-size: 18px;
  opacity: 0.9;
  margin: 0;
  font-weight: 400;
  color: rgba(255, 255, 255, 0.9);
}

.banner-wave {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 120px;
  color: #f5f7fa;
  transform: translateY(1px);
}

/* 页面包装器 */
.page-wrapper {
  max-width: 1400px;
  margin: -60px auto 40px;
  padding: 0 20px;
  position: relative;
  z-index: 10;
}

/* 课程选择区域 */
.courses-section {
  background: white;
  border-radius: 20px;
  padding: 30px;
  margin-bottom: 40px;
  box-shadow: var(--card-shadow);
  transition: var(--transition-smooth);
}

.courses-section:hover {
  box-shadow: var(--card-shadow-hover);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 30px;
  padding-bottom: 20px;
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);
}

.header-content {
  display: flex;
  align-items: center;
  gap: 20px;
}

.header-icon {
  font-size: 40px;
  background: var(--primary-gradient);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.section-title {
  font-size: 28px;
  font-weight: 700;
  color: #1a1a1a;
  margin: 0 0 8px 0;
}

.section-desc {
  color: #666;
  margin: 0;
  font-size: 15px;
  opacity: 0.8;
}

.progress-indicator {
  background: rgba(102, 126, 234, 0.1);
  padding: 8px 16px;
  border-radius: 12px;
  border: 1px solid rgba(102, 126, 234, 0.2);
}

.progress-text {
  font-size: 14px;
  color: #667eea;
  font-weight: 500;
}

/* 课程卡片水平滚动 */
.courses-scroll-container {
  display: flex;
  gap: 24px;
  overflow-x: auto;
  padding: 20px 10px;
  scroll-behavior: smooth;
  -webkit-overflow-scrolling: touch;
}

.courses-scroll-container::-webkit-scrollbar {
  height: 8px;
}

.courses-scroll-container::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.05);
  border-radius: 10px;
}

.courses-scroll-container::-webkit-scrollbar-thumb {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 10px;
}

.courses-scroll-container::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
}

/* 课程卡片样式 */
.course-card-horizontal {
  flex: 0 0 auto;
  width: 240px;
  background: white;
  border-radius: 16px;
  border: 1px solid rgba(0, 0, 0, 0.08);
  cursor: pointer;
  transition: var(--transition-smooth);
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
}

.course-card-horizontal:hover {
  transform: translateY(-8px);
  box-shadow: 0 20px 40px rgba(102, 126, 234, 0.15);
  border-color: rgba(102, 126, 234, 0.3);
}

.course-card-horizontal.active {
  border-color: #667eea;
  box-shadow: 0 20px 40px rgba(102, 126, 234, 0.2);
}

.course-card-inner {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.course-card-top {
  padding: 30px 20px;
  position: relative;
  min-height: 160px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.course-icon-large {
  width: 80px;
  height: 80px;
  border-radius: 20px;
  background: var(--primary-gradient);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 36px;
  color: white;
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
  transition: var(--transition-smooth);
}

.course-card-horizontal:hover .course-icon-large {
  transform: scale(1.05) rotate(5deg);
}

.course-badge {
  position: absolute;
  top: 16px;
  right: 16px;
  background: rgba(255, 255, 255, 0.95);
  color: #667eea;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.course-card-bottom {
  padding: 24px 20px;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border-top: 1px solid rgba(0, 0, 0, 0.05);
}

.course-name-vertical {
  font-size: 18px;
  font-weight: 700;
  color: #1a1a1a;
  margin: 0 0 12px 0;
  line-height: 1.3;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.course-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.course-tag {
  font-size: 12px;
  font-weight: 600;
  padding: 4px 12px;
  border-radius: 12px;
  background: rgba(102, 126, 234, 0.1);
  color: #667eea;
}

.course-level {
  font-size: 12px;
  color: #666;
  opacity: 0.8;
}

/* 学习内容区域 */
.learning-content {
  animation: fadeInUp 0.6s ease;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.content-grid {
  display: grid;
  grid-template-columns: 320px 1fr;
  gap: 30px;
}

@media (max-width: 1200px) {
  .content-grid {
    grid-template-columns: 1fr;
  }
}

/* 章节面板 */
.sections-panel {
  position: sticky;
  top: 100px;
  max-height: calc(100vh - 140px);
  overflow-y: auto;
}

.sections-card {
  background: white;
  border-radius: 20px;
  box-shadow: var(--card-shadow);
  overflow: hidden;
  transition: var(--transition-smooth);
}

.sections-card:hover {
  box-shadow: var(--card-shadow-hover);
}

.card-header-wrapper {
  padding: 24px 24px 0;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  padding-bottom: 20px;
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);
}

.header-title {
  font-size: 18px;
  font-weight: 700;
  color: #1a1a1a;
  display: flex;
  align-items: center;
  gap: 8px;
}

.sections-directory {
  padding: 16px;
}

.section-entry {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px;
  cursor: pointer;
  transition: var(--transition-smooth);
  border-radius: 12px;
  margin-bottom: 8px;
  position: relative;
  overflow: hidden;
}

.section-entry::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 4px;
  background: transparent;
  transition: var(--transition-smooth);
}

.section-entry:hover {
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);
}

.section-entry:hover::before {
  background: linear-gradient(to bottom, #667eea, #764ba2);
}

.section-entry.active {
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.1);
}

.section-entry.active::before {
  background: linear-gradient(to bottom, #667eea, #764ba2);
}

.section-entry.completed .section-indicator {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: white;
}

.section-indicator {
  width: 40px;
  height: 40px;
  min-width: 40px;
  border-radius: 12px;
  background: rgba(0, 0, 0, 0.05);
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  color: #666;
  position: relative;
  transition: var(--transition-smooth);
}

.section-status {
  position: absolute;
  top: -4px;
  right: -4px;
  background: #43e97b;
  color: white;
  width: 16px;
  height: 16px;
  border-radius: 50%;
  font-size: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.section-text {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.section-label {
  font-size: 12px;
  color: #666;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  font-weight: 600;
}

.section-title {
  font-size: 14px;
  font-weight: 600;
  color: #1a1a1a;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.section-entry.active .section-title {
  color: #667eea;
}

.section-duration {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  color: #999;
  opacity: 0;
  transition: var(--transition-smooth);
}

.section-entry:hover .section-duration {
  opacity: 1;
}

/* 主要内容区域 */
.content-main {
  display: flex;
  flex-direction: column;
  gap: 30px;
}

/* 视频卡片 */
.video-card {
  background: white;
  border-radius: 20px;
  box-shadow: var(--card-shadow);
  overflow: hidden;
  transition: var(--transition-smooth);
}

.video-card:hover {
  box-shadow: var(--card-shadow-hover);
}

.video-controls {
  display: flex;
  align-items: center;
  gap: 16px;
}

.video-quality {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 6px 16px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.5px;
}

.video-container {
  padding: 24px;
  background: #000;
  border-radius: 16px;
  margin: 24px;
  overflow: hidden;
}

.video-wrapper {
  position: relative;
  border-radius: 12px;
  overflow: hidden;
  aspect-ratio: 16 / 9;
}

.video-player {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 12px;
}

.video-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  animation: fadeIn 0.3s ease;
}

.overlay-icon {
  font-size: 60px;
  color: white;
  opacity: 0.8;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.video-placeholder {
  aspect-ratio: 16 / 9;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 20px;
  color: #999;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);
  border-radius: 12px;
  border: 2px dashed rgba(102, 126, 234, 0.2);
}

.placeholder-icon {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 40px;
  color: #667eea;
}

.placeholder-hint {
  font-size: 14px;
  opacity: 0.7;
  margin-top: 8px;
}

/* 信息卡片网格 */
.info-cards-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 30px;
}

@media (max-width: 768px) {
  .info-cards-grid {
    grid-template-columns: 1fr;
  }
}

.info-card {
  background: white;
  border-radius: 20px;
  box-shadow: var(--card-shadow);
  transition: var(--transition-smooth);
  overflow: hidden;
}

.info-card:hover {
  box-shadow: var(--card-shadow-hover);
  transform: translateY(-4px);
}

.info-content {
  padding: 24px;
}

.info-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
}

.info-item:last-child {
  border-bottom: none;
}

.info-label {
  font-size: 14px;
  color: #666;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 8px;
}

.info-value {
  font-size: 14px;
  color: #1a1a1a;
  font-weight: 600;
}

/* 进度条样式 */
.progress-item {
  margin-bottom: 24px;
}

.progress-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.progress-label {
  font-size: 14px;
  color: #666;
  font-weight: 500;
}

.progress-percentage {
  font-size: 16px;
  font-weight: 700;
  color: #667eea;
}

.progress-stats {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-top: 24px;
  padding-top: 24px;
  border-top: 1px solid rgba(0, 0, 0, 0.08);
}

.stat-item {
  text-align: center;
}

.stat-value {
  display: block;
  font-size: 28px;
  font-weight: 800;
  color: #667eea;
  margin-bottom: 4px;
}

.stat-label {
  display: block;
  font-size: 12px;
  color: #999;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

/* 学习建议卡片 */
.suggestion-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 20px;
  box-shadow: var(--card-shadow);
  transition: var(--transition-smooth);
  color: white;
}

.suggestion-card:hover {
  box-shadow: 0 20px 40px rgba(102, 126, 234, 0.3);
}

.suggestion-content {
  padding: 24px;
}

.suggestion-intro {
  margin: 0 0 20px 0;
  font-size: 16px;
  font-weight: 500;
  opacity: 0.95;
}

.suggestion-list {
  margin: 0;
  padding: 0;
  list-style: none;
}

.suggestion-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  margin-bottom: 12px;
  font-size: 14px;
  line-height: 1.6;
  opacity: 0.9;
}

.suggestion-item:last-child {
  margin-bottom: 0;
}

.tip-icon {
  margin-top: 2px;
  color: #43e97b;
  flex-shrink: 0;
}

/* 空状态 */
.empty-state {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 400px;
  background: white;
  border-radius: 20px;
  box-shadow: var(--card-shadow);
  margin-top: 40px;
}

.empty-content {
  text-align: center;
  padding: 40px;
}

.empty-icon {
  width: 120px;
  height: 120px;
  margin: 0 auto 24px;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 60px;
  color: #667eea;
}

.empty-title {
  font-size: 24px;
  font-weight: 700;
  color: #1a1a1a;
  margin: 0 0 12px 0;
}

.empty-desc {
  font-size: 16px;
  color: #666;
  margin: 0;
  opacity: 0.8;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .banner-title {
    font-size: 36px;
  }

  .banner-subtitle {
    font-size: 16px;
  }

  .page-wrapper {
    margin: -40px auto 40px;
    padding: 0 16px;
  }

  .courses-section {
    padding: 20px;
  }

  .section-header {
    flex-direction: column;
    gap: 16px;
  }

  .header-content {
    flex-direction: column;
    text-align: center;
    gap: 12px;
  }

  .header-icon {
    font-size: 32px;
  }

  .section-title {
    font-size: 24px;
  }

  .course-card-horizontal {
    width: 200px;
  }

  .video-container {
    margin: 16px;
    padding: 16px;
  }

  .info-cards-grid {
    gap: 20px;
  }
}

@media (max-width: 480px) {
  .banner-section {
    padding: 40px 16px 80px;
  }

  .course-card-horizontal {
    width: 180px;
  }

  .course-icon-large {
    width: 60px;
    height: 60px;
    font-size: 28px;
  }

  .video-quality {
    font-size: 11px;
    padding: 4px 12px;
  }
}

/* Element Plus 组件样式覆盖 */
:deep(.el-card) {
  border: none;
  border-radius: 20px;
}

:deep(.el-card__header) {
  border: none;
  padding: 24px 24px 0;
  background: transparent;
}

:deep(.el-progress__text) {
  font-size: 14px !important;
}

:deep(.el-rate) {
  --el-rate-font-size: 16px;
}

:deep(.el-button) {
  transition: var(--transition-smooth);
}

:deep(.el-button--text) {
  color: #667eea;
}

:deep(.el-button--text:hover) {
  color: #764ba2;
  background: rgba(102, 126, 234, 0.1);
}

:deep(.el-tag) {
  border-radius: 12px;
  font-weight: 600;
  letter-spacing: 0.3px;
}

:deep(.el-progress-bar__outer) {
  border-radius: 10px;
  overflow: hidden;
}

:deep(.el-progress-bar__inner) {
  border-radius: 10px;
  transition: width 0.6s ease;
}
</style>
