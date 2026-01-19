<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <fmt:setLocale value="en_IN" />
                <%@ include file="/includes/header.jsp" %>

                    <!-- Toast/Notification Containers -->
                    <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100;">
                        <div id="successToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                            <div class="toast-header bg-success text-white">
                                <strong class="me-auto">Success</strong>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"
                                    aria-label="Close"></button>
                            </div>
                            <div class="toast-body" id="toastMessage"></div>
                        </div>
                        <div id="errorToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                            <div class="toast-header bg-danger text-white">
                                <strong class="me-auto">Error</strong>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"
                                    aria-label="Close"></button>
                            </div>
                            <div class="toast-body" id="errorMessage"></div>
                        </div>
                    </div>

                    <main class="main-content">
                        <div class="container-fluid px-4">
                            <div class="d-flex justify-content-between align-items-center mb-5 pt-3">
                                <div>
                                    <h1 class="mb-1">Payments Management</h1>
                                    <p class="text-secondary mb-0 small fw-medium">Track and manage all transaction
                                        history</p>
                                </div>
                                <div class="d-flex gap-2">
                                    <button class="btn btn-zenith-success shadow-lg" data-bs-toggle="modal"
                                        data-bs-target="#addCashPaymentModal">
                                        <i class="fas fa-plus-circle me-2"></i>Record Cash
                                    </button>
                                    <button class="btn btn-white shadow-sm text-secondary hover-lift"
                                        data-bs-toggle="modal" data-bs-target="#paymentGatewayModal"
                                        style="border-radius: 10px; padding: 0.6rem 1.2rem;">
                                        <i class="fas fa-cog me-2"></i>Settings
                                    </button>
                                </div>
                            </div>

                            <!-- Filters and Summary Cards -->
                            <div class="row mb-5">
                                <div class="col-md-4 mb-4 mb-md-0">
                                    <div class="hero-stat-card bg-gradient-success-zenith">
                                        <div class="card-body">
                                            <i class="fas fa-money-bill-wave card-icon text-white"></i>
                                            <h6>Cash Collected</h6>
                                            <h3 id="cashCollected">₹0</h3>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4 mb-4 mb-md-0">
                                    <div class="hero-stat-card bg-gradient-primary-zenith">
                                        <div class="card-body">
                                            <i class="fas fa-credit-card card-icon text-white"></i>
                                            <h6>Online Payments</h6>
                                            <h3 id="onlinePayments">₹0</h3>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="hero-stat-card bg-gradient-info-zenith">
                                        <div class="card-body">
                                            <i class="fas fa-wallet card-icon text-white"></i>
                                            <h6>Total Amount</h6>
                                            <h3 id="totalAmount">₹0</h3>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Payment Transactions Panel -->
                            <div class="glass-panel mb-5 p-0 overflow-hidden">
                                <div
                                    class="p-4 border-bottom border-light d-flex justify-content-between align-items-center flex-wrap gap-3">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="icon-box bg-white text-primary rounded-circle d-flex align-items-center justify-content-center shadow-sm"
                                            style="width: 48px; height: 48px;">
                                            <i class="fas fa-history fa-lg"></i>
                                        </div>
                                        <h5 class="mb-0 fw-bold">Recent Transactions</h5>
                                    </div>

                                    <div class="d-flex gap-2 align-items-center flex-grow-1 justify-content-end">
                                        <!-- Time Filters -->
                                        <div class="bg-white p-1 rounded-pill shadow-sm d-flex" id="timeFilterButtons">
                                            <button type="button"
                                                class="btn btn-sm rounded-pill px-3 fw-medium time-filter active"
                                                data-filter="today" style="transition: all 0.2s;">Today</button>
                                            <button type="button"
                                                class="btn btn-sm rounded-pill px-3 fw-medium time-filter text-muted"
                                                data-filter="week">Week</button>
                                            <button type="button"
                                                class="btn btn-sm rounded-pill px-3 fw-medium time-filter text-muted"
                                                data-filter="month">Month</button>
                                            <button type="button" class="btn btn-sm rounded-circle text-muted"
                                                id="customDateBtn" data-bs-toggle="modal"
                                                data-bs-target="#dateRangeModal" title="Custom Range">
                                                <i class="fas fa-calendar-alt"></i>
                                            </button>
                                        </div>

                                        <!-- Search -->
                                        <div class="input-group" style="max-width: 250px;">
                                            <input type="text" class="form-control border-0 shadow-sm ps-3"
                                                placeholder="Search transactions..." id="paymentSearch"
                                                style="border-radius: 30px 0 0 30px; background: white;">
                                            <button class="btn btn-white shadow-sm border-0 pe-3" type="button"
                                                id="searchPaymentBtn"
                                                style="border-radius: 0 30px 30px 0; background: white;">
                                                <i class="fas fa-search text-secondary"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <div class="zenith-table-container p-3">
                                    <div class="table-responsive">
                                        <table class="zenith-table align-middle" id="paymentsTable">
                                            <thead>
                                                <tr>
                                                    <th class="ps-4">Transaction ID</th>
                                                    <th>Date</th>
                                                    <th>Customer Details</th>
                                                    <th>Amount</th>
                                                    <th>Method</th>
                                                    <th>Status</th>
                                                    <th class="text-center pe-4">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody class="bg-transparent">
                                                <!-- JS will populate this section -->
                                                <tr>
                                                    <td colspan="7" class="text-center p-5 text-muted">
                                                        <i class="fas fa-spinner fa-spin me-2"></i>Loading payments...
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <!-- Pagination placeholder -->
                                <div class="p-3 border-top border-light">
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
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
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
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Cancel</button>
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
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="mb-3">
                                        <label class="form-label">Order ID <span class="text-danger">*</span></label>
                                        <input type="text" name="orderId" class="form-control" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Customer Name <span
                                                class="text-danger">*</span></label>
                                        <input type="text" name="customerName" class="form-control" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Amount <span class="text-danger">*</span></label>
                                        <input type="number" step="0.01" name="amount" class="form-control" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Payment Date <span
                                                class="text-danger">*</span></label>
                                        <input type="datetime-local" name="paymentDate" class="form-control" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Collected By (Rider Name) <span
                                                class="text-danger">*</span></label>
                                        <input type="text" name="collectedBy" class="form-control" required>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Cancel</button>
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
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <!-- Content from your original JSP for this modal -->
                                    <p>Configure your payment gateway settings here.</p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Cancel</button>
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
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
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
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Close</button>
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
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
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
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Cancel</button>
                                    <button type="button" class="btn btn-danger" id="processRefundBtn">Process
                                        Refund</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%@ include file="/includes/footer.jsp" %>
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/payments.css">
                        <script src="${pageContext.request.contextPath}/resources/js/payments.js"></script>