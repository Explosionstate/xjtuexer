<template>
  <div class="welcome-container">

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

    <section class="hero-track">
      <div class="hero-sticky">

        <div class="video-layer">
          <video
            ref="heroFwd"
            class="hero-video"
            :class="{ 'is-active': heroState === 'fwd' }"
            autoplay muted playsinline
          >
            <source :src="heroFwdSrc" type="video/mp4" />
          </video>
          <video
            ref="heroRev"
            class="hero-video"
            :class="{ 'is-active': heroState === 'rev' }"
            muted playsinline preload="auto"
          >
            <source :src="heroRevSrc" type="video/mp4" />
          </video>
        </div>

        <div class="hero-overlay" :style="{ opacity: 0.3 + heroProgress * 0.5 }"></div>

        <div class="hero-content" :style="{
          opacity: 1 - heroProgress * 2,
          transform: `translate(-50%, calc(-50% - ${heroProgress * 150}px))`
        }">
          <h2 class="hero-slogan">探索 · 学习 · 沉淀</h2>
          <p class="hero-sub">全新视界，向下滚动开启</p>
          <div class="scroll-indicator">↓</div>
        </div>
      </div>
    </section>

    <section class="split-scroll-track" ref="scrollTrack">
      <div class="sticky-viewport">

        <div class="left-sticky-area">
          <div class="video-wrapper">

            <video
              ref="sideFwd"
              class="side-video"
              :class="{ 'is-active': sideState === 'fwd' }"
              autoplay muted playsinline
            >
              <source :src="sideFwdSrc" type="video/mp4" />
            </video>
            <video
              ref="sideRev"
              class="side-video"
              :class="{ 'is-active': sideState === 'rev' }"
              muted playsinline preload="auto"
            >
              <source :src="sideRevSrc" type="video/mp4" />
            </video>

            <div class="video-glow"></div>
          </div>
        </div>

        <div class="right-carousel-area">
          <div class="carousel-container">
            <div class="title-mask">
              <h2 class="main-section-title" :class="{ 'reveal': splitProgress > 0.05 }">全景赋能方案</h2>
            </div>
            <div class="title-divider" :class="{ 'reveal': splitProgress > 0.05 }"></div>

            <div class="carousel-content-box">
              <transition name="nanfu-slide" mode="out-in">
                <div class="feature-item" :key="activeIndex">
                  <h3 class="feature-title">{{ features[activeIndex].title }}</h3>
                  <p class="feature-desc">{{ features[activeIndex].desc }}</p>
                </div>
              </transition>
            </div>

            <div class="progress-dots">
              <span
                v-for="(item, index) in features"
                :key="'dot'+index"
                class="dot"
                :class="{ 'active': activeIndex === index }"
              ></span>
            </div>

          </div>
        </div>

      </div>
    </section>

  </div>
</template>

<script>
// ==========================================
// 【重要】请在这里准备 4 个不同的视频文件
// ==========================================
// 首屏的两个视频
import heroFwdPath from '../assets/splash.mp4'      // 首屏正放
import heroRevPath from '../assets/re-splash.mp4'    // 首屏倒放

// 下方侧边的两个视频
import sideFwdPath from '../assets/splash.mp4'      // 侧边正放
import sideRevPath from '../assets/re-splash.mp4'    // 侧边倒放

export default {
  name: 'WelcomePage',
  data() {
    return {
      // 绑定给模板的视频源
      heroFwdSrc: heroFwdPath,
      heroRevSrc: heroRevPath,
      sideFwdSrc: sideFwdPath,
      sideRevSrc: sideRevPath,

      // 状态机：标记当前处于最上层的是哪一个 ('fwd' 或 'rev')
      heroState: 'fwd',
      sideState: 'fwd',

      // 滚动与阻尼动画数据
      targetScrollY: 0,
      smoothScrollY: 0,
      rafId: null,

      heroProgress: 0,
      splitProgress: 0,
      activeIndex: 0,

      features: [
        { title: "海量精选课程", desc: "打破时空限制，随时随地开启沉浸式学习体验。聚合全网优质思政资源，为您量身定制学习路径。" },
        { title: "全景学情分析", desc: "精准追踪学习轨迹，生成直观的可视化报表。每一次点击、每一次停留，都将转化为科学的数据参考。" },
        { title: "智能评估体系", desc: "多维度考核模型，提供客观、立体的教学反馈。自动批阅与人工复核相结合，确保成绩公平公正。" },
        { title: "教务数据驾驶舱", desc: "为管理者打造一站式数据中心，全局掌控平台动态。用数据驱动决策，赋能教育模式创新。" },
        { title: "开启全新篇章", desc: "立即登录思政云平台，与十万学子共同探索知识的边界。" }
      ]
    }
  },
  mounted() {
    window.addEventListener('scroll', this.onScroll, { passive: true });
    this.renderLoop();

    // 初始化两个区域的“毫秒级帧监听引擎”
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

    // =====================================================================
    // 🎬 毫秒级帧监听引擎 (彻底杜绝原生 @ended 带来的几十毫秒黑屏死角)
    // =====================================================================
    monitorVideoSwap(refFwd, refRev, stateKey) {
      let isSwapping = false;

      const loop = () => {
        const fwd = this.$refs[refFwd];
        const rev = this.$refs[refRev];
        if (!fwd || !rev) return requestAnimationFrame(loop);

        const activeVid = this[stateKey] === 'fwd' ? fwd : rev;
        const nextVid = this[stateKey] === 'fwd' ? rev : fwd;
        const nextState = this[stateKey] === 'fwd' ? 'rev' : 'fwd';

        // 核心魔法：提前 0.15 秒触发交接！
        if (!isSwapping && activeVid.duration && activeVid.currentTime >= activeVid.duration - 0.15) {
          isSwapping = true;

          // 1. 让背景层待命的视频立刻开始播放
          nextVid.play().catch(()=>{});

          // 2. 瞬间把播放中的备用视频提到最前面（Z-index瞬间替换，没有任何透明度渐变）
          this[stateKey] = nextState;

          // 3. 延迟 150ms 等新视频彻底接管后，再把被压在底下的旧视频暂停并重置
          setTimeout(() => {
            activeVid.pause();
            activeVid.currentTime = 0;
            isSwapping = false; // 释放锁，准备下一次轮回
          }, 150);
        }

        // 使用 rAF 保证与显示器刷新率同频 (16ms一次)，比原生 timeupdate 准 10 倍
        requestAnimationFrame(loop);
      };

      loop();
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
    },
    onScroll() {
      this.targetScrollY = window.scrollY;
    },
    renderLoop() {
      this.smoothScrollY += (this.targetScrollY - this.smoothScrollY) * 0.08;
      this.updateAnimations();
      this.rafId = requestAnimationFrame(this.renderLoop);
    },
    updateAnimations() {
      const windowHeight = window.innerHeight;

      let hProg = this.smoothScrollY / (windowHeight * 0.8);
      this.heroProgress = Math.max(0, Math.min(1, hProg));

      const track = this.$refs.scrollTrack;
      if (track) {
        const rectTop = track.offsetTop;
        const maxScroll = track.offsetHeight - windowHeight;

        let sProg = (this.smoothScrollY - rectTop) / maxScroll;
        this.splitProgress = Math.max(0, Math.min(1, sProg));

        const totalItems = this.features.length;
        let currentIndex = Math.floor(this.splitProgress * totalItems);
        if (currentIndex >= totalItems) currentIndex = totalItems - 1;

        this.activeIndex = currentIndex;
      }
    }
  }
}
</script>

<style scoped>
/* =========== 基础容器 =========== */
.welcome-container { width: 100%; background-color: #030408; color: #ffffff; font-family: 'Helvetica Neue', Helvetica, 'PingFang SC', sans-serif; }

/* =========== 1. 顶部常驻导航栏 =========== */
.global-header { position: fixed; top: 0; left: 0; width: 100%; padding: 25px 50px; display: flex; justify-content: space-between; align-items: center; box-sizing: border-box; z-index: 9999; transition: all 0.5s cubic-bezier(0.16, 1, 0.3, 1); background: linear-gradient(to bottom, rgba(0,0,0,0.8), transparent); }
.global-header.is-scrolled { padding: 15px 50px; background: rgba(8, 12, 20, 0.85); backdrop-filter: blur(15px); box-shadow: 0 10px 30px rgba(0,0,0,0.6); }
.title { font-size: 24px; font-weight: 600; letter-spacing: 2px; margin: 0; }
.particle-btn { position: relative; display: flex; align-items: center; gap: 10px; background: rgba(0, 242, 254, 0.05); border: 1px solid rgba(0, 242, 254, 0.4); color: #00f2fe; border-radius: 30px; padding: 12px 30px; font-size: 16px; font-weight: bold; cursor: pointer; overflow: hidden; transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1); backdrop-filter: blur(5px); }
.particle-btn:hover { background: rgba(0, 242, 254, 0.2); border-color: #00f2fe; color: #ffffff; box-shadow: 0 0 20px rgba(0, 242, 254, 0.6), inset 0 0 15px rgba(0, 242, 254, 0.4); transform: translateY(-2px); }
.particle-btn:hover .arrow-icon { transform: translateX(6px); }
.arrow-icon { transition: transform 0.3s; }
.particles-container { position: absolute; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none; z-index: 0; }
.particle { position: absolute; bottom: -10px; background: #ffffff; border-radius: 50%; box-shadow: 0 0 8px #00f2fe, 0 0 15px #00f2fe; opacity: 0; animation: particleFloat infinite ease-in; }
@keyframes particleFloat { 0% { transform: translateY(0) scale(0.5); opacity: 0; } 20% { opacity: 1; } 80% { opacity: 0.8; } 100% { transform: translateY(-40px) scale(1.2); opacity: 0; } }
.btn-text, .arrow-icon { position: relative; z-index: 2; letter-spacing: 2px; }


/* =========== 2. 首屏：视差退场系统 =========== */
.hero-track { height: 150vh; position: relative; z-index: 1; }
.hero-sticky { position: sticky; top: 0; width: 100%; height: 100vh; overflow: hidden; background: #000; }

/* 视频双缓冲容器 */
.video-layer { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }

/* ★ 彻底弃用 Opacity 动画 ★
  两个视频永远是 100% 显示的，谁激活，谁的 Z-index 就大，直接盖在上面！
  底层备胎视频始终停留在第一帧静静等待被提拔。
*/
.hero-video { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; z-index: 1; opacity: 1; }
.hero-video.is-active { z-index: 2; }

.hero-overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: #000; will-change: opacity; z-index: 3; }
.hero-content { position: absolute; top: 50%; left: 50%; text-align: center; z-index: 4; will-change: transform, opacity; }
.hero-slogan { font-size: 64px; letter-spacing: 12px; margin: 0 0 20px 0; font-weight: bold; background: linear-gradient(180deg, #ffffff 0%, #aab2bd 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; text-shadow: 0 10px 30px rgba(0,0,0,0.8); }
.hero-sub { font-size: 20px; letter-spacing: 6px; color: #ddd; margin-bottom: 60px; }
.scroll-indicator { font-size: 24px; color: #fff; opacity: 0.6; animation: bounce 2s infinite; }
@keyframes bounce { 0%, 20%, 50%, 80%, 100% { transform: translateY(0); } 40% { transform: translateY(-15px); } 60% { transform: translateY(-7px); } }


/* =========== 3. 滚动幕布覆盖双栏区 =========== */
.split-scroll-track { height: 400vh; position: relative; background-color: #030408; z-index: 10; box-shadow: 0 -30px 60px rgba(0,0,0,0.9); }
.sticky-viewport { position: sticky; top: 0; width: 100%; height: 100vh; display: flex; max-width: 1500px; margin: 0 auto; box-sizing: border-box; }

.left-sticky-area { width: 50%; height: 100vh; display: flex; align-items: center; padding: 0 50px; box-sizing: border-box; }
.video-wrapper { position: relative; width: 100%; aspect-ratio: 16 / 9; border-radius: 16px; overflow: hidden; box-shadow: 0 30px 60px rgba(0, 0, 0, 0.8); border: 1px solid rgba(255, 255, 255, 0.08); background: #000; }

/* 侧边视频双缓冲样式同理 */
.side-video { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; z-index: 1; opacity: 1; }
.side-video.is-active { z-index: 2; }

.video-glow { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 80%; height: 80%; background: rgba(0, 150, 255, 0.15); filter: blur(100px); z-index: 0; pointer-events: none; }

.right-carousel-area { width: 50%; height: 100vh; display: flex; align-items: center; padding-left: 20px; padding-right: 80px; box-sizing: border-box; }
.carousel-container { width: 100%; }
.title-mask { overflow: hidden; padding-bottom: 10px; }
.main-section-title { font-size: 52px; font-weight: bold; margin: 0; background: linear-gradient(135deg, #ffffff 0%, #8ca4c8 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; transform: translateY(100%); transition: transform 1s cubic-bezier(0.16, 1, 0.3, 1); }
.main-section-title.reveal { transform: translateY(0); }
.title-divider { width: 0; height: 4px; background: #00f2fe; margin: 20px 0 40px 0; border-radius: 2px; transition: width 1s cubic-bezier(0.16, 1, 0.3, 1) 0.2s; }
.title-divider.reveal { width: 60px; }

.carousel-content-box { min-height: 200px; position: relative; }
.feature-title { font-size: 32px; color: #fff; margin: 0 0 20px 0; font-weight: 500; }
.feature-desc { font-size: 18px; line-height: 1.8; color: #aab2bd; }

.nanfu-slide-enter-active, .nanfu-slide-leave-active { transition: all 0.6s cubic-bezier(0.16, 1, 0.3, 1); }
.nanfu-slide-enter { opacity: 0; transform: translateY(40px); }
.nanfu-slide-leave-to { opacity: 0; transform: translateY(-40px); }

.progress-dots { display: flex; gap: 12px; margin-top: 50px; }
.dot { width: 30px; height: 4px; background: rgba(255, 255, 255, 0.15); border-radius: 2px; transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1); }
.dot.active { background: #00f2fe; width: 60px; box-shadow: 0 0 15px rgba(0, 242, 254, 0.6); }

@media (max-width: 992px) {
  .sticky-viewport { flex-direction: column; height: 100vh; padding-top: 100px; }
  .left-sticky-area { width: 100%; height: auto; padding: 0 20px; }
  .right-carousel-area { width: 100%; height: auto; padding: 40px 20px; }
  .main-section-title { font-size: 36px; }
  .feature-title { font-size: 24px; }
}
</style>