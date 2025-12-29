<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="en_IN" />
<%@ include file="/includes/header.jsp" %>

<!-- Toast/Notification Containers -->
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
        <div class="page-header pt-2">
            <h1>Delivery Boy Management</h1>
        </div>

        <!-- Overview Cards -->
        <div class="row mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="card bg-primary text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Total Riders</h6>
                                <h3 class="mb-0">0</h3>
                            </div>
                            <i class="fas fa-motorcycle fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-warning text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Pending Approval</h6>
                                <h3 class="mb-0">0</h3>
                            </div>
                            <i class="fas fa-clock fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-success text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Active Riders</h6>
                                <h3 class="mb-0">0</h3>
                            </div>
                            <i class="fas fa-check-circle fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-danger text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Rejected</h6>
                                <h3 class="mb-0">0</h3>
                            </div>
                            <i class="fas fa-times-circle fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content Tabs -->
        <div class="card mb-4">
            <div class="card-header">
                <ul class="nav nav-tabs card-header-tabs" id="deliveryBoyTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="riders-tab" data-bs-toggle="tab"
                                data-bs-target="#riders" type="button" role="tab">
                            <i class="fas fa-list me-2"></i>Rider List
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="settings-tab" data-bs-toggle="tab"
                                data-bs-target="#settings" type="button" role="tab">
                            <i class="fas fa-cog me-2"></i>Settings
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="shop-tab" data-bs-toggle="tab"
                                data-bs-target="#shop" type="button" role="tab">
                            <i class="fas fa-store me-2"></i>Rider Shop
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="reports-tab" data-bs-toggle="tab"
                                data-bs-target="#reports" type="button" role="tab">
                            <i class="fas fa-chart-bar me-2"></i>Reports
                        </button>
                    </li>
                </ul>
            </div>

            <div class="card-body tab-content" id="deliveryBoyTabContent">
                <!-- Rider List Tab -->
                <div class="tab-pane fade show active" id="riders" role="tabpanel">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="col-md-6">
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addRiderModal">
                                <i class="fas fa-plus me-2"></i>Add New Rider
                            </button>
                        </div>
                        <div class="col-md-6">
                            <div class="input-group mb-2">
                                <input type="text" class="form-control" placeholder="Search riders..." id="riderSearch">
                                <button class="btn btn-outline-secondary" type="button" id="searchRiderBtn">
                                    <i class="fas fa-search"></i>
                                </button>
                                <button class="btn btn-outline-secondary dropdown-toggle" type="button"
                                        id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-filter"></i>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterDropdown">
                                    <li><h6 class="dropdown-header">Filter Options</h6></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <div class="px-3 py-1">
                                            <label class="form-label small">Status</label>
                                            <select class="form-select form-select-sm" id="statusFilter">
                                                <option value="">All Statuses</option>
                                                <option value="ACTIVE">Active</option>
                                                <option value="INACTIVE">Inactive</option>
                                                <option value="REJECTED">Rejected</option>
                                            </select>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="px-3 py-1">
                                            <label class="form-label small">Vehicle Type</label>
                                            <select class="form-select form-select-sm" id="vehicleFilter">
                                                <option value="">All Vehicles</option>
                                                <option value="ELECTRIC">Electric</option>
                                                <option value="PETROL">Petrol</option>
                                            </select>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="px-3 py-1">
                                            <label class="form-label small">Rating</label>
                                            <select class="form-select form-select-sm" id="ratingFilter">
                                                <option value="">All Ratings</option>
                                                <option value="5">5 Stars</option>
                                                <option value="4">4+ Stars</option>
                                                <option value="3">3+ Stars</option>
                                                <option value="2">2+ Stars</option>
                                                <option value="1">1+ Stars</option>
                                            </select>
                                        </div>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <button class="dropdown-item text-danger" type="button" id="resetFiltersBtn">
                                            <i class="fas fa-times me-2"></i>Reset Filters
                                        </button>
                                    </li>
                                </ul>
                            </div>
                            <div class="filter-tags" id="activeFilters"></div>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover" id="ridersTable">
                            <thead>
                                <tr>
                                    <th>Rider</th>
                                    <th>Status</th>
                                    <th>Phone</th>
                                    <th>Vehicle</th>
                                    <th>Wallet Balance</th>
                                    <th>Rating</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td colspan="7" class="text-center">
                                        <i class="fas fa-spinner fa-spin me-2"></i>Loading riders...
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Settings Tab -->
                <div class="tab-pane fade" id="settings" role="tabpanel">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h5 class="mb-0">Payment Settings</h5>
                                </div>
                                <div class="card-body">
                                    <form id="paymentSettingsForm">
                                        <div class="mb-3">
                                            <label class="form-label">Payment Mode</label>
                                            <select class="form-select" name="paymentMode">
                                                <option value="PER_KM">Per KM Rate</option>
                                                <option value="PER_ORDER">Per Order Rate</option>
                                            </select>
                                        </div>
                                        <div class="mb-3" id="perKmRateContainer">
                                            <label class="form-label">Per KM Rate</label>
                                            <div class="input-group">
                                                <span class="input-group-text">₹</span>
                                                <input type="number" step="0.01" class="form-control"
                                                       name="perKmRate" value="15.00">
                                                <span class="input-group-text">per km</span>
                                            </div>
                                        </div>
                                        <div class="mb-3" id="perOrderRateContainer" style="display: none;">
                                            <label class="form-label">Per Order Rate</label>
                                            <div class="input-group">
                                                <span class="input-group-text">₹</span>
                                                <input type="number" step="0.01" class="form-control"
                                                       name="perOrderRate" value="30.00">
                                                <span class="input-group-text">per order</span>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Registration Fee</label>
                                            <div class="input-group">
                                                <span class="input-group-text">₹</span>
                                                <input type="number" step="0.01" class="form-control"
                                                       name="registrationFee" value="500.00">
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Cash Deposit Limit</label>
                                            <div class="input-group">
                                                <span class="input-group-text">₹</span>
                                                <input type="number" step="0.01" class="form-control"
                                                       name="cashDepositLimit" value="5000.00">
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Minimum Cash Deposit Frequency</label>
                                            <select class="form-select" name="cashDepositFrequency">
                                                <option value="DAILY">Daily</option>
                                                <option value="WEEKLY">Weekly</option>
                                                <option value="BIWEEKLY">Bi-Weekly</option>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn btn-primary">Save Settings</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">Incentive Programs</h5>
                                </div>
                                <div class="card-body">
                                    <form id="incentiveSettingsForm">
                                        <div class="mb-3">
                                            <label class="form-label">Monthly Delivery Target</label>
                                            <div class="input-group">
                                                <input type="number" class="form-control"
                                                       name="monthlyTarget" value="100">
                                                <span class="input-group-text">deliveries</span>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Target Bonus</label>
                                            <div class="input-group">
                                                <span class="input-group-text">₹</span>
                                                <input type="number" step="0.01" class="form-control"
                                                       name="targetBonus" value="2000.00">
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Super Performance Bonus</label>
                                            <div class="input-group">
                                                <span class="input-group-text">₹</span>
                                                <input type="number" step="0.01" class="form-control"
                                                       name="superBonus" value="5000.00">
                                                <span class="input-group-text">for 150% of target</span>
                                            </div>
                                        </div>
                                        <button type="submit" class="btn btn-primary">Save Incentives</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Rider Shop Tab -->
                <div class="tab-pane fade" id="shop" role="tabpanel">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="mb-0">Rider Equipment Shop</h5>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addShopItemModal">
                            <i class="fas fa-plus me-2"></i>Add Product
                        </button>
                    </div>

                    <div class="row">
                        <!-- Shop products will be loaded here by JS -->
                    </div>
                </div>

                <!-- Reports Tab -->
                <div class="tab-pane fade" id="reports" role="tabpanel">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="d-flex">
                            <div class="dropdown me-2">
                                <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="reportsTimeRangeDropdown"
                                        data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-calendar me-2"></i>
                                    <span id="selectedTimeRange">Last 30 Days</span>
                                </button>
                                <ul class="dropdown-menu" aria-labelledby="reportsTimeRangeDropdown">
                                    <li><a class="dropdown-item time-range-option" href="#" data-range="today">Today</a></li>
                                    <li><a class="dropdown-item time-range-option" href="#" data-range="week">Last Week</a></li>
                                    <li><a class="dropdown-item time-range-option" href="#" data-range="month">Last 30 Days</a></li>
                                </ul>
                            </div>
                            <button class="btn btn-outline-secondary" id="dateRangePickerBtn" data-bs-toggle="modal"
                                    data-bs-target="#dateRangeModal">
                                <i class="fas fa-calendar-alt me-2"></i>
                                <span id="dateRangeDisplay">Select Date Range</span>
                            </button>
                        </div>
                        <button class="btn btn-success" id="exportReportsBtn">
                            <i class="fas fa-file-export me-2"></i>Export Report
                        </button>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h5 class="mb-0">Monthly Performance (Last 6 Months)</h5>
                                </div>
                                <div class="card-body">
                                    <canvas id="performanceChart" height="300"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h5 class="mb-0">Rider Status Distribution</h5>
                                </div>
                                <div class="card-body">
                                    <canvas id="statusChart" height="300"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">Incentive Performance</h5>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-sm">
                                            <thead>
                                                <tr>
                                                    <th>Rider</th>
                                                    <th>Deliveries</th>
                                                    <th>Target</th>
                                                    <th>Completion</th>
                                                    <th>Earned Bonus</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                               <!-- Incentive reports loaded via JS -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Add Rider Modal -->
<div class="modal fade" id="addRiderModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <form class="modal-content" id="addRiderForm" enctype="multipart/form-data">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Add New Delivery Rider</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="firstName" class="form-label">First Name <span class="text-danger">*</span></label>
                            <input type="text" id="firstName" name="firstName" class="form-control" required>
                            <div class="invalid-feedback d-none">Please provide a valid first name.</div>
                        </div>
                        <div class="mb-3">
                            <label for="lastName" class="form-label">Last Name <span class="text-danger">*</span></label>
                            <input type="text" id="lastName" name="lastName" class="form-control" required>
                            <div class="invalid-feedback d-none">Please provide a valid last name.</div>
                        </div>
                        <div class="mb-3">
                            <label for="gender" class="form-label">Gender <span class="text-danger">*</span></label>
                            <select id="gender" name="gender" class="form-select" required>
                                <option value="">Select Gender</option>
                                <option value="MALE">Male</option>
                                <option value="FEMALE">Female</option>
                                <option value="OTHER">Other</option>
                            </select>
                            <div class="invalid-feedback d-none">Please select a gender.</div>
                        </div>
                        <div class="mb-3">
                            <label for="phoneNumber" class="form-label">Phone Number <span class="text-danger">*</span></label>
                            <input type="tel" id="phoneNumber" name="phoneNumber" class="form-control" required>
                            <div class="invalid-feedback d-none">Please provide a valid phone number.</div>
                        </div>
                        <div class="mb-3">
                            <label for="workingType" class="form-label">Working Type <span class="text-danger">*</span></label>
                            <select id="workingType" name="workingType" class="form-select" required>
                                <option value="">Select Working Type</option>
                                <option value="FULL_TIME">Full Time</option>
                                <option value="PART_TIME">Part Time</option>
                            </select>
                            <div class="invalid-feedback d-none">Please select a working type.</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="vehicleType" class="form-label">Vehicle Type <span class="text-danger">*</span></label>
                            <select id="vehicleType" name="vehicleType" class="form-select" required>
                                <option value="">Select Vehicle</option>
                                <option value="ELECTRIC">Electric</option>
                                <option value="PETROL">Petrol</option>
                            </select>
                            <div class="invalid-feedback d-none">Please select a vehicle type.</div>
                        </div>
                        <div class="mb-3">
                            <label for="vehicleRegistrationNumber" class="form-label">Vehicle Registration Number <span class="text-danger">*</span></label>
                            <input type="text" id="vehicleRegistrationNumber" name="vehicleRegistrationNumber" class="form-control" required>
                            <div class="invalid-feedback d-none">Please provide a valid vehicle number.</div>
                        </div>
                        <div class="mb-3">
                            <label for="preferredDeliveryZone" class="form-label">Preferred Delivery Zone <span class="text-danger">*</span></label>
                            <input type="text" id="preferredDeliveryZone" name="preferredDeliveryZone" class="form-control" required>
                            <div class="invalid-feedback d-none">Please provide a preferred zone.</div>
                        </div>
                        <div class="mb-3">
                            <label for="preferredPaymentMethod" class="form-label">Preferred Payment Method <span class="text-danger">*</span></label>
                            <select id="preferredPaymentMethod" name="preferredPaymentMethod" class="form-select" required>
                                <option value="">Select Payment Method</option>
                                <option value="CASH_ON_DELIVERY">Cash on Delivery</option>
                                <option value="ONLINE">Online Payment</option>
                            </select>
                            <div class="invalid-feedback d-none">Please select a payment method.</div>
                        </div>
                        <div class="mb-3">
                            <label for="tShirtSize" class="form-label">T-Shirt Size <span class="text-danger">*</span></label>
                            <select id="tShirtSize" name="tShirtSize" class="form-select" required>
                                <option value="">Select Size</option>
                                <option value="S">Small</option>
                                <option value="M">Medium</option>
                                <option value="L">Large</option>
                                <option value="XL">XL</option>
                                <option value="XXL">XXL</option>
                            </select>
                            <div class="invalid-feedback d-none">Please select a t-shirt size.</div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <h5 class="mb-3">Bank Details</h5>
                        <div class="mb-3">
                            <label for="bankAccountNumber" class="form-label">Bank Account Number <span class="text-danger">*</span></label>
                            <input type="text" name="bankAccountNumber" id="bankAccountNumber" class="form-control" required>
                            <div class="invalid-feedback d-none">Please provide a valid bank account number.</div>
                        </div>
                        <div class="mb-3">
                            <label for="confirmBankAccountNumber" class="form-label">Confirm Bank Account Number <span class="text-danger">*</span></label>
                            <input type="text" name="confirmBankAccountNumber" class="form-control" required>
                            <div class="invalid-feedback d-none">Bank account numbers do not match.</div>
                        </div>
                        <div class="mb-3">
                            <label for="bankAccountHolderName" class="form-label">Bank Account Holder Name <span class="text-danger">*</span></label>
                            <input type="text" id="bankAccountHolderName" name="bankAccountHolderName" class="form-control" required>
                            <div class="invalid-feedback d-none">Please provide the account holder's name.</div>
                        </div>
                        <div class="mb-3">
                            <label for="ifscCode" class="form-label">IFSC Code <span class="text-danger">*</span></label>
                            <input type="text" id="ifscCode" name="ifscCode" class="form-control" required>
                            <div class="invalid-feedback d-none">Please provide a valid IFSC code.</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <h5 class="mb-3">Location Details</h5>
                        <div class="mb-3">
                            <label for="countryId" class="form-label">Country <span class="text-danger">*</span></label>
                            <select id="countryId" name="countryId" class="form-select" required>
                                <option value="">Select Country</option>
                            </select>
                            <div class="invalid-feedback d-none">Please select a country.</div>
                        </div>
                        <div class="mb-3">
                            <label for="stateId" class="form-label">State <span class="text-danger">*</span></label>
                            <select id="stateId" name="stateId" class="form-select" disabled required>
                                <option value="">Select State</option>
                            </select>
                            <div class="invalid-feedback d-none">Please select a state.</div>
                        </div>
                        <div class="mb-3">
                            <label for="districtId" class="form-label">District <span class="text-danger">*</span></label>
                            <select id="districtId" name="districtId" class="form-select" disabled required>
                                <option value="">Select District</option>
                            </select>
                            <div class="invalid-feedback d-none">Please select a district.</div>
                        </div>
                        <div class="mb-3">
                            <label for="cityId" class="form-label">City <span class="text-danger">*</span></label>
                            <select id="cityId" name="cityId" class="form-select" disabled required>
                                <option value="">Select City</option>
                            </select>
                            <div class="invalid-feedback d-none">Please select a city.</div>
                        </div>
                        <div class="mb-3">
                            <label for="zipCode" class="form-label">Zip Code <span class="text-danger">*</span></label>
                            <input type="text" id="zipCode" name="zipCode" value="242003" class="form-control" required>
                            <div class="invalid-feedback d-none">Please provide a valid zip code.</div>
                        </div>
                    </div>
                </div>
                <hr>
                <div class="row">
                    <div class="col-12"><h5 class="mb-3">Document Uploads</h5></div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="drivingLicenseNumber" class="form-label">Driving License Number <span class="text-danger">*</span></label>
                            <input type="text" id="drivingLicenseNumber" name="drivingLicenseNumber" class="form-control" required>
                            <div class="invalid-feedback d-none">Please provide a valid license number.</div>
                        </div>
                        <div class="mb-3">
                            <label for="drivingLicensePhoto" class="form-label">Driving License Photo <span class="text-danger">*</span></label>
                            <input type="file" id="drivingLicensePhoto" name="drivingLicensePhoto" class="form-control" required accept="image/*">
                            <div class="invalid-feedback d-none">Please upload a license photo.</div>
                        </div>
                        <div class="mb-3">
                            <label for="aadhaarFrontPhoto" class="form-label">Aadhaar Front Photo <span class="text-danger">*</span></label>
                            <input type="file" id="aadhaarFrontPhoto" name="aadhaarFrontPhoto" class="form-control" required accept="image/*">
                            <div class="invalid-feedback d-none">Please upload the front of the Aadhaar card.</div>
                        </div>
                        <div class="mb-3">
                            <label for="aadhaarBackPhoto" class="form-label">Aadhaar Back Photo <span class="text-danger">*</span></label>
                            <input type="file" id="aadhaarBackPhoto" name="aadhaarBackPhoto" class="form-control" required accept="image/*">
                            <div class="invalid-feedback d-none">Please upload the back of the Aadhaar card.</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="panPhoto" class="form-label">PAN Photo <span class="text-danger">*</span></label>
                            <input type="file" id="panPhoto" name="panPhoto" class="form-control" required accept="image/*">
                            <div class="invalid-feedback d-none">Please upload a PAN photo.</div>
                        </div>
                        <div class="mb-3">
                            <label for="selfiePhoto" class="form-label">Selfie Photo <span class="text-danger">*</span></label>
                            <input type="file" id="selfiePhoto" name="selfiePhoto" class="form-control" required accept="image/*">
                            <div class="invalid-feedback d-none">Please upload a selfie.</div>
                        </div>
                        <div class="mb-3">
                            <label for="vehiclePhoto" class="form-label">Vehicle Photo <span class="text-danger">*</span></label>
                            <input type="file" id="vehiclePhoto" name="vehiclePhoto" class="form-control" required accept="image/*">
                            <div class="invalid-feedback d-none">Please upload a vehicle photo.</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary" id="addRiderSubmitBtn">Add Rider</button>
            </div>
        </form>
    </div>
</div>

<!-- Add Shop Item Modal -->
<div class="modal fade" id="addShopItemModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <form class="modal-content" id="addShopItemForm" enctype="multipart/form-data">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Add New Product</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Product Name <span class="text-danger">*</span></label>
                    <input type="text" name="name" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" rows="3"></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Price <span class="text-danger">*</span></label>
                    <input type="number" step="0.01" name="price" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Stock Quantity <span class="text-danger">*</span></label>
                    <input type="number" name="stock" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Category <span class="text-danger">*</span></label>
                    <select name="category" class="form-select" required>
                        <option value="">Select Category</option>
                        <option value="UNIFORM">Uniform</option>
                        <option value="EQUIPMENT">Equipment</option>
                        <option value="ACCESSORIES">Accessories</option>
                        <option value="SAFETY">Safety Gear</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Product Image <span class="text-danger">*</span></label>
                    <input type="file" name="image" class="form-control" required accept="image/*">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Add Product</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Shop Item Modal -->
<div class="modal fade" id="editShopItemModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <form class="modal-content" id="editShopItemForm" enctype="multipart/form-data">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Edit Product</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="productId" id="editProductId">
                <div class="mb-3">
                    <label class="form-label">Product Name <span class="text-danger">*</span></label>
                    <input type="text" name="name" id="editProductName" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="description" id="editProductDescription" class="form-control" rows="3"></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Price <span class="text-danger">*</span></label>
                    <input type="number" step="0.01" name="price" id="editProductPrice" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Stock Quantity <span class="text-danger">*</span></label>
                    <input type="number" name="stock" id="editProductStock" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Category <span class="text-danger">*</span></label>
                    <select name="category" id="editProductCategory" class="form-select" required>
                        <option value="">Select Category</option>
                        <option value="UNIFORM">Uniform</option>
                        <option value="EQUIPMENT">Equipment</option>
                        <option value="ACCESSORIES">Accessories</option>
                        <option value="SAFETY">Safety Gear</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Product Image</label>
                    <input type="file" name="image" class="form-control" accept="image/*">
                    <small class="text-muted">Current: <span id="editProductImageName"></span></small>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</div>

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

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteConfirmationModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">Confirm Delete</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p id="deleteConfirmationMessage">Are you sure you want to delete this item?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" id="confirmDeleteBtn">
                    <i class="fas fa-trash me-2"></i>Delete
                </button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/deliveryBoy-manage.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/deliveryBoy-manage.js"></script>