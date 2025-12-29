<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/header.jsp" %>

<!-- Toast/Notification Containers -->
<div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100;">
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
    <div class="container-fluid px-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="pt-3">Coupon Code Management</h1>
        </div>

        <!-- Quick Stats Cards -->
        <div class="row mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="card bg-primary text-white mb-4">
                    <div class="card-body">
                        <h6 class="mb-0">Total Coupons</h6>
                        <h3 class="mb-0" id="totalCouponsCount">0</h3>
                        <i class="fas fa-tag fa-2x card-icon"></i>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-success text-white mb-4">
                    <div class="card-body">
                        <h6 class="mb-0">Active Coupons</h6>
                        <h3 class="mb-0" id="activeCouponsCount">0</h3>
                        <i class="fas fa-check-circle fa-2x card-icon"></i>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-warning text-white mb-4">
                    <div class="card-body">
                        <h6 class="mb-0">Expiring Soon</h6>
                        <h3 class="mb-0" id="expiringSoonCount">0</h3>
                        <i class="fas fa-clock fa-2x card-icon"></i>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-danger text-white mb-4">
                    <div class="card-body">
                        <h6 class="mb-0">Expired</h6>
                        <h3 class="mb-0" id="expiredCouponsCount">0</h3>
                        <i class="fas fa-times-circle fa-2x card-icon"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Coupon Management Card -->
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">All Coupons</h5>
                <div>
                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#createCouponModal">
                        <i class="fas fa-plus me-1"></i> Create Coupon
                    </button>
                    <div class="btn-group ms-2" id="filterButtonGroup">
                        <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button"
                                data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-filter me-1"></i> <span id="filter-label">All Coupons</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item filter-option" href="#" data-filter="all">All Coupons</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item filter-option" href="#" data-filter="active">Active</a></li>
                            <li><a class="dropdown-item filter-option" href="#" data-filter="expired">Expired</a></li>
                            <li><a class="dropdown-item filter-option" href="#" data-filter="shop">Shop Coupons</a></li>
                            <li><a class="dropdown-item filter-option" href="#" data-filter="admin">Admin Coupons</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover" id="couponsTable">
                        <thead>
                            <tr>
                                <th>Code</th>
                                <th>Discount</th>
                                <th>Validity</th>
                                <th>Status</th>
                                <th>Created By</th>
                                <th>Usage</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- JS will populate this section -->
                            <tr>
                                <td colspan="7" class="text-center">
                                    <i class="fas fa-spinner fa-spin me-2"></i>Loading coupons...
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Create Coupon Modal -->
<div class="modal fade" id="createCouponModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <form class="modal-content" id="createCouponForm">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Create New Coupon</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Coupon Code <span class="text-danger">*</span></label>
                    <input type="text" name="code" class="form-control text-uppercase" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Coupon Name <span class="text-danger">*</span></label>
                    <input type="text" name="name" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" rows="2"></textarea>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Discount Type <span class="text-danger">*</span></label>
                        <select name="discountType" class="form-select" required>
                            <option value="PERCENTAGE">Percentage</option>
                            <option value="FIXED_AMOUNT">Fixed Amount</option>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Discount Value <span class="text-danger">*</span></label>
                        <input type="number" step="0.01" name="discountValue" class="form-control" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Valid From <span class="text-danger">*</span></label>
                        <input type="date" name="validFrom" class="form-control" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Expiry Date <span class="text-danger">*</span></label>
                        <input type="date" name="expiryDate" class="form-control" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Usage Limit <span class="text-danger">*</span></label>
                        <input type="number" name="usageLimit" class="form-control" value="100" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Minimum Order Amount</label>
                        <input type="number" step="0.01" name="minOrderAmount" class="form-control">
                    </div>
                </div>
                <div class="mb-3">
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" name="isActive" id="createIsActive" checked>
                        <label class="form-check-label" for="createIsActive">Active</label>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Create Coupon</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Coupon Modal -->
<div class="modal fade" id="editCouponModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <form class="modal-content" id="editCouponForm">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Edit Coupon</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="id" id="editCouponId">
                <div id="editModalLoader" class="text-center"><i class="fas fa-spinner fa-spin fa-2x"></i></div>
                <div id="editModalContent" class="d-none">
                     <div class="mb-3">
                        <label class="form-label">Coupon Code</label>
                        <input type="text" name="code" class="form-control" id="editCouponCode" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Coupon Name <span class="text-danger">*</span></label>
                        <input type="text" name="name" class="form-control" id="editCouponName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-control" rows="2" id="editCouponDescription"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Expiry Date <span class="text-danger">*</span></label>
                        <input type="date" name="expiryDate" class="form-control" id="editExpiryDate" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Minimum Order Amount</label>
                        <input type="number" step="0.01" name="minOrderAmount" class="form-control" id="editMinOrderAmount">
                    </div>
                    <div class="mb-3">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" name="isActive" id="editIsActive">
                            <label class="form-check-label" for="editIsActive">Active</label>
                        </div>
                    </div>
                    <small class="text-muted">Discount, usage limit, and start date cannot be changed after creation.</small>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">Confirm Deletion</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete coupon code <strong id="couponCodeToDelete"></strong>? This action cannot be undone.</p>
                <input type="hidden" id="deleteCouponId">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Delete</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/coupons.css">
<script src="${pageContext.request.contextPath}/resources/js/coupons.js"></script>