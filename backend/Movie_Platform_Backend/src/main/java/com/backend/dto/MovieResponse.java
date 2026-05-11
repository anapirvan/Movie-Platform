package com.backend.dto;

import java.sql.Date;
import java.time.LocalDate;

public record MovieResponse(
        Long filmId,
        String titlu,
        String descriere,
        LocalDate dataLansare,
        Double rating,
        String categorii,
        Long nrVizualizari,
        Double durataMedie
) {}
