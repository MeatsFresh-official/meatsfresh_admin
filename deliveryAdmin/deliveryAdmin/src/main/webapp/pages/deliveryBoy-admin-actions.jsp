<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/header.jsp" %>

<!-- Toast/Notification Containers -->
<div class="toast-container position-fixed bottom-0 end-0 p-3">
    <div id="successToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header bg-success text-white">
            <div class="me-auto">Success</div>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body" id="toastMessage"></div>
    </div>
    <div id="errorToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header bg-danger text-white">
            <div class="me-auto">Error</div>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body" id="errorMessage"></div>
    </div>
</div>

<main class="main-content">
    <div class="container-fluid">
        <div class="page-header pt-2 d-flex justify-content-between align-items-center">
            <h1>Admin Actions</h1>
             <div>
                <a id="viewRiderBtn" href="#" class="btn btn-outline-primary">
                    <i class="fas fa-eye me-2"></i>View Profile
                </a>
                <a href="${pageContext.request.contextPath}/deliveryBoy-manage" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Back to List
                </a>
             </div>
        </div>

        <div id="loading-spinner" class="text-center py-5">
             <div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div>
             <p class="mt-2">Loading Rider Details...</p>
        </div>

        <div id="action-container" class="d-none">
            <!-- Rider Header -->
            <div class="card mb-4">
                <div class="card-body">
                    <h4 class="mb-0">Rider: <span id="riderName"></span></h4>
                    <p class="text-muted mb-2">ID: <span id="riderId"></span></p>
                    <div id="riderStatusBadge"></div>
                </div>
            </div>

            <div class="row">
                <!-- Left Column for Actions -->
                <div class="col-lg-6">
                    <!-- Approval Card -->
                    <div>
                        <h5 class="mb-3">Rider Approval</h6>
                        <p id="rejection-reason-display" class="d-none"></p>
                        <div class="d-flex gap-2">
                            <button type="button" id="approveBtn" class="btn btn-success"><i class="fas fa-check me-2"></i>Approve Rider</button>
                            <button type="button" id="rejectBtn" class="btn btn-danger"><i class="fas fa-times me-2"></i>Reject Rider</button>
                        </div>
                    </div>

                    <!-- Payout Card -->
                    <div class="card mb-4">
                        <div class="card-header"><h5 class="mb-0">Process Payout</h5></div>
                        <div class="card-body">
                            <form id="payoutForm">
                                <div class="mb-3">
                                    <label class="form-label">Amount</label>
                                    <input type="number" name="amount" class="form-control" step="0.01" required placeholder="e.g., 1500.00">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Payment Method</label>
                                    <select name="paymentMethod" class="form-select" required>
                                        <option value="ONLINE">Online</option>
                                        <option value="CASH">Cash</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-hand-holding-usd me-2"></i>Process Payout
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Right Column for Wallet -->
                <div class="col-lg-6">
                     <!-- Credit Wallet Card -->
                    <div class="card mb-4">
                        <div class="card-header bg-success text-white"><h5 class="mb-0">Credit Wallet</h5></div>
                        <div class="card-body">
                            <form id="creditWalletForm">
                                <div class="mb-3">
                                    <label class="form-label">Amount</label>
                                    <input type="number" name="amount" class="form-control" step="0.01" required placeholder="e.g., 1000">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Description</label>
                                    <input type="text" name="description" class="form-control" required placeholder="e.g., Performance Bonus">
                                </div>
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-plus me-2"></i>Credit Amount
                                </button>
                            </form>
                        </div>
                    </div>

                    <!-- Debit Wallet Card -->
                    <div class="card mb-4">
                        <div class="card-header bg-danger text-white"><h5 class="mb-0">Debit Wallet</h5></div>
                        <div class="card-body">
                            <form id="debitWalletForm">
                                <div class="mb-3">
                                    <label class="form-label">Amount</label>
                                    <input type="number" name="amount" class="form-control" step="0.01" required placeholder="e.g., 100">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Description</label>
                                    <input type="text" name="description" class="form-control" required placeholder="e.g., Penalty for damaged goods">
                                </div>
                                <button type="submit" class="btn btn-danger">
                                    <i class="fas fa-minus me-2"></i>Debit Amount
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/includes/footer.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/deliveryBoy-manage.css">
<script src="${pageContext.request.contextPath}/resources/js/deliveryBoy-admin-actions.js"></script>