<template>
    <div class="modal-overlay" @click.self="close">
        <div class="modal-content-outside">
            <div class="modal-content">
                <h1>タスク作成</h1>
                <p>作成するタスクの情報を入力してください。</p>
                <form>
                    <div class="task-item-group">
                        <p class="create-label">タスク名</p>
                        <input class="name-input" v-model="taskName" placeholder="タスク名" type="text" required />
                    </div>
                    <div class="task-item-group">
                        <p class="create-label">タスクの説明</p>
                        <textarea class="description-input" v-model="taskDescription" placeholder="タスクの説明(Option)" type="text" @input="autoResize" ref="descriptionRef" />
                    </div>
                    <div class="task-item-group">
                        <p class="create-label">タスクの期限</p>
                        <input class="due-date-input" v-model="dueDate" type="date" required />
                    </div>
                    <button class="create-button" @click="createTask">作成</button>
                    <button class="cancel-button" @click="close">キャンセル</button>
            </form>
            </div>
            <div class="category-and-assignee-group">
                <form>
                    <div class="task-item-group">
                        <p class="create-label">タスクのカテゴリ</p>
                        <Multiselect v-model="selectedCategory" :options="categories" label="name" track-by="id" placeholder="カテゴリを選択してください" />
                    </div>
                    <div class="task-item-group">
                        <p class="create-label">タスクの担当者を選択してください。</p>
                        <Multiselect v-model="assignee" :options="users" label="name" track-by="id" placeholder="担当者を選択してください" />
                    </div>
                </form>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import axios from '../plugins/axios'
import Multiselect from 'vue-multiselect'
import 'vue-multiselect/dist/vue-multiselect.min.css'

const emit = defineEmits(['close'])

interface Category {
    id: number
    name: string
    color: string
    workspace_id: number
    created_at: string
    updated_at: string
}

const taskName = ref('')
const taskDescription = ref('')
const dueDate = ref('')
// const selectedCategory = ref('')
const assignee = ref('')
const users = ref<{ id: number, name: string }[]>([])

const descriptionRef = ref<HTMLTextAreaElement | null>(null)
const categories = ref<Category[]>([])
const selectedCategory = ref<Category | null>(null)

const props = defineProps({
    workspaceID: {
        type: Number,
        required: true
    }
})

const fetchUsers = async () => {
    try {
        const response = await axios.get(`/api/workspaces/${props.workspaceID}/users`)
        users.value = response.data
    } catch (error) {
        console.error('ユーザー情報の取得に失敗しました。', error)
    }
}

const fetchCategories = async () => {
    try {
        const response = await axios.get(`/api/workspaces/${props.workspaceID}/workspace_categories`)
        categories.value = response.data
    } catch (error) {
        console.error('カテゴリの取得に失敗しました。', error)
    }
}

const autoResize = () => {
  if (descriptionRef.value) {
    descriptionRef.value.style.height = 'auto'
    descriptionRef.value.style.height = descriptionRef.value.scrollHeight + 'px'
  }
}

onMounted(() => {
    fetchUsers()
    fetchCategories()
})

const createTask = async () => {
    if(!taskName.value.trim()) {
        alert('タスク名を入力してください。')
        return
    }

    try {
        await axios.post(`/api/workspaces/${props.workspaceID}/tasks`, {
            task: {
                name: taskName.value,
                description: taskDescription.value,
                due_date: dueDate.value ? dueDate.value : null,
                status: 'pending',
                workspace_category_id: selectedCategory.value ? selectedCategory.value.id : null,
            }
        })
        alert('タスクを作成しました。')
        emit('close')
    } catch (error) {
        alert('タスクの作成に失敗しました。')
    }
}

const close = () => {
    emit('close')
}
</script>

<style scoped>
::v-deep(.multiselect__placeholder) {
  font-size: 18px;
  color: #888;
}

::v-deep(.multiselect) {
  width: 100%;
  font-size: 24px;
}

::v-deep(.multiselect__input) {
  font-size: 24px;
}

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
}

.create-label {
    font-size: 24px;
    margin-bottom: 20px;
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
    width: 80%;
    min-height: 60px;
    font-size: 24px;
    padding: 20px 10px;
    align-self: center;
    border: 1px solid black;
    border-radius: 4px;
}

.due-date-input {
    padding: 10px 10px;
    font-size: 24px;
    align-self: center;
    border: 1px solid black;
    border-radius: 4px;
    margin-bottom: 20px;
}

.task-category {
    padding: 10px 10px;
    font-size: 24px;
    align-self: center;
    border: 1px solid black;
    border-radius: 4px;
}

.assignee-select {
    padding: 5px 5px;
    font-size: 24px;
    align-self: center;
    border: 1px solid black;
    border-radius: 4px;
    margin-bottom: 20px;
}

.create-button {
    padding: 10px 20px;
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
    padding: 10px 20px;
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