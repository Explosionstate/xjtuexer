<script setup>
import {CaretBottom, EditPen, Promotion, SwitchButton, TrendCharts, User, Search, Link, UserFilled, WarnTriangleFilled, Document, Tickets, SuccessFilled, DataLine, DArrowRight, DArrowLeft, Odometer} from '@element-plus/icons-vue'
import avatar from '@/assets/default.png'
import {userInfoService} from "@/api/user";
import {useUserInfoStore} from "@/stores/userInfo";
import {useRouter} from "vue-router";
import {ElMessage, ElMessageBox} from "element-plus";
import {getCurUser} from "@/api/api";
import {ref} from "vue";

const userInfoStore = useUserInfoStore();

const getUserInfo = () => {
  getCurUser().then(res => {
    if (!res.data) {
      ElMessage({
        message: '暂未登录请先登录',
        type: 'warning',
      })
      router.push({path: '/login'})
    } else {
      userInfoStore.setUserInfo(res.data)
    }
  })
}
getUserInfo()

const router = useRouter();
const handleCommand = (command) => {
  if (command === 'logout') {
    ElMessageBox.confirm(
        '你确认要退出吗？',
        '温馨提示',
        {
          confirmButtonText: '确认',
          cancelButtonText: '取消',
          type: 'warning'
        }
    ).then(
        async () => {
          userInfoStore.removeUserInfo()
          ElMessage.success("退出成功")
          await router.push('/login')
        }
    )
  } else {
    router.push('/user/' + command)
  }
}
const isCollapse = ref(true)
const handleOpen = (key, keyPath) => {
  console.log(key, keyPath)
}
const handleClose = (key, keyPath) => {
  console.log(key, keyPath)
}
</script>

<template>
  <el-container class="layout-container">
    <!-- 左侧菜单 -->
    <el-menu
        default-active="2"
        class="el-menu-vertical-demo"
        :collapse="isCollapse"
        @open="handleOpen"
        @close="handleClose"
        router
    >
      <el-menu-item index="/user/list">
        <el-tooltip :content="isCollapse ? '用户管理' : ''" placement="right">
          <el-icon><Promotion/></el-icon>
        </el-tooltip>
        <span>用户管理</span>
      </el-menu-item>
      <el-menu-item index="/user/count">
        <el-tooltip :content="isCollapse ? 'ai助力教学' : ''" placement="right">
          <el-icon><User/></el-icon>
        </el-tooltip>
        <span>ai助力教学</span>
      </el-menu-item>
      <el-menu-item index="/user/jiashicang">
        <el-tooltip :content="isCollapse ? '驾驶舱' : ''" placement="right">
          <el-icon><Odometer /></el-icon>
        </el-tooltip>
        <span>驾驶舱</span>
      </el-menu-item>
      <el-sub-menu>
        <template #title>
          <el-tooltip :content="isCollapse ? '个人中心' : ''" placement="right">
            <el-icon><UserFilled/></el-icon>
          </el-tooltip>
          <span>个人中心</span>
        </template>
        <el-menu-item index="/user/info">
          <el-icon><User/></el-icon>
          <span>基本资料</span>
        </el-menu-item>
        <el-menu-item index="/user/resetPassword">
          <el-icon><EditPen/></el-icon>
          <span>重置密码</span>
        </el-menu-item>
      </el-sub-menu>
      <el-menu-item index="/user/learning">
        <el-tooltip :content="isCollapse ? '在线学习' : ''" placement="right">
          <el-icon><Odometer /></el-icon>
        </el-tooltip>
        <span>在线学习</span>
      </el-menu-item>
      <el-menu-item index="/user/studentList">
        <el-tooltip :content="isCollapse ? '学情预警' : ''" placement="right">
          <el-icon><WarnTriangleFilled/></el-icon>
        </el-tooltip>
        <span>学情预警</span>
      </el-menu-item>
      <el-sub-menu>
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
      <el-radio-group v-model="isCollapse" style="margin-bottom: 40px; width:80px">
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

    <!-- 右侧主区域 -->
    <el-container>
      <!-- 头部区域 -->
      <el-header>
        <div>欢迎：<strong>{{ userInfoStore.userInfo.loginName }}</strong></div>
        <el-dropdown placement="bottom-end" @command="handleCommand">
          <span class="el-dropdown__box">
            <el-avatar :src="userInfoStore.userInfo.advater?userInfoStore.userInfo.advater:avatar"/>
            <el-icon><CaretBottom/></el-icon>
          </span>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="info" :icon="User">基本资料</el-dropdown-item>
              <el-dropdown-item command="resetPassword" :icon="EditPen">重置密码</el-dropdown-item>
              <el-dropdown-item command="logout" :icon="SwitchButton">退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </el-header>
      <!-- 中间区域 -->
      <el-main>
        <router-view/>
      </el-main>
      <!-- 底部区域 -->
      <el-footer>学业预警系统 ©2025 </el-footer>
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
      background: url('@/assets/login_title.png') no-repeat center / 120px auto;
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