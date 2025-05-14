<template>
    <div class="modal-overlay" @click.self="close">
        <div class="modal-content">
            <h1>ワークスペースに参加</h1>
            <p class="join-label">参加コードを入力してください。</p>
            <form>
                <input v-model="workspaceName" placeholder="参加コード" type="text" required />
                <button class="join-button" @click="createWorkspace">参加</button>
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

const createWorkspace = async () => {
    if(!workspaceName.value.trim()) {
        alert('有効なコードを入力してください。')
        return
    }

    try {
        await axios.post('/api/user_workspaces/join', {
            code: workspaceName.value
        })
        alert('ワークスペース参加に成功しました。')
        close()
        window.location.reload()
    } catch (error) {
        alert('ワークスペース参加に失敗しました。')
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
    width: 600px;
    text-align: center;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

h1 {
    margin-bottom: 30px;
    font-size: 48px;
}

.join-label {
    font-size: 24px;
    margin-bottom: 20px;
}

form {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 10px;
}

input {
    padding: 5px 5px;
    font-size: 24px;
    align-self: center;
    margin: 10px 0;
    border: 1px solid black;
    border-radius: 4px;
}

.join-button {
    padding: 5px 20px;
    font-size: 24px;
    color: black;
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