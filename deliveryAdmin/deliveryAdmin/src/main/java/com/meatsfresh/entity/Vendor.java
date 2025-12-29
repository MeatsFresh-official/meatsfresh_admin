package com.meatsfresh.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name = "vendors")
@Data
public class Vendor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "vendors_id")
    private Long id;

    @Column(name = "vendor_name", nullable = false)
    private String vendorName;

    @Column(name = "vendor_code", nullable = false)
    private String vendorCode;

    @Column(name = "phone_number", nullable = false)
    private String phoneNumber;

    @Column(name = "email")
    private String email;

    @Column(name = "isactive", nullable = false)
    private String status; // ONLINE, OFFLINE, BLOCKED

    @Column(name = "opening_time")
    private String openingTime;

    @Column(name = "closing_time")
    private String closingTime;

    @Column(name = "address", nullable = false)
    private String address;

    @Column(name = "rating")
    private Double rating;

    @Column(name = "created")
    private LocalDateTime created;

    @Column(name = "updated")
    private LocalDateTime updated;
}
