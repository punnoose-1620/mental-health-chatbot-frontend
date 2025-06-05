<template>
  <div class="app-container">
    <header class="app-header">
      <div class="container">
        <h1 class="app-title">LLM Chat Application</h1>
      </div>
    </header>
    
    <main class="app-main">
      <div class="container">
        <Nuxt />
      </div>
    </main>
    
    <footer class="app-footer">
      <div class="container">
        <p>© {{ new Date().getFullYear() }} AI Ethics Project</p>
      </div>
    </footer>
  </div>
</template>

<script>
export default {
  name: 'DefaultLayout'
}
</script>

<style>
html, body {
  margin: 0;
  padding: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen,
    Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
  background-color: #f5f5f5;
  color: #333;
}

.app-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.container {
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.app-header {
  background-color: #2563EB;
  color: white;
  padding: 1rem 0;
}

.app-title {
  font-size: 1.5rem;
  font-weight: bold;
  margin: 0;
}

.app-main {
  flex-grow: 1;
  padding: 2rem 0;
}

.app-footer {
  background-color: #e5e5e5;
  padding: 1rem 0;
  text-align: center;
  font-size: 0.875rem;
  color: #666;
}
</style> 