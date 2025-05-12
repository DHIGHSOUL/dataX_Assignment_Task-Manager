<template>
    <div class="main-page-header">
        <h1>メインページ</h1>
        <button class="logout-button" @click="logout">ログアウト</button>
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import axios from '../plugins/axios'
import { useRouter } from 'vue-router'

const router = useRouter()

const token = localStorage.getItem('token')
axios.defaults.headers.common['Authorization'] = `Bearer ${token}`

const logout = async () => {
    const confirmLogout = window.confirm('本当にログアウトしますか？');
    if (!confirmLogout) { return; }

    try {
        await axios.delete('/api/user/logout')
        localStorage.removeItem('token')
        window.alert('ログアウトしました。')
        router.push('/login')
    } catch {
        window.alert('ログアウトに失敗しました。');
    }
}
</script>

<style scoped>
.main-page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin: 0 auto;
}

.logout-button {
    background: none;
    border: none;
    color: #007bff;
    text-decoration: underline;
    cursor: pointer;
    font-size: 14px;
}
</style>