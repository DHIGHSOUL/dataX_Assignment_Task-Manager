import { createRouter, createWebHistory } from "vue-router"
import LoginPage from '../views/Auth/LoginPage.vue'
import SingUpPage from "../views/Auth/SingUpPage.vue"
import MainPage from "../views/Main/MainPage.vue"
import WorkspacePage from "../views/Workspace/WorkspacePage.vue"
import MyPage from "../views/Main/MyPage.vue"
import WorkspaceSettingPage from "../views/Workspace/WorkspaceSettingPage.vue"
import TaskPage from "../views/Task/TaskPage.vue"
import CategorySettingPage from "../views/Category/CategorySettingPage.vue"

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
        path: '/task/:id',
        name: 'TaskPage',
        component: TaskPage,
        meta: { requiresAuth: true }
    },
    {
        path: '/workspace/:id/categories',
        name: 'CategorySettingPage',
        component: CategorySettingPage,
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