<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/header.jsp" %>

<%-- Toast notifications for success and error messages --%>
<div class="toast-container position-fixed bottom-0 end-0 p-3">
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
    <div class="container-fluid">
        <div class="page-header pt-2 d-flex justify-content-between align-items-center">
            <h1>Rider Profile</h1>
            <a href="${pageContext.request.contextPath}/deliveryBoy-manage" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to List
            </a>
        </div>

        <%-- Loading spinner shown during initial data fetch --%>
        <div id="loading-spinner" class="text-center py-5">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-2">Loading Rider Details...</p>
        </div>

        <%-- Main content area, hidden until data is loaded --%>
        <div id="rider-content" class="d-none">
            <!-- Rider Header -->
            <div class="card mb-4">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col-md-2 text-center">
                            <img id="riderSelfie" src="" class="img-fluid rounded-circle" alt="Rider Selfie" style="width: 120px; height: 120px; object-fit: cover;">
                        </div>
                        <div class="col-md-5">
                            <h2 id="riderName" class="mb-0"></h2>
                            <p class="text-muted mb-1">ID: <span id="riderId"></span></p>
                            <div class="mt-2">
                                <span id="riderStatus" class="badge"></span>
                            </div>
                        </div>
                        <div class="col-md-5 text-md-end mt-3 mt-md-0">
                             <a id="editRiderBtn" href="#" class="btn btn-secondary"><i class="fas fa-edit me-2"></i>Edit Profile</a>
                        </div>
                    </div>

                    <!-- Admin Actions section for Approve/Reject -->
                    <div id="admin-actions" class="d-none mt-3 pt-3 border-top">
                        <div class="d-flex justify-content-between align-items-center">
                            <div id="rejection-reason-display" class="text-danger small fst-italic d-none"></div>
                            <div class="ms-auto">
                                <button id="approveBtn" class="btn btn-success"><i class="fas fa-check me-2"></i>Approve</button>
                                <button id="rejectBtn" class="btn btn-danger"><i class="fas fa-times me-2"></i>Reject</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tabs for Details -->
            <ul class="nav nav-tabs" id="riderDetailsTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="personal-tab" data-bs-toggle="tab" data-bs-target="#personal" type="button" role="tab">Personal & Vehicle</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="documents-tab" data-bs-toggle="tab" data-bs-target="#documents" type="button" role="tab">Documents</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="wallet-tab" data-bs-toggle="tab" data-bs-target="#wallet" type="button" role="tab">Wallet & Payouts</button>
                </li>
                 <li class="nav-item" role="presentation">
                    <button class="nav-link" id="earnings-tab" data-bs-toggle="tab" data-bs-target="#earnings" type="button" role="tab">Earnings</button>
                </li>
            </ul>

            <div class="tab-content card card-body" id="riderDetailsTabContent">
                <!-- Personal & Vehicle Tab (populated by JS) -->
                <div class="tab-pane fade show active" id="personal" role="tabpanel"></div>

                <!-- Documents Tab (populated by JS) -->
                <div class="tab-pane fade" id="documents" role="tabpanel"></div>

                 <!-- Wallet & Payouts Tab (populated by JS with new APIs) -->
                <div class="tab-pane fade" id="wallet" role="tabpanel"></div>

                <!-- Earnings Tab (populated by JS) -->
                <div class="tab-pane fade" id="earnings" role="tabpanel">
                     <canvas id="weeklyEarningsChart" style="max-height: 400px;"></canvas>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/includes/footer.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/deliveryBoy-manage.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/deliveryBoy-view.js"></script>