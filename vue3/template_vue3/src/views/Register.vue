<script setup>
import { ref, onMounted } from "vue";
import { ElMessage } from "element-plus";
import { useRouter } from "vue-router";
import { userLogin } from "@/api/api";
import request from '@/utils/request'; // 假设request定义在@/utils/request

const router = useRouter();
const username = ref('');
const password = ref('');
const confirmPassword = ref(''); // 新增确认密码变量

const login = () => {
  router.push({ path: '/login' }); // 返回登录页面
};

const register = () => {
  if (password.value !== confirmPassword.value) {
    ElMessage({
      message: '两次输入的密码不一致',
      type: 'warning',
    });
    return;
  }

  const user = {
    loginName: username.value,
    password: password.value
  };
  request({
    url: '/api/user/register',
    method: 'post',
    data: user
  }).then(res => {
    if (res.data == null) {
      ElMessage({
        message: '用户名已存在',
        type: 'warning',
      });
    } else {
      ElMessage({
        message: '注册成功',
        type: 'success',
      });
      username.value = '';
      password.value = '';
      confirmPassword.value = '';
    }
  }).catch(error => {
    ElMessage({
      message: '注册失败',
      type: 'error',
    });
  });
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
        <h2>注册界面</h2>
      </div>
      <div class="formdata">
        <el-form ref="form">
          <el-form-item prop="username">
            <el-input
                v-model="username"
                clearable
                placeholder="请输入账号"
            ></el-input>
          </el-form-item>
          <el-form-item prop="password">
            <el-input
                v-model="password"
                clearable
                placeholder="请输入密码"
                show-password
            ></el-input>
          </el-form-item>
          <el-form-item prop="confirmPassword">
            <el-input
                v-model="confirmPassword"
                clearable
                placeholder="请再次输入密码"
                show-password
            ></el-input>
          </el-form-item>
        </el-form>
      </div>
      <div class="butt">
        <el-button type="primary" @click="login">返回登录</el-button>
        <el-button type="primary" class="register" @click="register">注册</el-button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.loginbody {
  width: 100%;
  height: 100vh;
  background-image: url("../assets/1.png");
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

:deep(.el-input__inner) {
  background: rgba(255, 255, 255, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: #000000;
  border-radius: 8px;
}

:deep(.el-input__inner:focus) {
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