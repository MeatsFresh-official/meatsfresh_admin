package com.meatsfresh.repository;

import com.meatsfresh.entity.Rating;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface RatingRepository extends JpaRepository<Rating, Long> {

    @Query("SELECT AVG(r.vendorRating) FROM Rating r WHERE r.vendorRating IS NOT NULL")
    Double getAvgVendorRating();

    @Query("SELECT AVG(r.deliveryRating) FROM Rating r WHERE r.deliveryRating IS NOT NULL")
    Double getAvgDeliveryRating();

    @Query("SELECT COUNT(r) FROM Rating r")
    Long getTotalReviews();

    @Query("SELECT COUNT(r) FROM Rating r WHERE r.approved = false OR r.approved IS NULL")
    Long getPendingModerationCount();
}
