package com.meatsfresh.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "orders")
@Data
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "order_code", unique = true)
    private String orderCode;

    @Column(name = "payment_method")
    private String paymentMethod;

    @Column(name = "total_amount", precision = 38, scale = 2)
    private BigDecimal totalAmount;

    @Column(name = "placed_at")
    private LocalDateTime placedAt;

    @Column(name = "status")
    private String status;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "delivery_instructions")
    private String deliveryInstructions;

    @Column(name = "coupon")
    private String coupon;

    @Column(name = "donation")
    private Double donation;

    @Column(name = "note")
    private String note;

    @Column(name = "tip_for_delivery_person")
    private Double tipForDeliveryPerson;

    @Column(name = "delivery_fee", precision = 38, scale = 2)
    private BigDecimal deliveryFee;

    @Column(name = "gst", precision = 38, scale = 2)
    private BigDecimal gst;

    @Column(name = "platform_fee", precision = 38, scale = 2)
    private BigDecimal platformFee;

    @Column(name = "rain_fee", precision = 38, scale = 2)
    private BigDecimal rainFee;

    @Column(name = "packaging_fee", precision = 38, scale = 2)
    private BigDecimal packagingFee;

    @Column(name = "delivered_at")
    private LocalDateTime deliveredAt;

    @Column(name = "collected_cash")
    private Double collectedCash;

    @Column(name = "verify_status")
    private String verifyStatus;

    @Column(name = "order_number", unique = true)
    private String orderNumber;

    // Add other fields if needed
}
