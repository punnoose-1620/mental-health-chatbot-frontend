import envConfig from './config/env'

export default {
  // Target: https://go.nuxtjs.dev/config-target
  target: 'static',

  // Global page headers: https://go.nuxtjs.dev/config-head
  head: {
    title: envConfig.appName,
    htmlAttrs: {
      lang: 'en'
    },
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: envConfig.appDescription },
      { name: 'theme-color', content: envConfig.themeColor }
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/assets/favicon.ico' }
    ]
  },

  // Global CSS: https://go.nuxtjs.dev/config-css
  css: [
  ],

  // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
  plugins: [
    '~/plugins/api.js',
    '~/plugins/env.js'
  ],

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: true,

  // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
  buildModules: [
  ],

  // Modules: https://go.nuxtjs.dev/config-modules
  modules: [
    '@nuxtjs/dotenv'
  ],

  // Build Configuration: https://go.nuxtjs.dev/config-build
  build: {
  },

  // Environment variables
  env: {
    baseUrl: envConfig.baseUrl,
    defaultMaxLength: envConfig.defaultMaxLength,
    defaultTemperature: envConfig.defaultTemperature,
    appName: envConfig.appName,
    appDescription: envConfig.appDescription,
    themeColor: envConfig.themeColor,
    apiTimeout: envConfig.apiTimeout,
    retryAttempts: envConfig.retryAttempts
  }
} 