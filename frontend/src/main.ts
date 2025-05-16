import { createApp } from 'vue'

import App from './App.vue'
import router from './router'
import Multiselect from 'vue-multiselect'
import 'vue-multiselect/dist/vue-multiselect.css'

createApp(App).use(router).mount('#app')