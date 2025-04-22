<script setup lang="ts">
import TheWelcome from '../components/TheWelcome.vue'
</script>

<template>
  <main>
    <!-- <TheWelcome /> -->
     <div class="banner">
      <div class="left">
        <h2>Making Inventory</h2>
        <h2>Management</h2>
        <h2>Easy and Affordable</h2>
        <h3>Alpha Release Coming In March.</h3>
      </div>
      <div class="right">
        <img src="@/assets/blank_screen.png" alt="Phone Image" draggable="false">
      </div>
     </div>
  </main>
</template>

<style scoped>
.banner {
  display: flex;
}

.banner .left {
  padding-right: 2rem;
}

.banner h2 {
  font-weight: bold;
  font-size: 4rem;
  line-height: 5rem;
}
.banner h3 {
  background: linear-gradient(#FFFFFF, #FFD700);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  font-size: 2.2rem;
  font-weight: bold;
}

.banner img {
  height: 500px;
}
</style>
