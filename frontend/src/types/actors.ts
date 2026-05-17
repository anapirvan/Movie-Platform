// ─── Actor (în contextul unui film) ──────────────────────────────────────────

export interface ActorResponse {
  actorId: number;
  numeComplet: string;
  numeScena: string;
  numePersonaj: string;
  tipRol: string;
}

// ─── Actor (lista generala) ───────────────────────────────────────────────────

export interface ActorListResponse {
  actorId: number;
  numeComplet: string;
  numeScena: string;
  dataNastere: string; // ISO date string (LocalDate)
  nrFilme: number;
}

// ─── Comentariu al unui actor ─────────────────────────────────────────────────

export interface ActorCommentResponse {
  comentariuId: number;
  client: string;
  film: string;
  text: string;
  dataComentariu: string; // ISO date string (LocalDate)
  sentiment: string;
}

// ─── Sentiment actor ──────────────────────────────────────────────────────────

export interface ActorFeelingResponse {
  concluzie: string;
  comentarii: ActorCommentResponse[];
}
