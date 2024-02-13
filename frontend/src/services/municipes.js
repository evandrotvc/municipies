import axios from './axios';

export const createMunicipe = async (data) => {
  await axios.post('/municipes', data);
};

export const getMunicipes = async () => {
  const response = await axios.get('/municipes');
  return response.data;
}

export const getMunicipe = async (id) => {
  const response = await axios.get(`/municipes/${id}`);
  return response.data;
};

export const updateMunicipe = async (id, data) => {
  const response = await axios.put(`/municipes/${id}`, data);
  return response.data;
};

export const searchMunicipe = async (data = '') => {
  if (!data) data = '';
  const response = await axios.get(`/municipes?query=${data}`);
  return response.data;
}