<template>
  <div class="news-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <h1 class="page-title">新闻资讯</h1>
      <button class="publish-btn" @click="refreshNews">
        <span class="refresh-icon">🔄</span>
        刷新新闻
      </button>
    </div>

    <!-- 分类标签 -->
    <div class="category-tabs">
      <button
          v-for="category in categories"
          :key="category.id"
          :class="['category-tab', { active: activeCategory === category.id }]"
          @click="activeCategory = category.id"
      >
        {{ category.name }}
      </button>
    </div>

    <!-- 主内容区域 -->
    <div class="content-wrapper">
      <!-- 左侧：新闻列表 -->
      <div class="news-feed">
        <!-- 加载状态 -->
        <div v-if="loading" class="loading-container">
          <div class="loading-spinner"></div>
          <p>正在加载新闻...</p>
        </div>

        <!-- 错误状态 -->
        <div v-else-if="error" class="error-container">
          <p class="error-message">{{ error }}</p>
          <button class="retry-btn" @click="fetchNews">重试</button>
        </div>

        <!-- 空状态 -->
        <div v-else-if="filteredArticles.length === 0" class="empty-container">
          <p>暂无新闻内容</p>
        </div>

        <!-- 新闻卡片列表 -->
        <div
            v-for="(article, index) in filteredArticles"
            :key="article.id"
            :class="['news-card', { 'fade-in': true }]"
            :style="{ '--delay': `${index * 50}ms` }"
        >
          <div class="card-content">
            <div class="card-image-wrapper">
              <img
                  :src="article.image || defaultImage"
                  :alt="article.title"
                  class="card-image"
                  @error="handleImageError"
              >
              <div class="card-overlay"></div>
            </div>

            <div class="card-text">
              <h3 class="card-title">{{ article.title }}</h3>
              <p class="card-description">{{ truncateText(article.description, 100) }}</p>

              <div class="card-meta">
                <span class="meta-item">
                  <i class="icon-view">👁</i>
                  {{ formatViewCount(article.views || 0) }}
                </span>
                <span class="meta-item">
                  <i class="icon-comment">💬</i>
                  {{ article.comments || 0 }}
                </span>
                <span class="meta-time">
                  <i class="icon-time">📅</i>
                  {{ formatDate(article.date) }}
                </span>
              </div>

              <a :href="article.link" target="_blank" class="card-link">
                查看详情 →
              </a>
            </div>
          </div>
        </div>

        <!-- 加载更多 -->
        <div v-if="!loading && filteredArticles.length > 0" class="load-more">
          <button class="load-more-btn" @click="loadMore">
            <span>加载更多</span>
            <span class="arrow">→</span>
          </button>
        </div>
      </div>

      <!-- 右侧：侧栏 -->
      <aside class="sidebar">
        <!-- 热门新闻 -->
        <div class="sidebar-widget">
          <div class="widget-header">
            <h4 class="widget-title">热门新闻</h4>
            <a href="#" class="widget-link">查看更多</a>
          </div>
          <div class="sidebar-news-list">
            <div
                v-for="(news, index) in hotNews"
                :key="news.id"
                class="sidebar-news-item"
            >
              <div class="sidebar-news-number">{{ index + 1 }}</div>
              <div class="sidebar-news-text">
                <h5 class="sidebar-news-title">{{ news.title }}</h5>
                <p class="sidebar-news-meta">{{ formatDate(news.date) }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- 数据统计 -->
        <div class="sidebar-widget">
          <div class="widget-header">
            <h4 class="widget-title">数据统计</h4>
          </div>
          <div class="stats-container">
            <div class="stat-item">
              <span class="stat-label">总新闻数</span>
              <span class="stat-value">{{ articles.length }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">本周更新</span>
              <span class="stat-value">{{ weeklyCount }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">最后更新</span>
              <span class="stat-value">{{ lastUpdateTime }}</span>
            </div>
          </div>
        </div>

        <!-- 数据来源 -->
        <div class="sidebar-widget">
          <div class="widget-header">
            <h4 class="widget-title">数据来源</h4>
          </div>
          <div class="source-info">
            <p class="source-name">西安交通大学新闻网</p>
            <p class="source-url">news.xjtu.edu.cn</p>
            <p class="source-desc">实时爬虫更新，每小时同步最新新闻</p>
          </div>
        </div>
      </aside>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

// API配置
const API_BASE_URL = process.env.VUE_APP_API_URL || 'http://localhost:5000'
const defaultImage = 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=500&h=300&fit=crop'

// 响应式状态
const activeCategory = ref('学技说法')
const loading = ref(false)
const error = ref(null)
const articles = ref([])
const lastUpdateTime = ref('--:--')

const categories = [
  { id: '学技说法', name: '学技说法' },
  { id: '政策条规', name: '政策条规' },
  { id: '通知公告', name: '通知公告' },
  { id: '学术活动', name: '学术活动' },
  { id: '学生生活', name: '学生生活' }
]

// 计算属性
const filteredArticles = computed(() => {
  return articles.value.filter(article =>
      article.category === activeCategory.value || !article.category
  )
})

const hotNews = computed(() => {
  return articles.value.slice(0, 5)
})

const weeklyCount = computed(() => {
  const oneWeekAgo = Date.now() - 7 * 24 * 60 * 60 * 1000
  return articles.value.filter(article => {
    const articleTime = new Date(article.date).getTime()
    return articleTime > oneWeekAgo
  }).length
})

// 方法
const fetchNews = async () => {
  loading.value = true
  error.value = null

  try {
    const response = await fetch(`${API_BASE_URL}/api/news`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      }
    })

    if (!response.ok) {
      throw new Error('网络请求失败，请检查后端服务是否运行')
    }

    const data = await response.json()

    if (data.success) {
      articles.value = data.data.map((item, index) => ({
        id: item.id || `article-${index}`,
        title: item.title || '未知标题',
        description: item.description || '',
        image: item.image || defaultImage,
        link: item.link || '#',
        views: Math.floor(Math.random() * 5000),
        comments: Math.floor(Math.random() * 100),
        date: item.date || new Date().toISOString(),
        category: item.category || '学技说法',
        source: item.source || '西安交通大学新闻网'
      }))

      const now = new Date()
      lastUpdateTime.value = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`
    } else {
      throw new Error(data.message || '获取新闻失败')
    }
  } catch (err) {
    error.value = err.message
    console.error('获取新闻出错:', err)
    loadDefaultData()
  } finally {
    loading.value = false
  }
}

const loadDefaultData = () => {
  articles.value = [
    {
      id: 'demo-1',
      title: '西安交大帮扶案例入选教育部精准帮扶典型项目',
      description: '近日，第十届教育部直属高校精准帮扶典型项目推选结果正式公布。西安交通大学申报的《"二浪子""浪迹天涯"的致富路——西安交通大学帮扶施甸黑猪产业发展典型案例》从107个参评项目中脱颖而出，成功获评"教育部直属高校精准帮扶典型项目"。',
      image: defaultImage,
      link: 'https://news.xjtu.edu.cn/info/1033/229852.htm',
      views: 2345,
      comments: 5,
      date: new Date().toISOString(),
      category: '学技说法',
      source: '西安交通大学新闻网'
    }
  ]
  error.value = '后端服务未连接，显示示例数据'
}

const refreshNews = async () => {
  if (loading.value) return

  try {
    loading.value = true
    error.value = null

    const response = await fetch(`${API_BASE_URL}/api/news/refresh`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      }
    })

    const data = await response.json()

    if (data.success) {
      articles.value = data.data.map((item, index) => ({
        id: item.id || `article-${index}`,
        title: item.title || '未知标题',
        description: item.description || '',
        image: item.image || defaultImage,
        link: item.link || '#',
        views: Math.floor(Math.random() * 5000),
        comments: Math.floor(Math.random() * 100),
        date: item.date || new Date().toISOString(),
        category: item.category || '学技说法'
      }))

      const now = new Date()
      lastUpdateTime.value = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`
      console.log('✅ 新闻已刷新')
    }
  } catch (err) {
    error.value = '刷新失败: ' + err.message
    console.error('刷新新闻出错:', err)
  } finally {
    loading.value = false
  }
}

const loadMore = () => {
  console.log('加载更多新闻')
}

const formatDate = (dateStr) => {
  if (!dateStr) return '--'

  try {
    const date = new Date(dateStr)
    const now = new Date()
    const diff = now.getTime() - date.getTime()

    const minutes = Math.floor(diff / 60000)
    const hours = Math.floor(diff / 3600000)
    const days = Math.floor(diff / 86400000)

    if (minutes < 60) return `${minutes}分钟前`
    if (hours < 24) return `${hours}小时前`
    if (days < 7) return `${days}天前`

    return date.toLocaleDateString('zh-CN')
  } catch (e) {
    return dateStr
  }
}

const formatViewCount = (count) => {
  if (count > 10000) return `${(count / 10000).toFixed(1)}万`
  if (count > 1000) return `${(count / 1000).toFixed(1)}k`
  return count.toString()
}

const truncateText = (text, length = 100) => {
  if (!text) return ''
  return text.length > length ? text.substring(0, length) + '...' : text
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
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.news-container {
  width: 100%;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  padding: 40px 0;
  min-height: 100vh;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1400px;
  margin: 0 auto 40px;
  padding: 0 40px;
}

.page-title {
  font-size: 32px;
  font-weight: 700;
  color: #1a1a1a;
  letter-spacing: -0.5px;
}

.publish-btn {
  background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
  color: white;
  border: none;
  padding: 12px 24px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);
}

.publish-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(74, 144, 226, 0.4);
}

.refresh-icon {
  font-size: 16px;
}

.category-tabs {
  display: flex;
  gap: 12px;
  max-width: 1400px;
  margin: 0 auto 40px;
  padding: 0 40px;
  overflow-x: auto;
}

.category-tab {
  padding: 10px 20px;
  border: 2px solid #e0e0e0;
  background: white;
  border-radius: 24px;
  font-size: 14px;
  font-weight: 600;
  color: #666;
  cursor: pointer;
  white-space: nowrap;
  transition: all 0.3s ease;
}

.category-tab:hover {
  border-color: #4a90e2;
  color: #4a90e2;
}

.category-tab.active {
  background: #4a90e2;
  color: white;
  border-color: #4a90e2;
  box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);
}

.content-wrapper {
  display: grid;
  grid-template-columns: 1fr 360px;
  gap: 40px;
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 40px;
}

.news-feed {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.loading-container, .error-container, .empty-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f0f0f0;
  border-top-color: #4a90e2;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 16px;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.error-message {
  color: #f56c6c;
  margin-bottom: 16px;
}

.retry-btn {
  padding: 10px 24px;
  background: #4a90e2;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
}

.news-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
  animation: slideIn 0.6s ease forwards;
  animation-delay: var(--delay, 0ms);
  opacity: 0;
}

@keyframes slideIn {
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.news-card:hover {
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
  transform: translateY(-4px);
}

.card-content {
  display: grid;
  grid-template-columns: 280px 1fr;
  gap: 24px;
  padding: 24px;
}

.card-image-wrapper {
  position: relative;
  overflow: hidden;
  border-radius: 8px;
  height: 200px;
}

.card-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s ease;
}

.news-card:hover .card-image {
  transform: scale(1.05);
}

.card-text {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.card-title {
  font-size: 18px;
  font-weight: 700;
  color: #1a1a1a;
  line-height: 1.4;
  margin-bottom: 12px;
}

.card-description {
  font-size: 14px;
  color: #666;
  line-height: 1.6;
  margin-bottom: 16px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-meta {
  display: flex;
  gap: 20px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
  font-size: 13px;
  color: #999;
  margin-bottom: 12px;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
  transition: color 0.3s ease;
}

.meta-item:hover {
  color: #4a90e2;
}

.meta-time {
  margin-left: auto;
}

.card-link {
  color: #4a90e2;
  text-decoration: none;
  font-weight: 600;
  display: inline-block;
  width: fit-content;
}

.card-link:hover {
  color: #357abd;
}

.load-more {
  text-align: center;
  padding: 20px;
}

.load-more-btn {
  padding: 14px 40px;
  background: white;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  color: #4a90e2;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s ease;
}

.load-more-btn:hover {
  background: #4a90e2;
  color: white;
  border-color: #4a90e2;
}

.sidebar {
  display: flex;
  flex-direction: column;
  gap: 24px;
  height: fit-content;
  position: sticky;
  top: 80px;
}

.sidebar-widget {
  background: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.widget-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 2px solid #f0f0f0;
}

.widget-title {
  font-size: 16px;
  font-weight: 700;
  color: #1a1a1a;
}

.widget-link {
  font-size: 12px;
  color: #4a90e2;
  text-decoration: none;
}

.sidebar-news-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.sidebar-news-item {
  display: flex;
  gap: 12px;
  padding: 12px;
  border-radius: 8px;
  transition: all 0.3s ease;
  cursor: pointer;
}

.sidebar-news-item:hover {
  background: #f8f9fa;
}

.sidebar-news-number {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
  color: white;
  border-radius: 50%;
  font-weight: 700;
  font-size: 12px;
  flex-shrink: 0;
}

.sidebar-news-text {
  flex: 1;
}

.sidebar-news-title {
  font-size: 13px;
  font-weight: 600;
  color: #1a1a1a;
  line-height: 1.4;
  margin-bottom: 4px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.sidebar-news-meta {
  font-size: 12px;
  color: #999;
}

.stats-container {
  display: grid;
  gap: 12px;
}

.stat-item {
  display: flex;
  justify-content: space-between;
  padding: 12px;
  background: #f8f9fa;
  border-radius: 6px;
}

.stat-label {
  font-size: 12px;
  color: #999;
}

.stat-value {
  font-size: 18px;
  font-weight: 700;
  color: #4a90e2;
}

.source-info {
  padding: 12px;
}

.source-name {
  font-size: 14px;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 4px;
}

.source-url {
  font-size: 12px;
  color: #4a90e2;
  margin-bottom: 8px;
}

.source-desc {
  font-size: 12px;
  color: #999;
  line-height: 1.5;
}

@media (max-width: 1200px) {
  .page-header, .category-tabs {
    padding: 0 24px;
  }

  .content-wrapper {
    grid-template-columns: 1fr;
    padding: 0 24px;
  }

  .card-content {
    grid-template-columns: 240px 1fr;
  }

  .sidebar {
    position: static;
  }
}

@media (max-width: 768px) {
  .news-container {
    padding: 24px 0;
  }

  .page-header {
    flex-direction: column;
    gap: 16px;
    padding: 0 16px;
  }

  .page-title {
    font-size: 24px;
  }

  .category-tabs {
    padding: 0 16px;
  }

  .content-wrapper {
    padding: 0 16px;
  }

  .card-content {
    grid-template-columns: 1fr;
  }

  .card-image-wrapper {
    height: 240px;
  }

  .sidebar {
    order: -1;
    margin-bottom: 24px;
  }
}
</style>