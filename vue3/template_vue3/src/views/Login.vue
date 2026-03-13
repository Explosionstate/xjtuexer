<script setup>
import { ref, onMounted } from "vue";
import { ElMessage } from "element-plus";
import { useRouter } from "vue-router";
import { userLogin } from "@/api/api";
import { useUserInfoStore } from "@/stores/userInfo";
import platformLogo from "@/assets/logo.png";

const router = useRouter();
const userInfoStore = useUserInfoStore();
const username = ref("");
const password = ref("");
const validRoles = ["teacher", "student", "admin"];

const resolveHomePathByRole = (role) => {
  if (role === "teacher" || role === "student") {
    return "/news";
  }
  return "/user/list";
};

const isValidLoginRole = (role) => validRoles.includes(role);

const shouldShowCredentialError = (error) => {
  const message = error?.message || error?.data?.message || "";
  return [
    "用户名或密码错误",
    "Invalid loginName or password",
    "Invalid loginName/password",
  ].some((text) => message.includes(text));
};

const showCredentialError = () => {
  ElMessage.closeAll();
  ElMessage({
    message: "用户名或密码错误",
    type: "warning",
  });
};

const login = () => {
  const user = {
    loginName: username.value,
    password: password.value,
  };
  userLogin(user)
      .then((res) => {
        if (res.data == null || !isValidLoginRole(res.data.role)) {
          showCredentialError();
          return;
        }

        userInfoStore.setUserInfo(res.data);
        const targetPath = resolveHomePathByRole(res.data.role);
        ElMessage({
          message: "登录成功",
          type: "success",
        });
        router.push({ path: targetPath });
      })
      .catch((error) => {
        if (shouldShowCredentialError(error)) {
          showCredentialError();
        }
      });
};

const register = () => {
  router.push({ path: "/register" });
};

onMounted(() => {
  const canvas = document.getElementById("particleCanvas");
  const ctx = canvas.getContext("2d");

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
      this.color = Math.random() > 0.5 ? "#00a8a8" : "#4b0082";
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
          ctx.strokeStyle = "rgba(100, 100, 100, 0.1)";
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

  window.addEventListener("resize", () => {
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
        <div class="brand-title">
          <div class="brand-text-container">
            <img class="brand-logo" :src="platformLogo" alt="Platform logo" />
            <div class="brand-text">马克思主义学院</div>
            <div class="brand-text">精准思政云平台</div>
          </div>
        </div>
        <h2>Welcome</h2>
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
        </el-form>
      </div>
      <div class="butt">
        <el-button type="primary" @click="login">登录</el-button>
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
  width: 500px;
  padding: 30px;
  background: rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(10px);
  border-radius: 15px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
  animation: slideIn 0.6s ease-out;
  position: relative;
  z-index: 2;
}

.logintext .brand-title {
  display: flex;
  justify-content: center; /* 确保内部容器整体居中 */
  margin-bottom: 20px;
  width: 100%;
}

.brand-text-container {
  display: flex;
  flex-direction: column;
  align-items: center; /* 保持两行文字互相居中 */
  position: relative; /* 为 logo 提供定位锚点 */
}

.logintext .brand-logo {
  position: absolute;
  right: 100%; /* 将 logo 放置在文字容器的左侧外 */
  top: 50%;
  transform: translateY(-50%); /* 垂直居中 */
  width: 60px;
  height: 60px;
  object-fit: contain;
  margin-right: 20px; /* Logo 和文字之间的间距 */
}

.logintext .brand-text {
  font-size: 30px;
  font-weight: bold;
  color: #e6e6fa;
  text-shadow: 0 0 10px #4b0082, 0 0 20px #4b0082, 0 0 30px #00a8a8;
  animation: neonGlow 1.5s ease-in-out infinite alternate;
  line-height: 1.25;
  white-space: nowrap;
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