<script setup lang="ts">
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
        <div class="subtext">
          <ul class="features">
            <li>Simple, one-time payment</li>
            <li>No subscriptions or hidden fees</li>
            <li>Lifetime access to updates</li>
          </ul>
          <a href="#">Join Waitlist</a>
        </div>
      </div>
      <div class="right">
        <img src="@/assets/blank_screen.png" alt="Phone Image" draggable="false">
      </div>
     </div>
  </main>
</template>

<style scoped>
.banner {
  padding-top: 2rem;
  display: flex;
  justify-content: space-between;
  color: white;
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

.subtext {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.subtext ul {
  margin: 2rem 0 0 0;
  font-size: 1.25rem;
  list-style: none;
}

.subtext li {
  margin: 0;
  font-weight: bold;
  /* text-align: center; */
}

.subtext a {
  margin-top: 2rem;
  padding: 0.5rem 0.75rem;
  color: white;
  font-size: 1.2rem;
  font-weight: 600;
  border: 3px solid white;
  border-radius: 10px;
}

.banner img {
  height: 500px;
  filter: drop-shadow(0 0.5rem 1rem rgba(0, 0, 0, 0.623));
}

@media (max-width: 1024px) {
  .banner {
    display: flex;
    flex-direction: column;
  }

  .banner .left {
    padding-right: 0;
  }

  .banner h3 {
    font-size: clamp(1.25rem, 3vw, 2.2rem);
  }

  .banner h2 {
    font-size: clamp(2.25rem, 5vw, 5rem);
    line-height: clamp(2.75rem, 5vw, 5rem);
  }

  .banner .right {
    padding: 2rem 0;
    display: flex;
    justify-content: center;
  }
}
</style>
