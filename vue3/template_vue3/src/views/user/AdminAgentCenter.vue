<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import {
  User,
  DataAnalysis,
  EditPen,
  WarnTriangleFilled,
  DocumentCopy,
  ChatDotRound,
  ArrowRight,
  TopRight
} from '@element-plus/icons-vue'
import { getSsoTicket } from '@/api/api'
import { useUserInfoStore } from '@/stores/userInfo'
import { ADMIN_AGENT_MODULES, AGENT_WORKSPACE_BASE_URL } from '@/constants/adminAgents'

const userInfoStore = useUserInfoStore()
const router = useRouter()

const redirectingToAi = ref(false)

const iconComponentMap = {
  User,
  DataAnalysis,
  EditPen,
  WarnTriangleFilled,
  DocumentCopy,
  ChatDotRound
}

const isAdmin = computed(() => {
  const role = userInfoStore.userInfo?.role
  return role !== 'teacher' && role !== 'student'
})

const redirectIfUnauthorized = async () => {
  ElMessage.error('仅管理员可以访问智能体管理中心')
  const role = userInfoStore.userInfo?.role
  const fallbackPath = role === 'teacher' || role === 'student' ? '/news' : '/user/list'
  await router.replace(fallbackPath)
}

const getIconComponent = (iconName) => iconComponentMap[iconName] || User

const openWorkbench = (agent, newWindow = false) => {
  const target = {
    name: 'AdminAgentWorkbench',
    params: { agentKey: agent.key }
  }
  const resolved = router.resolve(target)
  if (newWindow) {
    window.open(resolved.href, '_blank', 'noopener,noreferrer')
    return
  }
  router.push(target)
}

const jumpToGeneralAi = async () => {
  if (redirectingToAi.value) {
    return
  }
  redirectingToAi.value = true
  try {
    const res = await getSsoTicket()
    const ticket = res?.data?.ticket
    if (!ticket) {
      throw new Error('获取 AI 登录票据失败')
    }
    const url = new URL(AGENT_WORKSPACE_BASE_URL)
    url.searchParams.set('sso_ticket', ticket)
    url.searchParams.set('entry', 'admin-agent-center-dashboard')
    window.open(url.toString(), '_blank', 'noopener,noreferrer')
  } catch (error) {
    ElMessage.error(error?.message || '跳转 AI 系统失败，请稍后重试')
  } finally {
    redirectingToAi.value = false
  }
}

onMounted(async () => {
  if (!isAdmin.value) {
    await redirectIfUnauthorized()
  }
})
</script>

<template>
  <div class="agent-dashboard-page">
    <section class="dashboard-shell">
      <div class="dashboard-head">
        <div>
          <h2>智能体中心 <span>AI-POWERED AGENTS</span></h2>
          <p>管理员专属智能体工作台，支持多模块独立调试与优化。</p>
        </div>
        <el-button type="primary" :loading="redirectingToAi" @click="jumpToGeneralAi">
          {{ redirectingToAi ? '正在进入 AI 助手...' : '进入 AI 助手（单点登录）' }}
        </el-button>
      </div>

      <div class="agent-grid">
        <article
          v-for="agent in ADMIN_AGENT_MODULES"
          :key="agent.key"
          class="agent-card"
          @click="openWorkbench(agent, false)"
        >
          <div class="card-main">
            <div class="icon-shell" :style="{ '--icon-color': agent.iconColor }">
              <component :is="getIconComponent(agent.icon)" class="agent-icon" />
            </div>
            <div class="text-block">
              <h3>{{ agent.title }}</h3>
              <p>{{ agent.subtitle }}</p>
            </div>
          </div>

          <div class="card-actions">
            <el-button text type="primary" @click.stop="openWorkbench(agent, false)">
              进入工作台
              <el-icon><ArrowRight /></el-icon>
            </el-button>
            <el-button text @click.stop="openWorkbench(agent, true)">
              独立窗口
              <el-icon><TopRight /></el-icon>
            </el-button>
          </div>
        </article>
      </div>

      <div class="dashboard-foot">
        点击任一智能体即可进入对应独立调试空间；不同智能体会加载不同的默认参数与测试场景。
      </div>
    </section>
  </div>
</template>

<style scoped>
.agent-dashboard-page {
  min-height: calc(100vh - 220px);
  padding: 8px 0 4px;
  max-width: 1640px;
  margin: 0 auto;
}

.dashboard-shell {
  background: linear-gradient(180deg, #eff2f8 0%, #eceff5 100%);
  border: 1px solid #e1e5ee;
  border-radius: 24px;
  padding: 24px 22px 18px;
}

.dashboard-head {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  align-items: flex-start;
  margin-bottom: 20px;
}

.dashboard-head h2 {
  margin: 0;
  font-size: 34px;
  line-height: 1;
  color: #151515;
  font-weight: 700;
}

.dashboard-head h2 span {
  margin-left: 10px;
  font-size: 15px;
  letter-spacing: 0.8px;
  color: #7b8492;
  font-weight: 500;
}

.dashboard-head p {
  margin: 10px 0 0;
  color: #5d6675;
  font-size: 14px;
}

.agent-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(220px, 1fr));
  gap: 14px;
}

.agent-card {
  background: #f7f9fc;
  border: 1px solid #dce1ea;
  border-radius: 14px;
  padding: 16px 16px 10px;
  cursor: pointer;
  transition: all 0.22s ease;
}

.agent-card:hover {
  transform: translateY(-2px);
  border-color: #a7c3f6;
  box-shadow: 0 8px 16px rgba(56, 114, 199, 0.12);
}

.card-main {
  display: flex;
  align-items: center;
  gap: 14px;
}

.icon-shell {
  width: 68px;
  height: 68px;
  border-radius: 16px;
  background: #e6e8ee;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--icon-color);
  flex-shrink: 0;
}

.agent-icon {
  width: 30px;
  height: 30px;
}

.text-block {
  min-width: 0;
}

.text-block h3 {
  margin: 0;
  font-size: 28px;
  color: #32353b;
  font-weight: 700;
  line-height: 1.2;
}

.text-block p {
  margin: 8px 0 0;
  font-size: 17px;
  color: #858d99;
  line-height: 1.3;
}

.card-actions {
  margin-top: 8px;
  display: flex;
  justify-content: flex-end;
  gap: 4px;
}

.dashboard-foot {
  margin-top: 10px;
  font-size: 12px;
  color: #6f7885;
}

.dashboard-head :deep(.el-button) {
  border-radius: 10px;
  padding: 10px 16px;
  font-size: 14px;
}

@media (max-width: 1300px) {
  .dashboard-head h2 {
    font-size: 30px;
  }

  .text-block h3 {
    font-size: 24px;
  }

  .text-block p {
    font-size: 15px;
  }
}

@media (max-width: 1100px) {
  .agent-grid {
    grid-template-columns: repeat(2, minmax(220px, 1fr));
  }

  .dashboard-head {
    flex-direction: column;
  }
}

@media (max-width: 768px) {
  .agent-grid {
    grid-template-columns: 1fr;
  }

  .dashboard-shell {
    border-radius: 16px;
    padding: 18px 14px;
  }

  .dashboard-head h2 {
    font-size: 24px;
  }

  .dashboard-head h2 span {
    display: block;
    margin: 8px 0 0;
  }

  .icon-shell {
    width: 70px;
    height: 70px;
    border-radius: 16px;
  }

  .agent-icon {
    width: 28px;
    height: 28px;
  }

  .text-block h3 {
    font-size: 20px;
  }

  .text-block p {
    font-size: 14px;
    margin-top: 8px;
  }
}
</style>
