package com.meatsfresh.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Data
public class Otp {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String phone;
    private String otp;

    @Column(name = "created_at") // Maps the field to `created_at` in the database
    private LocalDateTime createdAt;

    @Column(name = "expires_at")  // New Field
    private LocalDateTime expiresAt;
}
