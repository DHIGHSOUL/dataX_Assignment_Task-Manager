<template>
    <div class="container">
        <div class="my-page">
            <h1>マイページ</h1>
            <div class="mypage-body">
                <div class="email-group">
                    <label class="email-label" for="email">メールアドレス</label>
                    <label class="user-email">{{ userEmail }}</label>
                </div>
                <div class="password-group">
                    <label class="password-label" for="password">パスワード</label>
                    <button class="change-password-button" @click="showPasswordChangeModal = true">変更</button>
                </div>
                <div class="name-group">
                    <label class="name-label" for="name">名前</label>
                    <div class="change-name-group">
                        <label class="user-name">{{ userName }}</label>
                        <button class="change-name-button" @click="showNameChangeModal = true">変更</button>
                    </div>
                </div>
                <div class="button-group">
                    <button class="goback-button" @click="goBack">戻る</button>
                    <button class="logout-button" @click="logout">ログアウト</button>
                </div>
            </div>
        </div>
    </div>
    <PasswordChangeModal v-show="showPasswordChangeModal" @close="showPasswordChangeModal = false" @update="handleUpdatedPassword" />
    <NameChangeModal v-show="showNameChangeModal" @close="showNameChangeModal = false" @update="handleUpdatedName" />
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import axios from '../plugins/axios'
import PasswordChangeModal from './PasswordChangeModal.vue'
import NameChangeModal from './NameChangeModal.vue'

const router = useRouter()

const userEmail = ref('')
const userName = ref('')

const showPasswordChangeModal = ref(false)
const showNameChangeModal = ref(false)

const fetchUserInfo = async () => {
    try {
        const response = await axios.get('/api/user/me')
        userEmail.value = response.data.user.email
        userName.value = response.data.user.name
    } catch (error) {
        console.error('ユーザー情報の取得に失敗しました。', error)
    }
}

onMounted(() => {
    fetchUserInfo()
})

const handleUpdatedPassword = () => {
    fetchUserInfo()
    showPasswordChangeModal.value = false
}

const handleUpdatedName = () => {
    fetchUserInfo()
    showNameChangeModal.value = false
}

const goBack = () => {
    const previousPage = localStorage.getItem('previousPage')
    router.push(previousPage || '/main')
}

const logout = async () => {
    const confirmLogout = window.confirm('本当にログアウトしますか？');
    if (!confirmLogout) return;

    try {
        localStorage.removeItem('token')
        await axios.delete('/api/user/logout')
        window.location.replace('/')
    } catch {
        window.alert('ログアウトに失敗しました。');
    }
}
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
    max-width: 400px;
    width: 100%;
    padding: 20px;
    box-sizing: border-box;
    background-color: white;
    border-radius: 16px;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3), -2px -2px 25px rgba(0, 0, 0, 0.35);
}

.my-page h1 {
    margin-bottom: 30px;
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
}

.user-email {
    align-self: center;
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
}

.change-password-button {
    align-self: center;
    padding: 5px 20px;
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
}

.user-name {
    align-self: center;
}

.change-name-group {
    display: flex;
    flex-direction: row;
    gap: 10px;
}

.change-name-button {
    align-self: center;
    padding: 5px 20px;
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
    gap: 20px;
    margin-bottom: 30px;
}

.goback-button {
    align-self: center;
    height: 30%;
    padding: 5px 20px;
    color: white;
    background-color: gray;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3)
}

.logout-button {
    padding: 5px 20px;
    color: white;
    background-color: #f44336;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}
</style>