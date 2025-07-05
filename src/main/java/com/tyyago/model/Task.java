package com.tyyago.model;

import java.time.LocalDate;

public record Task(
        String id,
        String parent,
        String createdBy,
        String summary,
        String status,
        LocalDate modifiedDate,
        LocalDate plannedDate
) {}
