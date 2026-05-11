package com.backend.dto;

public record VersionResponse(
        Long versiuneId,
        String format,
        String limba,
        String rezolutie,
        Integer durata
) {}
