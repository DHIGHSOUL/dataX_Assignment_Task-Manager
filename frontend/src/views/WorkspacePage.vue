<template lang="pug">
  .workspace-header
    form.left-menu-bar
      h1 {{ workspaceName }}
      button.return-button(type="button" @click="goBack") 戻る
    form.menu-bar
      button.setting-button(type="button" @click="goToWorkspaceSetting") 設定
      button.category-button(type="button" @click="goToCategoriesSetting") カテゴリ
      button.mypage-button(type="button" @click="goToMyPage") マイページ
      button.logout-button(type="button" @click="logout") ログアウト
  .search-bar
    input.search-input(type="text" v-model="searchQuery" placeholder="タスク名、カテゴリ、担当者でタスクを検索")
    button.search-button(type="button" @click="filterTasks") 検索
  .task-board-section
    .task-column
      h2.h2-pending 待機
      .task-column-list
        ul.task-list
          li.task-item-dummy(@click="showCreateTaskModal = true")
            .task-title-dummy +
          li.task-item(v-for="task in pendingTasks" :key="task.id" @click="goToTaskPage(task.id)")
            .task-title {{ task.name }}
            .task-description {{ task.description }}
            .task-due-date {{ task.due_date?.slice(0, 10) || null }}
            .task-category(v-if="task.workspace_category_id" :style="[getCategoryStyle(task.workspace_category_id), { backgroundColor: getCategoryColor(task.workspace_category_id) }]") {{ getCategoryName(task.workspace_category_id) }}
            .task-assignments-count
              p 担当者{{ taskAssignments[task.id]?.length }}名
    .task-column
      h2.h2-in-progress 進行中
      .task-column-list
        ul.task-list
          li.task-item(v-for="task in inProgressTasks" :key="task.id" @click="goToTaskPage(task.id)")
            .task-title {{ task.name }}
            .task-description {{ task.description }}
            .task-due-date {{ task.due_date?.slice(0, 10) || null }}
            .task-category(v-if="task.workspace_category_id" :style="[getCategoryStyle(task.workspace_category_id), { backgroundColor: getCategoryColor(task.workspace_category_id) }]") {{ getCategoryName(task.workspace_category_id) }}
            .task-assignments-count
              p 担当者{{ taskAssignments[task.id]?.length }}名
    .task-column
      h2.h2-completed 完了済み
      .task-column-list
        ul.task-list
          li.task-item(v-for="task in completedTasks" :key="task.id" @click="goToTaskPage(task.id)")
            .task-title {{ task.name }}
            .task-description {{ task.description }}
            .task-due-date {{ task.due_date?.slice(0, 10) || null }}
            .task-category(v-if="task.workspace_category_id" :style="[getCategoryStyle(task.workspace_category_id), { backgroundColor: getCategoryColor(task.workspace_category_id) }]") {{ getCategoryName(task.workspace_category_id) }}
            .task-assignments-count
              p 担当者{{ taskAssignments[task.id]?.length }}名
    .assignments-column
      h2.h2-assignments 担当者
      .task-column-list
        ul.task-list
          li.task-item(v-for="user in workspaceUsers" :key="user.id")
            .task-title {{ user.name }}
            .task-progress
              | {{ userTaskProgress[user.id] ?? '0' }}%
  CreateTaskModal(v-if="showCreateTaskModal" :workspaceID="workspaceID" @close="showCreateTaskModal = false" @update="handleUpdate" )
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from "vue";
import { useRoute, useRouter } from "vue-router";
import axios from "../plugins/axios";
import CreateTaskModal from "./CreateTaskModal.vue";

interface Task {
  id: number;
  name: string;
  description: string | null;
  status: "pending" | "in_progress" | "completed";
  due_date: string | null;
  workspace_id: number;
  workspace_category_id: number | null;
  created_at_user: string | null;
  created_at: string;
  updated_at: string;
}

interface Category {
  id: number;
  name: string;
  color: string;
  workspace_id: number;
  created_at: string;
  updated_at: string;
}

interface User {
  id: number;
  name: string;
}

const route = useRoute();
const router = useRouter();

const workspaceID = Number(route.params.id);
const workspaceName = ref("");
const categories = ref<Category[]>([]);
const taskAssignments = ref<{ [taskID: number]: User[] }>({});
const searchQuery = ref("");
const workspaceUsers = ref<User[]>([]);
const userTaskProgress = ref<{ [userID: number]: number }>({});

const showCreateTaskModal = ref(false);

const tasks = ref<Task[]>([]);

const fetchWorkspaceName = async () => {
  try {
    const response = await axios.get(`/api/workspaces/${workspaceID}`);
    workspaceName.value = response.data.name;
  } catch (error) {
    console.error("ワークスペース名の取得に失敗しました。", error);
  }
};

const fetchTasks = async () => {
  try {
    const response = await axios.get(`/api/workspaces/${workspaceID}/tasks`);
    tasks.value = response.data.tasks;
  } catch (error) {
    console.error("タスクの取得に失敗しました。", error);
  }
};

const fecthCategories = async () => {
  try {
    const response = await axios.get(
      `/api/workspaces/${workspaceID}/workspace_categories`
    );
    categories.value = response.data;
  } catch (error) {
    console.error("カテゴリの取得に失敗しました。", error);
  }
};

const fetchAssignments = async () => {
  const promises = tasks.value.map(async (task) => {
    const taskID = task.id;
    try {
      const response = await axios.get(`/api/tasks/${taskID}/task_assignments`);
      taskAssignments.value[taskID] = response.data;
    } catch (error) {
      console.error("担当者の取得に失敗しました。", error);
    }
  });

  await Promise.all(promises);
};

const fetchWorkspaceUsers = async () => {
  try {
    const response = await axios.get(`/api/workspaces/${workspaceID}/users`);
    workspaceUsers.value = response.data;
  } catch (error) {
    console.error("ワークスペースユーザーの取得に失敗しました。", error);
  }
};

const fetchUserTaskProgress = async () => {
  try {
    const response = await axios.get(
      `/api/workspaces/${workspaceID}/user_task_progresses`
    );
    const progressMap: { [userID: number]: number } = {};
    response.data.forEach((item: { user_id: number; progress: number }) => {
      progressMap[item.user_id] = item.progress;
    });
    userTaskProgress.value = progressMap;
  } catch (error) {
    console.error("ユーザーのタスク進捗の取得に失敗しました。", error);
  }
};

const fetchTaskProgresses = async () => {
  const response = await axios.get(
    `/api/workspaces/${workspaceID}/user_task_progresses`
  );
  const progressMap: { [userID: number]: number } = {};
  response.data.forEach((item: { user_id: number; progress: number }) => {
    progressMap[item.user_id] = item.progress;
  });
  userTaskProgress.value = progressMap;
};

const getCategoryName = (categoryID: number | null): string => {
  const category = categories.value.find((c) => c.id === categoryID);
  return category ? category.name : "";
};

const getCategoryColor = (categoryID: number | null): string => {
  const category = categories.value.find((c) => c.id === categoryID);
  return category && category.color ? `#${category.color}` : "transparent";
};

const getCategoryStyle = (categoryID: number | null) => {
  const category = categories.value.find((c) => c.id === categoryID);
  const hexColor =
    category && category.color ? `#${category.color}` : "#ffffff";

  const r = parseInt(hexColor.slice(1, 3), 16);
  const g = parseInt(hexColor.slice(3, 5), 16);
  const b = parseInt(hexColor.slice(5, 7), 16);
  const brightness = (r * 299 + g * 587 + b * 114) / 1000;
  const textColor = brightness > 150 ? "#000000" : "#ffffff";

  return {
    backgroundColor: hexColor,
    color: textColor,
  };
};

onMounted(async () => {
  await fetchWorkspaceName();
  await fecthCategories();
  await fetchTasks();
  await fetchAssignments();
  await fetchWorkspaceUsers();
  await fetchUserTaskProgress();
  await fetchTaskProgresses();
});

const pendingTasks = computed(() => {
  // console.log('pendingTasks', tasks.value)
  return tasks.value.filter((task) => task.status === "pending");
});

const inProgressTasks = computed(() => {
  // console.log('inProgressTasks', tasks.value)
  return tasks.value.filter((task) => task.status === "in_progress");
});

const completedTasks = computed(() => {
  // console.log('completedTasks', tasks.value)
  return tasks.value.filter((task) => task.status === "completed");
});

const filterTasks = async () => {
  try {
    const response = await axios.post(
      `/api/workspaces/${workspaceID}/tasks/filter`,
      {
        workspace_id: workspaceID,
        search_query: searchQuery.value,
      }
    );
    console.log("フィルタリングリクエスト", response.data);
    tasks.value = response.data.tasks;
  } catch (error) {
    console.error("タスクのフィルタリングに失敗しました。", error);
  }
};

const goToCategoriesSetting = () => {
  router.push("/workspace/" + workspaceID + "/categories");
};

const goToWorkspaceSetting = () => {
  router.push("/workspace/" + workspaceID + "/setting");
};

const goBack = () => {
  router.push("/main");
};

const goToMyPage = () => {
  localStorage.setItem("previousPage", "/workspace/" + workspaceID);
  router.push("/mypage");
};

const logout = async () => {
  const confirmLogout = window.confirm("本当にログアウトしますか？");
  if (!confirmLogout) return;

  try {
    localStorage.removeItem("token");
    await axios.delete("/api/user/logout");
    window.location.replace("/");
  } catch {
    window.alert("ログアウトに失敗しました。");
  }
};

const goToTaskPage = (taskID: number) => {
  localStorage.setItem("previousPageForTaskPage", "/workspace/" + workspaceID);
  router.push(`/task/${taskID}`);
};

const handleUpdate = async () => {
  await fetchWorkspaceName();
  await fecthCategories();
  await fetchTasks();
  await fetchAssignments();
  await fetchWorkspaceUsers();
  await fetchUserTaskProgress();
  showCreateTaskModal.value = false;
};
</script>

<style scoped>
.workspace-header {
  padding: 0px 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: 0 auto;
}

.left-menu-bar {
  display: flex;
  flex-direction: row;
  gap: 30px;
}

h1 {
  font-size: 48px;
  font-weight: bold;
}

.menu-bar {
  display: flex;
  flex-direction: row;
  gap: 30px;
}

.return-button {
  align-self: center;
  height: 30%;
  padding: 8px 20px;
  font-size: 24px;
  color: white;
  background-color: gray;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.setting-button {
  align-self: center;
  height: 30%;
  padding: 10px 20px;
  font-size: 24px;
  color: white;
  background-color: gray;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.category-button {
  align-self: center;
  height: 30%;
  padding: 10px 20px;
  font-size: 24px;
  color: white;
  background-color: plum;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.mypage-button {
  padding: 5px 20px;
  color: white;
  background-color: #007bff;
  font-size: 24px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.logout-button {
  padding: 5px 20px;
  color: white;
  background-color: #f44336;
  font-size: 24px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.search-bar {
  display: flex;
  flex-direction: row;
  justify-content: center;
  width: 100%;
  margin: 20px;
  gap: 20px;
  font-size: 24px;
}

.search-input {
  width: 80%;
  padding: 10px 20px;
  font-size: 24px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.search-button {
  padding: 10px 20px;
  font-size: 24px;
  color: white;
  background-color: #007bff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.task-board-section {
  display: flex;
  flex-direction: row;
  justify-content: space-evenly;
  gap: 20px;
  margin-bottom: 100px;
}

.task-column {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.h2-pending {
  padding: 15px 30px;
  margin-bottom: 30px;
  font-size: 36px;
  align-self: center;
  border-radius: 10px;
  background-color: #fadccc;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.h2-in-progress {
  padding: 15px 30px;
  margin-bottom: 30px;
  font-size: 36px;
  align-self: center;
  border-radius: 10px;
  background-color: #d1f0c6;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.h2-completed {
  padding: 10px 30px;
  margin-bottom: 30px;
  font-size: 36px;
  align-self: center;
  border-radius: 10px;
  background-color: #b5dff3;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.h2-assignments {
  padding: 10px 30px;
  margin-bottom: 30px;
  font-size: 36px;
  align-self: center;
  border-radius: 10px;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.task-column-list {
  width: 80%;
  flex: 1;
  display: flex;
  align-self: center;
}

.task-list {
  list-style-type: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
  width: 100%;
}

.task-item {
  display: flex;
  width: 80%;
  flex-direction: column;
  align-items: start;
  padding: 10px 20px;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s;
  font-size: 24px;
  border-radius: 10px;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.task-item-dummy {
  display: flex;
  width: 80%;
  flex-direction: column;
  align-items: center;
  align-self: center;
  padding: 10px 20px;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s;
  font-size: 24px;
  border-radius: 10px;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.task-title-dummy {
  font-weight: bold;
  font-size: 36px;
}

.task-title {
  font-weight: bold;
  margin-top: 10px;
  margin-bottom: 10px;
}

.task-description {
  margin-bottom: 10px;
  font-size: 20px;
}

.task-due-date {
  font-size: 18px;
  color: #888;
}

.task-category {
  padding: 5px 10px;
  font-size: 18px;
  color: white;
  border-radius: 4px;
  margin-top: 10px;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2);
}

.task-assignments-count {
  font-size: 18px;
  color: #888;
}

.assignments-column {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.task-progress {
  font-size: 18px;
  color: #888;
  margin-top: 10px;
}
</style>
