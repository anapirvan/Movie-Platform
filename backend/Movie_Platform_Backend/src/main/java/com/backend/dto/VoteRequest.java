package com.backend.dto;

import jakarta.validation.constraints.NotNull;

public record VoteRequest(
        @NotNull(message = "filmId is mandatory!")
        Long filmId,

        @NotNull(message = "Score is mandatory!")
        Integer scor
) {}
