<template>
  <div class="welcome-container">

    <div class="virtual-scroll-track" :style="{ height: '500vh' }"></div>

    <header class="global-header" :class="{ 'is-scrolled': smoothScrollY > 50 }">
      <h1 class="title">思政云平台</h1>
      <div class="butt">
        <button class="particle-btn" @click="goToLogin">
          <div class="btn-glow"></div>
          <div class="particles-container">
            <i v-for="n in 20" :key="n" class="particle" :style="getParticleStyle(n)"></i>
          </div>
          <span class="btn-text">立即登录</span>
          <span class="arrow-icon">→</span>
        </button>
      </div>
    </header>

    <div class="fixed-canvas">

      <section class="hero-section" :style="heroStyle">

        <div class="video-layer">
          <video ref="heroFwd" class="bg-video" :class="{'is-active': heroState==='fwd'}" autoplay muted playsinline>
            <source :src="heroFwdSrc" type="video/mp4" />
          </video>
          <video ref="heroRev" class="bg-video" :class="{'is-active': heroState==='rev'}" muted playsinline preload="auto">
            <source :src="heroRevSrc" type="video/mp4" />
          </video>
        </div>

        <div class="hero-overlay" :style="{ opacity: 0.3 + p1 * 0.5 }"></div>

        <div class="hero-content" :style="{ opacity: 1 - p1 * 2 }">
          <h2 class="hero-slogan">探索 · 学习 · 沉淀</h2>
          <p class="hero-sub">全新视界，向下滚动开启</p>
          <div class="scroll-indicator">↓</div>
        </div>

      </section>

      <section class="split-section" :style="splitStyle">

        <div class="left-fixed-area">
          <div class="video-card">
            <video ref="sideFwd" class="side-video" :class="{'is-active': sideState==='fwd'}" autoplay muted playsinline>
              <source :src="sideFwdSrc" type="video/mp4" />
            </video>
            <video ref="sideRev" class="side-video" :class="{'is-active': sideState==='rev'}" muted playsinline preload="auto">
              <source :src="sideRevSrc" type="video/mp4" />
            </video>
            <div class="video-glow"></div>
          </div>
        </div>

        <div class="right-content-area">

          <div class="section-title-wrapper">
            <h2 class="main-section-title">全景赋能方案</h2>
            <div class="title-divider"></div>
          </div>

          <div class="features-list-viewport">
            <div
              v-for="(item, index) in features"
              :key="index"
              class="feature-block"
              :class="{ 'is-active': activeIndex === index }"
              :style="getFeatureStyle(index)"
            >
              <div class="feature-num">0{{ index + 1 }}</div>
              <h3 class="feature-title">{{ item.title }}</h3>
              <p class="feature-desc">{{ item.desc }}</p>
            </div>
          </div>

        </div>
      </section>

    </div>

  </div>
</template>

<script>
// 【重要】请保持这四个视频路径正确
import heroFwdPath from '../assets/splash.mp4'
import heroRevPath from '../assets/re-splash.mp4'
import sideFwdPath from '../assets/splash.mp4'
import sideRevPath from '../assets/re-splash.mp4'

export default {
  name: 'WelcomePage',
  data() {
    return {
      heroFwdSrc: heroFwdPath,
      heroRevSrc: heroRevPath,
      sideFwdSrc: sideFwdPath,
      sideRevSrc: sideRevPath,

      heroState: 'fwd',
      sideState: 'fwd',

      // 数学动画核心
      targetScrollY: 0,
      smoothScrollY: 0,
      rafId: null,

      p1: 0, // 第一阶段进度：首屏退场，第二屏升起 (0~1)
      p2: 0, // 第二阶段进度：右侧文字滑动 (0~1)
      activeIndex: 0, // 当前高亮的文字索引

      features: [
        { title: "海量精选课程", desc: "打破时空限制，随时随地开启沉浸式学习体验。聚合全网优质思政资源，为您量身定制学习路径。" },
        { title: "全景学情分析", desc: "精准追踪学习轨迹，生成直观的可视化报表。每一次点击、每一次停留，都将转化为科学的数据参考。" },
        { title: "智能评估体系", desc: "多维度考核模型，提供客观、立体的教学反馈。自动批阅与人工复核相结合，确保成绩公平公正。" },
        { title: "教务数据驾驶舱", desc: "为管理者打造一站式数据中心，全局掌控平台动态。用数据驱动决策，赋能教育模式创新。" },
        { title: "开启全新篇章", desc: "立即登录思政云平台，与十万学子共同探索知识的边界。让教育回归本质，让科技赋能未来。" }
      ]
    }
  },
  computed: {
    // 🌟 首屏样式引擎
    heroStyle() {
      // 首屏往后退去产生视差，最大退后 30vh，缩小到 0.9
      const translateY = this.p1 * -30;
      const scale = 1 - (this.p1 * 0.1);
      return {
        transform: `translate3d(0, ${translateY}vh, 0) scale3d(${scale}, ${scale}, 1)`
      }
    },
    // 🌟 第二屏幕布样式引擎
    splitStyle() {
      // 从距屏幕底部 100vh 处开始，随着 p1 增加，向上滑升至 0vh (完全覆盖屏幕)
      const translateY = 100 - (this.p1 * 100);
      return {
        transform: `translate3d(0, ${translateY}vh, 0)`
      }
    }
  },
  mounted() {
    window.addEventListener('scroll', this.onScroll, { passive: true });
    this.renderLoop();

    // 初始化无缝双缓冲引擎
    this.$nextTick(() => {
      this.monitorVideoSwap('heroFwd', 'heroRev', 'heroState');
      this.monitorVideoSwap('sideFwd', 'sideRev', 'sideState');
    });
  },
  beforeDestroy() {
    window.removeEventListener('scroll', this.onScroll);
    if (this.rafId) cancelAnimationFrame(this.rafId);
  },
  methods: {
    goToLogin() {
      this.$router.push('/login');
    },

    // ==========================================
    // 🎬 无黑屏·双缓冲循环引擎
    // ==========================================
    monitorVideoSwap(refFwd, refRev, stateKey) {
      let isSwapping = false;
      const loop = () => {
        const fwd = this.$refs[refFwd];
        const rev = this.$refs[refRev];
        if (!fwd || !rev) return requestAnimationFrame(loop);

        const activeVid = this[stateKey] === 'fwd' ? fwd : rev;
        const nextVid = this[stateKey] === 'fwd' ? rev : fwd;
        const nextState = this[stateKey] === 'fwd' ? 'rev' : 'fwd';

        // 提前 0.15 秒触发层级交接
        if (!isSwapping && activeVid.duration && activeVid.currentTime >= activeVid.duration - 0.15) {
          isSwapping = true;
          nextVid.play().catch(()=>{});
          this[stateKey] = nextState;

          setTimeout(() => {
            activeVid.pause();
            activeVid.currentTime = 0;
            isSwapping = false;
          }, 150);
        }
        requestAnimationFrame(loop);
      };
      loop();
    },

    // ==========================================
    // ⚙️ 核心数学逻辑：纯享阻尼虚拟滚动
    // ==========================================
    onScroll() {
      this.targetScrollY = window.scrollY;
    },
    renderLoop() {
      // 0.08 的极致丝滑阻尼摩擦力
      this.smoothScrollY += (this.targetScrollY - this.smoothScrollY) * 0.08;
      this.calculateProgress();
      this.rafId = requestAnimationFrame(this.renderLoop);
    },
    calculateProgress() {
      const H = window.innerHeight;

      // 第一阶段 (p1): 滚动前 1 个屏幕高度 (0 ~ 100vh)
      // 负责让首屏变暗退后，同时把双栏幕布拉上来
      let rawP1 = this.smoothScrollY / H;
      this.p1 = Math.max(0, Math.min(1, rawP1));

      // 第二阶段 (p2): 滚动剩下的 4 个屏幕高度 (100vh ~ 500vh)
      // 负责在双栏区完全覆盖后，滑动右侧的文字列表
      let rawP2 = (this.smoothScrollY - H) / (3 * H);
      this.p2 = Math.max(0, Math.min(1, rawP2));

      // 实时计算当前高亮的索引
      const totalItems = this.features.length;
      let currentIndex = Math.floor(this.p2 * totalItems);
      if (currentIndex >= totalItems) currentIndex = totalItems - 1;
      this.activeIndex = currentIndex;
    },

    // 🌟 计算每一个文字块的三维坐标和透明度
    getFeatureStyle(index) {
      const N = this.features.length;
      // 每个标题的顶点进度 (例如 5 个标题，顶点分别是 0, 0.25, 0.5, 0.75, 1)
      const p_i = index / (N - 1);

      // 距离顶点的偏差
      const d = this.p2 - p_i;

      // 距离偏差放大 120 倍映射为 vh 单位。d=0 时正好在中间，d<0 在下方，d>0 在上方
      const translateY = d * -120;

      // 距离越远，透明度越低，并且进行轻微缩放
      const opacity = 1 - Math.abs(d) * 3;
      const scale = 1 - Math.abs(d) * 0.1;

      return {
        // 全面启用 translate3d 进行 GPU 硬件加速
        transform: `translate3d(0, ${translateY}vh, 0) scale3d(${scale}, ${scale}, 1)`,
        opacity: Math.max(0, opacity),
        pointerEvents: Math.abs(d) < 0.1 ? 'auto' : 'none'
      }
    },

    getParticleStyle(n) {
      const size = Math.random() * 3 + 2;
      const left = Math.random() * 100;
      const delay = Math.random() * 2;
      const duration = Math.random() * 1.5 + 1;
      return {
        width: `${size}px`, height: `${size}px`, left: `${left}%`,
        animationDelay: `${delay}s`, animationDuration: `${duration}s`
      }
    }
  }
}
</script>

<style scoped>
/* =========== 基础容器 =========== */
.welcome-container { width: 100%; background-color: #000; color: #fff; font-family: 'Helvetica Neue', Helvetica, 'PingFang SC', sans-serif; overflow: hidden; }

/* =========== 1. 全局导航 =========== */
.global-header { position: fixed; top: 0; left: 0; width: 100%; padding: 25px 50px; display: flex; justify-content: space-between; align-items: center; box-sizing: border-box; z-index: 9999; transition: all 0.5s cubic-bezier(0.16, 1, 0.3, 1); background: linear-gradient(to bottom, rgba(0,0,0,0.8), transparent); }
.global-header.is-scrolled { padding: 15px 50px; background: rgba(8, 12, 20, 0.85); backdrop-filter: blur(15px); box-shadow: 0 10px 30px rgba(0,0,0,0.6); }
.title { font-size: 24px; font-weight: 600; letter-spacing: 2px; margin: 0; }
.particle-btn { position: relative; display: flex; align-items: center; gap: 10px; background: rgba(0, 242, 254, 0.05); border: 1px solid rgba(0, 242, 254, 0.4); color: #00f2fe; border-radius: 30px; padding: 12px 30px; font-size: 16px; font-weight: bold; cursor: pointer; overflow: hidden; transition: all 0.4s; backdrop-filter: blur(5px); }
.particle-btn:hover { background: rgba(0, 242, 254, 0.2); border-color: #00f2fe; color: #fff; box-shadow: 0 0 20px rgba(0, 242, 254, 0.6), inset 0 0 15px rgba(0, 242, 254, 0.4); transform: translateY(-2px); }
.particle-btn:hover .arrow-icon { transform: translateX(6px); }
.arrow-icon { transition: transform 0.3s; }
.particles-container { position: absolute; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none; z-index: 0; }
.particle { position: absolute; bottom: -10px; background: #ffffff; border-radius: 50%; box-shadow: 0 0 8px #00f2fe, 0 0 15px #00f2fe; opacity: 0; animation: particleFloat infinite ease-in; }
@keyframes particleFloat { 0% { transform: translate3d(0, 0, 0) scale(0.5); opacity: 0; } 20% { opacity: 1; } 80% { opacity: 0.8; } 100% { transform: translate3d(0, -40px, 0) scale(1.2); opacity: 0; } }
.btn-text, .arrow-icon { position: relative; z-index: 2; letter-spacing: 2px; }

/* =========== ★ 2. 终极固定画布 ★ =========== */
.fixed-canvas {
  position: fixed;
  top: 0; left: 0;
  width: 100vw; height: 100vh;
  overflow: hidden;
  z-index: 10;
}

/* --- 首屏视差区 --- */
.hero-section {
  position: absolute; top: 0; left: 0; width: 100%; height: 100%;
  will-change: transform; transform-origin: center center;
}

/* 无黑屏双轨视频 */
.video-layer { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: #000; }
.bg-video { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; opacity: 1; z-index: 1; }
.bg-video.is-active { z-index: 2; }

.hero-overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: #000; z-index: 3; }
.hero-content { position: absolute; top: 50%; left: 50%; text-align: center; z-index: 4; transform: translate3d(-50%, -50%, 0); }
.hero-slogan { font-size: 64px; letter-spacing: 12px; margin: 0 0 20px 0; font-weight: bold; background: linear-gradient(180deg, #fff 0%, #aab2bd 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; text-shadow: 0 10px 30px rgba(0,0,0,0.8); }
.hero-sub { font-size: 20px; letter-spacing: 6px; color: #ddd; margin-bottom: 60px; }
.scroll-indicator { font-size: 24px; color: #fff; opacity: 0.6; animation: bounce 2s infinite; }
@keyframes bounce { 0%, 20%, 50%, 80%, 100% { transform: translate3d(0, 0, 0); } 40% { transform: translate3d(0, -15px, 0); } 60% { transform: translate3d(0, -7px, 0); } }

/* --- 幕布覆盖区 (第二屏) --- */
.split-section {
  position: absolute; top: 0; left: 0; width: 100%; height: 100%;
  background-color: #030408;
  display: flex;
  box-shadow: 0 -40px 100px rgba(0,0,0,1); /* 向上抬升时自带的深渊阴影 */
  will-change: transform;
  z-index: 10;
}

/* 左侧常驻视频 */
.left-fixed-area { width: 50%; height: 100%; display: flex; align-items: center; padding: 0 50px; box-sizing: border-box; }
.video-card { position: relative; width: 100%; aspect-ratio: 16 / 9; border-radius: 16px; overflow: hidden; box-shadow: 0 30px 60px rgba(0, 0, 0, 0.8); border: 1px solid rgba(255, 255, 255, 0.08); background: #000; }
.side-video { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; z-index: 1; opacity: 1; }
.side-video.is-active { z-index: 2; }
.video-glow { position: absolute; top: 50%; left: 50%; transform: translate3d(-50%, -50%, 0); width: 80%; height: 80%; background: rgba(0, 150, 255, 0.15); filter: blur(100px); z-index: 0; pointer-events: none; }

/* 右侧常驻标题 + 滚动列表 */
.right-content-area { width: 50%; height: 100%; position: relative; padding-left: 20px; padding-right: 80px; box-sizing: border-box; }

/* 主标题完全固定在右侧区域的顶部 */
.section-title-wrapper { position: absolute; top: 15%; left: 20px; z-index: 20; }
.main-section-title { font-size: 52px; font-weight: bold; margin: 0; background: linear-gradient(135deg, #fff 0%, #8ca4c8 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.title-divider { width: 60px; height: 4px; background: #00f2fe; margin-top: 20px; border-radius: 2px; box-shadow: 0 0 10px rgba(0, 242, 254, 0.5); }

/* 文字滑动的计算视口 */
.features-list-viewport { position: absolute; top: 0; left: 20px; right: 80px; height: 100%; overflow: hidden; pointer-events: none; }

.feature-block {
  position: absolute;
  top: 50%; /* 基础位置放在中央 */
  width: 100%;
  will-change: transform, opacity;
  transition: opacity 0.1s; /* 细微透明度过渡防闪 */
}

.feature-block.is-active .feature-title { text-shadow: 0 4px 15px rgba(0, 242, 254, 0.3); }

.feature-num { font-size: 22px; font-weight: bold; font-family: monospace; color: #00f2fe; margin-bottom: 10px; }
.feature-title { font-size: 38px; color: #fff; margin: 0 0 20px 0; font-weight: 500; transition: text-shadow 0.3s; }
.feature-desc { font-size: 18px; line-height: 1.8; color: #aab2bd; max-width: 95%; }

@media (max-width: 992px) {
  .split-section { flex-direction: column; }
  .left-fixed-area { width: 100%; height: 40vh; padding: 0 20px; margin-top: 80px; }
  .right-content-area { width: 100%; height: 60vh; padding: 20px; }
  .section-title-wrapper { position: relative; top: 0; left: 0; margin-bottom: 40px; }
}
</style>