package com.meatsfresh.dto;

import lombok.Data;

import java.time.LocalDate;

@Data
public class UserTableFilterRequest {

    private String activityStatus; // ALL / ACTIVE_30 / INACTIVE_30
    private String spendingLevel;
    private LocalDate startDate;
    private LocalDate endDate;

    private String search; // 👈 GLOBAL SEARCH TEXT

    private int page;
    private int size;
}
