import api from './axiosConfig';
import type { CommentRequest, CommentResponse } from '../types/comments';

export const createComment = async (comment: CommentRequest): Promise<CommentResponse> => {
  const { data } = await api.post<CommentResponse>('/comments', comment);
  return data;
};
