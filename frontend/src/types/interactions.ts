// ─── Optiune (format, limba etc.) ─────────────────────────────────────────────

export interface OptionResponse {
  optiune_id: number;
  denumire: string;
  tip: string;
}

export interface OptionRequest {
  optionId: number;
}

// ─── Vot ──────────────────────────────────────────────────────────────────────

export interface VoteRequest {
  filmId: number;
  scor: number;
}

export interface VoteResponse {
  votId: number;
}

// ─── Vizualizare (watch) ──────────────────────────────────────────────────────

export interface WatchRequest {
  versiuneId: number;
  durata?: number;
  status?: string;
}

export interface WatchResponse {
  vizualizareId: number;
}
