
<template>
  <div class="welcome-container">
    <!-- 头部导航 -->
    <div class="header">
      <h1 class="title">欢迎来到思政云平台</h1>
      <div class="butt">
        <el-button class="login-btn" @click="goToLogin">登录</el-button>
      </div>
    </div>

    <!-- 轮播图 -->
    <el-carousel indicator-position="outside" height="calc(100vh - 80px)" :autoplay="true" :interval="3000">
      <el-carousel-item v-for="item in carouselItems" :key="item.id">
        <div class="carousel-content" :style="{ backgroundImage: `url(${item.image})`, backgroundSize: 'cover', backgroundPosition: 'center' }">
          <div class="gradient-transition">
            <div class="content-overlay">
              <h3>{{ item.title }}</h3>
              <p>{{ item.description }}</p>
            </div>
          </div>
        </div>
      </el-carousel-item>
    </el-carousel>
    <div class="clock-container">
      <p class="date">{{ currentDate }}</p>
      <p class="time">{{ currentTime }}</p>
    </div>
  </div>
</template>


<script>
import image1 from '../assets/lunbo-1.jpg'
import image2 from '../assets/lunbo-2.jpg'
import image3 from '../assets/lunbo-3.jpg'
import image4 from '../assets/lunbo-4.jpg'
import dayjs from 'dayjs'

export default {
  name: 'WelcomePage',
  data() {
    return {
      carouselItems: [
        { id: 1, image: image1, },
        { id: 2, image: image2, },
        { id: 3, image: image3, },
        { id: 4, image: image4, },
      ],
      currentDate: '',
      currentTime: ''
    }
  },
  mounted() {
    this.updateTime();
    this.timer = setInterval(() => {
      this.updateTime();
    }, 1000);
  },
  beforeDestroy() {
    clearInterval(this.timer);
  },
  methods: {
    goToLogin() {
      this.$router.push('/login');
    },
    updateTime() {
      const now = dayjs();
      this.currentDate = now.format('YYYY年MM月DD日');
      this.currentTime = now.format('HH:mm:ss');
    }
  }
}
</script>

<style scoped>
.welcome-container {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  overflow: hidden;
}

.header {
  position: relative;
  z-index: 1000;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 40px;
  background: rgba(30, 30, 30, 0.7); /* 深炭灰色，半透明 */
  height: 40px;
  backdrop-filter: blur(5px); /* 玻璃摩砂效果，增强高级感 */
}

.gradient-transition {
  height: 20px;
  background: linear-gradient(to bottom, rgba(30, 30, 30, 0.7), transparent); /* 与 header 一致 */
  z-index: 999;
}

.title {
  font-size: 28px;
  color: #ffffff; /* 纯白色文字 */
  text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.7); /* 更强阴影，立体感 */
}

.login-btn {
  background: rgba(255, 255, 255, 0.5); /* 半透明白色背景 */
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: #000000;
  border-radius: 8px;
  padding: 10px 20px;
  font-size: 16px;
  transition: all 0.3s ease;
}

.login-btn:hover {
  background: rgba(255, 255, 255, 0.7);
  border-color: #00a8a8;
  box-shadow: 0 0 8px #00a8a8;
  transform: scale(1.05);
}

.el-carousel {
  width: 100vw;
  margin-top: 0;
}

.el-carousel__container {
  height: calc(100vh - 80px) !important;
}

.el-carousel__item {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
}

.butt {
  display: flex;
  gap: 10px;
}

.carousel-content {
  width: 100%;
  height: 100%;
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
}

.content-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.3);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  color: white;
  padding: 0 20px;
  box-sizing: border-box;
}

.content-overlay h3 {
  font-size: 36px;
  margin-bottom: 20px;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
}

.content-overlay p {
  font-size: 18px;
  max-width: 800px;
  text-align: center;
  text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.5);
}

.clock-container {
  position: absolute;
  bottom: 20px;
  right: 20px;
  color: white;
  text-align: right;
  text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.5);
}

.clock-container .date {
  font-size: 24px;
  line-height: 1.2;
}


.clock-container .time {
  font-size: 28px;
  line-height: 1.2;
}
</style>
