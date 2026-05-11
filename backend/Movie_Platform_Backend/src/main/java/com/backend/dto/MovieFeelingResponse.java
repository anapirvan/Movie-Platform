package com.backend.dto;

import java.util.List;

public record MovieFeelingResponse (
        String concluzie,
        List<FeelingSourceResponse> detalii
) {}
