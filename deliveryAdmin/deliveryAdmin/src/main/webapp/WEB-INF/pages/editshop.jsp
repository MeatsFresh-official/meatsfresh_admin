<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/header.jsp" %>

<main class="main-content">
    <div class="container-fluid px-4">
        <h1 class="py-5" id="edit-vendor-title-main">Edit Shop</h1>

        <!-- Loading Spinner -->
        <div id="form-loading-spinner" class="text-center py-5">
            <div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div>
            <p class="mt-2 text-muted">Loading Vendor Data...</p>
        </div>

        <form id="editVendorForm" enctype="multipart/form-data" novalidate class="d-none">
            <input type="hidden" id="vendorId" name="vendorId">
            <div class="row">
                <div class="col-lg-8">
                    <!-- Basic & Contact Info Card -->
                    <div class="card">
                        <div class="card-header"><h5 class="mb-0">Vendor Information</h5></div>
                        <div class="card-body">
                            <h6>Basic Info</h6>
                            <div class="row g-3">
                                <div class="col-md-6"><label class="form-label">Vendor Name *</label><input type="text" name="vendorName" class="form-control" required></div>
                                <div class="col-md-6"><label class="form-label">Contact Person *</label><input type="text" name="contactPerson" class="form-control" required></div>
                            </div>
                            <hr class="my-4">
                            <h6>Contact & Location</h6>
                            <div class="row g-3">
                                <div class="col-md-6"><label class="form-label">Email *</label><input type="email" name="email" class="form-control" required></div>
                                <div class="col-md-6"><label class="form-label">Phone Number *</label><input type="tel" name="phoneNumber" class="form-control" required></div>
                                <div class="col-12"><label class="form-label">Address *</label><textarea name="address" class="form-control" rows="2" required></textarea></div>
                                <div class="col-md-4"><label class="form-label">City *</label><input type="text" name="cityName" class="form-control" required></div>
                                <div class="col-md-4"><label class="form-label">State *</label><input type="text" name="stateName" class="form-control" required></div>
                                <div class="col-md-4"><label class="form-label">Zip Code *</label><input type="text" name="zipCode" class="form-control" required></div>
                            </div>
                            <hr class="my-4">
                            <h6>Business Documents</h6>
                             <div class="row g-3">
                                <div class="col-md-6"><label class="form-label">PAN Number *</label><input type="text" name="panNumber" class="form-control" required></div>
                                <div class="col-md-6"><label class="form-label">FSSAI Number *</label><input type="text" name="fssaiNumber" class="form-control" required></div>
                                <div class="col-md-6"><label class="form-label">GST Number</label><input type="text" name="gstNumber" class="form-control"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <!-- Admin Settings Card -->
                    <div class="card">
                         <div class="card-header"><h5 class="mb-0">Admin Controls</h5></div>
                         <div class="card-body">
                             <div class="mb-4">
                                 <label class="form-label fw-bold">Approval Status *</label>
                                 <select name="isApproved" class="form-select form-select-lg" required>
                                     <option value="true">Accepted</option>
                                     <option value="false">Pending / Rejected</option>
                                 </select>
                             </div>
                             <div>
                                 <label class="form-label fw-bold">Shop Availability *</label>
                                 <select name="isActive" class="form-select form-select-lg" required>
                                     <option value="Y">Available</option>
                                     <option value="N">Unavailable</option>
                                 </select>
                             </div>
                         </div>
                    </div>
                     <!-- Photo Card -->
                    <div class="card">
                        <div class="card-header"><h5 class="mb-0">Shop Photo</h5></div>
                        <div class="card-body">
                            <input type="file" name="shopPhotoFile" class="form-control" accept="image/*">
                            <div id="currentShopPhoto" class="mt-3 text-center"></div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Action Buttons -->
            <div class="mt-2 py-3 text-end border-top bg-light sticky-bottom">
                 <div class="container-fluid px-4">
                     <a href="${pageContext.request.contextPath}/shopspage" class="btn btn-secondary">Cancel</a>
                     <button type="submit" class="btn btn-primary"><i class="fas fa-save me-2"></i>Save Changes</button>
                </div>
            </div>
        </form>
    </div>
</main>

<%@ include file="/includes/footer.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/shopspage-ui-enhancements.css">
<script src="${pageContext.request.contextPath}/resources/js/editshop.js"></script>