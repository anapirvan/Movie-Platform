package com.backend.dto;

import java.util.List;

public record SeasonalStatisticsResponse(
        List<TopSeasonMovieResponse> topFilme,
        List<TopSeasonCategoryResponse> topCategorii
) {}
