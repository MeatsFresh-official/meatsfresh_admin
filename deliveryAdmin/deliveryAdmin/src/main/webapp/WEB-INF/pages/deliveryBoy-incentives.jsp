<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <fmt:setLocale value="en_IN" />
                <%@ include file="/includes/header.jsp" %>

                    <main class="main-content">
                        <div class="container-fluid">
                            <!-- Page Header -->
                            <div class="d-flex justify-content-between align-items-center mb-4 pt-3">
                                <div>
                                    <h1 class="fw-bold text-gradient-primary mb-1">Incentive Programs</h1>
                                    <p class="text-secondary mb-0">Manage and track rider incentives</p>
                                </div>
                                <div>
                                    <button class="btn btn-white shadow-sm border rounded-pill px-3"
                                        onclick="alert('Export feature coming soon')">
                                        <i class="fas fa-download me-2 text-primary"></i>Export Report
                                    </button>
                                </div>
                            </div>

                            <div class="row">
                                <!-- Create Incentive Card -->
                                <div class="col-lg-4 mb-4">
                                    <div class="glass-panel h-100">
                                        <div class="p-4 border-bottom border-light bg-soft-primary">
                                            <h5 class="mb-0 fw-bold text-dark"><i
                                                    class="fas fa-plus-circle me-2 text-primary"></i>Create Incentive
                                            </h5>
                                            <p class="mb-0 text-muted small mt-1">Set targets for riders</p>
                                        </div>
                                        <div class="p-4">
                                            <form id="createIncentiveForm">
                                                <div class="mb-3">
                                                    <label
                                                        class="form-label small fw-bold text-uppercase text-secondary">Order
                                                        Count Target</label>
                                                    <input type="number" class="form-control form-control-lg"
                                                        id="incOrderCount" placeholder="e.g. 50 Orders" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label
                                                        class="form-label small fw-bold text-uppercase text-secondary">Slots
                                                        Required</label>
                                                    <input type="number" class="form-control form-control-lg"
                                                        id="incSlots" placeholder="e.g. 5 Slots" required>
                                                </div>
                                                <div class="mb-4">
                                                    <label
                                                        class="form-label small fw-bold text-uppercase text-secondary">Incentive
                                                        Amount (₹)</label>
                                                    <div class="input-group">
                                                        <span class="input-group-text bg-white border-end-0">₹</span>
                                                        <input type="number"
                                                            class="form-control form-control-lg border-start-0 ps-0"
                                                            id="incAmount" placeholder="0.00" required>
                                                    </div>
                                                </div>
                                                <button type="submit"
                                                    class="btn btn-zenith-primary w-100 py-2 shadow-sm fw-bold">
                                                    Create Incentive
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <!-- Active Incentives Grid -->
                                <div class="col-lg-8 mb-4">
                                    <div class="glass-panel h-100">
                                        <div
                                            class="p-4 border-bottom border-light d-flex justify-content-between align-items-center">
                                            <h5 class="mb-0 fw-bold text-dark">Active Programs</h5>
                                            <span class="badge bg-soft-success text-success rounded-pill px-3">Live
                                                Now</span>
                                        </div>
                                        <div class="p-4">
                                            <div class="row g-3" id="activeIncentivesGrid">
                                                <!-- Populated by JS -->
                                                <div class="text-center p-5 col-12 text-muted">No active incentives.
                                                    Creates one to get started.</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Incentive History Table -->
                            <div class="glass-panel mb-5 p-0 overflow-hidden">
                                <div
                                    class="p-4 border-bottom border-light bg-light d-flex justify-content-between align-items-center">
                                    <div>
                                        <h5 class="mb-0 fw-bold text-dark">Incentive Achievement History</h5>
                                        <p class="mb-0 text-muted small">Rider performance for the current period</p>
                                    </div>
                                    <!-- Simple Filter for History -->
                                    <div class="d-flex gap-2 bg-white p-1 rounded-pill shadow-sm border border-light">
                                        <button
                                            class="btn btn-sm rounded-pill px-3 py-1 fw-bold btn-zenith-primary active filter-pill"
                                            data-range="week">This Week</button>
                                        <button
                                            class="btn btn-sm rounded-pill px-3 py-1 fw-medium text-secondary hover-bg-light filter-pill"
                                            data-range="month">Month</button>
                                    </div>
                                </div>
                                <div class="zenith-table-container p-3">
                                    <div class="table-responsive">
                                        <table class="zenith-table align-middle" id="incentiveHistoryTable">
                                            <thead>
                                                <tr>
                                                    <th class="ps-4">Rider</th>
                                                    <th>Incentive Plan</th>
                                                    <th class="text-center">Progress</th>
                                                    <th class="text-center">Status</th>
                                                    <th class="text-end pe-4">Reward</th>
                                                </tr>
                                            </thead>
                                            <tbody id="incentiveHistoryBody">
                                                <!-- Populated by JS -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </main>

                    <!-- Toast/Notification Containers -->
                    <div class="toast-container position-fixed bottom-0 end-0 p-3">
                        <div id="successToast" class="toast align-items-center text-white bg-success border-0"
                            role="alert" aria-live="assertive" aria-atomic="true">
                            <div class="d-flex">
                                <div class="toast-body" id="toastMessage">Success</div>
                                <button type="button" class="btn-close btn-close-white me-2 m-auto"
                                    data-bs-dismiss="toast" aria-label="Close"></button>
                            </div>
                        </div>
                    </div>

                    <%@ include file="/includes/footer.jsp" %>
                        <link rel="stylesheet"
                            href="${pageContext.request.contextPath}/resources/css/deliveryBoy-incentives.css">
                        <script
                            src="${pageContext.request.contextPath}/resources/js/deliveryBoy-incentives.js"></script>