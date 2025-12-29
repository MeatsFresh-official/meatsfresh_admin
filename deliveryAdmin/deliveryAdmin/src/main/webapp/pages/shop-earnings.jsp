<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/header.jsp" %>

<main class="main-content">
    <div class="container-fluid px-4">
        <h1 class="pt-4">Shops Earnings</h1>

        <!-- Earnings Statistics Section -->
        <div class="row mb-4" id="earnings-stats-container">
            <!-- Stat cards will be dynamically inserted here by JavaScript -->
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card skeleton" style="height: 120px;"></div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card skeleton" style="height: 120px;"></div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card skeleton" style="height: 120px;"></div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card skeleton" style="height: 120px;"></div>
            </div>
        </div>

        <!-- Earnings Chart and Filters -->
        <div class="card mb-4 animate-on-load">
            <div class="card-header d-flex justify-content-between align-items-center flex-wrap">
                 <h5 class="mb-0"><i class="fas fa-chart-line me-2"></i>Earnings Overview</h5>
                 <div class="d-flex align-items-center mt-2 mt-md-0">
                    <div class="dropdown me-2">
                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="earningsDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-calendar-alt me-1"></i> <span>This Month</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="earningsDropdown">
                            <li><a class="dropdown-item earnings-range" href="#" data-range="today">Today</a></li>
                            <li><a class="dropdown-item earnings-range" href="#" data-range="week">Last 7 Days</a></li>
                            <li><a class="dropdown-item earnings-range active" href="#" data-range="month">This Month</a></li>
                            <li><a class="dropdown-item earnings-range" href="#" data-range="year">This Year</a></li>
                        </ul>
                    </div>
                    <button class="btn btn-sm btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#dateRangeModal">
                        <i class="fas fa-calendar-check me-1"></i> Custom Range
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-12">
                        <div class="skeleton" style="height: 300px;" id="earningsChartContainer">
                             <!-- Chart.js canvas will be inserted here -->
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <!-- Shops Earnings Table -->
        <div class="card mb-4 animate-on-load" style="animation-delay: 0.2s;">
            <div class="card-header d-flex justify-content-between align-items-center flex-wrap">
                <h5 class="mb-0"><i class="fas fa-store me-2"></i>Shop-wise Earnings</h5>
                <div class="d-flex align-items-center mt-2 mt-md-0">
                    <div class="input-group input-group-sm" style="max-width: 250px;">
                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                        <input type="text" id="searchInput" class="form-control" placeholder="Search shops...">
                    </div>
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-stylish mb-0" id="shopsEarningsTable">
                        <thead>
                            <tr>
                                <th class="ps-4">Vendor Info</th>
                                <th>Contact Details</th>
                                <th class="text-center status-column">Status</th>
                                <th class="text-end">Total Earnings</th>
                                <th class="text-end pe-4">Current Period Earnings</th>
                            </tr>
                        </thead>
                        <tbody id="shopsEarningsTableBody">
                            <tr><td colspan="5" class="text-center p-5"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></td></tr>
                        </tbody>
                    </table>
                </div>
                <!-- Pagination Controls -->
                <div class="card-footer d-flex justify-content-between align-items-center">
                    <span id="pagination-info"></span>
                    <nav>
                        <ul class="pagination mb-0" id="pagination-controls">
                            <!-- Pagination links will be inserted here -->
                        </ul>
                    </nav>
                </div>
            </div>
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
                <button type="button" class="btn btn-primary" id="applyDateRange">Apply</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/shop-earnings.css">
<script src="${pageContext.request.contextPath}/resources/js/shop-earnings.js"></script>