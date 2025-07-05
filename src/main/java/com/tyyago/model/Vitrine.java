package com.tyyago.model;

import java.time.LocalDate;

public record Vitrine(
        String id,
        String type,
        String name,
        String status,
        String itOwner,
        LocalDate modifiedDate,
        LocalDate deliveryStartDate,
        LocalDate deliveryEndDate,
        String description
) {}
