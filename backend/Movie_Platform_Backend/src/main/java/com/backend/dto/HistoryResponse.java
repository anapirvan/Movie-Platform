package com.backend.dto;

import java.time.LocalDate;

public record HistoryResponse(
        Long vizualizareId,
        String titlu,
        String format,
        String limba,
        LocalDate dataVizualizare,
        Integer durata,
        String status
) {}
