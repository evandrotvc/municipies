import { createRouter, createWebHistory } from 'vue-router';

const routes = [
  {
    path: '/',
    component: () => import('@/containers/MunicipesList.vue')
  },
  {
    path: '/municipes/create',
    component: () => import('@/containers/MunicipeForm.vue')
  },
  {
    path: '/municipes/:id',
    component: () => import('@/containers/MunicipeForm.vue'),
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;

