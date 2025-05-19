<template lang="pug">
  .modal-overlay(@click.self="close")
    .modal-content-outside
      .modal-content
        h1 タスク作成
        p 作成するタスクの情報を入力してください。
        form
          .task-item-group
            p.create-label タスク名
            input.name-input(type="text" v-model="taskName" placeholder="タスク名" required)
          .task-item-group
            p.create-label タスクの説明
            textarea.description-input(type="text" v-model="taskDescription" placeholder="タスクの説明(Option)" @input="autoResize" ref="descriptionRef")
          .task-item-group
            p.create-label タスクの期限
            input.due-date-input(type="date" v-model="dueDate" required)
          button.create-button(type="button" @click="createTask") 作成
          button.cancel-button(type="button" @click="close") キャンセル
      .category-and-assignee-group
        form
          .task-item-group
            p.create-label タスクのカテゴリ
            Multiselect(v-model="selectedCategory" :options="categories" label="name" track-by="id" placeholder="カテゴリを選択してください")
          .task-item-group-assignee
            p.create-label タスクの担当者を選択してください。
            Multiselect(v-model="assignee" :options="users" :multiple="true" label="name" track-by="id" placeholder="担当者を選択してください")
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from "vue";
import axios from "../../plugins/axios";
import Multiselect from "vue-multiselect";
import "vue-multiselect/dist/vue-multiselect.min.css";

const emit = defineEmits(["close", "update"]);

interface Category {
  id: number;
  name: string;
  color: string;
  workspace_id: number;
  created_at: string;
  updated_at: string;
}

const taskName = ref("");
const taskDescription = ref("");
const dueDate = ref("");
// const selectedCategory = ref('')
const assignee = ref<{ id: number; name: string }[]>([]);
const users = ref<{ id: number; name: string; email: string }[]>([]);

const descriptionRef = ref<HTMLTextAreaElement | null>(null);
const categories = ref<Category[]>([]);
const selectedCategory = ref<Category | null>(null);

const props = defineProps({
  workspaceID: {
    type: Number,
    required: true,
  },
});

const fetchUsers = async () => {
  try {
    const response = await axios.get(
      `/api/workspaces/${props.workspaceID}/users`
    );
    users.value = response.data;
  } catch (error) {
    console.error("ユーザー情報の取得に失敗しました。", error);
  }
};

const fetchCategories = async () => {
  try {
    const response = await axios.get(
      `/api/workspaces/${props.workspaceID}/workspace_categories`
    );
    categories.value = response.data;
  } catch (error) {
    console.error("カテゴリの取得に失敗しました。", error);
  }
};

const autoResize = () => {
  if (descriptionRef.value) {
    descriptionRef.value.style.height = "auto";
    descriptionRef.value.style.height =
      descriptionRef.value.scrollHeight + "px";
  }
};

onMounted(async () => {
  await fetchCategories();
  await fetchUsers();
});

const createTask = async () => {
  if (!taskName.value.trim()) {
    alert("タスク名を入力してください。");
    return;
  }

  try {
    const taskResponse = await axios.post(
      `/api/workspaces/${props.workspaceID}/tasks`,
      {
        task: {
          name: taskName.value,
          description: taskDescription.value,
          due_date: dueDate.value ? dueDate.value : null,
          status: "pending",
          workspace_category_id: selectedCategory.value
            ? selectedCategory.value.id
            : null,
        },
      }
    );

    addAssignments(taskResponse.data.task.id);
  } catch (error) {
    alert("タスクの作成に失敗しました。");
  }
};

const addAssignments = async (taskID: number) => {
  try {
    if (assignee.value.length > 0) {
      await Promise.all(
        assignee.value.map(async (user) => {
          await axios.post(`/api/tasks/${taskID}/task_assignments`, {
            user_id: user.id,
          });
        })
      );
    }
    alert("タスクを作成しました。");
    emit("update");
  } catch (error) {
    alert("タスクの担当者の割り当てに失敗しました。");
  }
};

const close = () => {
  emit("close");
};
</script>

<style scoped>
::v-deep(.multiselect__placeholder) {
  font-size: 18px;
  color: #888;
}

::v-deep(.multiselect) {
  width: 100%;
  font-size: 24px;
}

::v-deep(.multiselect__input) {
  font-size: 24px;
}

.modal-overlay {
  position: fixed;
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background-color: rgba(0, 0, 0, 0.5);
}

.modal-content-outside {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 20px;
}

.modal-content {
  background-color: white;
  padding: 30px;
  width: 600px;
  text-align: center;
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.category-and-assignee-group {
  background-color: white;
  padding: 30px;
  width: 600px;
  text-align: center;
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

h1 {
  font-size: 48px;
}

p {
  font-size: 24px;
}

.create-label {
  font-size: 24px;
  margin-bottom: 20px;
  font-weight: bold;
}

form {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
}

.task-item-group {
  display: flex;
  width: 80%;
  flex-direction: column;
  align-items: center;
}

.task-item-group-assignee {
  display: flex;
  width: 80%;
  flex-direction: column;
  align-items: center;
  margin-bottom: 30px;
}

.name-input {
  padding: 10px 10px;
  font-size: 24px;
  align-self: center;
  border: 1px solid black;
  border-radius: 4px;
}

.description-input {
  width: 100%;
  min-height: 60px;
  font-size: 24px;
  padding: 10px 10px;
  align-self: center;
  border: 1px solid black;
  border-radius: 4px;
}

.due-date-input {
  padding: 10px 10px;
  font-size: 24px;
  align-self: center;
  border: 1px solid black;
  border-radius: 4px;
  margin-bottom: 20px;
}

.task-category {
  padding: 10px 10px;
  font-size: 24px;
  align-self: center;
  border: 1px solid black;
  border-radius: 4px;
}

.assignee-select {
  padding: 5px 5px;
  font-size: 24px;
  align-self: center;
  border: 1px solid black;
  border-radius: 4px;
  margin-bottom: 20px;
}

.create-button {
  padding: 10px 20px;
  font-size: 24px;
  color: white;
  background-color: #007bff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
  margin-bottom: 10px;
}

.cancel-button {
  padding: 10px 20px;
  font-size: 24px;
  color: white;
  background-color: gray;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
  margin-bottom: 30px;
}
</style>
