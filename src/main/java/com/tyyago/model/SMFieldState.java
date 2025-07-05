package com.tyyago.model;

import java.time.OffsetDateTime;

public record SMFieldState(
        String workItemId,
        String fieldName,
        String currentValue,
        String lastModifiedBy,
        OffsetDateTime lastModifiedAt
) {}
