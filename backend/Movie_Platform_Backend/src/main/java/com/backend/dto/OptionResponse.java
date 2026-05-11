package com.backend.dto;

import java.sql.Date;

public record OptionResponse(
        Long optiune_id,
        String denumire,
        String tip
) {}
