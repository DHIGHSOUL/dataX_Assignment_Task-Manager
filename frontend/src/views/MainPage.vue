<template>
    <div class="main-page-header">
        <h1>メインページ</h1>
        <button class="logout-button" @click="logout">ログアウト</button>
    </div>
    <div class="workspace-section">
        <template v-if="isLoading">
        </template>
        <template v-else-if="workspaces.length !== 0">
            <div class="workspace-button-group-in-list">
                <h2>ワークスペース一覧</h2>
                <button class="create-workspace-button-in-list" @click="showCreateModal = true">+</button>
                <button class="join-workspace-button-in-list" @click="showJoinModal = true">参加</button>
            </div>
            <div class="workspace-list-container">
                <button class="workspace-card-item" v-for="ws in workspaces" :key="ws.id" @click="goToWorkspace(ws.id)">
                    {{ ws.name }}
                </button>
            </div>
        </template>
        <template v-else>
            <div class="no-workspaces-container">
                <div class="workspace">
                    <div class="workspace-button-group">
                        <button class="create-workspace-button" @click="showCreateModal = true">+</button>
                        <button class="join-workspace-button" @click="showJoinModal = true">参加</button>
                    </div>
                    <p>ワークスペースがありません。<br>「+」 ボタンで新しいワークスペースを作成したり、<br>「参加」 ボタンでワークスペースに参加してください。</p>
                </div>
            </div>
        </template>
    </div>
    <CreateWorkspaceModal v-if="showCreateModal" @close="showCreateModal = false" />
    <JoinWorkspaceModal v-if="showJoinModal" @close="showJoinModal = false" />
</template>

<script setup lang="ts">
import { ref } from 'vue'
import axios from '../plugins/axios'
import { useRouter } from 'vue-router'
import { onMounted } from 'vue'
import CreateWorkspaceModal from './CreateWorkspaceModal.vue'
import JoinWorkspaceModal from './JoinWorkspaceModal.vue'

const router = useRouter()

const workspaces = ref<any[]>([])

const showCreateModal = ref(false)
const showJoinModal = ref(false)

const isLoading = ref(true)

const fetchWorkspaces = async () => {
    try {
        const response = await axios.get('/api/workspaces')
        workspaces.value = response.data
    } catch (error) {
        console.error('ワークスペースの取得に失敗しました。', error)
    } finally {
        isLoading.value = false
    }
}

onMounted(() => {
    fetchWorkspaces()
})

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

const goToWorkspace = (id: number) => {
    router.push(`/workspace/${id}`)
}
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

.logout-button {
    padding: 5px 20px;
    color: white;
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
}

.workspace-button-group-in-list {
    display: flex;
    align-items: center;
    flex-direction: row;
    gap: 25px;
    height: 60px;
}

.create-workspace-button-in-list {
    width: 60px;
    height: 30px;
    background-color: white;
    align-self: center;
    font-size: 20px;
    border: none;
    border-radius: 8px;
    color: black;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
    cursor: pointer;
}

.join-workspace-button-in-list {
    width: 80px;
    height: 30px;
    background-color: white;
    font-size: 16px;
    border: none;
    border-radius: 8px;
    color: black;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
    cursor: pointer;
}

.workspace-card-item {
    background-color: white;
    border-radius: 16px;
    border-width: 0px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
    padding: 70px 0px;
    font-size: 20px;
    font-weight: bold;
    flex: 1 1 300px;
    max-width: 300px;
    text-align: center;
}

/* ワークスペースがない場合 */
.create-workspace-button {
    width: 60px;
    height: 60px;
    font-size: 40px;
    border: none;
    border-radius: 8px;
    color: black;
    margin-bottom: 20px;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3), -2px -2px 25px rgba(0, 0, 0, 0.35);
    cursor: pointer;
}

.join-workspace-button {
    width: 80px;
    height: 60px;
    font-size: 30px;
    border: none;
    border-radius: 8px;
    color: black;
    margin-bottom: 20px;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3), -2px -2px 25px rgba(0, 0, 0, 0.35);
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