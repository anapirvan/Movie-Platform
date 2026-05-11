package com.backend.dto;

public record FeelingSourceResponse (
        String sursa,
        Long pozitiv,
        Long negativ,
        Long neutru,
        Long total
) {}
