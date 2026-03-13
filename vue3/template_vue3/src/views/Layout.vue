<script setup>
import {
  CaretBottom,
  EditPen,
  Promotion,
  SwitchButton,
  TrendCharts,
  User,
  Search,
  Link,
  UserFilled,
  WarnTriangleFilled,
  Document,
  Tickets,
  SuccessFilled,
  DataLine,
  DArrowRight,
  DArrowLeft,
  Odometer,
  Message
} from '@element-plus/icons-vue'
import avatar from '@/assets/default.png'
import platformLogo from '@/assets/logo.png'
// 假设背景图名为 background.png
import headerBg from '@/assets/background.png'
import { useUserInfoStore } from '@/stores/userInfo'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getCurUser } from '@/api/api'
import { computed, ref, watch } from 'vue'

const userInfoStore = useUserInfoStore()
const router = useRouter()
const route = useRoute()

const ROLE_DEFAULT_PATH = {
  admin: '/user/list',
  teacher: '/news',
  student: '/news'
}

const ROLE_ALLOW_ROUTES = {
  admin: new Set(['/user/list']),
  teacher: new Set([
    '/news',
    '/user/count',
    '/user/jiashicang',
    '/user/info',
    '/user/resetPassword',
    '/user/learning',
    '/user/studentList',
    '/user/coursevisit',
    '/user/learninggrade',
    '/user/interaction',
    '/user/avgscore',
    '/user/LearningDurationA',
    '/user/completion'
  ]),
  student: new Set([
    '/news',
    '/user/count',
    '/user/info',
    '/user/resetPassword',
    '/user/learning'
  ])
}

const roleCode = computed(() => {
  const role = userInfoStore.userInfo?.role
  if (role === 'teacher' || role === 'student') {
    return role
  }
  return 'admin'
})

const showUserManagement = computed(() => roleCode.value === 'admin')
const showNews = computed(() => roleCode.value !== 'admin')
const showAi = computed(() => roleCode.value !== 'admin')
const showCockpit = computed(() => roleCode.value === 'teacher')
const showPersonalCenter = computed(() => roleCode.value !== 'admin')
const showOnlineLearning = computed(() => roleCode.value !== 'admin')
const showWarning = computed(() => roleCode.value === 'teacher')
const showAnalysis = computed(() => roleCode.value === 'teacher')

const isCollapse = ref(true)

const canAccessPath = (path) => {
  const allowSet = ROLE_ALLOW_ROUTES[roleCode.value] || ROLE_ALLOW_ROUTES.admin
  return allowSet.has(path)
}

const redirectToRoleDefaultIfNeeded = () => {
  if (route.path === '/login' || route.path === '/register' || route.path === '/welcome') {
    return
  }
  if (!canAccessPath(route.path)) {
    const target = ROLE_DEFAULT_PATH[roleCode.value]
    if (target !== route.path) {
      router.replace(target)
    }
  }
}

const getUserInfo = async () => {
  try {
    const res = await getCurUser()
    if (!res.data) {
      ElMessage({
        message: '暂未登录请先登录',
        type: 'warning'
      })
      userInfoStore.removeUserInfo()
      await router.push({ path: '/login' })
      return
    }
    userInfoStore.setUserInfo(res.data)
    redirectToRoleDefaultIfNeeded()
  } catch (e) {
    userInfoStore.removeUserInfo()
    await router.push({ path: '/login' })
  }
}
getUserInfo()

watch(() => route.path, () => {
  redirectToRoleDefaultIfNeeded()
})

watch(() => roleCode.value, () => {
  redirectToRoleDefaultIfNeeded()
})

const handleCommand = async (command) => {
  if (command === 'logout') {
    ElMessageBox.confirm(
        '你确认要退出吗？',
        '温馨提示',
        {
          confirmButtonText: '确认',
          cancelButtonText: '取消',
          type: 'warning'
        }
    ).then(async () => {
      userInfoStore.removeUserInfo()
      ElMessage.success('退出成功')
      await router.push('/login')
    })
    return
  }

  if (roleCode.value === 'admin') {
    ElMessage.warning('管理员仅可访问用户管理')
    return
  }
  await router.push('/user/' + command)
}

const handleOpen = (key, keyPath) => {
  console.log(key, keyPath)
}
const handleClose = (key, keyPath) => {
  console.log(key, keyPath)
}
</script>

<template>
  <el-container class="layout-container">
    <el-menu
        default-active="2"
        class="el-menu-vertical-demo"
        :collapse="isCollapse"
        @open="handleOpen"
        @close="handleClose"
        router
    >
      <el-menu-item v-if="showNews" index="/news">
        <el-tooltip :content="isCollapse ? '新闻资讯' : ''" placement="right">
          <el-icon><Message /></el-icon>
        </el-tooltip>
        <span>新闻资讯</span>
      </el-menu-item>

      <el-menu-item v-if="showUserManagement" index="/user/list">
        <el-tooltip :content="isCollapse ? '用户管理' : ''" placement="right">
          <el-icon><Promotion /></el-icon>
        </el-tooltip>
        <span>用户管理</span>
      </el-menu-item>

      <el-menu-item v-if="showAi" index="/user/count">
        <el-tooltip :content="isCollapse ? 'AI助理教学' : ''" placement="right">
          <el-icon><User /></el-icon>
        </el-tooltip>
        <span>AI助理教学</span>
      </el-menu-item>

      <el-menu-item v-if="showCockpit" index="/user/jiashicang">
        <el-tooltip :content="isCollapse ? '驾驶舱' : ''" placement="right">
          <el-icon><Odometer /></el-icon>
        </el-tooltip>
        <span>驾驶舱</span>
      </el-menu-item>

      <el-sub-menu v-if="showPersonalCenter" index="personal-center">
        <template #title>
          <el-tooltip :content="isCollapse ? '个人中心' : ''" placement="right">
            <el-icon><UserFilled /></el-icon>
          </el-tooltip>
          <span>个人中心</span>
        </template>
        <el-menu-item index="/user/info">
          <el-icon><User /></el-icon>
          <span>基本资料</span>
        </el-menu-item>
        <el-menu-item index="/user/resetPassword">
          <el-icon><EditPen /></el-icon>
          <span>重置密码</span>
        </el-menu-item>
      </el-sub-menu>

      <el-menu-item v-if="showOnlineLearning" index="/user/learning">
        <el-tooltip :content="isCollapse ? '在线学习' : ''" placement="right">
          <el-icon><Odometer /></el-icon>
        </el-tooltip>
        <span>在线学习</span>
      </el-menu-item>

      <el-menu-item v-if="showWarning" index="/user/studentList">
        <el-tooltip :content="isCollapse ? '学情预警' : ''" placement="right">
          <el-icon><WarnTriangleFilled /></el-icon>
        </el-tooltip>
        <span>学情预警</span>
      </el-menu-item>

      <el-sub-menu v-if="showAnalysis" index="analysis">
        <template #title>
          <el-tooltip :content="isCollapse ? '学情分析' : ''" placement="right">
            <el-icon><TrendCharts /></el-icon>
          </el-tooltip>
          <span>学情分析</span>
        </template>
        <el-menu-item index="/user/coursevisit">
          <el-icon><TrendCharts /></el-icon>
          <span>课程访问量</span>
        </el-menu-item>
        <el-menu-item index="/user/learninggrade">
          <el-icon><Document /></el-icon>
          <span>学习成绩</span>
        </el-menu-item>
        <el-menu-item index="/user/interaction">
          <el-icon><Link /></el-icon>
          <span>课堂互动情况</span>
        </el-menu-item>
        <el-menu-item index="/user/avgscore">
          <el-icon><Tickets /></el-icon>
          <span>课程平均分</span>
        </el-menu-item>
        <el-menu-item index="/user/LearningDurationA">
          <el-icon><DataLine /></el-icon>
          <span>学习时长</span>
        </el-menu-item>
        <el-menu-item index="/user/completion">
          <el-icon><SuccessFilled /></el-icon>
          <span>课程完成</span>
        </el-menu-item>
      </el-sub-menu>

      <el-radio-group v-model="isCollapse" style="margin-bottom: 40px; width: 80px">
        <el-tooltip content="折叠菜单" placement="right">
          <el-radio-button :value="true">
            <el-icon><DArrowLeft /></el-icon>
          </el-radio-button>
        </el-tooltip>
        <el-tooltip content="展开菜单" placement="right">
          <el-radio-button :value="false">
            <el-icon><DArrowRight /></el-icon>
          </el-radio-button>
        </el-tooltip>
      </el-radio-group>
    </el-menu>

    <!-- 主布局容器 -->
    <el-container class="main-content-wrapper">
      <!-- 顶部品牌栏 -->
      <el-header
          class="global-brand-header"
          :style="{ '--header-bg': `url(${headerBg})` }"
      >
        <div class="brand-left-area">
          <div class="logo-wrapper">
            <img :src="platformLogo" alt="Platform Logo" class="brand-logo" />
          </div>
          <div class="brand-info">
            <h1 class="brand-title">马克思主义学院精准思政云平台</h1>
            <span class="brand-subtitle">Marxism Cloud Platform</span>
          </div>
        </div>

        <div class="header-actions">
          <div class="welcome-text">
            欢迎：<strong>{{ userInfoStore.userInfo.name || userInfoStore.userInfo.username }}</strong>
          </div>
          <el-dropdown placement="bottom-end" @command="handleCommand" trigger="click">
            <div class="user-profile-trigger">
              <el-avatar :size="36" :src="userInfoStore.userInfo.avatar ? userInfoStore.userInfo.avatar : avatar" />
              <el-icon class="user-dropdown-icon"><CaretBottom /></el-icon>
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="info">个人中心</el-dropdown-item>
                <el-dropdown-item command="resetPassword">修改密码</el-dropdown-item>
                <el-dropdown-item divided command="logout" style="color: #f56c6c;">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>

      <el-main>
        <router-view />
      </el-main>

      <el-footer>思政云平台系统 ©2026</el-footer>
    </el-container>
  </el-container>
</template>

<style lang="scss" scoped>
.layout-container {
  height: 100vh;
  display: flex;

  /* 侧边菜单基础样式 */
  .el-menu-vertical-demo:not(.el-menu--collapse) {
    width: 220px;
    min-height: 400px;
  }
  .el-menu {
    border-right: none;
    background-color: #fff;
    box-shadow: 2px 0 8px rgba(0,0,0,0.05);
    z-index: 10;
  }

  .main-content-wrapper {
    display: flex;
    flex-direction: column;
    background-color: #f5f7fa; /* 整体背景色偏灰，突出Header */
    overflow: hidden;
  }

  /* =========== 顶部品牌栏核心样式 =========== */
  .global-brand-header {
    height: 85px; /* 修改点：调低高度 (原100px) */
    padding: 0 40px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    color: #fff;
    z-index: 100;
    box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
    position: relative;
    overflow: hidden;

    /* 品牌背景融合 */
    background-image:
        /* 修改点：透明度降低至 0.45，解决背景图不显示的问题 */
        linear-gradient(135deg, rgba(44, 62, 80, 0.45) 0%, rgba(75, 108, 183, 0.45) 100%),
        var(--header-bg);
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
  }

  .brand-left-area {
    display: flex;
    align-items: center;
    gap: 25px;
    position: relative;
    z-index: 2;

    .logo-wrapper {
      background: rgba(255, 255, 255, 0.15);
      width: 100px;
      height: 85px;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 0 15px rgba(255,255,255,0.2);
      border: 1px solid rgba(255,255,255,0.2);
      backdrop-filter: blur(4px);

      .brand-logo {
        width: 100%;
        height: 100%;
        object-fit: cover;
      }
    }

    .brand-info {
      display: flex;
      flex-direction: column;
      justify-content: center;

      .brand-title {
        font-size: 26px; /* 修改点：微调字号 */
        font-weight: 700;
        margin: 0;
        letter-spacing: 2px;
        line-height: 1.2;
        text-shadow: 0 2px 4px rgba(0,0,0,0.5);
      }

      .brand-subtitle {
        font-size: 13px;
        opacity: 0.9;
        font-weight: 300;
        text-transform: uppercase;
        letter-spacing: 1px;
        margin-top: 5px;
        color: rgba(255,255,255,0.85);
      }
    }
  }

  .header-actions {
    display: flex;
    align-items: center;
    gap: 20px;
    position: relative;
    z-index: 2;

    .welcome-text {
      font-size: 15px;
      color: rgba(255, 255, 255, 0.95);
      text-shadow: 0 1px 2px rgba(0,0,0,0.3);

      strong {
        color: #fff;
        font-weight: 600;
        margin-left: 4px;
      }
    }

    .user-profile-trigger {
      display: flex;
      align-items: center;
      gap: 8px;
      cursor: pointer;
      padding: 6px 12px;
      border-radius: 30px;
      transition: all 0.3s;
      background: rgba(255,255,255,0.1);
      border: 1px solid rgba(255,255,255,0.1);

      &:hover {
        background: rgba(255, 255, 255, 0.25);
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
      }

      .user-dropdown-icon {
        color: rgba(255,255,255,0.9);
        font-size: 14px;
      }
    }
  }

  .el-main {
    padding: 20px;
    overflow-y: auto;
  }

  .el-footer {
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 12px;
    color: #909399;
    background-color: #fff;
    border-top: 1px solid #e4e7ed;
    height: 40px;
  }

  /* 响应式适配 */
  @media (max-width: 768px) {
    .global-brand-header {
      height: 70px;
      padding: 0 20px;
    }
    .brand-subtitle {
      display: none;
    }
    .brand-title {
      font-size: 18px !important;
    }
    .welcome-text {
      display: none;
    }
    /* 移动端缩小logo */
    .brand-left-area .logo-wrapper {
      width: 50px;
      height: 50px;
    }
    .brand-left-area .logo-wrapper .brand-logo {
      width: 40px;
      height: 40px;
    }
  }
}
</style>