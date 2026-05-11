package com.backend.dto;

import java.util.List;

public record ActorFeelingResponse (
        String concluzie,
        List<ActorCommentResponse> comentarii
) {}