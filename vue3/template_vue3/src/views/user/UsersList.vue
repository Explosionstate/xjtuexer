<script setup>
import { ref } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import { pageUserss, removeUsersById, updateUsers } from "@/api/api";

const ROLE_OPTIONS = [
  { label: "学生", value: "student" },
  { label: "教师", value: "teacher" },
  { label: "管理员", value: "admin" },
];

const ROLE_LABEL_MAP = {
  student: "学生",
  teacher: "教师",
  admin: "管理员",
};

const users = ref([]);
const pageNum = ref(1);
const pageSize = ref(10);
const loginName = ref("");
const name = ref("");
const total = ref(0);

const isShow = ref(false);
const isCreate = ref(false);
const dialogTitle = ref("编辑用户");
const selectUser = ref({});

const getUsers = () => {
  const query = {
    pageNum: pageNum.value,
    pageSize: pageSize.value,
    loginName: loginName.value,
    name: name.value,
  };
  pageUserss(query).then((res) => {
    users.value = res.data?.records || [];
    total.value = res.data?.total || 0;
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

const openCreateDialog = () => {
  isCreate.value = true;
  dialogTitle.value = "新增用户";
  selectUser.value = {
    loginName: "",
    name: "",
    password: "",
    role: "student",
    originalRole: null,
  };
  isShow.value = true;
};

const showEditDialog = (row) => {
  isCreate.value = false;
  dialogTitle.value = "编辑用户";
  selectUser.value = {
    ...JSON.parse(JSON.stringify(row)),
    role: row.role || "student",
    originalRole: row.role || null,
    password: "",
  };
  isShow.value = true;
};

const saveUser = () => {
  if (!selectUser.value.loginName) {
    ElMessage.error("请输入用户名");
    return;
  }
  if (isCreate.value && !selectUser.value.password) {
    ElMessage.error("新增用户必须填写密码");
    return;
  }
  if (!selectUser.value.role) {
    ElMessage.error("请选择角色职责");
    return;
  }

  const user = {
    id: selectUser.value.id,
    loginName: selectUser.value.loginName,
    password: selectUser.value.password,
    name: selectUser.value.name,
    role: selectUser.value.role,
    originalRole: selectUser.value.originalRole,
  };

  if (!user.id) {
    delete user.id;
  }
  if (!user.password) {
    delete user.password;
  }

  updateUsers(user).then((res) => {
    if (res.data) {
      ElMessage.success(isCreate.value ? "新增成功" : "修改成功");
      isShow.value = false;
      getUsers();
      return;
    }
    ElMessage.error(isCreate.value ? "新增失败" : "修改失败");
  });
};

const removeUser = (row) => {
  ElMessageBox.confirm("是否确认删除?", "Warning", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning",
  })
    .then(() => {
      removeUsersById({ id: row.id, role: row.role }).then((res) => {
        if (res.data) {
          ElMessage.success("删除成功");
          getUsers();
          return;
        }
        ElMessage.error("删除失败");
      });
    })
    .catch(() => {});
};

const roleText = (role) => ROLE_LABEL_MAP[role] || role || "-";
const roleTagType = (role) => {
  if (role === "admin") {
    return "danger";
  }
  if (role === "teacher") {
    return "warning";
  }
  return "success";
};

getUsers();
</script>

<template>
  <el-card class="page-container">
    <template #header>
      <div class="header">
        <span>用户列表</span>
        <el-button type="primary" @click="openCreateDialog">新增用户</el-button>
      </div>
    </template>

    <el-form :inline="true" class="demo-form-inline">
      <el-form-item label="用户名">
        <el-input v-model="loginName" placeholder="请输入用户名" clearable />
      </el-form-item>
      <el-form-item label="姓名">
        <el-input v-model="name" placeholder="请输入姓名" clearable />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="getUsers">查询</el-button>
      </el-form-item>
    </el-form>

    <el-table :data="users" style="width: 100%">
      <el-table-column prop="id" label="ID" />
      <el-table-column prop="loginName" label="用户名" />
      <el-table-column prop="name" label="姓名" />
      <el-table-column label="角色职责">
        <template #default="scope">
          <el-tag :type="roleTagType(scope.row.role)">{{ roleText(scope.row.role) }}</el-tag>
        </template>
      </el-table-column>
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

    <el-dialog v-model="isShow" :title="dialogTitle" width="500">
      <el-form label-width="88px" style="max-width: 600px">
        <el-form-item label="用户名">
          <el-input v-model="selectUser.loginName" />
        </el-form-item>
        <el-form-item label="角色职责">
          <el-select v-model="selectUser.role" placeholder="请选择角色职责" style="width: 100%">
            <el-option
              v-for="item in ROLE_OPTIONS"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="姓名">
          <el-input v-model="selectUser.name" />
        </el-form-item>
        <el-form-item label="密码">
          <el-input
            v-model="selectUser.password"
            :placeholder="isCreate ? '请输入密码' : '留空表示不修改密码'"
            show-password
          />
        </el-form-item>
      </el-form>

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="isShow = false">取消</el-button>
          <el-button type="primary" @click="saveUser">保存</el-button>
        </div>
      </template>
    </el-dialog>
  </el-card>
</template>

<style scoped lang="scss">
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
</style>
