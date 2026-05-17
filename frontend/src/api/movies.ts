import api from './axiosConfig';
import type {
  MovieResponse,
  MovieDetailResponse,
  MovieFeelingResponse,
  RecommandationResponse,
  FeelingSourceResponse,
} from '../types/movies';
import type { OptionResponse, OptionRequest } from '../types/interactions';

export const getMovies = async (): Promise<MovieResponse[]> => {
  const { data } = await api.get<MovieResponse[]>('/movies');
  return data;
};

export const getMovieById = async (filmId: number): Promise<MovieDetailResponse> => {
  const { data } = await api.get<MovieDetailResponse>(`/movies/${filmId}`);
  return data;
};

export const getMovieFeeling = async (filmId: number): Promise<MovieFeelingResponse> => {
  const { data } = await api.get<MovieFeelingResponse>(`/movies/${filmId}/feeling`);
  return data;
};

export const getMovieOptions = async (filmId: number): Promise<OptionResponse[]> => {
  const { data } = await api.get<OptionResponse[]>(`/movies/${filmId}/options`);
  return data;
};

export const addMovieOption = async (
  filmId: number,
  optionRequest: OptionRequest
): Promise<void> => {
  await api.post(`/movies/${filmId}/options`, optionRequest);
};

export const deleteMovieOption = async (filmId: number, optionId: number): Promise<void> => {
  await api.delete(`/movies/${filmId}/options/${optionId}`);
};
