
<template>
  <div class="news-container">
    <section class="hero-section">
      <div class="hero-copy">
        <span class="section-kicker">Campus Ideology Digest</span>
        <h1 class="hero-title">新闻资讯</h1>
        <p class="hero-description">
          聚焦马克思主义理论、时政热点与校园动态，保留原有新闻抓取能力，同时补充学生更常用的校内入口与问答信息。
        </p>
        <div class="hero-actions">
          <button class="publish-btn" :disabled="loading" @click="refreshNews">
            <span class="refresh-icon">↻</span>
            {{ loading ? '正在刷新' : '刷新新闻' }}
          </button>
          <a
            class="secondary-btn"
            href="https://news.xjtu.edu.cn/tpjd.htm"
            target="_blank"
            rel="noreferrer"
          >
            查看校内图片专题
          </a>
        </div>
        <div class="hero-stats">
          <div class="hero-stat">
            <span class="hero-stat-label">动态新闻</span>
            <strong class="hero-stat-value">{{ articles.length }}</strong>
          </div>
          <div class="hero-stat">
            <span class="hero-stat-label">本周更新</span>
            <strong class="hero-stat-value">{{ weeklyCount }}</strong>
          </div>
          <div class="hero-stat">
            <span class="hero-stat-label">最近刷新</span>
            <strong class="hero-stat-value">{{ lastUpdateTime }}</strong>
          </div>
        </div>
      </div>

      <div class="hero-carousel">
        <el-carousel :interval="5000" arrow="always" height="340px" indicator-position="outside">
          <el-carousel-item v-for="slide in heroSlides" :key="slide.title">
            <article class="hero-slide" :style="slideStyle(slide)">
              <div class="hero-slide-content">
                <span class="hero-slide-tag">{{ slide.tag }}</span>
                <h2>{{ slide.title }}</h2>
                <p>{{ slide.summary }}</p>
                <div class="hero-slide-footer">
                  <span>{{ slide.source }}</span>
                  <a :href="slide.link" target="_blank" rel="noreferrer">查看原文</a>
                </div>
              </div>
            </article>
          </el-carousel-item>
        </el-carousel>
      </div>
    </section>

    <section class="headline-strip">
      <article
        v-for="item in headlineCards"
        :key="item.title"
        class="headline-card"
      >
        <span class="headline-tag">{{ item.tag }}</span>
        <h3 class="headline-title">{{ item.title }}</h3>
        <p class="headline-description">{{ item.description }}</p>
        <a :href="item.link" target="_blank" rel="noreferrer">进入阅读</a>
      </article>
    </section>

    <section class="content-wrapper">
      <div class="news-column">
        <div class="section-header">
          <div>
            <span class="section-kicker">News Feed</span>
            <h2 class="section-title">新闻资讯</h2>
            <p class="section-description">以校内动态为主，辅以理论和时政阅读入口，方便学生与教师快速浏览。</p>
          </div>
          <a
            class="section-link"
            href="https://www.qstheory.cn/"
            target="_blank"
            rel="noreferrer"
          >
            查看更多理论时政
          </a>
        </div>

        <div class="category-tabs">
          <button
            v-for="category in categories"
            :key="category.id"
            :class="['category-tab', { active: activeCategory === category.id }]"
            @click="changeCategory(category.id)"
          >
            {{ category.name }}
          </button>
        </div>

        <div v-if="error && displayedArticles.length > 0" class="status-banner">
          {{ error }}
        </div>

        <div v-if="loading" class="loading-container">
          <div class="loading-spinner"></div>
          <p>正在加载新闻内容...</p>
        </div>

        <div v-else-if="error && displayedArticles.length === 0" class="error-container">
          <p class="error-message">{{ error }}</p>
          <button class="retry-btn" @click="fetchNews">重新获取</button>
        </div>

        <div v-else-if="filteredArticles.length === 0" class="empty-container">
          <p>当前分类下暂无新闻内容</p>
        </div>

        <div v-else class="news-feed">
          <article
            v-for="(article, index) in displayedArticles"
            :key="article.id"
            class="news-card"
            :style="{ '--delay': `${index * 60}ms` }"
          >
            <a
              class="card-image-link"
              :href="article.link"
              target="_blank"
              rel="noreferrer"
              :aria-label="`打开新闻：${article.title}`"
            >
              <div class="card-image-wrapper">
                <img
                  :src="article.image || defaultImage"
                  :alt="article.title"
                  class="card-image"
                  @error="handleImageError"
                >
                <span class="article-badge">{{ getCategoryName(article.category) }}</span>
              </div>
            </a>

            <div class="card-text">
              <div class="card-top">
                <span class="card-source">{{ article.source || '西安交通大学新闻网' }}</span>
                <span class="card-time">{{ formatDate(article.date) }}</span>
              </div>
              <h3 class="card-title">
                <a
                  class="card-title-link"
                  :href="article.link"
                  target="_blank"
                  rel="noreferrer"
                >
                  {{ article.title }}
                </a>
              </h3>
              <p class="card-description">{{ truncateText(article.description, 110) }}</p>

              <div class="card-meta">
                <span>浏览 {{ formatViewCount(article.views || 0) }}</span>
                <span>评论 {{ article.comments || 0 }}</span>
              </div>

              <div class="card-actions">
                <a :href="article.link" target="_blank" rel="noreferrer" class="card-link">
                  查看详情
                </a>
              </div>
            </div>
          </article>
        </div>

        <div v-if="hasMoreArticles" class="load-more">
          <button class="load-more-btn" @click="loadMore">
            加载更多
          </button>
        </div>
      </div>

      <aside class="sidebar">
        <section class="sidebar-widget">
          <div class="widget-header">
            <div>
              <h3 class="widget-title">热门新闻</h3>
              <span class="widget-tip">理论 / 时政 / 校园</span>
            </div>
            <a
              class="widget-link"
              href="https://www.news.cn/politics/"
              target="_blank"
              rel="noreferrer"
            >
              更多新闻
            </a>
          </div>
          <div class="sidebar-news-list">
            <a
              v-for="(news, index) in hotNewsItems"
              :key="news.title"
              class="sidebar-news-item"
              :href="news.link"
              target="_blank"
              rel="noreferrer"
              :aria-label="`打开热门新闻：${news.title}`"
            >
              <div class="sidebar-news-number">{{ index + 1 }}</div>
              <div class="sidebar-news-text">
                <h4 class="sidebar-news-title">{{ news.title }}</h4>
                <p class="sidebar-news-meta">{{ news.source }}</p>
              </div>
            </a>
          </div>
        </section>

        <section class="sidebar-widget">
          <div class="widget-header">
            <h3 class="widget-title">校内链接</h3>
            <span class="widget-tip">图片交大入口</span>
          </div>
          <div class="campus-links">
            <a
              v-for="item in campusLinks"
              :key="item.title"
              class="campus-link-card"
              :href="item.link"
              target="_blank"
              rel="noreferrer"
            >
              <span class="campus-link-tag">{{ item.tag }}</span>
              <strong>{{ item.title }}</strong>
              <p>{{ item.description }}</p>
            </a>
          </div>
        </section>

        <section class="sidebar-widget">
          <div class="widget-header">
            <h3 class="widget-title">学生常见问题</h3>
            <span class="widget-tip">常用功能提示</span>
          </div>
          <div class="faq-list">
            <button
              v-for="faq in studentFaqs"
              :key="faq.id"
              class="faq-item"
              type="button"
              @click="toggleFaq(faq.id)"
            >
              <div class="faq-question-row">
                <span class="faq-question">{{ faq.question }}</span>
                <span class="faq-toggle">{{ openFaqId === faq.id ? '－' : '＋' }}</span>
              </div>
              <p v-if="openFaqId === faq.id" class="faq-answer">{{ faq.answer }}</p>
            </button>
          </div>
        </section>

        <section class="sidebar-widget source-widget">
          <div class="widget-header">
            <h3 class="widget-title">信息说明</h3>
          </div>
          <div class="source-info">
            <p class="source-name">动态新闻来源：西安交通大学新闻网接口抓取</p>
            <p class="source-desc">热门新闻与顶部导读补充了求是网、人民网理论频道、新华网时政栏目和西安交通大学新闻网官方链接。</p>
          </div>
        </section>
      </aside>
    </section>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'

const API_BASE_URL = import.meta.env.VITE_NEWS_API_URL || import.meta.env.VITE_API_URL || 'http://localhost:5000'
const defaultImage = 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=900&h=560&fit=crop'

const categories = [
  { id: 'all', name: '全部' },
  { id: 'theory', name: '理论学习' },
  { id: 'politics', name: '时政热点' },
  { id: 'campus', name: '校园动态' },
  { id: 'notice', name: '通知公告' }
]

const heroSlides = [
  {
    tag: '理论导读',
    title: '推动思想政治工作做在日常落到基层',
    summary: '聚焦思想政治工作的日常化、基层化落实路径，适合作为本页理论学习的首屏入口。',
    source: '求是网',
    link: 'https://www.qstheory.cn/20260115/234f9c7d95d84a8f8590625021d1c4ca/c.html',
    background: 'linear-gradient(135deg, rgba(15, 38, 95, 0.96), rgba(33, 120, 188, 0.9))'
  },
  {
    tag: '时政速览',
    title: '阔步向前启新程 接续奋斗谱新篇',
    summary: '以 2026 年全国两会专题为核心入口，适合教师和学生集中了解近期国内时政重点。',
    source: '新华网',
    link: 'https://www.news.cn/politics/2026lh/index.html',
    background: 'linear-gradient(135deg, rgba(88, 22, 62, 0.94), rgba(194, 60, 84, 0.88))'
  },
  {
    tag: '校园专题',
    title: '图片交大：校园焦点与专题入口',
    summary: '通过图片交大进入校内活动、校园专题与视觉新闻，保留页面的校园资讯入口。',
    source: '西安交通大学新闻网',
    link: 'https://news.xjtu.edu.cn/tpjd.htm',
    background: 'linear-gradient(135deg, rgba(17, 81, 72, 0.96), rgba(79, 167, 134, 0.88))'
  }
]

const headlineCards = [
  {
    tag: '马克思主义理论',
    title: '打牢做好思想政治工作的基本功',
    description: '围绕思想政治工作的基础能力和落实方法，适合放在新闻首页作为理论导读。',
    link: 'https://www.qstheory.cn/20260131/64d379bc41184055ac077ad3f7795ee7/c.html'
  },
  {
    tag: '时政热点',
    title: '走好中国式现代化关键一程',
    description: '从全国两会和“十五五”规划视角理解当前高质量发展与现代化建设的阶段重点。',
    link: 'https://www.qstheory.cn/20260306/90f8b0af2f9a489081837716cb6d227f/c.html'
  },
  {
    tag: '校内精选',
    title: '校园专题与图片要闻',
    description: '进入图片交大栏目，查看校园焦点、校内专题和活动现场影像。',
    link: 'https://news.xjtu.edu.cn/tpjd.htm'
  }
]

const hotNewsItems = [
  {
    title: '阔步向前启新程 接续奋斗谱新篇——2026年全国两会巡礼',
    source: '新华网',
    link: 'https://www.news.cn/politics/2026lh/index.html'
  },
  {
    title: '两会特稿丨“与中国同行就是与机遇同行”——中国携手世界开创互利共赢新局面',
    source: '新华网',
    link: 'https://www.news.cn/world/20260306/305365d190b045a5ac904b96de14f3b3/c.html'
  },
  {
    title: '两会·外长记者会丨王毅：中欧关系的关键是欧洲要树立正确对华认知',
    source: '新华网',
    link: 'https://www.news.cn/20260308/c3a0a72c6717457397b34adb4b0e0148/c.html'
  },
  {
    title: '两会速递丨教育部部长：这两年“双一流”高校扩招3.8万人',
    source: '新华网',
    link: 'https://www.news.cn/politics/20260307/6f69f34ea62e406baccfffddbf01c74f/c.html'
  },
  {
    title: '两会现场速递丨教育部部长怀进鹏：大力实施健康教育专项工程 让学生身上有汗、眼里有光',
    source: '新华网',
    link: 'https://www.news.cn/politics/20260307/38d5c9f4482f4fae82a639cbedb82841/c.html'
  }
]

const campusLinks = [
  {
    tag: '图片交大',
    title: '校园焦点',
    description: '浏览校内活动影像、校园焦点图片和专题内容。',
    link: 'https://news.xjtu.edu.cn/tpjd.htm'
  },
  {
    tag: '图片交大',
    title: '校内要闻',
    description: '从图片专题进入交大校内动态，适合快速了解近期校园面貌。',
    link: 'https://news.xjtu.edu.cn/tpjd.htm'
  },
  {
    tag: '图片交大',
    title: '校园专题',
    description: '查看图片交大的专题栏目入口，集中浏览校园主题内容。',
    link: 'https://news.xjtu.edu.cn/tpjd.htm'
  }
]

const studentFaqs = [
  {
    id: 'faq-1',
    question: '忘记密码怎么办？',
    answer: '可以先进入“个人中心 - 重置密码”进行修改；如果无法进入系统，请联系管理员协助重置。'
  },
  {
    id: 'faq-2',
    question: '登录异常如何处理？',
    answer: '请先确认账号、密码和网络状态是否正常；若仍无法登录，建议截图当前提示信息并反馈给管理员。'
  },
  {
    id: 'faq-3',
    question: '新闻无法打开怎么办？',
    answer: '可以先点击本页“刷新新闻”重新获取内容；如果外链打不开，建议稍后重试或切换浏览器访问。'
  },
  {
    id: 'faq-4',
    question: '如何查看个人学习信息？',
    answer: '登录后可通过左侧菜单进入“在线学习”或“个人中心”，查看课程学习情况和个人基础信息。'
  },
  {
    id: 'faq-5',
    question: '如何联系管理员？',
    answer: '遇到账户、权限或页面异常问题时，请整理账号信息、问题描述和截图，通过班级通知渠道或系统管理员联系方式反馈。'
  }
]

const curatedArticles = [
  {
    id: 'curated-1',
    title: '推动思想政治工作做在日常落到基层',
    description: '聚焦思想政治工作的制度保障、基层落实与常态化推进，适合作为学生和教师的理论阅读入口。',
    image: defaultImage,
    link: 'https://www.qstheory.cn/20260115/234f9c7d95d84a8f8590625021d1c4ca/c.html',
    date: '2026-01-16',
    source: '求是网',
    category: 'theory'
  },
  {
    id: 'curated-2',
    title: '打牢做好思想政治工作的基本功',
    description: '围绕思想政治工作的能力建设展开论述，内容契合马克思主义理论和高校思政场景。',
    image: defaultImage,
    link: 'https://www.qstheory.cn/20260131/64d379bc41184055ac077ad3f7795ee7/c.html',
    date: '2026-02-01',
    source: '求是网',
    category: 'theory'
  },
  {
    id: 'curated-3',
    title: '深刻把握推动高质量发展的四重意蕴',
    description: '从理论层面解读高质量发展的时代内涵，适合作为时政学习与理论阅读的延伸材料。',
    image: defaultImage,
    link: 'https://theory.people.com.cn/n1/2026/0129/c40531-40655062.html',
    date: '2026-01-29',
    source: '人民网理论频道',
    category: 'theory'
  },
  {
    id: 'curated-4',
    title: '以人工智能为引领赋能高质量发展',
    description: '结合新质生产力与科技发展议题，帮助学生从理论与现实结合的角度理解当前发展主题。',
    image: defaultImage,
    link: 'https://theory.people.com.cn/n1/2026/0109/c40531-40641880.html',
    date: '2026-01-09',
    source: '人民网理论频道',
    category: 'theory'
  },
  {
    id: 'curated-5',
    title: '走好中国式现代化关键一程',
    description: '从“十五五”规划新图景切入，适合放在新闻资讯主区作为近期时政与发展议题的重点导读。',
    image: defaultImage,
    link: 'https://www.qstheory.cn/20260306/90f8b0af2f9a489081837716cb6d227f/c.html',
    date: '2026-03-06',
    source: '求是网',
    category: 'politics'
  },
  {
    id: 'curated-6',
    title: '两会现场速递丨教育部部长怀进鹏：大力实施健康教育专项工程 让学生身上有汗、眼里有光',
    description: '内容与学生成长、校园教育和两会热点直接相关，适合作为新闻资讯区域的时政补充。',
    image: defaultImage,
    link: 'https://www.news.cn/politics/20260307/38d5c9f4482f4fae82a639cbedb82841/c.html',
    date: '2026-03-07',
    source: '新华网',
    category: 'politics'
  }
]

const fallbackArticles = [...curatedArticles]

const activeCategory = ref('all')
const loading = ref(false)
const error = ref(null)
const articles = ref([])
const visibleCount = ref(6)
const lastUpdateTime = ref('--:--')
const openFaqId = ref(studentFaqs[0].id)

const categoryKeywords = {
  theory: ['理论', '马克思主义', '思政', '党建', '思想政治', '高质量发展'],
  politics: ['两会', '时政', '政策', '现代化', '教育部', '外交', '规划'],
  notice: ['通知', '公告'],
  campus: ['交大', '校园', '学院', '学生', '活动', '图片交大']
}

const slideStyle = (slide) => ({
  background: slide.background
})

const inferCategory = (title = '', description = '') => {
  const content = `${title} ${description}`
  if (categoryKeywords.notice.some((keyword) => content.includes(keyword))) {
    return 'notice'
  }
  if (categoryKeywords.campus.some((keyword) => content.includes(keyword))) {
    return 'campus'
  }
  if (categoryKeywords.theory.some((keyword) => content.includes(keyword))) {
    return 'theory'
  }
  if (categoryKeywords.politics.some((keyword) => content.includes(keyword))) {
    return 'politics'
  }
  return 'campus'
}

const normalizeArticle = (item, index) => ({
  id: item.id || `article-${index}`,
  title: item.title || '未命名新闻',
  description: item.description || item.title || '',
  image: item.image || defaultImage,
  link: item.link || '#',
  views: item.views ?? Math.floor(Math.random() * 5000) + 500,
  comments: item.comments ?? Math.floor(Math.random() * 80),
  date: item.date || new Date().toISOString(),
  category: item.category || inferCategory(item.title, item.description),
  source: item.source || '西安交通大学新闻网'
})

const mergeArticles = (remoteItems = []) => {
  const normalizedCurated = curatedArticles.map((item, index) => normalizeArticle(item, index))
  const normalizedRemote = remoteItems.map((item, index) => normalizeArticle(item, index + normalizedCurated.length))
  const seen = new Set()

  return [...normalizedCurated, ...normalizedRemote].filter((item) => {
    const key = item.link || item.title
    if (seen.has(key)) {
      return false
    }
    seen.add(key)
    return true
  })
}

const filteredArticles = computed(() => {
  if (activeCategory.value === 'all') {
    return articles.value
  }
  return articles.value.filter((article) => article.category === activeCategory.value)
})

const displayedArticles = computed(() => filteredArticles.value.slice(0, visibleCount.value))
const hasMoreArticles = computed(() => filteredArticles.value.length > visibleCount.value)

const weeklyCount = computed(() => {
  const oneWeekAgo = Date.now() - 7 * 24 * 60 * 60 * 1000
  return articles.value.filter((article) => {
    const articleTime = new Date(article.date).getTime()
    return !Number.isNaN(articleTime) && articleTime > oneWeekAgo
  }).length
})

const getCategoryName = (categoryId) => {
  const category = categories.find((item) => item.id === categoryId)
  return category ? category.name : '校园动态'
}

const changeCategory = (categoryId) => {
  activeCategory.value = categoryId
  visibleCount.value = 6
}

const fetchNews = async () => {
  loading.value = true
  error.value = null

  try {
    const response = await fetch(`${API_BASE_URL}/api/news`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json'
      }
    })

    if (!response.ok) {
      throw new Error('新闻接口请求失败，请检查新闻服务是否正常运行。')
    }

    const data = await response.json()
    if (!data.success || !Array.isArray(data.data)) {
      throw new Error(data.message || '新闻数据返回异常。')
    }

    articles.value = mergeArticles(data.data)
    visibleCount.value = 6
    updateLastRefreshTime()
  } catch (err) {
    console.error('获取新闻失败:', err)
    error.value = '新闻服务暂时不可用，当前展示静态新闻资讯内容。'
    loadDefaultData()
  } finally {
    loading.value = false
  }
}

const loadDefaultData = () => {
  articles.value = fallbackArticles.map((item, index) => normalizeArticle(item, index))
  visibleCount.value = 6
  updateLastRefreshTime()
}

const refreshNews = async () => {
  if (loading.value) {
    return
  }

  loading.value = true
  error.value = null

  try {
    const response = await fetch(`${API_BASE_URL}/api/news/refresh`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      }
    })

    if (!response.ok) {
      throw new Error('刷新请求失败，请稍后再试。')
    }

    const data = await response.json()
    if (!data.success || !Array.isArray(data.data)) {
      throw new Error(data.message || '刷新新闻失败。')
    }

    articles.value = mergeArticles(data.data)
    visibleCount.value = 6
    updateLastRefreshTime()
  } catch (err) {
    console.error('刷新新闻失败:', err)
    error.value = `刷新失败：${err.message}`
    if (articles.value.length === 0) {
      loadDefaultData()
    }
  } finally {
    loading.value = false
  }
}

const loadMore = () => {
  visibleCount.value += 6
}

const updateLastRefreshTime = () => {
  const now = new Date()
  lastUpdateTime.value = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`
}

const toggleFaq = (faqId) => {
  openFaqId.value = openFaqId.value === faqId ? '' : faqId
}

const formatDate = (dateStr) => {
  if (!dateStr) {
    return '--'
  }

  const date = new Date(dateStr)
  if (Number.isNaN(date.getTime())) {
    return dateStr
  }

  const now = Date.now()
  const diff = now - date.getTime()
  if (diff < 0) {
    return date.toLocaleDateString('zh-CN')
  }

  const minutes = Math.floor(diff / 60000)
  const hours = Math.floor(diff / 3600000)
  const days = Math.floor(diff / 86400000)

  if (minutes < 60) {
    return `${minutes} 分钟前`
  }
  if (hours < 24) {
    return `${hours} 小时前`
  }
  if (days < 7) {
    return `${days} 天前`
  }
  return date.toLocaleDateString('zh-CN')
}

const formatViewCount = (count) => {
  if (count >= 10000) {
    return `${(count / 10000).toFixed(1)}w`
  }
  if (count >= 1000) {
    return `${(count / 1000).toFixed(1)}k`
  }
  return String(count)
}

const truncateText = (text, length = 100) => {
  if (!text) {
    return ''
  }
  return text.length > length ? `${text.slice(0, length)}...` : text
}

const handleImageError = (event) => {
  event.target.src = defaultImage
}

onMounted(() => {
  fetchNews()
})
</script>

<style scoped>
* {
  box-sizing: border-box;
}

.news-container {
  min-height: 100vh;
  padding: 32px 0 48px;
  background:
    radial-gradient(circle at top left, rgba(74, 144, 226, 0.12), transparent 28%),
    linear-gradient(180deg, #f4f7fb 0%, #eef3f9 100%);
}

.hero-section,
.headline-strip,
.content-wrapper {
  width: min(1400px, calc(100% - 48px));
  margin: 0 auto;
}

.hero-section {
  display: grid;
  grid-template-columns: minmax(300px, 420px) minmax(0, 1fr);
  gap: 24px;
  align-items: stretch;
  margin-bottom: 24px;
}

.hero-copy,
.hero-carousel,
.headline-card,
.news-column,
.sidebar-widget {
  background: rgba(255, 255, 255, 0.92);
  border: 1px solid rgba(219, 228, 239, 0.9);
  border-radius: 24px;
  box-shadow: 0 16px 40px rgba(31, 56, 88, 0.08);
}

.hero-copy {
  padding: 28px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  gap: 20px;
}

.section-kicker {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: #3f74ad;
}

.hero-title,
.section-title {
  margin: 0;
  color: #1b2a3d;
}

.hero-title {
  font-size: 38px;
  line-height: 1.15;
}

.hero-description,
.section-description,
.headline-description,
.campus-link-card p,
.source-desc,
.faq-answer,
.card-description {
  margin: 0;
  font-size: 14px;
  line-height: 1.8;
  color: #58708d;
}

.hero-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.publish-btn,
.secondary-btn,
.retry-btn,
.load-more-btn {
  border: none;
  border-radius: 999px;
  padding: 12px 22px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  text-decoration: none;
  transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
}

.publish-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  color: #fff;
  background: linear-gradient(135deg, #4a90e2 0%, #2f68c1 100%);
  box-shadow: 0 12px 24px rgba(74, 144, 226, 0.28);
}

.publish-btn:disabled {
  cursor: not-allowed;
  opacity: 0.7;
}

.secondary-btn {
  color: #28558f;
  background: rgba(232, 240, 250, 0.95);
}

.publish-btn:hover,
.secondary-btn:hover,
.retry-btn:hover,
.load-more-btn:hover {
  transform: translateY(-1px);
}

.hero-stats {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px;
}

.hero-stat {
  padding: 14px 16px;
  border-radius: 18px;
  background: linear-gradient(180deg, rgba(247, 250, 254, 0.98), rgba(236, 243, 250, 0.98));
}

.hero-stat-label {
  display: block;
  margin-bottom: 8px;
  font-size: 12px;
  color: #7090b0;
}

.hero-stat-value {
  font-size: 24px;
  color: #1d3f73;
}

.hero-carousel {
  padding: 18px;
}

.hero-slide {
  position: relative;
  height: 100%;
  overflow: hidden;
  border-radius: 22px;
  padding: 30px;
  color: #fff;
  isolation: isolate;
}

.hero-slide::before,
.hero-slide::after {
  content: '';
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  z-index: 0;
}

.hero-slide::before {
  width: 220px;
  height: 220px;
  right: -50px;
  top: -30px;
}

.hero-slide::after {
  width: 160px;
  height: 160px;
  right: 120px;
  bottom: -60px;
}

.hero-slide-content {
  position: relative;
  z-index: 1;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.hero-slide-tag,
.headline-tag,
.campus-link-tag,
.article-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 700;
}

.hero-slide-tag {
  width: fit-content;
  padding: 7px 12px;
  background: rgba(255, 255, 255, 0.16);
  color: rgba(255, 255, 255, 0.96);
}

.hero-slide h2 {
  margin: 18px 0 14px;
  font-size: 30px;
  line-height: 1.3;
}

.hero-slide p {
  margin: 0;
  max-width: 80%;
  font-size: 15px;
  line-height: 1.8;
  color: rgba(255, 255, 255, 0.9);
}

.hero-slide-footer {
  margin-top: auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  font-size: 13px;
}

.hero-slide-footer a {
  color: #fff;
  font-weight: 700;
  text-decoration: none;
}

.headline-strip {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 20px;
  margin-bottom: 24px;
}

.headline-card {
  padding: 22px 24px;
}

.headline-tag,
.campus-link-tag,
.article-badge {
  padding: 6px 12px;
  color: #225288;
  background: rgba(226, 236, 248, 0.9);
}

.headline-title {
  margin: 16px 0 10px;
  font-size: 20px;
  color: #20344d;
}

.headline-card a {
  display: inline-block;
  margin-top: 18px;
  color: #3d79c3;
  font-weight: 700;
  text-decoration: none;
}

.content-wrapper {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 360px;
  gap: 24px;
}

.news-column {
  padding: 26px;
}

.section-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 22px;
}

.section-link,
.widget-link {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  white-space: nowrap;
  color: #3269b9;
  font-size: 13px;
  font-weight: 700;
  text-decoration: none;
  transition: color 0.2s ease, transform 0.2s ease;
}

.section-link:hover,
.widget-link:hover {
  color: #214d8e;
  transform: translateY(-1px);
}

.section-title {
  font-size: 30px;
  margin-bottom: 8px;
}

.category-tabs {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-bottom: 18px;
}

.category-tab {
  border: 1px solid rgba(214, 226, 239, 0.95);
  background: #fff;
  border-radius: 999px;
  padding: 10px 18px;
  font-size: 14px;
  font-weight: 600;
  color: #58708d;
  cursor: pointer;
  transition: all 0.2s ease;
}

.category-tab:hover,
.category-tab.active {
  color: #fff;
  border-color: #4a90e2;
  background: linear-gradient(135deg, #4a90e2 0%, #2f68c1 100%);
}

.status-banner,
.loading-container,
.error-container,
.empty-container {
  border-radius: 18px;
  background: #f8fbff;
  border: 1px solid rgba(218, 230, 243, 0.95);
}

.status-banner {
  margin-bottom: 18px;
  padding: 14px 18px;
  color: #5c7490;
}

.loading-container,
.error-container,
.empty-container {
  padding: 54px 18px;
  text-align: center;
}

.loading-spinner {
  width: 42px;
  height: 42px;
  margin: 0 auto 16px;
  border: 4px solid rgba(74, 144, 226, 0.14);
  border-top-color: #4a90e2;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.error-message {
  margin: 0 0 16px;
  color: #d95858;
}

.retry-btn,
.load-more-btn {
  color: #fff;
  background: linear-gradient(135deg, #4a90e2 0%, #2f68c1 100%);
}

.news-feed {
  display: flex;
  flex-direction: column;
  gap: 18px;
}

.news-card {
  display: grid;
  grid-template-columns: 260px minmax(0, 1fr);
  gap: 20px;
  padding: 18px;
  border-radius: 22px;
  background: linear-gradient(180deg, #ffffff 0%, #fbfdff 100%);
  border: 1px solid rgba(220, 229, 239, 0.95);
  box-shadow: 0 12px 30px rgba(34, 56, 84, 0.06);
  animation: cardIn 0.45s ease forwards;
  animation-delay: var(--delay, 0ms);
  opacity: 0;
}

.news-card:hover {
  box-shadow: 0 16px 36px rgba(34, 56, 84, 0.1);
}

@keyframes cardIn {
  from {
    opacity: 0;
    transform: translateY(12px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.card-image-link {
  display: block;
  text-decoration: none;
}

.card-image-wrapper {
  position: relative;
  overflow: hidden;
  border-radius: 18px;
  min-height: 188px;
  background: #edf3fb;
  transition: box-shadow 0.2s ease, transform 0.2s ease;
}

.card-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.news-card:hover .card-image {
  transform: scale(1.04);
}

.card-image-link:hover .card-image-wrapper {
  box-shadow: 0 12px 24px rgba(46, 89, 145, 0.12);
}

.article-badge {
  position: absolute;
  left: 14px;
  top: 14px;
}

.card-text {
  display: flex;
  flex-direction: column;
  min-width: 0;
}

.card-top,
.card-meta,
.card-actions {
  display: flex;
  align-items: center;
  gap: 16px;
}

.card-top {
  justify-content: space-between;
  margin-bottom: 12px;
  color: #7691ad;
  font-size: 13px;
}

.card-title {
  margin: 0 0 12px;
  font-size: 22px;
  line-height: 1.45;
  color: #20344d;
}

.card-title-link {
  color: inherit;
  text-decoration: none;
  transition: color 0.2s ease;
}

.card-title-link:hover {
  color: #2d67b4;
}

.card-meta {
  margin-top: auto;
  padding-top: 18px;
  font-size: 13px;
  color: #7691ad;
}

.card-actions {
  margin-top: 16px;
}

.card-link {
  display: inline-flex;
  align-items: center;
  color: #3269b9;
  font-weight: 700;
  text-decoration: none;
  transition: color 0.2s ease, transform 0.2s ease;
}

.card-link:hover {
  color: #214d8e;
  transform: translateX(2px);
}

.load-more {
  display: flex;
  justify-content: center;
  padding-top: 22px;
}

.sidebar {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.sidebar-widget {
  padding: 22px;
}

.widget-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 16px;
}

.widget-title {
  margin: 0;
  font-size: 20px;
  color: #20344d;
}

.widget-tip {
  font-size: 12px;
  color: #84a0bc;
}

.sidebar-news-list,
.campus-links,
.faq-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.sidebar-news-item,
.campus-link-card,
.faq-item {
  width: 100%;
  border: 0;
  border-radius: 18px;
  background: #f8fbff;
  border: 1px solid rgba(219, 229, 240, 0.95);
  text-decoration: none;
  text-align: left;
}

.sidebar-news-item {
  display: flex;
  gap: 14px;
  padding: 14px;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.sidebar-news-item:hover,
.campus-link-card:hover,
.faq-item:hover {
  transform: translateY(-1px);
  box-shadow: 0 12px 26px rgba(46, 89, 145, 0.08);
}

.section-link:focus-visible,
.widget-link:focus-visible,
.card-image-link:focus-visible,
.card-title-link:focus-visible,
.card-link:focus-visible,
.sidebar-news-item:focus-visible,
.campus-link-card:focus-visible {
  outline: 2px solid #4a90e2;
  outline-offset: 3px;
  border-radius: 12px;
}

.sidebar-news-number {
  flex-shrink: 0;
  width: 30px;
  height: 30px;
  border-radius: 50%;
  background: linear-gradient(135deg, #4a90e2 0%, #2f68c1 100%);
  color: #fff;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
}

.sidebar-news-text {
  min-width: 0;
}

.sidebar-news-title {
  margin: 0 0 6px;
  font-size: 15px;
  line-height: 1.55;
  color: #223550;
}

.sidebar-news-meta {
  margin: 0;
  font-size: 12px;
  color: #7f99b4;
}

.campus-link-card {
  padding: 16px;
}

.campus-link-card strong {
  display: block;
  margin: 12px 0 8px;
  font-size: 16px;
  color: #20344d;
}

.faq-item {
  padding: 16px;
  cursor: pointer;
}

.faq-question-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.faq-question {
  font-size: 15px;
  font-weight: 700;
  color: #20344d;
}

.faq-toggle {
  font-size: 18px;
  color: #3269b9;
}

.faq-answer {
  margin-top: 12px;
}

.source-name {
  margin: 0 0 8px;
  font-size: 14px;
  color: #20344d;
}

.source-desc {
  font-size: 13px;
}

@media (max-width: 1200px) {
  .hero-section {
    grid-template-columns: 1fr;
  }

  .headline-strip,
  .content-wrapper {
    grid-template-columns: 1fr;
  }

  .sidebar {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 20px;
  }

  .source-widget {
    grid-column: 1 / -1;
  }
}

@media (max-width: 900px) {
  .news-card {
    grid-template-columns: 1fr;
  }

  .card-image-wrapper {
    min-height: 240px;
  }

  .hero-slide p {
    max-width: 100%;
  }
}

@media (max-width: 768px) {
  .news-container {
    padding: 20px 0 36px;
  }

  .hero-section,
  .headline-strip,
  .content-wrapper {
    width: min(1400px, calc(100% - 24px));
  }

  .hero-copy,
  .news-column,
  .sidebar-widget,
  .headline-card {
    border-radius: 20px;
  }

  .hero-title {
    font-size: 30px;
  }

  .hero-stats {
    grid-template-columns: 1fr;
  }

  .hero-carousel {
    padding: 14px;
  }

  .hero-slide {
    padding: 22px;
  }

  .hero-slide h2 {
    font-size: 24px;
  }

  .section-title {
    font-size: 26px;
  }

  .section-header {
    flex-direction: column;
  }

  .sidebar {
    grid-template-columns: 1fr;
  }

  .card-title {
    font-size: 20px;
  }

  .card-top,
  .card-meta {
    flex-wrap: wrap;
  }
}
</style>
