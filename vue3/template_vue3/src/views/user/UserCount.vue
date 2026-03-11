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
  ChatDotRound
} from '@element-plus/icons-vue'

const router = useRouter()

const carouselItems = ref([
  { id: 1, image: image1 },
  { id: 2, image: image2 },
  { id: 3, image: image3 },
  { id: 4, image: image4 }
])
const centerCards = ref([
  {
    id: 1,
    icon: 'User',
    title: '学生成长助手',
    subtitle: '学习建议·生活指导',
    color: '#667eea'
  },
  {
    id: 2,
    icon: 'DataAnalysis',
    title: '教师助教助手',
    subtitle: '教学辅助·课堂分析',
    color: '#764ba2'
  },
  {
    id: 3,
    icon: 'Edit',
    title: '辅导员思政助手',
    subtitle: '思想引导·学生管理',
    color: '#f093fb'
  },
  {
    id: 4,
    icon: 'Warning',
    title: '学情预警助手',
    subtitle: '风险识别·预警分析',
    color: '#ff6b6b'
  },
  {
    id: 5,
    icon: 'DocumentCopy',
    title: '学情报告助手',
    subtitle: '数据统计·报告生成',
    color: '#4ecdc4'
  },
  {
    id: 6,
    icon: 'ChatDotRound',
    title: '思政知识问答',
    subtitle: '政策解读·知识问答',
    color: '#ffa502'
  }
])
const aiRecommendations = ref([
  {
    id: 1,
    title: 'AI推荐咨询',
    icon: '✓'
  },
  {
    id: 2,
    title: 'AI推荐咨询',
    icon: '◉'
  },
  {
    id: 3,
    title: 'AI推荐咨询',
    icon: '💬'
  },
  {
    id: 4,
    title: 'AI推荐咨询',
    icon: '👁'
  }
])
const recentUsage = ref([
  {
    id: 1,
    name: '最近使用智能体'
  },
  {
    id: 2,
    name: '最近使用智能体'
  },
  {
    id: 3,
    name: '最近使用智能体'
  }
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
}
</script>

<template>
  <div class="home-page">
    <header class="title-bar">
      <h1 class="title-text">AI智能助手</h1>
    </header>
    <div class="carousel-section">
      <el-carousel
          indicator-position="outside"
          height="600px"
          :autoplay="true"
          :interval="5000"
      >
        <el-carousel-item v-for="item in carouselItems" :key="item.id">
          <div class="carousel-content" :style="{ backgroundImage: `url(${item.image})`, backgroundSize: 'cover', backgroundPosition: 'center' }">
          </div>
        </el-carousel-item>
      </el-carousel>
    </div>
    <main class="main-content">
      <section class="section-title">
        <h2>智能体中心</h2>
        <div class="title-line"></div>
      </section>
      <div class="cards-grid">
        <div
            v-for="card in centerCards"
            :key="card.id"
            class="card-item"
            @click="navigateToCard(card.id)"
        >
          <div class="card-icon-wrapper" :style="{ color: card.color }">
            <component :is="getIconComponent(card.icon)" class="card-icon"></component>
          </div>
          <div class="card-title">{{ card.title }}</div>
          <div class="card-subtitle">{{ card.subtitle }}</div>
        </div>
      </div>
      <div class="recommendations-section">
        <div class="section-header">
          <h3>AI 推荐</h3>
          <div class="recommendations-list">
            <div v-for="rec in aiRecommendations" :key="rec.id" class="rec-item">
              <span class="rec-icon">{{ rec.icon }}</span>
              <span class="rec-text">{{ rec.title }}</span>
            </div>
          </div>
        </div>
        <div class="section-header">
          <h3>最近使用</h3>
          <div class="recent-list">
            <div v-for="item in recentUsage" :key="item.id" class="recent-item">
              <span class="recent-text">{{ item.name }}</span>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>
<style scoped lang="scss">
.home-page {
  background: linear-gradient(135deg, #f8f9ff 0%, #f0f2ff 50%, #e8ebff 100%);
  min-height: 100vh;
  position: relative;
  padding: 0;
  margin: 0;
}
.home-page::before {
  content: '';
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background:
      radial-gradient(circle at 20% 50%, rgba(102, 126, 234, 0.08) 0%, transparent 50%),
      radial-gradient(circle at 80% 80%, rgba(118, 75, 162, 0.08) 0%, transparent 50%),
      radial-gradient(circle at 40% 20%, rgba(240, 147, 251, 0.05) 0%, transparent 50%);
  pointer-events: none;
  z-index: -1;
}
.title-bar {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 16px 0;
  text-align: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  position: relative;
  z-index: 100;
}
.title-text {
  font-size: 24px;
  font-weight: 600;
  color: white;
  margin: 0;
  letter-spacing: 0.5px;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}
.carousel-section {
  padding: 0;
  background: transparent;
  margin: 0;
  width: 100%;
  max-width: 100%;

  :deep(.el-carousel) {
    border-radius: 0;
    overflow: hidden;
    box-shadow: none;
  }

  :deep(.el-carousel__item) {
    border-radius: 0;
  }

  :deep(.el-carousel__indicators) {
    background: rgba(0, 0, 0, 0.2);
    padding: 10px;
    border-radius: 8px;
  }

  :deep(.el-carousel__indicator.is-active button) {
    background-color: #667eea;
  }

  :deep(.el-carousel__indicator button) {
    background-color: rgba(255, 255, 255, 0.5);
    width: 12px;
    height: 12px;
    border-radius: 50%;
    transition: all 0.3s ease;

    &:hover {
      background-color: rgba(255, 255, 255, 0.8);
    }
  }
}

.carousel-content {
  width: 100%;
  height: 100%;
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
}

.main-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 30px 40px;
  position: relative;
  z-index: 1;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-bottom: 30px;
  padding: 30px 0;
  background: linear-gradient(90deg, rgba(255, 255, 255, 0.5) 0%, rgba(255, 255, 255, 0) 100%);
  border-radius: 8px;

  h2 {
    font-size: 24px;
    color: #333;
    margin: 0;
    font-weight: 600;
  }

  .title-line {
    flex: 1;
    height: 2px;
    background: linear-gradient(to right, #667eea 0%, transparent 100%);
  }
}

.cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 24px;
  margin-bottom: 50px;

  .card-item {
    background: linear-gradient(135deg, rgba(245, 247, 250, 0.8) 0%, rgba(195, 207, 226, 0.6) 100%);
    padding: 35px 20px;
    border-radius: 12px;
    text-align: center;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    position: relative;
    overflow: hidden;
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.5);

    &::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      opacity: 0;
      transition: opacity 0.3s ease;
    }

    &:hover {
      transform: translateY(-8px);
      box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);

      &::before {
        opacity: 1;
      }

      .card-title,
      .card-subtitle {
        color: white;
        position: relative;
        z-index: 2;
      }

      .card-icon-wrapper {
        color: white;
        transform: scale(1.1);
      }
    }

    .card-icon-wrapper {
      display: flex;
      justify-content: center;
      align-items: center;
      width: 60px;
      height: 60px;
      margin: 0 auto 20px;
      background: rgba(255, 255, 255, 0.5);
      border-radius: 8px;
      transition: all 0.3s ease;
    }

    .card-icon {
      font-size: 32px;
      width: 32px;
      height: 32px;
    }

    .card-title {
      font-size: 18px;
      font-weight: 600;
      color: #333;
      margin-bottom: 10px;
      transition: color 0.3s ease;
      position: relative;
      z-index: 2;
    }

    .card-subtitle {
      font-size: 14px;
      color: #666;
      transition: color 0.3s ease;
      position: relative;
      z-index: 2;
    }
  }
}
.recommendations-section {
  display: flex;
  gap: 60px;
  margin-bottom: 50px;
  padding: 30px;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.7) 0%, rgba(255, 255, 255, 0.5) 100%);
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.5);

  .section-header {
    flex: 1;

    h3 {
      font-size: 18px;
      color: #333;
      margin: 0 0 20px 0;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 15px;

      &::after {
        content: '';
        flex: 1;
        height: 1px;
        background: linear-gradient(to right, #667eea, transparent);
      }
    }

    .recommendations-list,
    .recent-list {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    .rec-item,
    .recent-item {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 12px 16px;
      background: rgba(255, 255, 255, 0.8);
      border-radius: 6px;
      transition: all 0.3s ease;
      box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08);
      border: 1px solid rgba(255, 255, 255, 0.3);

      &:hover {
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
        transform: translateX(4px);
        background: rgba(255, 255, 255, 1);
      }

      .rec-icon {
        font-size: 18px;
        min-width: 24px;
      }

      .rec-text,
      .recent-text {
        color: #333;
        font-size: 14px;
        flex: 1;
      }
    }
  }
}
@media (max-width: 1024px) {
  .recommendations-section {
    flex-direction: column;
    gap: 30px;
  }

  .cards-grid {
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 20px;
  }
}

@media (max-width: 768px) {
  .title-bar {
    padding: 12px 0;
  }

  .title-text {
    font-size: 20px;
  }

  .carousel-section {
    width: 100vw;
    margin-left: calc(-50vw + 50%);

    :deep(.el-carousel) {
      height: 300px !important;
    }
  }

  .main-content {
    padding: 20px;
  }

  .cards-grid {
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 15px;

    .card-item {
      padding: 25px 15px;
    }
  }

  .section-title {
    margin-bottom: 20px;
    padding: 20px 0;

    h2 {
      font-size: 20px;
    }
  }

  .recommendations-section {
    padding: 20px;
    gap: 20px;
  }
}
</style>