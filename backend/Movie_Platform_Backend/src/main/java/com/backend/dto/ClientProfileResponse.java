package com.backend.dto;

import java.util.List;

public record ClientProfileResponse (
        List<FavoriteCategoryResponse> categoriiPreferate,
        List<FavoriteActorResponse> actoriPreferati,
        List<HistoryResponse> istoric,
        String sentimentDominant
) {}
