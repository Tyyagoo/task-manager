package com.tyyago.model;

import java.time.OffsetDateTime;
import java.util.UUID;

public record SMFieldEvent(
        UUID id,
        String workItemId,
        String fieldName,
        String oldValue,
        String newValue,
        String userId,
        OffsetDateTime timestamp,
        boolean reverted
) {}
