<template>
    <div class="modal-overlay" @click.self="close">
        <div class="modal-content">
            <h2>ワークスペース作成</h2>
            <p>作成するワークスペース名を入力してください。</p>
            <form>
                <input class="name-input" v-model="workspaceName" placeholder="ワークスペース名" type="text" required />
                <textarea class="description-input" v-model="workspaceDescription" placeholder="ワークスペースの説明(Option)" type="text" required />
                <button class="create-button" @click="createWorkspace">作成</button>
                <button class="cancel-button" @click="close">キャンセル</button>
            </form>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import axios from '../plugins/axios'

const emit = defineEmits(['close'])
const workspaceName = ref('')
const workspaceDescription = ref('')

const createWorkspace = async () => {
    if(!workspaceName.value.trim()) {
        alert('ワークスペース名を入力してください。')
        return
    }

    try {
        await axios.post('/api/workspaces', {
            workspace: {
                name: workspaceName.value,
                description: workspaceDescription.value
            }
        })
        alert('ワークスペースを作成しました。')
        close()
        window.location.reload()
    } catch (error) {
        alert('ワークスペースの作成に失敗しました。')
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

.modal-content {
    background-color: white;
    padding: 30px;
    width: 300px;
    text-align: center;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

form {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 10px;
}

.name-input {
    padding: 5px 5px;
    font-size: 16px;
    align-self: center;
    border: 1px solid black;
    border-radius: 4px;
}

.description-input {
    width: 80%;
    min-height: 60px;
    font-size: 16px;
    margin: 10px 0;
    padding: 5px;
    align-self: center;
    border: 1px solid black;
    border-radius: 4px;
}

.create-button {
    padding: 5px 20px;
    color: black;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3)
}

.cancel-button {
    padding: 5px 20px;
    color: white;
    background-color: #f44336;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3)
}
</style>