<template>
    <div class="container">
        <div class="signup-page">
            <h1>サインアップ</h1>
            <form @submit.prevent="handleSignup">
                <input v-model="name" placeholder="名前" type="text" required autocomplete="off" />
                <input v-model="email" placeholder="メールアドレス" type="email" required autocomplete="off" />
                <input v-model="password" placeholder="パスワード" type="password" required autocomplete="off" />
                <input v-model="passwordConfirmation" placeholder="パスワード再入力" type="password" required autocomplete="off" />
                <button class="signup-button" type="submit">登録</button>
            </form>
            <button class="backto-button" type="button" @click="ReturnToLogin">ログイン画面に戻る</button>
        </div>
    </div>"
</template>

<script setup lang="ts">
import { ref } from 'vue';
import axios from '../plugins/axios';
import { useRouter } from 'vue-router';

const router = useRouter();
const name = ref('');
const email = ref('');
const password = ref('');
const passwordConfirmation = ref('');

const resetForm = () => {
    name.value = '';
    email.value = '';
    password.value = '';
    passwordConfirmation.value = '';
};

const handleSignup = async () => {
    try {
        const response = await axios.post('/api/user/signup', {
            user: {
                name: name.value,
                email: email.value,
                password: password.value,
                password_confirmation: passwordConfirmation.value
            }
        });

        const token = response.data.token
        localStorage.setItem('token', token)

        if(window.confirm('登録成功しました！')) {
            router.push('/login');
        }
    } catch (err: any) {
        alert('登録に失敗しました。');
    }
};

const ReturnToLogin = () => {
    resetForm();
    router.push('/login');
};
</script>

<style scoped>
.container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

.signup-page {
    text-align: center;
    max-width: 600px;
    width: 100%;
    padding: 20px;
    box-sizing: border-box;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3), -2px -2px 25px rgba(0, 0, 0, 0.35);
    border-radius: 16px;
    background-color: white;
}

.signup-page h1 {
    margin-bottom: 30px;
    font-size: 48px;
}

form {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

input {
    align-self: center;
    width: 60%;
    padding: 10px;
    font-size: 16px;
    border-radius: 6px;
    border-width: 1px;
    font-size: 24px;
}

.signup-button {
    margin-top: 20px;
    padding: 5px;
    width: 40%;
    align-self: center;
    font-size: 14px;
    background-color: white;
    border-radius: 6px;
    border-width: 0px;
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
    font-size: 24px;
}

.backto-button {
    margin-top: 20px;
    background: none;
    border: none;
    color: #007bff;
    text-decoration: underline;
    cursor: pointer;
    font-size: 24px;
    margin-bottom: 30px;
}
</style>