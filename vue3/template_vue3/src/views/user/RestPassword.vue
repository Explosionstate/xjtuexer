<template>
  <div class="reset-password-container">
    <h2>重置密码</h2>
    <el-card class="reset-card">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="auto" style="max-width: 600px">
        <el-form-item label="旧密码" prop="oldPassword">
          <el-input v-model="form.oldPassword" type="password" placeholder="请输入旧密码" show-password />
        </el-form-item>
        <el-form-item label="新密码" prop="newPassword">
          <el-input v-model="form.newPassword" type="password" placeholder="请输入新密码" show-password />
        </el-form-item>
        <el-form-item label="确认新密码" prop="confirmPassword">
          <el-input v-model="form.confirmPassword" type="password" placeholder="请确认新密码" show-password />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitForm">提交</el-button>
          <el-button @click="resetForm">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { getCurUser, updateUser } from '@/api/api';
import { ElMessage } from 'element-plus';

const form = ref({
  oldPassword: '',
  newPassword: '',
  confirmPassword: '',
});
const formRef = ref(null);
const user = ref(null);
const rules = {
  oldPassword: [
    { required: true, message: '请输入旧密码', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (!user.value || value !== user.value.password) {
          callback(new Error('旧密码错误'));
        } else {
          callback();
        }
      },
      trigger: 'blur',
    },
  ],
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少6位', trigger: 'blur' },
  ],
  confirmPassword: [
    { required: true, message: '请确认新密码', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (value !== form.value.newPassword) {
          callback(new Error('两次输入的密码不一致'));
        } else {
          callback();
        }
      },
      trigger: 'blur',
    },
  ],
};

const fetchUserInfo = async () => {
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
  }
};

const submitForm = async () => {
  try {
    await formRef.value.validate();
    if (!user.value) {
      ElMessage.error('请先获取用户信息');
      return;
    }
    const updateData = {
      id: user.value.id,
      password: form.value.newPassword,
    };
    const response = await updateUser(updateData);
    console.log('updateUser Response:', response);
    if (response.status === true && response.code === 0 && response.data) {
      ElMessage.success('密码重置成功');
      user.value.password = form.value.newPassword; // 更新本地密码
      formRef.value.resetFields();
    } else if (response.code === 70005) {
      ElMessage.error('请先登录');
      this.$router.push('/login');
    } else {
      ElMessage.error(response.message || '密码重置失败');
    }
  } catch (error) {
    console.error('submitForm Error:', error);
    ElMessage.error(`密码重置失败: ${error.message}`);
  }
};

const resetForm = () => {
  formRef.value.resetFields();
};

onMounted(() => {
  fetchUserInfo();
});
</script>

<style scoped lang="scss">
.reset-password-container {
  padding: 20px;
}
.reset-card {
  max-width: 600px;
  margin: 0 auto;
}
</style>