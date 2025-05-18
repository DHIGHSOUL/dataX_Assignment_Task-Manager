<template>
    <div class="category-setting-header">
        <form class="left-menu-bar">
            <h1>カテゴリ設定</h1>
            <button class="return-button" @click="goBack">戻る</button>
        </form>
    </div>
    <div class="category-setting-body">
        <div class="category-list">
            <h2>カテゴリ一覧</h2>
            <div class="category-list-container">
                <div class="category-item-dummy" @click="showCreateModal = true">
                    <div class="category-name-dummy">+</div>
                </div>
                <div class="category-card-item" :style="getCategoryStyle(category.color)" v-for="category in categories" :key="category.id" @click="openChangeModal(category.id)">
                    <div class="category-card-item-content">{{ category.name }}</div>
                </div>
            </div>
        </div>
    </div>
    <CreateCategoryModal v-if="showCreateModal" :workspaceID="workspaceID" @close="showCreateModal = false" />
    <CategoryChangeModal v-if="showChangeModal && categoryID !== null" :workspaceID="workspaceID" :categoryID="categoryID" @close="showChangeModal = false" @update="fetchCategories" />
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from '../plugins/axios'
import CreateCategoryModal from './CreateCategoryModal.vue'
import CategoryChangeModal from './CategoryChangeModal.vue'

interface Category {
    id: number
    name: string
    color: string
    workspace_id: number
    created_at: string
    updated_at: string
}

const router = useRouter()
const route = useRoute()

const workspaceID = Number(route.params.id)
const categoryID = ref<number | null>(null)

const showCreateModal = ref(false)
const showChangeModal = ref(false)

const categories = ref<Category[]>([])

const fetchCategories = async () => {
    try {
        const response = await axios.get(`/api/workspaces/${workspaceID}/workspace_categories`)
        categories.value = response.data
    } catch (error) {
        console.error('カテゴリの取得に失敗しました。', error)
    }
}

onMounted(() => {
    fetchCategories()
})

const openChangeModal = (id: number) => {
    categoryID.value = id
    showChangeModal.value = true
}

const goBack = () => {
    router.push('/workspace/' + workspaceID)
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
</script>

<style scoped>
.category-setting-header {
    padding: 0px 20px;
    display: flex;
    flex-direction: space-between;
    align-items: center;
    margin: 0 auto;
}

.left-menu-bar {
    display: flex;
    flex-direction: row;
    gap: 30px;
}

h1 {
    font-size: 48px;
    font-weight: bold;
}

.category-setting-body {
    flex: 1;
    display: flex;
    flex-direction: column;
    padding: 0 20px;
}

h2 {
    font-size: 36px;
    font-weight: bold;
}

.category-list {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.category-list-container {
    display: flex;
    flex-wrap: wrap;
    gap: 40px;
    justify-content: flex-start;
}

.category-card-item {
    background-color: white;
    border-radius: 16px;
    border-width: 0px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
    padding: 50px 0px;
    font-size: 24px;
    font-weight: bold;
    flex: 1 1 300px;
    max-width: 380px;
    text-align: center;
    display: flex;
    align-items: center;
    justify-content: center;
}

.category-card-item-content {
    font-size: 24px;
    font-weight: bold;
    padding: 0px 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100%;
}

.category-item-dummy {
    background-color: white;
    border-radius: 16px;
    border-width: 0px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
    padding: 50px 0px;
    font-size: 24px;
    font-weight: bold;
    flex: 1 1 300px;
    max-width: 380px;
    text-align: center;
}

.category-name-dummy {
    font-size: 100x;
    font-weight: bold;
    padding: 0px 40px;
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
</style>