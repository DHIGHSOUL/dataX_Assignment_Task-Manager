<template>
    <div class="workspace-header">
        <form class="left-menu-bar">
            <h1>{{ workspaceName }}</h1>
            <button class="return-button" @click="goBack">戻る</button>
        </form>
        <form class="menu-bar">
            <button class="setting-button" @click="goToWorkspaceSetting">設定</button>
            <button class="mypage-button" @click="goToMyPage">マイページ</button>
            <button class="logout-button" @click="logout">ログアウト</button>
        </form>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from '../plugins/axios'

const route = useRoute()
const router = useRouter()

const workspaceID = Number(route.params.id)
const workspaceName = ref('')

const fetchWorkspaceName = async () => {
    try {
        const response = await axios.get(`/api/workspaces/${workspaceID}`)
        workspaceName.value = response.data.name
    } catch (error) {
        console.error('ワークスペース名の取得に失敗しました。', error)
    }
}

onMounted(() => {
    fetchWorkspaceName()
})

const goToWorkspaceSetting = () => {
    router.push('/workspace/' + workspaceID + '/setting')
}

const goBack = () => {
    router.push('/main')
}

const goToMyPage = () => {
    localStorage.setItem('previousPage', '/workspace/' + workspaceID)
    router.push('/mypage')
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
    gap: 20px;
}

.return-button {
    align-self: center;
    height: 30%;
    padding: 8px 20px;
    color: white;
    background-color: gray;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3)
}

.menu-bar {
    display: flex;
    flex-direction: row;
    gap: 20px;
}

.setting-button {
    align-self: center;
    height: 30%;
    padding: 10px 20px;
    color: white;
    background-color: gray;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3)
}

.mypage-button {
    padding: 5px 20px;
    color: white;
    background-color: #007bff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
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