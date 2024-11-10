<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';

const counter = ref(0);
const data = ref("");
const jsdata = ref("");

async function loadData() {
  const resp = await axios.post("/api/data");
  data.value = resp.data;
  const jsresp = await axios.post("/jsapi/data");
  jsdata.value = jsresp.data;
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
  </div>
</template>
<style scoped>
.data {
  font-style: italic;
}
</style>