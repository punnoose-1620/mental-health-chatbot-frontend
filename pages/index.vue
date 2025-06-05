<template>
  <div class="welcome-screen">
    <div class="welcome-content">
      <h1 class="welcome-title">Welcome to LLM Chat</h1>
      <p class="welcome-description">A conversational AI chatbot powered by Flask and NuxtJS</p>
    </div>
    
    <div v-if="isCheckingBackend" class="status-box loading">
      <div class="spinner"></div>
      <p class="status-text">Connecting to the backend server...</p>
    </div>
    
    <div v-else-if="isBackendOnline" class="status-box success">
      <p class="status-title">Backend server is online!</p>
      <p class="status-text">Redirecting to chat...</p>
    </div>
    
    <div v-else class="status-box error">
      <p class="status-title">Backend server is offline</p>
      <p class="status-text">Redirecting to error page...</p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'LoadingPage',
  computed: {
    isCheckingBackend() {
      return this.$store.getters.isCheckingBackend
    },
    isBackendOnline() {
      return this.$store.getters.isBackendOnline
    },
    isBackendOffline() {
      return this.$store.getters.isBackendOffline
    }
  },
  async mounted() {
    // Check backend status
    await this.$store.dispatch('checkBackendStatus')
    
    // Redirect based on backend status
    setTimeout(() => {
      if (this.$store.getters.isBackendOnline) {
        this.$router.push('/chat')
      } else if (this.$store.getters.isBackendOffline) {
        this.$router.push('/error')
      }
    }, 2000) // Short delay for better UX
  }
}
</script>

<style scoped>
.welcome-screen {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 70vh;
  text-align: center;
}

.welcome-content {
  margin-bottom: 2rem;
}

.welcome-title {
  font-size: 2rem;
  font-weight: bold;
  margin-bottom: 1rem;
}

.welcome-description {
  font-size: 1.2rem;
  color: #666;
  margin-bottom: 2rem;
}

.status-box {
  padding: 2rem;
  border-radius: 8px;
  max-width: 400px;
  margin: 0 auto;
}

.status-box.loading {
  background-color: #f0f9ff;
  border: 1px solid #bae6fd;
  color: #0369a1;
}

.status-box.success {
  background-color: #f0fdf4;
  border: 1px solid #bbf7d0;
  color: #16a34a;
}

.status-box.error {
  background-color: #fef2f2;
  border: 1px solid #fecaca;
  color: #dc2626;
}

.status-title {
  font-size: 1.2rem;
  font-weight: bold;
  margin-bottom: 0.5rem;
}

.status-text {
  font-size: 1rem;
}

.spinner {
  display: inline-block;
  width: 3rem;
  height: 3rem;
  border-radius: 50%;
  border: 3px solid #bae6fd;
  border-top-color: #0369a1;
  animation: spin 1s linear infinite;
  margin-bottom: 1rem;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
</style> 