package com.backend.dto;

public record FavoriteCategoryResponse(
        Long categorieId,
        String denumire,
        Long nrVizualizari
) {}
