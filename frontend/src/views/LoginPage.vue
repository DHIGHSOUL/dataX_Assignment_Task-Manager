<template>
    <div class="login-page">
        <h1>ログイン</h1>
        <form @submit.prevent="handleLogin">
            <input v-model="email" placeholder="メールアドレス" type="email" required autocomplete="off" />
            <input v-model="password" placeholder="パスワード" type="password" required autocomplete="off" />
            <button type="submit">ログイン</button>
        </form>
        <p>
            アカウントをお持ちでない方は
            <button @click="goToSingUpPage">こちら</button>
        </p>
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import axios from '../plugins/axios';
import { useRouter } from 'vue-router';

const router = useRouter();
const email = ref('');
const password = ref('');

const resetForm = () => {
    email.value = '';
    password.value = '';
};

const handleLogin = async () => {
    try {
        const response = await axios.post('/api/user/login', {
            user: {
                email: email.value,
                password: password.value
            }
        });

        const token = response.data.token
        localStorage.setItem('token', token)

        if(window.confirm('ログイン成功しました！')) {
            router.push('/main');
        }
    } catch (err: any) {
        alert('ログインに失敗しました。');
    }
};

const goToSingUpPage = () => {
    resetForm();
    router.push('/signup');
};
</script>

<style scoped>
.login-container {
    max-width: 400px;
    margin: 0 auto;
    padding: 20px;
}
</style>