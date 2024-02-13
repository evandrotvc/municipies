<script setup>
const props = defineProps({
  value: {
    type: String,
    default: ''
  }
});

const emit = defineEmits(['update:modelValue']);

const toBase64 = (file) => new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => resolve(reader.result);
    reader.onerror = reject;
});

async function uploadPhoto(file) {
  let base64file = await toBase64(file);
  base64file = base64file.replace(/^data:image\/[a-z]+;base64,/, "");
  emit('update:modelValue', base64file);
}
</script>
<template>
  <v-avatar
    size="150"
    rounded="0"
  >
    <v-img
      :src="`data:image/png;base64,${value}`"
    ></v-img>
  </v-avatar>
  <v-btn
    class="mt-4 ml-4"
    color="primary"
    @click="$refs.fileInput.click()">
    {{ $t('actions.upload') }}
  </v-btn>
  <input
    @change="uploadPhoto($event.target.files[0])"
    ref="fileInput"
    type="file"
    hidden accept="image/png, image/jpeg, image/bmp"
  />
</template>
