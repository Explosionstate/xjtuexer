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
  DArrowRight,
  DArrowLeft,
  Odometer,
  Message,
  ChatDotRound
} from '@element-plus/icons-vue'
import avatar from '@/assets/default.png'
import platformLogo from '@/assets/logo.png'
// 假设背景图名为 background.png
import headerBg from '@/assets/background.png'
import { useUserInfoStore } from '@/stores/userInfo'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getCurUser, userLogout } from '@/api/api'
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
  admin: new Set(['/user/list', '/admin/agent-center']),
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

const welcomeDisplayName = computed(() => {
  const legacyName = userInfoStore.userInfo?.name || userInfoStore.userInfo?.username || ''
  const normalizedName = legacyName || userInfoStore.userInfo?.loginName || ''

  if (roleCode.value === 'teacher') {
    if (!normalizedName) {
      return normalizedName
    }
    return normalizedName.endsWith('老师') ? normalizedName : `${normalizedName}老师`
  }
  if (roleCode.value === 'student') {
    return normalizedName
  }
  // 兼容保留 admin 及其他角色原展示逻辑
  return legacyName
})

const showUserManagement = computed(() => roleCode.value === 'admin')
const showAdminAgentCenter = computed(() => roleCode.value === 'admin')
const showNews = computed(() => roleCode.value !== 'admin')
const showAi = computed(() => roleCode.value !== 'admin')
const showCockpit = computed(() => roleCode.value === 'teacher')
const showPersonalCenter = computed(() => roleCode.value !== 'admin')
const showOnlineLearning = computed(() => roleCode.value !== 'admin')
const showWarning = computed(() => roleCode.value === 'teacher')
const showAnalysis = computed(() => roleCode.value === 'teacher')
const activeMenuIndex = computed(() => {
  if (route.path.startsWith('/admin/agent-center')) {
    return '/admin/agent-center'
  }
  return route.path
})

const isCollapse = ref(true)

const clearAuthState = () => {
  userInfoStore.removeUserInfo()
  localStorage.removeItem('userInfo')
  sessionStorage.removeItem('userInfo')
}

const canAccessPath = (path) => {
  if (roleCode.value === 'admin' && path.startsWith('/admin/agent-center/workbench/')) {
    return true
  }
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
      clearAuthState()
      await router.replace({ path: '/login' })
      return
    }
    userInfoStore.setUserInfo(res.data)
    redirectToRoleDefaultIfNeeded()
  } catch (e) {
    clearAuthState()
    await router.replace({ path: '/login' })
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
      try {
        await userLogout()
      } catch (_) {
      }
      clearAuthState()
      ElMessage.success('退出成功')
      await router.replace('/login')
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
    <div class="sidebar-wrapper" :class="{ 'is-collapse': isCollapse }">
      <el-menu
        :default-active="activeMenuIndex"
        class="el-menu-vertical-demo"
        :collapse="isCollapse"
        @open="handleOpen"
        @close="handleClose"
        router
      >
        <div class="menu-content-scroll">
          <el-menu-item v-if="showNews" index="/news">
            <el-tooltip :content="isCollapse ? '新闻资讯' : ''" placement="right" :disabled="!isCollapse">
              <el-icon><Message /></el-icon>
            </el-tooltip>
            <template #title><span>新闻资讯</span></template>
          </el-menu-item>

          <el-menu-item v-if="showUserManagement" index="/user/list">
            <el-tooltip :content="isCollapse ? '用户管理' : ''" placement="right" :disabled="!isCollapse">
              <el-icon><Promotion /></el-icon>
            </el-tooltip>
            <template #title><span>用户管理</span></template>
          </el-menu-item>

          <el-menu-item v-if="showAdminAgentCenter" index="/admin/agent-center">
            <el-tooltip :content="isCollapse ? '智能体管理中心' : ''" placement="right" :disabled="!isCollapse">
              <el-icon><ChatDotRound /></el-icon>
            </el-tooltip>
            <template #title><span>智能体管理中心</span></template>
          </el-menu-item>

          <el-menu-item v-if="showAi" index="/user/count">
            <el-tooltip :content="isCollapse ? 'AI助力教学' : ''" placement="right" :disabled="!isCollapse">
              <el-icon><User /></el-icon>
            </el-tooltip>
            <template #title><span>AI助力教学</span></template>
          </el-menu-item>

          <el-menu-item v-if="showCockpit" index="/user/jiashicang">
            <el-tooltip :content="isCollapse ? '驾驶舱' : ''" placement="right" :disabled="!isCollapse">
              <el-icon><Odometer /></el-icon>
            </el-tooltip>
            <template #title><span>驾驶舱</span></template>
          </el-menu-item>

          <el-sub-menu v-if="showPersonalCenter" index="personal-center">
            <template #title>
              <el-tooltip :content="isCollapse ? '个人中心' : ''" placement="right" :disabled="!isCollapse">
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
            <el-tooltip :content="isCollapse ? '在线学习' : ''" placement="right" :disabled="!isCollapse">
              <el-icon><Odometer /></el-icon>
            </el-tooltip>
            <template #title><span>在线学习</span></template>
          </el-menu-item>

          <el-menu-item v-if="showWarning" index="/user/studentList">
            <el-tooltip :content="isCollapse ? '学情预警' : ''" placement="right" :disabled="!isCollapse">
              <el-icon><WarnTriangleFilled /></el-icon>
            </el-tooltip>
            <template #title><span>学情预警</span></template>
          </el-menu-item>

          <el-sub-menu v-if="showAnalysis" index="analysis" class="analysis-sub-menu">
            <template #title>
              <el-tooltip :content="isCollapse ? '学情分析' : ''" placement="right" :disabled="!isCollapse">
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
            <el-menu-item index="/user/completion">
              <el-icon><SuccessFilled /></el-icon>
              <span>课程完成</span>
            </el-menu-item>
          </el-sub-menu>
        </div>

        <div class="collapse-trigger-box">
          <div class="collapse-trigger" @click="isCollapse = !isCollapse">
            <el-icon><DArrowRight v-if="isCollapse" /><DArrowLeft v-else /></el-icon>
          </div>
        </div>
      </el-menu>
    </div>

    <el-container class="main-content-wrapper">
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
            欢迎：<strong>{{ welcomeDisplayName }}</strong>
          </div>
          <el-dropdown placement="bottom-end" @command="handleCommand" trigger="click">
            <div class="user-profile-trigger">
              <el-avatar :size="34" :src="userInfoStore.userInfo.avatar ? userInfoStore.userInfo.avatar : avatar" />
              <el-icon class="user-dropdown-icon"><CaretBottom /></el-icon>
            </div>
            <template #dropdown>
              <el-dropdown-menu class="custom-dropdown">
                <el-dropdown-item command="info"><el-icon><User /></el-icon>个人中心</el-dropdown-item>
                <el-dropdown-item command="resetPassword"><el-icon><EditPen /></el-icon>修改密码</el-dropdown-item>
                <el-dropdown-item divided command="logout" class="logout-item"><el-icon><SwitchButton /></el-icon>退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>

      <el-main>
        <router-view v-slot="{ Component }">
          <transition name="fade-transform" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </el-main>

      <el-footer>思政云平台系统 ©2026</el-footer>
    </el-container>
  </el-container>
</template>

<style lang="scss" scoped>
/* 定义全局 Quaric Cubic-Bezier 丝滑曲线 */
$qw-ease: cubic-bezier(0.25, 1, 0.25, 1);
/* 定义冷色调科技感的背景色 */
$qw-bg-color: #f0f2f5;

/* 清除默认抗锯齿，文字清晰度提升 */
* {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.layout-container {
  height: 100vh;
  display: flex;
  background-color: $qw-bg-color; /* 更冷的背景底色 */

  /* 侧边栏优化 */
  .sidebar-wrapper {
    background-color: #ffffff;
    box-shadow: 2px 0 12px rgba(0, 0, 0, 0.04);
    z-index: 10;
    /* 侧边栏收缩动画必须使用 Quart 曲线，不能用默认 linear */
    transition: width 0.3s $qw-ease;
    overflow: hidden;
    display: flex;
    flex-direction: column;

    .el-menu {
      border-right: none;
      height: 100%;
      display: flex;
      flex-direction: column;
      background-color: transparent; /* 允许菜单项悬浮效果 */
      padding: 12px 0;
    }

    /* 非折叠状态宽度 */
    .el-menu-vertical-demo:not(.el-menu--collapse) {
      width: 240px; /* 大气 */
    }

    /* 菜单内容滚动区 */
    .menu-content-scroll {
      flex: 1;
      overflow-y: auto;
      overflow-x: hidden;
      /* 隐藏滚动条 */
      &::-webkit-scrollbar { width: 0; }
    }

    /* 自定义折叠按钮 */
    .collapse-trigger-box {
      padding: 12px;
      border-top: 1px solid #f1f5f9;
      display: flex;
      justify-content: center;

      .collapse-trigger {
        width: 100%;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 8px;
        cursor: pointer;
        color: #64748b;
        background-color: #f8fafc;
        transition: all 0.3s $qw-ease;

        &:hover {
          background-color: #f1f5f9;
          color: var(--el-color-primary);
        }
      }
    }
  }

  /* 核心优化：胶囊悬浮式菜单项，科技感 */
  :deep(.el-menu-item),
  :deep(.el-sub-menu__title) {
    height: 48px;
    line-height: 48px;
    margin: 4px 12px; /* 关键：四周留白，呈现胶囊悬浮感 */
    border-radius: 8px; /* 柔和圆角 */
    color: #64748b;
    transition: all 0.3s $qw-ease; /* 全局Quart曲线 */
    position: relative;
    overflow: hidden;
    left: 0;

    &.is-active {
      background-color: var(--el-color-primary-light-9);
      color: var(--el-color-primary);
      font-weight: 600;
      box-shadow: 0 4px 12px rgba(var(--el-color-primary-rgb), 0.1); /* 柔和光晕 */

      /* 激活时的右侧微妙指示条 */
      &::before {
        content: '';
        position: absolute;
        right: -12px;
        top: 50%;
        transform: translateY(-50%);
        height: 50%;
        width: 3px;
        background-color: var(--el-color-primary);
        border-radius: 4px;
        transition: all 0.3s $qw-ease;
      }
    }

    &:hover:not(.is-active) {
      background-color: #f1f5f9;
      color: var(--el-color-primary);
      /* 微动效：悬浮时水平微移 */
      left: 3px;
    }

    /* Icon 细节 */
    .el-icon {
      font-size: 18px;
      transition: all 0.3s $qw-ease;
      color: #94a3b8;
    }
    &.is-active .el-icon { color: var(--el-color-primary); }
  }

  /* 子菜单适配 */
  :deep(.el-sub-menu) {
    .el-menu-item {
      height: 44px;
      line-height: 44px;
      margin: 2px 12px 2px 24px; /* 缩进，增强层次感 */
      padding-left: 20px !important;
    }
  }

  .main-content-wrapper {
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }

  /* 顶部 Header：科技感重刷 */
  .global-brand-header {
    height: 72px; /* 缩减高度，精致 */
    padding: 0 32px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    color: #fff;
    z-index: 100;
    position: relative;
    overflow: hidden;

    /* 品牌背景重刷：更强的蓝灰科技渐变，降低透明度增加毛玻璃感 */
    background-image:
      linear-gradient(135deg, rgba(44, 62, 80, 0.55) 0%, rgba(75, 108, 183, 0.55) 100%),
      var(--header-bg);
    background-size: cover;
    background-position: center;

    /* 核心：高斯模糊毛玻璃效果 */
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
    border-bottom: 1px solid rgba(255, 255, 255, 0.08); /* 极细的光亮边框 */
  }

  .brand-left-area {
    display: flex;
    align-items: center;
    gap: 20px;
    position: relative;
    z-index: 2;

    .logo-wrapper {
      /* 圆角玻璃拟态 */
      background: rgba(255, 255, 255, 0.1);
      width: 46px;
      height: 46px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      border: 1px solid rgba(255,255,255,0.15);
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      backdrop-filter: blur(4px);

      .brand-logo {
        width: 100%;
        height: 100%;
        object-fit: contain; /* 改为 contain，防止 logo 变形 */
        padding: 4px; /* 留白 */
      }
    }

    .brand-info {
      display: flex;
      flex-direction: column;
      justify-content: center;

      .brand-title {
        font-size: 20px; /* 精致化 */
        font-weight: 600;
        margin: 0;
        letter-spacing: 1.5px;
        text-shadow: 0 2px 4px rgba(0,0,0,0.3);
      }

      .brand-subtitle {
        font-size: 11px;
        opacity: 0.85;
        font-weight: 400;
        letter-spacing: 1px;
        margin-top: 2px;
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
      font-size: 14px;
      color: rgba(255, 255, 255, 0.9);

      strong {
        color: #fff;
        font-weight: 600;
        margin-left: 4px;
        letter-spacing: 0.5px;
      }
    }

    .user-profile-trigger {
      display: flex;
      align-items: center;
      gap: 8px;
      cursor: pointer;
      padding: 4px 10px 4px 4px;
      border-radius: 30px;
      transition: all 0.3s $qw-ease;
      background: rgba(255,255,255,0.1);
      border: 1px solid rgba(255,255,255,0.1);

      &:hover {
        background: rgba(255, 255, 255, 0.2);
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      }

      .user-dropdown-icon {
        color: rgba(255,255,255,0.9);
        font-size: 14px;
      }
    }
  }

  /* 内容区域细节优化 */
  .el-main {
    padding: 24px;
    overflow-y: auto;
    background-color: $qw-bg-color;

    /* 这里是未来 router-view 的内容，可以加一个白底卡片包裹层 */
    & > * {
      background: #ffffff;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03); /* 柔和阴影 */
      padding: 24px;
      min-height: 100%;
      overflow: hidden;
    }
  }

  /* 丝滑的页面切换动画 (Fade-Transform) */
  .fade-transform-leave-active,
  .fade-transform-enter-active {
    transition: all 0.4s $qw-ease;
  }

  .fade-transform-enter-from {
    opacity: 0;
    transform: translateY(15px); /* 向上淡入 */
  }

  .fade-transform-leave-to {
    opacity: 0;
    transform: translateY(-15px); /* 向上淡出 */
  }

  .el-footer {
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 13px;
    color: #94a3b8;
    background-color: $qw-bg-color;
    border-top: 1px solid rgba(228, 231, 237, 0.6);
    height: 48px;
  }

  /* 移动端端适配细节 */
  @media (max-width: 768px) {
    .global-brand-header {
      height: 60px;
      padding: 0 16px;
    }
    .brand-subtitle { display: none; }
    .brand-title { font-size: 16px !important; }
    .welcome-text { display: none; }
    .brand-left-area .logo-wrapper { width: 36px; height: 36px; padding: 2px; }
  }
}

/* 优化 Dropdown 样式，使其更优雅 */
.custom-dropdown {
  border-radius: 8px;
  overflow: hidden;
  .el-dropdown-menu__item {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 8px 16px;
    color: #64748b;
  }
  .logout-item {
    color: #ef4444;
    &:hover { background-color: #fef2f2; color: #dc2626; }
  }
}
</style>
