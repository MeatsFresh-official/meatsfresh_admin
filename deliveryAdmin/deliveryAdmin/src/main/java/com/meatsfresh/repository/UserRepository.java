package com.meatsfresh.repository;

import com.meatsfresh.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDateTime;

public interface UserRepository extends JpaRepository<User, Long> {

    // Total users
    long count();

    // Active users in last 30 days
    @Query("SELECT COUNT(u) FROM User u WHERE u.createdAt >= :fromDate")
    long countActiveUsersLast30Days(LocalDateTime fromDate);

    // Total revenue
    @Query("SELECT COALESCE(SUM(o.totalAmount), 0) FROM Order o")
    Double getTotalRevenue();

    // Average order value
    @Query("SELECT COALESCE(AVG(o.totalAmount), 0) FROM Order o")
    Double getAvgOrderValue();
}
