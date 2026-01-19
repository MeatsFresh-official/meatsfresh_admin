<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <fmt:setLocale value="en_IN" />
                <%@ include file="/includes/header.jsp" %>

                    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/shop-view.css">

                    <main class="main-content">
                        <div class="container-fluid">
                            <!-- Breadcrumb & Back -->
                            <div class="d-flex justify-content-between align-items-center mb-4 pt-3">
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb mb-0">
                                        <li class="breadcrumb-item"><a
                                                href="${pageContext.request.contextPath}/shopspage"
                                                class="text-decoration-none text-muted">Shops</a></li>
                                        <li class="breadcrumb-item active" aria-current="page">Shop Details</li>
                                    </ol>
                                </nav>
                                <a href="${pageContext.request.contextPath}/shopspage" class="btn btn-zenith-primary">
                                    <i class="fas fa-arrow-left me-2"></i>Back to List
                                </a>
                            </div>

                            <!-- Shop Header -->
                            <div class="shop-header-card fade-in-up">
                                <img id="header-shop-img" src="" alt="Shop" class="shop-avatar-lg">
                                <div class="shop-info flex-grow-1">
                                    <div class="d-flex align-items-center mb-1">
                                        <h2 id="header-shop-name" class="m-0 me-3">Loading...</h2>
                                        <span class="badge bg-warning text-dark"><i
                                                class="fas fa-star me-1"></i>4.8</span>
                                    </div>
                                    <div class="shop-meta">
                                        <span id="header-owner"><i class="fas fa-user-tie"></i> -</span>
                                        <span id="header-phone"><i class="fas fa-phone"></i> -</span>
                                    </div>
                                </div>

                                <!-- Online/Offline Toggle -->
                                <div id="shop-status-toggle-wrapper" class="shop-status-toggle">
                                    <div class="status-indicator"></div>
                                    <span class="status-text" id="status-text">Offline</span>
                                    <label class="zenith-switch ms-2">
                                        <input type="checkbox" id="status-checkbox">
                                        <span class="zenith-slider"></span>
                                    </label>
                                </div>
                            </div>

                            <!-- Tabs Navigation -->
                            <div class="zenith-tabs">
                                <button class="zenith-tab-btn active" data-tab="tab-profile">
                                    <i class="fas fa-store me-2"></i>Profile
                                </button>
                                <button class="zenith-tab-btn" data-tab="tab-orders">
                                    <i class="fas fa-receipt me-2"></i>Orders
                                </button>
                                <button class="zenith-tab-btn" data-tab="tab-products">
                                    <i class="fas fa-box-open me-2"></i>Products
                                </button>
                                <button class="zenith-tab-btn" data-tab="tab-settings">
                                    <i class="fas fa-sliders-h me-2"></i>Settings
                                </button>
                            </div>

                            <!-- Tabs Content -->
                            <div class="tab-content">

                                <!-- 1. Profile Tab -->
                                <div id="tab-profile" class="tab-content-pane active">
                                    <div class="row g-4">
                                        <div class="col-lg-6">
                                            <div class="glass-panel p-4 h-100">
                                                <h5 class="fw-bold mb-4 text-dark"><i
                                                        class="fas fa-info-circle me-2 text-primary"></i>Basic
                                                    Information</h5>
                                                <div class="row g-3">
                                                    <div class="col-md-6">
                                                        <label class="zenith-form-label">Shop Name</label>
                                                        <input type="text" id="input-shop-name"
                                                            class="form-control zenith-input">
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label class="zenith-form-label">Owner Name</label>
                                                        <input type="text" id="input-owner"
                                                            class="form-control zenith-input">
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label class="zenith-form-label">Email</label>
                                                        <input type="email" id="input-email"
                                                            class="form-control zenith-input">
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label class="zenith-form-label">Phone</label>
                                                        <input type="tel" id="input-phone"
                                                            class="form-control zenith-input">
                                                    </div>
                                                    <div class="col-12">
                                                        <label class="zenith-form-label">Address</label>
                                                        <textarea id="input-address" class="form-control zenith-input"
                                                            rows="2"></textarea>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-lg-6">
                                            <div class="glass-panel p-4 h-100">
                                                <h5 class="fw-bold mb-4 text-dark"><i
                                                        class="fas fa-file-alt me-2 text-primary"></i>Documents & Bank
                                                </h5>
                                                <div class="row g-3">
                                                    <div class="col-md-4">
                                                        <label class="zenith-form-label">PAN No</label>
                                                        <input type="text" id="input-pan"
                                                            class="form-control zenith-input">
                                                    </div>
                                                    <div class="col-md-4">
                                                        <label class="zenith-form-label">FSSAI No</label>
                                                        <input type="text" id="input-fssai"
                                                            class="form-control zenith-input">
                                                    </div>
                                                    <div class="col-md-4">
                                                        <label class="zenith-form-label">GST No</label>
                                                        <input type="text" id="input-gst"
                                                            class="form-control zenith-input">
                                                    </div>
                                                    <div class="col-12 mt-4">
                                                        <hr class="text-muted">
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label class="zenith-form-label">Account Holder</label>
                                                        <input type="text" id="input-bank-holder"
                                                            class="form-control zenith-input">
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label class="zenith-form-label">Bank Name</label>
                                                        <input type="text" id="input-bank-name"
                                                            class="form-control zenith-input">
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label class="zenith-form-label">Account No</label>
                                                        <input type="text" id="input-bank-acc"
                                                            class="form-control zenith-input">
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label class="zenith-form-label">IFSC Code</label>
                                                        <input type="text" id="input-bank-ifsc"
                                                            class="form-control zenith-input">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="text-end mt-4">
                                        <button class="btn btn-zenith-primary px-4"><i class="fas fa-save me-2"></i>Save
                                            Changes</button>
                                    </div>
                                </div>

                                <!-- 2. Orders Tab -->
                                <div id="tab-orders" class="tab-content-pane">
                                    <div class="glass-panel p-0 overflow-hidden">
                                        <div
                                            class="p-4 border-bottom d-flex justify-content-between align-items-center bg-white">
                                            <h5 class="fw-bold m-0"><i
                                                    class="fas fa-history me-2 text-primary"></i>Recent Orders</h5>
                                            <input type="text" class="form-control form-control-sm"
                                                placeholder="Search Order ID" style="width: 200px;">
                                        </div>
                                        <div class="table-responsive">
                                            <table class="table zenith-table align-middle mb-0">
                                                <thead>
                                                    <tr>
                                                        <th class="ps-4">Order ID</th>
                                                        <th>Date</th>
                                                        <th>Customer</th>
                                                        <th>Items</th>
                                                        <th>Total</th>
                                                        <th>Status</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="shop-orders-body">
                                                    <!-- Populated by JS -->
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>

                                <!-- 3. Products Tab -->
                                <div id="tab-products" class="tab-content-pane">
                                    <div class="row g-4" id="products-grid">
                                        <!-- Products Populated via JS -->
                                    </div>
                                </div>

                                <!-- 4. Settings Tab -->
                                <div id="tab-settings" class="tab-content-pane">
                                    <div class="glass-panel p-5 text-center">
                                        <i class="fas fa-cogs fa-3x text-muted mb-3 opacity-50"></i>
                                        <h5 class="text-muted">Shop Settings & Configuration</h5>
                                        <p class="text-muted small">Configure delivery zones, timing, and notification
                                            preferences here.</p>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </main>

                    <!-- Product Modal -->
                    <div class="modal fade" id="productModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content border-0 shadow-lg">
                                <div class="modal-header bg-white border-bottom-0 pb-0">
                                    <h5 class="modal-title fw-bold" id="productModalTitle">Add Product</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <div class="modal-body p-4">
                                    <form id="productForm">
                                        <div class="mb-3">
                                            <label class="zenith-form-label">Product Name</label>
                                            <input type="text" id="prod-name" class="form-control zenith-input">
                                        </div>
                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <label class="zenith-form-label">Category</label>
                                                <select id="prod-cat" class="form-select zenith-input">
                                                    <option>Chicken</option>
                                                    <option>Mutton</option>
                                                    <option>Eggs</option>
                                                    <option>Fish</option>
                                                </select>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="zenith-form-label">Price (₹)</label>
                                                <input type="number" id="prod-price" class="form-control zenith-input">
                                            </div>
                                            <div class="col-md-6">
                                                <label class="zenith-form-label">Status</label>
                                                <select id="prod-status" class="form-select zenith-input">
                                                    <option value="Available">Available</option>
                                                    <option value="Out of Stock">Out of Stock</option>
                                                </select>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="zenith-form-label">Image URL</label>
                                                <input type="text" id="prod-img" class="form-control zenith-input"
                                                    placeholder="http://...">
                                            </div>
                                        </div>
                                    </form>
                                </div>
                                <div class="modal-footer border-top-0 pt-0">
                                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                    <button type="button" class="btn btn-zenith-primary px-4">Save Product</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script src="${pageContext.request.contextPath}/resources/js/shop-view.js"></script>
                    <%@ include file="/includes/footer.jsp" %>