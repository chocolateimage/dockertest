<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import NewPost from './components/NewPost.vue';

const counter = ref(0);
const data = ref("");
const jsdata = ref("");
const posts = ref(null);

async function loadData() {
  const resp = await axios.post("/api/data");
  data.value = resp.data;
  const jsresp = await axios.post("/jsapi/data");
  jsdata.value = jsresp.data;

  const postsResp = await axios.post("/api/posts/list");
  posts.value = postsResp.data.posts;
}

function newPost(post) {
  posts.value.splice(0, 0, post);
}

onMounted(() => {
  loadData();
})

</script>
<template>
  <div>
    <h1>This is Vue with pnpm (and nginx in prod) inside Docker with Compose</h1>
    <h4>And this is a counter: <a href="#" @click="counter++">{{ counter }}</a> because every example has one.</h4>
    <hr>
    <h4>With an API (just using Python + Flask): <span class="data">{{ data }}</span></h4>
    <h4>With an API (just using pnpm + nodemon + express): <span class="data">{{ jsdata }}</span></h4>
    <hr>
    <h4>Dev: <code>docker compose up --watch --build</code> (watch is Docker's development thing)</h4>
    <h4>Prod: <code>docker compose -f compose.yml -f compose-production.yml up --build</code></h4>
    <p>Build is needed when changing between dev and prod because Docker forgets that it has been changed.</p>
    <NewPost @newPost="newPost" />
    <div v-if="posts != null && posts.length > 0" class="posts">
      <div v-for="post in posts" :key="post.id" class="post">
        <span class="author">{{ post.name }}:</span>
        <span class="content">{{ post.content }}</span>
      </div>
    </div>
    <div v-else-if="posts != null">No posts</div>
    <p v-else>Loading posts...</p>
  </div>
</template>
<style scoped>
.data {
  font-style: italic;
}

.posts {
  display: flex;
  flex-direction: column;
  max-width: 500px;
}

.post {
  display: flex;
  flex-direction: column;

  padding: 4px 8px;
  border-radius: 2px;
  background-color: #2c2c2c;
  margin-block: 2px;
}

.author {
  font-weight: bold;
}

.content {
  white-space: pre-wrap;
}
</style>