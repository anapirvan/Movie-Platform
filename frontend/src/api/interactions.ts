import api from './axiosConfig';
import type {
  OptionResponse,
  OptionRequest,
  VoteRequest,
  VoteResponse,
  WatchRequest,
  WatchResponse,
} from '../types/interactions';

export const getOptions = async (): Promise<OptionResponse[]> => {
  const { data } = await api.get<OptionResponse[]>('/predefined-options');
  return data;
};

export const addOptionToMovie = async (
  filmId: number,
  optionRequest: OptionRequest
): Promise<void> => {
  await api.post(`/movies/${filmId}/options`, optionRequest);
};

export const removeOptionFromMovie = async (filmId: number, optionId: number): Promise<void> => {
  await api.delete(`/movies/${filmId}/options/${optionId}`);
};

export const postVote = async (voteRequest: VoteRequest): Promise<VoteResponse> => {
  const { data } = await api.post<VoteResponse>('/votes', voteRequest);
  return data;
};

export const updateVote = async (voteRequest: VoteRequest): Promise<void> => {
  await api.put('/votes', voteRequest);
};

export const postWatch = async (watchRequest: WatchRequest): Promise<WatchResponse> => {
  const { data } = await api.post<WatchResponse>('/watches', watchRequest);
  return data;
};
