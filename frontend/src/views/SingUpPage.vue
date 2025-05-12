<template>
    <div class="signup-page">
        <h1>サインアップ</h1>
        <form @submit.prevent="handleSignup">
            <input v-model="name" placeholder="名前" type="text" required autocomplete="off" />
            <input v-model="email" placeholder="メールアドレス" type="email" required autocomplete="off" />
            <input v-model="password" placeholder="パスワード" type="password" required autocomplete="off" />
            <input v-model="passwordConfirmation" placeholder="パスワード再入力" type="password" required autocomplete="off" />
            <button type="submit">登録</button>
        </form>
        <p>
            すでにアカウントをお持ちの方は
            <button type="button" @click="ReturnToLogin">戻る</button>
        </p>
    </div>
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
.signup-page {
    max-width: 400px;
    margin: 0 auto;
    padding: 20px;
}
</style>