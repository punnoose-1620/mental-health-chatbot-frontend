import envConfig from '~/config/env'

export default ({ app }, inject) => {
  // Inject environment configuration into the app
  inject('env', envConfig)
} 