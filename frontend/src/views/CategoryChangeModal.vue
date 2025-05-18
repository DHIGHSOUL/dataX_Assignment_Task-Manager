<template lang="pug">
  .modal-overlay(@click.self="close")
    .modal-content
      h1 カテゴリ変更
      p.update-label 変更するカテゴリ情報を入力してください。
      form
        .category-item-group
          p.update-label カテゴリ名
          input.name-input(v-model="categoryName" placeholder="カテゴリ名" type="text" required)
        .category-item-group
          p.update-label カテゴリのカラーコード
          input.color-input(v-model="categoryColor" placeholder="カテゴリの色" type="text")
        .category-change-button-group
          button.update-button(type="button" @click="updateCategory") 変更
          button.delete-button(type="button" @click="deleteCategory") 削除
        button.cancel-button(type="button" @click="close") キャンセル
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import axios from "../plugins/axios";

const emit = defineEmits(["close", "update"]);

const categoryName = ref("");
const categoryColor = ref("");

const props = defineProps({
  workspaceID: {
    type: Number,
    required: true,
  },
  categoryID: {
    type: Number,
    required: true,
  },
});

const fecthOriginalCategoryInfo = async () => {
  try {
    const response = await axios.get(
      `/api/workspace_categories/${props.categoryID}`
    );
    categoryName.value = response.data.name;
    categoryColor.value = response.data.color;
  } catch (error) {
    console.error("カテゴリ情報の取得に失敗しました。", error);
  }
};

onMounted(async () => {
  await fecthOriginalCategoryInfo();
});

const updateCategory = async () => {
  if (!categoryName.value.trim()) {
    alert("カテゴリ名を入力してください。");
    return;
  }

  const hexColorPattern = /^#?[0-9A-Fa-f]{6}$/;
  if (
    categoryColor.value &&
    !hexColorPattern.test(categoryColor.value.trim())
  ) {
    alert("カラーコードは6桁の16進数で入力してください。例: #ff0000");
    return;
  }

  try {
    await axios.patch(`/api/workspace_categories/${props.categoryID}`, {
      name: categoryName.value,
      color: categoryColor.value,
    });
    alert("カテゴリを変更しました。");
    emit("update");
    close();
  } catch (error) {
    alert("カテゴリの変更に失敗しました。");
  }
};

const deleteCategory = async () => {
  if (confirm("本当にこのカテゴリを削除しますか？")) {
    try {
      await axios.delete(`/api/workspace_categories/${props.categoryID}`);
      alert("カテゴリを削除しました。");
      emit("update");
      close();
    } catch (error) {
      alert("カテゴリの削除に失敗しました。");
    }
  }
};

const close = () => {
  emit("close");
};
</script>

<style scoped>
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

.modal-content {
  background-color: white;
  padding: 30px;
  width: 600px;
  text-align: center;
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

h1 {
  font-size: 48px;
  margin-bottom: 30px;
}

.update-label {
  font-size: 24px;
  margin-bottom: 20px;
}

form {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 30px;
}

.category-item-group {
  display: flex;
  width: 80%;
  flex-direction: column;
  align-items: center;
}

.name-input {
  padding: 10px 10px;
  font-size: 24px;
  align-self: center;
  border: 1px solid black;
  border-radius: 4px;
}

.color-input {
  padding: 10px 10px;
  font-size: 24px;
  align-self: center;
  border: 1px solid black;
  border-radius: 4px;
}

.category-change-button-group {
  display: flex;
  flex-direction: column;
  gap: 50px;
}

.update-button {
  padding: 10px 20px;
  font-size: 24px;
  color: white;
  background-color: #007bff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
}

.delete-button {
  padding: 10px 20px;
  color: white;
  font-size: 24px;
  background-color: #f44336;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
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
