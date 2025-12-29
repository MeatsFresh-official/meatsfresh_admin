package com.meatsfresh.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public class DashboardRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // --- STATS QUERIES ---
    public Long countOrdersBetweenDates(LocalDateTime startDate, LocalDateTime endDate) {
        return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM orders WHERE order_date BETWEEN ? AND ?", Long.class, startDate, endDate);
    }

    public BigDecimal sumEarningsBetweenDates(LocalDateTime startDate, LocalDateTime endDate) {
        return jdbcTemplate.queryForObject("SELECT COALESCE(SUM(amount), 0) FROM orders WHERE status = 'DELIVERED' AND order_date BETWEEN ? AND ?", BigDecimal.class, startDate, endDate);
    }

    public Long countRefundOrdersBetweenDates(LocalDateTime startDate, LocalDateTime endDate) {
        return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM orders WHERE status = 'REFUNDED' AND order_date BETWEEN ? AND ?", Long.class, startDate, endDate);
    }

    public Long countCancelOrdersBetweenDates(LocalDateTime startDate, LocalDateTime endDate) {
        return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM orders WHERE status = 'CANCELLED' AND order_date BETWEEN ? AND ?", Long.class, startDate, endDate);
    }

    public Long countActiveShops() {
        return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM shops WHERE active = true", Long.class);
    }

    public Long countActiveCategories() {
        return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM categories WHERE active = true", Long.class);
    }

    public Long countActiveStaff() {
        return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM staff WHERE active = true", Long.class);
    }

    public Long countUsersBetweenDates(LocalDateTime startDate, LocalDateTime endDate) {
        return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users WHERE registration_date BETWEEN ? AND ?", Long.class, startDate, endDate);
    }

    public Long countReviewsBetweenDates(LocalDateTime startDate, LocalDateTime endDate) {
        return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM reviews WHERE review_date BETWEEN ? AND ?", Long.class, startDate, endDate);
    }

    public Long countTotalUsers() {
        return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users", Long.class);
    }

    // --- CHART QUERIES (FOR POSTGRESQL) ---
    public List<Object[]> getDailyOrderCounts(LocalDateTime startDate, LocalDateTime endDate) {
        String sql = "SELECT to_char(DATE_TRUNC('day', order_date), 'Mon DD') as day, COUNT(*) as count " +
                "FROM orders WHERE order_date BETWEEN ? AND ? " +
                "GROUP BY DATE_TRUNC('day', order_date) ORDER BY DATE_TRUNC('day', order_date)";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{rs.getString("day"), rs.getLong("count")}, startDate, endDate);
    }

    public List<Object[]> getDailyEarnings(LocalDateTime startDate, LocalDateTime endDate) {
        String sql = "SELECT to_char(DATE_TRUNC('day', order_date), 'Mon DD') as day, COALESCE(SUM(amount), 0) as amount " +
                "FROM orders WHERE status = 'DELIVERED' AND order_date BETWEEN ? AND ? " +
                "GROUP BY DATE_TRUNC('day', order_date) ORDER BY DATE_TRUNC('day', order_date)";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{rs.getString("day"), rs.getBigDecimal("amount")}, startDate, endDate);
    }

    public List<Object[]> getDailyUserRegistrations(LocalDateTime startDate, LocalDateTime endDate) {
        String sql = "SELECT to_char(DATE_TRUNC('day', registration_date), 'Mon DD') as day, COUNT(*) as count " +
                "FROM users WHERE registration_date BETWEEN ? AND ? " +
                "GROUP BY DATE_TRUNC('day', registration_date) ORDER BY DATE_TRUNC('day', registration_date)";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{rs.getString("day"), rs.getLong("count")}, startDate, endDate);
    }

    public List<Object[]> getOrderStatusDistribution(LocalDateTime startDate, LocalDateTime endDate) {
        String sql = "SELECT CASE WHEN status = 'DELIVERED' THEN 'Completed' ELSE status END as status_display, COUNT(*) as count " +
                "FROM orders WHERE order_date BETWEEN ? AND ? " +
                "GROUP BY status ORDER BY count DESC";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{rs.getString("status_display"), rs.getLong("count")}, startDate, endDate);
    }

    public List<Object[]> getWeeklyOrderCounts(LocalDateTime startDate, LocalDateTime endDate) {
        String sql = "SELECT to_char(DATE_TRUNC('week', order_date), 'Mon DD') || ' - ' || to_char(DATE_TRUNC('week', order_date) + INTERVAL '6 days', 'Mon DD') as week_range, COUNT(*) as count " +
                "FROM orders WHERE order_date BETWEEN ? AND ? " +
                "GROUP BY DATE_TRUNC('week', order_date) ORDER BY DATE_TRUNC('week', order_date)";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{rs.getString("week_range"), rs.getLong("count")}, startDate, endDate);
    }

    public List<Object[]> getMonthlyOrderCounts(LocalDateTime startDate, LocalDateTime endDate) {
        String sql = "SELECT to_char(order_date, 'Mon YYYY') as month, COUNT(*) as count " +
                "FROM orders WHERE order_date BETWEEN ? AND ? " +
                "GROUP BY DATE_TRUNC('month', order_date), to_char(order_date, 'Mon YYYY') ORDER BY DATE_TRUNC('month', order_date)";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{rs.getString("month"), rs.getLong("count")}, startDate, endDate);
    }
}