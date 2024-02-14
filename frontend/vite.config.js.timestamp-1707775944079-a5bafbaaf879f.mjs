// vite.config.js
import { defineConfig } from "vite";
import vue from "vue";
import path from "path";
export default defineConfig({
  plugins: [vue()],
  css: {
    modules: {
      generateScopedName: "[local]_[hash:base64:5]"
    }
  },
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "src")
    }
  }
});

