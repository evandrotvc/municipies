<script setup>
import { ref } from 'vue';
import { useI18n } from 'vue-i18n';
import { vMaska } from "maska";
import { Mask } from "maska";
import { watch } from 'vue';

const props = defineProps({
  value: {
    type: String,
    required: true,
    default: '',
  },
  type: {
    type: String,
    required: true,
    default: 'create',
    validator: (value) => {
      return ['create', 'update'].includes(value);
    },
  },
});

const { t } = useI18n();

const mask = new Mask({ mask: "##/##/####" });
const input = ref('');

const emit = defineEmits(['update:modelValue']);

function applyMask() {
  input.value = mask.masked(input.value);
  emit('update:modelValue', input.value);
}

watch(() => props.value, (value) => {
  if (value && props.type === 'update') {
    value = value.split('-').reverse().join('/');
    input.value = mask.masked(value);
  }
});
</script>
<template>
  <v-text-field
    v-model="input"
    :label="$t('fields.birthdate')"
    v-maska
    :data-maska="mask"
    :placeholder="t('placeholders.birthdate')"
    variant="outlined"
    @update:modelValue="applyMask">
  </v-text-field>
</template>

