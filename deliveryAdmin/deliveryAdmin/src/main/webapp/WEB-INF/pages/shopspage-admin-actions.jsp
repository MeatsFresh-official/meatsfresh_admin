<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/header.jsp" %>

<main class="main-content">
    <div class="container-fluid px-4">
        <!-- Header -->
        <div class="py-5 d-flex justify-content-between align-items-center flex-wrap">
            <h1 id="admin-page-title">Admin Console</h1>
            <div>
                <a href="${pageContext.request.contextPath}/shopspage" class="btn btn-outline-secondary">
                   <i class="fas fa-arrow-left me-2"></i>Back to Shops List
                </a>
            </div>
        </div>

        <!-- Loading Spinner -->
        <div id="loading-spinner" class="text-center py-5">
            <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;"><span class="visually-hidden">Loading...</span></div>
            <p class="mt-2 text-muted">Loading Vendor Data...</p>
        </div>

        <!-- Main Content Area (hidden until loaded) -->
        <div class="d-none" id="admin-content">
            <div class="row">
                <!-- Top Row: Vendor Actions & Dashboard -->
                <div class="col-12">
                    <div class="row">
                        <!-- Vendor Info & Actions -->
                        <div class="col-lg-5 mb-4">
                            <div class="card h-100">
                                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0" id="vendor-name-header">Vendor Actions</h5>
                                    <span class="badge bg-light text-dark" id="vendor-id-badge">ID: -</span>
                                </div>
                                <div class="card-body">
                                    <h6 class="text-muted">APPROVAL STATUS</h6>
                                    <p class="mb-2">Current: <span class="fw-bold fs-5" id="approval-status-text">Loading...</span></p>
                                    <div class="d-grid gap-2 d-sm-flex mb-4">
                                        <button class="btn btn-success flex-fill" id="approve-btn"><i class="fas fa-check-circle me-2"></i>Approve</button>
                                        <button class="btn btn-danger flex-fill" id="disapprove-btn"><i class="fas fa-times-circle me-2"></i>Disapprove</button>
                                    </div>
                                    <hr>
                                    <h6 class="text-muted mt-4">SHOP AVAILABILITY</h6>
                                    <div class="form-check form-switch form-switch-lg mt-2">
                                        <input class="form-check-input" type="checkbox" role="switch" id="availability-switch">
                                        <label class="form-check-label" for="availability-switch" id="availability-label">Toggle Availability</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Vendor Dashboard -->
                        <div class="col-lg-7 mb-4">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h5 class="mb-0"><i class="fas fa-chart-line me-2"></i>Vendor Dashboard</h5>
                                </div>
                                <div class="card-body" id="vendor-dashboard-stats">
                                    <div class="p-3 text-muted">Loading dashboard data...</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bottom Row: Product Management -->
                <div class="col-12">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="fas fa-box-open me-2"></i>Product Management</h5>
                            <button class="btn btn-primary" id="addProductBtn">
                                <i class="fas fa-plus me-2"></i>Add New Product
                            </button>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="ps-4">Product</th>
                                            <th>Price</th>
                                            <th>Category</th>
                                            <th>Status</th>
                                            <th class="text-center">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="productsTableBody">
                                        <!-- Products will be loaded here by JS -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- MODALS -->
<!-- Add/Edit Product Modal -->
<div class="modal fade" id="productModal" tabindex="-1" aria-labelledby="productModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="productModalLabel">Add Product</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="productForm">
                    <input type="hidden" id="productId" name="id">
                    <div class="row g-3">
                        <div class="col-12">
                            <label for="productTitle" class="form-label">Product Title *</label>
                            <input type="text" class="form-control" id="productTitle" name="title" required>
                        </div>
                        <div class="col-12">
                            <label for="productDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="productDescription" name="description" rows="3"></textarea>
                        </div>
                        <div class="col-md-6">
                            <label for="productPrice" class="form-label">Price *</label>
                            <input type="number" class="form-control" id="productPrice" name="price" step="0.01" required>
                        </div>
                         <div class="col-md-6">
                            <label for="productCategory" class="form-label">Category *</label>
                            <select class="form-select" id="productCategory" name="category" required>
                                <option selected disabled value="">Loading categories...</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label for="productImage" class="form-label">Product Image</label>
                            <input type="file" class="form-control" id="productImage" name="productImage" accept="image/*">
                            <small class="text-muted">Leave empty if you don't want to change the existing image.</small>
                        </div>
                        <div class="col-12 mt-4 d-flex gap-4">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" id="isActive" name="isActive" checked>
                                <label class="form-check-label" for="isActive">Active</label>
                            </div>
                            <!-- ★★★ THIS IS THE NEWLY ADDED FIELD ★★★ -->
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" id="recommendedForUser" name="recommendedForUser">
                                <label class="form-check-label" for="recommendedForUser">Recommended for User</label>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-primary" form="productForm" id="saveProductBtn">Save Product</button>
            </div>
        </div>
    </div>
</div>

<!-- View Product Modal -->
<div class="modal fade" id="viewProductModal" tabindex="-1" aria-labelledby="viewProductModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="viewProductModalLabel">Product Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="text-center mb-3">
                    <img id="viewProductImage" src="" class="img-fluid rounded" alt="Product Image" style="max-height: 200px;">
                </div>
                <h4 id="viewProductTitle" class="mb-1"></h4>
                <p><strong class="text-primary fs-5" id="viewProductPrice"></strong></p>
                <dl class="row">
                    <dt class="col-sm-4">Category</dt>
                    <dd class="col-sm-8" id="viewProductCategory"></dd>
                    <dt class="col-sm-4">Status</dt>
                    <dd class="col-sm-8" id="viewProductStatus"></dd>
                    <!-- ★★★ THIS IS THE NEWLY ADDED FIELD ★★★ -->
                    <dt class="col-sm-4">Recommended</dt>
                    <dd class="col-sm-8" id="viewProductRecommended"></dd>
                </dl>
                <p id="viewProductDescription"></p>
            </div>
        </div>
    </div>
</div>


<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteConfirmationModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Confirm Deletion</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p id="deleteConfirmationMessage">Are you sure you want to delete this product? This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Delete</button>
            </div>
        </div>
    </div>
</div>


<%@ include file="/includes/footer.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/shopspage-ui-enhancements.css">
<script src="${pageContext.request.contextPath}/resources/js/shopspage-admin-actions.js"></script>