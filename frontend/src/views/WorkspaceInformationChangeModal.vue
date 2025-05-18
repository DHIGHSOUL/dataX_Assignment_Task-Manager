<template lang="pug">
  .modal-overlay(@click.self="close")
    .modal-content
      h1 ワークスペース情報変更
      p 変更する情報を入力してください。
      .change-name-group
        p.update-label ワークスペース名
        input.name-input(type="text" v-model="workspaceName" placeholder="ワークスペース名" required)
        p.update-label ワークスペースの説明
        textarea.description-input(type="text" v-model="workspaceDescription" placeholder="ワークスペースの説明(Option)" @input="autoResize" ref="descriptionRef")
        button.change-button(type="submit" @click="changeWorkspaceInformation") 更新
        button.cancel-button(type="button" @click="close") キャンセル
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from "vue";
import axios from "../plugins/axios";

const emit = defineEmits(["close", "update"]);
const workspaceName = ref("");
const workspaceDescription = ref("");
const props = defineProps({
  workspaceID: {
    type: Number,
    required: true,
  },
});

const descriptionRef = ref<HTMLTextAreaElement | null>(null);

const workspaceID = props.workspaceID;

const fetchOriginalWorkspaceInfo = async () => {
  try {
    const response = await axios.get("/api/workspaces/" + workspaceID);
    workspaceName.value = response.data.name;
    workspaceDescription.value = response.data.description;
  } catch (error) {
    console.error("ワークスペース情報の取得に失敗しました。", error);
  }
};

const autoResize = () => {
  if (descriptionRef.value) {
    descriptionRef.value.style.height = "auto";
    descriptionRef.value.style.height =
      descriptionRef.value.scrollHeight + "px";
  }
};

onMounted(async () => {
  await fetchOriginalWorkspaceInfo();
});

const changeWorkspaceInformation = async () => {
  if (!workspaceName.value.trim()) {
    alert("ワークスペース名を入力してください。");
    return;
  }

  try {
    await axios.patch("/api/workspaces/" + workspaceID, {
      workspace: {
        name: workspaceName.value,
        description: workspaceDescription.value,
      },
    });
    alert("ワークスペース情報を変更しました。");
    emit("update");
  } catch (error) {
    console.error("ワークスペース情報の変更に失敗しました。", error);
    alert("ワークスペース情報の変更に失敗しました。");
  }
};

const close = () => {
  emit("close");
};
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background-color: rgba(0, 0, 0, 0.5);
}

.modal-content {
  background-color: white;
  padding: 30px;
  width: 600px;
  text-align: center;
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.change-name-group {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
}

h1 {
  font-size: 48px;
  margin-bottom: 20px;
}

p {
  font-size: 24px;
  margin-bottom: 20px;
}

.update-label {
  font-size: 24px;
  margin-bottom: 0px;
}

.name-input {
  padding: 10px 10px;
  font-size: 24px;
  align-self: center;
  border: 1px solid black;
  border-radius: 4px;
}

.description-input {
  width: 80%;
  min-height: 60px;
  font-size: 24px;
  padding: 30px 10px;
  align-self: center;
  border: 1px solid black;
  border-radius: 4px;
}

.change-button {
  padding: 5px 20px;
  font-size: 24px;
  color: white;
  background-color: #007bff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.cancel-button {
  padding: 5px 20px;
  font-size: 24px;
  color: white;
  background-color: gray;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
  margin-bottom: 30px;
}
</style>
