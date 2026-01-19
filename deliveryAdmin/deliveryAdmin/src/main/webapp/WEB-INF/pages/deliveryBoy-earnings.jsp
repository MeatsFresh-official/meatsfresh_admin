<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <fmt:setLocale value="en_IN" />
            <%@ include file="/includes/header.jsp" %>

                <!-- Toast/Notification Containers -->
                <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100">
                    <div id="successToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                        <div class="toast-header bg-success text-white">
                            <strong class="me-auto">Success</strong>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"
                                aria-label="Close"></button>
                        </div>
                        <div class="toast-body" id="successToastMessage"></div>
                    </div>
                    <div id="errorToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                        <div class="toast-header bg-danger text-white">
                            <strong class="me-auto">Error</strong>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"
                                aria-label="Close"></button>
                        </div>
                        <div class="toast-body" id="errorToastMessage"></div>
                    </div>
                </div>

                <main class="main-content">
                    <div class="container-fluid px-4">
                        <!-- Global Header with Filters -->
                        <div class="page-header pt-3 d-flex justify-content-between align-items-center flex-wrap gap-3">
                            <div>
                                <h1>Rider Payouts & Earnings</h1>
                                <p class="text-muted small mb-0">Manage weekly payouts for delivery partners (Wednesday
                                    Cycle)</p>
                            </div>

                            <!-- Global Soft Filters (Pills) -->
                            <div
                                class="d-flex align-items-center gap-2 bg-white p-1 rounded-pill shadow-sm border border-light">
                                <a href="#" class="btn btn-sm rounded-pill px-3 py-1 fw-bold filter-pill active"
                                    data-range="week">This Week</a>
                                <a href="#"
                                    class="btn btn-sm rounded-pill px-3 py-1 fw-medium filter-pill text-secondary"
                                    data-range="today">Today</a>
                                <a href="#"
                                    class="btn btn-sm rounded-pill px-3 py-1 fw-medium filter-pill text-secondary"
                                    data-range="month">Month</a>
                                <div class="vr mx-1 text-muted"></div>
                                <a href="#" class="btn btn-sm rounded-pill px-3 py-1 fw-medium text-secondary"
                                    data-bs-toggle="modal" data-bs-target="#dateRangeModal">
                                    <i class="fas fa-calendar-alt"></i>
                                </a>
                            </div>
                        </div>

                        <!-- Overview Earnings Cards -->
                        <div class="row mb-5 mt-4" id="payout-stats-container">
                            <!-- Skeleton loaders -->
                            <div class="col-xl-3 col-md-6 mb-4">
                                <div class="glass-panel skeleton" style="height: 140px;"></div>
                            </div>
                            <div class="col-xl-3 col-md-6 mb-4">
                                <div class="glass-panel skeleton" style="height: 140px;"></div>
                            </div>
                            <div class="col-xl-3 col-md-6 mb-4">
                                <div class="glass-panel skeleton" style="height: 140px;"></div>
                            </div>
                            <div class="col-xl-3 col-md-6 mb-4">
                                <div class="glass-panel skeleton" style="height: 140px;"></div>
                            </div>
                        </div>

                        <!-- Tab Navigation -->
                        <ul class="nav nav-pills mb-4 d-flex flex-wrap gap-2" id="payoutsTab" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button
                                    class="nav-link rounded-pill px-4 fw-bold d-flex align-items-center gap-2 active"
                                    id="current-week-tab" data-bs-toggle="tab" data-bs-target="#current-week-pane"
                                    type="button" role="tab" aria-controls="current-week-pane" aria-selected="true">
                                    <div class="icon-circle bg-light text-primary me-1"><i class="fas fa-wallet"></i>
                                    </div>
                                    Current Week
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button
                                    class="nav-link rounded-pill px-4 fw-bold d-flex align-items-center gap-2 text-secondary"
                                    id="history-tab" data-bs-toggle="tab" data-bs-target="#history-pane" type="button"
                                    role="tab" aria-controls="history-pane" aria-selected="false">
                                    <div class="icon-circle bg-light text-secondary me-1"><i class="fas fa-history"></i>
                                    </div>
                                    Payout History
                                </button>
                            </li>
                        </ul>

                        <div class="tab-content" id="payoutsTabContent">
                            <!-- Current Week Tab Pane -->
                            <div class="tab-pane fade show active" id="current-week-pane" role="tabpanel"
                                aria-labelledby="current-week-tab" tabindex="0">
                                <div class="glass-panel mb-4 p-0 overflow-hidden">
                                    <div
                                        class="p-4 d-flex justify-content-between align-items-center flex-wrap border-bottom border-light app-header-panel bg-gradient-soft-primary">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="icon-box bg-gradient-primary-zenith text-white rounded-circle d-flex align-items-center justify-content-center"
                                                style="width: 48px; height: 48px; box-shadow: 0 4px 6px rgba(79, 70, 229, 0.2);">
                                                <i class="fas fa-wallet"></i>
                                            </div>
                                            <div>
                                                <h5 class="mb-0 fw-bold text-dark">Pending Weekly Payouts</h5>
                                                <p class="mb-0 text-muted small">Pay riders for the current week's
                                                    earnings</p>
                                            </div>
                                        </div>

                                        <!-- Soft Filters (Pills) -->
                                        <div
                                            class="d-flex align-items-center gap-2 mt-3 mt-md-0 bg-white p-1 rounded-pill shadow-sm border border-light">
                                            <a href="#"
                                                class="btn btn-sm rounded-pill px-3 py-1 fw-medium filter-pill active"
                                                data-range="week">This Week</a>
                                            <a href="#"
                                                class="btn btn-sm rounded-pill px-3 py-1 fw-medium filter-pill text-secondary"
                                                data-range="today">Today</a>
                                            <a href="#"
                                                class="btn btn-sm rounded-pill px-3 py-1 fw-medium filter-pill text-secondary"
                                                data-range="month">Month</a>
                                        </div>
                                    </div>

                                    <div class="zenith-table-container p-3">
                                        <div class="table-responsive">
                                            <table class="zenith-table align-middle" id="currentWeekTable">
                                                <thead>
                                                    <tr>
                                                        <th class="ps-4">Rider Info</th>
                                                        <th>Contact</th>
                                                        <th class="text-center">Active Orders</th>
                                                        <th class="text-end">Current Earnings</th>
                                                        <th class="text-center pe-4">Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="currentWeekTableBody">
                                                    <tr>
                                                        <td colspan="5" class="text-center p-5">
                                                            <div class="spinner-border text-primary" role="status">
                                                                <span class="visually-hidden">Loading current week
                                                                    payouts...</span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- History Tab Pane -->
                            <div class="tab-pane fade" id="history-pane" role="tabpanel" aria-labelledby="history-tab"
                                tabindex="0">
                                <div class="glass-panel mb-4 p-0 overflow-hidden">
                                    <div
                                        class="p-4 d-flex justify-content-between align-items-center flex-wrap border-bottom border-light app-header-panel">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="icon-box bg-white text-secondary rounded-circle d-flex align-items-center justify-content-center shadow-sm"
                                                style="width: 48px; height: 48px;">
                                                <i class="fas fa-file-invoice-dollar"></i>
                                            </div>
                                            <h5 class="mb-0 fw-bold text-dark">Transaction History</h5>
                                        </div>

                                        <div class="d-flex align-items-center gap-2 mt-3 mt-md-0">
                                            <!-- Status Filter for History -->
                                            <div class="dropdown">
                                                <button
                                                    class="btn btn-white shadow-sm dropdown-toggle d-flex align-items-center gap-2 px-3 py-2 border-0"
                                                    type="button" data-bs-toggle="dropdown" aria-expanded="false"
                                                    style="border-radius: 12px; color: var(--text-secondary);">
                                                    <i class="fas fa-filter text-primary"></i> <span
                                                        id="filterStatusText">All Statuses</span>
                                                </button>
                                                <ul class="dropdown-menu dropdown-menu-end border-0 shadow-lg p-2"
                                                    style="border-radius: 16px;">
                                                    <li><a class="dropdown-item filter-payout rounded-3 px-3 py-2"
                                                            href="#" data-filter="all">All Statuses</a></li>
                                                    <li><a class="dropdown-item filter-payout rounded-3 px-3 py-2"
                                                            href="#" data-filter="paid">Paid</a></li>
                                                    <li><a class="dropdown-item filter-payout rounded-3 px-3 py-2"
                                                            href="#" data-filter="failed">Failed</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="zenith-table-container p-3">
                                        <div class="table-responsive">
                                            <table class="zenith-table align-middle" id="historyTable">
                                                <thead>
                                                    <tr>
                                                        <th class="ps-4">Transaction ID</th>
                                                        <th>Date</th>
                                                        <th>Rider</th>
                                                        <th class="text-center">Status</th>
                                                        <th class="text-end">Amount Paid</th>
                                                        <th class="text-center pe-4">Details</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="historyTableBody">
                                                    <!-- Populated by JS -->
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div
                                        class="p-4 d-flex justify-content-between align-items-center border-top border-light">
                                        <span id="pagination-info" class="text-muted small fw-medium"></span>
                                        <nav>
                                            <ul class="pagination mb-0 gap-2" id="pagination-controls">
                                                <!-- Pagination controls generated by JS -->
                                            </ul>
                                        </nav>
                                    </div>
                                </div>
                            </div>
                        </div>
                </main>

                <!-- Rider Details Offcanvas (Slide-Over) -->
                <div class="offcanvas offcanvas-end" tabindex="-1" id="riderDetailsOffcanvas"
                    aria-labelledby="riderDetailsLabel"
                    style="width: 500px; border-left: none; box-shadow: -10px 0 30px rgba(0,0,0,0.1);">
                    <div class="offcanvas-header bg-gradient-soft-primary border-bottom border-light p-4">
                        <div class="d-flex align-items-center gap-3">
                            <div id="offcanvasRiderAvatar" class="rider-avatar shadow-sm"
                                style="width: 56px; height: 56px; font-size: 1.2rem;">RK</div>
                            <div>
                                <h5 class="offcanvas-title fw-bold text-dark mb-0" id="offcanvasRiderName">Raju Kumar
                                </h5>
                                <div class="d-flex align-items-center gap-2">
                                    <small class="text-muted" id="offcanvasRiderId">R001</small>
                                    <span class="badge bg-white text-success border border-success rounded-pill px-2"
                                        id="offcanvasRiderStatus">Active</span>
                                </div>
                            </div>
                        </div>
                        <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas"
                            aria-label="Close"></button>
                    </div>
                    <div class="offcanvas-body p-0 bg-white">
                        <!-- Quick Stats -->
                        <div class="row g-0 border-bottom border-light">
                            <div class="col-6 p-4 border-end border-light">
                                <small class="text-muted text-uppercase fw-bold"
                                    style="font-size: 0.7rem; letter-spacing: 0.05em;">Total Paid</small>
                                <h4 class="mb-0 fw-bold text-dark mt-1" id="offcanvasTotalPaid">₹1,25,000</h4>
                            </div>
                            <div class="col-6 p-4">
                                <small class="text-muted text-uppercase fw-bold"
                                    style="font-size: 0.7rem; letter-spacing: 0.05em;">Pending</small>
                                <h4 class="mb-0 fw-bold text-danger mt-1" id="offcanvasPendingAmount">₹4,500</h4>
                            </div>
                        </div>

                        <!-- Filters -->
                        <div class="p-3 bg-light border-bottom border-light d-flex gap-2 sticky-top"
                            style="z-index: 10;">
                            <button
                                class="btn btn-sm btn-white border shadow-sm rounded-pill px-3 active fw-bold text-primary">All
                                Time</button>
                            <button class="btn btn-sm btn-white border shadow-sm rounded-pill px-3 text-secondary">This
                                Month</button>
                            <button class="btn btn-sm btn-white border shadow-sm rounded-pill px-3 text-secondary">Last
                                Month</button>
                        </div>

                        <!-- Detail List -->
                        <div class="p-0">
                            <div id="riderHistoryList" class="list-group list-group-flush">
                                <!-- Populated by JS -->
                                <div class="text-center p-5">
                                    <div class="spinner-border text-primary" role="status"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="offcanvas-footer p-3 border-top border-light bg-light">
                        <button class="btn btn-zenith-primary w-100 shadow-sm py-2">
                            <i class="fas fa-file-download me-2"></i> Download Statement
                        </button>
                    </div>
                </div>

                <!-- Process Payout Modal -->
                <div class="modal fade" id="processPayoutModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header bg-primary text-white">
                                <h5 class="modal-title">Process Payout</h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <p>You are about to process a payout for:</p>
                                <div class="mb-3">
                                    <strong>Rider:</strong> <span id="payoutRiderName"></span><br>
                                    <strong>Pending Amount:</strong> <span class="fw-bold text-success fs-5"
                                        id="payoutAmount"></span>
                                </div>
                                <div class="mb-3">
                                    <label for="transactionId" class="form-label">Transaction ID / Reference <span
                                            class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="transactionId"
                                        placeholder="Enter transaction reference number" required>
                                    <div class="invalid-feedback">A transaction ID is required.</div>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value=""
                                        id="payoutConfirmationCheck">
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
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="button" class="btn btn-primary" id="applyDateRange">Apply</button>
                            </div>
                        </div>
                    </div>
                </div>

                <%@ include file="/includes/footer.jsp" %>

                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/resources/css/deliveryBoy-earnings.css">
                    <script src="${pageContext.request.contextPath}/resources/js/deliveryBoy-earnings.js"></script>