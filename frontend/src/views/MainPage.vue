<template lang="pug">
    .main-page-header
        h1 メインページ
        form.menu-bar
            button.mypage-button(type="button" @click="goToMyPage") マイページ
            button.logout-button(type="button" @click="logout") ログアウト
    .workspace-section
        template(v-if="isLoading")
        template(v-else-if="workspaces.length !== 0")
            .workspace-button-group-in-list
                h2 ワークスペース一覧
                button.create-workspace-button-in-list(@click="showCreateModal = true") +
                button.join-workspace-button-in-list(@click="showJoinModal = true") 参加
            .workspace-list-container
                button.workspace-card-item(
                    v-for="ws in workspaces"
                    :key="ws.id"
                    @click="goToWorkspace(ws.id)"
                )
                    .workspace-card-item-content {{ ws.name }}
        template(v-else)
            .no-workspaces-container
                .workspace
                    .workspace-button-group
                        button.create-workspace-button(type="button" @click="showCreateModal = true") +
                        button.join-workspace-button(type="button" @click="showJoinModal = true") 参加
                    p.
                        ワークスペースがありません。<br>「+」 ボタンで新しいワークスペースを作成したり、<br>「参加」 ボタンでワークスペースに参加してください。
    CreateWorkspaceModal(v-if="showCreateModal" @close="showCreateModal = false")
    JoinWorkspaceModal(v-if="showJoinModal" @close="showJoinModal = false")
</template>

<script setup lang="ts">
import { ref } from "vue";
import axios from "../plugins/axios";
import { useRouter } from "vue-router";
import { onMounted } from "vue";
import CreateWorkspaceModal from "./CreateWorkspaceModal.vue";
import JoinWorkspaceModal from "./JoinWorkspaceModal.vue";

const router = useRouter();

const workspaces = ref<any[]>([]);

const showCreateModal = ref(false);
const showJoinModal = ref(false);

const isLoading = ref(true);

const fetchWorkspaces = async () => {
  try {
    const response = await axios.get("/api/workspaces");
    workspaces.value = response.data;
  } catch (error) {
    console.error("ワークスペースの取得に失敗しました。", error);
  } finally {
    isLoading.value = false;
  }
};

onMounted(async () => {
  await fetchWorkspaces();
});

const token = localStorage.getItem("token");
axios.defaults.headers.common["Authorization"] = `Bearer ${token}`;

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

const goToWorkspace = (id: number) => {
  router.push(`/workspace/${id}`);
};

const goToMyPage = () => {
  localStorage.setItem("previousPage", "/main");
  router.push("/mypage");
};
</script>

<style scoped>
/* メインページのheader */
.main-page-header {
  padding: 0px 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: 0 auto;
}

.main-page-header > h1 {
  font-size: 48px;
  font-weight: bold;
}

.menu-bar {
  display: flex;
  flex-direction: row;
  gap: 30px;
}

.mypage-button {
  padding: 10px 20px;
  color: white;
  font-size: 24px;
  background-color: #007bff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.logout-button {
  padding: 10px 20px;
  color: white;
  font-size: 24px;
  background-color: #f44336;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

/* ワークスペースカードが入る部分 */
.workspace-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 0 20px;
}

.workspace-section > h2 {
  margin-bottom: 20px;
}

.no-workspaces-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 60vh;
}

.workspace {
  margin-top: 40px;
  background-color: white;
  padding: 40px;
  border-radius: 10px;
  text-align: center;
}

.workspace-list-container {
  display: flex;
  flex-wrap: wrap;
  gap: 40px;
  margin-top: 20px;
  justify-content: flex-start;
}

.workspace-button-group-in-list {
  display: flex;
  align-items: center;
  flex-direction: row;
  gap: 25px;
  height: 60px;
}

.workspace-button-group-in-list > h2 {
  font-size: 36px;
  font-weight: bold;
}

.create-workspace-button-in-list {
  width: 60px;
  height: 40px;
  background-color: white;
  align-self: center;
  font-size: 24px;
  border: none;
  border-radius: 8px;
  color: black;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
  cursor: pointer;
}

.join-workspace-button-in-list {
  width: 80px;
  height: 40px;
  background-color: white;
  font-size: 24px;
  border: none;
  border-radius: 8px;
  color: black;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
  cursor: pointer;
}

.workspace-card-item {
  margin: 30px;
  background-color: white;
  border-radius: 16px;
  border-width: 0px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
  padding: 70px 0px;
  font-size: 28px;
  font-weight: bold;
  flex: 1 1 300px;
  max-width: 400px;
  text-align: center;
}

.workspace-card-item-content {
  font-size: 24px;
  font-weight: bold;
  padding: 0px 40px;
}

/* ワークスペースがない場合 */
.create-workspace-button {
  width: 60px;
  height: 60px;
  font-size: 40px;
  border: none;
  border-radius: 8px;
  color: #007bff;
  margin-bottom: 20px;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3),
    -2px -2px 25px rgba(0, 0, 0, 0.35);
  cursor: pointer;
}

.join-workspace-button {
  width: 80px;
  height: 60px;
  font-size: 30px;
  border: none;
  border-radius: 8px;
  color: #007bff;
  margin-bottom: 20px;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3),
    -2px -2px 25px rgba(0, 0, 0, 0.35);
  cursor: pointer;
}

.workspace-button-group {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 40px;
  margin-bottom: 20px;
}
</style>
