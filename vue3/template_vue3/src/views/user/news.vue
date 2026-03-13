<template>
  <div class="news-container">
    <section class="hero-section">
      <div class="hero-copy">
        <div class="hero-copy-main">
          <h1 class="hero-title">新闻资讯</h1>
          <p class="hero-subtitle">Marxism Cloud Platform News</p>
        </div>
        <a
            class="hero-source-link"
            href="https://news.xjtu.edu.cn/zyxw.htm"
            target="_blank"
            rel="noreferrer"
        >
          <span class="hero-source-link-main">
            <span class="hero-source-link-title">西安交通大学新闻网</span>
            <span class="hero-source-link-desc">权威发布校园要闻、学术动态与专题报道</span>
          </span>
          <span class="hero-source-link-action">进入官网</span>
        </a>

        <section class="hero-learning-widget">
          <div class="hero-learning-header">
            <h3 class="hero-learning-title">每日一学</h3>
            <button class="hero-learning-refresh" type="button" @click="refreshDailyQuote">
              换一条
            </button>
          </div>
          <div class="hero-learning-content">
            <p class="hero-learning-text">“{{ dailyQuote.text }}”</p>
            <div class="hero-learning-source-box">
              <span class="hero-learning-dash">——</span>
              <span class="hero-learning-source">{{ dailyQuote.source }}</span>
            </div>
          </div>
        </section>
      </div>

      <div class="hero-carousel">
        <el-carousel :interval="5600" arrow="always" height="376px">
          <el-carousel-item v-for="slide in heroSlides" :key="slide.title">
            <article class="hero-slide" :style="slideStyle(slide)">
              <div class="hero-slide-content">
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
        <div class="headline-footer">
          <a :href="item.link" target="_blank" rel="noreferrer">进入阅读</a>
        </div>
      </article>
    </section>

    <section class="content-wrapper">
      <div class="news-column">
        <div class="section-header">
          <div class="section-copy">
            <h2 class="section-title">最新资讯</h2>
          </div>
          <a
              class="section-link"
              href="https://www.qstheory.cn/"
              target="_blank"
              rel="noreferrer"
          >
            更多资讯
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
              v-for="article in displayedArticles"
              :key="article.id"
              class="news-card"
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
                <div class="card-source-group">
                  <span class="card-source">{{ article.source || '西安交通大学新闻网' }}</span>
                  <span class="card-dot"></span>
                  <span class="card-time">{{ formatDate(article.date) }}</span>
                </div>
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

              <div class="card-footer">
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
            </div>
          </article>
        </div>

        <div
            v-if="showAllPagination"
            class="news-pagination"
            role="navigation"
            aria-label="全部新闻分页导航"
        >
          <button
              type="button"
              class="pagination-btn"
              :disabled="allCurrentPage === 1"
              @click="changeAllPage(allCurrentPage - 1)"
          >
            上一页
          </button>

          <template v-for="item in allPaginationItems" :key="item.key">
            <button
                v-if="item.type === 'page'"
                type="button"
                :class="['pagination-btn', 'page-btn', { active: item.value === allCurrentPage }]"
                @click="changeAllPage(item.value)"
            >
              {{ item.value }}
            </button>
            <span v-else class="pagination-ellipsis">…</span>
          </template>

          <button
              type="button"
              class="pagination-btn"
              :disabled="allCurrentPage === allTotalPages"
              @click="changeAllPage(allCurrentPage + 1)"
          >
            下一页
          </button>
        </div>

      </div>

      <aside class="sidebar">
        <section class="sidebar-widget">
          <div class="widget-header">
            <div>
              <h3 class="widget-title">热门新闻</h3>
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
          </div>
          <ul class="campus-links">
            <li
                v-for="item in campusLinks"
                :key="item.title"
            >
              <a
                  class="campus-link"
                  :href="item.link"
                  target="_blank"
                  rel="noreferrer"
              >
                {{ item.title }}
              </a>
            </li>
          </ul>
        </section>

        <section class="sidebar-widget">
          <div class="widget-header">
            <h3 class="widget-title">学生常见问题</h3>
          </div>
          <div class="faq-list">
            <button
                v-for="faq in studentFaqs"
                :key="faq.id"
                class="faq-item"
                type="button"
                @click="toggleFaq(faq.id)"
            >
              <span class="faq-question-row">
                <span class="faq-question">{{ faq.question }}</span>
                <span class="faq-toggle">{{ openFaqId === faq.id ? '－' : '＋' }}</span>
              </span>
              <span v-if="openFaqId === faq.id" class="faq-answer">{{ faq.answer }}</span>
            </button>
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

const FIXED_NEWS_COUNT = 4
const LOCAL_DYNAMIC_COUNT = 26
const HOT_NEWS_COUNT = 8
const ALL_PAGE_SIZE = 5
const CATEGORY_BASE_PICK_COUNT = 4

const categories = [
  { id: 'all', name: '全部' },
  { id: 'theory', name: '理论学习' },
  { id: 'politics', name: '时政热点' },
  { id: 'campus', name: '校园动态' },
  { id: 'notice', name: '通知公告' }
]

const heroSlides = [
  {
    title: '全国两会观察：把高质量发展要求贯穿全年工作主线',
    summary: '聚焦权威时政报道与两会专题解读，适合作为页面顶部焦点资讯入口，快速掌握当前重要政策议题。',
    source: '新华网',
    link: 'https://www.news.cn/politics/',
    image: 'https://img2.baidu.com/it/u=3173549564,1514066771&fm=253&fmt=auto&app=138&f=JPEG?w=763&h=500',
    focalPoint: 'center center'
  },
  {
    title: '理论学习纵横：持续推动党的创新理论入脑入心',
    summary: '围绕理论阐释、思想引领和实践转化组织内容，更贴合当前页面的理论学习与思想政治资讯定位。',
    source: '求是网',
    link: 'https://www.qstheory.cn/',
    image: 'https://img1.baidu.com/it/u=2205595552,1505893496&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=667',
    focalPoint: 'center 42%'
  },
  {
    title: '思想引领：把思政工作贯穿教育教学与育人全过程',
    summary: '聚合理论频道中的权威评论和学习文章，强化思政、理论与教育协同的内容氛围，保持页面整体主题一致。',
    source: '人民网理论频道',
    link: 'https://theory.people.com.cn/',
    image: 'https://img2.baidu.com/it/u=675422831,4156642598&fm=253&fmt=auto&app=138&f=JPEG?w=880&h=373',
    focalPoint: 'center center'
  },
  {
    title: '政策解读：围绕教育科技人才一体推进看部署落地',
    summary: '以政策发布、权威解读和制度安排为核心，补足页面在时政政策维度上的信息感和专业感。',
    source: '中国政府网',
    link: 'https://www.gov.cn/zhengce/',
    image: 'https://mediabluk.cnr.cn/img/cnr/CNRCDP/2025/1219/d8bd1a8430366176610830204319513110.png?auth=4505791332cf1dfbed801b348ca4ca7c',
    focalPoint: 'center 38%'
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
    tag: '马克思主义学院',
    title: '西安交通大学马克思主义学院',
    description: '进入马克思主义学院官网，查看学院新闻、理论动态和思政教育活动内容。',
    link: 'https://marx.xjtu.edu.cn/'
  }
]

const hotNewsPool = [
  {
    title: '理论强，才能方向明：把学习成果转化为治理效能',
    source: '求是网',
    link: 'https://www.qstheory.cn/'
  },
  {
    title: '全国两会观察：高质量发展与民生改善同频共振',
    source: '新华网',
    link: 'https://www.news.cn/politics/'
  },
  {
    title: '理论频道聚焦：坚持系统观念推进教育现代化',
    source: '人民网理论频道',
    link: 'https://theory.people.com.cn/'
  },
  {
    title: '时政新闻眼：把握政策连续性和改革协同性',
    source: '央视网',
    link: 'https://news.cctv.com/china/'
  },
  {
    title: '政策解读：以科技创新引领新质生产力发展',
    source: '中国政府网',
    link: 'https://www.gov.cn/zhengce/'
  },
  {
    title: '理论纵横：完善立德树人机制，夯实高校育人基础',
    source: '光明网理论频道',
    link: 'https://theory.gmw.cn/'
  },
  {
    title: '求是评论：坚持人民立场是马克思主义的根本政治立场',
    source: '求是网',
    link: 'https://www.qstheory.cn/'
  },
  {
    title: '两会现场速递：教育、就业与科技议题持续升温',
    source: '新华网',
    link: 'https://www.news.cn/politics/2026lh/index.html'
  },
  {
    title: '理论学习参考：推动思政工作融入日常、做在经常',
    source: '人民网',
    link: 'https://theory.people.com.cn/'
  },
  {
    title: '时政周刊：以改革精神激发基层治理新活力',
    source: '央视网',
    link: 'https://news.cctv.com/china/'
  },
  {
    title: '专题研读：推动高水平对外开放与制度型开放协同',
    source: '光明网',
    link: 'https://theory.gmw.cn/'
  },
  {
    title: '政策观察：教育强国建设中的关键支撑体系',
    source: '中国政府网',
    link: 'https://www.gov.cn/zhengce/'
  },
  {
    title: '国际时政追踪：全球治理议题与多边合作的现实挑战',
    source: 'CNN Politics',
    link: 'https://www.cnn.com/politics'
  },
  {
    title: '国际观察：地区安全与发展议题进入政策协调阶段',
    source: 'Reuters World',
    link: 'https://www.reuters.com/world/'
  },
  {
    title: '两会热点追踪：教育数字化与人才培养体系持续升级',
    source: '新华网',
    link: 'https://www.news.cn/politics/'
  },
  {
    title: '政策观察：完善高校思政课程体系与实践协同机制',
    source: '求是网',
    link: 'https://www.qstheory.cn/'
  },
  {
    title: '权威解读：推动高校科研创新与服务国家战略同向发力',
    source: '人民网',
    link: 'https://theory.people.com.cn/'
  },
  {
    title: '教育资讯：新学期学风建设与课堂质量提升重点发布',
    source: '央视网',
    link: 'https://news.cctv.com/china/'
  }
]

const campusLinks = [
  {
    title: '规章制度',
    link: 'https://dean.xjtu.edu.cn/gzzd/jwgl.htm'
  },
  {
    title: '校园动态',
    link: 'https://dean.xjtu.edu.cn/jxxx/jxdt.htm'
  },
  {
    title: '国际交流',
    link: 'https://news.xjtu.edu.cn/gjjl.htm'
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
    answer: '请先检查网络连接和浏览器拦截设置；若外链暂时无法访问，建议稍后重试或切换浏览器。'
  },
  {
    id: 'faq-4',
    question: '如何查看个人学习信息？',
    answer: '登录后可通过左侧菜单进入“在线学习”或“个人中心”，查看课程学习情况和个人基础信息。'
  }
]

const dailyQuotePool = [
  {
    text: '哲学家们只是用不同的方式解释世界，问题在于改变世界。',
    source: '马克思'
  },
  {
    text: '每个人的自由发展是一切人的自由发展的条件。',
    source: '马克思、恩格斯'
  },
  {
    text: '在科学上没有平坦的大道，只有不畏劳苦沿着陡峭山路攀登的人，才有希望到达光辉的顶点。',
    source: '马克思'
  },
  {
    text: '理论一经掌握群众，也会变成物质力量。',
    source: '马克思'
  },
  {
    text: '一个民族要想站在科学的最高峰，就一刻也不能没有理论思维。',
    source: '恩格斯'
  },
  {
    text: '劳动创造了人本身。',
    source: '恩格斯'
  },
  {
    text: '一个幽灵，共产主义的幽灵，在欧洲游荡。',
    source: '马克思、恩格斯'
  },
  {
    text: '没有革命的理论，就不会有革命的运动。',
    source: '列宁'
  },
  {
    text: '共产主义就是苏维埃政权加全国电气化。',
    source: '列宁'
  },
  {
    text: '学习，学习，再学习。',
    source: '列宁'
  },
  {
    text: '没有调查，就没有发言权。',
    source: '毛泽东'
  },
  {
    text: '实事求是。',
    source: '毛泽东'
  },
  {
    text: '星星之火，可以燎原。',
    source: '毛泽东'
  },
  {
    text: '人民，只有人民，才是创造世界历史的动力。',
    source: '毛泽东'
  },
  {
    text: '世界是你们的，也是我们的，但是归根结底是你们的。',
    source: '毛泽东'
  },
  {
    text: '为中华之崛起而读书。',
    source: '周恩来'
  },
  {
    text: '发展才是硬道理。',
    source: '邓小平'
  },
  {
    text: '科学技术是第一生产力。',
    source: '邓小平'
  },
  {
    text: '解放思想，实事求是，团结一致向前看。',
    source: '邓小平'
  },
  {
    text: '共产党人可以把自己的理论概括为一句话：消灭私有制。',
    source: '马克思、恩格斯'
  },
  {
    text: '人的本质并不是单个人所固有的抽象物，在其现实性上，它是一切社会关系的总和。',
    source: '马克思'
  },
  {
    text: '社会生活在本质上是实践的。',
    source: '马克思'
  },
  {
    text: '我们的理论是发展的理论，而不是必须背得烂熟并机械地加以重复的教条。',
    source: '列宁'
  },
  {
    text: '政治路线确定之后，干部就是决定因素。',
    source: '毛泽东'
  },
  {
    text: '为人民服务。',
    source: '毛泽东'
  },
  {
    text: '我们爱我们的民族，这是我们自信心的泉源。',
    source: '周恩来'
  },
  {
    text: '摸着石头过河。',
    source: '邓小平'
  }
]

const curatedArticlePool = [
  {
    id: 'pool-1',
    title: '推动思想政治工作做在日常落到基层',
    description: '围绕高校思政工作的常态化与基层化路径，强调在具体场景中提升育人实效。',
    image: 'https://img2.baidu.com/it/u=3589784601,958620663&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500',
    link: 'https://www.qstheory.cn/20260115/234f9c7d95d84a8f8590625021d1c4ca/c.html',
    date: '2026-03-11',
    source: '求是网',
    category: 'theory'
  },
  {
    id: 'pool-2',
    title: '打牢做好思想政治工作的基本功',
    description: '聚焦思政工作中的能力建设和机制完善，适合作为理论学习起点内容。',
    image: 'https://img2.baidu.com/it/u=1585019232,1784597970&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=889',
    link: 'https://www.qstheory.cn/20260131/64d379bc41184055ac077ad3f7795ee7/c.html',
    date: '2026-03-10',
    source: '求是网',
    category: 'theory'
  },
  {
    id: 'pool-4',
    title: '走好中国式现代化关键一程',
    description: '从阶段任务和总体目标两方面切入，梳理当前时政与发展重点。',
    image: 'https://www.qstheory.cn/20260306/90f8b0af2f9a489081837716cb6d227f/2026030690f8b0af2f9a489081837716cb6d227f_20260306a0ad2c40677e4e11ad8e97b61fcb4beb.jpeg',
    link: 'https://www.qstheory.cn/20260306/90f8b0af2f9a489081837716cb6d227f/c.html',
    date: '2026-03-08',
    source: '求是网',
    category: 'politics'
  },
  {
    id: 'pool-5',
    title: '两会现场速递丨教育部部长：持续提升高等教育服务能力',
    description: '聚焦教育治理和人才培养改革，关注政策导向与校园实践连接。',
    image: 'https://www.news.cn/politics/20260312/59573588d09544a38c504b883a9724fe/31f4f502a38a44b1bc5a40613641a703.jpg',
    link: 'https://www.news.cn/politics/2026lh/index.html',
    date: '2026-03-07',
    source: '新华网',
    category: 'politics'
  },
  {
    id: 'pool-6',
    title: '政策解读：加快建设高质量教育体系',
    description: '围绕教育体系建设中的关键指标和实施路径，提供可参考的政策脉络。',
    image: 'https://www.gov.cn/zhengce/jiedu/tujie/202603/W020260312780153198844_ORIGIN.jpg',
    link: 'https://www.gov.cn/zhengce/',
    date: '2026-03-06',
    source: '中国政府网',
    category: 'politics'
  },
  {
    id: 'pool-7',
    title: '理论学习：坚持系统观念推进教育现代化',
    description: '从系统观念切入教育改革，强调改革协同和治理效能同步提升。',
    image: 'https://img1.baidu.com/it/u=2705010477,3360194056&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=889',
    link: 'https://theory.gmw.cn/',
    date: '2026-03-05',
    source: '光明网理论频道',
    category: 'theory'
  },
  {
    id: 'pool-8',
    title: '时政观察：科技创新与产业升级的协同路径',
    description: '聚焦科技政策与产业结构调整，在时政背景下理解高质量发展动力。',
    image: 'https://img0.baidu.com/it/u=169175187,817175624&fm=253&fmt=auto&app=138&f=JPEG?w=667&h=500',
    link: 'https://news.cctv.com/china/',
    date: '2026-03-04',
    source: '央视网',
    category: 'politics'
  },
  {
    id: 'pool-9',
    title: '校园动态：思政实践课程优秀案例交流会举行',
    description: '围绕课程建设与实践育人经验开展交流，提升课堂与实践协同质量。',
    image: 'https://img0.baidu.com/it/u=3626409601,3520749539&fm=253&fmt=auto&app=120&f=JPEG?w=1276&h=800',
    link: 'https://dean.xjtu.edu.cn/jxxx/jxdt.htm',
    date: '2026-03-03',
    source: '西安交通大学教务处',
    category: 'campus'
  },
  {
    id: 'pool-10',
    title: '通知公告：本学期理论学习专题讲座安排发布',
    description: '聚焦理论学习专题讲座的时间安排和参与方式，便于师生统一规划。',
    image: 'https://img0.baidu.com/it/u=2069246692,4064812800&fm=253&fmt=auto&app=120&f=JPEG?w=750&h=500',
    link: 'https://dean.xjtu.edu.cn/jxxx/jxtz2.htm',
    date: '2026-03-02',
    source: '西安交通大学教务处',
    category: 'notice'
  },
  {
    id: 'pool-11',
    title: '国际交流：马克思主义理论国际传播专题论坛举行',
    description: '论坛围绕理论传播与国际对话展开，强调学术交流与实践应用结合。',
    image: 'https://img0.baidu.com/it/u=1033046783,3125940332&fm=253&fmt=auto&app=138&f=JPEG?w=754&h=500',
    link: 'https://news.xjtu.edu.cn/gjjl.htm',
    date: '2026-03-01',
    source: '西安交通大学新闻网',
    category: 'campus'
  },
  {
    id: 'pool-12',
    title: '理论导读：在调查研究中提升政策理解力与执行力',
    description: '从调研方法与政策落实关系出发，强调在实践中增强问题解决能力。',
    image: 'https://img0.baidu.com/it/u=1924945106,1990179039&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=649',
    link: 'https://theory.people.com.cn/',
    date: '2026-02-28',
    source: '人民网',
    category: 'theory'
  },
  {
    id: 'pool-13',
    title: '时政聚焦：统筹发展和安全，提升治理现代化水平',
    description: '结合当前时政重点，分析治理体系现代化的现实任务和推进节奏。',
    image: 'https://img1.baidu.com/it/u=4142880624,664479926&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=500',
    link: 'https://www.news.cn/politics/',
    date: '2026-02-27',
    source: '新华网',
    category: 'politics'
  },
  {
    id: 'pool-14',
    title: '理论学习参考：马克思主义基本原理与现实问题分析',
    description: '突出原理学习和现实分析的结合方式，适合作为课程拓展阅读材料。',
    image: 'https://img2.baidu.com/it/u=946817778,2240996961&fm=253&fmt=auto&app=138&f=JPEG?w=787&h=500',
    link: 'https://www.qstheory.cn/',
    date: '2026-02-26',
    source: '求是网',
    category: 'theory'
  },
  {
    id: 'pool-15',
    title: '教育时评：以课程思政推动专业教育与价值教育同向同行',
    description: '通过课程思政案例梳理，展示专业课程与价值引导的协同路径。',
    image: 'https://img2.baidu.com/it/u=3059065725,44705855&fm=253&fmt=auto&app=138&f=JPEG?w=606&h=343',
    link: 'https://theory.gmw.cn/',
    date: '2026-02-25',
    source: '光明网',
    category: 'theory'
  },
  {
    id: 'pool-16',
    title: '学习动态：面向青年群体优化理论学习资源供给',
    description: '强调内容供给与学习场景匹配，让理论学习更具连续性和实践性。',
    image: 'https://img1.baidu.com/it/u=1215609842,726647569&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500',
    link: 'https://theory.people.com.cn/',
    date: '2026-02-24',
    source: '人民网理论频道',
    category: 'theory'
  },
  {
    id: 'pool-17',
    title: '理论研习：坚持和发展马克思主义必须同中国具体实际相结合',
    description: '围绕理论创新与实践创新的统一关系，梳理学习中应把握的关键方法论。',
    image: 'https://img0.baidu.com/it/u=954241299,210392241&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=889',
    link: 'https://www.qstheory.cn/',
    date: '2026-02-23',
    source: '求是网',
    category: 'theory'
  },
  {
    id: 'pool-18',
    title: '理论观察：人民立场是思想政治教育的根本遵循',
    description: '从群众观点和群众路线出发，讨论高校思想政治工作中“以学生为中心”的实施路径。',
    image: 'https://img0.baidu.com/it/u=1779282902,4006624582&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=889',
    link: 'https://theory.people.com.cn/',
    date: '2026-02-22',
    source: '人民网理论频道',
    category: 'theory'
  },
  {
    id: 'pool-19',
    title: '读原著学原文：历史唯物主义视角下的教育治理现代化',
    description: '聚焦历史唯物主义的分析框架，结合教育治理场景开展专题学习。',
    image: 'https://img0.baidu.com/it/u=3011574549,2467945177&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=742',
    link: 'https://theory.gmw.cn/',
    date: '2026-02-21',
    source: '光明网理论频道',
    category: 'theory'
  },
  {
    id: 'pool-20',
    title: '课程思政专题：推进大中小学思政课一体化建设',
    description: '关注课程体系衔接、教学资源协同与育人目标一致性，提升思政教育系统性。',
    image: 'https://img0.baidu.com/it/u=4279973735,1645023083&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=620',
    link: 'https://www.news.cn/politics/',
    date: '2026-02-20',
    source: '新华网',
    category: 'theory'
  },
  {
    id: 'pool-21',
    title: '时政解读：以高水平安全保障高质量发展',
    description: '围绕安全与发展的统筹关系，分析当前政策部署中的结构性重点。',
    image: 'https://img1.baidu.com/it/u=3842409983,2283256798&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500',
    link: 'https://www.gov.cn/zhengce/',
    date: '2026-02-19',
    source: '中国政府网',
    category: 'politics'
  },
  {
    id: 'pool-22',
    title: '政策跟踪：就业优先与青年发展支持政策协同发力',
    description: '聚焦青年就业、教育衔接与人才培养政策在基层场景中的协同落地。',
    image: 'https://img1.baidu.com/it/u=2145549819,2356683731&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=614',
    link: 'https://www.news.cn/politics/',
    date: '2026-02-18',
    source: '新华网',
    category: 'politics'
  },
  {
    id: 'pool-23',
    title: '国际观察：多边合作框架下的全球治理议题持续推进',
    description: '从国际政治视角梳理主要治理议题，帮助理解外部环境对国内发展的影响。',
    image: 'https://img0.baidu.com/it/u=2733345387,1784935073&fm=253&fmt=auto&app=138&f=JPEG?w=756&h=500',
    link: 'https://www.cnn.com/politics',
    date: '2026-02-17',
    source: 'CNN Politics',
    category: 'politics'
  },
  {
    id: 'pool-24',
    title: '时政观察：科技创新、产业升级与区域协调发展',
    description: '结合近期政策取向，分析创新驱动与区域协同在现代化建设中的作用。',
    image: 'https://img1.baidu.com/it/u=3646410194,4276587735&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=889',
    link: 'https://news.cctv.com/china/',
    date: '2026-02-16',
    source: '央视网',
    category: 'politics'
  },
  {
    id: 'pool-25',
    title: '政策纵览：教育、科技、人才一体推进的实施路径',
    description: '梳理教育强国、科技强国、人才强国战略协同推进的政策逻辑与重点任务。',
    image: 'https://img2.baidu.com/it/u=2152670583,2126270231&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=592',
    link: 'https://www.gov.cn/zhengce/',
    date: '2026-02-15',
    source: '中国政府网',
    category: 'politics'
  },
  {
    id: 'pool-26',
    title: '校园动态：人物风采栏目更新青年教师育人事迹',
    description: '聚焦教师教学创新与育人实践，展示校园思政和专业教育协同成果。',
    image: 'https://img2.baidu.com/it/u=2544266381,894101798&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1132',
    link: 'https://news.xjtu.edu.cn/rwfc.htm',
    date: '2026-02-14',
    source: '西安交通大学新闻网',
    category: 'campus'
  },
  {
    id: 'pool-27',
    title: '校园服务：书院育人活动与学生发展支持持续推进',
    description: '围绕学生成长支持体系，关注校园服务与思想引导相结合的实践模式。',
    image: 'https://img1.baidu.com/it/u=3610532671,2572606525&fm=253&fmt=auto&app=120&f=JPEG?w=666&h=500',
    link: 'https://news.xjtu.edu.cn/shfw1/shfw.htm',
    date: '2026-02-13',
    source: '西安交通大学新闻网',
    category: 'campus'
  },
  {
    id: 'pool-28',
    title: '科研要闻：交叉学科团队发布阶段性研究进展',
    description: '聚焦科研组织与平台建设，体现学校在关键技术与基础研究方面的协同能力。',
    image: 'https://img1.baidu.com/it/u=2905154569,3180246878&fm=253&fmt=auto&app=138&f=JPEG?w=867&h=488',
    link: 'https://news.xjtu.edu.cn/kxyj.htm',
    date: '2026-02-12',
    source: '西安交通大学新闻网',
    category: 'campus'
  },
  {
    id: 'pool-29',
    title: '校园动态：实践教学专题交流会面向全校开放报名',
    description: '围绕实践教学改革与教学能力建设，推动学院间经验互鉴与资源共享。',
    image: 'https://img1.baidu.com/it/u=224322545,80848587&fm=253&fmt=auto&app=138&f=JPEG?w=667&h=500',
    link: 'https://dean.xjtu.edu.cn/jxxx/jxdt.htm',
    date: '2026-02-11',
    source: '西安交通大学教务处',
    category: 'campus'
  },
  {
    id: 'pool-30',
    title: '校园纪实：服务保障与学术活动联动机制持续完善',
    description: '关注校园保障体系与学术环境建设，提升师生学习科研体验。',
    image: 'https://img1.baidu.com/it/u=1003067787,2054303806&fm=253&fmt=auto&app=138&f=JPEG?w=775&h=500',
    link: 'https://news.xjtu.edu.cn/shfw1/shfw.htm',
    date: '2026-02-10',
    source: '西安交通大学新闻网',
    category: 'campus'
  },
  {
    id: 'pool-31',
    title: '通知公告：本学期课程调整与选课安排说明发布',
    description: '明确课程计划调整节点、选课规则与时间窗口，便于学生做好学习规划。',
    image: 'https://img1.baidu.com/it/u=83601900,2829504162&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1778',
    link: 'https://dean.xjtu.edu.cn/jxxx/jxtz2.htm',
    date: '2026-02-09',
    source: '西安交通大学教务处',
    category: 'notice'
  },
  {
    id: 'pool-32',
    title: '通知公告：实践环节教学管理要求与提交流程更新',
    description: '围绕实践教学过程管理，更新材料提交规范和时间要求。',
    image: 'https://img2.baidu.com/it/u=2488750953,3705641594&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1050',
    link: 'https://dean.xjtu.edu.cn/jxxx/jxtz2.htm',
    date: '2026-02-08',
    source: '西安交通大学教务处',
    category: 'notice'
  },
  {
    id: 'pool-33',
    title: '培养方案：专业培养方案修订意见征集通知',
    description: '组织各学院围绕培养目标、课程体系和能力导向开展修订建议征集。',
    image: 'https://img0.baidu.com/it/u=2924758767,662513202&fm=253&fmt=auto&app=120&f=JPEG?w=722&h=500',
    link: 'https://dean.xjtu.edu.cn/jxxx/pyfa.htm',
    date: '2026-02-07',
    source: '西安交通大学教务处',
    category: 'notice'
  },
  {
    id: 'pool-34',
    title: '通知公告：教学运行周报与课堂质量反馈通道开放',
    description: '完善教学运行反馈闭环，提升教学管理的响应效率与透明度。',
    image: 'https://img2.baidu.com/it/u=2263661474,926040949&fm=253&fmt=auto&app=120&f=JPEG?w=667&h=500',
    link: 'https://dean.xjtu.edu.cn/jxxx/jxdt.htm',
    date: '2026-02-06',
    source: '西安交通大学教务处',
    category: 'notice'
  },
  {
    id: 'pool-35',
    title: '培养方案：跨学科模块课程设置与修读建议发布',
    description: '结合培养方案要求，明确跨学科课程修读逻辑与能力培养目标。',
    image: 'https://img2.baidu.com/it/u=2517753008,2128672324&fm=253&fmt=auto&app=138&f=JPEG?w=750&h=500',
    link: 'https://dean.xjtu.edu.cn/jxxx/pyfa.htm',
    date: '2026-02-05',
    source: '西安交通大学教务处',
    category: 'notice'
  },
  {
    id: 'pool-36',
    title: '理论学习：坚持用马克思主义立场观点方法观察时代问题',
    description: '围绕立场观点方法的现实运用展开，强调理论学习与实际工作的统一。',
    image: 'https://img1.baidu.com/it/u=176226891,2767313969&fm=253&fmt=auto&app=138&f=JPEG?w=750&h=500',
    link: 'https://www.qstheory.cn/#study-20260204',
    date: '2026-02-04',
    source: '求是网',
    category: 'theory'
  },
  {
    id: 'pool-37',
    title: '理论前沿：推动党的创新理论进入课堂、进入头脑',
    description: '从课程建设与学习组织两方面讨论理论传播的有效机制，提升学习覆盖与质量。',
    image: 'https://img2.baidu.com/it/u=3434327559,2594707856&fm=253&fmt=auto&app=138&f=JPEG?w=667&h=500',
    link: 'https://theory.people.com.cn/#study-20260203',
    date: '2026-02-03',
    source: '人民网理论频道',
    category: 'theory'
  },
  {
    id: 'pool-38',
    title: '思想观察：在调查研究中把握社会主要矛盾的新变化',
    description: '聚焦调查研究方法和问题导向，提升对现实问题的辨析与政策理解能力。',
    image: 'https://img2.baidu.com/it/u=1758023591,3200699489&fm=253&fmt=auto&app=138&f=JPEG?w=550&h=312',
    link: 'https://theory.gmw.cn/#study-20260202',
    date: '2026-02-02',
    source: '光明网理论频道',
    category: 'theory'
  },
  {
    id: 'pool-39',
    title: '理论导读：历史唯物主义视角下的中国式现代化实践',
    description: '围绕生产力与生产关系、经济基础与上层建筑关系，解析现代化建设实践逻辑。',
    image: 'https://img1.baidu.com/it/u=2655365851,793219508&fm=253&fmt=auto&app=138&f=JPEG?w=683&h=389',
    link: 'https://www.qstheory.cn/#study-20260201',
    date: '2026-02-01',
    source: '求是网',
    category: 'theory'
  },
  {
    id: 'pool-40',
    title: '时政热点：稳中求进总基调下的宏观政策协同发力',
    description: '围绕财政、产业与民生政策协同，梳理阶段性重点任务和预期目标。',
    image: 'https://img1.baidu.com/it/u=1647789955,2734498272&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=755',
    link: 'https://www.news.cn/politics/#focus-20260131',
    date: '2026-01-31',
    source: '新华网',
    category: 'politics'
  },
  {
    id: 'pool-41',
    title: '政策解读：教育强国建设中的基础能力与制度保障',
    description: '聚焦教育治理现代化关键环节，讨论制度建设与执行效能的协同推进。',
    image: 'https://img0.baidu.com/it/u=3852769005,58934022&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=521',
    link: 'https://www.gov.cn/zhengce/#focus-20260130',
    date: '2026-01-30',
    source: '中国政府网',
    category: 'politics'
  },
  {
    id: 'pool-42',
    title: '时政追踪：科技创新与实体经济深度融合持续提速',
    description: '从产业链升级与创新链协同角度，关注高质量发展的结构性动力变化。',
    image: 'https://img2.baidu.com/it/u=701612233,2113831772&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500',
    link: 'https://news.cctv.com/china/#focus-20260129',
    date: '2026-01-29',
    source: '央视网',
    category: 'politics'
  },
  {
    id: 'pool-43',
    title: '国际观察：全球治理议题下的合作与发展新动向',
    description: '聚焦国际规则、发展倡议与地区合作，帮助理解外部环境对国内治理的影响。',
    image: 'https://q9.itc.cn/q_70/images03/20250902/9f113d1f42f947429e7d35a83dd4e2c2.jpeg',
    link: 'https://www.reuters.com/world/#focus-20260128',
    date: '2026-01-28',
    source: 'Reuters World',
    category: 'politics'
  },
  {
    id: 'pool-44',
    title: '校园动态：思政主题实践周活动总结与案例发布',
    description: '围绕实践育人成果与课程联动案例，展示学院协同推进思政建设的具体做法。',
    image: 'https://www.nefu.edu.cn/__local/8/D0/7B/4791B9636C17A89A25722C78B54_B6243A68_5002D2.jpg',
    link: 'https://news.xjtu.edu.cn/rwfc.htm#campus-20260127',
    date: '2026-01-27',
    source: '西安交通大学新闻网',
    category: 'campus'
  },
  {
    id: 'pool-45',
    title: '通知公告：理论学习专题研讨会报名与安排说明',
    description: '明确研讨会报名流程、参与对象与学习要求，便于师生按计划参加学习活动。',
    image: 'https://img0.baidu.com/it/u=3123405693,3050026514&fm=253&fmt=auto&app=138&f=JPEG?w=751&h=500',
    link: 'https://dean.xjtu.edu.cn/jxxx/jxtz2.htm#notice-20260126',
    date: '2026-01-26',
    source: '西安交通大学教务处',
    category: 'notice'
  }
]


const categoryKeywords = {
  theory: ['理论', '马克思主义', '思政', '党建', '思想政治', '高质量发展'],
  politics: ['两会', '时政', '政策', '现代化', '教育部', '外交', '规划'],
  notice: ['通知', '公告'],
  campus: ['交大', '校园', '学院', '学生', '活动', '图片交大']
}

const shuffleItems = (items = []) => {
  const copied = [...items]
  for (let i = copied.length - 1; i > 0; i -= 1) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[copied[i], copied[j]] = [copied[j], copied[i]]
  }
  return copied
}

const pickItems = (items = [], count = 0) => {
  if (!Array.isArray(items) || items.length === 0 || count <= 0) {
    return []
  }
  return shuffleItems(items).slice(0, Math.min(count, items.length))
}

const parseDateValue = (value) => {
  const timestamp = new Date(value).getTime()
  return Number.isNaN(timestamp) ? 0 : timestamp
}

const sortByDateDesc = (items = []) => [...items].sort((a, b) => parseDateValue(b.date) - parseDateValue(a.date))

const buildRandomQuote = (excludeText = '') => {
  const candidates = dailyQuotePool.filter((item) => item.text !== excludeText)
  const pool = candidates.length > 0 ? candidates : dailyQuotePool
  const selected = pool[Math.floor(Math.random() * pool.length)] || dailyQuotePool[0]
  return selected
}

const slideStyle = (slide) => ({
  backgroundImage: `linear-gradient(90deg, rgba(8, 16, 31, 0.82) 0%, rgba(8, 16, 31, 0.58) 36%, rgba(8, 16, 31, 0.24) 68%, rgba(8, 16, 31, 0.14) 100%), url(${slide.image})`,
  backgroundPosition: slide.focalPoint || 'center center',
  backgroundRepeat: 'no-repeat',
  backgroundSize: 'cover',
  backgroundColor: '#243142'
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

const buildLocalArticles = () => {
  const selectedItems = []
  const selectedKeys = new Set()
  const requiredCategories = ['theory', 'politics', 'campus', 'notice']

  requiredCategories.forEach((categoryId) => {
    const categoryItems = curatedArticlePool.filter((item) => item.category === categoryId)
    pickItems(categoryItems, CATEGORY_BASE_PICK_COUNT).forEach((item) => {
      const key = item.id || `${item.title}-${item.link}`
      if (selectedKeys.has(key)) {
        return
      }
      selectedKeys.add(key)
      selectedItems.push(item)
    })
  })

  if (selectedItems.length < LOCAL_DYNAMIC_COUNT) {
    const remainPool = curatedArticlePool.filter((item) => {
      const key = item.id || `${item.title}-${item.link}`
      return !selectedKeys.has(key)
    })

    pickItems(remainPool, LOCAL_DYNAMIC_COUNT - selectedItems.length).forEach((item) => {
      selectedItems.push(item)
    })
  }

  return sortByDateDesc(selectedItems).map((item, index) => {
    const dynamicId = `${item.id}-${Date.now()}-${index}`
    return normalizeArticle({ ...item, id: dynamicId }, index)
  })
}

const buildHotNewsItems = () => pickItems(hotNewsPool, HOT_NEWS_COUNT)

const activeCategory = ref('all')
const allCurrentPage = ref(1)
const loading = ref(false)
const error = ref(null)
const articles = ref([])
const openFaqId = ref(studentFaqs[0]?.id || '')
const hotNewsItems = ref(buildHotNewsItems())
const dailyQuote = ref(buildRandomQuote())

const refreshDailyQuote = () => {
  dailyQuote.value = buildRandomQuote(dailyQuote.value.text)
}

const mergeArticles = (remoteItems = []) => {
  const normalizedRemote = remoteItems.map((item, index) => normalizeArticle(item, index))
  const localArticles = buildLocalArticles()
  const seen = new Set()

  return sortByDateDesc([...normalizedRemote, ...localArticles].filter((item) => {
    const key = item.link || item.title
    if (seen.has(key)) {
      return false
    }
    seen.add(key)
    return true
  }))
}

const filteredArticles = computed(() => {
  if (activeCategory.value === 'all') {
    return articles.value
  }
  return articles.value.filter((article) => article.category === activeCategory.value)
})

const allTotalPages = computed(() => {
  const total = Math.ceil(filteredArticles.value.length / ALL_PAGE_SIZE)
  return total > 0 ? total : 1
})

const displayedArticles = computed(() => {
  if (activeCategory.value === 'all') {
    const currentPage = Math.min(allCurrentPage.value, allTotalPages.value)
    const startIndex = (currentPage - 1) * ALL_PAGE_SIZE
    return filteredArticles.value.slice(startIndex, startIndex + ALL_PAGE_SIZE)
  }
  return filteredArticles.value.slice(0, FIXED_NEWS_COUNT)
})

const showAllPagination = computed(() => (
    !loading.value && activeCategory.value === 'all' && filteredArticles.value.length > ALL_PAGE_SIZE
))

const allPaginationItems = computed(() => {
  const total = allTotalPages.value
  const current = allCurrentPage.value

  if (total <= 7) {
    return Array.from({ length: total }, (_, index) => ({
      type: 'page',
      value: index + 1,
      key: `page-${index + 1}`
    }))
  }

  const items = [{ type: 'page', value: 1, key: 'page-1' }]
  let start = Math.max(2, current - 1)
  let end = Math.min(total - 1, current + 1)

  if (current <= 3) {
    end = 4
  }
  if (current >= total - 2) {
    start = total - 3
  }

  if (start > 2) {
    items.push({ type: 'ellipsis', key: 'ellipsis-left' })
  }

  for (let page = start; page <= end; page += 1) {
    items.push({
      type: 'page',
      value: page,
      key: `page-${page}`
    })
  }

  if (end < total - 1) {
    items.push({ type: 'ellipsis', key: 'ellipsis-right' })
  }

  items.push({
    type: 'page',
    value: total,
    key: `page-${total}`
  })

  return items
})

const getCategoryName = (categoryId) => {
  const category = categories.find((item) => item.id === categoryId)
  return category ? category.name : '校园动态'
}

const changeAllPage = (targetPage) => {
  const nextPage = Math.min(Math.max(1, targetPage), allTotalPages.value)
  allCurrentPage.value = nextPage
}

const changeCategory = (categoryId) => {
  activeCategory.value = categoryId
  if (categoryId === 'all') {
    allCurrentPage.value = 1
  }
}

const loadDefaultData = () => {
  articles.value = sortByDateDesc(buildLocalArticles())
  allCurrentPage.value = 1
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
    allCurrentPage.value = 1
  } catch (err) {
    console.error('获取新闻失败:', err)
    loadDefaultData()
  } finally {
    loading.value = false
  }
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

  if (minutes <= 0) {
    return '刚刚'
  }
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
  --page-bg: #f3f5f7;
  --surface: #ffffff;
  --line: #d7dce3;
  --line-strong: #c5ccd6;
  --text: #1e2329;
  --accent: #0f4c97;
  --accent-dark: #0a3e7b;
  min-height: 100vh;
  padding: 24px 0 40px;
  background: var(--page-bg);
  color: var(--text);
  font-family: 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', sans-serif;
}

.hero-section,
.headline-strip,
.content-wrapper {
  width: min(1240px, calc(100% - 40px));
  margin: 0 auto;
}

.hero-section {
  display: grid;
  grid-template-columns: minmax(320px, 380px) minmax(0, 1fr);
  gap: 16px;
  align-items: stretch;
  margin-bottom: 18px;
}

.hero-copy,
.hero-carousel,
.headline-card,
.news-column,
.sidebar-widget {
  background: var(--surface);
  border: 1px solid var(--line);
  border-radius: 2px;
}

.hero-copy {
  padding: 24px;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  gap: 14px;
}

.hero-copy-main {
  display: flex;
  flex-direction: column;
  gap: 6px;
  padding-bottom: 10px;
  border-bottom: 1px solid var(--line);
}

.hero-title,
.section-title,
.widget-title,
.headline-title,
.card-title {
  font-family: 'Noto Serif SC', 'Source Han Serif SC', 'Songti SC', 'STSong', serif;
}

.hero-title {
  margin: 0;
  font-size: 44px;
  line-height: 1.1;
  font-weight: 700;
  letter-spacing: 0.01em;
  color: #14181e;
}

.hero-subtitle {
  margin: 0;
  font-size: 12px;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: #697586;
  font-weight: 600;
}

.hero-source-link {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 14px;
  width: 100%;
  border: 1px solid var(--line-strong);
  border-radius: 2px;
  color: #1f2f44;
  background: #fff;
  padding: 18px 18px;
  min-height: 96px;
  text-decoration: none;
  transition: background-color 0.2s ease, border-color 0.2s ease, color 0.2s ease;
}

.hero-source-link-main {
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.hero-source-link-title {
  font-size: 21px;
  line-height: 1.35;
  font-weight: 600;
  font-family: 'Noto Serif SC', 'Source Han Serif SC', 'Songti SC', 'STSong', serif;
}

.hero-source-link-desc {
  font-size: 13px;
  line-height: 1.6;
  color: #5c6c80;
}

.hero-source-link-action {
  font-size: 13px;
  letter-spacing: 0.04em;
  color: #5f6f82;
  font-weight: 600;
  white-space: nowrap;
}

.hero-source-link:hover {
  border-color: #aab4c2;
  color: #122236;
  background: #f7f9fc;
}

.hero-learning-widget {
  margin-top: auto;
  border: 1px solid var(--line);
  border-left: 3px solid #c0cee0;
  border-radius: 2px;
  background: #f8fafd;
  padding: 12px 12px 10px;
}

.hero-learning-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  margin-bottom: 10px;
  padding-bottom: 8px;
  border-bottom: 1px solid var(--line);
}

.hero-learning-title {
  margin: 0;
  font-size: 16px;
  font-weight: 700;
  color: #1f2d40;
  font-family: 'Noto Serif SC', 'Source Han Serif SC', 'Songti SC', 'STSong', serif;
}

.hero-learning-refresh {
  border: none;
  background: transparent;
  padding: 0;
  color: #365a86;
  font-size: 12px;
  font-weight: 600;
  font-family: inherit;
  cursor: pointer;
}

.hero-learning-content {
  padding: 2px 0 0;
}

.hero-learning-text {
  margin: 0;
  font-size: 13px;
  line-height: 1.75;
  color: #33475e;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 3;
  overflow: hidden;
}

.hero-learning-source-box {
  margin-top: 8px;
  display: flex;
  justify-content: flex-end;
  gap: 6px;
  color: #5f6f82;
  font-size: 12px;
  font-weight: 600;
}

.hero-learning-dash {
  color: #a0aebc;
}

.retry-btn {
  border-radius: 2px;
  padding: 10px 16px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  text-decoration: none;
  transition: background-color 0.2s ease, border-color 0.2s ease, color 0.2s ease;
}

.hero-carousel {
  padding: 0;
  overflow: hidden;
}

.hero-slide {
  position: relative;
  height: 100%;
  overflow: hidden;
  border-radius: 0;
  padding: 34px 36px 28px;
  color: #fff;
  isolation: isolate;
}

.hero-slide::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(6, 13, 25, 0.08) 0%, rgba(6, 13, 25, 0.18) 48%, rgba(6, 13, 25, 0.74) 100%);
  z-index: 0;
}

.hero-slide-content {
  position: relative;
  z-index: 1;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  max-width: min(560px, 72%);
}

.headline-tag,
.article-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.03em;
}

.hero-slide h2 {
  margin: 0 0 12px;
  font-size: 28px;
  line-height: 1.42;
  font-weight: 700;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.28);
}

.hero-slide p {
  margin: 0;
  font-size: 14px;
  line-height: 1.75;
  color: rgba(255, 255, 255, 0.92);
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.hero-slide-footer {
  margin-top: 18px;
  padding-top: 14px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 14px;
  font-size: 13px;
  border-top: 1px solid rgba(255, 255, 255, 0.22);
  color: rgba(255, 255, 255, 0.88);
}

.hero-slide-footer a {
  color: #fff;
  font-weight: 600;
  text-decoration: none;
  border-bottom: 1px solid transparent;
}

.hero-slide-footer a:hover {
  border-bottom-color: #fff;
}

.hero-carousel :deep(.el-carousel__container) {
  border-radius: 0;
}

.hero-carousel :deep(.el-carousel__arrow) {
  width: 34px;
  height: 34px;
  background-color: rgba(10, 20, 36, 0.48);
}

.hero-carousel :deep(.el-carousel__indicator button) {
  width: 22px;
  height: 3px;
  border-radius: 999px;
  background-color: rgba(255, 255, 255, 0.44);
}

.hero-carousel :deep(.el-carousel__indicator.is-active button) {
  background-color: #ffffff;
}

.hero-carousel :deep(.el-carousel__indicators) {
  bottom: 12px;
}

.headline-strip {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 14px;
  margin-bottom: 18px;
}

.headline-card {
  display: flex;
  flex-direction: column;
  min-height: 192px;
  padding: 18px 18px 16px;
  transition: border-color 0.2s ease, background-color 0.2s ease;
}

.headline-card:hover {
  border-color: #bfc8d4;
  background: #fafbfc;
}

.headline-tag {
  width: fit-content;
  padding: 3px 8px;
  color: #0f4c97;
  background: #eef3fa;
}

.headline-title {
  margin: 12px 0 8px;
  font-size: 22px;
  line-height: 1.45;
  color: #1a2431;
}

.headline-description {
  margin: 0;
  font-size: 14px;
  line-height: 1.75;
  color: #596575;
}

.headline-footer {
  margin-top: auto;
  padding-top: 14px;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  border-top: 1px solid var(--line);
}

.headline-card a {
  color: var(--accent);
  font-size: 13px;
  font-weight: 600;
  text-decoration: none;
  border-bottom: 1px solid transparent;
}

.headline-card a:hover {
  border-bottom-color: var(--accent);
}

.content-wrapper {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 348px;
  gap: 16px;
  align-items: start;
}

.news-column {
  padding: 18px 20px 20px;
  border-top: 2px solid #d5dfec;
}

.section-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 18px;
  padding-bottom: 14px;
  border-bottom: 1px solid var(--line);
}

.section-title {
  margin: 0;
  font-size: 30px;
  font-weight: 700;
  line-height: 1.2;
  color: #16202d;
}

.section-link,
.widget-link {
  display: inline-flex;
  align-items: center;
  white-space: nowrap;
  color: var(--accent);
  font-size: 13px;
  font-weight: 600;
  text-decoration: none;
  border-bottom: 1px solid transparent;
  transition: color 0.2s ease, border-color 0.2s ease;
}

.section-link:hover,
.widget-link:hover {
  color: var(--accent-dark);
  border-bottom-color: var(--accent-dark);
}

.category-tabs {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 16px;
}

.category-tab {
  border: 1px solid var(--line-strong);
  background: #fff;
  border-radius: 2px;
  padding: 8px 14px;
  font-size: 13px;
  font-weight: 600;
  color: #4e5d70;
  cursor: pointer;
  transition: color 0.2s ease, border-color 0.2s ease, background-color 0.2s ease;
}

.category-tab:hover,
.category-tab.active {
  color: var(--accent);
  border-color: #9fb1c7;
  background: #f8fafd;
}

.status-banner,
.loading-container,
.error-container,
.empty-container {
  border-radius: 2px;
  background: #fcfcfd;
  border: 1px solid var(--line);
}

.status-banner {
  margin-bottom: 16px;
  padding: 12px 14px;
  color: #5f6d80;
}

.loading-container,
.error-container,
.empty-container {
  padding: 48px 16px;
  text-align: center;
}

.loading-spinner {
  width: 38px;
  height: 38px;
  margin: 0 auto 14px;
  border: 3px solid rgba(15, 76, 151, 0.2);
  border-top-color: var(--accent);
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.error-message {
  margin: 0 0 14px;
  color: #bf3e3e;
}

.retry-btn {
  border: 1px solid var(--accent);
  color: #fff;
  background: var(--accent);
}

.retry-btn:hover {
  border-color: var(--accent-dark);
  background: var(--accent-dark);
}

.news-feed {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.news-card {
  position: relative;
  display: grid;
  grid-template-columns: 252px minmax(0, 1fr);
  gap: 16px;
  padding: 14px;
  border-radius: 2px;
  background: #fff;
  border: 1px solid var(--line);
  transition: border-color 0.2s ease, background-color 0.2s ease;
}

.news-card::before {
  content: '';
  position: absolute;
  left: -1px;
  top: -1px;
  bottom: -1px;
  width: 3px;
  background: transparent;
  transition: background-color 0.2s ease;
}

.news-card:hover {
  border-color: #bdc8d6;
  background: #fbfcfd;
}

.news-card:hover::before {
  background: var(--accent);
}

.card-image-link {
  display: block;
  text-decoration: none;
}

.card-image-wrapper {
  position: relative;
  overflow: hidden;
  border-radius: 0;
  aspect-ratio: 16 / 10;
  min-height: 160px;
  background: #ecf0f4;
  border: 1px solid #d9dfe7;
  transition: border-color 0.2s ease;
}

.card-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.35s ease;
}

.news-card:hover .card-image {
  transform: scale(1.03);
}

.card-image-link:hover .card-image-wrapper {
  border-color: #b4c0d0;
}

.article-badge {
  position: absolute;
  left: 10px;
  bottom: 10px;
  padding: 4px 8px;
  color: #fff;
  background: rgba(15, 24, 36, 0.78);
}

.card-text {
  display: flex;
  flex-direction: column;
  min-width: 0;
}

.card-top,
.card-actions {
  display: flex;
  align-items: center;
}

.card-top {
  margin-bottom: 8px;
}

.card-source-group,
.card-meta,
.card-footer {
  display: flex;
  align-items: center;
  gap: 12px;
}

.card-source-group {
  flex-wrap: wrap;
  color: #6b788a;
  font-size: 12px;
}

.card-source {
  font-weight: 600;
  color: #334255;
}

.card-dot {
  width: 3px;
  height: 3px;
  border-radius: 50%;
  background: #9aa7b7;
}

.card-time {
  color: #6f7d90;
}

.card-title {
  margin: 0 0 8px;
  font-size: 22px;
  line-height: 1.4;
  color: #1b2634;
}

.card-title-link {
  color: inherit;
  text-decoration: none;
  border-bottom: 1px solid transparent;
  transition: color 0.2s ease, border-color 0.2s ease;
}

.card-title-link:hover {
  color: var(--accent-dark);
  border-bottom-color: var(--accent-dark);
}

.card-description {
  margin: 0;
  font-size: 13px;
  line-height: 1.72;
  color: #566376;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.card-footer {
  margin-top: auto;
  justify-content: space-between;
  gap: 14px;
  padding-top: 14px;
  border-top: 1px solid var(--line);
}

.card-meta {
  flex-wrap: wrap;
  font-size: 12px;
  color: #6e7d90;
}

.card-actions {
  margin-left: auto;
}

.card-link {
  display: inline-flex;
  align-items: center;
  color: var(--accent);
  font-size: 13px;
  font-weight: 600;
  text-decoration: none;
  border-bottom: 1px solid transparent;
  transition: color 0.2s ease, border-color 0.2s ease;
}

.card-link:hover {
  color: var(--accent-dark);
  border-bottom-color: var(--accent-dark);
}

.news-pagination {
  margin-top: 18px;
  padding-top: 14px;
  border-top: 1px solid var(--line);
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
}

.pagination-btn {
  min-width: 34px;
  height: 34px;
  padding: 0 10px;
  border: 1px solid var(--line-strong);
  background: #fff;
  color: #334255;
  font-size: 13px;
  line-height: 32px;
  text-align: center;
  cursor: pointer;
  transition: border-color 0.2s ease, color 0.2s ease, background-color 0.2s ease;
}

.pagination-btn:hover:not(:disabled) {
  border-color: #9eb1c8;
  color: var(--accent-dark);
}

.pagination-btn:disabled {
  color: #9aa8b8;
  border-color: #d3d9e1;
  cursor: not-allowed;
}

.pagination-btn.page-btn {
  padding: 0;
}

.pagination-btn.page-btn.active {
  border-color: var(--accent);
  color: #fff;
  background: var(--accent);
}

.pagination-ellipsis {
  padding: 0 2px;
  color: #8b98a8;
  font-size: 16px;
  line-height: 1;
}

.sidebar {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.sidebar-widget {
  padding: 14px 16px;
  border-top: 2px solid #dbe4ef;
}

.widget-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
  padding-bottom: 10px;
  border-bottom: 1px solid var(--line);
}

.widget-title {
  margin: 0;
  font-size: 20px;
  line-height: 1.25;
  color: #16212f;
}

.sidebar-news-list,
.faq-list {
  display: flex;
  flex-direction: column;
}

.sidebar-news-item {
  display: flex;
  gap: 12px;
  padding: 9px 0;
  border-top: 1px solid var(--line);
  text-decoration: none;
  transition: color 0.2s ease;
}

.sidebar-news-item:first-child {
  border-top: none;
  padding-top: 0;
}

.sidebar-news-item:hover .sidebar-news-title {
  color: var(--accent-dark);
}

.sidebar-news-number {
  flex-shrink: 0;
  width: 26px;
  height: 26px;
  border: 1px solid var(--line-strong);
  color: #1a2a3f;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 12px;
}

.sidebar-news-item:nth-child(-n + 3) .sidebar-news-number {
  border-color: #97aaca;
  color: #0f4c97;
  background: #f4f7fb;
}

.sidebar-news-text {
  min-width: 0;
}

.sidebar-news-title {
  margin: 0 0 4px;
  font-size: 13px;
  line-height: 1.52;
  color: #253346;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
  transition: color 0.2s ease;
}

.sidebar-news-meta {
  margin: 0;
  font-size: 12px;
  color: #7c8899;
}

.campus-links {
  list-style: none;
  margin: 0;
  padding: 0;
}

.campus-links li {
  border-top: 1px solid var(--line);
}

.campus-links li:first-child {
  border-top: none;
}

.campus-link {
  display: block;
  padding: 12px 0;
  color: #1f2f44;
  font-size: 15px;
  font-weight: 600;
  text-decoration: none;
  transition: color 0.2s ease, text-decoration-color 0.2s ease;
}

.campus-link:hover {
  color: var(--accent-dark);
  text-decoration: underline;
  text-decoration-thickness: 1px;
  text-underline-offset: 3px;
}

.faq-item {
  width: 100%;
  border: none;
  border-top: 1px solid var(--line);
  background: transparent;
  padding: 10px 0;
  cursor: pointer;
  text-align: left;
}

.faq-item:first-child {
  border-top: none;
  padding-top: 0;
}

.faq-question-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.faq-question {
  font-size: 13px;
  font-weight: 600;
  color: #253346;
}

.faq-toggle {
  font-size: 16px;
  color: #365a86;
}

.faq-answer {
  display: block;
  margin-top: 10px;
  font-size: 13px;
  line-height: 1.75;
  color: #5c697b;
}

.section-link:focus-visible,
.widget-link:focus-visible,
.hero-source-link:focus-visible,
.hero-learning-refresh:focus-visible,
.pagination-btn:focus-visible,
.card-image-link:focus-visible,
.card-title-link:focus-visible,
.card-link:focus-visible,
.sidebar-news-item:focus-visible,
.campus-link:focus-visible {
  outline: 2px solid #6f8fb7;
  outline-offset: 2px;
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
    gap: 12px;
  }
}

@media (max-width: 900px) {
  .news-card {
    grid-template-columns: 1fr;
  }

  .card-image-wrapper {
    min-height: 220px;
  }

  .hero-slide p {
    font-size: 13px;
  }
}

@media (max-width: 768px) {
  .news-container {
    padding: 16px 0 30px;
  }

  .hero-section,
  .headline-strip,
  .content-wrapper {
    width: min(1240px, calc(100% - 24px));
  }

  .headline-strip,
  .sidebar {
    grid-template-columns: 1fr;
  }

  .hero-title {
    font-size: 34px;
  }

  .hero-source-link {
    gap: 10px;
    padding: 14px 14px;
    min-height: 82px;
  }

  .hero-source-link-title {
    font-size: 17px;
  }

  .hero-source-link-desc {
    font-size: 12px;
    line-height: 1.5;
  }

  .hero-source-link-action {
    font-size: 11px;
  }

  .hero-learning-widget {
    padding: 10px 11px 9px;
  }

  .hero-learning-title {
    font-size: 15px;
  }

  .hero-learning-text {
    font-size: 12px;
  }

  .hero-learning-source-box {
    font-size: 11px;
  }

  .hero-slide {
    padding: 24px 22px 22px;
  }

  .hero-slide h2 {
    font-size: 23px;
  }

  .hero-slide-content {
    max-width: 100%;
  }

  .hero-slide-footer {
    margin-top: 14px;
    padding-top: 12px;
  }

  .section-title {
    font-size: 28px;
  }

  .section-header {
    flex-direction: column;
    align-items: flex-start;
  }

  .card-title {
    font-size: 21px;
  }

  .card-footer {
    flex-direction: column;
    align-items: flex-start;
  }

  .card-actions {
    margin-left: 0;
  }

}
</style>
