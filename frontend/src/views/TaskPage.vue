<template>
    <div class="Task-header">
        <form class="left-menu-bar">
            <h1>{{ taskName }}</h1>
            <button class="return-button" @click="goBack">戻る</button>
        </form>
        <form class="menu-bar">
            <button class="delete-button" @click="deleteTask">削除</button>
            <button type="button" class="change-button" @click="showTaskChangeModal = true">変更</button>
            <button class="mypage-button" @click="goToMyPage">マイページ</button>
            <button class="logout-button" @click="logout">ログアウト</button>
        </form>
    </div>
    <div class="task-board">
        <div class="task-board-left-section">
            <form class="task-column">
                <h2 class="task-info-label">タスク情報</h2>
                <div class="task-description-group">
                    <p class="task-description-label">タスクの説明</p>
                    <label class="task-description">{{ taskDescription }}</label>
                </div>
                <div class="task-due-date-group">
                    <p class="task-due-date-label">タスクの期限</p>
                    <label class="task-due-date">{{ due_date?.slice(0, 10) || null }}</label>
                </div>
                <div class="task-status-group">
                    <p class="task-status-label">タスクの進行状況</p>
                    <label :class="['task-status', status]">{{ status }}</label>
                </div>
            </form>
        </div>
        <div class="task-board-right-section">
            <form class="task-column">
                <h2 class="task-info-label">カテゴリ＆担当者</h2>
                <div class="task-category-group">
                    <p class="task-category-label">タスクのカテゴリ</p>
                    <label class="task-category" :style="getCategoryStyle(categoryColor)">{{ categoryName || 'カテゴリがありません' }}</label>
                </div>
                <div class="task-assignee-group">
                    <p class="task-assignee-label">タスクの担当者</p>
                    <div v-if="assignees.length > 0" class="task-assignee-list">
                        <label v-for="assignee in assignees" :key="assignee.id" class="task-assignee">{{ assignee.name }}</label>
                    </div>
                    <div v-else class="task-assignee">
                        <label>担当者がいません</label>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <TaskInfoChangeModal v-if="showTaskChangeModal" :taskID="taskID" :workspaceID="workspaceID ?? 0" @close="showTaskChangeModal = false" @update="handleChange" />
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from '../plugins/axios'
import TaskInfoChangeModal from './TaskInfoChangeModal.vue'

const route = useRoute()
const router = useRouter()

const workspaceID = ref<number | null>(null)
const taskID = Number(route.params.id)
const taskDescription = ref('')
const due_date = ref('')
const status = ref('')
const categoryColor = ref<string | null>(null)
const categoryName = ref('')
const assignees = ref<{ id: number, name: string }[]>([])

const taskName = ref('')

const showTaskChangeModal = ref(false)

const fetchTaskInfo = async () => {
    try {
        console.log('taskID:', taskID)
        if (isNaN(taskID)) {
            console.error('taskIDが正しく取得できませんでした。')
            return
        }
        const response = await axios.get(`/api/tasks/${taskID}`)
        taskName.value = response.data.task.name
        taskDescription.value = response.data.task.description
        due_date.value = response.data.task.due_date
        status.value = response.data.task.status
        workspaceID.value = response.data.task.workspace_id
        if (response.data.task.workspace_category) {
            categoryColor.value = response.data.task.workspace_category.color
            categoryName.value = response.data.task.workspace_category.name
        } else {
            categoryColor.value = ''
            categoryName.value = ''
        }
        console.log('タスク情報:', response.data)
    } catch (error) {
        console.error('taskIDが正しく取得できませんでした。')
        console.error('タスク情報の取得に失敗しました。', error)
    }
}

const fetchAssignees = async () => {
    try {
        const response = await axios.get(`/api/tasks/${taskID}/task_assignments`)
        assignees.value = response.data
    } catch (error) {
        console.error('担当者の取得に失敗しました。', error)
    }
}

const getCategoryStyle = (hex: string | null) => {
    const hexColor = hex ? `#${hex}` : '#ffffff';
    const r = parseInt(hexColor.slice(1, 3), 16);
    const g = parseInt(hexColor.slice(3, 5), 16);
    const b = parseInt(hexColor.slice(5, 7), 16);
    const brightness = (r * 299 + g * 587 + b * 114) / 1000;
    const textColor = brightness > 150 ? '#000000' : '#ffffff';
    return {
      backgroundColor: hexColor,
      color: textColor,
    };
};

onMounted(async () => {
    await fetchTaskInfo()
    await fetchAssignees()
})

const goBack = () => {
    const previousPage = localStorage.getItem('previousPageForTaskPage')
    router.push(previousPage || '/main')
}

const goToMyPage = () => {
    localStorage.setItem('previousPage', '/task/' + taskID)
    router.push('/mypage')
}

const deleteTask = async () => {
    const confirmDelete = window.confirm('本当にタスクを削除しますか？');
    const previousPage = localStorage.getItem('previousPageForTaskPage')

    if (!confirmDelete) return;

    try {
        router.push(previousPage || '/main')
        await axios.delete(`/api/tasks/${taskID}`)
        alert('タスクを削除しました。')
    } catch (error) {
        console.error('タスクの削除に失敗しました。', error)
        alert('タスクの削除に失敗しました。')
    }
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

const handleChange = async () => {
    await fetchTaskInfo()
    await fetchAssignees()
    showTaskChangeModal.value = false
}
</script>

<style scoped>
.Task-header {
    padding: 0px 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin: 0 auto;
}

.left-menu-bar {
    display: flex;
    align-items: center;
    gap: 20px;
}

h1 {
    font-size: 48px;
    font-weight: bold;
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

.menu-bar {
    display: flex;
    flex-direction: row;
    gap: 30px;
}

.delete-button {
    align-self: center;
    height: 30%;
    padding: 13px 20px;
    font-size: 24px;
    color: white;
    background-color: red;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3)
}


.change-button {
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

.mypage-button {
    padding: 10px 20px;
    font-size: 24px;
    color: white;
    background-color: #007bff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.logout-button {
    padding: 10px 20px;
    color: white;
    background-color: #f44336;
    font-size: 24px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.task-board {
    display: flex;
    flex-direction: row;
    justify-content: space-evenly;
    gap: 30px;
    margin: 0 auto;
    padding: 20px;
}

.task-board-left-section,
.task-board-right-section {
    flex: 1;
    width: 50%;
    display: flex;
    flex-direction: column;
}

.task-column {
    flex: 1;
    display: flex;
    flex-direction: column;
    padding: 20px;
    background-color: white;
}

.task-info-label {
    font-size: 36px;
    font-weight: bold;
    margin-bottom: 20px;
}

.task-description-group {
    display: flex;
    flex-direction: column;
}

.task-description-label {
    font-size: 24px;
    font-weight: bold;
}

.task-description {
    font-size: 24px;
    padding: 10px;
    border: none;
    border-radius: 10px;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.task-due-date-group {
    display: flex;
    flex-direction: column;
    margin-top: 20px;
}

.task-due-date-label {
    font-size: 24px;
    font-weight: bold;
}

.task-due-date {
    font-size: 24px;
    padding: 10px;
    border: none;
    border-radius: 10px;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.task-status-group {
    display: flex;
    flex-direction: column;
    margin-top: 20px;
}

.task-status-label {
    font-size: 24px;
    font-weight: bold;
}

.task-status {
    font-size: 24px;
    padding: 10px;
    border: none;
    border-radius: 10px;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.task-status.pending {
    background-color: #fadccc;
}

.task-status.in_progress {
    background-color: #d1f0c6;
}

.task-status.completed {
    background-color: #b5dff3;
}

.task-category-group {
    display: flex;
    flex-direction: column;
}

.task-category-label {
    font-size: 24px;
    font-weight: bold;
}

.task-category {
    font-size: 24px;
    padding: 10px;
    border: none;
    border-radius: 10px;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.task-assignee-group {
    display: flex;
    flex-direction: column;
    margin-top: 20px;
}

.task-assignee-label {
    font-size: 24px;
    font-weight: bold;
}

.task-assignee-list {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.task-assignee {
    font-size: 24px;
    padding: 10px;
    border: none;
    border-radius: 10px;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}
</style>