<script setup>
import { ref } from 'vue';
import { vMaska } from "maska";
import { Mask } from "maska";
import { watch } from 'vue';

const props = defineProps({
  value: {
    type: String,
    default: ''
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

const mask = new Mask({ mask: "#####-###" });
const input = ref('');

const emit = defineEmits(['fetch:cep']);

function updateCEP() {
  if (input.value.length === 9) {
    emit('fetch:cep', mask.unmasked(input.value));
  }
  applyMask();
}

function applyMask() {
  input.value = mask.masked(input.value);
}

watch(() => props.value, (value) => {
  if (value && props.type === 'update') {
    input.value = value;
  }
});

</script>
<template>
  <v-text-field
    v-model="input"
    v-maska
    :data-maska="mask"
    :label="$t('fields.zipcode')"
    variant="outlined"
    @update:modelValue="updateCEP"
  >
  </v-text-field>
</template>