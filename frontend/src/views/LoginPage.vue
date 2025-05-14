<template>
    <div class="container">
        <div class="login-page">
            <h1>ログイン</h1>
            <form @submit.prevent="handleLogin">
                <input v-model="email" placeholder="メールアドレス" type="email" required autocomplete="off" />
                <input v-model="password" placeholder="パスワード" type="password" required autocomplete="off" />
                <button class="login-button" type="submit">ログイン</button>
            </form>
            <button class="goto-signuppage-button" @click="goToSingUpPage">アカウントをお持ちでない方はこちら</button>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import axios from '../plugins/axios';
import { useRouter } from 'vue-router';
import { onMounted, onUnmounted } from 'vue';

const router = useRouter();
const email = ref('');
const password = ref('');

onMounted(() => {
    history.pushState(null, '', location.href);
    window.addEventListener('popstate', preventBack);
})

onUnmounted(() => {
    window.removeEventListener('popstate', preventBack);
})

const preventBack = () => {
    history.pushState(null, '', location.href);
}

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
            router.push('/main')
        }
    } catch (err: any) {
        alert('メールやパスワードが間違っています。');
    }
};

const goToSingUpPage = () => {
    resetForm();
    router.push('/signup');
};
</script>

<style scoped>
.container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

.login-page {
    text-align: center;
    max-width: 400px;
    width: 100%;
    padding: 20px;
    box-sizing: border-box;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3), -2px -2px 25px rgba(0, 0, 0, 0.35);
    border-radius: 16px;
    background-color: white;
}

.login-page h1 {
    margin-bottom: 30px;
}

form {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

input {
    align-self: center;
    width: 60%;
    padding: 10px;
    font-size: 16px;
    border-radius: 6px;
    border-width: 1px;
}

.login-button {
    margin-top: 20px;
    padding: 5px;
    width: 40%;
    align-self: center;
    font-size: 14px;
    background-color: white;
    border-radius: 6px;
    border-width: 0px;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3)
}

.goto-signuppage-button {
    margin-top: 20px;
    background: none;
    border: none;
    color: #007bff;
    text-decoration: underline;
    cursor: pointer;
    font-size: 14px;
}
</style>