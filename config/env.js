/**
 * Environment variables configuration
 * This file can be used as a reference for environment variables
 * Create an actual .env file based on these variables
 */

export default {
  // Backend API Configuration
  baseUrl: process.env.BASE_URL || 'http://localhost:5000',
  
  // Chat Configuration
  defaultMaxLength: parseInt(process.env.DEFAULT_MAX_LENGTH || '150', 10),
  defaultTemperature: parseFloat(process.env.DEFAULT_TEMPERATURE || '0.7'),
  
  // UI Configuration
  appName: process.env.APP_NAME || 'LLM Chat Application',
  appDescription: process.env.APP_DESCRIPTION || 'A conversational AI chatbot powered by Flask and NuxtJS',
  themeColor: process.env.THEME_COLOR || '#2563EB',
  
  // API Request Configuration
  apiTimeout: parseInt(process.env.API_TIMEOUT || '10000', 10),
  retryAttempts: parseInt(process.env.RETRY_ATTEMPTS || '3', 10)
} 