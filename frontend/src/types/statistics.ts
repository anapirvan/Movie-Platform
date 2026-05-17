// ─── Top film pe sezon ────────────────────────────────────────────────────────

export interface TopSeasonMovieResponse {
  sezon: string;
  filmId: number;
  titlu: string;
  rating: number;
  nrVizualizari: number;
  locInSezon: number;
}

// ─── Top categorie pe sezon ───────────────────────────────────────────────────

export interface TopSeasonCategoryResponse {
  sezon: string;
  categorie: string;
  nrVizualizari: number;
}

// ─── Statistici sezoniere complete ───────────────────────────────────────────

export interface SeasonalStatisticsResponse {
  topFilme: TopSeasonMovieResponse[];
  topCategorii: TopSeasonCategoryResponse[];
}
