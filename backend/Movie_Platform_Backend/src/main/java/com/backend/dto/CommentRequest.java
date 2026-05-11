package com.backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.util.List;

public record CommentRequest(
        @NotNull(message = "filmId is mandatory!")
        Long filmId,

        @NotNull(message = "Comment text is mandatory!")
        String text,

        List<Long> actorIds
) {}
