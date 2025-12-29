<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="en_IN" />
<%@ include file="/includes/header.jsp" %>

<!-- Toast/Notification Containers -->
<div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100">
    <div id="successToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header bg-success text-white">
            <strong class="me-auto">Success</strong>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body" id="successToastMessage"></div>
    </div>
    <div id="errorToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header bg-danger text-white">
            <strong class="me-auto">Error</strong>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body" id="errorToastMessage"></div>
    </div>
</div>

<main class="main-content">
    <div class="container-fluid px-4">
        <div class="page-header pt-3">
            <h1>Rider Payouts & Earnings</h1>
        </div>

        <!-- Overview Earnings Cards -->
        <div class="row mb-4" id="payout-stats-container">
            <!-- Skeleton loaders, content will be populated by JS -->
            <div class="col-xl-3 col-md-6 mb-4"><div class="card skeleton" style="height: 110px;"></div></div>
            <div class="col-xl-3 col-md-6 mb-4"><div class="card skeleton" style="height: 110px;"></div></div>
            <div class="col-xl-3 col-md-6 mb-4"><div class="card skeleton" style="height: 110px;"></div></div>
            <div class="col-xl-3 col-md-6 mb-4"><div class="card skeleton" style="height: 110px;"></div></div>
        </div>

        <!-- Main Payouts Table Card -->
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center flex-wrap">
                <h5 class="mb-0 card-title"><i class="fas fa-money-check-alt me-2"></i>Rider Payouts</h5>
                <div class="d-flex align-items-center mt-2 mt-md-0">
                    <!-- Date Range Dropdown -->
                    <div class="dropdown me-2">
                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="payoutsDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-calendar-alt me-1"></i> <span>This Month</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="payoutsDropdown">
                            <li><a class="dropdown-item payout-range" href="#" data-range="today">Today</a></li>
                            <li><a class="dropdown-item payout-range" href="#" data-range="week">Last 7 Days</a></li>
                            <li><a class="dropdown-item payout-range active" href="#" data-range="month">This Month</a></li>
                            <li><a class="dropdown-item payout-range" href="#" data-range="year">This Year</a></li>
                            <li><hr class="dropdown-divider"></li>
                             <li>
                                <a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#dateRangeModal">
                                    <i class="fas fa-calendar-check me-1"></i> Custom Range
                                </a>
                            </li>
                        </ul>
                    </div>
                     <!-- Status Filter -->
                    <div class="btn-group">
                        <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-filter me-1"></i> <span id="filterStatusText">All Statuses</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item filter-payout" href="#" data-filter="all">All Statuses</a></li>
                            <li><a class="dropdown-item filter-payout" href="#" data-filter="pending">Pending</a></li>
                            <li><a class="dropdown-item filter-payout" href="#" data-filter="paid">Paid</a></li>
                            <li><a class="dropdown-item filter-payout" href="#" data-filter="failed">Failed</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle" id="payoutsTable">
                        <thead>
                            <tr>
                                <th class="ps-3">Rider</th>
                                <th>Contact</th>
                                <th class="text-center payout-status-column">Payout Status</th>
                                <th class="text-end">Period Earnings</th>
                                <th class="text-end">Pending Amount</th>
                                <th class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="payoutsTableBody">
                            <!-- Initial loading state -->
                            <tr>
                                <td colspan="6" class="text-center p-5">
                                    <div class="spinner-border text-primary" role="status">
                                        <span class="visually-hidden">Loading rider payouts...</span>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
             <div class="card-footer d-flex justify-content-between align-items-center">
                <span id="pagination-info"></span>
                <nav>
                    <ul class="pagination mb-0" id="pagination-controls">
                        <!-- Pagination controls generated by JS -->
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</main>

<!-- Process Payout Modal -->
<div class="modal fade" id="processPayoutModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Process Payout</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>You are about to process a payout for:</p>
                <div class="mb-3">
                    <strong>Rider:</strong> <span id="payoutRiderName"></span><br>
                    <strong>Pending Amount:</strong> <span class="fw-bold text-success fs-5" id="payoutAmount"></span>
                </div>
                <div class="mb-3">
                    <label for="transactionId" class="form-label">Transaction ID / Reference <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="transactionId" placeholder="Enter transaction reference number" required>
                    <div class="invalid-feedback">A transaction ID is required.</div>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" value="" id="payoutConfirmationCheck">
                    <label class="form-check-label" for="payoutConfirmationCheck">
                        I confirm that the payout has been successfully transferred.
                    </label>
                </div>
                 <input type="hidden" id="payoutRiderId">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="confirmPayoutBtn" disabled>
                    <i class="fas fa-check-circle me-2"></i>Confirm Payout
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Date Range Modal (reused from reference) -->
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

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/deliveryBoy-earnings.css">
<script src="${pageContext.request.contextPath}/resources/js/deliveryBoy-earnings.js"></script>