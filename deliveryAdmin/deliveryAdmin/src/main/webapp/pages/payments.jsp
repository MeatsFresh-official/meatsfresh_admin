<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="en_IN" />
<%@ include file="/includes/header.jsp" %>

<!-- Toast/Notification Containers -->
<div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100;">
    <div id="successToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header bg-success text-white">
            <strong class="me-auto">Success</strong>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body" id="toastMessage"></div>
    </div>
    <div id="errorToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header bg-danger text-white">
            <strong class="me-auto">Error</strong>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body" id="errorMessage"></div>
    </div>
</div>

<main class="main-content">
    <div class="container-fluid px-4">
        <div class="d-flex justify-content-between align-items-center mb-4 pt-3">
            <h1 class="mb-0">Payments Management</h1>
            <div>
                 <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addCashPaymentModal">
                    <i class="fas fa-plus me-2"></i>Record Cash
                </button>
                 <button class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="#paymentGatewayModal">
                    <i class="fas fa-cog me-2"></i>Gateway Settings
                </button>
            </div>
        </div>

        <!-- Filters and Summary Cards -->
        <div class="card mb-4">
            <div class="card-header">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Payment Summary</h5>
                    <div class="btn-group" role="group" id="timeFilterButtons">
                        <button type="button" class="btn btn-outline-primary active time-filter" data-filter="today">Today</button>
                        <button type="button" class="btn btn-outline-primary time-filter" data-filter="week">This Week</button>
                        <button type="button" class="btn btn-outline-primary time-filter" data-filter="month">This Month</button>
                        <button type="button" class="btn btn-outline-primary" id="customDateBtn" data-bs-toggle="modal" data-bs-target="#dateRangeModal">
                            <i class="fas fa-calendar-alt"></i>
                        </button>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4">
                        <div class="card bg-success text-white">
                            <div class="card-body">
                                <h6 class="mb-0">Cash Collected</h6>
                                <h3 class="mb-0" id="cashCollected">₹0</h3>
                                <i class="fas fa-money-bill-wave fa-2x card-icon"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card bg-primary text-white">
                            <div class="card-body">
                                <h6 class="mb-0">Online Payments</h6>
                                <h3 class="mb-0" id="onlinePayments">₹0</h3>
                                <i class="fas fa-credit-card fa-2x card-icon"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card bg-info text-white">
                            <div class="card-body">
                                <h6 class="mb-0">Total Amount</h6>
                                <h3 class="mb-0" id="totalAmount">₹0</h3>
                                <i class="fas fa-wallet fa-2x card-icon"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Payment Transactions Table -->
        <div class="card mb-4">
            <div class="card-header">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Payment Transactions</h5>
                    <div class="col-md-4">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Search by ID, name, order ID..." id="paymentSearch">
                            <button class="btn btn-outline-secondary" type="button" id="searchPaymentBtn">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover" id="paymentsTable">
                        <thead>
                            <tr>
                                <th>Transaction ID</th>
                                <th>Date</th>
                                <th>Customer</th>
                                <th>Amount</th>
                                <th>Payment Method</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                           <!-- JS will populate this section -->
                           <tr>
                               <td colspan="7" class="text-center">
                                   <i class="fas fa-spinner fa-spin me-2"></i>Loading payments...
                               </td>
                           </tr>
                        </tbody>
                    </table>
                </div>
                 <!-- Pagination placeholder -->
                <nav id="paginationContainer" aria-label="Page navigation"></nav>
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

<!-- Add Cash Payment Modal -->
<div class="modal fade" id="addCashPaymentModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <form class="modal-content" id="addCashPaymentForm">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Record Cash Payment</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Order ID <span class="text-danger">*</span></label>
                    <input type="text" name="orderId" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Customer Name <span class="text-danger">*</span></label>
                    <input type="text" name="customerName" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Amount <span class="text-danger">*</span></label>
                    <input type="number" step="0.01" name="amount" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Payment Date <span class="text-danger">*</span></label>
                    <input type="datetime-local" name="paymentDate" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Collected By (Rider Name) <span class="text-danger">*</span></label>
                    <input type="text" name="collectedBy" class="form-control" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Record Payment</button>
            </div>
        </form>
    </div>
</div>

<!-- Payment Gateway Settings Modal -->
<div class="modal fade" id="paymentGatewayModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <form class="modal-content" id="paymentGatewayForm">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Payment Gateway Integration</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- Content from your original JSP for this modal -->
                 <p>Configure your payment gateway settings here.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Settings</button>
            </div>
        </form>
    </div>
</div>

<!-- Payment Details Modal -->
<div class="modal fade" id="paymentDetailsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Payment Details</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                 <div class="text-center" id="paymentDetailLoader">
                    <i class="fas fa-spinner fa-spin fa-2x"></i>
                 </div>
                 <div id="paymentDetailContent" class="d-none">
                    <div class="mb-3">
                        <h6 class="text-muted">Transaction ID</h6>
                        <p id="detailTransactionId" class="fw-bold"></p>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <h6 class="text-muted">Date & Time</h6>
                            <p id="detailPaymentDate" class="fw-bold"></p>
                        </div>
                        <div class="col-md-6">
                            <h6 class="text-muted">Amount</h6>
                            <p id="detailAmount" class="fw-bold"></p>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <h6 class="text-muted">Payment Method</h6>
                            <p id="detailPaymentMethod" class="fw-bold"></p>
                        </div>
                        <div class="col-md-6">
                            <h6 class="text-muted">Status</h6>
                            <p id="detailPaymentStatus" class="fw-bold"></p>
                        </div>
                    </div>
                    <div class="mb-3">
                        <h6 class="text-muted">Customer</h6>
                        <div class="d-flex align-items-center">
                            <div>
                                <p id="detailCustomerName" class="fw-bold mb-0"></p>
                                <small id="detailOrderId" class="text-muted"></small>
                            </div>
                        </div>
                    </div>
                    <div id="onlinePaymentDetails" class="d-none">
                        <hr>
                        <h6 class="text-muted">Online Payment Details</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-1"><small>Gateway Reference</small></p>
                                <p id="detailGatewayRef" class="fw-bold"></p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1"><small>Payment Mode</small></p>
                                <p id="detailPaymentMode" class="fw-bold"></p>
                            </div>
                        </div>
                    </div>
                    <div id="cashPaymentDetails" class="d-none">
                        <hr>
                        <h6 class="text-muted">Cash Collection Details</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-1"><small>Collected By</small></p>
                                <p id="detailCollectedBy" class="fw-bold"></p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1"><small>Collection Time</small></p>
                                <p id="detailCollectionTime" class="fw-bold"></p>
                            </div>
                        </div>
                    </div>
                 </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="printReceiptBtn">
                    <i class="fas fa-print me-2"></i>Print Receipt
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Refund Confirmation Modal -->
<div class="modal fade" id="refundConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">Confirm Refund</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to process a refund for this payment?</p>
                <input type="hidden" id="refundPaymentId">
                <div class="mb-3">
                    <label class="form-label">Refund Amount</label>
                    <input type="number" step="0.01" class="form-control" id="refundAmount">
                </div>
                <div class="mb-3">
                    <label class="form-label">Reason (Optional)</label>
                    <textarea class="form-control" id="refundReason" rows="2"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" id="processRefundBtn">Process Refund</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/payments.css">
<script src="${pageContext.request.contextPath}/resources/js/payments.js"></script>