<template>
  <div class="page-container">
    <div class="chat-container">
      <div class="chat-header">Mood Manager 5000</div>
      
      <div class="chat-box" ref="messagesContainer">
        <!-- Empty state -->
        <div v-if="messages.length === 0" class="empty-state">
          <div class="empty-icon">💬</div>
          <h3 class="empty-title">Start a conversation</h3>
          <p class="empty-subtitle">Send a message to begin chatting with your mental health assistant</p>
        </div>
        
        <!-- Messages -->
        <div v-else class="messages-list">
          <div 
            v-for="(message, index) in messages" 
            :key="message.id"
            :class="['message', message.sender === 'user' ? 'user-message' : 'bot-message']"
          >
            {{ message.text }}
          </div>
          
          <!-- Typing indicator -->
          <div v-if="isLoading" class="message bot-message typing-indicator">
            <div class="typing-animation">
              <div class="typing-dot"></div>
              <div class="typing-dot"></div>
              <div class="typing-dot"></div>
            </div>
          </div>
        </div>
      </div>
      
      <div class="chat-input">
        <input 
          type="text" 
          v-model="messageText" 
          ref="messageInput"
          placeholder="Type a message..."
          :disabled="isLoading"
          @keydown.enter.exact.prevent="sendMessage"
        >
        <button 
          @click="sendMessage"
          :disabled="isLoading || !messageText.trim()"
        >Send</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ChatPage',
  data() {
    return {
      messageText: ''
    }
  },
  computed: {
    messages() {
      return this.$store.state.messages.map(msg => ({
        ...msg,
        timestamp: msg.timestamp || new Date()
      }))
    },
    isLoading() {
      return this.$store.state.isLoading
    },
    isBackendOnline() {
      return this.$store.getters.isBackendOnline
    }
  },
  methods: {
    async sendMessage() {
      if (!this.messageText.trim() || this.isLoading) return
      
      const message = this.messageText
      this.messageText = ''
      
      await this.$store.dispatch('sendMessage', message)
    },
    formatTime(timestamp) {
      if (!timestamp) return ''
      const date = new Date(timestamp)
      return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    },
    scrollToBottom() {
      this.$nextTick(() => {
        if (this.$refs.messagesContainer) {
          this.$refs.messagesContainer.scrollTop = this.$refs.messagesContainer.scrollHeight
        }
      })
    }
  },
  async mounted() {
    // Check if backend is online, redirect to index if not
    if (!this.isBackendOnline) {
      const isOnline = await this.$store.dispatch('checkBackendStatus')
      if (!isOnline) {
        this.$router.push('/')
      }
    }
    
    // Focus on input
    this.$nextTick(() => {
      if (this.$refs.messageInput) {
        this.$refs.messageInput.focus()
      }
    })
  },
  updated() {
    this.scrollToBottom()
  }
}
</script> 

<style scoped>
.page-container {
  font-family: Arial, sans-serif;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background-image: url("../assets/bg.jpg");
  background-repeat: no-repeat;
  background-position: center;
  background-size: cover;
}

.chat-container {
  width: 350px;
  background: white;
  border-radius: 10px;
  box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.chat-header {
  background: #007bff;
  color: white;
  padding: 10px;
  text-align: center;
  font-size: 18px;
  font-weight: bold;
}

.chat-box {
  height: 400px;
  overflow-y: auto;
  padding: 10px;
  display: flex;
  flex-direction: column;
}

.message {
  max-width: 80%;
  padding: 10px;
  border-radius: 5px;
  margin-bottom: 10px;
}

.user-message {
  background: #007bff;
  color: white;
  align-self: flex-end;
}

.bot-message {
  background: #e9ecef;
  color: black;
  align-self: flex-start;
}

.chat-input {
  display: flex;
  padding: 10px;
  background: #fff;
  border-top: 1px solid #ddd;
}

.chat-input input {
  flex: 1;
  padding: 10px;
  border: none;
  border-radius: 5px;
  outline: none;
  font-size: 16px;
}

.chat-input button {
  background: #007bff;
  color: white;
  border: none;
  padding: 10px 15px;
  margin-left: 5px;
  border-radius: 5px;
  cursor: pointer;
  font-size: 16px;
}

.chat-input button:hover {
  background: #0056b3;
}

.chat-input button:disabled {
  background: #cccccc;
  cursor: not-allowed;
}

.empty-state {
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 2rem;
}

.empty-icon {
  font-size: 4rem;
  margin-bottom: 1rem;
  opacity: 0.5;
}

.empty-title {
  font-size: 1.5rem;
  font-weight: bold;
  color: #374151;
  margin-bottom: 0.5rem;
}

.empty-subtitle {
  color: #6b7280;
  max-width: 20rem;
}

.typing-indicator {
  padding: 10px;
}

.typing-animation {
  display: flex;
  gap: 0.25rem;
}

.typing-dot {
  width: 0.5rem;
  height: 0.5rem;
  background-color: #9ca3af;
  border-radius: 50%;
  animation: typing 1.4s infinite ease-in-out;
}

.typing-dot:nth-child(2) {
  animation-delay: 0.2s;
}

.typing-dot:nth-child(3) {
  animation-delay: 0.4s;
}

@keyframes typing {
  0%, 60%, 100% {
    transform: translateY(0);
  }
  30% {
    transform: translateY(-0.625rem);
  }
}

/* Scrollbar styling */
.chat-box::-webkit-scrollbar {
  width: 6px;
}

.chat-box::-webkit-scrollbar-track {
  background: transparent;
}

.chat-box::-webkit-scrollbar-thumb {
  background: rgba(0, 0, 0, 0.2);
  border-radius: 3px;
}

.chat-box::-webkit-scrollbar-thumb:hover {
  background: rgba(0, 0, 0, 0.3);
}
</style> 