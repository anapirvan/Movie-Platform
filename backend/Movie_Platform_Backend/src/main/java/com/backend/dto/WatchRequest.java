package com.backend.dto;

import jakarta.validation.constraints.NotNull;

public record WatchRequest(
    @NotNull(message = "versionId is mandatory!")
    Long versiuneId,
    Integer durata,
    String status
){ }
