<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/header.jsp" %>

<main class="main-content">
    <div class="container-fluid px-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="pt-4">Shops Management</h1>
        </div>

        <div class="row" id="shop-stats-container">
            <!-- JavaScript will populate this section with stat cards -->
        </div>

        <!--Aggregated Dashboard UI -->
        <div class="card mb-4 animate-on-load">
            <div class="card-header d-flex justify-content-between align-items-center flex-wrap">
                 <h5 class="mb-0"><i class="fas fa-chart-pie me-2"></i>Aggregated Dashboard</h5>
                 <div class="d-flex align-items-center mt-2 mt-md-0">
                    <div class="dropdown me-2">
                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="dashboardDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-calendar-alt me-1"></i> <span>This Month</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dashboardDropdown">
                            <li><a class="dropdown-item dashboard-range" href="#" data-range="today">Today</a></li>
                            <li><a class="dropdown-item dashboard-range" href="#" data-range="week">Last 7 Days</a></li>
                            <li><a class="dropdown-item dashboard-range active" href="#" data-range="month">This Month</a></li>
                        </ul>
                    </div>
                    <button class="btn btn-sm btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#dateRangeModal">
                        <i class="fas fa-calendar-check me-1"></i> Custom Range
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div class="row" id="vendor-dashboard-stats">
                    <!-- SKELETON LOADER FOR THE NEW DASHBOARD LAYOUT -->
                    <div class="col-lg-5 mb-4 mb-lg-0">
                         <div class="card skeleton w-100" style="height: 240px;"></div>
                    </div>
                    <div class="col-lg-7">
                        <div class="row g-3">
                            <div class="col-md-6"><div class="card skeleton w-100" style="height: 80px;"></div></div>
                            <div class="col-md-6"><div class="card skeleton w-100" style="height: 80px;"></div></div>
                            <div class="col-md-6"><div class="card skeleton w-100" style="height: 80px;"></div></div>
                            <div class="col-md-6"><div class="card skeleton w-100" style="height: 80px;"></div></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <!-- Main Shops Table Card -->
        <div class="card mb-4 animate-on-load" style="animation-delay: 0.2s;">
            <div class="card-header d-flex justify-content-between align-items-center flex-wrap">
                <h5 class="mb-0"><i class="fas fa-store me-2"></i>All Shops</h5>
                <!-- Global Search with Button -->
                <div class="row mt-3">
                    <div class="col-12">
                        <div class="input-group input-group-sm">
                            <span class="input-group-text bg-light">
                                <i class="fas fa-search"></i>
                            </span>
                            <input
                                type="text"
                                id="globalShopSearch"
                                class="form-control"
                                placeholder="Search by shop name, owner, mobile, email..."
                            >
                            <button class="btn btn-primary" id="searchShopBtn">
                                Search
                            </button>
                        </div>
                    </div>
                </div>

                <div class="d-flex align-items-center mt-2 mt-md-0">
                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addShopModal">
                        <i class="fas fa-plus me-1"></i> Add Vendor
                    </button>
                    <div class="btn-group ms-2">
                        <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-filter me-1"></i> <span id="filterStatusText">Filter</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item filter-shops" href="#" data-filter-type="status" data-filter-value="all">All Shops</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item filter-shops" href="#" data-filter-type="status" data-filter-value="ACCEPTED">Accepted</a></li>
                            <li><a class="dropdown-item filter-shops" href="#" data-filter-type="status" data-filter-value="PENDING">Pending</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item filter-shops" href="#" data-filter-type="availability" data-filter-value="true">Available</a></li>
                            <li><a class="dropdown-item filter-shops" href="#" data-filter-type="availability" data-filter-value="false">Unavailable</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-stylish mb-0" id="shopsTable">
                        <thead>
                            <tr>
                                <th class="ps-4">Vendor Info</th>
                                <th>Contact Details</th>
                                <th>Status</th>
                                <th>Availability</th>
                                <th class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="shopsTableBody">
                            <tr><td colspan="5" class="text-center p-5"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Add Vendor Modal -->
<div class="modal fade" id="addShopModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl">
        <form class="modal-content" enctype="multipart/form-data" id="vendorForm">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="vendorModalTitle">Add New Vendor & Shop</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <ul class="nav nav-tabs mb-4" id="vendorTabs" role="tablist">
                    <li class="nav-item" role="presentation"><button class="nav-link active" id="basic-tab" data-bs-toggle="tab" data-bs-target="#basic-info" type="button" role="tab">Basic Info</button></li>
                    <li class="nav-item" role="presentation"><button class="nav-link" id="contact-tab" data-bs-toggle="tab" data-bs-target="#contact-info" type="button" role="tab">Contact</button></li>
                    <li class="nav-item" role="presentation"><button class="nav-link" id="location-tab" data-bs-toggle="tab" data-bs-target="#location-info" type="button" role="tab">Location</button></li>
                    <li class="nav-item" role="presentation"><button class="nav-link" id="bank-tab" data-bs-toggle="tab" data-bs-target="#bank-info" type="button" role="tab">Bank Details</button></li>
                    <li class="nav-item" role="presentation"><button class="nav-link" id="documents-tab" data-bs-toggle="tab" data-bs-target="#documents" type="button" role="tab">Documents</button></li>
                    <li class="nav-item" role="presentation"><button class="nav-link" id="settings-tab" data-bs-toggle="tab" data-bs-target="#settings" type="button" role="tab">Settings</button></li>
                </ul>
                <div class="tab-content p-2" id="vendorTabContent">
                    <!-- Basic Info Tab -->
                    <div class="tab-pane fade show active" id="basic-info" role="tabpanel">
                        <div class="row g-3">
                            <div class="col-md-6"><label class="form-label">Vendor Name *</label><input type="text" name="vendorName" class="form-control" required></div>
                            <div class="col-md-6"><label class="form-label">Contact Person *</label><input type="text" name="contactPerson" class="form-control" required></div>
                            <div class="col-md-6"><label class="form-label">PAN Number *</label><input type="text" name="panNumber" class="form-control" required></div>
                            <div class="col-md-6"><label class="form-label">FSSAI Number *</label><input type="text" name="fssaiNumber" class="form-control" required></div>
                            <div class="col-md-6"><label class="form-label">GST Number</label><input type="text" name="gstNumber" class="form-control"></div>
                        </div>
                    </div>
                    <!-- Contact Info Tab -->
                    <div class="tab-pane fade" id="contact-info" role="tabpanel">
                         <div class="row g-3">
                            <div class="col-md-6"><label class="form-label">Email *</label><input type="email" name="email" class="form-control" required></div>
                            <div class="col-md-6"><label class="form-label">Phone Number *</label><input type="tel" name="phoneNumber" class="form-control" required></div>
                            <div class="col-md-6"><label class="form-label">Alternate Phone</label><input type="tel" name="alternatePhoneNumber" class="form-control"></div>
                            <div class="col-md-6"><label class="form-label">Zip Code *</label><input type="text" name="zipCode" class="form-control" required></div>
                            <div class="col-12"><label class="form-label">Address *</label><textarea name="address" class="form-control" rows="2" required></textarea></div>
                        </div>
                    </div>
                    <!-- Location Info Tab -->
                    <div class="tab-pane fade" id="location-info" role="tabpanel">
                         <div class="row g-3">
                            <div class="col-md-6"><label class="form-label">Country *</label><select name="countryId" class="form-select" id="countryId" required><option value="">Select Country</option></select></div>
                            <div class="col-md-6"><label class="form-label">State *</label><select name="stateId" class="form-select" id="stateId" required disabled><option value="">Select State</option></select></div>
                            <div class="col-md-6"><label class="form-label">District *</label><select name="districtId" class="form-select" id="districtId" required disabled><option value="">Select District</option></select></div>
                            <div class="col-md-6"><label class="form-label">City *</label><select name="cityId" class="form-select" id="cityId" required disabled><option value="">Select City</option></select></div>
                            <div class="col-md-6"><label class="form-label">Latitude</label><input type="text" name="latitude" class="form-control" value="12.9716"></div>
                            <div class="col-md-6"><label class="form-label">Longitude</label><input type="text" name="longitude" class="form-control" value="77.5946"></div>
                        </div>
                    </div>
                    <!-- Bank Details Tab -->
                    <div class="tab-pane fade" id="bank-info" role="tabpanel">
                        <div class="row g-3">
                            <div class="col-md-6"><label class="form-label">Bank Account Holder Name *</label><input type="text" name="bankHolderName" class="form-control" required></div>
                            <div class="col-md-6"><label class="form-label">Bank Name *</label><input type="text" name="bankName" class="form-control" required></div>
                            <div class="col-md-6"><label class="form-label">Account Number *</label><input type="text" name="accountNumber" class="form-control" required></div>
                            <div class="col-md-6"><label class="form-label">IFSC Code *</label><input type="text" name="ifscCode" class="form-control" required></div>
                        </div>
                    </div>
                    <!-- Documents Tab -->
                    <div class="tab-pane fade" id="documents" role="tabpanel">
                        <div class="row g-3">
                            <div class="col-md-6"><label class="form-label">PAN Card *</label><input type="file" name="panCardFile" class="form-control" required></div>
                            <div class="col-md-6"><label class="form-label">FSSAI Certificate *</label><input type="file" name="fssaiFile" class="form-control" required></div>
                            <div class="col-md-6"><label class="form-label">GST Certificate</label><input type="file" name="gstCertificateFile" class="form-control"></div>
                            <div class="col-md-6"><label class="form-label">Shop Photo</label><input type="file" name="shopPhotoFile" class="form-control" accept="image/*"></div>
                            <div class="col-md-6"><label class="form-label">Business License</label><input type="file" name="businessLicenseFile" class="form-control"></div>
                            <div class="col-md-6"><label class="form-label">Additional Documents</label><input type="file" name="additionalDocumentFile" class="form-control"></div>
                        </div>
                    </div>
                    <!-- Settings Tab -->
                    <div class="tab-pane fade" id="settings" role="tabpanel">
                        <div class="row g-3">
                            <div class="col-md-6"><label class="form-label">Product Category *</label><input type="text" name="productCategories" class="form-control" required></div>
                            <div class="col-md-6"><label class="form-label">Opening Time *</label><input type="time" name="openingTime" class="form-control" value="09:00" required></div>
                            <div class="col-md-6"><label class="form-label">Closing Time *</label><input type="time" name="closingTime" class="form-control" value="21:00" required></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary" id="vendorFormSubmitBtn">Add Vendor</button>
            </div>
        </form>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteConfirmationModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white"><h5 class="modal-title">Confirm Deletion</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button></div>
            <div class="modal-body"><p id="deleteConfirmationMessage">Are you sure you want to delete this item? This action cannot be undone.</p></div>
            <div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button><button type="button" class="btn btn-danger" id="confirmDeleteBtn">Delete</button></div>
        </div>
    </div>
</div>

<!-- Date Range Modal -->
<div class="modal fade" id="dateRangeModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Select Date Range</h5><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button></div>
            <div class="modal-body">
                <div class="mb-3"><label for="startDate" class="form-label">Start Date</label><input type="date" class="form-control" id="startDate"></div>
                <div class="mb-3"><label for="endDate" class="form-label">End Date</label><input type="date" class="form-control" id="endDate"></div>
            </div>
            <div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button><button type="button" class="btn btn-primary" id="applyDateRange">Apply</button></div>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/shopspage.css">
<script src="${pageContext.request.contextPath}/resources/js/shopspage.js"></script>