import api from './axiosConfig';
import type { ActorListResponse, ActorFeelingResponse } from '../types/actors';

export const getActors = async (): Promise<ActorListResponse[]> => {
  const { data } = await api.get<ActorListResponse[]>('/actors');
  return data;
};

export const getActorFeeling = async (actorId: number): Promise<ActorFeelingResponse> => {
  const { data } = await api.get<ActorFeelingResponse>(`/actors/${actorId}/feeling`);
  return data;
};
