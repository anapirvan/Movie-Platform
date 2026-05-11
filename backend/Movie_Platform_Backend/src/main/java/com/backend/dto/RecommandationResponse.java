package com.backend.dto;

import java.time.LocalDate;

public record RecommandationResponse(
        Long filmId,
        String titlu,
        Double rating,
        LocalDate dataLansare,
        String categorii,
        Long scorRelevanta
) {}
