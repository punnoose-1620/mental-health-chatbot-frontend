export const state = () => ({
  backendStatus: 'checking', // 'checking', 'online', 'offline'
  backendPort: null, // The port that the backend is running on
  messages: [],
  isLoading: false
})

export const mutations = {
  SET_BACKEND_STATUS(state, status) {
    state.backendStatus = status
  },
  SET_BACKEND_PORT(state, port) {
    state.backendPort = port
  },
  ADD_MESSAGE(state, message) {
    state.messages.push(message)
  },
  SET_LOADING(state, isLoading) {
    state.isLoading = isLoading
  },
  CLEAR_MESSAGES(state) {
    state.messages = []
  }
}

export const actions = {
  async checkBackendStatus({ commit }) {
    commit('SET_BACKEND_STATUS', 'checking')
    try {
      const { isHealthy, port } = await this.$api.checkHealth()
      commit('SET_BACKEND_STATUS', isHealthy ? 'online' : 'offline')
      commit('SET_BACKEND_PORT', port)
      return isHealthy
    } catch (error) {
      commit('SET_BACKEND_STATUS', 'offline')
      commit('SET_BACKEND_PORT', null)
      return false
    }
  },
  
  async sendMessage({ commit, state }, messageText) {
    if (state.backendStatus !== 'online' || !state.backendPort) {
      return false
    }
    
    // Add user message
    const userMessage = {
      id: Date.now(),
      text: messageText,
      sender: 'user',
      timestamp: new Date().toISOString()
    }
    commit('ADD_MESSAGE', userMessage)
    
    // Generate response
    commit('SET_LOADING', true)
    try {
      const response = await this.$api.generateText(messageText, state.backendPort)
      
      // Add AI response
      if (response && response.success) {
        const aiMessage = {
          id: Date.now() + 1,
          text: response.generated_text,
          sender: 'ai',
          timestamp: new Date().toISOString()
        }
        commit('ADD_MESSAGE', aiMessage)
      } else {
        throw new Error('Failed to generate response')
      }
      
      commit('SET_LOADING', false)
      return true
    } catch (error) {
      console.error('Failed to send message:', error)
      
      // Add error message
      const errorMessage = {
        id: Date.now() + 1,
        text: 'Sorry, I encountered an error while generating a response.',
        sender: 'system',
        error: true,
        timestamp: new Date().toISOString()
      }
      commit('ADD_MESSAGE', errorMessage)
      
      commit('SET_LOADING', false)
      return false
    }
  }
}

export const getters = {
  isBackendOnline: state => state.backendStatus === 'online',
  isBackendOffline: state => state.backendStatus === 'offline',
  isCheckingBackend: state => state.backendStatus === 'checking',
  backendPort: state => state.backendPort
} 