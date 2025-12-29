<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/header.jsp" %>

<main class="main-content">
    <div class="container-fluid px-4">
        <!-- Header -->
        <div class="py-5 d-flex justify-content-between align-items-center flex-wrap">
            <h1 id="vendor-page-title">Loading Shop Details...</h1>
            <div>
                <a href="${pageContext.request.contextPath}/shopspage" class="btn btn-outline-secondary">
                   <i class="fas fa-arrow-left me-2"></i>Back to Shops List
                </a>
            </div>
        </div>

        <!-- Loading Spinner -->
        <div id="loading-spinner" class="text-center py-5">
            <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;"><span class="visually-hidden">Loading...</span></div>
            <p class="mt-2 text-muted">Fetching Shop Data...</p>
        </div>

        <!-- Main Content Area -->
        <div id="view-content" class="d-none">
            <div class="row">
                <!-- Left Column: Summary -->
                <div class="col-lg-4">
                    <div class="card mb-4">
                        <div class="card-body text-center">
                            <img src="${pageContext.request.contextPath}/resources/images/default-store.jpg" class="rounded-circle mb-3" width="150" height="150" alt="Shop Photo" id="shopPhoto" style="object-fit: cover;">
                            <h3 class="mb-1" id="vendorName">-</h3>
                            <div class="d-flex justify-content-center align-items-center my-3 gap-2" id="statusBadges"></div>
                            <hr>
                            <div class="text-start mt-4">
                                <p class="mb-2"><i class="fas fa-user-tie fa-fw me-2 text-muted"></i><strong>Contact Person:</strong> <span id="summary-contactPerson">-</span></p>
                                <p><i class="fas fa-phone fa-fw me-2 text-muted"></i><strong>Phone:</strong> <span id="summary-phone">-</span></p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Detailed Tabs -->
                <div class="col-lg-8">
                    <div class="card mb-4">
                        <div class="card-header">
                            <ul class="nav nav-tabs card-header-tabs" id="myTab" role="tablist">
                                <li class="nav-item" role="presentation"><button class="nav-link active" id="details-tab" data-bs-toggle="tab" data-bs-target="#details" type="button" role="tab">Shop Details</button></li>
                                <li class="nav-item" role="presentation"><button class="nav-link" id="location-tab" data-bs-toggle="tab" data-bs-target="#location" type="button" role="tab">Location</button></li>
                                <li class="nav-item" role="presentation"><button class="nav-link" id="bank-tab" data-bs-toggle="tab" data-bs-target="#bank" type="button" role="tab">Bank Details</button></li>
                            </ul>
                        </div>
                        <div class="card-body">
                            <div class="tab-content" id="myTabContent">
                                <!-- Details Tab -->
                                <div class="tab-pane fade show active" id="details" role="tabpanel">
                                    <h5 class="mb-4">Business Information</h5>
                                    <div class="row g-4">
                                        <div class="col-md-6"><label class="form-label text-muted">PAN Number</label><p class="form-control-plaintext" id="detail-panNumber">-</p></div>
                                        <div class="col-md-6"><label class="form-label text-muted">FSSAI Number</label><p class="form-control-plaintext" id="detail-fssaiNumber">-</p></div>
                                        <div class="col-md-6"><label class="form-label text-muted">GST Number</label><p class="form-control-plaintext" id="detail-gstNumber">-</p></div>
                                        <div class="col-md-6"><label class="form-label text-muted">Email</label><p class="form-control-plaintext" id="detail-email">-</p></div>
                                        <div class="col-md-6"><label class="form-label text-muted">Opening Time</label><p class="form-control-plaintext" id="detail-openingTime">-</p></div>
                                        <div class="col-md-6"><label class="form-label text-muted">Closing Time</label><p class="form-control-plaintext" id="detail-closingTime">-</p></div>
                                    </div>
                                </div>

                                <!-- Location Tab -->
                                <div class="tab-pane fade" id="location" role="tabpanel">
                                    <h5 class="mb-4">Contact & Location</h5>
                                    <div class="row g-4">
                                        <div class="col-12"><label class="form-label text-muted">Address</label><p class="form-control-plaintext" id="location-address">-</p></div>
                                        <div class="col-md-6"><label class="form-label text-muted">City</label><p class="form-control-plaintext" id="location-city">-</p></div>
                                        <div class="col-md-6"><label class="form-label text-muted">District</label><p class="form-control-plaintext" id="location-district">-</p></div>
                                        <div class="col-md-6"><label class="form-label text-muted">State</label><p class="form-control-plaintext" id="location-state">-</p></div>
                                        <div class="col-md-6"><label class="form-label text-muted">Zip Code</label><p class="form-control-plaintext" id="location-zipcode">-</p></div>
                                    </div>
                                </div>

                                 <!-- Bank Details Tab -->
                                <div class="tab-pane fade" id="bank" role="tabpanel">
                                    <h5 class="mb-4">Financial Details</h5>
                                     <div class="row g-4">
                                        <div class="col-md-6"><label class="form-label text-muted">Account Holder</label><p class="form-control-plaintext" id="bank-holderName">-</p></div>
                                        <div class="col-md-6"><label class="form-label text-muted">Bank Name</label><p class="form-control-plaintext" id="bank-bankName">-</p></div>
                                        <div class="col-md-6"><label class="form-label text-muted">Account Number</label><p class="form-control-plaintext" id="bank-accountNumber">-</p></div>
                                        <div class="col-md-6"><label class="form-label text-muted">IFSC Code</label><p class="form-control-plaintext" id="bank-ifscCode">-</p></div>
                                     </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Products List Card -->
            <div class="card">
                <div class="card-header"><h5 class="mb-0"><i class="fas fa-box-open me-2"></i>Products from this Shop</h5></div>
                <div class="card-body p-0">
                     <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead><tr><th class="ps-4">Product</th><th>Price</th><th>Category</th><th>Status</th></tr></thead>
                            <tbody id="products-table-body"><!-- JS Populates --></tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>
</main>

<%@ include file="/includes/footer.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/shopspage-ui-enhancements.css">
<script src="${pageContext.request.contextPath}/resources/js/viewshop.js"></script>