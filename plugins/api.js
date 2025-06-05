import axios from 'axios'
import envConfig from '~/config/env'

export default ({ app }, inject) => {
  // Create axios instance with dynamic baseURL
  const createApi = (port) => {
    return axios.create({
      baseURL: `http://localhost:${port}`,
      timeout: envConfig.apiTimeout
    })
  }

  // Health check function that tries both ports
  const checkHealth = async () => {
    // Try port 5000 first
    try {
      const api5000 = createApi(5000)
      const response = await api5000.get('/health')
      if (response.data.status === 'healthy') {
        return { isHealthy: true, port: 5000 }
      }
    } catch (error) {
      console.log('Port 5000 not available, trying 5050...')
    }

    // Try port 5050 if 5000 fails
    try {
      const api5050 = createApi(5050)
      const response = await api5050.get('/health')
      if (response.data.status === 'healthy') {
        return { isHealthy: true, port: 5050 }
      }
    } catch (error) {
      console.error('Both ports failed:', error)
    }

    return { isHealthy: false, port: null }
  }

  // Generate text function with dynamic port
  const generateText = async (prompt, port, maxLength = envConfig.defaultMaxLength, temperature = envConfig.defaultTemperature) => {
    try {
      const api = createApi(port)
      const response = await api.post('/generate', {
        prompt,
        max_length: maxLength,
        temperature
      })
      return response.data
    } catch (error) {
      console.error('Text generation failed:', error)
      throw error
    }
  }

  // Inject API functions into context
  inject('api', {
    checkHealth,
    generateText
  })
} 