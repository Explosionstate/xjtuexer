<script setup>
import { ref } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import { pageUserss, removeUsersById, updateUsers } from "@/api/api";
import { Plus } from "@element-plus/icons-vue";

const users = ref([]);
const pageNum = ref(1);
const pageSize = ref(10);
const loginName = ref('');
const password = ref('');
const name = ref('');
const total = ref(0);
const isShow = ref(false);
const selectUser = ref({});

const getUsers = () => {
  const query = {
    pageNum: pageNum.value,
    pageSize: pageSize.value,
    loginName: loginName.value,
    name: name.value,
  };
  console.info(query);
  pageUserss(query).then(res => {
    users.value = res.data.records;
    total.value = res.data.total;
  });
};

const handleSizeChange = (value) => {
  pageSize.value = value;
  getUsers();
};

const pageNoChange = (value) => {
  pageNum.value = value;
  getUsers();
};

const showEditDialog = (row) => {
  selectUser.value = JSON.parse(JSON.stringify(row));
  isShow.value = true;
};

const saveUser = () => {
  const user = {
    loginName: selectUser.value.loginName,
    password: selectUser.value.password,
    id: selectUser.value.id,
    name: selectUser.value.name,
  };
  updateUsers(user).then(res => {
    if (res.data) {
      ElMessage({
        type: 'success',
        message: '修改成功',
      });
      getUsers();
    }
  });
};

const removeUser = (row) => {
  ElMessageBox.confirm(
      '是否确认删除?',
      'Warning',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }
  )
      .then(() => {
        const obj = {
          id: row.id
        };
        removeUsersById(obj).then(() => {
          getUsers();
        });
        ElMessage({
          type: 'success',
          message: '删除成功',
        });
      })
      .catch(() => {});
};

const imageUrl = ref('');

const handleAvatarSuccess = (response, uploadFile) => {
  imageUrl.value = URL.createObjectURL(uploadFile.raw);
  selectUser.value.advater = response.data.url;
};

getUsers();
</script>

<template>
  <el-card class="page-container">
    <template #header>
      <div class="header">
        <span>用户列表</span>
      </div>
    </template>
    <el-form :inline="true" class="demo-form-inline">
      <el-form-item label="用户名">
        <el-input v-model="loginName" placeholder="请输入用户名" clearable/>
      </el-form-item>
    </el-form>
    <el-form :inline="true" class="demo-form-inline">
      <el-form-item label="姓名">
        <el-input v-model="name" placeholder="请输入姓名" clearable/>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="getUsers">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table :data="users" style="width: 100%">
      <el-table-column prop="id" label="ID"/>
      <el-table-column prop="loginName" label="用户名"/>
      <el-table-column prop="name" label="姓名"/>
      <el-table-column prop="password" label="密码"/>
      <el-table-column label="操作" align="center">
        <template #default="scope">
          <el-button type="danger" @click="removeUser(scope.row)">删除</el-button>
          <el-button type="primary" @click="showEditDialog(scope.row)">编辑</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
        :background="true"
        v-model:current-page="pageNum"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total"
        @size-change="handleSizeChange"
        @current-change="pageNoChange"
    />
    <el-dialog
        v-model="isShow"
        title="用户编辑"
        width="500"
        :before-close="handleClose"
    >
      <span>
          <el-form label-width="auto" style="max-width: 600px">
            <el-form-item label="用户名  ">
              <el-input v-model="selectUser.loginName"/>
            </el-form-item>
            <el-form-item label="姓名  ">
              <el-input v-model="selectUser.name"/>
            </el-form-item>
            <el-form-item label="密码  ">
              <el-input v-model="selectUser.password"/>
            </el-form-item>
          </el-form>
      </span>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="isShow = false">取消</el-button>
          <el-button type="primary" @click="saveUser">
            修改
          </el-button>
        </div>
      </template>
    </el-dialog>
  </el-card>
</template>

<style scoped lang="scss">
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