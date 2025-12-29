package com.meatsfresh.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DateRangeRequest {
    private String preset; // "7", "30", "90", "365"
    private LocalDate startDate;
    private LocalDate endDate;
}
