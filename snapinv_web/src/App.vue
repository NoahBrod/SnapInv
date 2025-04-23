<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
import HelloWorld from './components/HelloWorld.vue'
</script>

<template>
  <header>
    <div class="wrapper">
      <h1>SnapInv</h1>
      <nav>
        <RouterLink to="/">Home</RouterLink>
        <RouterLink to="/pricing">Pricing</RouterLink>
        <RouterLink to="/about">About</RouterLink>
      </nav>
    </div>
  </header>

  <RouterView />
</template>

<style scoped>
header {
  line-height: 1.5;
  padding-top: 2rem;
  display: flex;
  justify-content: center;
}

h1 {
  font-weight: 500;
  font-size: 2.7rem;
  text-align: center;
  color: white;
  text-decoration: underline;
}

nav {
  font-size: 12px;
  padding: 1rem 0;
  font-size: 1.15rem;
}

nav a.router-link-exact-active {
  color: white;
  text-decoration: underline;
}

nav a:hover {
  text-decoration: underline;
}

nav a.router-link-exact-active:hover {
  background-color: transparent;
}

nav a {
  display: inline-block;
  padding: 0 1rem;
  color: white;
  font-weight: 500;
}
</style>
