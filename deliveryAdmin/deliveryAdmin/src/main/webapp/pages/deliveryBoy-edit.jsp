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
            <h1>Edit Rider Profile</h1>
            <a href="${pageContext.request.contextPath}/deliveryBoy-manage" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to List
            </a>
        </div>

        <div id="loading-spinner" class="text-center py-5">
             <div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div>
             <p class="mt-2">Loading Rider Details...</p>
        </div>

        <div class="card d-none" id="edit-form-container">
            <form id="editRiderForm">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Rider Details</h5>
                    <div id="riderStatusBadge"></div>
                </div>
                <div class="card-body">
                    <!-- Personal Information -->
                    <h5 class="mb-3">Personal Information</h5>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label">First Name</label>
                            <input type="text" name="firstName" class="form-control" required>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Last Name</label>
                            <input type="text" name="lastName" class="form-control" required>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Phone Number</label>
                            <input type="tel" name="phoneNumber" class="form-control" required>
                        </div>
                         <div class="col-md-4 mb-3">
                            <label class="form-label">Gender</label>
                             <select name="gender" class="form-select" required>
                                <option value="MALE">Male</option>
                                <option value="FEMALE">Female</option>
                                <option value="OTHER">Other</option>
                            </select>
                        </div>
                         <div class="col-md-4 mb-3">
                            <label class="form-label">Working Type</label>
                            <select name="workingType" class="form-select" required>
                                <option value="FULL_TIME">Full Time</option>
                                <option value="PART_TIME">Part Time</option>
                            </select>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">T-Shirt Size</label>
                            <select name="tshirtSize" class="form-select" required>
                                <option value="S">Small</option>
                                <option value="M">Medium</option>
                                <option value="L">Large</option>
                                <option value="XL">XL</option>
                                <option value="XXL">XXL</option>
                            </select>
                        </div>
                    </div>
                    <hr class="my-4">

                    <!-- Vehicle & Zone -->
                    <h5 class="mb-3">Vehicle & Delivery Zone</h5>
                    <div class="row">
                         <div class="col-md-4 mb-3">
                            <label class="form-label">Vehicle Type</label>
                            <select name="vehicleType" class="form-select" required>
                                <option value="ELECTRIC">Electric</option>
                                <option value="PETROL">Petrol</option>
                            </select>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Vehicle Registration No.</label>
                            <input type="text" name="vehicleRegistrationNumber" class="form-control" required>
                        </div>
                         <div class="col-md-4 mb-3">
                            <label class="form-label">Driving License No.</label>
                            <input type="text" name="drivingLicenseNumber" class="form-control" required>
                        </div>
                        <div class="col-md-12 mb-3">
                            <label class="form-label">Preferred Delivery Zone</label>
                            <input type="text" name="preferredDeliveryZone" class="form-control" required>
                        </div>
                    </div>
                    <hr class="my-4">

                     <!-- Bank Details -->
                    <h5 class="mb-3">Bank Details</h5>
                     <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Bank Account Holder Name</label>
                            <input type="text" name="bankAccountHolderName" class="form-control" required>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Bank Account Number</label>
                            <input type="text" name="bankAccountNumber" class="form-control" required>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">IFSC Code</label>
                            <input type="text" name="ifscCode" class="form-control" required>
                        </div>
                    </div>
                </div>
                <div class="card-footer text-end">
                    <a id="viewRiderBtn" href="#" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Save Changes
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>

<%@ include file="/includes/footer.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/deliveryBoy-manage.css">
<script src="${pageContext.request.contextPath}/resources/js/deliveryBoy-edit.js"></script>