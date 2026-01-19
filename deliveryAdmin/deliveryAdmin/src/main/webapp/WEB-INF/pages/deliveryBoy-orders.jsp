<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <fmt:setLocale value="en_IN" />
                <%@ include file="/includes/header.jsp" %>

                    <main class="main-content">
                        <div class="container-fluid">
                            <!-- Page Header & Global Filters -->
                            <div class="d-flex justify-content-between align-items-center mb-4 pt-3">
                                <div>
                                    <h1 class="fw-bold text-gradient-primary mb-1">Order Management</h1>
                                    <p class="text-secondary mb-0">Track delivery flow and rider performance</p>
                                </div>
                                <div class="d-flex gap-2 bg-white p-1 rounded-pill shadow-sm border border-light">
                                    <button
                                        class="btn btn-sm rounded-pill px-3 py-1 fw-bold btn-zenith-primary active filter-pill"
                                        data-range="today">Today</button>
                                    <button
                                        class="btn btn-sm rounded-pill px-3 py-1 fw-medium text-secondary hover-bg-light filter-pill"
                                        data-range="week">This Week</button>
                                    <button
                                        class="btn btn-sm rounded-pill px-3 py-1 fw-medium text-secondary hover-bg-light filter-pill"
                                        data-range="month">Month</button>
                                    <button class="btn btn-white btn-sm rounded-circle shadow-sm text-secondary"
                                        id="customDateBtn" title="Custom Range"><i
                                            class="fas fa-calendar-alt"></i></button>
                                </div>
                            </div>

                            <!-- Dashboard Stats -->
                            <div class="row mb-4">
                                <div class="col-xl-3 col-md-6 mb-3">
                                    <div class="glass-panel p-4 h-100 position-relative overflow-hidden">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <div class="icon-box bg-gradient-primary-zenith text-white rounded-circle d-flex align-items-center justify-content-center shadow-sm"
                                                style="width: 48px; height: 48px;">
                                                <i class="fas fa-shopping-bag"></i>
                                            </div>
                                            <span class="badge bg-soft-primary rounded-pill">+12%</span>
                                        </div>
                                        <h3 class="fw-bold text-dark mb-1" id="totalOrdersCount">0</h3>
                                        <p class="text-muted small mb-0">Total Orders</p>
                                    </div>
                                </div>
                                <div class="col-xl-3 col-md-6 mb-3">
                                    <div class="glass-panel p-4 h-100 position-relative overflow-hidden">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <div class="icon-box bg-gradient-warning-zenith text-white rounded-circle d-flex align-items-center justify-content-center shadow-sm"
                                                style="width: 48px; height: 48px;">
                                                <i class="fas fa-clock"></i>
                                            </div>
                                            <span class="badge bg-soft-warning rounded-pill">Active</span>
                                        </div>
                                        <h3 class="fw-bold text-dark mb-1" id="pendingOrdersCount">0</h3>
                                        <p class="text-muted small mb-0">Pending Delivery</p>
                                    </div>
                                </div>
                                <div class="col-xl-3 col-md-6 mb-3">
                                    <div class="glass-panel p-4 h-100 position-relative overflow-hidden">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <div class="icon-box bg-gradient-success-zenith text-white rounded-circle d-flex align-items-center justify-content-center shadow-sm"
                                                style="width: 48px; height: 48px;">
                                                <i class="fas fa-check-circle"></i>
                                            </div>
                                        </div>
                                        <h3 class="fw-bold text-dark mb-1" id="completedOrdersCount">0</h3>
                                        <p class="text-muted small mb-0">Completed Orders</p>
                                    </div>
                                </div>
                                <div class="col-xl-3 col-md-6 mb-3">
                                    <div class="glass-panel p-4 h-100 position-relative overflow-hidden">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <div class="icon-box bg-gradient-danger-zenith text-white rounded-circle d-flex align-items-center justify-content-center shadow-sm"
                                                style="width: 48px; height: 48px;">
                                                <i class="fas fa-times-circle"></i>
                                            </div>
                                        </div>
                                        <h3 class="fw-bold text-dark mb-1" id="cancelledOrdersCount">0</h3>
                                        <p class="text-muted small mb-0">Cancelled</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Main Order Table Section -->
                            <div class="glass-panel mb-5 p-0 overflow-hidden">
                                <div
                                    class="p-4 d-flex justify-content-between align-items-center border-bottom border-light bg-light">
                                    <ul class="nav nav-pills gap-2" id="orderTabs" role="tablist">
                                        <li class="nav-item">
                                            <button class="nav-link active rounded-pill px-3 py-1 small fw-bold"
                                                id="all-orders-tab" data-bs-toggle="tab"
                                                data-bs-target="#all-orders">All Orders</button>
                                        </li>
                                        <li class="nav-item">
                                            <button class="nav-link rounded-pill px-3 py-1 small fw-bold"
                                                id="pending-tab" data-bs-toggle="tab"
                                                data-bs-target="#pending">Pending</button>
                                        </li>
                                        <li class="nav-item">
                                            <button class="nav-link rounded-pill px-3 py-1 small fw-bold"
                                                id="completed-tab" data-bs-toggle="tab"
                                                data-bs-target="#completed">Completed</button>
                                        </li>
                                    </ul>
                                    <div class="input-group" style="width: 300px;">
                                        <span class="input-group-text bg-white border-end-0 ps-3"><i
                                                class="fas fa-search text-muted"></i></span>
                                        <input type="text" class="form-control border-start-0 ps-0"
                                            placeholder="Search orders..." id="orderSearch">
                                    </div>
                                </div>

                                <div class="tab-content" id="orderTabContent">
                                    <!-- Use single table structure populated dynamically? Or keep separating tabs? Keeping tabs for structure. -->
                                    <div class="tab-pane fade show active" id="all-orders" role="tabpanel">
                                        <div class="zenith-table-container p-0">
                                            <div class="table-responsive">
                                                <table class="zenith-table align-middle table-hover" id="ordersTable">
                                                    <thead>
                                                        <tr>
                                                            <th class="ps-4">Order ID</th>
                                                            <th>Customer</th>
                                                            <th>Amount</th>
                                                            <th>Location</th>
                                                            <th>Status</th>
                                                            <th>Rider</th>
                                                            <th class="text-center pe-4">Action</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <!-- JS Populated -->
                                                    </tbody>
                                                </table>
                                            </div>
                                            <div id="allOrdersPagination" class="d-flex justify-content-center py-3">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="tab-pane fade" id="pending" role="tabpanel">
                                        <div class="zenith-table-container p-0">
                                            <div class="table-responsive">
                                                <table class="zenith-table align-middle table-hover"
                                                    id="pendingOrdersTable">
                                                    <thead>
                                                        <tr>
                                                            <th class="ps-4">Order ID</th>
                                                            <th>Customer</th>
                                                            <th>Amount</th>
                                                            <th>Location & Distance</th>
                                                            <th>Order Time</th>
                                                            <th class="text-center pe-4">Action</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody><!-- JS --></tbody>
                                                </table>
                                            </div>
                                            <div id="pendingOrdersPagination"
                                                class="d-flex justify-content-center py-3"></div>
                                        </div>
                                    </div>

                                    <div class="tab-pane fade" id="completed" role="tabpanel">
                                        <div class="zenith-table-container p-0">
                                            <div class="table-responsive">
                                                <table class="zenith-table align-middle table-hover"
                                                    id="completedOrdersTable">
                                                    <thead>
                                                        <tr>
                                                            <th class="ps-4">Order ID</th>
                                                            <th>Customer</th>
                                                            <th>Amount</th>
                                                            <th>Completed On</th>
                                                            <th>Rating</th>
                                                            <th class="text-center pe-4">View</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody><!-- JS --></tbody>
                                                </table>
                                            </div>
                                            <div id="completedOrdersPagination"
                                                class="d-flex justify-content-center py-3"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>

                    <!-- Rider/Order Details Offcanvas (Slide-Over) -->
                    <div class="offcanvas offcanvas-end" tabindex="-1" id="orderDetailsOffcanvas"
                        aria-labelledby="orderDetailsLabel" style="width: 450px;">
                        <div class="offcanvas-header px-4 py-3">
                            <h5 class="offcanvas-title fw-bold" id="orderDetailsLabel">Order Details</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="offcanvas"
                                aria-label="Close"></button>
                        </div>
                        <div class="offcanvas-body p-4 bg-light">
                            <!-- Logistics Section -->
                            <div class="glass-panel bg-white p-3 mb-3 shadow-sm border-0">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="badge bg-soft-primary rounded-pill px-3" id="offStatus">PENDING</span>
                                    <span class="text-muted small fw-bold" id="offTime">12:30 PM</span>
                                </div>
                                <h4 class="fw-bold mb-1" id="offOrderId">#ORD-0000</h4>
                                <div class="map-placeholder mb-3 mt-3 shadow-inner">
                                    <div class="map-overlay"></div>
                                    <span
                                        class="fw-medium text-dark bg-white px-3 py-1 rounded-pill shadow-sm position-relative"><i
                                            class="fas fa-map-marker-alt text-danger me-2"></i>Live Tracking</span>
                                </div>

                                <div class="d-flex align-items-center gap-3 mb-3">
                                    <div class="icon-circle bg-soft-warning text-warning"
                                        style="width: 40px; height: 40px;"><i class="fas fa-store"></i></div>
                                    <div>
                                        <h6 class="mb-0 fw-bold text-dark" id="offVendor">Vendor Name</h6>
                                        <small class="text-muted">Pick-up Location</small>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center gap-3">
                                    <div class="icon-circle bg-soft-info text-info" style="width: 40px; height: 40px;">
                                        <i class="fas fa-user"></i></div>
                                    <div>
                                        <h6 class="mb-0 fw-bold text-dark" id="offCustomer">Customer Name</h6>
                                        <small class="text-muted" id="offAddress">Delivery Location</small>
                                    </div>
                                </div>
                            </div>

                            <!-- Financials (The "Heart" Card) -->
                            <h6 class="text-uppercase text-secondary fw-bold small mb-2 ps-1">Financial Breakdown</h6>
                            <div class="financial-card mb-3">
                                <div class="stat-row">
                                    <span class="text-secondary fw-medium">Order Total</span>
                                    <span class="fw-bold text-dark" id="offTotalAmount">₹0.00</span>
                                </div>
                                <div class="stat-row">
                                    <span class="text-secondary fw-medium">Delivery Fee Base</span>
                                    <span class="fw-medium text-dark" id="offBaseFee">₹0.00</span>
                                </div>
                                <div class="stat-row">
                                    <span class="text-secondary fw-medium">Surge/Distance Fee</span>
                                    <span class="fw-medium text-dark" id="offSurgeFee">₹0.00</span>
                                </div>
                                <div class="stat-row bg-soft-success p-2 rounded mt-2 border-0">
                                    <span class="text-success fw-bold"><i class="fas fa-coins me-1"></i> Total
                                        Earnings</span>
                                    <span class="fw-bold text-success" id="offRiderEarnings">₹0.00</span>
                                </div>

                                <div class="d-flex gap-2 mt-3">
                                    <div class="bg-soft-warning p-2 rounded flex-fill text-center">
                                        <small class="d-block text-warning fw-bold text-uppercase"
                                            style="font-size: 0.65rem;">Tip Amount</small>
                                        <span class="fw-bold text-dark" id="offTip">₹0.00</span>
                                    </div>
                                    <div class="bg-soft-primary p-2 rounded flex-fill text-center">
                                        <small class="d-block text-primary fw-bold text-uppercase"
                                            style="font-size: 0.65rem;">Incentive</small>
                                        <span class="fw-bold text-dark" id="offIncentive">₹0.00</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Items List -->
                            <h6 class="text-uppercase text-secondary fw-bold small mb-2 ps-1">Items</h6>
                            <div class="glass-panel p-0 overflow-hidden bg-white">
                                <ul class="list-group list-group-flush" id="offItemsList">
                                    <!-- JS -->
                                </ul>
                            </div>
                        </div>
                        <div class="offcanvas-footer p-3 bg-white border-top">
                            <button class="btn btn-zenith-primary w-100 py-2 shadow-sm fw-bold">Download
                                Invoice</button>
                        </div>
                    </div>

                    <!-- Toast & Scripts -->
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
                            href="${pageContext.request.contextPath}/resources/css/deliveryBoy-orders.css">
                        <script src="${pageContext.request.contextPath}/resources/js/pagination-utils.js"></script>
                        <script src="${pageContext.request.contextPath}/resources/js/deliveryBoy-orders.js"></script>