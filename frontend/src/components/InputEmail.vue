<script setup>
import { ref, watch } from 'vue';
import { email, required } from '@/utils/validators';
import { useI18n } from 'vue-i18n';

const props = defineProps({
  value: {
    type: String,
    required: true,
    default: '',
  },
});

const { t } = useI18n();
const emailRules = ref([
  (value) => required(value) || t('validations.required'),
  (value) => email(value) || t('validations.email'),
]);

const input = ref('');

watch(() => props.value, (value) => {
  input.value = value;
});
</script>
<template>
  <v-text-field
    v-model="input"
    :label="$t('fields.email')"
    :placeholder="$t('placeholders.email')"
    type="email"
    :rules="emailRules"
    variant="outlined"
    @update:modelValue="$emit('update:modelValue', email)">
  </v-text-field>
</template>

