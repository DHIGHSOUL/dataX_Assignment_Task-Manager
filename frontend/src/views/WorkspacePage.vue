<template>
    <div class="workspace-header">
        <form class="left-menu-bar">
            <h1>{{ workspaceName }}</h1>
            <button class="return-button" @click="goBack">戻る</button>
        </form>
        <form class="menu-bar">
            <button class="setting-button" @click="goToWorkspaceSetting">設定</button>
            <button class="category-button" @click="goToCategoriesSetting">カテゴリ</button>
            <button class="mypage-button" @click="goToMyPage">マイページ</button>
            <button class="logout-button" @click="logout">ログアウト</button>
        </form>
    </div>
    <div class="task-board-section">
        <div class="task-column">
            <h2 class="h2-pending">待機</h2>
            <div class="task-column-list">
                <ul class="task-list">
                    <li class="task-item-dummy" @click="showCreateTaskModal = true">
                        <div class="task-title-dummy">+</div>
                    </li>
                    <li v-for="task in tasks.filter(t => t.status === 'pending')" :key="task.id" class="task-item" @click="goToTaskPage(task.id)">
                        <div class="task-title">{{ task.name }}</div>
                        <div class="task-description">{{ task.description }}</div>
                        <div class="task-due-date">{{ task.due_date?.slice(0, 10) || null }}</div>
                        <div v-if="task.workspace_category_id" :style="getCategoryStyle(task.workspace_category_id), { backgroundColor: getCategoryColor(task.workspace_category_id) }" class="task-category">{{ getCategoryName(task.workspace_category_id) }}</div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="task-column">
            <h2 class="h2-in-progress">進行中</h2>
            <div class="task-column-list">
                <ul class="task-list">
                    <li v-for="task in tasks.filter(t => t.status === 'in_progress')" :key="task.id" class="task-item" @click="goToTaskPage(task.id)">
                        <div class="task-title">{{ task.name }}</div>
                        <div class="task-description">{{ task.description }}</div>
                        <div class="task-due-date">{{ task.due_date?.slice(0, 10) || null }}</div>
                        <div v-if="task.workspace_category_id" :style="getCategoryStyle(task.workspace_category_id), { backgroundColor: getCategoryColor(task.workspace_category_id) }" class="task-category">{{ getCategoryName(task.workspace_category_id) }}</div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="task-column">
            <h2 class="h2-completed">完了済み</h2>
            <div class="task-column-list">
                <ul class="task-list">
                    <li v-for="task in tasks.filter(t => t.status === 'completed')" :key="task.id" class="task-item" @click="goToTaskPage(task.id)">
                        <div class="task-title">{{ task.name }}</div>
                        <div class="task-description">{{ task.description }}</div>
                        <div class="task-due-date">{{ task.due_date?.slice(0, 10) || null }}</div>
                        <div v-if="task.workspace_category_id" :style="getCategoryStyle(task.workspace_category_id), { backgroundColor: getCategoryColor(task.workspace_category_id) }" class="task-category">{{ getCategoryName(task.workspace_category_id) }}</div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <CreateTaskModal v-if="showCreateTaskModal":workspaceID="workspaceID" @close="showCreateTaskModal = false" />
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from '../plugins/axios'
import CreateTaskModal from './CreateTaskModal.vue'

interface Task {
    id: number
    name: string
    description: string | null
    status: 'pending' | 'in_progress' | 'completed'
    due_date: string | null
    workspace_id: number
    workspace_category_id: number | null
    created_at_user: string | null
    created_at: string
    updated_at: string
}

interface Category {
    id: number
    name: string
    color: string
    workspace_id: number
    created_at: string
    updated_at: string
}

const route = useRoute()
const router = useRouter()

const workspaceID = Number(route.params.id)
const workspaceName = ref('')
const categories = ref<Category[]>([])

const showCreateTaskModal = ref(false)

const tasks = ref<Task[]>([])

const fetchWorkspaceName = async () => {
    try {
        const response = await axios.get(`/api/workspaces/${workspaceID}`)
        workspaceName.value = response.data.name
    } catch (error) {
        console.error('ワークスペース名の取得に失敗しました。', error)
    }
}

const fetchTasks = async () => {
    try {
        const response = await axios.get(`/api/workspaces/${workspaceID}/tasks`)
        tasks.value = response.data.tasks
    } catch (error) {
        console.error('タスクの取得に失敗しました。', error)
    }
}

const fecthCategories = async () => {
    try {
        const response = await axios.get(`/api/workspaces/${workspaceID}/workspace_categories`)
        categories.value = response.data
    } catch (error) {
        console.error('カテゴリの取得に失敗しました。', error)
    }
}

const getCategoryName = (categoryID: number | null): string => {
    const category = categories.value.find(c => c.id === categoryID)
    return category ? category.name : ''
}

const getCategoryColor = (categoryID: number | null): string => {
    const category = categories.value.find(c => c.id === categoryID)
    return category && category.color ? `#${category.color}` : 'transparent'
}

const getCategoryStyle = (categoryID: number | null) => {
    const category = categories.value.find(c => c.id === categoryID)
    const hexColor = category && category.color ? `#${category.color}` : '#ffffff';

    const r = parseInt(hexColor.slice(1, 3), 16)
    const g = parseInt(hexColor.slice(3, 5), 16)
    const b = parseInt(hexColor.slice(5, 7), 16)
    const brightness = (r * 299 + g * 587 + b * 114) / 1000
    const textColor = brightness > 150 ? '#000000' : '#ffffff'

    return {
        backgroundColor: hexColor,
        color: textColor
    }
}

onMounted(() => {
    fetchWorkspaceName()
    fetchTasks()
    fecthCategories()
})

const goToCategoriesSetting = () => {
    router.push('/workspace/' + workspaceID + '/categories')
}

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

const goToTaskPage = (taskID: number) => {
    localStorage.setItem('previousPageForTaskPage', '/workspace/' + workspaceID)
    router.push(`/task/${taskID}`)
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
    gap: 30px;
}

h1 {
    font-size: 48px;
    font-weight: bold;
}

.menu-bar {
    display: flex;
    flex-direction: row;
    gap: 30px;
}

.return-button {
    align-self: center;
    height: 30%;
    padding: 8px 20px;
    font-size: 24px;
    color: white;
    background-color: gray;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3)
}

.setting-button {
    align-self: center;
    height: 30%;
    padding: 10px 20px;
    font-size: 24px;
    color: white;
    background-color: gray;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3)
}

.category-button {
    align-self: center;
    height: 30%;
    padding: 10px 20px;
    font-size: 24px;
    color: white;
    background-color: plum;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3)
}


.mypage-button {
    padding: 5px 20px;
    color: white;
    background-color: #007bff;
    font-size: 24px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.logout-button {
    padding: 5px 20px;
    color: white;
    background-color: #f44336;
    font-size: 24px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.task-board-section {
    display: flex;
    flex-direction: row;
    justify-content: space-evenly;
    gap: 20px;
    margin-bottom: 100px;
}

.task-column {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
}

.h2-pending {
    padding: 15px 30px;
    margin-bottom: 30px;
    font-size: 36px;
    align-self: center;
    border-radius: 10px;
    background-color: #fadccc;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.h2-in-progress {
    padding: 15px 30px;
    margin-bottom: 30px;
    font-size: 36px;
    align-self: center;
    border-radius: 10px;
    background-color: #d1f0c6;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.h2-completed {
    padding: 10px 30px;
    margin-bottom: 30px;
    font-size: 36px;
    align-self: center;
    border-radius: 10px;
    background-color: #b5dff3;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.task-column-list {
    width: 80%;
    flex: 1;
    display: flex;
    align-self: center;
}

.task-list {
    list-style-type: none;
    padding: 0;
    margin: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 20px;
    width: 100%;
}

.task-item {
    display: flex;
    width: 80%;
    flex-direction: column;
    align-items: start;
    padding: 10px 20px;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
    font-size: 24px;
    border-radius: 10px;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.task-item-dummy {
    display: flex;
    width: 80%;
    flex-direction: column;
    align-items: center;
    align-self: center;
    padding: 10px 20px;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
    font-size: 24px;
    border-radius: 10px;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.task-title-dummy {
    font-weight: bold;
    font-size: 36px;
}

.task-title {
    font-weight: bold;
    margin-bottom: 10px;
}

.task-description {
    margin-bottom: 10px;
    font-size: 20px;
}

.task-due-date {
    font-size: 18px;
    color: #888;
}

.task-category {
    padding: 5px 10px;
    font-size: 18px;
    color: white;
    border-radius: 4px;
    margin-top: 10px;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2);
}
</style>