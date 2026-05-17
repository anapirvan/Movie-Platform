// ─── Request: adaugare comentariu ────────────────────────────────────────────

export interface CommentRequest {
  filmId: number;
  text: string;
  actorIds?: number[];
}

// ─── Response: confirmare creare comentariu ───────────────────────────────────

export interface CommentResponse {
  comentariuId: number;
}

// ─── Comentariu detaliat (in contextul unui film) ─────────────────────────────

export interface CommentDetailResponse {
  comentariuId: number;
  client: string;
  text: string;
  sentiment: string;
  dataComentariu: string; // ISO date string (LocalDate)
  actoriMentionati: string;
}
