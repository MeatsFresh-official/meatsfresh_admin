package com.meatsfresh.repository;

import com.meatsfresh.entity.Otp;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface OtpRepository  extends JpaRepository<Otp, Long> {
    @Query("SELECT o FROM Otp o WHERE o.phone = :phone ORDER BY o.createdAt DESC")
    List<Otp> findTop1ByPhoneOrderByCreatedAtDesc(@Param("phone") String phone);
}
