package com.backend.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;

public record LoginRequest(
        @NotNull(message = "Email is mandatory")
        @Email(message = "Invalid email")
        String email
){}
