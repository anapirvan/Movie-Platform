package com.backend.dto;

import java.time.LocalDate;

public record ClientResponse(
        Long clientId,
        String numeComplet,
        String email,
        String telefon,
        String oras,
        LocalDate dataInregistrare,
        Long nrVizualizari,
        Long nrVoturi,
        Long nrComentarii
) {}
