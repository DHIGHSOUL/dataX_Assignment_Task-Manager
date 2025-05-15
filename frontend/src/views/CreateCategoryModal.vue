<template>
    <div class="modal-overlay" @click.self="close">
        <div class="modal-content">
            <h1>カテゴリ作成</h1>
            <p class="create-label">作成するカテゴリ情報を入力してください。</p>
            <form>
                <div class="category-item-group">
                    <p class="create-label">カテゴリ名</p>
                    <input class="name-input" v-model="categoryName" placeholder="カテゴリ名" type="text" required />
                </div>
                <div class="category-item-group">
                    <p class="create-label">カテゴリのカラーコード</p>
                    <input class="color-input" v-model="categoryColor" placeholder="カテゴリの色" type="text" />
                </div>
                <button type="submit" class="create-button" @click="createCategory">作成</button>
                <button type="button" class="cancel-button" @click="close">キャンセル</button>
            </form>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import axios from '../plugins/axios'

const emit = defineEmits(['close'])

const categoryName = ref('')
const categoryColor = ref('')

const props = defineProps({
    workspaceID: {
        type: Number,
        required: true
    }
})

const createCategory = async () => {
    if (!categoryName.value.trim()) {
        alert('カテゴリ名を入力してください。')
        return
    }

    const hexColorPattern = /^#?[0-9A-Fa-f]{6}$/;
    if (categoryColor.value && !hexColorPattern.test(categoryColor.value.trim())) {
        alert('カラーコードは6桁の16進数で入力してください。例: #ff0000');
        return;
    }

    try {
        await axios.post(`/api/workspaces/${props.workspaceID}/workspace_categories`, {
            name: categoryName.value,
            color: categoryColor.value
        })
        alert('カテゴリを作成しました。')
        close()
    } catch (error) {
        alert('カテゴリの作成に失敗しました。')
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
    font-size: 48px;
    margin-bottom: 30px;
}

.create-label {
    font-size: 24px;
    margin-bottom: 20px;
}

form {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 30px;
}

.category-item-group {
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

.color-input {
    padding: 10px 10px;
    font-size: 24px;
    align-self: center;
    border: 1px solid black;
    border-radius: 4px;
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