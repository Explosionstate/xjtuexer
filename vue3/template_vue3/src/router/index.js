import { createRouter, createWebHistory } from 'vue-router'
import Login from '@/views/Login.vue'
import Layout from '@/views/Layout.vue'
import UserInfo from '@/views/user/UserInfo.vue'
import RestPassword from '@/views/user/RestPassword.vue'
import UserCount from '@/views/user/UserCount.vue'
import StudentList from '@/views/user/StudentList.vue'
import UserJiashicang from '@/views/user/UserJiashicang.vue'
import UsersList from '@/views/user/UsersList.vue'
import LearningDurationAnalytics from '@/views/user/LearningDurationAnalytics.vue'
import CourseCompletionAnalytics from '@/views/user/CourseCompletionAnalytics.vue'
import News from '@/views/user/news.vue'
import OnlineLearning from '@/views/user/OnlineLearning.vue'
import InteractionAnalytics from '@/views/user/InteractionAnalytics.vue'
import CourseVisitAnalytics from '@/views/user/CourseVisitAnalytics.vue'
import ScoreAnalytics from '@/views/user/ScoreAnalytics.vue'
import CourseAvgScores from '@/views/user/CourseAvgScores.vue'
import Welcome from '@/views/Welcome.vue'
import Register from '@/views/Register.vue'
import CourseInsert from '@/views/user/CourseInsert.vue'
import { useUserInfoStore } from '@/stores/userInfo'

const ROLE_DEFAULT_PATH = {
  admin: '/user/list',
  teacher: '/news',
  student: '/news'
}

const ROLE_ALLOW_ROUTES = {
  admin: new Set(['/user/list', '/user/count']),
  teacher: new Set([
    '/news',
    '/user/count',
    '/user/jiashicang',
    '/user/info',
    '/user/resetPassword',
    '/user/learning',
    '/user/studentList',
    '/user/coursevisit',
    '/user/learninggrade',
    '/user/interaction',
    '/user/avgscore',
    '/user/LearningDurationA',
    '/user/completion'
  ]),
  student: new Set([
    '/news',
    '/user/count',
    '/user/info',
    '/user/resetPassword',
    '/user/learning'
  ])
}

const routes = [
  { path: '/welcome', component: Welcome },
  { path: '/login', component: Login },
  { path: '/register', component: Register },
  {
    path: '/',
    redirect: '/welcome',
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
      { path: '/news', component: News }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const publicPaths = new Set(['/login', '/register', '/welcome'])
  if (publicPaths.has(to.path)) {
    next()
    return
  }

  const userInfoStore = useUserInfoStore()
  const loginName = userInfoStore.userInfo?.loginName
  if (!loginName) {
    next('/login')
    return
  }

  const role = (userInfoStore.userInfo?.role === 'teacher' || userInfoStore.userInfo?.role === 'student')
    ? userInfoStore.userInfo.role
    : 'admin'

  const allowSet = ROLE_ALLOW_ROUTES[role] || ROLE_ALLOW_ROUTES.admin
  if (!allowSet.has(to.path)) {
    next(ROLE_DEFAULT_PATH[role] || '/user/list')
    return
  }

  next()
})

export default router
