package com.backend.dto;

public record TopSeasonMovieResponse(
        String sezon,
        Long filmId,
        String titlu,
        Double rating,
        Long nrVizualizari,
        Long locInSezon
) {}
