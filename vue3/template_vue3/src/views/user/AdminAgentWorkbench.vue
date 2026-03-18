<template>
  <div class="workbench-container">
    <div class="workbench-header">
      <div class="header-left">
        <el-button
            type="text"
            class="back-btn"
            @click="goBackCenter"
        >
          <i class="el-icon-back"></i>
          <span>返回智能体管理中心</span>
        </el-button>
      </div>
      <div class="header-center">
        <div class="agent-info">
          <div class="agent-icon">
            <i class="el-icon-magic-stick"></i>
          </div>
          <div>
            <h2 class="agent-title">{{ currentAgent?.title || '智能体工作台' }}</h2>
            <p class="agent-desc">{{ currentAgent?.description || '管理员独立调试空间' }}</p>
          </div>
        </div>
      </div>

      <div class="header-right">
        <el-button-group>
          <el-button
              type="primary"
              :icon="MagicStick"
              @click="applyDebugSettings"
              :loading="loading"
              class="action-btn"
          >
            应用调试参数
          </el-button>
          <el-button
              :icon="Refresh"
              @click="loadWorkspace('手动刷新')"
              :loading="loading"
              class="action-btn"
          >
            刷新工作台
          </el-button>
          <el-button
              :icon="TopRight"
              @click="openStandaloneWorkspace"
              :disabled="!workspaceUrl"
              class="action-btn"
          >
            独立窗口
          </el-button>
        </el-button-group>
      </div>
    </div>
    <div class="workbench-main">
      <el-card class="panel-left" shadow="never">
        <div class="panel-header">
          <div class="panel-title">
            <i class="el-icon-setting"></i>
            参数调试面板
          </div>
          <el-tag type="info" size="small">实时调试</el-tag>
        </div>

        <div class="debug-form-wrapper">
          <el-form label-position="top" class="debug-form">
            <div class="form-section">
              <div class="section-label">
                <i class="el-icon-chat-dot-square"></i>
                初始测试问题
              </div>
              <el-input
                  v-model="debugForm.initialPrompt"
                  type="textarea"
                  :rows="3"
                  placeholder="请基于知识库内容生成本月学情报告（含关键结论与建议）"
                  class="custom-textarea"
                  resize="none"
              />
            </div>
            <div class="form-section">
              <div class="section-label">
                <i class="el-icon-switch"></i>
                功能开关
              </div>
              <div class="switch-group">
                <div class="switch-item">
                  <el-switch
                      v-model="debugForm.useQwen"
                      active-color="#13ce66"
                      inactive-color="#dcdfe6"
                  />
                  <span>启用 Qwen 生成增强</span>
                  <el-tag v-if="debugForm.useQwen" type="success" size="small" effect="light">已启用</el-tag>
                </div>
                <div class="switch-item">
                  <el-switch
                      v-model="debugForm.useWs"
                      active-color="#13ce66"
                      inactive-color="#dcdfe6"
                  />
                  <span>启用 WebSocket 流式</span>
                  <el-tag v-if="debugForm.useWs" type="success" size="small" effect="light">已启用</el-tag>
                </div>
              </div>
            </div>

            <div class="form-section">
              <div class="section-label">
                <i class="el-icon-connection"></i>
                检索参数调优
              </div>
              <div class="param-group">
                <div class="param-item">
                  <span class="param-label">召回数量 Top-K</span>
                  <div class="param-control">
                    <el-slider
                        v-model="debugForm.retrievalTopK"
                        :min="1"
                        :max="20"
                        :step="1"
                        show-stops
                        class="custom-slider"
                    />
                    <span class="param-value">{{ debugForm.retrievalTopK }}</span>
                  </div>
                </div>

                <div class="param-item">
                  <span class="param-label">评分阈值</span>
                  <div class="param-control">
                    <el-slider
                        v-model="debugForm.scoreThreshold"
                        :min="0"
                        :max="1"
                        :step="0.1"
                        :format-tooltip="val => val.toFixed(1)"
                        class="custom-slider"
                    />
                    <span class="param-value">{{ debugForm.scoreThreshold.toFixed(2) }}</span>
                  </div>
                </div>
              </div>
            </div>
            <div class="form-section">
              <div class="section-label">
                <i class="el-icon-c-scale-to-original"></i>
                融合参数配置
              </div>
              <div class="fusion-group">
                <div class="fusion-item">
                  <span class="param-label">融合模式</span>
                  <el-select
                      v-model="debugForm.fusionMode"
                      class="fusion-select"
                      placeholder="选择融合模式"
                  >
                    <el-option label="weighted" value="weighted" />
                    <el-option label="rrf" value="rrf" />
                    <el-option label="simple" value="simple" />
                  </el-select>
                </div>

                <div class="fusion-item">
                  <span class="param-label">融合系数 Alpha</span>
                  <div class="param-control">
                    <el-slider
                        v-model="debugForm.alpha"
                        :min="0"
                        :max="1"
                        :step="0.05"
                        :format-tooltip="val => val.toFixed(2)"
                        class="custom-slider"
                    />
                    <span class="param-value">{{ debugForm.alpha.toFixed(2) }}</span>
                  </div>
                </div>
              </div>
            </div>
            <div class="form-actions">
              <el-button
                  type="primary"
                  @click="applyDebugSettings"
                  :loading="loading"
                  class="apply-btn"
              >
                <i class="el-icon-check"></i>
                应用并重载
              </el-button>
              <el-button
                  @click="resetToDefaults"
                  :loading="loading"
                  class="reset-btn"
              >
                <i class="el-icon-refresh"></i>
                恢复默认
              </el-button>
            </div>
          </el-form>
        </div>
      </el-card>

      <el-card class="panel-center" shadow="never">
        <div class="panel-header">
          <div class="panel-title">
            <i class="el-icon-monitor"></i>
            独立智能体工作窗口
            <el-tag v-if="currentAgent?.key" type="info" size="small" class="agent-id">
              {{ currentAgent.key }}
            </el-tag>
          </div>
          <div class="center-actions">
            <el-button
                type="text"
                size="small"
                @click="handleNewSession"
                class="new-session-btn"
            >
              <i class="el-icon-circle-plus"></i>
              新建会话
            </el-button>
            <el-tag type="warning" size="small" effect="light">点击"新建会话"会清空当前消息上下文</el-tag>
          </div>
        </div>

        <div class="workspace-wrapper">
          <div v-if="errorMessage" class="workspace-error">
            <el-result
                icon="error"
                title="工作台加载失败"
                :sub-title="errorMessage"
            >
              <template #extra>
                <el-button type="primary" @click="loadWorkspace('重试加载')">重试加载</el-button>
              </template>
            </el-result>
          </div>

          <div v-else class="workspace-container">
            <div class="console-panel">
              <div class="console-header">
                <span>控制台面板</span>
                <span class="console-subtitle">配置知识库、检索参数与调试信息</span>
              </div>

              <div class="console-content">
                <div class="console-section">
                  <div class="section-header">
                    <i class="el-icon-collection"></i>
                    <span>知识库管理</span>
                  </div>
                  <div class="section-desc">
                    创建、选择并启用知识库参与当前会话
                  </div>
                  <div class="kb-status">
                    <el-tag type="success" effect="light" class="kb-tag">
                      演示知识库
                    </el-tag>
                    <el-switch
                        v-model="knowledgeBaseEnabled"
                        active-color="#13ce66"
                        size="small"
                    />
                  </div>
                </div>

                <div class="console-section">
                  <div class="section-header">
                    <i class="el-icon-document"></i>
                    <span>当前会话</span>
                  </div>
                  <div class="session-info">
                    <el-tag type="info" effect="plain" class="session-id">
                      {{ sessionId }}
                    </el-tag>
                    <span class="session-desc">回答会优先参考当前文档片段</span>
                  </div>
                </div>

                <div class="console-section">
                  <div class="section-header">
                    <i class="el-icon-search"></i>
                    <span>文档片段管理</span>
                  </div>
                  <div class="fragment-info">
                    <el-progress
                        :percentage="75"
                        :show-text="false"
                        :stroke-width="6"
                        color="#409EFF"
                    />
                    <span class="fragment-text">已加载 15/20 个相关片段</span>
                  </div>
                </div>
              </div>
            </div>
            <div class="agent-workspace">
              <div v-if="workspaceUrl" class="workspace-frame">
                <iframe
                    :key="frameKey"
                    :src="workspaceUrl"
                    frameborder="0"
                    :title="`${currentAgent?.title || '智能体'}工作区`"
                    allow="clipboard-read; clipboard-write"
                    @load="handleFrameLoaded"
                    class="workspace-iframe"
                />
                <div v-if="loading || frameLoading" class="workspace-loading">
                  <div class="loading-content">
                    <i class="el-icon-loading loading-icon"></i>
                    <p>正在加载智能体工作区...</p>
                  </div>
                </div>
              </div>
              <div v-else class="workspace-placeholder">
                <div class="placeholder-content">
                  <i class="el-icon-chat-line-square placeholder-icon"></i>
                  <p class="placeholder-title">智能体工作区准备就绪</p>
                  <p class="placeholder-desc">配置参数后点击"应用调试参数"开始工作</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </el-card>
      <el-card class="panel-right" shadow="never">
        <div class="panel-header">
          <div class="panel-title">
            <i class="el-icon-aim"></i>
            测试与优化区
          </div>
          <el-tag type="info" size="small">智能优化</el-tag>
        </div>

        <div class="test-optimization-panel">
          <!-- 场景测试用例 -->
          <div class="test-section">
            <div class="section-header">
              <i class="el-icon-s-grid"></i>
              <span>场景测试用例</span>
            </div>
            <div class="test-cases">
              <div
                  v-for="(item, index) in testCases"
                  :key="index"
                  class="test-case-item"
                  @click="runTestCase(item.content)"
              >
                <div class="case-icon">
                  <i :class="item.icon"></i>
                </div>
                <div class="case-content">
                  <div class="case-title">{{ item.title }}</div>
                  <div class="case-desc">{{ item.content }}</div>
                </div>
              </div>
            </div>
          </div>

          <div class="optimization-section">
            <div class="section-header">
              <i class="el-icon-lightning"></i>
              <span>优化建议</span>
            </div>
            <div class="suggestions">
              <div
                  v-for="(tip, index) in optimizationTips"
                  :key="index"
                  class="suggestion-item"
                  :class="tip.level"
              >
                <div class="suggestion-icon">
                  <i :class="tip.icon"></i>
                </div>
                <div class="suggestion-content">
                  {{ tip.text }}
                </div>
              </div>
            </div>
          </div>

          <div class="log-section">
            <div class="section-header">
              <i class="el-icon-timer"></i>
              <span>操作日志</span>
            </div>
            <div class="log-list">
              <div
                  v-for="log in actionLogs"
                  :key="log.id"
                  class="log-item"
              >
                <div class="log-time">{{ log.time }}</div>
                <div class="log-message">{{ log.message }}</div>
              </div>
              <div v-if="actionLogs.length === 0" class="empty-log">
                暂无操作记录
              </div>
            </div>
          </div>
        </div>
      </el-card>
    </div>
  </div>
</template>

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
const knowledgeBaseEnabled = ref(true)
const sessionId = ref(`S${Date.now().toString().slice(-6)}`)

const LOCAL_DEBUG_KEY_PREFIX = 'xjtuexer_admin_agent_debug'

const debugForm = reactive({
  useQwen: true,
  useWs: false,
  retrievalTopK: 8,
  scoreThreshold: 0.2,
  fusionMode: 'weighted',
  alpha: 0.6,
  initialPrompt: ''
})

const testCases = [
  {
    icon: 'el-icon-document-checked',
    title: '报告生成',
    content: '输出"月度学情简报"模板（摘要/问题/建议）。'
  },
  {
    icon: 'el-icon-data-analysis',
    title: '对比分析',
    content: '请按学院维度生成对比分析段落。'
  },
  {
    icon: 'el-icon-tickets',
    title: '改进计划',
    content: '自动生成"下月改进行动清单"。'
  }
]

const optimizationTips = [
  {
    icon: 'el-icon-chat-line-round',
    level: 'important',
    text: '报告生成场景建议启用Qwen增强文本组织。'
  },
  {
    icon: 'el-icon-scale-to-original',
    level: 'warning',
    text: '较高alpha更利于证据一致性。'
  },
  {
    icon: 'el-icon-collection-tag',
    level: 'info',
    text: '建议固定模板提示词，提升输出可复用性。'
  }
]

const getDebugStorageKey = (agentKey) => `${LOCAL_DEBUG_KEY_PREFIX}:${agentKey}`

const loadLocalDebugSettings = (agentKey) => {
  if (!agentKey) return null
  try {
    const raw = localStorage.getItem(getDebugStorageKey(agentKey))
    if (!raw) return null
    const parsed = JSON.parse(raw)
    if (!parsed || typeof parsed !== 'object') return null
    return parsed
  } catch {
    return null
  }
}

const saveLocalDebugSettings = (agentKey) => {
  if (!agentKey) return
  const payload = {
    useQwen: debugForm.useQwen,
    useWs: debugForm.useWs,
    retrievalTopK: debugForm.retrievalTopK,
    scoreThreshold: debugForm.scoreThreshold,
    fusionMode: debugForm.fusionMode,
    alpha: debugForm.alpha,
    initialPrompt: debugForm.initialPrompt
  }
  localStorage.setItem(getDebugStorageKey(agentKey), JSON.stringify(payload))
}

const applyRawDefaults = (agent) => {
  const defaults = agent.debugDefaults
  debugForm.useQwen = defaults.useQwen
  debugForm.useWs = defaults.useWs
  debugForm.retrievalTopK = defaults.retrievalTopK
  debugForm.scoreThreshold = defaults.scoreThreshold
  debugForm.fusionMode = defaults.fusionMode
  debugForm.alpha = defaults.alpha
  debugForm.initialPrompt = defaults.initialPrompt
}

const isAdmin = computed(() => {
  const role = userInfoStore.userInfo?.role
  return role !== 'teacher' && role !== 'student'
})
const currentAgent = computed(() => getAdminAgentByKey(route.params.agentKey))

const pushLog = (message) => {
  actionLogs.value.unshift({
    id: Date.now() + Math.floor(Math.random() * 1000),
    message,
    time: new Date().toLocaleTimeString('zh-CN', { hour12: false })
  })
  if (actionLogs.value.length > 10) {
    actionLogs.value = actionLogs.value.slice(0, 10)
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
  const localSaved = loadLocalDebugSettings(agent.key)
  const merged = {
    useQwen: localSaved?.useQwen ?? defaults.useQwen,
    useWs: localSaved?.useWs ?? defaults.useWs,
    retrievalTopK: Number(localSaved?.retrievalTopK ?? defaults.retrievalTopK),
    scoreThreshold: Number(localSaved?.scoreThreshold ?? defaults.scoreThreshold),
    fusionMode: localSaved?.fusionMode || defaults.fusionMode,
    alpha: Number(localSaved?.alpha ?? defaults.alpha),
    initialPrompt: localSaved?.initialPrompt || defaults.initialPrompt
  }
  debugForm.useQwen = merged.useQwen
  debugForm.useWs = merged.useWs
  debugForm.retrievalTopK = merged.retrievalTopK
  debugForm.scoreThreshold = merged.scoreThreshold
  debugForm.fusionMode = merged.fusionMode
  debugForm.alpha = merged.alpha
  debugForm.initialPrompt = merged.initialPrompt
  pushLog(localSaved ? `已加载 ${agent.title} 本地调试参数` : `已加载 ${agent.title} 默认调试参数`)
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
  url.searchParams.set('conversation_id', sessionId.value)
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
  pushLog('工作台加载完成')
}

const applyDebugSettings = async () => {
  if (currentAgent.value?.key) {
    saveLocalDebugSettings(currentAgent.value.key)
  }
  await loadWorkspace('应用调试参数')
}

const runTestCase = async (caseText) => {
  debugForm.initialPrompt = caseText
  pushLog('已选择测试用例并重载工作台')
  await loadWorkspace('执行测试用例')
}

const resetToDefaults = async () => {
  if (currentAgent.value?.key) {
    localStorage.removeItem(getDebugStorageKey(currentAgent.value.key))
    applyRawDefaults(currentAgent.value)
  }
  pushLog(`已恢复 ${currentAgent.value?.title || '当前智能体'} 默认参数`)
  await loadWorkspace('恢复默认参数')
}

const openStandaloneWorkspace = () => {
  if (!workspaceUrl.value) {
    ElMessage.warning('工作台尚未就绪，请先加载')
    return
  }
  window.open(workspaceUrl.value, '_blank', 'noopener,noreferrer')
  pushLog('在独立窗口中打开工作台')
}

const handleNewSession = () => {
  sessionId.value = `S${Date.now().toString().slice(-6)}`
  pushLog('创建新会话，上下文已清空')
  ElMessage.info('已创建新会话，上下文已清空')
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
  pushLog('智能体工作台初始化完成')
})
</script>

<style scoped>
.workbench-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #f0f2f5 100%);
  padding: 20px;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
}

.workbench-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px 20px;
  margin-bottom: 20px;
  border-bottom: 1px solid #e8eaed;
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
  padding: 20px;
}

.header-left {
  flex: 0 0 200px;
}

.back-btn {
  color: #409EFF;
  font-size: 14px;
  padding: 8px 12px;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.back-btn:hover {
  background: rgba(64, 158, 255, 0.1);
  transform: translateX(-2px);
}

.back-btn i {
  margin-right: 6px;
  font-size: 16px;
}

.header-center {
  flex: 1;
  display: flex;
  justify-content: center;
}

.agent-info {
  display: flex;
  align-items: center;
  gap: 16px;
}

.agent-icon {
  width: 48px;
  height: 48px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 24px;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
}

.agent-title {
  margin: 0;
  font-size: 24px;
  font-weight: 600;
  color: #1f2329;
  line-height: 1.2;
}

.agent-desc {
  margin: 4px 0 0;
  color: #646a73;
  font-size: 14px;
  max-width: 400px;
  line-height: 1.4;
}

.header-right {
  flex: 0 0 300px;
  display: flex;
  justify-content: flex-end;
}

.action-btn {
  border-radius: 8px;
  padding: 10px 16px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.action-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.workbench-main {
  display: grid;
  grid-template-columns: 320px 1fr 360px;
  gap: 20px;
  min-height: calc(100vh - 140px);
}

.panel-left,
.panel-center,
.panel-right {
  border: 1px solid #e4e7ed;
  border-radius: 12px;
  overflow: hidden;
  transition: all 0.3s ease;
  background: white;
}

.panel-left:hover,
.panel-center:hover,
.panel-right:hover {
  border-color: #c0c4cc;
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
}

.panel-header {
  padding: 20px 20px 16px;
  border-bottom: 1px solid #f0f2f5;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: linear-gradient(to right, #f8fafc, #ffffff);
}

.panel-title {
  font-size: 16px;
  font-weight: 600;
  color: #1f2329;
  display: flex;
  align-items: center;
  gap: 8px;
}

.panel-title i {
  color: #409EFF;
  font-size: 18px;
}

.debug-form-wrapper {
  padding: 20px;
  height: calc(100% - 70px);
  overflow-y: auto;
}

.debug-form-wrapper::-webkit-scrollbar {
  width: 6px;
}

.debug-form-wrapper::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

.debug-form-wrapper::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}

.debug-form-wrapper::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}

.form-section {
  margin-bottom: 24px;
  padding-bottom: 20px;
  border-bottom: 1px solid #f0f2f5;
}

.form-section:last-child {
  border-bottom: none;
  margin-bottom: 0;
  padding-bottom: 0;
}

.section-label {
  font-size: 14px;
  font-weight: 600;
  color: #1f2329;
  margin-bottom: 12px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.section-label i {
  color: #409EFF;
}

.custom-textarea {
  :deep(.el-textarea__inner) {
    border: 1px solid #dcdfe6;
    border-radius: 8px;
    padding: 12px;
    font-size: 13px;
    line-height: 1.4;
    transition: border-color 0.3s ease;
  }

  :deep(.el-textarea__inner:focus) {
    border-color: #409EFF;
    box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.1);
  }
}

.switch-group {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.switch-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 12px;
  background: #f8fafc;
  border-radius: 8px;
  border: 1px solid #e4e7ed;
  transition: all 0.3s ease;
}

.switch-item:hover {
  background: #f0f7ff;
  border-color: #409EFF;
}

.switch-item span {
  flex: 1;
  font-size: 13px;
  color: #1f2329;
}

.param-group,
.fusion-group {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.param-item,
.fusion-item {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.param-label {
  font-size: 13px;
  color: #646a73;
  font-weight: 500;
}

.param-control {
  display: flex;
  align-items: center;
  gap: 16px;
}

.custom-slider {
  flex: 1;

  :deep(.el-slider__runway) {
    background-color: #e4e7ed;
    height: 4px;
  }

  :deep(.el-slider__bar) {
    background-color: #409EFF;
    height: 4px;
  }

  :deep(.el-slider__button) {
    width: 16px;
    height: 16px;
    border: 2px solid #409EFF;
  }
}

.param-value {
  min-width: 40px;
  text-align: right;
  font-size: 13px;
  font-weight: 600;
  color: #409EFF;
}

.fusion-select {
  width: 100%;

  :deep(.el-input__inner) {
    border-radius: 8px;
    border-color: #dcdfe6;
  }
}

.form-actions {
  display: flex;
  gap: 12px;
  margin-top: 24px;
  padding-top: 20px;
  border-top: 1px solid #f0f2f5;
}

.apply-btn,
.reset-btn {
  flex: 1;
  padding: 12px;
  border-radius: 8px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.apply-btn {
  background: linear-gradient(135deg, #409EFF 0%, #337ecc 100%);
  border: none;
  color: white;
}

.apply-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
}

.reset-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.workspace-wrapper {
  height: calc(100% - 70px);
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.center-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.new-session-btn {
  color: #409EFF;
  font-size: 13px;
  padding: 6px 12px;
  border-radius: 6px;
  transition: all 0.3s ease;
}

.new-session-btn:hover {
  background: rgba(64, 158, 255, 0.1);
}

.agent-id {
  font-family: 'Monaco', 'Consolas', monospace;
  font-size: 12px;
  margin-left: 8px;
}

.workspace-container {
  display: grid;
  grid-template-columns: 280px 1fr;
  gap: 20px;
  height: 100%;
}

.console-panel {
  background: #f8fafc;
  border-radius: 12px;
  border: 1px solid #e4e7ed;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.console-header {
  padding: 16px 20px;
  background: linear-gradient(to right, #f0f7ff, #ffffff);
  border-bottom: 1px solid #e4e7ed;
}

.console-header span:first-child {
  font-weight: 600;
  color: #1f2329;
  font-size: 15px;
  display: block;
  margin-bottom: 4px;
}

.console-subtitle {
  font-size: 12px;
  color: #646a73;
  line-height: 1.4;
}

.console-content {
  padding: 20px;
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 20px;
  overflow-y: auto;
}

.console-section {
  padding-bottom: 20px;
  border-bottom: 1px solid #f0f2f5;
}

.console-section:last-child {
  border-bottom: none;
  padding-bottom: 0;
}

.section-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
  font-weight: 600;
  color: #1f2329;
  font-size: 14px;
}

.section-header i {
  color: #409EFF;
  font-size: 16px;
}

.section-desc {
  font-size: 12px;
  color: #8f959e;
  line-height: 1.4;
  margin-bottom: 12px;
}

.kb-status {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 12px;
  background: white;
  border-radius: 8px;
  border: 1px solid #e4e7ed;
}

.kb-tag {
  font-size: 12px;
  padding: 4px 8px;
}

.session-info {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.session-id {
  width: fit-content;
  font-family: 'Monaco', 'Consolas', monospace;
  font-size: 12px;
  padding: 4px 8px;
}

.session-desc {
  font-size: 12px;
  color: #646a73;
  line-height: 1.4;
}

.fragment-info {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.fragment-text {
  font-size: 12px;
  color: #646a73;
  text-align: center;
}

.agent-workspace {
  position: relative;
  border-radius: 12px;
  border: 1px solid #e4e7ed;
  overflow: hidden;
  background: white;
}

.workspace-frame {
  position: relative;
  width: 100%;
  height: 100%;
  min-height: 600px;
}

.workspace-iframe {
  width: 100%;
  height: 100%;
  border: none;
  display: block;
}

.workspace-loading {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(255, 255, 255, 0.9);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 10;
}

.loading-content {
  text-align: center;
}

.loading-icon {
  font-size: 36px;
  color: #409EFF;
  margin-bottom: 12px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.loading-content p {
  color: #646a73;
  font-size: 14px;
  margin: 0;
}

.workspace-placeholder {
  width: 100%;
  height: 100%;
  min-height: 600px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f8fafc 0%, #f0f7ff 100%);
  border: 2px dashed #d0d7de;
  border-radius: 12px;
}

.placeholder-content {
  text-align: center;
  padding: 40px;
}

.placeholder-icon {
  font-size: 48px;
  color: #c0c4cc;
  margin-bottom: 16px;
}

.placeholder-title {
  font-size: 16px;
  font-weight: 600;
  color: #1f2329;
  margin: 0 0 8px 0;
}

.placeholder-desc {
  font-size: 14px;
  color: #8f959e;
  margin: 0;
  max-width: 300px;
  line-height: 1.4;
}

.workspace-error {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px;
}
.test-optimization-panel {
  height: calc(100% - 70px);
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 24px;
  overflow-y: auto;
}

.test-section,
.optimization-section,
.log-section {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.test-cases {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.test-case-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 12px;
  background: #f8fafc;
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.test-case-item:hover {
  background: #f0f7ff;
  border-color: #409EFF;
  transform: translateX(4px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.case-icon {
  width: 32px;
  height: 32px;
  min-width: 32px;
  background: linear-gradient(135deg, #409EFF 0%, #337ecc 100%);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 16px;
}

.case-content {
  flex: 1;
  min-width: 0;
}

.case-title {
  font-size: 13px;
  font-weight: 600;
  color: #1f2329;
  margin-bottom: 4px;
}

.case-desc {
  font-size: 12px;
  color: #646a73;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.suggestions {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.suggestion-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 12px;
  border-radius: 8px;
  border-left: 4px solid #409EFF;
  background: #f8fafc;
  transition: all 0.3s ease;
}

.suggestion-item.important {
  border-left-color: #f56c6c;
  background: #fff6f6;
}

.suggestion-item.warning {
  border-left-color: #e6a23c;
  background: #fdf6ec;
}

.suggestion-item.info {
  border-left-color: #909399;
  background: #f4f4f5;
}

.suggestion-icon {
  color: #409EFF;
  font-size: 16px;
  margin-top: 1px;
}

.suggestion-item.important .suggestion-icon {
  color: #f56c6c;
}

.suggestion-item.warning .suggestion-icon {
  color: #e6a23c;
}

.suggestion-item.info .suggestion-icon {
  color: #909399;
}

.suggestion-content {
  flex: 1;
  font-size: 13px;
  color: #1f2329;
  line-height: 1.4;
}

.log-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
  max-height: 200px;
  overflow-y: auto;
  padding: 12px;
  background: #f8fafc;
  border-radius: 8px;
  border: 1px solid #e4e7ed;
}

.log-item {
  padding: 8px 12px;
  background: white;
  border-radius: 6px;
  border: 1px solid #f0f2f5;
  transition: all 0.3s ease;
}

.log-item:hover {
  background: #f0f7ff;
  border-color: #409EFF;
}

.log-time {
  font-size: 11px;
  color: #8f959e;
  font-family: 'Monaco', 'Consolas', monospace;
  margin-bottom: 4px;
}

.log-message {
  font-size: 12px;
  color: #1f2329;
  line-height: 1.4;
}

.empty-log {
  padding: 20px;
  text-align: center;
  color: #8f959e;
  font-size: 13px;
}
@media (max-width: 1600px) {
  .workbench-main {
    grid-template-columns: 300px 1fr 320px;
  }

  .workspace-container {
    grid-template-columns: 240px 1fr;
  }
}

@media (max-width: 1200px) {
  .workbench-main {
    grid-template-columns: 1fr;
    grid-template-rows: auto auto auto;
  }

  .workspace-container {
    grid-template-columns: 1fr;
    grid-template-rows: auto 1fr;
  }

  .console-panel {
    height: 200px;
  }

  .agent-workspace {
    height: 500px;
  }

  .workspace-frame,
  .workspace-placeholder {
    min-height: 400px;
  }
}

@media (max-width: 768px) {
  .workbench-header {
    flex-direction: column;
    gap: 16px;
    padding: 16px;
  }

  .header-left,
  .header-center,
  .header-right {
    width: 100%;
  }

  .header-right {
    justify-content: center;
  }

  .agent-info {
    justify-content: center;
    text-align: center;
  }

  .workbench-main {
    gap: 16px;
  }

  .debug-form-wrapper,
  .workspace-wrapper,
  .test-optimization-panel {
    padding: 16px;
  }
}
</style>
