package com.backend.dto;

import jakarta.validation.constraints.NotNull;

public record OptionRequest(
        @NotNull(message = "optionId is mandatory!")
        Long optionId
) {
}
