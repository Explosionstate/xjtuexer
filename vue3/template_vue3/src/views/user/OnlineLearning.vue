<template>
  <div class="p-6 bg-gray-100 min-h-screen">
    <h1 class="text-2xl font-bold mb-6">在线学习</h1>
    <el-card class="mb-6">
      <h2 class="text-xl font-bold mb-4">选择课程</h2>
      <el-row :gutter="20" class="mb-4">
        <el-col :span="8" v-for="course in courses" :key="course.coursename">
          <el-card shadow="hover" class="mb-4 cursor-pointer" @click="selectCourse(course.coursename)">
            <div class="text-center">
              <h3 class="text-lg font-semibold">{{ course.coursename }}</h3>
            </div>
          </el-card>
        </el-col>
      </el-row>
      <div v-if="selectedCourse">
        <el-row :gutter="20">
          <el-col :span="6">
            <el-card class="mb-6">
              <h2 class="text-xl font-bold mb-4">节数列表 - {{ selectedCourse }}</h2>
              <el-menu :default-active="activeSection" class="el-menu-vertical">
                <el-menu-item
                    v-for="section in sections"
                    :key="section.id"
                    :index="section.id"
                    @click="selectSection(section)"
                >
                  {{ section.name }}
                </el-menu-item>
              </el-menu>
            </el-card>
          </el-col>
          <el-col :span="18">
            <el-card class="mb-6">
              <h2 class="text-xl font-bold mb-4">视频播放</h2>
              <video
                  v-if="currentVideo"
                  controls
                  class="w-full h-[500px]"
                  :src="currentVideo"
                  @error="handleVideoError"
                  autoplay
              >
                您的浏览器不支持视频播放。
              </video>
              <div v-else>请选择一节课</div>
            </el-card>
          </el-col>
        </el-row>
      </div>
    </el-card>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { ElMessage } from 'element-plus';
import axios from 'axios';

export default {
  name: 'OnlineLearning',
  setup() {
    const courses = ref([]);
    const selectedCourse = ref('');
    const activeSection = ref('');
    const currentVideo = ref('');
    const sections = ref([]);

    const courseSections = {
      '国防教育': [
        { id: '1', name: '第一节', video: '/api/online-course/video/11.mp4' },
        { id: '2', name: '第二节', video: '/api/online-course/video/12.mp4' },
      ],
      '近代史': [
        { id: '1', name: '第一节', video: '/api/online-course/video/21.mp4' },
        { id: '2', name: '第二节', video: '/api/online-course/video/22.mp4' },
      ],
    };

    const fetchCourses = async () => {
      try {
        const response = await axios.get('http://localhost:8080/api/online-course/courses');
        if (response.data.code === 0) {
          courses.value = response.data.data;
        } else {
          ElMessage.error(response.data.message || '获取课程列表失败');
        }
      } catch (error) {
        ElMessage.error('请求课程列表失败: ' + error.message);
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
      selectCourse,
      selectSection,
      handleVideoError,
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
.cursor-pointer {
  cursor: pointer;
}
.el-menu-vertical {
  width: 100%;
}
video {
  max-width: 100%;
}
</style>