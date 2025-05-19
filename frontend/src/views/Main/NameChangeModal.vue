<template lang="pug">
    .modal-overlay(@click.self="close")
        .modal-content
            h1 名前変更
            p.change-label 変更する名前を入力してください。
            .change-name-group
                input.name-input(type="text" v-model="name" placeholder="名前" required)
                button.change-button(type="button" @click="changeName") 更新
                button.cancel-button(type="button" @click="close") キャンセル
</template>

<script setup lang="ts">
import { ref } from "vue";
import axios from "../../plugins/axios";

const emit = defineEmits(["close", "update"]);
const name = ref("");

const changeName = async () => {
  if (!name.value.trim()) {
    alert("名前を入力してください。");
    return;
  }

  try {
    await axios.patch("/api/user/update_name", {
      user: {
        name: name.value,
      },
    });
    alert("名前を変更しました。");
    emit("update");
  } catch (error) {
    alert("名前の変更に失敗しました。");
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
  margin-bottom: 20px;
}

.change-label {
  font-size: 24px;
  margin-bottom: 20px;
}

.change-name-group {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 30px;
}

.name-input {
  padding: 10px 10px;
  font-size: 24px;
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
}
</style>
