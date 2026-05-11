package com.backend.dto;

import java.time.LocalDate;
import java.util.List;

public record MovieDetailResponse(
        Long filmId,
        String titlu,
        String descriere,
        LocalDate dataLansare,
        Double rating,
        String categorii,
        List<VersionResponse> versiuni,
        List<ActorResponse> actori,
        List<CommentDetailResponse> comentarii
) {}
