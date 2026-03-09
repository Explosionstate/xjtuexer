<template>
  <div class="user-info-container">
    <h2>用户信息</h2>
    <el-card class="info-card">
      <el-form v-if="user && !loading" :model="user" label-width="auto" style="max-width: 600px">
        <el-form-item label="ID">
          <el-input v-model="user.id" disabled />
        </el-form-item>
        <el-form-item label="用户名">
          <el-input v-model="user.loginName" disabled />
        </el-form-item>
        <el-form-item label="最后登录时间">
          <el-input v-model="user.lastLoginTime" disabled />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="user.remark" type="textarea" rows="4" placeholder="请输入备注" />
        </el-form-item>
        <el-form-item label="头像">
          <el-upload
              class="avatar-uploader"
              action="/api/file/upload"
              :show-file-list="false"
              :on-success="handleAvatarSuccess"
              :before-upload="beforeAvatarUpload"
          >
            <img v-if="user.advater" :src="user.advater" class="avatar" />
            <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
          </el-upload>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="saveUser">保存</el-button>
        </el-form-item>
      </el-form>
      <el-skeleton v-else-if="loading" :rows="5" animated />
      <div v-else>暂无用户信息</div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { getCurUser, updateUser } from '@/api/api';
import { ElMessage } from 'element-plus';
import { Plus } from '@element-plus/icons-vue';

const user = ref(null);
const loading = ref(false);

const fetchUserInfo = async () => {
  loading.value = true;
  try {
    const response = await getCurUser();
    console.log('getCurUser Response:', response);
    if (response.status === true && response.code === 0 && response.data) {
      user.value = response.data;
    } else if (response.code === 70005) {
      ElMessage.error('请先登录');
      this.$router.push('/login');
    } else {
      ElMessage.error(response.message || '获取用户信息失败');
    }
  } catch (error) {
    console.error('fetchUserInfo Error:', error);
    ElMessage.error(`获取用户信息失败: ${error.message}`);
  } finally {
    loading.value = false;
  }
};

const beforeAvatarUpload = (file) => {
  const isImage = file.type.startsWith('image/');
  const isLt2M = file.size / 1024 / 1024 < 2;
  if (!isImage) {
    ElMessage.error('请上传图片文件！');
  }
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过2MB！');
  }
  return isImage && isLt2M;
};

const handleAvatarSuccess = (response, uploadFile) => {
  if (response.data && response.data.url) {
    user.value.advater = response.data.url;
    ElMessage.success('头像上传成功');
  } else {
    ElMessage.error('头像上传失败');
  }
};

const saveUser = async () => {
  try {
    const updateData = {
      id: user.value.id,
      remark: user.value.remark,
      advater: user.value.advater,
    };
    const response = await updateUser(updateData);
    console.log('updateUser Response:', response);
    if (response.status === true && response.code === 0 && response.data) {
      ElMessage.success('用户信息更新成功');
    } else if (response.code === 70005) {
      ElMessage.error('请先登录');
      this.$router.push('/login');
    } else {
      ElMessage.error(response.message || '更新用户信息失败');
    }
  } catch (error) {
    console.error('saveUser Error:', error);
    ElMessage.error(`更新用户信息失败: ${error.message}`);
  }
};

onMounted(() => {
  fetchUserInfo();
});
</script>

<style scoped lang="scss">
.user-info-container {
  padding: 20px;
}
.info-card {
  max-width: 600px;
  margin: 0 auto;
}
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
</style>