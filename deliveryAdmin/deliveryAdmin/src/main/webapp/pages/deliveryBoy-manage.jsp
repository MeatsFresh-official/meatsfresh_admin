<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <fmt:setLocale value="en_IN" />
                <%@ include file="/includes/header.jsp" %>

                    <!-- Toast/Notification Containers -->
                    <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1070;">
                        <div id="successToast" class="toast align-items-center text-white bg-success border-0"
                            role="alert" aria-live="assertive" aria-atomic="true">
                            <div class="d-flex">
                                <div class="toast-body" id="toastMessage"></div>
                                <button type="button" class="btn-close btn-close-white me-2 m-auto"
                                    data-bs-dismiss="toast" aria-label="Close"></button>
                            </div>
                        </div>
                        <div id="errorToast" class="toast align-items-center text-white bg-danger border-0" role="alert"
                            aria-live="assertive" aria-atomic="true">
                            <div class="d-flex">
                                <div class="toast-body" id="errorMessage"></div>
                                <button type="button" class="btn-close btn-close-white me-2 m-auto"
                                    data-bs-dismiss="toast" aria-label="Close"></button>
                            </div>
                        </div>
                    </div>

                    <main class="main-content">
                        <div class="container-fluid">
                            <!-- Modern Header with Gradient -->
                            <div class="page-header d-flex justify-content-between align-items-center">
                                <div>
                                    <h1 class="text-white mb-2">Delivery Management</h1>
                                    <p class="mb-0 text-white-50">Manage your fleet, track earnings, and optimize
                                        performance.</p>
                                </div>
                                <button class="btn btn-light rounded-pill shadow-sm fw-bold px-4" data-bs-toggle="modal"
                                    data-bs-target="#addRiderModal">
                                    <i class="fas fa-plus me-2 text-primary"></i>New Rider
                                </button>
                            </div>

                            <!-- Glassmorphism Stats Cards -->
                            <div class="row g-4 mb-5">
                                <div class="col-xl-3 col-md-6">
                                    <div
                                        class="card stat-card bg-primary text-white h-100 shadow-lg border-0 rounded-4 overflow-hidden">
                                        <div class="card-body position-relative z-index-1">
                                            <h6 class="text-uppercase fw-bold opacity-75 mb-2">Total Riders</h6>
                                            <h2 class="display-5 fw-bold mb-0">0</h2>
                                            <i
                                                class="fas fa-motorcycle position-absolute end-0 bottom-0 mb-n2 me-3 opacity-25 fa-4x text-white"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xl-3 col-md-6">
                                    <div
                                        class="card stat-card bg-info text-white h-100 shadow-lg border-0 rounded-4 overflow-hidden">
                                        <div class="card-body position-relative z-index-1">
                                            <h6 class="text-uppercase fw-bold opacity-75 mb-2">Active Now</h6>
                                            <h2 class="display-5 fw-bold mb-0">0</h2>
                                            <i
                                                class="fas fa-check-circle position-absolute end-0 bottom-0 mb-n2 me-3 opacity-25 fa-4x text-white"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xl-3 col-md-6">
                                    <div
                                        class="card stat-card bg-warning text-dark h-100 shadow-lg border-0 rounded-4 overflow-hidden">
                                        <div class="card-body position-relative z-index-1">
                                            <h6 class="text-uppercase fw-bold opacity-75 mb-2">Pending Approval</h6>
                                            <h2 class="display-5 fw-bold mb-0">0</h2>
                                            <i
                                                class="fas fa-clock position-absolute end-0 bottom-0 mb-n2 me-3 opacity-25 fa-4x text-dark"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xl-3 col-md-6">
                                    <div
                                        class="card stat-card bg-danger text-white h-100 shadow-lg border-0 rounded-4 overflow-hidden">
                                        <div class="card-body position-relative z-index-1">
                                            <h6 class="text-uppercase fw-bold opacity-75 mb-2">Rejected</h6>
                                            <h2 class="display-5 fw-bold mb-0">0</h2>
                                            <i
                                                class="fas fa-ban position-absolute end-0 bottom-0 mb-n2 me-3 opacity-25 fa-4x text-white"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Zenith Pills Navigation -->
                            <ul class="nav nav-pills-zenith mb-4" id="deliveryBoyTabs" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" id="riders-tab" data-bs-toggle="pill"
                                        data-bs-target="#riders" type="button" role="tab">
                                        <i class="fas fa-list me-2"></i>Rider List
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="shop-tab" data-bs-toggle="pill" data-bs-target="#shop"
                                        type="button" role="tab">
                                        <i class="fas fa-store me-2"></i>Equipment Shop
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="settings-tab" data-bs-toggle="pill"
                                        data-bs-target="#settings" type="button" role="tab">
                                        <i class="fas fa-cogs me-2"></i>Settings
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="reports-tab" data-bs-toggle="pill"
                                        data-bs-target="#reports" type="button" role="tab">
                                        <i class="fas fa-chart-pie me-2"></i>Reports
                                    </button>
                                </li>
                            </ul>

                            <div class="tab-content" id="deliveryBoyTabContent">
                                <!-- RIDER LIST TAB -->
                                <div class="tab-pane fade show active" id="riders" role="tabpanel">
                                    <!-- Toolbar -->
                                    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                                        <div class="search-bar">
                                            <i class="fas fa-search text-muted"></i>
                                            <input type="text" class="search-input"
                                                placeholder="Search by name, ID or phone..." id="riderSearch">
                                        </div>

                                        <div class="d-flex gap-2">
                                            <div class="dropdown">
                                                <button
                                                    class="btn btn-white shadow-sm dropdown-toggle rounded-pill px-3"
                                                    type="button" id="filterDropdown" data-bs-toggle="dropdown"
                                                    aria-expanded="false">
                                                    <i class="fas fa-filter me-2 text-primary"></i>Filter
                                                </button>
                                                <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3 p-3"
                                                    aria-labelledby="filterDropdown" style="width: 250px;">
                                                    <li class="mb-2">
                                                        <label
                                                            class="form-label small text-muted fw-bold">Status</label>
                                                        <select class="form-select form-select-sm" id="statusFilter">
                                                            <option value="">All Statuses</option>
                                                            <option value="ACTIVE">Active</option>
                                                            <option value="INACTIVE">Inactive</option>
                                                            <option value="REJECTED">Rejected</option>
                                                        </select>
                                                    </li>
                                                    <li class="mb-2">
                                                        <label
                                                            class="form-label small text-muted fw-bold">Vehicle</label>
                                                        <select class="form-select form-select-sm" id="vehicleFilter">
                                                            <option value="">All Vehicles</option>
                                                            <option value="ELECTRIC">Electric</option>
                                                            <option value="PETROL">Petrol</option>
                                                        </select>
                                                    </li>
                                                    <li>
                                                        <button class="btn btn-sm btn-light w-100 text-danger mt-2"
                                                            id="resetFiltersBtn">Reset</button>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="filter-tags mb-4" id="activeFilters"></div>

                                    <!-- Rider List Table -->
                                    <div class="zenith-table-container">
                                        <div class="table-responsive">
                                            <table class="zenith-table" id="ridersTable">
                                                <thead>
                                                    <tr>
                                                        <th>Rider</th>
                                                        <th>Contact</th>
                                                        <th>Status</th>
                                                        <th>Vehicle</th>
                                                        <th>Wallet</th>
                                                        <th>Rating</th>
                                                        <th class="text-end">Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <!-- Rows injected via JS -->
                                                    <tr>
                                                        <td colspan="7" class="text-center py-5">
                                                            <div class="spinner-grow text-primary spinner-grow-sm me-2"
                                                                role="status"></div>
                                                            <span class="text-muted">Loading fleet data...</span>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <!-- PAGINATION CONTAINER -->
                                        <div id="ridersPagination"></div>
                                    </div>
                                </div>

                                <!-- SHOP TAB -->
                                <div class="tab-pane fade" id="shop" role="tabpanel">
                                    <div class="d-flex justify-content-between align-items-center mb-4">
                                        <h4 class="fw-bold mb-0">Rider Equipment & Essentials</h4>
                                        <button class="btn btn-primary rounded-pill px-4" data-bs-toggle="modal"
                                            data-bs-target="#addShopItemModal">
                                            <i class="fas fa-plus me-2"></i>Add Product
                                        </button>
                                    </div>
                                    <div class="row g-4" id="shopItemsGrid">
                                        <!-- Shop Items injected here -->
                                    </div>
                                </div>

                                <!-- SETTINGS TAB -->
                                <div class="tab-pane fade" id="settings" role="tabpanel">
                                    <div class="row g-4">
                                        <div class="col-md-12"> <!-- Full width since incentive is removed -->
                                            <div class="card zenith-card h-100">
                                                <div class="card-body p-4">
                                                    <h5 class="fw-bold mb-4 text-primary"><i
                                                            class="fas fa-wallet me-2"></i>Payout Configuration</h5>
                                                    <form id="paymentSettingsForm">
                                                        <!-- Form content same as before but styled -->
                                                        <div class="mb-3">
                                                            <label class="form-label small fw-bold text-muted">Payment
                                                                Mode</label>
                                                            <select class="form-select" name="paymentMode">
                                                                <option value="PER_KM">Per KM Rate</option>
                                                                <option value="PER_ORDER">Per Order Rate</option>
                                                            </select>
                                                        </div>
                                                        <div class="mb-3" id="perKmRateContainer">
                                                            <label class="form-label small fw-bold text-muted">Per KM
                                                                Rate (₹)</label>
                                                            <input type="number" step="0.01" class="form-control"
                                                                name="perKmRate" value="15.00">
                                                        </div>
                                                        <div class="mb-3" id="perOrderRateContainer"
                                                            style="display: none;">
                                                            <label class="form-label small fw-bold text-muted">Per Order
                                                                Rate (₹)</label>
                                                            <input type="number" step="0.01" class="form-control"
                                                                name="perOrderRate" value="30.00">
                                                        </div>
                                                        <div class="mb-3">
                                                            <label
                                                                class="form-label small fw-bold text-muted">Registration
                                                                Fee (₹)</label>
                                                            <input type="number" step="0.01" class="form-control"
                                                                name="registrationFee" value="500.00">
                                                        </div>
                                                        <button type="submit" class="btn btn-primary w-100 mt-3">Save
                                                            Payout Settings</button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- REPORTS TAB -->
                                <div class="tab-pane fade" id="reports" role="tabpanel">
                                    <div class="card zenith-card mb-4">
                                        <div class="card-body p-4">
                                            <div class="d-flex justify-content-between mb-4">
                                                <h5 class="fw-bold">Performance Analytics</h5>
                                                <button class="btn btn-outline-primary rounded-pill btn-sm"
                                                    id="exportReportsBtn">
                                                    <i class="fas fa-download me-2"></i>Export Data
                                                </button>
                                            </div>
                                            <canvas id="performanceChart" height="100"></canvas>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>

                    <!-- ADD RIDER MODAL -->
                    <div class="modal fade" id="addRiderModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-centered">
                            <form class="modal-content" id="addRiderForm" enctype="multipart/form-data">
                                <div class="modal-header border-0 pb-0">
                                    <h5 class="modal-title fw-bold">Onboard New Rider</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <div class="modal-body p-4">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label small fw-bold text-muted">First Name</label>
                                            <input type="text" name="firstName" class="form-control" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-bold text-muted">Last Name</label>
                                            <input type="text" name="lastName" class="form-control" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-bold text-muted">Phone Number</label>
                                            <input type="tel" name="phoneNumber" class="form-control" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-bold text-muted">Vehicle Type</label>
                                            <select name="vehicleType" class="form-select" required>
                                                <option value="ELECTRIC">Electric Scooter</option>
                                                <option value="PETROL">Petrol Bike</option>
                                                <option value="CYCLE">Bicycle</option>
                                            </select>
                                        </div>
                                        <!-- Add more fields as needed but kept minimal for UI demo -->
                                    </div>
                                </div>
                                <div class="modal-footer border-0 pt-0">
                                    <button type="button" class="btn btn-light rounded-pill"
                                        data-bs-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-primary rounded-pill px-4"
                                        id="addRiderSubmitBtn">Create Profile</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- ADD PRODUCT MODAL -->
                    <div class="modal fade" id="addShopItemModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <form class="modal-content" id="addShopItemForm" enctype="multipart/form-data">
                                <div class="modal-header border-0 pb-0">
                                    <h5 class="modal-title fw-bold">Add Equipment</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <div class="modal-body p-4">
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold text-muted">Product Name</label>
                                        <input type="text" name="name" class="form-control" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold text-muted">Price</label>
                                        <input type="number" name="price" class="form-control" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold text-muted">Category</label>
                                        <select name="category" class="form-select" required>
                                            <option value="UNIFORM">Uniform</option>
                                            <option value="EQUIPMENT">Equipment</option>
                                            <option value="ACCESSORIES">Accessories</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="modal-footer border-0 pt-0">
                                    <button type="button" class="btn btn-light rounded-pill"
                                        data-bs-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-primary rounded-pill px-4">Add Item</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <%@ include file="/includes/footer.jsp" %>
                        <link rel="stylesheet"
                            href="${pageContext.request.contextPath}/resources/css/deliveryBoy-manage.css">
                        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                        <script src="${pageContext.request.contextPath}/resources/js/pagination-utils.js"></script>
                        <script src="${pageContext.request.contextPath}/resources/js/deliveryBoy-manage.js"></script>