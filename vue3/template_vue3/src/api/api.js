import request from "@/utils/request";
import axios from "axios";

export const getTop10Visits = (params) => axios.get('/api/coursevisit/top10Visits', { params });
export const getInteractions = (params) => axios.get('/api/interaction/interactions', { params });
export const getCourseScores = (params) => axios.get('/api/scores/courseScores', { params });
export const getCourseAvgScores = (params) => axios.get('/api/avgScores/courseAvgScores', { params });

export function getUsersPage(data) {
   return request({
      url: '/api/users/page', // 添加 /api 前缀
      method: 'post',
      data
   });
}

export function login(data) {
   return request({
      url: '/api/users/login',
      method: 'post',
      data
   });
}

export function getInfo() {
   return request({
      url: '/api/users/getInfo',
      method: 'get'
   });
}

export function listByKey(key) {
   return request({
      url: '/api/users/listByKey',
      method: 'get',
      params: { key }
   });
}

export function getById(id) {
   return request({
      url: '/api/users/getById',
      method: 'get',
      params: { id }
   });
}

export function listPage(params, data) {
   return request({
      url: '/api/users/listPage',
      method: 'get',
      params,
      data
   });
}

export function removeById(id) {
   return request({
      url: '/api/users/removeById',
      method: 'get',
      params: { id }
   });
}

export function updateById(data) {
   return request({
      url: '/api/users/updateById',
      method: 'post',
      data
   });
}

export function getDashboardStats() {
   return request({
      url: '/api/dashboard/stats',
      method: 'get'
   });
}

export function getLearningIndex() {
   return request({
      url: '/api/dashboard/learning-index',
      method: 'get'
   });
}

export function getLearningIndexList(params) {
   return request({
      url: '/api/dashboard/learning-index-list',
      method: 'get',
      params
   });
}


export function getDepartmentRanking() {
   return request({
      url: '/api/dashboard/department-ranking',
      method: 'get'
   });
}

export function getLiveSessions() {
   return request({
      url: '/api/dashboard/live-sessions',
      method: 'get'
   });
}

export const userLogin = (user) => {
   return request.post("/api/user/login", user);
};

export function userRegister(data) {
   return request({
      url: '/api/user/register',
      method: 'post',
      data
   })
}


export function insertCourse(course) {
   return request({
      url: '/api/course/insert',
      method: 'post',
      data: course
   });
}

// export const getTop10Visits = (params) => axios.get('/api/coursevisit/top10Visits', { params });
// export const getDurations = (params) => axios.get('/api/learningduration/durations', { params });

export const getCurUser = () => request.get("/api/user/getInfo");
export const pageUsers = (query) => request.get("/api/user/listPage", { params: query });
export const removeUserById = (user) => request.get("/api/user/removeById", { params: user });
export const aiChat1 = (query) => request.get("/api/ai/chat1", { params: query });
export const updateUser = (user) => request.post("/api/user/updateById", user);

export const getCompletions = (params) => axios.get('/api/completion/completions', { params });
export const pageStudents = (query) => request.get("/api/student/listPage", { params: query });

export const pageUserss = (query) => request.get("/api/users/listPage", { params: query });
export const removeUsersById = (user) => request.get("/api/users/removeById", { params: user });
export const updateUsers = (user) => request.post("/api/users/updateById", user);
