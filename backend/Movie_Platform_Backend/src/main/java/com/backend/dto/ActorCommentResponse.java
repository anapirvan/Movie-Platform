package com.backend.dto;

import java.time.LocalDate;

public record ActorCommentResponse(
        Long comentariuId,
        String client,
        String film,
        String text,
        LocalDate dataComentariu,
        String sentiment
) {}
