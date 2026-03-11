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
            <el-icon><Search /></el-icon>
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

    <el-container>
      <el-header>
        <div>欢迎：<strong>{{ userInfoStore.userInfo.loginName }}</strong></div>
        <el-dropdown placement="bottom-end" @command="handleCommand">
          <span class="el-dropdown__box">
            <el-avatar :src="userInfoStore.userInfo.advater ? userInfoStore.userInfo.advater : avatar" />
            <el-icon><CaretBottom /></el-icon>
          </span>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item
                v-if="showPersonalCenter"
                command="info"
                :icon="User"
              >
                基本资料
              </el-dropdown-item>
              <el-dropdown-item
                v-if="showPersonalCenter"
                command="resetPassword"
                :icon="EditPen"
              >
                重置密码
              </el-dropdown-item>
              <el-dropdown-item command="logout" :icon="SwitchButton">退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </el-header>

      <el-main>
        <router-view />
      </el-main>

      <el-footer>学业预警系统 ©2025</el-footer>
    </el-container>
  </el-container>
</template>

<style lang="scss" scoped>
.layout-container {
  height: 100vh;

  .el-aside {
    background-color: #232323;

    &__logo {
      height: 120px;
      background: url('../assets/login_title.png') no-repeat center / 120px auto;
    }

    .el-menu {
      border-right: none;
    }
  }

  .el-header {
    background-color: #fff;
    display: flex;
    align-items: center;
    justify-content: space-between;

    .el-dropdown__box {
      display: flex;
      align-items: center;

      .el-icon {
        color: #999;
        margin-left: 10px;
      }

      &:active,
      &:focus {
        outline: none;
      }
    }
  }

  .el-footer {
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    color: #666;
  }
}
.el-menu-vertical-demo:not(.el-menu--collapse) {
  width: 200px;
  min-height: 400px;
}
</style>
