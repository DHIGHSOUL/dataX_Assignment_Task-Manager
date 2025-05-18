<template lang="pug">
    .modal-overlay(@click.self="close")
        .modal-content
            h1 ワークスペース作成
            p.create-label 作成するワークスペース名を入力してください。
            form
                input.name-input(type="text" v-model="workspaceName" placeholder="ワークスペース名" required)
                textarea.description-input(type="text" v-model="workspaceDescription" placeholder="ワークスペースの説明(Option)" @input="autoResize" ref="descriptionRef")
                button.create-button(type="button" @click="createWorkspace") 作成
                button.cancel-button(type="button" @click="close") キャンセル
</template>

<script setup lang="ts">
import { ref, watch } from "vue";
import axios from "../plugins/axios";

const emit = defineEmits(["close"]);
const workspaceName = ref("");
const workspaceDescription = ref("");

const descriptionRef = ref<HTMLTextAreaElement | null>(null);

const createWorkspace = async () => {
  if (!workspaceName.value.trim()) {
    alert("ワークスペース名を入力してください。");
    return;
  }

  try {
    await axios.post("/api/workspaces", {
      workspace: {
        name: workspaceName.value,
        description: workspaceDescription.value,
      },
    });
    alert("ワークスペースを作成しました。");
    close();
    window.location.reload();
  } catch (error) {
    alert("ワークスペースの作成に失敗しました。");
  }
};

const autoResize = () => {
  if (descriptionRef.value) {
    descriptionRef.value.style.height = "auto";
    descriptionRef.value.style.height =
      descriptionRef.value.scrollHeight + "px";
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

h1 {
  font-size: 48px;
  margin-bottom: 30px;
}

.create-label {
  font-size: 24px;
  margin-bottom: 20px;
}

form {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
}

.name-input {
  padding: 5px 5px;
  font-size: 24px;
  align-self: center;
  border: 1px solid black;
  border-radius: 4px;
}

.description-input {
  width: 80%;
  min-height: 60px;
  font-size: 24px;
  margin: 10px 0;
  padding: 5px;
  align-self: center;
  border: 1px solid black;
  border-radius: 4px;
}

.create-button {
  padding: 5px 20px;
  font-size: 24px;
  color: white;
  background-color: #007bff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
  margin-bottom: 10px;
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
