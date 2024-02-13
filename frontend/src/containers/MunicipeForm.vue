<script setup>
import { ref, onMounted } from 'vue';
import BaseInput from '@/components/BaseInput.vue';
import InputCNS from '@/components/InputCNS.vue';
import InputCPF from '@/components/InputCPF.vue';
import InputEmail from '@/components/InputEmail.vue';
import InputBirthdate from '@/components/InputBirthdate.vue';
import InputPhone from '@/components/InputPhone.vue';
import InputCEP from '@/components/InputCEP.vue';
import InputPhoto from '@/components/InputPhoto.vue';
import InputActive from '@/components/InputActive.vue';
import { fetchCEP, createMunicipe, getMunicipe, updateMunicipe } from '@/services';
import { useToast } from 'vue-toast-notification';
import 'vue-toast-notification/dist/theme-bootstrap.css';

import { useI18n } from 'vue-i18n';
import { useRouter, useRoute } from 'vue-router';

const { t } = useI18n();
const toast = useToast();
const router = useRouter();
const route = useRoute();

const user = ref({
  name: '',
  cpf: '',
  cns: '',
  email: '',
  phone: '',
  status: '',
  birth_date: '',
  status: 'active'
});

const photo = ref('');

const address = ref({
  zipcode: '',
  street: '',
  complement: '',
  neighborhood: '',
  number: '',
  city: '',
  ibge_code: '',
  uf: ''
});

const canUpdate = ref(false);

onMounted(async () => {
  if (route.params.id) {
    const { municipe } = await getMunicipe(route.params.id);
    user.value.name = municipe.name;
    user.value.cpf = municipe.cpf;
    user.value.cns = municipe.cns;
    user.value.email = municipe.email;
    user.value.phone = municipe.phone;
    photo.value = municipe.photo;
    user.value.status = municipe.status;
    user.value.birth_date = municipe.birth_date;
    address.value.zipcode = municipe.address.zipcode;
    address.value.street = municipe.address.street;
    address.value.complement = municipe.address.complement;
    address.value.neighborhood = municipe.address.neighborhood;
    address.value.number = municipe.address.number;
    address.value.city = municipe.address.city;
    address.value.ibge_code = municipe.address.ibge_code;
    address.value.uf = municipe.address.uf;
    
    canUpdate.value = true;
  }
});

const fillAddress = async (value) => {
  const data = await fetchCEP(value);
  address.value.zipcode = data.cep,
  address.value.street = data.logradouro,
  address.value.complement = data.complemento,
  address.value.neighborhood = data.bairro,
  address.value.city = data.localidade,
  address.value.ibge_code = data.ibge,
  address.value.uf = data.uf
}

async function submitForm() {
  const municipe = {
    ...user.value,
    address_attributes: { ...address.value}
  };
  try {
    if (canUpdate.value) {
      await updateMunicipe(route.params.id, {
        municipe,
        photo: {
          data: photo.value,
        },
      });
      toast.success(t('municipe.create.success'));
      return;
    } else {
      await createMunicipe({
        municipe,
        photo: {
          data: photo.value,
        },
      });
      toast.success(t('municipe.create.success'));
    }
  } catch (error) {
    console.error(error);
  }
}
</script>
<template>
  <v-sheet width="1060" class="mx-auto">
    <v-form ref="form">
      <v-container fluid>
        <v-btn
          class="my-5"
          variant="plain"
          @click="router.push('/')"
        >
          {{ $t('actions.back') }}
        </v-btn>
        <h2 class="mb-4">{{ $t('title.form') }}</h2>
        <v-divider class="border-opacity-75"></v-divider>
        <v-row>
          <v-col cols="12" sm="6" class="my-4">
            <InputPhoto
              :value="photo"
              @update:modelValue="photo = $event"
            />
          </v-col>
        </v-row>
        <v-row class="mt-4">
          <v-col
            cols="12"
            sm="12"
          >
          <BaseInput
            label="name"
            :value="user.name"
            @update:modelValue="user.name = $event"
          />
          </v-col>
        </v-row>
        <v-row>
          <v-col
            cols="12"
            sm="6"
          >
            <InputCPF
              :value="user.cpf"
              @update:modelValue="user.cpf = $event"
            />
          </v-col>
          <v-col>
            <InputCNS
              :value="user.cns"
              @update:modelValue="user.cns = $event"
            />
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" sm="6">
            <InputEmail
              :value="user.email"
              @update:modelValue="user.email = $event"
            />
          </v-col>
          <v-col cols="12" sm="6">
            <InputBirthdate
              :value="user.birth_date"
              :type="canUpdate ? 'update' : 'create'"
              @update:modelValue="user.birth_date = $event"
            />
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" sm="6">
            <InputPhone
              :value="user.phone"
              @update:modelValue="user.phone = $event"
            />
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" sm="6">
            <InputActive @update:modelValue="user.status = $event" />
          </v-col>
        </v-row>
        <h2 class="mb-4">{{ $t('fields.address') }}</h2>
        <v-divider class="border-opacity-75"></v-divider>
        <v-row class="mt-4">
          <v-col cols="4" md="4" lg="2" xl="2" xxl="2">
            <InputCEP
              :value="address?.zipcode"
              :type="canUpdate ? 'update' : 'create'"
              @fetch:cep="fillAddress"
            />
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" sm="10">
            <BaseInput
              :value="address?.street"
              label="street"
              @update:modelValue="address.street = $event"
            />
          </v-col>
          <v-col cols="12" sm="2">
            <BaseInput
              :value="address?.number"
              label="number"
              @update:modelValue="address.number = $event"
            />
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" sm="4">
            <BaseInput
              :value="address?.complement"
              label="complement"
              @update:modelValue="address.complement = $event"
            />
          </v-col>
          <v-col cols="12" sm="4">
            <BaseInput
              :value="address?.neighborhood"
              label="neighborhood"
              @update:modelValue="address.neighborhood = $event"
            />
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" sm="4">
            <BaseInput
              :value="address?.city"
              label="city"
              @update:modelValue="address.city = $event"
            />
          </v-col>
          <v-col cols="12" sm="2">
            <BaseInput
              :value="address?.uf"
              label="state"
              @update:modelValue="address.uf = $event"
            />
          </v-col>
          <v-col cols="12" sm="2">
            <BaseInput
              :value="address?.ibge_code"
              label="ibge"
              @update:modelValue="address.ibge_code = $event"
            />
          </v-col>
        </v-row>
        <v-btn
          variation="flat"
          color="#0055FF"
          @click="submitForm"
        >
          {{ $t('actions.save') }}
        </v-btn>
      </v-container>
    </v-form>
  </v-sheet>
</template>