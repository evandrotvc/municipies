<script setup>
import { ref, watch } from 'vue';
import { useI18n } from 'vue-i18n';
import { vMaska } from "maska";
import { Mask } from "maska";

const props = defineProps({
  value: {
    type: String,
    required: true,
    default: '',
  },
});

const { t } = useI18n();

const mask = new Mask({ mask: ["+## (##) ##### - ####", "+## (##) #### - ####"] });
const input = ref('');

const emit = defineEmits(['update:modelValue']);

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
    :label="$t('fields.phone')"
    v-maska
    :data-maska="mask"
    :placeholder="t('placeholders.phone')"
    variant="outlined"
    @update:modelValue="applyMask">
  </v-text-field>
</template>
