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
          <div class="header-content">
            <h2 class="section-title">选择课程</h2>
            <p class="section-desc">选择您感兴趣的课程开始学习</p>
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
                <div class="course-icon-large" :style="getCardBackground(course.coursename)">
                  <i :class="getCourseIcon(course.coursename)"></i>
                </div>
                <div class="course-badge" v-if="getSectionCount(course.coursename)">
                  {{ getSectionCount(course.coursename) }} 节
                </div>
              </div>
              <div class="course-card-bottom">
                <h3 class="course-name-vertical">{{ course.coursename }}</h3>
                <div class="course-meta">
                  <span class="course-tag" :style="getTagStyle(course.coursename)">
                    {{ getCourseTag(course.coursename) }}
                  </span>
                  <span class="course-level">{{ getCourseLevel(course.coursename) }}</span>
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
                  </div>
                  <div class="section-text">
                    <div class="section-label">第 {{ index + 1 }} 章</div>
                    <div class="section-title-text">{{ section.name }}</div>
                  </div>
                  <div class="section-duration">
                    <i class="el-icon-time"></i>
                    <span>15min</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="content-main">
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
                    <span class="info-label"><i class="el-icon-notebook-2"></i> 课程名称</span>
                    <span class="info-value">{{ selectedCourse }}</span>
                  </div>
                  <div class="info-item">
                    <span class="info-label"><i class="el-icon-document"></i> 当前章节</span>
                    <span class="info-value">{{ currentSection?.name || '未选择' }}</span>
                  </div>
                  <div class="info-item">
                    <span class="info-label"><i class="el-icon-tickets"></i> 课程类型</span>
                    <el-tag type="primary" effect="light" size="small">视频课程</el-tag>
                  </div>
                  <div class="info-item">
                    <span class="info-label"><i class="el-icon-star-off"></i> 课程难度</span>
                    <el-rate v-model="difficultyScore" disabled show-score score-template="{value} 星" />
                  </div>
                </div>
              </div>

              <div class="info-card progress-info">
                <div class="card-header-wrapper">
                  <div class="card-header">
                    <span class="header-title">📊 学习进度</span>
                    <el-button type="text" size="small" @click="resetProgress">重置</el-button>
                  </div>
                </div>
                <div class="info-content">
                  <div class="progress-item">
                    <div class="progress-header">
                      <span class="progress-label">整体进度</span>
                      <span class="progress-percentage">{{ overallProgress }}%</span>
                    </div>
                    <el-progress :percentage="overallProgress" :color="customColors" :show-text="false" stroke-width="8" />
                  </div>
                  <div class="progress-item">
                    <div class="progress-header">
                      <span class="progress-label">当前章节</span>
                      <span class="progress-percentage">{{ currentSectionProgress }}%</span>
                    </div>
                    <el-progress :percentage="currentSectionProgress" color="#8a9e7a" :show-text="false" stroke-width="6" />
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

            <div class="suggestion-card">
              <div class="card-header-wrapper">
                <div class="card-header">
                  <span class="header-title">💡 学习建议</span>
                  <el-button type="text" size="small" @click="showMoreTips">更多建议</el-button>
                </div>
              </div>
              <div class="suggestion-content">
                <ul class="suggestion-list">
                  <li v-for="(tip, index) in learningTips" :key="index" class="suggestion-item">
                    <span class="tip-dot"></span>{{ tip }}
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
          <p class="empty-desc">从上方课程列表中选择一门课程开始您的学习之旅</p>
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

    const learningTips = [
      '每次集中学习45-60分钟，避免过度疲劳',
      '边看视频边做笔记，加深理解和印象',
      '完成每章节后进行自我检测和总结',
      '遇到疑难问题可查阅相关参考资料',
      '定期复习已学内容，巩固学习效果'
    ];

    const courseSections = {
      '思想道德与法治': [
        { id: '1', name: '导论：青年成长与法治中国', video: '/api/online-course/video/11.mp4' },
        { id: '2', name: '理想信念与人生价值', video: '/api/online-course/video/12.mp4' },
        { id: '3', name: '道德规范与社会公德', video: '/api/online-course/video/13.mp4' },
        { id: '4', name: '法治思维与法律实践', video: '/api/online-course/video/14.mp4' },
      ],
      '中国近现代史纲要': [
        { id: '1', name: '晚清变局与民族危机', video: '/api/online-course/video/21.mp4' },
        { id: '2', name: '辛亥革命与民国建立', video: '/api/online-course/video/22.mp4' },
        { id: '3', name: '新中国成立与建设', video: '/api/online-course/video/23.mp4' },
        { id: '4', name: '改革开放与现代化', video: '/api/online-course/video/24.mp4' },
      ],
      '形势与政策': [
        { id: '1', name: '时政热点导读', video: '/api/online-course/video/31.mp4' },
        { id: '2', name: '国家发展观察', video: '/api/online-course/video/32.mp4' },
        { id: '3', name: '青年责任担当', video: '/api/online-course/video/33.mp4' },
        { id: '4', name: '国际形势分析', video: '/api/online-course/video/34.mp4' },
      ],
      '马克思主义基本原理': [
        { id: '1', name: '世界的物质性', video: '/api/online-course/video/41.mp4' },
        { id: '2', name: '实践与认识', video: '/api/online-course/video/42.mp4' },
        { id: '3', name: '社会历史发展', video: '/api/online-course/video/43.mp4' },
        { id: '4', name: '历史唯物主义基础', video: '/api/online-course/video/44.mp4' },
      ],
      '毛泽东思想和中国特色社会主义理论体系概论': [
        { id: '1', name: '理论体系形成发展', video: '/api/online-course/video/51.mp4' },
        { id: '2', name: '毛泽东思想核心内容', video: '/api/online-course/video/52.mp4' },
        { id: '3', name: '社会主义建设道路探索', video: '/api/online-course/video/53.mp4' },
        { id: '4', name: '改革开放理论创新', video: '/api/online-course/video/54.mp4' },
      ],
      '习近平新时代中国特色社会主义思想概论': [
        { id: '1', name: '新时代十年的伟大变革', video: '/api/online-course/video/61.mp4' },
        { id: '2', name: '以人民为中心的发展思想', video: '/api/online-course/video/62.mp4' },
        { id: '3', name: '社会主义现代化建设', video: '/api/online-course/video/63.mp4' },
        { id: '4', name: '人类命运共同体构建', video: '/api/online-course/video/64.mp4' },
      ],
      '国家安全教育': [
        { id: '1', name: '总体国家安全观', video: '/api/online-course/video/71.mp4' },
        { id: '2', name: '网络与数据安全', video: '/api/online-course/video/72.mp4' },
        { id: '3', name: '校园安全教育', video: '/api/online-course/video/73.mp4' },
        { id: '4', name: '应急防范能力提升', video: '/api/online-course/video/74.mp4' },
      ],
      '工程伦理与科技报国': [
        { id: '1', name: '工程伦理基本框架', video: '/api/online-course/video/81.mp4' },
        { id: '2', name: '科技创新与国家战略', video: '/api/online-course/video/82.mp4' },
        { id: '3', name: '科技报国实践路径', video: '/api/online-course/video/83.mp4' },
        { id: '4', name: '工程实践案例分析', video: '/api/online-course/video/84.mp4' },
      ],
    };

    // Chapter-level custom video override.
    // Put your video file into ONLINE_VIDEO_PATH (default: D:/xjtu/xjtuexer/file/video)
    // and set filename here, e.g. "late-qing-crisis.mp4".
    const chapterVideoOverrides = {
      '中国近现代史纲要': {
        '晚清变局与民族危机': '/api/online-course/video/late-qing-crisis.mp4'
      }
    };

    const overallProgress = computed(() =>
        sections.value.length > 0
            ? Math.round((completedSections.value / sections.value.length) * 100)
            : 0
    );

    const currentSectionProgress = computed(() => {
      if (!videoPlayer.value) return 0;
      const v = videoPlayer.value;
      return v.duration ? Math.round((v.currentTime / v.duration) * 100) : 0;
    });

    const customColors = computed(() => [
      { color: '#b5c4a1', percentage: 40 },
      { color: '#8a9e7a', percentage: 70 },
      { color: '#5c7a4e', percentage: 100 }
    ]);

    const getCourseIcon = (name) => ({
      '思想道德与法治': 'el-icon-s-flag',
      '中国近现代史纲要': 'el-icon-s-management',
      '形势与政策': 'el-icon-s-data',
      '马克思主义基本原理': 'el-icon-s-promotion',
      '毛泽东思想和中国特色社会主义理论体系概论': 'el-icon-s-custom',
      '习近平新时代中国特色社会主义思想概论': 'el-icon-s-opportunity',
      '国家安全教育': 'el-icon-s-home',
      '工程伦理与科技报国': 'el-icon-s-tools',
    }[name] || 'el-icon-s-open');

    const getCardBackground = (name) => {
      const imageMap = {
        '思想道德与法治': {
          url: 'https://img0.baidu.com/it/u=2697821383,2580029367&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=727',
          scale: 1.1,
          position: 'center 30%',
        },
        '中国近现代史纲要': {
          url: 'https://img0.baidu.com/it/u=1138047997,1531768358&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=667',
          scale: 1.1,
          position: 'center 30%',
        },
        '形势与政策': {
          url: 'https://img0.baidu.com/it/u=2422475940,1289613256&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=719',
          scale: 1.3,
          position: 'center 30%',
        },
        '马克思主义基本原理': {
          url: 'https://img2.baidu.com/it/u=3892508350,2077687280&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=679',
          scale: 1.1,
          position: 'center 30%',
        },
        '毛泽东思想和中国特色社会主义理论体系概论': {
          url: 'https://g-search1.alicdn.com/img/bao/uploaded/i4/i2/2208883464425/O1CN01eR5a4b1iYhfziMSD2_!!2208883464425.jpg',
          scale: 1.8,
          position: 'center 30%',
        },
        '习近平新时代中国特色社会主义思想概论': {
          url: 'https://g-search3.alicdn.com/img/bao/uploaded/i4/i2/6000000005344/O1CN01y6NIil1pLbS28OTIt_!!6000000005344-2-remus.png',
          scale: 2.1,
          position: 'center 30%',
        },
        '国家安全教育': {
          url: 'http://img.alicdn.com/img/O1CN01ZxZa0y2EYJ4ViK0VS_!!4611686018427387060-0-item_pic.jpg',
          scale: 1.6,
          position: 'center 30%',
        },
        '工程伦理与科技报国': {
          url: 'https://img2.baidu.com/it/u=2640373742,2790729314&fm=253&fmt=auto&app=138&f=JPEG?w=475&h=671',
          scale: 1.1,
          position: 'center 30%',
        },
      };
      const config = imageMap[name] || {
        url: 'https://img2.baidu.com/it/u=2832391765,747817603&fm=253&fmt=auto&app=138&f=JPEG?w=833&h=500',
        scale: 1.1,
        position: 'center 30%',
      };

      return {
        backgroundImage: `url('${config.url}')`,
        backgroundSize: `${config.scale * 100}%`,
        backgroundPosition: config.position,
        backgroundRepeat: 'no-repeat',
        backgroundBlendMode: 'multiply',
        transition: 'all 0.3s ease'
      };
    };
    const getTagStyle = (name) => ({
      '思想道德与法治': { background: 'rgba(107,135,168,0.1)', color: '#6b87a8' },
      '中国近现代史纲要': { background: 'rgba(168,120,104,0.1)', color: '#a87868' },
      '形势与政策': { background: 'rgba(136,168,104,0.1)', color: '#88a868' },
      '马克思主义基本原理': { background: 'rgba(168,104,104,0.1)', color: '#a86868' },
      '毛泽东思想和中国特色社会主义理论体系概论': { background: 'rgba(104,168,168,0.1)', color: '#68a8a8' },
      '习近平新时代中国特色社会主义思想概论': { background: 'rgba(168,168,104,0.1)', color: '#a8a868' },
      '国家安全教育': { background: 'rgba(136,104,168,0.1)', color: '#8868a8' },
      '工程伦理与科技报国': { background: 'rgba(107,135,168,0.1)', color: '#6b87a8' },
    }[name] || { background: 'rgba(122,144,128,0.1)', color: '#7a9080' });

    const getCourseTag = (name) => ({
      '思想道德与法治': '法治教育',
      '中国近现代史纲要': '历史理论',
      '形势与政策': '时事政治',
      '马克思主义基本原理': '基础理论',
      '毛泽东思想和中国特色社会主义理论体系概论': '理论体系',
      '习近平新时代中国特色社会主义思想概论': '最新理论',
      '国家安全教育': '安全教育',
      '工程伦理与科技报国': '科技伦理',
    }[name] || '理论学习');

    const getCourseLevel = (name) => ({
      '思想道德与法治': '初级',
      '中国近现代史纲要': '初级',
      '形势与政策': '初级',
      '马克思主义基本原理': '中级',
      '毛泽东思想和中国特色社会主义理论体系概论': '中级',
      '习近平新时代中国特色社会主义思想概论': '中级',
      '国家安全教育': '初级',
      '工程伦理与科技报国': '高级',
    }[name] || '初级');

    const getSectionCount = (name) => courseSections[name]?.length || 0;
    const isSectionCompleted = (id) => completedSectionsList.value.has(id);

    const fetchCourses = async () => {
      try {
        const res = await axios.get('http://localhost:8080/api/online-course/courses');
        courses.value = res.data.code === 0 && res.data.data.length > 0
            ? res.data.data
            : [
              { coursename: '思想道德与法治' },
              { coursename: '中国近现代史纲要' },
              { coursename: '形势与政策' },
              { coursename: '马克思主义基本原理' },
              { coursename: '毛泽东思想和中国特色社会主义理论体系概论' },
              { coursename: '习近平新时代中国特色社会主义思想概论' },
              { coursename: '国家安全教育' },
              { coursename: '工程伦理与科技报国' },
            ];
      } catch {
        courses.value = [
          { coursename: '思想道德与法治' },
          { coursename: '中国近现代史纲要' },
          { coursename: '形势与政策' },
          { coursename: '马克思主义基本原理' },
          { coursename: '毛泽东思想和中国特色社会主义理论体系概论' },
          { coursename: '习近平新时代中国特色社会主义思想概论' },
          { coursename: '国家安全教育' },
          { coursename: '工程伦理与科技报国' },
        ];
      }
    };

    const selectCourse = async (name) => {
      try {
        await axios.post('http://localhost:8080/api/online-course/increment-visit', null, {
          params: { coursename: name }
        });
      } catch (error) {
        console.error('记录访问量失败:', error);
      }
      selectedCourse.value = name;
      const overrideMap = chapterVideoOverrides[name] || {};
      sections.value = (courseSections[name] || []).map((section) => ({
        ...section,
        video: overrideMap[section.name] || section.video
      }));
      activeSection.value = '';
      currentVideo.value = '';
      currentSection.value = null;
      completedSections.value = 0;
      completedSectionsList.value.clear();
      ElMessage.success(`已选择《${name}》课程`);
    };

    const selectSection = (section) => {
      activeSection.value = section.id;
      currentVideo.value = section.video;
      currentSection.value = section;
    };

    const togglePlaybackSpeed = () => {
      const speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
      const i = speeds.indexOf(playbackSpeed.value);
      playbackSpeed.value = speeds[(i + 1) % speeds.length];
      if (videoPlayer.value) videoPlayer.value.playbackRate = playbackSpeed.value;
      ElMessage.info(`播放速度 ${playbackSpeed.value}x`);
    };

    const handleVideoError = () => ElMessage.error('视频加载失败');

    const handleVideoProgress = () => {
      const v = videoPlayer.value;
      if (v && v.currentTime / v.duration > 0.9 && !isSectionCompleted(activeSection.value)) {
        completedSectionsList.value.add(activeSection.value);
        completedSections.value = completedSectionsList.value.size;
        if (!v.progressUpdated) {
          ElMessage.success('恭喜完成本章节学习！');
          v.progressUpdated = true;
        }
      }
    };

    const resetProgress = () => {
      completedSectionsList.value.clear();
      completedSections.value = 0;
      ElMessage.success('学习进度已重置');
    };

    const showMoreTips = () => ElMessage.info('更多学习建议功能开发中...');

    onMounted(fetchCourses);

    return {
      courses, selectedCourse, sections, activeSection, currentVideo, currentSection,
      overallProgress, currentSectionProgress, completedSections, difficultyScore,
      playbackSpeed, studyTime, learningTips, videoPlayer, customColors,
      getCourseIcon,   getCardBackground, getTagStyle, getCourseTag, getCourseLevel,
      getSectionCount, isSectionCompleted, selectCourse, selectSection, togglePlaybackSpeed,
      handleVideoError, handleVideoProgress, resetProgress, showMoreTips,
    };
  },
};
</script>

<style scoped>
:root {
  --c-ink:      #2d2d2d;
  --c-muted:    #6b7280;
  --c-line:     #e8eaed;
  --c-bg:       #f7f8f6;
  --c-surface:  #ffffff;
  --c-accent:   #6b87a8;
  --c-accent2:  #8a9e7a;
  --c-warm:     #a87868;
  --shadow-sm:  0 2px 8px rgba(0,0,0,0.06);
  --shadow-md:  0 6px 24px rgba(0,0,0,0.08);
  --radius:     14px;
  --transition: all 0.25s ease;
}

* { box-sizing: border-box; }

.learning-container {
  min-height: 100vh;
  background: var(--c-bg);
  font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
  color: var(--c-ink);
}

.banner-section {
  background-image: url('https://img2.baidu.com/it/u=2832391765,747817603&fm=253&fmt=auto&app=138&f=JPEG?w=833&h=500');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  border-bottom: 1px solid rgba(139, 195, 74, 0.2);
  padding: 20px 20px;
  text-align: center;
  position: relative;
  overflow: hidden;
  min-height: 50px;
}

.banner-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background:
      radial-gradient(circle at 20% 80%, rgba(139, 195, 74, 0.1) 0%, transparent 50%),
      radial-gradient(circle at 80% 20%, rgba(76, 175, 80, 0.1) 0%, transparent 50%);
  z-index: 0;
}

.banner-content {
  max-width: 1400px;
  margin: 0 auto;
  position: relative;
  z-index: 1;
}

.banner-title {
  font-size: 32px;
  font-weight: 700;
  margin: 0 0 12px;
  color: #f1eded;
  letter-spacing: 1px;
  text-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.banner-subtitle {
  font-size: 16px;
  color: #f1eded;
  margin: 0;
  font-weight: 500;
  letter-spacing: 0.5px;
}

.page-wrapper {
  max-width: 1400px;
  margin: 0 auto;
  padding: 32px 40px 60px;
}

.courses-section {
  background: var(--c-surface);
  border-radius: var(--radius);
  padding: 28px 28px 20px;
  margin-bottom: 32px;
  box-shadow: var(--shadow-sm);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 24px;
}

.section-title {
  font-size: 17px;
  font-weight: 600;
  color: var(--c-ink);
  margin: 0 0 4px;
}

.section-desc {
  font-size: 13px;
  color: var(--c-muted);
  margin: 0;
}

.progress-indicator {
  background: #f0f4f0;
  padding: 6px 14px;
  border-radius: 20px;
}

.progress-text {
  font-size: 13px;
  color: var(--c-accent2);
  font-weight: 500;
}

.courses-scroll-container {
  display: flex;
  gap: 20px;
  overflow-x: auto;
  padding-bottom: 8px;
  scroll-behavior: smooth;
  -webkit-overflow-scrolling: touch;
}

.courses-scroll-container::-webkit-scrollbar { height: 4px; }
.courses-scroll-container::-webkit-scrollbar-track { background: #f0f0f0; border-radius: 4px; }
.courses-scroll-container::-webkit-scrollbar-thumb { background: #d0d5d0; border-radius: 4px; }

.course-card-horizontal {
  flex: 0 0 auto;
  width: 220px;
  background: var(--c-surface);
  border-radius: var(--radius);
  border: 1.5px solid var(--c-line);
  cursor: pointer;
  transition: var(--transition);
  overflow: hidden;
}

.course-card-horizontal:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-md);
  border-color: #cdd5dc;
}

.course-card-horizontal.active {
  border-color: var(--c-accent);
  box-shadow: 0 4px 16px rgba(107,135,168,0.18);
}

.course-card-top {
  padding: 28px 20px;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;

}

.course-icon-large {
  width: 100px;
  height: 150px;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
  color: white;
  transition: var(--transition);
}

.course-card-horizontal:hover .course-icon-large {
  transform: scale(1.06);
}

.course-badge {
  position: absolute;
  top: 12px;
  right: 12px;
  background: white;
  color: var(--c-muted);
  padding: 3px 10px;
  border-radius: 10px;
  font-size: 11px;
  font-weight: 600;
  border: 1px solid var(--c-line);
}

.course-card-bottom {
  padding: 16px 18px 20px;
  border-top: 1px solid var(--c-line);
}

.course-name-vertical {
  font-size: 15px;
  font-weight: 600;
  color: var(--c-ink);
  margin: 0 0 10px;
  line-height: 1.4;
  height: 42px;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.course-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.course-tag {
  font-size: 11px;
  font-weight: 600;
  padding: 3px 10px;
  border-radius: 10px;
}

.course-level {
  font-size: 12px;
  color: var(--c-muted);
}

/* ── 内容网格 ── */
.learning-content { animation: fadeUp 0.4s ease; }

@keyframes fadeUp {
  from { opacity: 0; transform: translateY(16px); }
  to   { opacity: 1; transform: translateY(0); }
}

.content-grid {
  display: grid;
  grid-template-columns: 300px 1fr;
  gap: 24px;
}

@media (max-width: 1100px) {
  .content-grid { grid-template-columns: 1fr; }
}

/* ── 章节面板 ── */
.sections-panel {
  position: sticky;
  top: 20px;
  max-height: calc(100vh - 120px);
  overflow-y: auto;
}

.sections-card {
  background: var(--c-surface);
  border-radius: var(--radius);
  box-shadow: var(--shadow-sm);
  overflow: hidden;
}

.card-header-wrapper { padding: 20px 20px 0; }

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 16px;
  border-bottom: 1px solid var(--c-line);
}

.header-title {
  font-size: 15px;
  font-weight: 600;
  color: var(--c-ink);
}

.sections-directory { padding: 12px; }

.section-entry {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 10px;
  cursor: pointer;
  border-radius: 10px;
  margin-bottom: 4px;
  transition: var(--transition);
}

.section-entry:hover { background: #f5f6f4; }

.section-entry.active {
  background: #eef2f7;
}

.section-entry.completed .section-indicator {
  background: #d4e8d4;
  color: #4a7c4a;
}

.section-indicator {
  width: 32px;
  height: 32px;
  min-width: 32px;
  border-radius: 8px;
  background: #f0f1f0;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 13px;
  font-weight: 700;
  color: var(--c-muted);
  transition: var(--transition);
}

.section-entry.active .section-indicator {
  background: var(--c-accent);
  color: white;
}

.section-text { flex: 1; min-width: 0; }

.section-label {
  font-size: 11px;
  color: #aaa;
  font-weight: 500;
  margin-bottom: 2px;
}

.section-title-text {
  font-size: 13px;
  font-weight: 500;
  color: var(--c-ink);
  line-height: 1.4;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
}

.section-entry.active .section-title-text { color: var(--c-accent); }

.section-duration {
  display: flex;
  align-items: center;
  gap: 3px;
  font-size: 11px;
  color: #bbb;
  opacity: 0;
  transition: var(--transition);
}

.section-entry:hover .section-duration { opacity: 1; }

/* ── 主内容 ── */
.content-main {
  display: flex;
  flex-direction: column;
  gap: 24px;
}
.video-card {
  background: var(--c-surface);
  border-radius: var(--radius);
  box-shadow: var(--shadow-sm);
  overflow: hidden;
}

.video-controls {
  display: flex;
  align-items: center;
  gap: 12px;
}

.video-quality {
  background: #eef2f7;
  color: var(--c-accent);
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.3px;
}

.video-container {
  padding: 16px 20px 20px;
}

.video-wrapper {
  border-radius: 10px;
  overflow: hidden;
  aspect-ratio: 16/9;
  background: #111;
}

.video-player {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.video-placeholder {
  aspect-ratio: 16/9;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  color: #aaa;
  background: #fafafa;
  border-radius: 10px;
  border: 1.5px dashed #e0e0e0;
  font-size: 14px;
}

.placeholder-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: #f0f1f0;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
  color: #bbb;
}

.placeholder-hint { font-size: 12px; color: #ccc; margin: 0; }
.info-cards-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 24px;
}

@media (max-width: 768px) {
  .info-cards-grid { grid-template-columns: 1fr; }
}

.info-card {
  background: var(--c-surface);
  border-radius: var(--radius);
  box-shadow: var(--shadow-sm);
  transition: var(--transition);
  overflow: hidden;
}

.info-card:hover {
  box-shadow: var(--shadow-md);
  transform: translateY(-2px);
}

.info-content { padding: 16px 20px 20px; }

.info-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #f4f4f4;
  font-size: 13px;
}

.info-item:last-child { border-bottom: none; }

.info-label {
  color: var(--c-muted);
  display: flex;
  align-items: center;
  gap: 6px;
}

.info-value { font-weight: 600; color: var(--c-ink); }

.progress-item { margin-bottom: 20px; }

.progress-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
}

.progress-label { font-size: 13px; color: var(--c-muted); }

.progress-percentage { font-size: 14px; font-weight: 700; color: var(--c-accent); }

.progress-stats {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
  margin-top: 20px;
  padding-top: 16px;
  border-top: 1px solid #f4f4f4;
  text-align: center;
}

.stat-value {
  display: block;
  font-size: 24px;
  font-weight: 700;
  color: var(--c-accent2);
  margin-bottom: 2px;
}

.stat-label {
  display: block;
  font-size: 11px;
  color: #bbb;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

/* 学习建议 */
.suggestion-card {
  background: var(--c-surface);
  border-radius: var(--radius);
  box-shadow: var(--shadow-sm);
  border-left: 3px solid var(--c-accent2);
}

.suggestion-content { padding: 4px 20px 20px; }

.suggestion-list { margin: 0; padding: 0; list-style: none; }

.suggestion-item {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 8px 0;
  font-size: 13px;
  color: var(--c-muted);
  line-height: 1.6;
  border-bottom: 1px solid #f8f8f8;
}

.suggestion-item:last-child { border-bottom: none; }

.tip-dot {
  width: 6px;
  height: 6px;
  min-width: 6px;
  border-radius: 50%;
  background: var(--c-accent2);
  margin-top: 7px;
}

.empty-state {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 320px;
  background: var(--c-surface);
  border-radius: var(--radius);
  box-shadow: var(--shadow-sm);
}

.empty-content { text-align: center; padding: 40px; }

.empty-icon {
  width: 80px;
  height: 80px;
  margin: 0 auto 20px;
  border-radius: 50%;
  background: #f4f5f4;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 36px;
  color: #bbb;
}

.empty-title { font-size: 18px; font-weight: 600; color: var(--c-ink); margin: 0 0 8px; }
.empty-desc  { font-size: 14px; color: var(--c-muted); margin: 0; }

@media (max-width: 768px) {
  .page-wrapper { padding: 20px 16px 40px; }
  .banner-section { padding: 30px 16px; }
  .banner-title { font-size: 24px; }
  .banner-subtitle { font-size: 14px; }
  .courses-section { padding: 20px 16px 16px; }
  .section-header { flex-direction: column; gap: 12px; }
  .course-card-horizontal { width: 180px; }
  .course-name-vertical { font-size: 14px; height: 38px; }
}

:deep(.el-tag) { border-radius: 8px; font-weight: 500; }
:deep(.el-button--text) { color: var(--c-accent); }
:deep(.el-button--text:hover) { color: var(--c-accent2); background: #f4f5f4; }
:deep(.el-progress-bar__inner) { transition: width 0.5s ease; }
</style>
