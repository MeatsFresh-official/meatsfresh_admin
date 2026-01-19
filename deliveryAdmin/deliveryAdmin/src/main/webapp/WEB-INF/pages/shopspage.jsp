<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/includes/header.jsp" %>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/shop-view.css">

        <main class="main-content">
            <div class="container-fluid px-4 pt-4">
                <!-- Header Section -->
                <div class="d-flex justify-content-between align-items-center mb-5 fade-in-up">
                    <div>
                        <h1 class="fw-bold text-dark mb-1">Vendor Management</h1>
                        <p class="text-muted small">Manage all your registered shops and partners</p>
                    </div>
                    <button class="btn btn-zenith-primary shadow-sm" data-bs-toggle="modal"
                        data-bs-target="#addShopModal">
                        <i class="fas fa-plus-circle me-2"></i>Add New Vendor
                    </button>
                </div>

                <!-- Stats Cards -->
                <div class="row g-4 mb-5" id="shop-stats-container">
                    <!-- JS populated stats -->
                </div>

                <!-- Filters & Search -->
                <div class="glass-panel p-3 mb-4 d-flex flex-wrap gap-3 align-items-center justify-content-between fade-in-up"
                    style="animation-delay: 0.1s;">
                    <div class="d-flex align-items-center gap-3 flex-grow-1">
                        <div class="input-group" style="max-width: 400px;">
                            <span class="input-group-text bg-white border-end-0"><i
                                    class="fas fa-search text-muted"></i></span>
                            <input type="text" id="globalShopSearch" class="form-control border-start-0 ps-0"
                                placeholder="Search shops, owners, IDs...">
                            <button class="btn btn-light border bg-white text-primary"
                                id="searchShopBtn">Search</button>
                        </div>
                        <div class="vr h-50 my-auto text-muted"></div>
                        <div class="dropdown">
                            <button class="btn btn-light dropdown-toggle border-0 fw-bold text-secondary" type="button"
                                data-bs-toggle="dropdown">
                                <i class="fas fa-filter me-2 text-primary"></i> <span id="filterStatusText">All
                                    Status</span>
                            </button>
                            <ul class="dropdown-menu shadow border-0">
                                <li><a class="dropdown-item filter-shops" href="#" data-filter-type="status"
                                        data-filter-value="all">All Shops</a></li>
                                <li><a class="dropdown-item filter-shops" href="#" data-filter-type="status"
                                        data-filter-value="ACCEPTED">Accepted</a></li>
                                <li><a class="dropdown-item filter-shops" href="#" data-filter-type="status"
                                        data-filter-value="PENDING">Pending</a></li>
                                <li>
                                    <hr class="dropdown-divider">
                                </li>
                                <li><a class="dropdown-item filter-shops" href="#" data-filter-type="availability"
                                        data-filter-value="true">Active/Online</a></li>
                                <li><a class="dropdown-item filter-shops" href="#" data-filter-type="availability"
                                        data-filter-value="false">Offline</a></li>
                            </ul>
                        </div>
                    </div>

                    <div class="btn-group" role="group">
                        <input type="radio" class="btn-check" name="viewMode" id="view-grid" autocomplete="off" checked>
                        <label class="btn btn-outline-light text-primary border-0" for="view-grid"><i
                                class="fas fa-th-large"></i></label>

                        <input type="radio" class="btn-check" name="viewMode" id="view-list" autocomplete="off">
                        <label class="btn btn-outline-light text-muted border-0" for="view-list"><i
                                class="fas fa-list"></i></label>
                    </div>
                </div>

                <!-- Shops Grid/List Container -->
                <div id="shops-container" class="row g-4 fade-in-up" style="animation-delay: 0.2s;">
                    <!-- Content Rendered via JS -->
                    <div class="col-12 text-center py-5">
                        <div class="spinner-border text-primary" role="status"><span
                                class="visually-hidden">Loading...</span></div>
                    </div>
                </div>
                <!-- Pagination -->
                <div id="shopsPagination"></div>
            </div>
        </main>

        <!-- Add Vendor Modal (Existing structure preserved but cleaned if needed) -->
        <div class="modal fade" id="addShopModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-centered">
                <form class="modal-content border-0 shadow-lg" enctype="multipart/form-data" id="vendorForm">
                    <div class="modal-header bg-white border-bottom-0">
                        <h5 class="modal-title fw-bold" id="vendorModalTitle">Add New Vendor</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4 bg-light">
                        <!-- Existing Tab Structure - Preserving functional core -->
                        <ul class="nav nav-pills mb-4 bg-white p-2 rounded shadow-sm d-inline-flex" id="vendorTabs"
                            role="tablist">
                            <li class="nav-item" role="presentation"><button class="nav-link active rounded-pill px-4"
                                    id="basic-tab" data-bs-toggle="tab" data-bs-target="#basic-info" type="button">Basic
                                    Info</button></li>
                            <li class="nav-item" role="presentation"><button class="nav-link rounded-pill px-4"
                                    id="contact-tab" data-bs-toggle="tab" data-bs-target="#contact-info"
                                    type="button">Contact</button></li>
                            <li class="nav-item" role="presentation"><button class="nav-link rounded-pill px-4"
                                    id="location-tab" data-bs-toggle="tab" data-bs-target="#location-info"
                                    type="button">Location</button></li>
                            <li class="nav-item" role="presentation"><button class="nav-link rounded-pill px-4"
                                    id="bank-tab" data-bs-toggle="tab" data-bs-target="#bank-info"
                                    type="button">Bank</button></li>
                            <li class="nav-item" role="presentation"><button class="nav-link rounded-pill px-4"
                                    id="documents-tab" data-bs-toggle="tab" data-bs-target="#documents"
                                    type="button">Docs</button></li>
                            <li class="nav-item" role="presentation"><button class="nav-link rounded-pill px-4"
                                    id="settings-tab" data-bs-toggle="tab" data-bs-target="#settings"
                                    type="button">Settings</button></li>
                        </ul>

                        <div class="tab-content" id="vendorTabContent">
                            <!-- Tab content structure kept same but classes modernized if needed -->
                            <div class="tab-pane fade show active" id="basic-info">
                                <div class="glass-panel p-4">
                                    <div class="row g-3">
                                        <div class="col-md-6"><label class="zenith-form-label">Vendor Name
                                                *</label><input type="text" name="vendorName"
                                                class="form-control zenith-input" required></div>
                                        <div class="col-md-6"><label class="zenith-form-label">Contact Person
                                                *</label><input type="text" name="contactPerson"
                                                class="form-control zenith-input" required></div>
                                        <div class="col-md-6"><label class="zenith-form-label">PAN Number
                                                *</label><input type="text" name="panNumber"
                                                class="form-control zenith-input" required></div>
                                        <div class="col-md-6"><label class="zenith-form-label">FSSAI Number
                                                *</label><input type="text" name="fssaiNumber"
                                                class="form-control zenith-input" required></div>
                                        <div class="col-md-6"><label class="zenith-form-label">GST Number</label><input
                                                type="text" name="gstNumber" class="form-control zenith-input"></div>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="contact-info">
                                <div class="glass-panel p-4">
                                    <div class="row g-3">
                                        <div class="col-md-6"><label class="zenith-form-label">Email *</label><input
                                                type="email" name="email" class="form-control zenith-input" required>
                                        </div>
                                        <div class="col-md-6"><label class="zenith-form-label">Phone *</label><input
                                                type="tel" name="phoneNumber" class="form-control zenith-input"
                                                required></div>
                                        <div class="col-md-6"><label class="zenith-form-label">Alt Phone</label><input
                                                type="tel" name="alternatePhoneNumber"
                                                class="form-control zenith-input"></div>
                                        <div class="col-md-6"><label class="zenith-form-label">Zip Code *</label><input
                                                type="text" name="zipCode" class="form-control zenith-input" required>
                                        </div>
                                        <div class="col-12"><label class="zenith-form-label">Address *</label><textarea
                                                name="address" class="form-control zenith-input" rows="2"
                                                required></textarea></div>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="location-info">
                                <div class="glass-panel p-4">
                                    <div class="row g-3">
                                        <div class="col-md-6"><label class="zenith-form-label">Country *</label><select
                                                name="countryId" class="form-select zenith-input" id="countryId"
                                                required>
                                                <option value="">Select</option>
                                            </select></div>
                                        <div class="col-md-6"><label class="zenith-form-label">State *</label><select
                                                name="stateId" class="form-select zenith-input" id="stateId" required
                                                disabled></select></div>
                                        <div class="col-md-6"><label class="zenith-form-label">District *</label><select
                                                name="districtId" class="form-select zenith-input" id="districtId"
                                                required disabled></select></div>
                                        <div class="col-md-6"><label class="zenith-form-label">City *</label><select
                                                name="cityId" class="form-select zenith-input" id="cityId" required
                                                disabled></select></div>
                                        <div class="col-md-6"><label class="zenith-form-label">Latitude</label><input
                                                type="text" name="latitude" class="form-control zenith-input"
                                                value="12.9716"></div>
                                        <div class="col-md-6"><label class="zenith-form-label">Longitude</label><input
                                                type="text" name="longitude" class="form-control zenith-input"
                                                value="77.5946"></div>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="bank-info">
                                <div class="glass-panel p-4">
                                    <div class="row g-3">
                                        <div class="col-md-6"><label class="zenith-form-label">Acc Holder
                                                *</label><input type="text" name="bankHolderName"
                                                class="form-control zenith-input" required></div>
                                        <div class="col-md-6"><label class="zenith-form-label">Bank Name *</label><input
                                                type="text" name="bankName" class="form-control zenith-input" required>
                                        </div>
                                        <div class="col-md-6"><label class="zenith-form-label">Account No
                                                *</label><input type="text" name="accountNumber"
                                                class="form-control zenith-input" required></div>
                                        <div class="col-md-6"><label class="zenith-form-label">IFSC Code *</label><input
                                                type="text" name="ifscCode" class="form-control zenith-input" required>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="documents">
                                <div class="glass-panel p-4">
                                    <div class="row g-3">
                                        <div class="col-md-6"><label class="zenith-form-label">PAN Card *</label><input
                                                type="file" name="panCardFile" class="form-control zenith-input"
                                                required></div>
                                        <div class="col-md-6"><label class="zenith-form-label">FSSAI Cert
                                                *</label><input type="file" name="fssaiFile"
                                                class="form-control zenith-input" required></div>
                                        <div class="col-md-6"><label class="zenith-form-label">GST Cert</label><input
                                                type="file" name="gstCertificateFile" class="form-control zenith-input">
                                        </div>
                                        <div class="col-md-6"><label class="zenith-form-label">Shop Photo</label><input
                                                type="file" name="shopPhotoFile" class="form-control zenith-input"
                                                accept="image/*"></div>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="settings">
                                <div class="glass-panel p-4">
                                    <div class="row g-3">
                                        <div class="col-md-6"><label class="zenith-form-label">Categories
                                                *</label><input type="text" name="productCategories"
                                                class="form-control zenith-input" required></div>
                                        <div class="col-md-6"><label class="zenith-form-label">Open Time *</label><input
                                                type="time" name="openingTime" class="form-control zenith-input"
                                                value="09:00" required></div>
                                        <div class="col-md-6"><label class="zenith-form-label">Close Time
                                                *</label><input type="time" name="closingTime"
                                                class="form-control zenith-input" value="21:00" required></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0 pt-0 bg-light">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-zenith-primary">Add Vendor</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteConfirmationModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title">Confirm Deletion</h5><button type="button"
                            class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p id="deleteConfirmationMessage">Are you sure you want to delete this item? This action cannot
                            be undone.</p>
                    </div>
                    <div class="modal-footer"><button type="button" class="btn btn-secondary"
                            data-bs-dismiss="modal">Cancel</button><button type="button" class="btn btn-danger"
                            id="confirmDeleteBtn">Delete</button></div>
                </div>
            </div>
        </div>

        <!-- Date Range Modal -->
        <div class="modal fade" id="dateRangeModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Select Date Range</h5><button type="button" class="btn-close"
                            data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3"><label for="startDate" class="form-label">Start Date</label><input type="date"
                                class="form-control" id="startDate"></div>
                        <div class="mb-3"><label for="endDate" class="form-label">End Date</label><input type="date"
                                class="form-control" id="endDate"></div>
                    </div>
                    <div class="modal-footer"><button type="button" class="btn btn-secondary"
                            data-bs-dismiss="modal">Cancel</button><button type="button" class="btn btn-primary"
                            id="applyDateRange">Apply</button></div>
                </div>
            </div>
        </div>

        <%@ include file="/includes/footer.jsp" %>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/shopspage.css">
            <script src="${pageContext.request.contextPath}/resources/js/pagination-utils.js"></script>
            <script src="${pageContext.request.contextPath}/resources/js/shopspage.js"></script>