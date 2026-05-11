package com.backend.dto;

public record ActorResponse(
        Long actorId,
        String numeComplet,
        String numeScena,
        String numePersonaj,
        String tipRol
) {}
