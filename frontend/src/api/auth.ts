import api from './axiosConfig';
import type { LoginRequest } from '../types/auth';

export const login = async (loginRequest: LoginRequest): Promise<void> => {
  await api.post('/auth/login', loginRequest);
};

export const logout = async (): Promise<void> => {
  await api.post('/auth/logout');
};
