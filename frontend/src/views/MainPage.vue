<template>
    <div class="main-page">
        <h1>メインページ</h1>

        <form @submit.prevent="updateName">
            <input v-model="name" placeholder="変更する名前" type="text" required />
            <button type="submit">名前を変更</button>
        </form>

        <form @submit.prevent="updatePassword">
            <input v-model="password" placeholder="変更するパスワード" type="password" required />
            <input v-model="passwordConfirmation" placeholder="パスワード再入力" type="password" required />
            <button type="submit">パスワードを変更</button>
        </form>

        <button @click="logout">ログアウト</button>
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import axios from '../plugins/axios'
import { useRouter } from 'vue-router'

const router = useRouter()
const name = ref('')
const password = ref('')
const passwordConfirmation = ref('')

const token = localStorage.getItem('token')
axios.defaults.headers.common['Authorization'] = `Bearer ${token}`

const updateName = async () => {
    try {
        await axios.patch('/api/user/update_name', { user: { name: name.value }})
        if (window.confirm('名前が変更されました。')) {
            name.value = '';
        }
    } catch {
        window.alert('名前の変更に失敗しました。');
    }
}

const updatePassword = async () => {
    try {
        await axios.patch('/api/user/update_password', { user: { password: password.value, password_confirmation: passwordConfirmation.value }})
        if (window.confirm('パスワードが変更されました。')) {
            password.value = '';
            passwordConfirmation.value = '';
        }
    } catch {
        window.alert('パスワードの変更に失敗しました。');
    }
}

const logout = async () => {
    try {
        await axios.delete('/api/user/logout')
        localStorage.removeItem('token')
        if (window.confirm('ログアウトしました。')) {
            router.push('/login');
        }
    } catch {
        window.alert('ログアウトに失敗しました。');
    }
}
</script>