<script setup>
import { ref } from 'vue';
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';

// defineProps({
//   active: {
//     type: Boolean,
//     required: true,
//   },
// })

const active = ref(true);
const { t } = useI18n();

const label = computed(() => {
  return t(`placeholders.${active.value ? 'active' : 'inactive'}`);
});

const emit = defineEmits(['update:modelValue']);
const updateStatus = () => {
  const status = active.value ? 'active' : 'inactive';
  emit('update:modelValue', status);
}

</script>
<template>
  <v-switch
    v-model="active"
    hide-details
    inset
    color="blue"
    :label="label"
    @update:modelValue="updateStatus"
  ></v-switch>
</template>
