package com.meatsfresh.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Data
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "users_id")
    private Long id;

    @Column(name = "dob")
    private LocalDate dob;

    @Column(name = "email")
    private String email;

    @Column(name = "name")
    private String name;

    @Column(name = "otp")
    private String otp;

    @Column(name = "otp_expiry")
    private LocalDateTime otpExpiry;

    @Column(name = "phone", nullable = false)
    private String phone;

    @Column(name = "plan")
    private String plan;

    @Column(name = "registration_date")
    private LocalDateTime registrationDate;

    @Column(name = "status")
    private String status;

    @Column(name = "user_code", nullable = false, unique = true)
    private String userCode;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
