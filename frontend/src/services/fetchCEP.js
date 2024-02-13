import axios from './axios';

export const fetchCEP = async (cep) => {
  const { data } = await axios.get(`https://viacep.com.br/ws/${cep}/json/`);
  return data;
};
