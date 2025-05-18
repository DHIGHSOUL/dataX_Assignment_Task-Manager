<template lang="pug">
  .container
    .workspace-setting
      h1 ワークスペース設定
      .workspace-setting-body
        .name-group
          label.name-label ワークスペース名
          label.workspace-name {{ workspaceName }}
        .description-group
          label.description-label ワークスペースの説明
          label.workspace-description {{ workspaceDescription }}
        button.change-button(type="button" @click="showChangeModal = true") 変更
        .invitation-group
          label.invitation-label 招待リンク
          label.workspace-invitation-link {{ invitationLink }}
        .destruction-button-group
          button.delete-button(type="button" @click="deleteWorkspace") 削除
          button.leave-button(type="button" @click="leaveWorkspace") 退会
        button.close-button(type="button" @click="goBack") 閉じる
  WorkspaceInformationChangeModal(v-if="showChangeModal" :workspaceID="workspaceID" @close="showChangeModal = false" @update="fetchWorkspaceInfo")
</template>

<script setup lang="ts">
import { ref } from "vue";
import axios from "../plugins/axios";
import { useRoute, useRouter } from "vue-router";
import { onMounted } from "vue";
import WorkspaceInformationChangeModal from "./WorkspaceInformationChangeModal.vue";

const workspaceName = ref("");
const workspaceDescription = ref("");
const route = useRoute();
const router = useRouter();
const workspaceID = Number(route.params.id);
const invitationLink = ref("");

const showChangeModal = ref(false);

const fetchWorkspaceInfo = async () => {
  try {
    const response = await axios.get(`/api/workspaces/${workspaceID}`);
    workspaceName.value = response.data.name;
    workspaceDescription.value = response.data.description;
  } catch (error) {
    console.error("ワークスペース情報の取得に失敗しました。", error);
  }
};

const fetchInvitationLink = async () => {
  try {
    const response = await axios.get(
      `/api/workspaces/${workspaceID}/invitation_code`
    );
    invitationLink.value = response.data.code;
  } catch (error) {
    console.error("招待リンクの取得に失敗しました。", error);
  }
};

const deleteWorkspace = async () => {
  if (!confirm("本当にワークスペースを削除しますか？")) {
    return;
  }

  try {
    await axios.delete(`/api/workspaces/${workspaceID}`);
    router.push("/main");
  } catch (error) {
    console.error("ワークスペースの削除に失敗しました。", error);
  }
};

const leaveWorkspace = async () => {
  if (!confirm("本当にワークスペースを退会しますか？")) {
    return;
  }

  try {
    await axios.delete(`/api/user_workspaces/${workspaceID}/leave`);
    router.push("/main");
  } catch (error) {
    console.error("ワークスペースの削除に失敗しました。", error);
  }
};

onMounted(async () => {
  await fetchWorkspaceInfo();
  await fetchInvitationLink();
});

const goBack = () => {
  router.push("/workspace/" + workspaceID);
};
</script>

<style scoped>
.container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

.workspace-setting {
  text-align: center;
  max-width: 800px;
  width: 100%;
  padding: 20px;
  box-sizing: border-box;
  background-color: white;
  border-radius: 16px;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3),
    -2px -2px 25px rgba(0, 0, 0, 0.35);
}

.workspace-setting h1 {
  font-size: 48px;
  margin-bottom: 30px;
}

.workspace-setting-body {
  display: flex;
  flex-direction: column;
  gap: 30px;
}

.name-group {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  gap: 10px;
}

.name-label {
  align-self: center;
  font-weight: bold;
  font-size: 24px;
}

.workspace-name {
  width: 80%;
  align-self: center;
  padding: 5px;
  border: 1px solid black;
  border-radius: 4px;
  font-size: 24px;
}

.description-group {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  gap: 10px;
}

.description-label {
  align-self: center;
  font-weight: bold;
  font-size: 24px;
}

.workspace-description {
  align-self: center;
  width: 80%;
  align-self: center;
  padding: 5px;
  border: 1px solid black;
  border-radius: 4px;
  font-size: 24px;
}

.change-button {
  align-self: center;
  padding: 7px 20px;
  color: white;
  background-color: #007bff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
  font-size: 24px;
}

.invitation-group {
  align-self: center;
  width: 78%;
  padding: 10px;
  display: flex;
  flex-direction: rows;
  justify-content: space-between;
  gap: 10px;
  border: 1px solid black;
  border-radius: 4px;
}

.invitation-label {
  align-self: center;
  font-weight: bold;
  font-size: 24px;
}

.workspace-invitation-link {
  align-self: center;
  font-size: 24px;
}

.close-button {
  margin-top: 20px;
  align-self: center;
  padding: 10px 20px;
  font-size: 24px;
  color: white;
  background-color: gray;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
  margin-bottom: 30px;
}

.destruction-button-group {
  display: flex;
  flex-direction: row;
  align-self: center;
  gap: 50px;
}

.delete-button {
  align-self: center;
  padding: 10px 20px;
  font-size: 24px;
  color: white;
  background-color: red;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.leave-button {
  align-self: center;
  padding: 7px 20px;
  font-size: 24px;
  color: white;
  background-color: #f44336;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}
</style>
