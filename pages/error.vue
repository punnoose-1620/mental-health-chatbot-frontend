<template>
  <div class="max-w-md mx-auto text-center py-8">
    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-6 rounded-lg mb-8">
      <h2 class="text-2xl font-bold mb-4">Backend Unavailable</h2>
      <div class="mb-6">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 mx-auto text-red-500 mb-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <p class="text-lg mb-2">Connection to the Backend Server Failed</p>
        <p>Please make sure the backend server is running and accessible.</p>
      </div>
      
      <div class="bg-white p-4 rounded-lg text-left mb-6">
        <h3 class="font-bold mb-2">Troubleshooting Steps:</h3>
        <ul class="list-disc pl-5 space-y-1">
          <li>Verify the backend Flask server is running</li>
          <li>Check that the server is running on the correct port (default: 5000)</li>
          <li>Ensure there are no firewall or network issues</li>
          <li>Check backend logs for any error messages</li>
        </ul>
      </div>
    </div>
    
    <div class="flex justify-center space-x-4">
      <button 
        @click="retryConnection" 
        class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
        :disabled="checking"
      >
        <span v-if="checking">Checking...</span>
        <span v-else>Retry Connection</span>
      </button>
      
      <nuxt-link 
        to="/" 
        class="bg-gray-200 text-gray-700 px-4 py-2 rounded-lg hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-gray-500"
      >
        Back to Home
      </nuxt-link>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ErrorPage',
  data() {
    return {
      checking: false
    }
  },
  methods: {
    async retryConnection() {
      this.checking = true
      const isOnline = await this.$store.dispatch('checkBackendStatus')
      this.checking = false
      
      if (isOnline) {
        this.$router.push('/chat')
      }
    }
  },
  async mounted() {
    // Check if we should be on this page
    if (this.$store.getters.isBackendOnline) {
      this.$router.push('/chat')
    }
  }
}
</script> 