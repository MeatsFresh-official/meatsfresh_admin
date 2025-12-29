package com.meatsfresh.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DashboardStats {
    private long totalOrders;
    private BigDecimal totalEarnings;
    private long refundOrders;
    private long cancelOrders;
    private long totalShops;
    private long totalCategories;
    private long totalStaff;
    private long totalUsers;
    private long totalReviews;
    private long newUsers;
}
