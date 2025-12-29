package com.meatsfresh.service;

import com.meatsfresh.dto.RatingDashboardDTO;
import com.meatsfresh.repository.RatingRepository;
import org.springframework.stereotype.Service;

@Service
public class RatingDashboardService {

    private final RatingRepository ratingRepository;

    public RatingDashboardService(RatingRepository ratingRepository) {
        this.ratingRepository = ratingRepository;
    }

    public RatingDashboardDTO getRatingDashboardStats() {

        Double avgVendorRating = ratingRepository.getAvgVendorRating();
        Double avgDeliveryRating = ratingRepository.getAvgDeliveryRating();
        Long totalReviews = ratingRepository.getTotalReviews();
        Long pendingModeration = ratingRepository.getPendingModerationCount();

        return new RatingDashboardDTO(
                avgVendorRating != null ? avgVendorRating : 0.0,
                avgDeliveryRating != null ? avgDeliveryRating : 0.0,
                totalReviews,
                pendingModeration
        );
    }
}
