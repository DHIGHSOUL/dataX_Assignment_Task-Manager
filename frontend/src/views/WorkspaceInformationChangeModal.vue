<template>
    <div class="modal-overlay" @click.self="close">
        <div class="modal-content">
            <h2>ワークスペース名変更</h2>
            <p>変更する情報を入力してください。</p>
            <div class="change-name-group">
                <input class="name-input" v-model="workspaceName" placeholder="ワークスペース名" type="text" required />
                <textarea class="description-input" v-model="workspaceDescription" placeholder="ワークスペースの説明(Option)" type="text" />
                <button type="submit" class="change-button" @click="changeWorkspaceInformation">更新</button>
                <button type="button" class="cancel-button" @click="close">キャンセル</button>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
    import { ref } from 'vue'
    import axios from '../plugins/axios'
    import { onMounted } from 'vue'

    const emit = defineEmits(['close', 'update'])
    const workspaceName = ref('')
    const workspaceDescription = ref('')
    const props = defineProps({
        workspaceID: {
            type: Number,
            required: true
        }
    })

    const workspaceID = props.workspaceID

    const fetchOriginalWorkspaceInfo = async () => {
        try {
            const response = await axios.get('/api/workspaces/' + workspaceID)
            workspaceName.value = response.data.name
            workspaceDescription.value = response.data.description
        } catch (error) {
            console.error('ワークスペース情報の取得に失敗しました。', error)
        }
    }

    onMounted(() => {
        fetchOriginalWorkspaceInfo()
    })

    const changeWorkspaceInformation = async () => {
        if (!workspaceName.value.trim()) {
            alert('ワークスペース名を入力してください。')
            return
        }

        try {
            await axios.patch('/api/workspaces/' + workspaceID, {
                workspace: {
                    name: workspaceName.value,
                    description: workspaceDescription.value
                }
            })
            alert('ワークスペース情報を変更しました。')
            emit('update')
        } catch (error) {
            alert('ワークスペース情報の変更に失敗しました。')
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