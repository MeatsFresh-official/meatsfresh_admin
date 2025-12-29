<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/header.jsp" %>

<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<!-- Main Content -->
<main class="main-content">
    <div class="container-fluid px-4">

        <!-- Page Header with Time Range Selector -->
        <div class="page-header py-2 d-flex justify-content-between align-items-center">
            <h1 class="m-0">Dashboard</h1>
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

        <!-- Loading Spinner -->
        <div id="loadingSpinner" class="text-center py-5" style="display: none;">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-2">Loading dashboard data...</p>
        </div>

        <!-- Dashboard Content (initially hidden) -->
        <div id="dashboardContent">

    <!-- Stats Cards - First Row -->
            <div class="row g-4 mb-4">
                <!-- Total Orders -->
                <div class="col-xl-3 col-lg-6 col-md-6 col-sm-6">
                    <div class="stats-card h-100">
                        <div class="stats-info">
                            <h5>Total Orders</h5>
                            <h2 id="totalOrders">${totalOrders}</h2>
                        </div>
                        <div class="stats-icon">
                            <i class="fas fa-shopping-bag"></i>
                        </div>
                    </div>
                </div>

                <!-- Total Earnings -->
                <div class="col-xl-3 col-lg-6 col-md-6 col-sm-6">
                    <div class="stats-card h-100">
                        <div class="stats-info">
                            <h5>Total Earnings</h5>
                            <h2 id="totalEarnings">${totalEarnings}</h2>
                        </div>
                        <div class="stats-icon">
                            <i class="fas fa-rupee-sign"></i>
                        </div>
                    </div>
                </div>

                <!-- Refund Orders -->
                <div class="col-xl-3 col-lg-6 col-md-6 col-sm-6">
                    <div class="stats-card h-100">
                        <div class="stats-info">
                            <h5>Refund Orders</h5>
                            <h2 id="refundOrders">${refundOrders}</h2>
                        </div>
                        <div class="stats-icon">
                            <i class="fas fa-exchange-alt"></i>
                        </div>
                    </div>
                </div>

                <!-- Cancel Orders -->
                <div class="col-xl-3 col-lg-6 col-md-6 col-sm-6">
                    <div class="stats-card h-100">
                        <div class="stats-info">
                            <h5>Cancel Orders</h5>
                            <h2 id="cancelOrders">${cancelOrders}</h2>
                        </div>
                        <div class="stats-icon">
                            <i class="fas fa-times-circle"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Stats Cards - Second Row -->
            <div class="row g-4 mb-4">
                <!-- Total Shops -->
                <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                    <div class="stats-card h-100">
                        <div class="stats-info">
                            <h5>Total Shops</h5>
                            <h2 id="totalShops">${totalShops}</h2>
                        </div>
                        <div class="stats-icon">
                            <i class="fas fa-store"></i>
                        </div>
                    </div>
                </div>

                <!-- Total Categories -->
                <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                    <div class="stats-card h-100">
                        <div class="stats-info">
                            <h5>Categories</h5>
                            <h2 id="totalCategories">${totalCategories}</h2>
                        </div>
                        <div class="stats-icon">
                            <i class="fas fa-tags"></i>
                        </div>
                    </div>
                </div>

                <!-- Total Staff -->
                <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                    <div class="stats-card h-100">
                        <div class="stats-info">
                            <h5>Total Staff</h5>
                            <h2 id="totalStaff">${totalStaff}</h2>
                        </div>
                        <div class="stats-icon">
                            <i class="fas fa-user-tie"></i>
                        </div>
                    </div>
                </div>

                <!-- Total Users -->
                <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                    <div class="stats-card h-100">
                        <div class="stats-info">
                            <h5>Total Users</h5>
                            <h2 id="totalUsers">${totalUsers}</h2>
                        </div>
                        <div class="stats-icon">
                            <i class="fas fa-users"></i>
                        </div>
                    </div>
                </div>

                <!-- Total Reviews -->
                <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                    <div class="stats-card h-100">
                        <div class="stats-info">
                            <h5>Total Reviews</h5>
                            <h2 id="totalReviews">${totalReviews}</h2>
                        </div>
                        <div class="stats-icon">
                            <i class="fas fa-star"></i>
                        </div>
                    </div>
                </div>

                <!-- New Users -->
                <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                    <div class="stats-card h-100">
                        <div class="stats-info">
                            <h5>New Users</h5>
                            <h2 id="newUsers">${newUsers}</h2>
                        </div>
                        <div class="stats-icon">
                            <i class="fas fa-user-plus"></i>
                        </div>
                    </div>
                </div>
            </div>


            <!-- Charts Row - First -->
            <div class="row g-4 mb-4">
                <!-- Orders Overview Chart -->
                <div class="col-lg-8">
                    <div class="card chart-card h-100">
                        <div class="card-header bg-white border-bottom-0 py-3">
                            <h4 class="mb-0">Orders Overview</h4>
                        </div>
                        <div class="card-body pt-0">
                            <div class="chart-container" style="height: 300px;">
                                <canvas id="ordersChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Orders Distribution Chart -->
                <div class="col-lg-4">
                    <div class="card chart-card h-100">
                        <div class="card-header bg-white border-bottom-0 py-3">
                            <h4 class="mb-0">Orders Distribution</h4>
                        </div>
                        <div class="card-body pt-0">
                            <div class="chart-container" style="height: 300px;">
                                <canvas id="ordersPieChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Charts Row - Second -->
            <div class="row g-4">
                <!-- Earnings Overview Chart -->
                <div class="col-lg-6">
                    <div class="card chart-card h-100">
                        <div class="card-header bg-white border-bottom-0 py-3">
                            <h4 class="mb-0">Earnings Overview</h4>
                        </div>
                        <div class="card-body pt-0">
                            <div class="chart-container" style="height: 300px;">
                                <canvas id="earningsChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- User Growth Chart -->
                <div class="col-lg-6">
                    <div class="card chart-card h-100">
                        <div class="card-header bg-white border-bottom-0 py-3">
                            <h4 class="mb-0">User Growth</h4>
                        </div>
                        <div class="card-body pt-0">
                            <div class="chart-container" style="height: 300px;">
                                <canvas id="usersChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div> <!-- End of dashboardContent -->

        <!-- Date Range Modal -->
        <div class="modal fade" id="dateRangeModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Select Date Range</h5>
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
<script type="text/javascript">
    const contextPath = "${pageContext.request.contextPath}";
</script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
<script src="${pageContext.request.contextPath}/resources/js/dashboard.js"></script>