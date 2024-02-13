import { createApp } from 'vue';
import './style.css';
import App from './App.vue';

// Vuetify
import 'vuetify/styles';
import { createVuetify } from 'vuetify';
import * as components from 'vuetify/components';
import * as directives from 'vuetify/directives';
import router from './router';

// i18n
import { createI18n } from 'vue-i18n';
import { messages } from '@/locales';

const vuetify = createVuetify({
  components,
  directives,
  defaultTheme: 'light'
});

export const i18n = createI18n({
  legacy: false,
  globalInjection: true,
  fallbackLocale: 'ptBR',
  locale: 'ptBR',
  messages,
});

createApp(App)
  .use(vuetify)
  .use(i18n)
  .use(router)
  .mount('#app')