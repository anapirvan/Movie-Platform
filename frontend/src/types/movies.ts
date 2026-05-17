// ─── Versiune ────────────────────────────────────────────────────────────────

export interface VersionResponse {
  versiuneId: number;
  format: string;
  limba: string;
  rezolutie: string;
  durata: number;
}

// ─── Film (lista) ─────────────────────────────────────────────────────────────

export interface MovieResponse {
  filmId: number;
  titlu: string;
  descriere: string;
  dataLansare: string; // ISO date string (LocalDate)
  rating: number;
  categorii: string;
  nrVizualizari: number;
  durataMedie: number;
}

// ─── Film (detalii complete) ──────────────────────────────────────────────────

export interface MovieDetailResponse {
  filmId: number;
  titlu: string;
  descriere: string;
  dataLansare: string; // ISO date string (LocalDate)
  rating: number;
  categorii: string;
  versiuni: VersionResponse[];
  actori: import('./actors').ActorResponse[];
  comentarii: import('./comments').CommentDetailResponse[];
}

// ─── Recomandare ─────────────────────────────────────────────────────────────

export interface RecommandationResponse {
  filmId: number;
  titlu: string;
  rating: number;
  dataLansare: string; // ISO date string (LocalDate)
  categorii: string;
  scorRelevanta: number;
}

// ─── Sentiment film ───────────────────────────────────────────────────────────

export interface FeelingSourceResponse {
  sursa: string;
  pozitiv: number;
  negativ: number;
  neutru: number;
  total: number;
}

export interface MovieFeelingResponse {
  concluzie: string;
  detalii: FeelingSourceResponse[];
}
