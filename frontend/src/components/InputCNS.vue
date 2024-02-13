<script setup>
import { ref, watch } from 'vue';
import { vMaska } from "maska";
import { Mask } from "maska";
import { useI18n } from 'vue-i18n';
import { charsEquals } from '@/utils/validators';

const { t } = useI18n();

const props = defineProps({
  value: {
    type: String,
    required: true,
    default: '',
  },
});

const mask = new Mask({ mask: "###############" });
const input = ref('');

const emit = defineEmits(['update:modelValue']);

const cnsRules = ref([
  (value) => !!value || t('validations.required'),
  (value) => charsEquals(value, 15) || t('validations.chars', { length: 15 }),
]);

function applyMask() {
  input.value = mask.masked(input.value);
  emit('update:modelValue', mask.unmasked(input.value));
}

watch(() => props.value, (value) => {
  input.value = mask.masked(value);
});
</script>
<template>
  <v-text-field
    v-model="input"
    v-maska
    :data-maska="mask"
    :label="t('fields.cns')"
    variant="outlined"
    counter="15"
    :rules="cnsRules"
    @update:modelValue="applyMask">
  </v-text-field>
</template>