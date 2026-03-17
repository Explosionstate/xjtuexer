export const AGENT_WORKSPACE_BASE_URL = import.meta.env.VITE_AGENT_WORKSPACE_URL || 'http://127.0.0.1:5174/'

export const ADMIN_AGENT_MODULES = [
  {
    key: 'student-growth',
    title: '学生成长助手',
    subtitle: '学习建议 · 生活指导',
    description: '面向学生成长画像，提供学业、生活与发展建议。',
    icon: 'User',
    iconColor: '#5b7cff',
    debugDefaults: {
      useQwen: true,
      useWs: false,
      retrievalTopK: 10,
      scoreThreshold: 0.2,
      fusionMode: 'weighted',
      alpha: 0.62,
      initialPrompt: '请根据当前知识库，给出大一学生本周学习与生活平衡建议。'
    },
    testCases: [
      '请给出一份可执行的期中复习计划（按每天安排）。',
      '我最近学习效率低，给我一套三步改进方案。',
      '结合学生心理压力场景，给出风险识别与干预建议。'
    ],
    optimizationTips: [
      '提高 top_k 以增强多来源检索覆盖。',
      '当回答发散时，可提高 score_threshold。',
      '使用 weighted + 较高 alpha 更适合结构化建议类问答。'
    ]
  },
  {
    key: 'teacher-assistant',
    title: '教师助教助手',
    subtitle: '教学辅助 · 课堂分析',
    description: '服务教师备课、课堂互动分析与教学策略优化。',
    icon: 'DataAnalysis',
    iconColor: '#7d57d1',
    debugDefaults: {
      useQwen: true,
      useWs: true,
      retrievalTopK: 12,
      scoreThreshold: 0.18,
      fusionMode: 'weighted',
      alpha: 0.68,
      initialPrompt: '请给出“思政课课堂互动提升”可直接执行的教学设计建议。'
    },
    testCases: [
      '按 45 分钟课程给出课堂节奏与互动节点设计。',
      '如何根据学情数据调整分层教学策略？',
      '给出课后作业评价 Rubric 模板。'
    ],
    optimizationTips: [
      '建议启用 WebSocket 观察长回答的生成稳定性。',
      '课堂分析类任务推荐更高 alpha 强化语义检索。',
      '通过检索调试比对不同融合模式的证据来源。'
    ]
  },
  {
    key: 'counselor-ideology',
    title: '辅导员思政助手',
    subtitle: '思想引导 · 学生管理',
    description: '支持辅导员开展思想引导、班级治理和沟通辅导。',
    icon: 'EditPen',
    iconColor: '#d28af2',
    debugDefaults: {
      useQwen: true,
      useWs: false,
      retrievalTopK: 9,
      scoreThreshold: 0.22,
      fusionMode: 'weighted',
      alpha: 0.6,
      initialPrompt: '请生成“班会思政主题沟通”对话提纲，兼顾引导与关怀。'
    },
    testCases: [
      '如何与学习焦虑学生进行一次有效谈话？',
      '给出班级思政主题月活动方案。',
      '请输出“学生事务管理”标准话术模板。'
    ],
    optimizationTips: [
      '对情绪类场景适度提高阈值可减少无关信息。',
      '保留 8~10 的 top_k 可兼顾广度与准确度。',
      '建议优先使用结构化提示词进行对话引导。'
    ]
  },
  {
    key: 'risk-warning',
    title: '学情预警助手',
    subtitle: '风险识别 · 预警分析',
    description: '面向学情风险与异常行为，提供预警解释与处置建议。',
    icon: 'WarnTriangleFilled',
    iconColor: '#ff6b6b',
    debugDefaults: {
      useQwen: false,
      useWs: true,
      retrievalTopK: 14,
      scoreThreshold: 0.15,
      fusionMode: 'rrf',
      alpha: 0.5,
      initialPrompt: '请识别近两周学习行为中的预警信号，并给出处置优先级。'
    },
    testCases: [
      '请给出“课程出勤下降 + 成绩波动”的风险解释链路。',
      '生成风险分级处置建议（高/中/低）。',
      '输出辅导员可执行的 7 天干预计划。'
    ],
    optimizationTips: [
      '风险识别任务推荐 rrf 融合提升召回多样性。',
      '提高 top_k 能更好覆盖弱信号片段。',
      '通过会话参数回放对比不同阈值下的误报率。'
    ]
  },
  {
    key: 'report-assistant',
    title: '学情报告助手',
    subtitle: '数据统计 · 报告生成',
    description: '自动生成阶段性学情报告，支持摘要、结论与建议。',
    icon: 'DocumentCopy',
    iconColor: '#42c8c3',
    debugDefaults: {
      useQwen: true,
      useWs: false,
      retrievalTopK: 11,
      scoreThreshold: 0.2,
      fusionMode: 'weighted',
      alpha: 0.66,
      initialPrompt: '请基于知识库内容生成本月学情报告（含关键结论与建议）。'
    },
    testCases: [
      '输出“月度学情简报”模板（摘要/问题/建议）。',
      '请按学院维度生成对比分析段落。',
      '自动生成“下月改进行动清单”。'
    ],
    optimizationTips: [
      '报告生成场景建议启用 Qwen 增强文本组织。',
      '较高 alpha 更利于证据一致性。',
      '建议固定模板提示词，提升输出可复用性。'
    ]
  },
  {
    key: 'policy-qa',
    title: '思政知识问答',
    subtitle: '政策解读 · 知识问答',
    description: '用于政策解读、知识问答与依据溯源。',
    icon: 'ChatDotRound',
    iconColor: '#f4a300',
    debugDefaults: {
      useQwen: true,
      useWs: true,
      retrievalTopK: 8,
      scoreThreshold: 0.25,
      fusionMode: 'weighted',
      alpha: 0.7,
      initialPrompt: '请解释当前政策条目，并给出面向学生的通俗版说明。'
    },
    testCases: [
      '请给出某政策条款的核心要点与适用场景。',
      '同一问题给出“官方版”与“通俗版”两种回答。',
      '列出回答依据来源并说明可信度。'
    ],
    optimizationTips: [
      '问答场景可提高 score_threshold 降低噪声。',
      '高 alpha 有助于强化语义相关性。',
      '建议开启 WS 流式观察长回答完整性。'
    ]
  }
]

export const ADMIN_AGENT_MAP = ADMIN_AGENT_MODULES.reduce((acc, item) => {
  acc[item.key] = item
  return acc
}, {})

export const getAdminAgentByKey = (agentKey) => ADMIN_AGENT_MAP[agentKey] || null
