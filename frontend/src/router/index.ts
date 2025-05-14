import { createRouter, createWebHistory } from "vue-router"
import LoginPage from '../views/LoginPage.vue'
import SingUpPage from "../views/SingUpPage.vue"
import MainPage from "../views/MainPage.vue"
import WorkspacePage from "../views/WorkspacePage.vue"
import MyPage from "../views/MyPage.vue"
import WorkspaceSettingPage from "../views/WorkspaceSettingPage.vue"

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
        component: MainPage,
        meta: { requiresAuth: true }
    },
    {
        path: '/workspace/:id',
        name: 'Workspace',
        component: WorkspacePage,
        meta: { requiresAuth: true }
    },
    {
        path:'/workspace/:id/setting',
        name: 'WorkspaceSettingPage',
        component: WorkspaceSettingPage,
        meta: { requiresAuth: true }
    },
    {
        path: '/mypage',
        name: 'MyPage',
        component: MyPage,
        meta: { requiresAuth: true }
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

router.beforeEach((to, from, next) => {
    const token = localStorage.getItem('token')

    if (to.meta.requiresAuth && !token) {
        next({ name: 'Login' })
    } else {
        next()
    }
})

export default router