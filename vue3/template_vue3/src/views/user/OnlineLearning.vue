<template>
  <div class="learning-container">
    <div class="banner-section">
      <div class="banner-content">
        <h1 class="banner-title">在线学习</h1>
        <p class="banner-subtitle">深化理论学习，筑牢思想基础</p>
      </div>
    </div>

    <div class="page-wrapper">
      <div class="courses-section">
        <div class="section-header">
          <h2 class="section-title">
            <span class="title-icon">📚</span>
            选择课程
          </h2>
          <p class="section-desc">选择您感兴趣的课程开始学习</p>
        </div>

        <div class="courses-scroll-container">
          <div
              class="course-card-horizontal"
              v-for="course in courses"
              :key="course.coursename"
              :class="{ active: selectedCourse === course.coursename }"
              @click="selectCourse(course.coursename)"
          >
            <div class="course-card-inner">
              <div class="course-card-top">
                <div class="course-icon-large">
                  <i :class="getCourseIcon(course.coursename)"></i>
                </div>
              </div>
              <div class="course-card-bottom">
                <h3 class="course-name-vertical">{{ course.coursename }}</h3>
                <p class="course-count-vertical">{{ getSectionCount(course.coursename) }} 节课</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div v-if="selectedCourse" class="learning-content">
        <el-row :gutter="24" class="content-row">
          <el-col :xs="24" :md="18" class="sections-panel">
            <el-card shadow="always" class="sections-card">
              <template #header>
                <div class="card-header">
                  <span class="header-title">章节列表</span>
                  <el-tag type="info" effect="light">{{ sections.length }} 章</el-tag>
                </div>
              </template>

              <div class="sections-directory">
                <div
                    v-for="(section, index) in sections"
                    :key="section.id"
                    class="section-entry"
                    :class="{ active: activeSection === section.id }"
                    @click="selectSection(section)"
                >
                  <div class="section-number">{{ index + 1 }}</div>
                  <div class="section-text">
                    <div class="section-label">第 {{ index + 1 }} 章</div>
                    <div class="section-title">{{ section.name }}</div>
                  </div>
                  <div class="section-indicator">
                    <i v-if="activeSection === section.id" class="el-icon-video-play"></i>
                  </div>
                </div>
              </div>
            </el-card>
          </el-col>
          <el-col :xs="24" :md="18">
            <el-card shadow="always" class="video-card mb-6">
              <template #header>
                <div class="card-header">
                  <span class="header-title">视频播放</span>
                  <span class="video-quality">HD 1080P</span>
                </div>
              </template>

              <div class="video-container">
                <video
                    v-if="currentVideo"
                    controls
                    class="video-player"
                    :src="currentVideo"
                    @error="handleVideoError"
                    autoplay
                >
                  您的浏览器不支持视频播放。
                </video>
                <div v-else class="video-placeholder">
                  <i class="el-icon-video-play"></i>
                  <p>请选择一节课程开始学习</p>
                </div>
              </div>
            </el-card>
            <el-row v-if="currentSection" :gutter="24" class="info-row">
              <el-col :xs="24" :md="12">
                <el-card shadow="hover" class="info-card">
                  <template #header>
                    <div class="card-header">
                      <span class="header-title">课程信息</span>
                    </div>
                  </template>
                  <div class="info-content">
                    <div class="info-item">
                      <span class="info-label">课程名称</span>
                      <span class="info-value">{{ selectedCourse }}</span>
                    </div>
                    <div class="info-item">
                      <span class="info-label">章节</span>
                      <span class="info-value">{{ currentSection.name }}</span>
                    </div>
                    <div class="info-item">
                      <span class="info-label">类型</span>
                      <el-tag type="primary" effect="light">视频课程</el-tag>
                    </div>
                    <div class="info-item">
                      <span class="info-label">难度</span>
                      <el-rate v-model="difficultyScore" disabled></el-rate>
                    </div>
                  </div>
                </el-card>
              </el-col>

              <el-col :xs="24" :md="12">
                <el-card shadow="hover" class="info-card">
                  <template #header>
                    <div class="card-header">
                      <span class="header-title">学习进度</span>
                    </div>
                  </template>
                  <div class="info-content">
                    <div class="progress-item">
                      <span class="progress-label">整体进度</span>
                      <el-progress :percentage="overallProgress" color="#409EFF"></el-progress>
                    </div>
                    <div class="progress-item">
                      <span class="progress-label">当前章节</span>
                      <div class="progress-display">
                        {{ (currentProgress * 1).toFixed(1) }}%
                      </div>
                    </div>
                    <div class="progress-stats">
                      <div class="stat">
                        <span class="stat-number">{{ completedSections }}</span>
                        <span class="stat-label">已完成</span>
                      </div>
                      <div class="stat">
                        <span class="stat-number">{{ sections.length }}</span>
                        <span class="stat-label">总节数</span>
                      </div>
                    </div>
                  </div>
                </el-card>
              </el-col>
            </el-row>

            <el-card shadow="hover" class="suggestion-card mt-6">
              <template #header>
                <div class="card-header">
                  <span class="header-title">💡 学习建议</span>
                </div>
              </template>
              <div class="suggestion-content">
                <p>为了获得最好的学习效果，我们建议：</p>
                <ul class="suggestion-list">
                  <li>每次集中学习 45-60 分钟，避免过度疲劳</li>
                  <li>边看视频边做笔记，加深理解和印象</li>
                  <li>完成每章节后进行自我检测和总结</li>
                  <li>遇到疑难问题可查阅相关参考资料或提问</li>
                  <li>定期复习已学内容，巩固学习效果</li>
                </ul>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>

      <div v-else class="empty-state">
        <el-empty description="请选择课程开始学习"></el-empty>
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

    const courseSections = {
      '马克思主义基本原理': [
        { id: '1', name: '第一节：历史唯物主义基础', video: '/api/online-course/video/31.mp4' },
        { id: '2', name: '第二节：物质与意识', video: '/api/online-course/video/32.mp4' },
        { id: '3', name: '第三节：社会发展规律', video: '/api/online-course/video/33.mp4' },
      ],
      '中国近现代史纲要': [
        { id: '1', name: '第一节：鸦片战争', video: '/api/online-course/video/21.mp4' },
        { id: '2', name: '第二节：辛亥革命', video: '/api/online-course/video/22.mp4' },
        { id: '3', name: '第三节：新中国成立', video: '/api/online-course/video/23.mp4' },
      ],
    };

    const overallProgress = computed(() => {
      return sections.value.length > 0
          ? Math.round((completedSections.value / sections.value.length) * 100)
          : 0;
    });

    const currentProgress = computed(() => {
      const currentIndex = sections.value.findIndex(s => s.id === activeSection.value);
      return currentIndex >= 0 ? ((currentIndex + 1) / sections.value.length) * 100 : 0;
    });

    const getCourseIcon = (coursename) => {
      const icons = {
        '马克思主义基本原理': 'el-icon-s-promotion',
        '中国近现代史纲要': 'el-icon-s-management',
      };
      return icons[coursename] || 'el-icon-s-open';
    };

    const getSectionCount = (coursename) => {
      return courseSections[coursename]?.length || 0;
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
        ElMessage.warning('无法连接服务器，使用本地课程数据: ' + error.message);
        console.error('Fetch courses error:', error);
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

        if (sections.value.length === 0) {
          ElMessage.error('未找到该课程的节数');
        }
      } catch (error) {
        ElMessage.error('更新访问量失败: ' + error.message);
        console.error('Increment visit error:', error);
      }
    };

    const selectSection = (section) => {
      activeSection.value = section.id;
      currentVideo.value = section.video;
      currentSection.value = section;
      completedSections.value = Math.min(completedSections.value + 1, sections.value.length);
      console.log('Selected video:', currentVideo.value);
    };

    const handleVideoError = (event) => {
      ElMessage.error('视频加载失败，请检查网络或文件路径');
      console.error('Video load error:', event);
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
      currentProgress,
      completedSections,
      difficultyScore,
      getCourseIcon,
      getSectionCount,
      selectCourse,
      selectSection,
      handleVideoError,
    };
  },
};
</script>

<style scoped>
:root {
  --primary-color: #e91e63;
  --primary-light: #f8bbd9;
  --primary-dark: #880e4f;
  --gradient-primary: linear-gradient(135deg, #f8bbd9 0%, #e91e63 100%);
  --gradient-banner: linear-gradient(135deg, #4a148c 0%, #880e4f 50%, #d81b60 100%);
  --gradient-background: linear-gradient(135deg, #f3e5f5 0%, #ede7f6 50%, #fce4ec 100%);
  --color-blue: #3f51b5;
  --color-purple: #9c27b0;
  --color-red: #e91e63;
}

* {
  box-sizing: border-box;
}

.learning-container {
  min-height: 100vh;
  background: #ffffff;
}

.banner-section {
  background: linear-gradient(135deg, #455a64 0%, #546e7a 50%, #78909c 100%);
  color: white;
  padding: 40px 20px;
  text-align: center;
  margin-bottom: 40px;
}

.banner-content {
  max-width: 1200px;
  margin: 0 auto;
}

.banner-title {
  font-size: 42px;
  font-weight: 700;
  margin: 0 0 12px 0;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.banner-subtitle {
  font-size: 16px;
  opacity: 0.9;
  margin: 0;
}

.page-wrapper {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 20px 40px;
}
.courses-section {
  margin-bottom: 50px;
}

.section-header {
  margin-bottom: 30px;
}

.section-title {
  font-size: 28px;
  font-weight: 700;
  color: #333;
  margin: 0 0 12px 0;
  display: flex;
  align-items: center;
  gap: 12px;
}

.title-icon {
  font-size: 32px;
}

.section-desc {
  color: #666;
  margin: 0;
  font-size: 14px;
}

.courses-scroll-container {
  display: flex;
  gap: 24px;
  overflow-x: auto;
  padding: 12px 0;
  scroll-behavior: smooth;
  -webkit-overflow-scrolling: touch;
}

.courses-scroll-container::-webkit-scrollbar {
  height: 6px;
}

.courses-scroll-container::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 10px;
}

.courses-scroll-container::-webkit-scrollbar-thumb {
  background: #667eea;
  border-radius: 10px;
}

.courses-scroll-container::-webkit-scrollbar-thumb:hover {
  background: #764ba2;
}

.course-card-horizontal {
  flex: 0 0 auto;
  width: 160px;
  background: white;
  border-radius: 12px;
  border: 2px solid #e8ecf1;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  display: flex;
  flex-direction: column;
}

.course-card-horizontal:hover {
  border-color: #0097a7;
  box-shadow: 0 8px 24px rgba(0, 188, 212, 0.15);
  transform: translateY(-4px);
}

.course-card-horizontal.active {
  border-color: #0097a7;
  background: linear-gradient(135deg, #b3e5fc 0%, #81d4fa 100%);
  box-shadow: 0 8px 24px rgba(0, 188, 212, 0.2);
}

.course-card-inner {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.course-card-top {
  background: linear-gradient(135deg, #b3e5fc 0%, #81d4fa 100%);
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px 16px;
  min-height: 120px;
}

.course-icon-large {
  width: 56px;
  height: 56px;
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
  color: white;
}

.course-card-bottom {
  padding: 16px 12px;
  text-align: center;
  flex: 0 0 auto;
}

.course-name-vertical {
  font-size: 14px;
  font-weight: 700;
  color: #333;
  margin: 0 0 8px 0;
  line-height: 1.3;
  word-break: break-word;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.course-count-vertical {
  font-size: 12px;
  color: #999;
  margin: 0;
}

.learning-content {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.content-row {
  display: grid;
  grid-template-columns: 280px 1fr;
  gap: 24px;
}

@media (max-width: 768px) {
  .content-row {
    grid-template-columns: 1fr;
  }
}

.sections-panel {
  position: sticky;
  top: 20px;
  max-height: calc(100vh - 40px);
  overflow-y: auto;
}

.sections-card {
  border-radius: 8px;
  overflow: hidden;
}

.sections-directory {
  display: flex;
  flex-direction: column;
  gap: 0;
}
.section-entry {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  cursor: pointer;
  transition: all 0.2s ease;
  border-left: 3px solid transparent;
  position: relative;
}

.section-entry:hover {
  background: #f5f7fa;
}

.section-entry.active {
  background: linear-gradient(135deg, #b3e5fc 0%, #e1f5fe 100%);
  border-left-color: #0097a7;
}

.section-number {
  font-size: 12px;
  font-weight: 700;
  color: #0097a7;
  min-width: 32px;
  text-align: center;
}

.section-text {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.section-label {
  font-size: 11px;
  color: #999;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.section-title {
  font-size: 13px;
  font-weight: 500;
  color: #333;
  word-wrap: break-word;
  white-space: normal;
  line-height: 1.3;
}

.section-entry.active .section-title {
  color: #0097a7;
  font-weight: 600;
}

.section-indicator {
  font-size: 14px;
  color: #0097a7;
  opacity: 0;
  transition: opacity 0.2s ease;
}

.section-entry.active .section-indicator {
  opacity: 1;
}

.video-card {
  margin-bottom: 24px;
  border-radius: 8px;
  overflow: hidden;
}

.video-container {
  background: #000;
  border-radius: 6px;
  overflow: hidden;
  aspect-ratio: 16 / 9;
}

.video-player {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.video-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 16px;
  color: #999;
}

.video-placeholder i {
  font-size: 48px;
  opacity: 0.5;
}

.video-quality {
  background: linear-gradient(135deg, #b3e5fc 0%, #81d4fa 100%);
  color: white;
  padding: 4px 12px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 600;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
}

.header-title {
  font-size: 16px;
  font-weight: 600;
  color: #333;
}

.info-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
  margin-top: 24px;
}

@media (max-width: 992px) {
  .info-row {
    grid-template-columns: 1fr;
  }
}

.info-card {
  border-radius: 8px;
  overflow: hidden;
}

.info-content {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.info-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
}

.info-item:last-child {
  border-bottom: none;
  padding-bottom: 0;
}

.info-label {
  font-size: 14px;
  color: #666;
  font-weight: 500;
}

.info-value {
  font-size: 14px;
  color: #333;
  font-weight: 600;
}

.progress-item {
  margin-bottom: 16px;
}

.progress-item:last-child {
  margin-bottom: 0;
}

.progress-label {
  display: block;
  font-size: 14px;
  color: #666;
  font-weight: 500;
  margin-bottom: 8px;
}

.progress-display {
  font-size: 16px;
  font-weight: 600;
  color: #0097a7;
  padding: 8px 0;
}

.progress-stats {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid #f0f0f0;
}

.stat {
  text-align: center;
}

.stat-number {
  display: block;
  font-size: 24px;
  font-weight: 700;
  color: #0097a7;
  margin-bottom: 4px;
}

.stat-label {
  display: block;
  font-size: 12px;
  color: #999;
}

.suggestion-card {
  border-radius: 8px;
  overflow: hidden;
  background: linear-gradient(135deg, #f3e5f5 0%, #fce4ec 100%);
  border: 1px solid #f8bbd9;
}

.suggestion-content {
  color: #666;
  line-height: 1.8;
}

.suggestion-content p {
  margin: 0 0 12px 0;
  color: #333;
  font-weight: 500;
}

.suggestion-list {
  margin: 12px 0 0 0;
  padding-left: 20px;
}

.suggestion-list li {
  margin-bottom: 8px;
  color: #666;
  font-size: 14px;
}
.empty-state {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 400px;
  background: white;
  border-radius: 8px;
  margin-top: 40px;
}

.mb-6 {
  margin-bottom: 24px;
}

.mt-6 {
  margin-top: 24px;
}
@media (max-width: 768px) {
  .banner-title {
    font-size: 28px;
  }

  .banner-subtitle {
    font-size: 14px;
  }

  .section-title {
    font-size: 22px;
  }

  .courses-scroll-container {
    gap: 16px;
  }

  .course-card-horizontal {
    width: 140px;
  }

  .course-card-top {
    min-height: 100px;
    padding: 16px 12px;
  }

  .course-icon-large {
    width: 48px;
    height: 48px;
    font-size: 24px;
  }

  .course-name-vertical {
    font-size: 12px;
  }

  .course-count-vertical {
    font-size: 11px;
  }

  .sections-panel {
    position: relative;
    top: auto;
    max-height: none;
  }

  .info-row {
    gap: 16px;
  }
}

:deep(.el-card) {
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  border: 1px solid #ebeef5;
}

:deep(.el-card:hover) {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
}

:deep(.el-card__header) {
  background: linear-gradient(135deg, #f3e5f5 0%, #ede7f6 100%);
  padding: 18px 20px;
  border-bottom: 2px solid #f8bbd9;
}

:deep(.el-tag) {
  border-radius: 4px;
}

:deep(.el-progress__bar) {
  transition: width 0.3s ease;
}
</style>