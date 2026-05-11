package com.backend.dto;

import java.time.LocalDate;

public record ActorListResponse(
        Long actorId,
        String numeComplet,
        String numeScena,
        LocalDate dataNastere,
        Long nrFilme
) {}
