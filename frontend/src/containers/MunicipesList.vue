<script setup>
import { ref, onMounted } from 'vue';
import { useI18n } from 'vue-i18n';
import { getMunicipes, searchMunicipe } from '@/services';
import { useRouter } from 'vue-router';

const { t } = useI18n();

const items = ref([]);
const router = useRouter();

onMounted(async () => {
  const { municipes } = await getMunicipes();
  items.value = municipes;
});

const searchItem = ref('');

async function search() {
  const { municipes } = await searchMunicipe(searchItem.value);
  items.value = municipes;
}

</script>
<template>
  <v-sheet width="1060" class="mx-auto mt-10">
    <h1>{{ $t('title.list') }}</h1>
    <v-btn
      class="mt-5"
      color="blue"
      @click="router.push('/municipes/create')"
    >
      {{ $t('actions.create') }}
    </v-btn>
    <v-row class="mt-5" justify="space-around" align="center">
      <v-sheet
        width="800">
        <v-combobox
          v-model="searchItem"
          cols="6"
          class="mt-5"
          :label="t('actions.search')"
          @keyup.enter="search"
        ></v-combobox>
      
      </v-sheet>
      <v-btn cols="4" color="blue" @click="search">
        {{ $t('actions.search') }}  
      </v-btn>
    </v-row>
    <v-card
      v-for="item in items"
      :key="item.id"
      class="mx-auto my-5"
      :title="item.name"
    >
    <v-card-actions>
      <v-row justify="space-between" align="center" class="px-2">
        <v-col>
          {{ t('municipe.cns', { cns: item.cns }) }}
        </v-col>
        <v-btn
          variation="flat"
          color="#0055FF"
          @click="router.push(`/municipes/${item.id}`)"
        >
          {{ $t('actions.edit') }}
        </v-btn>
      </v-row>
    </v-card-actions>
  </v-card>
  </v-sheet>
</template>