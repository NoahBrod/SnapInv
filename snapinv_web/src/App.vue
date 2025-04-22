<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
import HelloWorld from './components/HelloWorld.vue'
</script>

<template>
  <header>
    <!-- <img alt="Vue logo" class="logo" src="@/assets/logo.svg" width="125" height="125" /> -->

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
  width: 100%;
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
  text-align: center;
  padding: 1rem 0;
  font-size: 1.15rem;
}

nav a.router-link-exact-active {
  color: white;
  text-decoration: underline;
  /* font-size: 1rem; */
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
