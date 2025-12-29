<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="en_IN" />
<%@ include file="/includes/header.jsp" %>
<%-- Add this to your header or main layout to include Chart.js --%>
<%-- <script src="https://cdn.jsdelivr.net/npm/chart.js"></script> --%>

<main class="main-content">
    <div class="container-fluid px-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="pt-3">User Revenue</h1>
             <button class="btn btn-primary" id="exportDataBtn">
                <i class="fas fa-file-excel me-2"></i>Export Report
            </button>
        </div>

        <!-- Analytics Stats Cards Row -->
        <div class="row mb-4" id="analytics-stats-container">
            <!-- Skeletons shown on load, content populated by JS -->
            <div class="col-xl-3 col-md-6 mb-4"><div class="card skeleton" style="height: 110px;"></div></div>
            <div class="col-xl-3 col-md-6 mb-4"><div class="card skeleton" style="height: 110px;"></div></div>
            <div class="col-xl-3 col-md-6 mb-4"><div class="card skeleton" style="height: 110px;"></div></div>
            <div class="col-xl-3 col-md-6 mb-4"><div class="card skeleton" style="height: 110px;"></div></div>
        </div>

        <!-- Filters Card -->
        <div class="card shadow-sm mb-4">
            <div class="card-header py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-filter me-2"></i>Filter by Date</h6>
                <button class="btn btn-outline-danger btn-sm" id="resetFiltersBtn">
                    <i class="fas fa-times me-1"></i>Reset Filters
                </button>
            </div>
            <div class="card-body">
                <label class="form-label fw-semibold">Select Date Range</label>
                <div class="dropdown">
                     <button class="btn btn-outline-secondary dropdown-toggle w-100" type="button" id="dateRangeDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-calendar-alt me-2"></i> <span>This Month</span>
                    </button>
                    <ul class="dropdown-menu w-100" aria-labelledby="dateRangeDropdown">
                        <li><a class="dropdown-item date-range-option" href="#" data-range="today">Today</a></li>
                        <li><a class="dropdown-item date-range-option" href="#" data-range="week">Last 7 Days</a></li>
                        <li><a class="dropdown-item date-range-option active" href="#" data-range="month">This Month</a></li>
                        <li><a class="dropdown-item date-range-option" href="#" data-range="year">This Year</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#dateRangeModal">Custom Range...</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Charts Row -->
        <div class="row">
            <!-- Revenue Chart -->
            <div class="col-xl-8 col-lg-7">
                <div class="card shadow-sm mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-chart-line me-2"></i>Revenue Over Time</h6>
                    </div>
                    <div class="card-body">
                        <div class="chart-container" style="position: relative; height:320px;">
                            <canvas id="revenueChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Order Status Chart -->
            <div class="col-xl-4 col-lg-5">
                <div class="card shadow-sm mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-chart-pie me-2"></i>Order Status Distribution</h6>
                    </div>
                    <div class="card-body">
                         <div class="chart-container" style="position: relative; height:320px;">
                            <canvas id="orderStatusChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>

         <!-- Loading Indicator (centered) -->
        <div id="loadingIndicator" class="text-center py-5 d-none">
            <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-3 text-muted">Loading analytics data...</p>
        </div>

    </div>
</main>


<!-- Date Range Modal -->
<div class="modal fade" id="dateRangeModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Select Custom Date Range</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label for="startDate" class="form-label">Start Date</label>
                    <input type="date" class="form-control" id="startDate">
                </div>
                <div class="mb-3">
                    <label for="endDate" class="form-label">End Date</label>
                    <input type="date" class="form-control" id="endDate">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="applyDateRangeBtn">Apply</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin-dashboard.css">
<script src="${pageContext.request.contextPath}/resources/js/admin-dashboard.js"></script>