<script setup>
import * as echarts from 'echarts'

const value1 = ref(0)
const value2 = ref(0)
import { ref } from 'vue'
import {onMounted} from "vue";
import {aiChat1} from "@/api/api"

const result=ref('')
const msg=ref('')
const sendMsg=()=>{
  const query ={
    msg:msg.value
  }
  aiChat1(query).then(res=>{
      result.value = "该回答深度为"+value2.value+"回答开放深度最大为100，最小为0"+res.data
  })
}
import { ElMessage } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'

const imageUrl = ref('')
const handleAvatarSuccess = (
    response,
    uploadFile
) => {
  imageUrl.value = URL.createObjectURL(uploadFile.raw)
}

const beforeAvatarUpload = (rawFile) => {
  if (rawFile.type !== 'image/jpeg') {
    ElMessage.error('Avatar picture must be JPG format!')
    return false
  } else if (rawFile.size / 1024 / 1024 > 2) {
    ElMessage.error('Avatar picture size can not exceed 2MB!')
    return false
  }
  return true
}
</script>

<template>
<div>
  <h1>ai引领教学</h1>

  <div class="slider-demo-block">
    <span class="demonstration">回答深度</span>
    <el-slider v-model="value2" :step="10" show-stops />
  </div>
  <el-upload
      class="avatar-uploader"
      action="/api/file/upload"
      :show-file-list="false"
      :on-success="handleAvatarSuccess"
      :before-upload="beforeAvatarUpload"
  >


  </el-upload>
  问题：<el-input
    v-model="msg"
    style="width: 540px"
    :rows="10"
    type="textarea"
    placeholder="Please input"
/><el-button type="primary" @click="sendMsg">提问</el-button>

  </div>
  <br>
  回答：<el-input
    v-text="result"
    style="width: 540px"
    :rows="10"
    type="textarea"
    placeholder="ai助力教学"
/>
</template>

<style scoped>
.avatar-uploader .avatar {
  width: 178px;
  height: 178px;
  display: block;
}
.avatar-uploader .el-upload {
  border: 1px dashed var(--el-border-color);
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: var(--el-transition-duration-fast);
}

.avatar-uploader .el-upload:hover {
  border-color: var(--el-color-primary);
}

.el-icon.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 178px;
  height: 178px;
  text-align: center;
}
.slider-demo-block {
  max-width: 600px;
  display: flex;
  align-items: center;
}
.slider-demo-block .el-slider {
  margin-top: 0;
  margin-left: 12px;
}
.slider-demo-block .demonstration {
  font-size: 14px;
  color: var(--el-text-color-secondary);
  line-height: 44px;
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  margin-bottom: 0;
}
.slider-demo-block .demonstration + .el-slider {
  flex: 0 0 70%;
}
</style>