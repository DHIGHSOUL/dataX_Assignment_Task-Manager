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
                        <textarea class="description-input" v-model="taskDescription" placeholder="タスクの説明(Option)" type="text" @input="autoResize" ref="descriptionRef" />
                    </div>
                    <div class="task-item-group">
                        <p class="update-label">タスクの期限</p>
                        <input class="due-date-input" v-model="dueDate" type="date" required />
                    </div>
                    <div class="task-item-group">
                        <p class="update-label">タスクの進行状況</p>
                        <Multiselect class="status-input" v-model="selectedStatus" :options="statusOptions" label="text" track-by="value" placeholder="タスクの進行状況を選択してください" />
                    </div>
                    <button type="button" class="update-button" @click="updateTask">更新</button>
                    <button type="button" class="cancel-button" @click="close">キャンセル</button>
                </form>
            </div>
            <div class="category-and-assignee-group">
                <form>
                    <div class="task-item-group">
                        <p class="update-label">タスクのカテゴリ</p>
                        <Multiselect v-model="selectedCategory" :options="categories" label="name" track-by="id" placeholder="カテゴリを選択してください" />
                    </div>
                    <div class="task-item-group-assignee">
                        <p class="update-label">タスクの担当者を選択してください。</p>
                        <Multiselect v-model="assignees" :options="users" :multiple="true" label="name" track-by="id" placeholder="担当者を選択してください" />
                        <ul>
                            <li v-for="assignee in assignees" :key="assignee.id">
                                {{ assignee.name }}
                            </li>
                        </ul>
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

const emit = defineEmits(['close', 'update'])
const taskName = ref('')
const taskDescription = ref('')
const dueDate = ref('')
const status = ref('')
const assignees = ref<{ id: number, name: string }[]>([])
const originalAssignees = ref<{ id: number, user_id: number, name: string }[]>([])
const taskAssignments = ref<{ id: number, user_id: number, name: string }[]>([])
const users = ref<{ id: number, name: string }[]>([])

const descriptionRef = ref<HTMLTextAreaElement | null>(null)

interface Category {
    id: number
    name: string
    color?: string
    workspace_id: number
    created_at: string
    updated_at: string
}

const statusOptions = [
    { value: 'pending', text: '待機' },
    { value: 'in_progress', text: '進行中' },
    { value: 'completed', text: '完了済み' }
]

const selectedStatus = ref<{ value: string, text: string } | null>(null)

const categories = ref<Category[]>([])
const selectedCategory = ref<Category | null>(null)

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
        const originalStatus = response.data.task.status
        status.value = originalStatus
        selectedStatus.value = statusOptions.find(s => s.value === originalStatus) ?? null
        const originalCategory = response.data.task.workspace_category
        if (originalCategory) {
            selectedCategory.value = categories.value.find(c => c.id === originalCategory.id) ?? null
        } else {
            selectedCategory.value = null
        }
    } catch (error) {
        console.error('タスク情報の取得に失敗しました。', error)
    }
}

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

const fetchOriginalAssignees = async () => {
    try {
        const response = await axios.get(`/api/tasks/${taskID}/task_assignments`)
        taskAssignments.value = response.data

        console.log('taskAssignments:', taskAssignments.value)

        originalAssignees.value = response.data.map((res: any) => ({
            user_id: res.user_id,
            name: res.name
        }))

        assignees.value = users.value.filter(user => {
            return originalAssignees.value.some(assignee => assignee.user_id === user.id)
        })
    } catch (error) {
        console.error('担当者の取得に失敗しました。', error)
    }
}

const autoResize = () => {
  if (descriptionRef.value) {
    descriptionRef.value.style.height = 'auto'
    descriptionRef.value.style.height = descriptionRef.value.scrollHeight + 'px'
  }
}

onMounted(async () => {
    await fetchCategories()
    await fetchUsers()
    await fetchOriginalTaskInfo()
    await fetchOriginalAssignees()
})

const updateTask = async () => {
    if (!taskName.value.trim()) {
        alert('タスク名を入力してください。')
        return
    }

    if (!status.value) {
        alert('タスクの進行状況を選択してください。')
        return
    }

    try {
        await axios.patch('/api/tasks/' + taskID, {
            task: {
                name: taskName.value,
                description: taskDescription.value,
                due_date: dueDate.value ? dueDate.value : null,
                status: selectedStatus.value?.value,
                workspace_category_id: selectedCategory.value?.id ?? null,
            }
        })

        await updateTaskAssignments()

        if(window.confirm('タスク情報を変更しました。') === true) {
            emit('update')
        }
    } catch (error) {
        console.error('タスク情報の変更に失敗しました。', error)
        alert('タスク情報の変更に失敗しました。')
    }
}

const updateTaskAssignments = async () => {
    const currentIDs = assignees.value.map(user => user.id)
    const originalIDs = originalAssignees.value.map(user => user.user_id)

    const toAddIDs = currentIDs.filter(id => !originalIDs.includes(id))
    const toRemoveIDs = originalIDs.filter(id => !currentIDs.includes(id))

    await Promise.all(toAddIDs.map(async id => {
        try {
            await axios.post(`/api/tasks/${taskID}/task_assignments`, {
                user_id: id
            })
        } catch (error) {
            console.error('担当者の追加に失敗しました。', error)
        }
    }))

    await Promise.all(toRemoveIDs.map(async id => {
        const assignment = taskAssignments.value.find(a => a.user_id === id)

        if (!assignment) return

        try {
            await axios.delete(`/api/tasks/${taskID}/task_assignments/${assignment.id}`)
        } catch (error) {

            console.error('担当者の削除に失敗しました。', error)
        }
    }))
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

.task-item-group-assignee {
    display: flex;
    width: 80%;
    flex-direction: column;
    align-items: center;
    margin-bottom: 30px;
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
    padding: 10px 10px;
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

.status-input {
    font-size: 24px;
    align-self: center;
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

.category-and-assignee-group {
    background-color: white;
    padding: 30px;
    width: 600px;
    text-align: center;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}
</style>