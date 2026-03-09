<script setup>
import { ref, onMounted } from 'vue';
import { ElMessage } from 'element-plus';
import { useRouter } from 'vue-router';
import { insertCourse } from '@/api/api';
import request from '@/utils/request';

const router = useRouter();
const title = ref('');
const teacherId = ref('');
const chapters = ref('[{"id": 1, "title": "章节1"}]');
const materials = ref('[{"id": 1, "title": "资料1"}]');
const taskPoints = ref('[{"id": 1, "title": "任务点1"}]');

const submit = () => {
  // 验证JSON格式
  try {
    JSON.parse(chapters.value);
    JSON.parse(materials.value);
    JSON.parse(taskPoints.value);
  } catch (e) {
    ElMessage({
      message: 'JSON格式错误，请检查章节、资料或任务点输入',
      type: 'warning',
    });
    return;
  }

  const course = {
    title: title.value,
    teacherId: Number(teacherId.value),
    chapters: JSON.parse(chapters.value),
    materials: JSON.parse(materials.value),
    taskPoints: JSON.parse(taskPoints.value),
  };

  insertCourse(course).then(res => {
    if (res.data == null) {
      ElMessage({
        message: '插入课程失败',
        type: 'warning',
      });
    } else {
      ElMessage({
        message: '插入课程成功',
        type: 'success',
      });
      // 清空表单
      title.value = '';
      teacherId.value = '';
      chapters.value = '[{"id": 1, "title": "章节1"}]';
      materials.value = '[{"id": 1, "title": "资料1"}]';
      taskPoints.value = '[{"id": 1, "title": "任务点1"}]';
      // 跳转到课程列表页面
      router.push({ path: '../user/jiashicang' });
    }
  }).catch(error => {
    ElMessage({
      message: '插入失败：' + error.message,
      type: 'error',
    });
  });
};

const back = () => {
  router.push({ path: '../user/jiashicang' }); // 返回课程列表页面
};

onMounted(() => {
  const canvas = document.getElementById('particleCanvas');
  const ctx = canvas.getContext('2d');

  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  const particlesArray = [];
  const numberOfParticles = 100;

  class Particle {
    constructor() {
      this.x = Math.random() * canvas.width;
      this.y = Math.random() * canvas.height;
      this.size = Math.random() * 4 + 1;
      this.speedX = Math.random() * 2 - 1;
      this.speedY = Math.random() * 2 - 1;
      this.color = Math.random() > 0.5 ? '#00a8a8' : '#4b0082';
    }

    update() {
      this.x += this.speedX;
      this.y += this.speedY;

      if (this.x > canvas.width) this.x = 0;
      else if (this.x < 0) this.x = canvas.width;
      if (this.y > canvas.height) this.y = 0;
      else if (this.y < 0) this.y = canvas.height;
    }

    draw() {
      ctx.fillStyle = this.color;
      ctx.globalAlpha = 0.4;
      ctx.beginPath();
      ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
      ctx.closePath();
      ctx.fill();
    }
  }

  function init() {
    for (let i = 0; i < numberOfParticles; i++) {
      particlesArray.push(new Particle());
    }
  }

  function animate() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    for (let i = 0; i < particlesArray.length; i++) {
      particlesArray[i].update();
      particlesArray[i].draw();
      for (let j = i; j < particlesArray.length; j++) {
        const dx = particlesArray[i].x - particlesArray[j].x;
        const dy = particlesArray[i].y - particlesArray[j].y;
        const distance = Math.sqrt(dx * dx + dy * dy);
        if (distance < 100) {
          ctx.beginPath();
          ctx.strokeStyle = 'rgba(100, 100, 100, 0.1)';
          ctx.lineWidth = 1;
          ctx.moveTo(particlesArray[i].x, particlesArray[i].y);
          ctx.lineTo(particlesArray[j].x, particlesArray[j].y);
          ctx.stroke();
        }
      }
    }
    ctx.globalAlpha = 1;
    requestAnimationFrame(animate);
  }

  init();
  animate();

  window.addEventListener('resize', () => {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
  });
});
</script>

<template>
  <div class="loginbody">
    <canvas id="particleCanvas"></canvas>
    <div class="logindata">
      <div class="logintext">
        <h1>马克思主义学院精准思政云平台</h1>
        <h2>添加课程</h2>
      </div>
      <div class="formdata">
        <el-form ref="form">
          <el-form-item prop="title">
            <el-input
                v-model="title"
                clearable
                placeholder="请输入课程标题"
            ></el-input>
          </el-form-item>
          <el-form-item prop="teacherId">
            <el-input
                v-model="teacherId"
                clearable
                placeholder="请输入教师ID"
                type="number"
            ></el-input>
          </el-form-item>
          <el-form-item prop="chapters">
            <el-input
                v-model="chapters"
                type="textarea"
                :rows="4"
                placeholder='请输入章节JSON，例如：[{"id": 1, "title": "章节1"}]'
            ></el-input>
          </el-form-item>
          <el-form-item prop="materials">
            <el-input
                v-model="materials"
                type="textarea"
                :rows="4"
                placeholder='请输入资料JSON，例如：[{"id": 1, "title": "资料1"}]'
            ></el-input>
          </el-form-item>
          <el-form-item prop="taskPoints">
            <el-input
                v-model="taskPoints"
                type="textarea"
                :rows="4"
                placeholder='请输入任务点JSON，例如：[{"id": 1, "title": "任务点1"}]'
            ></el-input>
          </el-form-item>
        </el-form>
      </div>
      <div class="butt">
        <el-button type="primary" @click="back">返回</el-button>
        <el-button type="primary" class="register" @click="submit">提交</el-button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.loginbody {
  width: 100%;
  height: 100vh;

  background-size: cover;
  background-position: center center;
  position: fixed;
  display: flex;
  justify-content: center;
  align-items: center;
  overflow: hidden;
  filter: brightness(0.7);
}

canvas {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
}

.logindata {
  width: 400px;
  padding: 30px;
  background: rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(10px);
  border-radius: 15px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
  animation: slideIn 0.6s ease-out;
  position: relative;
  z-index: 2;
}

.logintext h1 {
  margin-bottom: 10px;
  font-size: 36px;
  font-weight: 900;
  color: #e6e6fa;
  text-align: center;
  text-shadow: 0 0 15px #4b0082, 0 0 30px #4b0082, 0 0 45px #00a8a8, 0 0 60px #00a8a8;
  animation: neonGlow 1s ease-in-out infinite alternate;
}

.logintext h2 {
  margin-bottom: 20px;
  font-size: 34px;
  font-weight: bold;
  color: #e6e6fa;
  text-align: center;
  text-shadow: 0 0 10px #4b0082, 0 0 20px #4b0082, 0 0 30px #00a8a8;
  animation: neonGlow 1.5s ease-in-out infinite alternate;
}

.formdata {
  margin-bottom: 20px;
}

:deep(.el-input__inner),
:deep(.el-textarea__inner) {
  background: rgba(255, 255, 255, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: #000000;
  border-radius: 8px;
}

:deep(.el-input__inner:focus),
:deep(.el-textarea__inner:focus) {
  border-color: #00a8a8;
  box-shadow: 0 0 8px #00a8a8;
}

.butt {
  display: flex;
  justify-content: center;
  gap: 10px;
}

.el-button--primary {
  background: transparent;
  border: 2px solid #4b0082;
  border-radius: 8px;
  padding: 12px 30px;
  font-size: 16px;
  color: #e6e6fa;
  box-shadow: 0 0 10px #4b0082, 0 0 20px #00a8a8;
  transition: transform 0.3s, box-shadow 0.3s, border-color 0.3s;
}

.el-button--primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 0 15px #4b0082, 0 0 25px #00a8a8;
  border-color: #00a8a8;
}

@keyframes slideIn {
  from {
    transform: translateY(-50px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

@keyframes neonGlow {
  from {
    text-shadow: 0 0 15px #4b0082, 0 0 30px #4b0082, 0 0 45px #00a8a8;
  }
  to {
    text-shadow: 0 0 20px #4b0082, 0 0 35px #4b0082, 0 0 60px #00a8a8;
  }
}
</style>