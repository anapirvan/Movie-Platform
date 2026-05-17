// ─── Client (lista) ───────────────────────────────────────────────────────────

export interface ClientResponse {
  clientId: number;
  numeComplet: string;
  email: string;
  telefon: string;
  oras: string;
  dataInregistrare: string; // ISO date string (LocalDate)
  nrVizualizari: number;
  nrVoturi: number;
  nrComentarii: number;
}

// ─── Categorie preferata ──────────────────────────────────────────────────────

export interface FavoriteCategoryResponse {
  categorieId: number;
  denumire: string;
  nrVizualizari: number;
}

// ─── Actor preferat ───────────────────────────────────────────────────────────

export interface FavoriteActorResponse {
  actorId: number;
  numeComplet: string;
  nrFilmeVazute: number;
}

// ─── Intrare in istoricul vizualizarilor ──────────────────────────────────────

export interface HistoryResponse {
  vizualizareId: number;
  titlu: string;
  format: string;
  limba: string;
  dataVizualizare: string; // ISO date string (LocalDate)
  durata: number;
  status: string;
}

// ─── Profil complet client ────────────────────────────────────────────────────

export interface ClientProfileResponse {
  categoriiPreferate: FavoriteCategoryResponse[];
  actoriPreferati: FavoriteActorResponse[];
  istoric: HistoryResponse[];
  sentimentDominant: string;
}
