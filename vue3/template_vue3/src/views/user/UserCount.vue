<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import image1 from '@/assets/lunbo-1.jpg'
import image2 from '@/assets/lunbo-2.jpg'
import image3 from '@/assets/lunbo-3.jpg'
import image4 from '@/assets/lunbo-4.jpg'
import {
  User,
  DataAnalysis,
  Edit,
  Warning,
  DocumentCopy,
  ChatDotRound,
  ArrowRight
} from '@element-plus/icons-vue'

const router = useRouter()

const carouselItems = ref([
  { id: 1, image: image1 },
  { id: 2, image: image2 },
  { id: 3, image: image3 },
  { id: 4, image: image4 }
])

const centerCards = ref([
  { id: 1, icon: 'User', title: '学生成长助手', subtitle: '学习建议 · 生活指导', color: '#667eea' },
  { id: 2, icon: 'DataAnalysis', title: '教师助教助手', subtitle: '教学辅助 · 课堂分析', color: '#764ba2' },
  { id: 3, icon: 'Edit', title: '辅导员思政助手', subtitle: '思想引导 · 学生管理', color: '#f093fb' },
  { id: 4, icon: 'Warning', title: '学情预警助手', subtitle: '风险识别 · 预警分析', color: '#ff6b6b' },
  { id: 5, icon: 'DocumentCopy', title: '学情报告助手', subtitle: '数据统计 · 报告生成', color: '#4ecdc4' },
  { id: 6, icon: 'ChatDotRound', title: '思政知识问答', subtitle: '政策解读 · 知识问答', color: '#ffa502' }
])

const aiRecommendations = ref([
  { id: 1, title: '2024年奖学金评定政策解读', icon: '✨' },
  { id: 2, title: '如何进行期末复习规划？', icon: '💡' },
  { id: 3, title: '近期校园心理健康讲座预约', icon: '💬' },
  { id: 4, title: '大学生职业生涯规划指南', icon: '🎯' }
])

const recentUsage = ref([
  { id: 1, title: '学生成长助手 - 成绩分析' },
  { id: 2, title: '思政知识问答 - 理论学习' },
  { id: 3, title: '学情报告助手 - 月度总结' }
])

const iconComponentMap = {
  'User': User,
  'DataAnalysis': DataAnalysis,
  'Edit': Edit,
  'Warning': Warning,
  'DocumentCopy': DocumentCopy,
  'ChatDotRound': ChatDotRound
} as const

const getIconComponent = (iconName: string) => {
  return iconComponentMap[iconName as keyof typeof iconComponentMap] || User
}

const navigateToCard = (cardId: number) => {
  console.log('导航到卡片:', cardId)
  // router.push(`/agent/${cardId}`)
}

const navigateToDetail = (item: any) => {
  console.log('查看详情:', item)
}
</script>

<template>
  <div class="home-page">
    <div class="carousel-section">
      <el-carousel
        indicator-position="outside"
        height="400px"
        :autoplay="true"
        :interval="5000"
        arrow="hover"
      >
        <el-carousel-item v-for="item in carouselItems" :key="item.id">
          <div class="carousel-content" :style="{ backgroundImage: `url(${item.image})` }">
            <div class="carousel-overlay"></div>
          </div>
        </el-carousel-item>
      </el-carousel>
    </div>

    <main class="main-content">
      <section class="module-section">
        <div class="section-title">
          <h2>智能体中心</h2>
          <span class="subtitle">AI-Powered Agents</span>
        </div>

        <div class="cards-grid">
          <div
            v-for="card in centerCards"
            :key="card.id"
            class="card-item"
            @click="navigateToCard(card.id)"
          >
            <div class="card-icon-wrapper" :style="{ '--theme-color': card.color }">
              <component :is="getIconComponent(card.icon)" class="card-icon"></component>
            </div>
            <div class="card-info">
              <div class="card-title">{{ card.title }}</div>
              <div class="card-subtitle">{{ card.subtitle }}</div>
            </div>
          </div>
        </div>
      </section>

      <section class="bottom-sections">
        <div class="info-panel">
          <div class="panel-header">
            <h3>AI 智能推荐</h3>
          </div>
          <div class="panel-list">
            <div
              v-for="rec in aiRecommendations"
              :key="rec.id"
              class="list-item"
              @click="navigateToDetail(rec)"
            >
              <div class="item-icon">{{ rec.icon }}</div>
              <div class="item-content">{{ rec.title }}</div>
              <el-icon class="item-arrow"><ArrowRight /></el-icon>
            </div>
          </div>
        </div>

        <div class="info-panel">
          <div class="panel-header">
            <h3>最近使用</h3>
          </div>
          <div class="panel-list">
            <div
              v-for="item in recentUsage"
              :key="item.id"
              class="list-item"
              @click="navigateToDetail(item)"
            >
              <div class="item-icon">🕒</div>
              <div class="item-content">{{ item.name || item.title }}</div>
              <el-icon class="item-arrow"><ArrowRight /></el-icon>
            </div>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>

<style scoped lang="scss">
/* --- 基础与背景 --- */
.home-page {
  background-color: #f5f7fa;
  min-height: 100vh;
  position: relative;
  overflow-x: hidden;

  &::before {
    content: '';
    position: fixed;
    top: 0; left: 0; right: 0; bottom: 0;
    background:
      radial-gradient(circle at 15% 50%, rgba(102, 126, 234, 0.05) 0%, transparent 50%),
      radial-gradient(circle at 85% 30%, rgba(118, 75, 162, 0.05) 0%, transparent 50%);
    pointer-events: none;
    z-index: 0;
  }
}

/* --- 轮播图 --- */
.carousel-section {
  width: 100%;
  margin-bottom: -40px; /* 让主体内容稍微往上浮动，与轮播图产生层次感 */
  z-index: 1;
  position: relative;

  .carousel-content {
    width: 100%;
    height: 100%;
    background-size: cover;
    background-position: center;
    position: relative;

    .carousel-overlay {
      position: absolute;
      inset: 0;
      background: linear-gradient(to bottom, rgba(0,0,0,0.1) 0%, rgba(0,0,0,0.4) 100%);
    }
  }

  :deep(.el-carousel__indicators--outside) {
    position: absolute;
    bottom: 50px;
    left: 50%;
    transform: translateX(-50%);
    background: transparent;
  }

  :deep(.el-carousel__indicator button) {
    background-color: rgba(255, 255, 255, 0.6);
    height: 4px;
    border-radius: 2px;
  }
  :deep(.el-carousel__indicator.is-active button) {
    background-color: #fff;
    width: 24px;
  }
}

/* --- 主体内容区 --- */
.main-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px 60px;
  position: relative;
  z-index: 2;
}

.module-section {
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.8);
  border-radius: 16px;
  padding: 32px;
  box-shadow: 0 8px 32px rgba(31, 38, 135, 0.05);
  margin-bottom: 32px;
}

/* --- 标题 --- */
.section-title {
  display: flex;
  align-items: baseline;
  gap: 12px;
  margin-bottom: 28px;

  h2 {
    font-size: 24px;
    color: #1a1a1a;
    margin: 0;
    font-weight: 600;
  }

  .subtitle {
    font-size: 14px;
    color: #8c939d;
    text-transform: uppercase;
    letter-spacing: 1px;
  }
}

/* --- 卡片网格 --- */
.cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 24px;

  .card-item {
    display: flex;
    align-items: center;
    padding: 24px;
    background: #ffffff;
    border-radius: 12px;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    border: 1px solid #ebeef5;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.02);

    &:hover {
      transform: translateY(-4px);
      box-shadow: 0 12px 24px rgba(0, 0, 0, 0.08);
      border-color: transparent;

      .card-icon-wrapper {
        background: var(--theme-color);
        color: #ffffff;
        transform: scale(1.05) rotate(-5deg);
      }

      .card-title {
        color: var(--theme-color);
      }
    }

    .card-icon-wrapper {
      flex-shrink: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      width: 56px;
      height: 56px;
      margin-right: 20px;
      background: rgba(240, 242, 245, 0.8);
      color: var(--theme-color);
      border-radius: 12px;
      transition: all 0.4s ease;

      .card-icon {
        font-size: 28px;
        width: 28px;
        height: 28px;
      }
    }

    .card-info {
      flex: 1;

      .card-title {
        font-size: 18px;
        font-weight: 600;
        color: #303133;
        margin-bottom: 6px;
        transition: color 0.3s ease;
      }

      .card-subtitle {
        font-size: 13px;
        color: #909399;
        line-height: 1.4;
      }
    }
  }
}

/* --- 底部面板区 (推荐 & 历史) --- */
.bottom-sections {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;

  .info-panel {
    background: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.8);
    border-radius: 16px;
    padding: 28px;
    box-shadow: 0 8px 32px rgba(31, 38, 135, 0.03);

    .panel-header h3 {
      font-size: 18px;
      color: #303133;
      margin: 0 0 20px 0;
      font-weight: 600;
      position: relative;
      padding-left: 12px;

      &::before {
        content: '';
        position: absolute;
        left: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 4px;
        height: 16px;
        background: #667eea;
        border-radius: 2px;
      }
    }

    .panel-list {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    .list-item {
      display: flex;
      align-items: center;
      padding: 14px 16px;
      background: #ffffff;
      border-radius: 8px;
      cursor: pointer;
      border: 1px solid #ebeef5;
      transition: all 0.2s ease;

      &:hover {
        border-color: #c6e2ff;
        background: #ecf5ff;
        transform: translateX(4px);

        .item-content {
          color: #409eff;
        }

        .item-arrow {
          opacity: 1;
          transform: translateX(0);
        }
      }

      .item-icon {
        font-size: 18px;
        margin-right: 12px;
      }

      .item-content {
        flex: 1;
        font-size: 14px;
        color: #606266;
        transition: color 0.2s ease;
      }

      .item-arrow {
        color: #409eff;
        opacity: 0;
        transform: translateX(-10px);
        transition: all 0.3s ease;
      }
    }
  }
}

/* --- 响应式适配 --- */
@media (max-width: 1024px) {
  .bottom-sections {
    grid-template-columns: 1fr;
  }

  .cards-grid {
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  }
}

@media (max-width: 768px) {
  .carousel-section {
    :deep(.el-carousel) {
      height: 240px !important;
    }
    margin-bottom: -20px;
  }

  .main-content {
    padding: 0 16px 40px;
  }

  .module-section {
    padding: 20px;
  }

  .cards-grid .card-item {
    padding: 16px;
  }

  .bottom-sections .info-panel {
    padding: 20px;
  }
}
</style>