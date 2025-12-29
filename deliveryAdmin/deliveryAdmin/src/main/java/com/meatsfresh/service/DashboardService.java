package com.meatsfresh.service;

import com.meatsfresh.dto.ChartData;
import com.meatsfresh.dto.DashboardStats;
import com.meatsfresh.dto.DateRangeRequest;
import com.meatsfresh.repository.DashboardRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class DashboardService {

    private static final Logger logger = LoggerFactory.getLogger(DashboardService.class);

    @Autowired
    private DashboardRepository dashboardRepository;

    // The static chart style is no longer needed, as it will now be dynamic.
    // @Value("${dashboard.chart.style:daily}")
    // private String chartStyle;

    // ... getDashboardStats() method remains unchanged ...
    public DashboardStats getDashboardStats(DateRangeRequest dateRange) {
        LocalDateTime[] range = parseDateRange(dateRange);
        DashboardStats stats = new DashboardStats();
        stats.setTotalOrders(dashboardRepository.countOrdersBetweenDates(range[0], range[1]));
        stats.setTotalEarnings(dashboardRepository.sumEarningsBetweenDates(range[0], range[1]));
        stats.setRefundOrders(dashboardRepository.countRefundOrdersBetweenDates(range[0], range[1]));
        stats.setCancelOrders(dashboardRepository.countCancelOrdersBetweenDates(range[0], range[1]));
        stats.setNewUsers(dashboardRepository.countUsersBetweenDates(range[0], range[1]));
        stats.setTotalReviews(dashboardRepository.countReviewsBetweenDates(range[0], range[1]));
        stats.setTotalShops(dashboardRepository.countActiveShops());
        stats.setTotalCategories(dashboardRepository.countActiveCategories());
        stats.setTotalStaff(dashboardRepository.countActiveStaff());
        stats.setTotalUsers(dashboardRepository.countTotalUsers());
        return stats;
    }


    /**
     * This is the new, dynamic method. It inspects the date range and decides
     * whether to group the data by day, week, or month.
     */
    private ChartData getDynamicChartData(DateRangeRequest dateRange, String chartType) {
        LocalDateTime[] range = parseDateRange(dateRange);
        LocalDateTime startDate = range[0];
        LocalDateTime endDate = range[1];

        // Calculate the duration of the selected period in days.
        long daysBetween = ChronoUnit.DAYS.between(startDate, endDate);

        List<Object[]> queryResults;

        // Apply logic to choose the best grouping.
        if (daysBetween <= 31) {
            // For short periods (up to a month), show daily data.
            logger.info("Fetching DAILY data for '{}' chart.", chartType);
            switch (chartType) {
                case "orders": queryResults = dashboardRepository.getDailyOrderCounts(startDate, endDate); break;
                case "earnings": queryResults = dashboardRepository.getDailyEarnings(startDate, endDate); break;
                case "users": queryResults = dashboardRepository.getDailyUserRegistrations(startDate, endDate); break;
                default: queryResults = new ArrayList<>();
            }
            // Pad the daily data to ensure the timeline is continuous.
            return generateTimeSeriesChartData(startDate, endDate, queryResults);

        } else if (daysBetween <= 180) {
            // For medium periods (up to ~6 months), show weekly data.
            logger.info("Fetching WEEKLY data for '{}' chart.", chartType);
            switch (chartType) {
                case "orders": queryResults = dashboardRepository.getWeeklyOrderCounts(startDate, endDate); break;
                // Add weekly queries for earnings/users to the repository if needed.
                // For now, we default to monthly for them if the range is long.
                default: queryResults = dashboardRepository.getMonthlyOrderCounts(startDate, endDate);
            }
            return convertToChartData(queryResults);

        } else {
            // For long periods, show monthly data.
            logger.info("Fetching MONTHLY data for '{}' chart.", chartType);
            switch (chartType) {
                case "orders": queryResults = dashboardRepository.getMonthlyOrderCounts(startDate, endDate); break;
                // You would add getMonthlyEarnings, getMonthlyUserRegistrations etc. here
                default: queryResults = dashboardRepository.getMonthlyOrderCounts(startDate, endDate);
            }
            return convertToChartData(queryResults);
        }
    }

    public ChartData getOrdersChartData(DateRangeRequest dateRange) {
        return getDynamicChartData(dateRange, "orders");
    }

    public ChartData getEarningsChartData(DateRangeRequest dateRange) {
        // This will currently show daily data or fall back to monthly orders data for long ranges.
        // To show weekly/monthly earnings, new methods would be needed in the repository.
        return getDynamicChartData(dateRange, "earnings");
    }

    public ChartData getUserGrowthChartData(DateRangeRequest dateRange) {
        return getDynamicChartData(dateRange, "users");
    }

    public ChartData getOrdersDistributionData(DateRangeRequest dateRange) {
        LocalDateTime[] range = parseDateRange(dateRange);
        List<Object[]> distributionData = dashboardRepository.getOrderStatusDistribution(range[0], range[1]);
        return convertToChartData(distributionData);
    }

    // This method is now ONLY used for padding DAILY data.
    private ChartData generateTimeSeriesChartData(LocalDateTime startDate, LocalDateTime endDate, List<Object[]> dbResults) {
        Map<String, BigDecimal> timeSeriesData = new LinkedHashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd");
        for (LocalDate date = startDate.toLocalDate(); !date.isAfter(endDate.toLocalDate()); date = date.plusDays(1)) {
            timeSeriesData.put(date.format(formatter), BigDecimal.ZERO);
        }
        Map<String, BigDecimal> dataFromDb = dbResults.stream()
                .collect(Collectors.toMap(row -> String.valueOf(row[0]), row -> new BigDecimal(row[1].toString())));
        timeSeriesData.putAll(dataFromDb);
        ChartData chartData = new ChartData();
        chartData.setLabels(new ArrayList<>(timeSeriesData.keySet()));
        chartData.setValues(new ArrayList<>(timeSeriesData.values()));
        return chartData;
    }

    // This method is used for already-grouped data (weekly, monthly, pie charts).
    private ChartData convertToChartData(List<Object[]> rawData) {
        ChartData chartData = new ChartData();
        if (rawData == null) return chartData;
        chartData.setLabels(rawData.stream().map(r -> String.valueOf(r[0])).collect(Collectors.toList()));
        chartData.setValues(rawData.stream().map(r -> new BigDecimal(r[1].toString())).collect(Collectors.toList()));
        return chartData;
    }

    private LocalDateTime[] parseDateRange(DateRangeRequest dateRange) {
        LocalDateTime startDate, endDate;
        if (dateRange.getStartDate() != null && dateRange.getEndDate() != null) {
            startDate = dateRange.getStartDate().atStartOfDay();
            endDate = dateRange.getEndDate().atTime(LocalTime.MAX);
        } else {
            int days = 30;
            if (dateRange.getPreset() != null) {
                try {
                    days = Integer.parseInt(dateRange.getPreset());
                } catch (NumberFormatException e) {
                    logger.warn("Invalid date range preset '{}', defaulting to 30 days.", dateRange.getPreset());
                }
            }
            endDate = LocalDateTime.now().with(LocalTime.MAX);
            startDate = endDate.minusDays(days - 1).with(LocalTime.MIN);
        }
        return new LocalDateTime[]{startDate, endDate};
    }
}