<script setup>
import axios from "axios";
import { ref } from "vue"

const emit = defineEmits(["newPost"]);

const name = ref("");
const content = ref("");

const sending = ref(false);

async function send() {
    sending.value = true;

    const resp = await axios.post("/api/posts/add", {
        name: name.value,
        content: content.value
    });

    emit("newPost", resp.data);

    sending.value = false;
    name.value = "";
    content.value = "";
}
</script>
<template>
    <div class="new-post">
        <input v-model="name" placeholder="Name">
        <textarea v-model="content" placeholder="Entry" rows="3"></textarea>
        <button @click="send" class="post-button" :disabled="sending">Post</button>
    </div>
</template>
<style scoped>
.new-post {
    display: flex;
    flex-direction: column;

    max-width: 500px;

    margin-block: 8px;
}

.post-button {
    align-self: end;
}
</style>