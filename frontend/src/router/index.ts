import { createRouter, createWebHistory } from "vue-router"
import LoginPage from '../views/LoginPage.vue'
import SingUpPage from "../views/SingUpPage.vue"
import MainPage from "../views/MainPage.vue"

const routes = [
    {
        path: '/login',
        name: 'Login',
        component: LoginPage
    },
    {
        path: '/signup',
        name: 'SignUp',
        component: SingUpPage
    },
    {
        path: '/main',
        name: 'Main',
        component: MainPage
    },
    {
        path: '/workspace/:id',
        name: 'Workspace',
        component: () => import('../views/WorkspacePage.vue')
    },
    {
        path: '/',
        redirect: '/login'
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router