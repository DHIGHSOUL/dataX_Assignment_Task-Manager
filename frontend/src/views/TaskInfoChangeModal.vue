<template>
    <div class="modal-overlay" @click.self="close">
        <div class="modal-content-outside">
            <div class="modal-content">
                <h1>タスク情報変更</h1>
                <p>変更する情報を入力してください。</p>
                <form>
                    <div class="task-item-group">
                        <p class="update-label">タスク名</p>
                        <input class="name-input" v-model="taskName" placeholder="タスク名" type="text" required />
                    </div>
                    <div class="task-item-group">
                        <p class="update-label">タスクの説明</p>
                        <textarea class="description-input" v-model="taskDescription" placeholder="タスクの説明(Option)" type="text" />
                    </div>
                    <div class="task-item-group">
                        <p class="update-label">タスクの期限</p>
                        <input class="due-date-input" v-model="dueDate" type="date" required />
                    </div>
                    <button class="update-button" @click="updateTask">作成</button>
                    <button class="cancel-button" @click="close">キャンセル</button>
                </form>
            </div>
            <div class="category-and-assignee-group">
                <p class="create-label">タスクの担当者を選択してください。</p>
                <select class="assignee-select" v-model="assignee">
                    <option disabled value="">担当者を選択</option>
                    <option v-for="user in users" :key="user.id" :value="user.id">{{ user.name }}</option>
                </select>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import axios from '../plugins/axios'
import { onMounted } from 'vue'

const emit = defineEmits(['close', 'update'])
const taskName = ref('')
const taskDescription = ref('')
const dueDate = ref('')
const assignee = ref('')
const users = ref<{ id: number, name: string }[]>([])

const props = defineProps({
    taskID: {
        type: Number,
        required: true
    },
    workspaceID: {
        type: Number,
        required: true
    }
})

const taskID = props.taskID

const fetchOriginalTaskInfo = async () => {
    try {
        const response = await axios.get('/api/tasks/' + taskID)
        taskName.value = response.data.task.name
        taskDescription.value = response.data.task.description
        dueDate.value = response.data.task.due_date?.slice(0, 10) || ''
    } catch (error) {
        console.error('タスク情報の取得に失敗しました。', error)
    }
}

const fetchUsers = async () => {
    try {
        console.log('workspaceID:', props.workspaceID)
        const response = await axios.get(`/api/workspaces/${props.workspaceID}/users`)
        users.value = response.data
    } catch (error) {
        console.error('ユーザー情報の取得に失敗しました。', error)
    }
}

onMounted(() => {
    fetchOriginalTaskInfo()
    fetchUsers()
})

const updateTask = async () => {
    if (!taskName.value.trim()) {
        alert('タスク名を入力してください。')
        return
    }

    try {
        await axios.patch('/api/tasks/' + taskID, {
            task: {
                name: taskName.value,
                description: taskDescription.value,
                due_date: dueDate.value,
                status: 'pending'
            }
        })
        alert('タスク情報を変更しました。')
        emit('update')
    } catch (error) {
        console.error('タスク情報の変更に失敗しました。', error)
        alert('タスク情報の変更に失敗しました。')
    }
}

const close = () => {
    emit('close')
}
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

.modal-content-outside {
    display: flex;
    flex-direction: row;
    align-items: center;
    gap: 20px;
}

.modal-content {
    background-color: white;
    padding: 30px;
    width: 600px;
    text-align: center;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.category-and-assignee-group {
    background-color: white;
    padding: 30px;
    width: 600px;
    text-align: center;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

h1 {
    font-size: 48px;
}

p {
    font-size: 24px;
    margin-bottom: 20px;
}

.update-label {
    font-size: 24px;
    margin-bottom: 20px;
    font-weight: bold;
}

form {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 10px;
}

.task-item-group {
    display: flex;
    width: 80%;
    flex-direction: column;
    align-items: center;
}

.name-input {
    padding: 10px 10px;
    font-size: 24px;
    align-self: center;
    border: 1px solid black;
    border-radius: 4px;
}

.description-input {
    width: 100%;
    min-height: 60px;
    font-size: 24px;
    padding: 20px 10px;
    align-self: center;
    border: 1px solid black;
    border-radius: 4px;
}

.due-date-input {
    padding: 5px 5px;
    font-size: 24px;
    align-self: center;
    border: 1px solid black;
    border-radius: 4px;
    margin-bottom: 20px;
}

.update-button {
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