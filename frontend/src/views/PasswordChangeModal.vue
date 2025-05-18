<template lang="pug">
    .modal-overlay(@click.self="close")
        .modal-content
            h1 パースワード変更
            p.change-label 変更するパースワードを入力してください。
            .change-password-group
                input.password-input(type="text" v-model="password" placeholder="パースワード" required)
                input.password-input-again(type="text" v-model="passwordConfirmation" placeholder="パースワード再入力" required)
                button.change-button(type="submit" @click="changePassword") 更新
                button.cancel-button(type="button" @click="close") キャンセル
</template>

<script setup lang="ts">
import { ref } from "vue";
import axios from "../plugins/axios";

const emit = defineEmits(["close", "update"]);
const password = ref("");
const passwordConfirmation = ref("");

const changePassword = async () => {
  if (!password.value.trim() || !passwordConfirmation.value.trim()) {
    alert("パスワードを入力してください。");
    return;
  }

  if (password.value !== passwordConfirmation.value) {
    alert("パスワードが一致しません。");
    return;
  }

  try {
    await axios.patch("/api/user/update_password", {
      user: {
        password: password.value,
        password_confirmation: passwordConfirmation.value,
      },
    });
    alert("パスワードを変更しました。");
    emit("update");
  } catch (error) {
    alert("パスワードの変更に失敗しました。");
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
  margin-bottom: 20px;
  font-size: 48px;
  font-weight: bold;
}

.change-label {
  margin-bottom: 20px;
  font-size: 24px;
}

.change-password-group {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 30px;
}

.password-input,
.password-input-again {
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
  margin-bottom: 20px;
}
</style>
