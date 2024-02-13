
<script setup>
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';

const { t } = useI18n();

const props = defineProps({
  label: {
    type: String,
    default: 'name'
  },
  variant: {
    type: String,
    default: 'outlined'
  },
  value: {
    type: String,
    default: ''
  },
});

const emit = defineEmits(['update:modelValue']);

const input = computed({
  get: () => props.value,
  set: (value) => {
    emit('update:modelValue', value);
  }
});

</script>
<template>
  <v-text-field
    v-model="input"
    :label="t(`fields.${label}`)"
    variant="outlined"
  >
  </v-text-field>
</template>