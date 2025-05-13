<template>
    <div class="workspace-header">
        <h1>{{ workspaceName }}</h1>
        <button class="return-button" @click="goBack">戻る</button>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from '../plugins/axios'

const route = useRoute()
const router = useRouter()

const workspaceID = Number(route.params.id)
const workspaceName = ref('')

const fetchWorkspaceName = async () => {
    try {
        const response = await axios.get(`/api/workspaces/${workspaceID}`)
        workspaceName.value = response.data.name
    } catch (error) {
        console.error('ワークスペース名の取得に失敗しました。', error)
    }
}

onMounted(() => {
    fetchWorkspaceName()
})

const goBack = () => {
    router.push('/main')
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

.return-button {
    padding: 5px 20px;
    color: white;
    background-color: #007bff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3)
}
</style>