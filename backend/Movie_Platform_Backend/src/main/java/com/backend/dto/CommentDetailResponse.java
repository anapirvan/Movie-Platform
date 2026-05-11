package com.backend.dto;

import java.time.LocalDate;

public record CommentDetailResponse(
        Long comentariuId,
        String client,
        String text,
        String sentiment,
        LocalDate dataComentariu,
        String actoriMentionati
) {}
