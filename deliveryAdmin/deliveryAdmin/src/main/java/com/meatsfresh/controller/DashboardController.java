package com.meatsfresh.controller;

import com.meatsfresh.dto.ChartData;
import com.meatsfresh.dto.DashboardStats;
import com.meatsfresh.dto.DateRangeRequest;
import com.meatsfresh.service.DashboardService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    private static final Logger logger = LoggerFactory.getLogger(DashboardController.class);

    @Autowired
    private DashboardService dashboardService;

    @PostMapping("/stats")
    public ResponseEntity<DashboardStats> getDashboardStats(@RequestBody DateRangeRequest dateRange) {
        try {
            DashboardStats stats = dashboardService.getDashboardStats(dateRange);
            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            logger.error("Error fetching dashboard stats", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/orders-chart")
    public ResponseEntity<ChartData> getOrdersChartData(@RequestBody DateRangeRequest dateRange) {
        try {
            ChartData chartData = dashboardService.getOrdersChartData(dateRange);
            return ResponseEntity.ok(chartData);
        } catch (Exception e) {
            logger.error("Error fetching orders chart data", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/orders-distribution")
    public ResponseEntity<ChartData> getOrdersDistributionData(@RequestBody DateRangeRequest dateRange) {
        try {
            ChartData chartData = dashboardService.getOrdersDistributionData(dateRange);
            return ResponseEntity.ok(chartData);
        } catch (Exception e) {
            logger.error("Error fetching orders distribution data", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/earnings-chart")
    public ResponseEntity<ChartData> getEarningsChartData(@RequestBody DateRangeRequest dateRange) {
        try {
            ChartData chartData = dashboardService.getEarningsChartData(dateRange);
            return ResponseEntity.ok(chartData);
        } catch (Exception e) {
            logger.error("Error fetching earnings chart data", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/user-growth-chart")
    public ResponseEntity<ChartData> getUserGrowthChartData(@RequestBody DateRangeRequest dateRange) {
        try {
            ChartData chartData = dashboardService.getUserGrowthChartData(dateRange);
            return ResponseEntity.ok(chartData);
        } catch (Exception e) {
            logger.error("Error fetching user growth chart data", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}