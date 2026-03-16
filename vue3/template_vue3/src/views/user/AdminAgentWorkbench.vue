<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Refresh, TopRight, Back, MagicStick } from '@element-plus/icons-vue'
import { getSsoTicket } from '@/api/api'
import { useUserInfoStore } from '@/stores/userInfo'
import {
  AGENT_WORKSPACE_BASE_URL,
  getAdminAgentByKey
} from '@/constants/adminAgents'

const route = useRoute()
const router = useRouter()
const userInfoStore = useUserInfoStore()

const loading = ref(false)
const frameLoading = ref(false)
const frameKey = ref(0)
const errorMessage = ref('')
const workspaceUrl = ref('')
const actionLogs = ref([])

const debugForm = reactive({
  useQwen: true,
  useWs: false,
  retrievalTopK: 8,
  scoreThreshold: 0.2,
  fusionMode: 'weighted',
  alpha: 0.6,
  initialPrompt: ''
})

const isAdmin = computed(() => {
  const role = userInfoStore.userInfo?.role
  return role !== 'teacher' && role !== 'student'
})

const currentAgent = computed(() => getAdminAgentByKey(route.params.agentKey))

const pushLog = (message) => {
  actionLogs.value.unshift({
    id: Date.now() + Math.floor(Math.random() * 1000),
    message,
    time: new Date().toLocaleTimeString()
  })
  if (actionLogs.value.length > 16) {
    actionLogs.value = actionLogs.value.slice(0, 16)
  }
}

const redirectIfUnauthorized = async () => {
  ElMessage.error('仅管理员可以访问智能体管理中心')
  const role = userInfoStore.userInfo?.role
  const fallbackPath = role === 'teacher' || role === 'student' ? '/news' : '/user/list'
  await router.replace(fallbackPath)
}

const applyAgentDefaults = () => {
  const agent = currentAgent.value
  if (!agent) {
    return
  }
  const defaults = agent.debugDefaults
  debugForm.useQwen = defaults.useQwen
  debugForm.useWs = defaults.useWs
  debugForm.retrievalTopK = defaults.retrievalTopK
  debugForm.scoreThreshold = defaults.scoreThreshold
  debugForm.fusionMode = defaults.fusionMode
  debugForm.alpha = defaults.alpha
  debugForm.initialPrompt = defaults.initialPrompt
  pushLog(`已加载 ${agent.title} 默认调试参数`)
}

const buildWorkspaceUrl = (ticket) => {
  const agent = currentAgent.value
  const url = new URL(AGENT_WORKSPACE_BASE_URL)
  url.searchParams.set('sso_ticket', ticket)
  url.searchParams.set('entry', 'admin-agent-workbench')
  url.searchParams.set('agent_key', agent.key)
  url.searchParams.set('agent_title', `${agent.title}工作台`)
  url.searchParams.set('agent_empty_title', `你好，我是${agent.title}`)
  url.searchParams.set('agent_empty_desc', agent.description)
  url.searchParams.set('preset_question', debugForm.initialPrompt)
  url.searchParams.set('conversation_id', `agent-${agent.key}-${Date.now()}`)
  url.searchParams.set('use_qwen', debugForm.useQwen ? '1' : '0')
  url.searchParams.set('use_ws', debugForm.useWs ? '1' : '0')
  url.searchParams.set('retrieval_top_k', String(debugForm.retrievalTopK))
  url.searchParams.set('score_threshold', String(debugForm.scoreThreshold))
  url.searchParams.set('fusion_mode', debugForm.fusionMode)
  url.searchParams.set('alpha', String(debugForm.alpha))
  return url.toString()
}

const loadWorkspace = async (reason = '刷新工作台') => {
  if (!isAdmin.value) {
    await redirectIfUnauthorized()
    return
  }
  const agent = currentAgent.value
  if (!agent) {
    ElMessage.error('未识别智能体模块，已返回管理中心')
    await router.replace('/admin/agent-center')
    return
  }
  loading.value = true
  frameLoading.value = true
  errorMessage.value = ''
  try {
    const res = await getSsoTicket()
    const ticket = res?.data?.ticket
    if (!ticket) {
      throw new Error('未获取到单点登录票据，请稍后重试')
    }
    workspaceUrl.value = buildWorkspaceUrl(ticket)
    frameKey.value += 1
    pushLog(`${reason}：${agent.title}`)
  } catch (error) {
    errorMessage.value = error?.message || '智能体工作台加载失败'
    frameLoading.value = false
    ElMessage.error(errorMessage.value)
  } finally {
    loading.value = false
  }
}

const handleFrameLoaded = () => {
  frameLoading.value = false
}

const applyDebugSettings = async () => {
  await loadWorkspace('应用调试参数')
}

const runTestCase = async (caseText) => {
  debugForm.initialPrompt = caseText
  pushLog('已选择测试用例并重载工作台')
  await loadWorkspace('执行测试用例')
}

const resetToDefaults = async () => {
  applyAgentDefaults()
  await loadWorkspace('恢复默认参数')
}

const openStandaloneWorkspace = () => {
  if (!workspaceUrl.value) {
    ElMessage.warning('工作台尚未就绪，请先加载')
    return
  }
  window.open(workspaceUrl.value, '_blank', 'noopener,noreferrer')
}

const goBackCenter = () => {
  router.push('/admin/agent-center')
}

watch(
  () => route.params.agentKey,
  async () => {
    if (!isAdmin.value) {
      await redirectIfUnauthorized()
      return
    }
    if (!currentAgent.value) {
      ElMessage.error('无效的智能体模块，已返回管理中心')
      await router.replace('/admin/agent-center')
      return
    }
    applyAgentDefaults()
    await loadWorkspace('初始化工作台')
  },
  { immediate: true }
)

onMounted(async () => {
  if (!isAdmin.value) {
    await redirectIfUnauthorized()
  }
})
</script>

<template>
  <div class="workbench-page">
    <el-card shadow="never" class="head-card">
      <div class="head-main">
        <div>
          <div class="head-breadcrumb" @click="goBackCenter">
            <el-icon><Back /></el-icon>
            返回智能体管理中心
          </div>
          <h2>{{ currentAgent?.title || '智能体工作台' }}</h2>
          <p>{{ currentAgent?.description || '管理员独立调试空间' }}</p>
        </div>
        <div class="head-actions">
          <el-button type="primary" :icon="MagicStick" @click="applyDebugSettings" :loading="loading">
            应用调试参数
          </el-button>
          <el-button :icon="Refresh" @click="loadWorkspace('手动刷新')" :loading="loading">刷新工作台</el-button>
          <el-button :icon="TopRight" @click="openStandaloneWorkspace" :disabled="!workspaceUrl">
            独立窗口
          </el-button>
        </div>
      </div>
    </el-card>

    <div class="workbench-grid">
      <el-card shadow="never" class="side-card">
        <template #header>
          <div class="card-title">参数调试面板</div>
        </template>

        <el-form label-position="top" class="debug-form">
          <el-form-item label="初始测试问题">
            <el-input
              v-model="debugForm.initialPrompt"
              type="textarea"
              :rows="3"
              placeholder="输入该智能体本次调试的问题或任务目标"
            />
          </el-form-item>

          <div class="switch-row">
            <el-switch v-model="debugForm.useQwen" />
            <span>启用 Qwen 生成增强</span>
          </div>
          <div class="switch-row">
            <el-switch v-model="debugForm.useWs" />
            <span>启用 WebSocket 流式</span>
          </div>

          <el-form-item label="召回数量 Top-K">
            <el-input-number v-model="debugForm.retrievalTopK" :min="1" :max="50" />
          </el-form-item>

          <el-form-item label="评分阈值">
            <el-input-number v-model="debugForm.scoreThreshold" :min="0" :max="1" :step="0.01" />
          </el-form-item>

          <el-form-item label="融合模式">
            <el-select v-model="debugForm.fusionMode">
              <el-option label="weighted" value="weighted" />
              <el-option label="rrf" value="rrf" />
            </el-select>
          </el-form-item>

          <el-form-item label="融合系数 Alpha">
            <el-input-number v-model="debugForm.alpha" :min="0" :max="1" :step="0.01" />
          </el-form-item>

          <div class="debug-actions">
            <el-button type="primary" @click="applyDebugSettings" :loading="loading">应用并重载</el-button>
            <el-button @click="resetToDefaults" :loading="loading">恢复默认</el-button>
          </div>
        </el-form>
      </el-card>

      <el-card shadow="never" class="workspace-card">
        <template #header>
          <div class="card-title">独立智能体工作窗口</div>
        </template>

        <div class="workspace-shell">
          <el-result
            v-if="errorMessage"
            icon="error"
            title="工作台加载失败"
            :sub-title="errorMessage"
          >
            <template #extra>
              <el-button type="primary" @click="loadWorkspace('重试加载')">重试加载</el-button>
            </template>
          </el-result>

          <template v-else>
            <iframe
              v-if="workspaceUrl"
              :key="frameKey"
              class="workspace-iframe"
              :src="workspaceUrl"
              frameborder="0"
              :title="`${currentAgent?.title || '智能体'}独立窗口`"
              allow="clipboard-read; clipboard-write"
              @load="handleFrameLoaded"
            />
            <div v-else class="workspace-empty">正在准备智能体独立窗口...</div>
            <div v-if="loading || frameLoading" class="workspace-mask">
              <el-skeleton :rows="10" animated />
            </div>
          </template>
        </div>
      </el-card>

      <el-card shadow="never" class="side-card">
        <template #header>
          <div class="card-title">测试与优化</div>
        </template>

        <div class="test-section">
          <h4>场景测试用例</h4>
          <div class="test-list">
            <button
              v-for="item in currentAgent?.testCases || []"
              :key="item"
              class="test-item"
              @click="runTestCase(item)"
            >
              {{ item }}
            </button>
          </div>
        </div>

        <div class="test-section">
          <h4>优化建议</h4>
          <ul class="tips-list">
            <li v-for="tip in currentAgent?.optimizationTips || []" :key="tip">{{ tip }}</li>
          </ul>
        </div>

        <div class="test-section">
          <h4>操作日志</h4>
          <div class="log-list">
            <div v-for="log in actionLogs" :key="log.id" class="log-item">
              <span class="time">{{ log.time }}</span>
              <span>{{ log.message }}</span>
            </div>
          </div>
        </div>
      </el-card>
    </div>
  </div>
</template>

<style scoped>
.workbench-page {
  min-height: calc(100vh - 220px);
  display: flex;
  flex-direction: column;
  gap: 10px;
  max-width: 1680px;
  margin: 0 auto;
}

.head-card {
  border-radius: 12px;
  border: 1px solid #dce3ef;
  background: #f8faff;
}

.head-main {
  display: flex;
  justify-content: space-between;
  gap: 10px;
  align-items: flex-start;
}

.head-breadcrumb {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  color: #467bce;
  cursor: pointer;
  margin-bottom: 6px;
  font-size: 13px;
}

.head-main h2 {
  margin: 0;
  font-size: 22px;
  color: #243041;
}

.head-main p {
  margin: 6px 0 0;
  color: #5f6c80;
  font-size: 13px;
  line-height: 1.4;
}

.head-actions {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

.workbench-grid {
  flex: 1;
  min-height: 0;
  display: grid;
  grid-template-columns: 280px 1fr 300px;
  gap: 10px;
}

.side-card,
.workspace-card {
  border-radius: 12px;
  border: 1px solid #dce3ef;
}

.card-title {
  font-size: 14px;
  font-weight: 600;
  color: #314258;
}

.debug-form {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.switch-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 10px;
  color: #40546d;
  font-size: 13px;
}

.debug-actions {
  display: flex;
  gap: 6px;
}

.workspace-shell {
  min-height: 600px;
  position: relative;
  border-radius: 8px;
  overflow: hidden;
  background: #ffffff;
  border: 1px solid #e4e9f2;
}

.workspace-iframe {
  width: 100%;
  height: 100%;
  min-height: 600px;
  border: 0;
  display: block;
}

.workspace-empty {
  min-height: 600px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #758297;
  font-size: 14px;
}

.workspace-mask {
  position: absolute;
  inset: 0;
  background: rgba(255, 255, 255, 0.92);
  padding: 14px;
}

.test-section {
  margin-bottom: 14px;
}

.test-section h4 {
  margin: 0 0 8px;
  color: #314258;
  font-size: 14px;
}

.test-list {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.test-item {
  text-align: left;
  border: 1px solid #d8e2f1;
  background: #f8fbff;
  border-radius: 8px;
  padding: 8px 9px;
  color: #3d4d63;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 13px;
}

.test-item:hover {
  border-color: #89afef;
  background: #eef5ff;
}

.tips-list {
  margin: 0;
  padding-left: 16px;
  color: #566578;
  font-size: 13px;
}

.tips-list li {
  margin-bottom: 6px;
  line-height: 1.4;
}

.log-list {
  max-height: 190px;
  overflow-y: auto;
  border: 1px solid #e2e8f2;
  border-radius: 8px;
  padding: 7px;
  background: #f8fafd;
}

.log-item {
  font-size: 11px;
  color: #5a6678;
  margin-bottom: 6px;
  line-height: 1.4;
  display: grid;
  gap: 2px;
}

.log-item .time {
  color: #8a96a8;
}

@media (max-width: 1600px) {
  .workbench-grid {
    grid-template-columns: 260px 1fr 280px;
  }
}

@media (max-width: 1200px) {
  .workbench-grid {
    grid-template-columns: 1fr;
  }

  .workspace-shell,
  .workspace-iframe,
  .workspace-empty {
    min-height: 500px;
  }
}

.head-actions :deep(.el-button) {
  border-radius: 8px;
  padding: 8px 12px;
  font-size: 13px;
}
</style>
