<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/header.jsp" %>

<main class="main-content">
    <div class="container-fluid px-4">
        <div class="d-flex justify-content-between align-items-center mb-4 pt-3">
            <h1>Commissions Report</h1>
        </div>

        <!-- Filters Section -->
        <div class="card mb-4">
            <div class="card-body">
                <div class="row align-items-end g-3">
                    <div class="col-lg-4 col-md-6">
                        <label class="form-label">Date Range</label>
                        <div class="btn-group w-100" role="group">
                            <button type="button" class="btn btn-outline-primary active time-filter" data-range="today">Today</button>
                            <button type="button" class="btn btn-outline-primary time-filter" data-range="week">This Week</button>
                            <button type="button" class="btn btn-outline-primary time-filter" data-range="month">This Month</button>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                         <button id="customDateRangeBtn" class="btn btn-outline-secondary w-100" data-bs-toggle="modal" data-bs-target="#dateRangeModal">
                            <i class="fas fa-calendar-alt me-2"></i>
                            <span id="customDateRangeText">Select Custom Range</span>
                        </button>
                    </div>
                    <div class="col-lg-4 col-md-12">
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-search"></i></span>
                            <input type="text" class="form-control" placeholder="Search by vendor name or ID..." id="vendorSearchInput">
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Summary Cards -->
        <div class="row mb-4" id="summary-cards-container">
            <!-- Skeleton Loaders -->
            <div class="col-xl-4 col-md-6"><div class="card skeleton mb-4" style="height: 95px;"></div></div>
            <div class="col-xl-4 col-md-6"><div class="card skeleton mb-4" style="height: 95px;"></div></div>
            <div class="col-xl-4 col-md-6"><div class="card skeleton mb-4" style="height: 95px;"></div></div>
        </div>

        <!-- Vendor Commissions Table -->
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Vendor Commission Details</h5>
                 <button class="btn btn-sm btn-success" id="exportCsvBtn">
                    <i class="fas fa-file-csv me-2"></i>Export as CSV
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0" id="commissionsTable">
                        <thead>
                            <tr>
                                <th>Vendor</th>
                                <th>Products Sold</th>
                                <th>Total Sales</th>
                                <th>Commission Rate</th>
                                <th>Commission Amount</th>
                                <th>Vendor Earnings</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="commissionsTableBody">
                            <!-- Data will be loaded here by JavaScript -->
                        </tbody>
                    </table>
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

<!-- Vendor Details Modal -->
<div class="modal fade" id="vendorDetailsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Vendor Commission Details</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="vendorDetailsBody">
                <!-- Details will be loaded here by JavaScript -->
                <div class="text-center p-5"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="downloadReportBtn">
                    <i class="fas fa-download me-2"></i>Download Full Report
                </button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/commissions-report.css">
<script src="${pageContext.request.contextPath}/resources/js/commissions-report.js"></script>