package com.tyyago.model;

import java.time.LocalDate;

public record WorkItem(
        String id,
        String summary,
        String managingUnit,
        String priority,
        String externalStatus,
        LocalDate creationDate,
        LocalDate resolutionDate,
        LocalDate plannedDate,
        String demandType,
        String backlogType,
        LocalDate modifiedDate,
        String modifiedBy,
        String parent
) {}
