<template>
    <div class="modal-overlay" @click.self="close">
        <div class="modal-content">
            <h2>名前変更</h2>
            <p>変更する名前を入力してください。</p>
            <div class="change-name-group">
                <input class="name-input" v-model="name" placeholder="名前" type="text" required />
                <button class="change-button" @click="changeName">更新</button>
                <button class="cancel-button" @click="close">キャンセル</button>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
    import { ref } from 'vue'
    import axios from '../plugins/axios'

    const emit = defineEmits(['close', 'update'])
    const name = ref('')

    const changeName = async () => {
        if (!name.value.trim()) {
            alert('名前を入力してください。')
            return
        }

        try {
            await axios.patch('/api/user/update_name', {
                user: {
                    name: name.value
                }
            })
            alert('名前を変更しました。')
            emit('update')
        } catch (error) {
            alert('名前の変更に失敗しました。')
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

    .change-name-group {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 20px;
    }

    .name-input {
        padding: 5px 5px;
        font-size: 16px;
        align-self: center;
        border: 1px solid black;
        border-radius: 4px;
    }

    .change-button {
        padding: 5px 20px;
        color: white;
        background-color: #007bff;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3)
    }

    .cancel-button {
        padding: 5px 20px;
        color: white;
        background-color: gray;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3)
    }
</style>