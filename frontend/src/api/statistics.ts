import api from './axiosConfig';
import type { SeasonalStatisticsResponse } from '../types/statistics';

export const getSeasonalStatistics = async (): Promise<SeasonalStatisticsResponse> => {
  const { data } = await api.get<SeasonalStatisticsResponse>('/statistics/seasonal');
  return data;
};
