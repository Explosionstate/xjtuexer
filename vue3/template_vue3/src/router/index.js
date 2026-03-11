import { createRouter, createWebHistory } from 'vue-router';
import Login from '@/views/Login.vue';
import Layout from '@/views/Layout.vue';
import UserInfo from '@/views/user/UserInfo.vue';

import RestPassword from '@/views/user/RestPassword.vue';
import UserCount from '@/views/user/UserCount.vue';
import StudentList from '@/views/user/StudentList.vue';
import UserJiashicang from '@/views/user/UserJiashicang.vue';
import UsersList from '@/views/user/UsersList.vue';
import LearningDurationAnalytics from '@/views/user/LearningDurationAnalytics.vue';
import CourseCompletionAnalytics from '@/views/user/CourseCompletionAnalytics.vue';
import News from "@/views/user/news.vue";

import OnlineLearning from '@/views/user/OnlineLearning.vue';
import InteractionAnalytics from "@/views/user/InteractionAnalytics.vue";
import CourseVisitAnalytics from "@/views/user/CourseVisitAnalytics.vue";
import ScoreAnalytics from "@/views/user/ScoreAnalytics.vue";
import CourseAvgScores from "@/views/user/CourseAvgScores.vue";
import Welcome from "@/views/Welcome.vue";
import Register from "@/views/Register.vue";
import CourseInsert from "@/views/user/CourseInsert.vue";



// 定义路由关系
const routes = [
  {path: '/welcome', component: Welcome},
  // 一级路由
  { path: '/login', component: Login },
  {
    path: '/',
    redirect: '/welcome',  // 重定向
    component: Login,

  },
  {path: '/register', component: Register},
  {path: '/login', component: Login},
  {
    path: '/',
    redirect: '/login',
    component: Layout,
    children: [

      { path: '/user/list', component: UsersList },
      { path: '/user/count', component: UserCount },
      { path: '/user/info', component: UserInfo },
      { path: '/user/resetPassword', component: RestPassword },
      { path: '/user/studentList', component: StudentList },
      { path: '/user/jiashicang', component: UserJiashicang },
      { path: '/user/completion', component: CourseCompletionAnalytics },
      { path: '/user/LearningDurationA', component: LearningDurationAnalytics },
      { path: '/user/coursevisit', component: CourseVisitAnalytics },
      { path: '/user/interaction', component: InteractionAnalytics },
      { path: '/user/learninggrade', component: ScoreAnalytics },
      { path: '/user/avgscore', component: CourseAvgScores },
      { path: '/user/learning', name: 'OnlineLearning', component: OnlineLearning },
      { path: '/user/courseinsert', component: CourseInsert },
      { path: '/news', component: News },
    ],
  },
];

// 创建路由器
const router = createRouter({
  history: createWebHistory(),
  routes,
});

// 路由守卫（可选，调试用）
router.beforeEach((to, from, next) => {
  console.log('Navigating to:', to.path);
  next();
});

export default router;