<template>
  <div class="news-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <h1 class="page-title">新闻资讯</h1>
      <button class="publish-btn">
        <span class="plus-icon">+</span>
        资讯新闻
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
        <div
            v-for="(article, index) in filteredArticles"
            :key="article.id"
            :class="['news-card', { 'fade-in': true }]"
            :style="{ '--delay': `${index * 50}ms` }"
        >
          <div class="card-content">
            <div class="card-image-wrapper">
              <img :src="article.image" :alt="article.title" class="card-image">
              <div class="card-overlay"></div>
            </div>

            <div class="card-text">
              <h3 class="card-title">{{ article.title }}</h3>
              <p class="card-description">{{ article.description }}</p>

              <div class="card-meta">
                <span class="meta-item">
                  <i class="icon-view">👁</i>
                  {{ article.views }}
                </span>
                <span class="meta-item">
                  <i class="icon-comment">💬</i>
                  {{ article.comments }}
                </span>
                <span class="meta-time">
                  <i class="icon-time">📅</i>
                  {{ formatTime(article.time) }}
                </span>
              </div>
            </div>
          </div>
        </div>

        <!-- 加载更多 -->
        <div class="load-more">
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
                v-for="news in hotNews"
                :key="news.id"
                class="sidebar-news-item"
            >
              <div class="sidebar-news-icon">📰</div>
              <div class="sidebar-news-text">
                <h5 class="sidebar-news-title">{{ news.title }}</h5>
                <p class="sidebar-news-meta">{{ news.views }} 次浏览</p>
              </div>
            </div>
          </div>
        </div>

        <!-- 校园连接 -->
        <div class="sidebar-widget">
          <div class="widget-header">
            <h4 class="widget-title">校园连接</h4>
            <a href="#" class="widget-link">全部</a>
          </div>
          <div class="sidebar-links">
            <a
                v-for="link in campusLinks"
                :key="link.id"
                :href="link.url"
                class="sidebar-link-item"
            >
              <span class="link-icon">🔗</span>
              {{ link.name }}
            </a>
          </div>
        </div>

        <!-- 常见问题 -->
        <div class="sidebar-widget">
          <div class="widget-header">
            <h4 class="widget-title">常见问题</h4>
          </div>
          <div class="sidebar-faqs">
            <a
                v-for="faq in faqs"
                :key="faq.id"
                :href="faq.url"
                class="faq-item"
            >
              <span class="faq-icon">❓</span>
              {{ faq.question }}
            </a>
          </div>
        </div>
      </aside>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const activeCategory = ref('学技说法')

const categories = [
  { id: '学校新闻', name: '学校新闻' },
  { id: '政策条规', name: '政策条规' },
  { id: '通知公告', name: '通知公告' },
  { id: '学术活动', name: '学术活动' },
  { id: '学生生活', name: '学生生活' }
]

const articles = ref([
  {
    id: 1,
    category: '学校新闻',
    title: '马克思思想政学院学力主题教育专题讲座',
    description: '马克思思想政学院举行目的贯彻学力主题教育专题讲座，鼓励学生积极参加。',
    image: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=500&h=300&fit=crop',
    views: '2345',
    comments: '0',
    time: Date.now() - 2 * 60 * 60 * 1000
  },
  {
    id: 2,
    category: '学校新闻',
    title: '学校召开新学期工作会议暨教师培训',
    description: '定期听课讲，走访调理助推送给内忆交流，教师专业报告提升工作成果。',
    image: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=500&h=300&fit=crop',
    views: '1892',
    comments: '1',
    time: Date.now() - 1 * 24 * 60 * 60 * 1000
  },
  {
    id: 3,
    category: '政策条规',
    title: '关于开展校园安全检查的通知',
    description: '贯彻了众多师主管部周的组建与安全、适应校园领域教学纲要',
    image: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=500&h=300&fit=crop',
    views: '1546',
    comments: '2',
    time: Date.now() - 2 * 24 * 60 * 60 * 1000
  },
  {
    id: 4,
    category: '学术活动',
    title: '架构青年年教师教学实践因素简介',
    description: '着师回略年度法法活动答言，透读青年回为年学宗毕对答议交注重焦点',
    image: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=500&h=300&fit=crop',
    views: '1768',
    comments: '3',
    time: Date.now() - 3 * 24 * 60 * 60 * 1000
  },
  {
    id: 5,
    category: '学生生活',
    title: '同奔人新思想政教育故实的辉说',
    description: '践行同时教活期构宣言，透读教育为故本安为对于焦考方文艺研究',
    image: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=500&h=300&fit=crop',
    views: '1654',
    comments: '1',
    time: Date.now() - 4 * 24 * 60 * 60 * 1000
  }
])

const hotNews = [
  { id: 1, title: '马克思思想政学办主题教育专题讲座', views: '2345' },
  { id: 2, title: '学校召开新学期工作会议暨教师培训', views: '1892' },
  { id: 3, title: '拟因考虑年度教学评说', views: '1766' }
]

const campusLinks = [
  { id: 1, name: '思政课堂', url: '#' },
  { id: 2, name: '选择推荐', url: '#' },
  { id: 3, name: '拟因省年度评说年建', url: '#' }
]

const faqs = [
  { id: 1, question: '如因金辉和下降习系统？', url: '#' },
  { id: 2, question: '学生学新在哪里属呢？', url: '#' },
  { id: 3, question: '如因新安宗的操市日画匙？', url: '#' }
]

const filteredArticles = computed(() => {
  return articles.value.filter(article =>
      article.category === activeCategory.value
  )
})

const formatTime = (timestamp) => {
  const now = Date.now()
  const diff = now - timestamp
  const minutes = Math.floor(diff / 60000)
  const hours = Math.floor(diff / 3600000)
  const days = Math.floor(diff / 86400000)

  if (minutes < 60) return `${minutes}分钟前`
  if (hours < 24) return `${hours}小时前`
  if (days < 7) return `${days}天前`

  const date = new Date(timestamp)
  return date.toLocaleDateString('zh-CN')
}

const loadMore = () => {
  console.log('加载更多新闻')
}
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

/* 页面标题 */
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

.plus-icon {
  font-size: 18px;
}

/* 分类标签 */
.category-tabs {
  display: flex;
  gap: 12px;
  max-width: 1400px;
  margin: 0 auto 40px;
  padding: 0 40px;
  overflow-x: auto;
  scrollbar-width: none;
}

.category-tabs::-webkit-scrollbar {
  display: none;
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
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  position: relative;
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

/* 内容包装 */
.content-wrapper {
  display: grid;
  grid-template-columns: 1fr 360px;
  gap: 40px;
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 40px;
}

/* 新闻列表 */
.news-feed {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.news-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  animation: slideIn 0.6s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
  animation-delay: var(--delay, 0ms);
  opacity: 0;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
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
  flex-shrink: 0;
}

.card-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.card-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, rgba(74, 144, 226, 0) 0%, rgba(74, 144, 226, 0.1) 100%);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.news-card:hover .card-image {
  transform: scale(1.05);
}

.news-card:hover .card-overlay {
  opacity: 1;
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
  transition: color 0.3s ease;
}

.news-card:hover .card-title {
  color: #4a90e2;
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
  padding-top: 12px;
  border-top: 1px solid #f0f0f0;
  font-size: 13px;
  color: #999;
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

.icon-view, .icon-comment, .icon-time {
  font-size: 14px;
}

.meta-time {
  margin-left: auto;
  display: flex;
  align-items: center;
  gap: 6px;
}

/* 加载更多 */
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
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.load-more-btn:hover {
  background: #4a90e2;
  color: white;
  border-color: #4a90e2;
  box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);
}

.arrow {
  font-size: 16px;
  transition: transform 0.3s ease;
}

.load-more-btn:hover .arrow {
  transform: translateX(4px);
}

/* 侧栏 */
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
  transition: box-shadow 0.3s ease;
}

.sidebar-widget:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
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
  transition: color 0.3s ease;
}

.widget-link:hover {
  color: #357abd;
}

/* 侧栏新闻列表 */
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

.sidebar-news-icon {
  font-size: 20px;
  flex-shrink: 0;
}

.sidebar-news-text {
  flex: 1;
  min-width: 0;
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

/* 侧栏链接 */
.sidebar-links {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.sidebar-link-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 12px;
  border-radius: 6px;
  font-size: 13px;
  color: #4a90e2;
  text-decoration: none;
  transition: all 0.3s ease;
}

.sidebar-link-item:hover {
  background: #f0f4ff;
  color: #357abd;
  transform: translateX(4px);
}

.link-icon {
  font-size: 14px;
  flex-shrink: 0;
}

/* 常见问题 */
.sidebar-faqs {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.faq-item {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 10px 12px;
  border-radius: 6px;
  font-size: 13px;
  color: #4a90e2;
  text-decoration: none;
  transition: all 0.3s ease;
  line-height: 1.4;
}

.faq-item:hover {
  background: #f0f4ff;
  color: #357abd;
  transform: translateX(4px);
}

.faq-icon {
  font-size: 14px;
  flex-shrink: 0;
  margin-top: 2px;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .page-header {
    padding: 0 24px;
  }

  .category-tabs {
    padding: 0 24px;
  }

  .content-wrapper {
    grid-template-columns: 1fr;
    padding: 0 24px;
  }

  .card-content {
    grid-template-columns: 240px 1fr;
    gap: 16px;
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
    margin-bottom: 24px;
  }

  .page-title {
    font-size: 24px;
  }

  .category-tabs {
    padding: 0 16px;
    margin-bottom: 24px;
  }

  .content-wrapper {
    padding: 0 16px;
  }

  .card-content {
    grid-template-columns: 1fr;
    gap: 16px;
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