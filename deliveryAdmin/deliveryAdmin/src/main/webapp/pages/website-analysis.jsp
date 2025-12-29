<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/header.jsp" %>

<main class="main-content">
    <div class="container-fluid">
        <!-- Page Header with Global Time Range Selector -->
        <div class="page-header py-2 d-flex justify-content-between align-items-center">
            <h1>Website Analysis</h1>
            <div class="d-flex align-items-center">
                <!-- Global Time Range Dropdown -->
                <div class="dropdown me-2">
                    <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="globalTimeRange" data-bs-toggle="dropdown">
                        <i class="fas fa-clock me-1"></i> Last 30 Days
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item global-time-range" href="#" data-range="7">Last 7 Days</a></li>
                        <li><a class="dropdown-item global-time-range" href="#" data-range="30">Last 30 Days</a></li>
                        <li><a class="dropdown-item global-time-range" href="#" data-range="90">Last 90 Days</a></li>
                        <li><a class="dropdown-item global-time-range" href="#" data-range="365">Last 1 Year</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#dateRangeModal">
                            <i class="fas fa-calendar-alt me-1"></i> Custom Range
                        </a></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Stats Cards Row -->
        <div class="row stats-row">
            <div class="col-xl-4 col-lg-6 col-md-6 col-sm-6">
                <div class="stats-card">
                    <div class="stats-info">
                        <h5>Website Visitors</h5>
                        <h2 id="totalVisitors">8k</h2>
                    </div>
                    <div class="stats-icon">
                        <i class="fas fa-users"></i>
                    </div>
                </div>
            </div>

            <div class="col-xl-4 col-lg-6 col-md-6 col-sm-6">
                <div class="stats-card">
                    <div class="stats-info">
                        <h5>Customers</h5>
                        <h2 id="totalCustomers">6k</h2>
                    </div>
                    <div class="stats-icon">
                        <i class="fas fa-user-friends"></i>
                    </div>
                </div>
            </div>

            <div class="col-xl-4 col-lg-6 col-md-6 col-sm-6">
                <div class="stats-card">
                    <div class="stats-info">
                        <h5>Bounce Rate</h5>
                        <h2 id="bounceRate">43%</h2>
                    </div>
                    <div class="stats-icon">
                        <i class="fas fa-percentage"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Main Chart Column -->
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header">
                        <h4>Visitors Overview</h4>
                    </div>
                    <div class="card-body">
                        <div class="chart-container" style="height: 300px;">
                            <canvas id="visitorsChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- OS Chart Column -->
            <div class="col-lg-4">
                <div class="card">
                    <div class="card-header">
                        <h4>Operating Systems</h4>
                    </div>
                    <div class="card-body">
                        <div class="chart-container" style="height: 300px;">
                            <canvas id="osChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Date Range Modal -->
        <div class="modal fade" id="dateRangeModal" tabindex="-1" aria-labelledby="dateRangeModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="dateRangeModalLabel">Select Date Range</h5>
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
                        <button type="button" class="btn btn-primary" id="applyDateRange">Apply</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/includes/footer.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/website-analysis.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/website-analysis.js"></script>