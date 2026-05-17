import api from './axiosConfig';
import type {
  ClientResponse,
  ClientProfileResponse,
} from '../types/clients';
import type { RecommandationResponse } from '../types/movies';

export const getClients = async (): Promise<ClientResponse[]> => {
  const { data } = await api.get<ClientResponse[]>('/clients');
  return data;
};

export const getClientProfile = async (): Promise<ClientProfileResponse> => {
  const { data } = await api.get<ClientProfileResponse>('/clients/profile');
  return data;
};

export const getClientRecommandations = async (): Promise<RecommandationResponse[]> => {
  const { data } = await api.get<RecommandationResponse[]>('/clients/recommandations');
  return data;
};
