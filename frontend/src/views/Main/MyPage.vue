<template lang="pug">
    .container
        .my-page
            h1 マイページ
            .mypage-body
                .email-group
                    label.email-label(for="email") メールアドレス
                    label.user-email {{ userEmail }}
                .password-group
                    label.password-label(for="password") パスワード
                    button.change-password-button(type="button" @click="showPasswordChangeModal = true") 変更
                .name-group
                    label.name-label(for="name") 名前
                    .change-name-group
                        label.user-name {{ userName }}
                        button.change-name-button(type="button" @click="showNameChangeModal = true") 変更
                .button-group
                    button.goback-button(type="button" @click="goBack") 戻る
                    button.logout-button(type="button" @click="logout") ログアウト
    PasswordChangeModal( v-show="showPasswordChangeModal" @close="showPasswordChangeModal = false" @update="handleUpdatedPassword")
    NameChangeModal(v-show="showNameChangeModal" @close="showNameChangeModal = false" @update="handleUpdatedName")
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import axios from "../../plugins/axios";
import PasswordChangeModal from "./PasswordChangeModal.vue";
import NameChangeModal from "./NameChangeModal.vue";

const router = useRouter();

const userEmail = ref("");
const userName = ref("");

const showPasswordChangeModal = ref(false);
const showNameChangeModal = ref(false);

const fetchUserInfo = async () => {
  try {
    const response = await axios.get("/api/user/me");
    userEmail.value = response.data.user.email;
    userName.value = response.data.user.name;
  } catch (error) {
    console.error("ユーザー情報の取得に失敗しました。", error);
  }
};

onMounted(async () => {
  await fetchUserInfo();
});

const handleUpdatedPassword = () => {
  fetchUserInfo();
  showPasswordChangeModal.value = false;
};

const handleUpdatedName = () => {
  fetchUserInfo();
  showNameChangeModal.value = false;
};

const goBack = () => {
  const previousPage = localStorage.getItem("previousPage");
  router.push(previousPage || "/main");
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
</script>

<style scoped>
.container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

.my-page {
  text-align: center;
  max-width: 700px;
  width: 100%;
  padding: 20px;
  box-sizing: border-box;
  background-color: white;
  border-radius: 16px;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3),
    -2px -2px 25px rgba(0, 0, 0, 0.35);
}

.my-page h1 {
  margin-bottom: 30px;
  font-size: 48px;
}

.mypage-body {
  display: flex;
  flex-direction: column;
  gap: 30px;
}

.email-group {
  align-self: center;
  width: 80%;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  gap: 10px;
}

.email-label {
  align-self: center;
  font-weight: bold;
  font-size: 24px;
}

.user-email {
  align-self: center;
  font-size: 24px;
}

.password-group {
  align-self: center;
  width: 80%;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  gap: 10px;
}

.password-label {
  align-self: center;
  font-weight: bold;
  font-size: 24px;
}

.change-password-button {
  align-self: center;
  padding: 5px 20px;
  font-size: 24px;
  color: white;
  background-color: #007bff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.name-group {
  align-self: center;
  width: 80%;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  gap: 10px;
}

.name-label {
  align-self: center;
  font-weight: bold;
  font-size: 24px;
}

.user-name {
  align-self: center;
  font-size: 24px;
}

.change-name-group {
  display: flex;
  flex-direction: row;
  gap: 10px;
}

.change-name-button {
  align-self: center;
  padding: 5px 20px;
  font-size: 24px;
  color: white;
  background-color: #007bff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.button-group {
  align-self: center;
  display: flex;
  flex-direction: row;
  gap: 30px;
  margin-bottom: 30px;
}

.goback-button {
  align-self: center;
  height: 30%;
  padding: 5px 20px;
  font-size: 24px;
  color: white;
  background-color: gray;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.logout-button {
  padding: 5px 20px;
  font-size: 24px;
  color: white;
  background-color: #f44336;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}
</style>
