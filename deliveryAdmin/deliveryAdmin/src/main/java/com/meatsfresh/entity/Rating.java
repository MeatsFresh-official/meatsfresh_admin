package com.meatsfresh.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name = "ratings")
@Data
public class Rating {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "rating_id")
    private Long ratingId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "vendor_id")
    private Long vendorId;

    @Column(name = "vendor_rating")
    private Integer vendorRating;

    @Column(name = "vendor_review")
    private String vendorReview;

    @Column(name = "delivery_partner_id")
    private Long deliveryPartnerId;

    @Column(name = "delivery_rating")
    private Integer deliveryRating;

    @Column(name = "delivery_review")
    private String deliveryReview;

    @Column(name = "rating")
    private Integer rating;

    @Column(name = "review")
    private String review;

    @Column(name = "approved")
    private Boolean approved;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
