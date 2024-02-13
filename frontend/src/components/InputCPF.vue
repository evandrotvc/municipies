<script setup>
import { ref, watch } from 'vue';
import { vMaska } from "maska";
import { Mask } from "maska";
import { cpf } from '@/utils/validators';
import { useI18n } from 'vue-i18n';

const props = defineProps({
  value: {
    type: String,
    required: true,
    default: '',
  },
});

const { t } = useI18n();
const mask = new Mask({ mask: "###.###.###-##" });
const input = ref('');

const emit = defineEmits(['update:modelValue']);

function applyMask() {
  input.value = mask.masked(input.value);
  emit('update:modelValue', mask.unmasked(input.value));
}

function validateCpf(value) {
  return cpf(value) || t('validations.cpf');
}

const cpfRules = ref([
  (value) => !!value || t('validations.required'),
  (value) => validateCpf(value),
]);

watch(() => props.value, (value) => {
  input.value = mask.masked(value);
});

</script>
<template>
  <v-text-field
    v-model="input"
    :label="$t('fields.cpf')"
    :placeholder="$t('placeholders.cpf')"
    v-maska
    :data-maska="mask"
    :rules="cpfRules"
    variant="outlined"
    @update:modelValue="applyMask">
  </v-text-field>
</template>
