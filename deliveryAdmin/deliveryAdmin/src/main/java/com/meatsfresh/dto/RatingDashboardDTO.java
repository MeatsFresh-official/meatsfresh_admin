package com.meatsfresh.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class RatingDashboardDTO {

    private Double avgVendorRating;
    private Double avgDeliveryRating;
    private Long totalReviews;
    private Long pendingModeration;
}
