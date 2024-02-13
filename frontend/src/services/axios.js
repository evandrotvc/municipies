import axios from 'axios';

const axiosInstance = axios.create({
  baseURL: 'http://localhost:3000',
  headers: {
    'content-type': 'application/json',
    accept: 'application/json'
  },
  responseType: 'json',
});

export default axiosInstance;