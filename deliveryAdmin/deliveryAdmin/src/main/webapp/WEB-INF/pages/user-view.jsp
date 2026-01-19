<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <fmt:setLocale value="en_IN" />
                <%@ include file="/includes/header.jsp" %>

                    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user-view.css">

                    <main class="main-content">
                        <div class="container-fluid">
                            <!-- Breadcrumb & Back -->
                            <div class="d-flex justify-content-between align-items-center mb-4 pt-3">
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb mb-0">
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/user"
                                                class="text-decoration-none text-muted">Users</a></li>
                                        <li class="breadcrumb-item active" aria-current="page">User Details</li>
                                    </ol>
                                </nav>
                                <a href="${pageContext.request.contextPath}/user" class="btn btn-zenith-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>Back to List
                                </a>
                            </div>

                            <!-- Profile Header -->
                            <div class="profile-header-card fade-in-up">
                                <img id="header-img" src="" alt="Profile" class="profile-avatar-lg">
                                <div class="profile-info flex-grow-1">
                                    <h2 id="header-name">Loading...</h2>
                                    <div class="profile-meta">
                                        <span id="header-email"><i class="fas fa-envelope"></i> -</span>
                                        <span id="header-phone"><i class="fas fa-phone"></i> -</span>
                                    </div>
                                </div>

                                <!-- Quick Stats in Header -->
                                <div class="d-flex gap-4 border-start ps-4">
                                    <div class="text-center">
                                        <div class="h3 fw-bold text-primary mb-0">24</div>
                                        <small class="text-muted text-uppercase"
                                            style="font-size: 0.7rem;">Orders</small>
                                    </div>
                                    <div class="text-center">
                                        <div class="h3 fw-bold text-success mb-0">₹15.4k</div>
                                        <small class="text-muted text-uppercase"
                                            style="font-size: 0.7rem;">Spent</small>
                                    </div>
                                    <div class="text-center">
                                        <div class="h3 fw-bold text-warning mb-0" id="header-status-val">Active</div>
                                        <small class="text-muted text-uppercase"
                                            style="font-size: 0.7rem;">Status</small>
                                    </div>
                                </div>
                            </div>

                            <!-- Tabs Navigation -->
                            <div class="zenith-tabs">
                                <button class="zenith-tab-btn active" data-tab="tab-profile">
                                    <i class="fas fa-user me-2"></i>Profile
                                </button>
                                <button class="zenith-tab-btn" data-tab="tab-orders">
                                    <i class="fas fa-shopping-bag me-2"></i>Orders
                                </button>
                                <button class="zenith-tab-btn" data-tab="tab-addresses">
                                    <i class="fas fa-map-marker-alt me-2"></i>Addresses
                                </button>
                                <button class="zenith-tab-btn" data-tab="tab-preferences">
                                    <i class="fas fa-cog me-2"></i>Preferences & Settings
                                </button>
                                <button class="zenith-tab-btn" data-tab="tab-reviews">
                                    <i class="fas fa-star me-2"></i>Reviews
                                </button>
                            </div>

                            <!-- Tabs Content -->
                            <div class="tab-content">

                                <!-- 1. Profile Tab -->
                                <div id="tab-profile" class="tab-content-pane active">
                                    <div class="glass-panel p-4">
                                        <div class="d-flex justify-content-between align-items-center mb-4">
                                            <h5 class="fw-bold m-0 text-dark"><i
                                                    class="fas fa-id-card me-2 text-primary"></i>Personal Information
                                            </h5>
                                            <button class="btn btn-sm btn-zenith-primary"><i
                                                    class="fas fa-save me-2"></i>Save Changes</button>
                                        </div>
                                        <div class="row g-4">
                                            <div class="col-md-6">
                                                <label class="zenith-form-label">Full Name</label>
                                                <input type="text" id="input-name" class="form-control zenith-input">
                                            </div>
                                            <div class="col-md-6">
                                                <label class="zenith-form-label">Date of Birth</label>
                                                <input type="date" id="input-dob" class="form-control zenith-input">
                                            </div>
                                            <div class="col-md-6">
                                                <label class="zenith-form-label">Email Address</label>
                                                <input type="email" id="input-email" class="form-control zenith-input">
                                            </div>
                                            <div class="col-md-6">
                                                <label class="zenith-form-label">Phone Number</label>
                                                <input type="tel" id="input-phone" class="form-control zenith-input">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- 2. ADDRESSES TAB (Master-Detail) -->
                                <div id="tab-addresses" class="tab-content-pane">
                                    <div class="row g-4 h-100">
                                        <!-- Left: Address List -->
                                        <div class="col-lg-4 border-end">
                                            <div class="d-flex justify-content-between align-items-center mb-3">
                                                <h6 class="fw-bold m-0 text-muted text-uppercase small ls-1">Saved
                                                    Locations</h6>
                                                <button class="btn btn-sm btn-light text-primary rounded-circle"
                                                    onclick="createNewAddress()">
                                                    <i class="fas fa-plus"></i>
                                                </button>
                                            </div>
                                            <div class="address-list-scroll" id="address-list-container"
                                                style="max-height: 600px; overflow-y: auto; padding-right: 5px;">
                                                <!-- List populated by JS -->
                                            </div>
                                        </div>

                                        <!-- Right: Address Detail / Edit Form -->
                                        <div class="col-lg-8">
                                            <div class="glass-panel p-4 h-100 position-relative">
                                                <div class="d-flex justify-content-between align-items-center mb-4">
                                                    <h5 class="fw-bold m-0 text-dark" id="addr-detail-title"><i
                                                            class="fas fa-map-marker-alt me-2 text-primary"></i>Address
                                                        Details</h5>
                                                    <div>
                                                        <button class="btn btn-sm btn-danger me-2 d-none"
                                                            id="btn-delete-addr" onclick="deleteCurrentAddress()">
                                                            <i class="fas fa-trash me-2"></i>Delete
                                                        </button>
                                                        <button class="btn btn-sm btn-zenith-primary"
                                                            onclick="saveAddressMasterDetail()">
                                                            <i class="fas fa-save me-2"></i>Save Address
                                                        </button>
                                                    </div>
                                                </div>

                                                <form id="addressForm">
                                                    <input type="hidden" id="addr-id">

                                                    <div class="row g-3">
                                                        <div class="col-12">
                                                            <label class="zenith-form-label">Location Type</label>
                                                            <div class="d-flex gap-2">
                                                                <input type="radio" class="btn-check" name="addrType"
                                                                    id="type-home" value="HOME" checked
                                                                    onchange="toggleReceiverFields()">
                                                                <label class="btn btn-outline-primary px-3 rounded-pill"
                                                                    for="type-home">Home</label>

                                                                <input type="radio" class="btn-check" name="addrType"
                                                                    id="type-work" value="WORK"
                                                                    onchange="toggleReceiverFields()">
                                                                <label class="btn btn-outline-primary px-3 rounded-pill"
                                                                    for="type-work">Work</label>

                                                                <input type="radio" class="btn-check" name="addrType"
                                                                    id="type-others" value="OTHERS"
                                                                    onchange="toggleReceiverFields()">
                                                                <label class="btn btn-outline-primary px-3 rounded-pill"
                                                                    for="type-others">Others</label>
                                                            </div>
                                                        </div>

                                                        <div class="col-12" id="receiver-fields" style="display:none;">
                                                            <div class="p-3 bg-light rounded border">
                                                                <div class="row g-3">
                                                                    <div class="col-md-6">
                                                                        <label class="zenith-form-label">Receiver
                                                                            Name</label>
                                                                        <input type="text" id="addr-receiver-name"
                                                                            class="form-control zenith-input">
                                                                    </div>
                                                                    <div class="col-md-6">
                                                                        <label class="zenith-form-label">Receiver
                                                                            Phone</label>
                                                                        <input type="text" id="addr-receiver-phone"
                                                                            class="form-control zenith-input">
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="zenith-form-label">House / Flat No</label>
                                                            <input type="text" id="addr-house-no"
                                                                class="form-control zenith-input"
                                                                placeholder="e.g. 104A">
                                                        </div>
                                                        <div class="col-md-8">
                                                            <label class="zenith-form-label">Landmark</label>
                                                            <input type="text" id="addr-landmark"
                                                                class="form-control zenith-input"
                                                                placeholder="e.g. Near Metro Station">
                                                        </div>

                                                        <div class="col-12">
                                                            <label class="zenith-form-label">Full Address</label>
                                                            <textarea id="addr-text" class="form-control zenith-input"
                                                                rows="3"
                                                                placeholder="Click to edit address..."></textarea>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <label class="zenith-form-label">Latitude</label>
                                                            <input type="text" id="addr-lat"
                                                                class="form-control zenith-input"
                                                                placeholder="e.g. 12.9716">
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="zenith-form-label">Longitude</label>
                                                            <input type="text" id="addr-lng"
                                                                class="form-control zenith-input"
                                                                placeholder="e.g. 77.5946">
                                                        </div>
                                                    </div>
                                                </form>

                                                <!-- Placeholder Map or Graphic -->
                                                <div class="mt-4 border rounded overflow-hidden"
                                                    style="height: 150px; background: #e2e8f0; display: flex; align-items: center; justify-content: center;">
                                                    <div class="text-center text-muted">
                                                        <i class="fas fa-map-marked-alt fa-2x mb-2"></i>
                                                        <p class="mb-0 small">Map Preview (Static)</p>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 3. Orders Tab -->
                            <div id="tab-orders" class="tab-content-pane">
                                <div class="glass-panel p-0 overflow-hidden">
                                    <div
                                        class="p-4 border-bottom d-flex justify-content-between align-items-center bg-white">
                                        <h5 class="fw-bold m-0"><i class="fas fa-history me-2 text-primary"></i>Order
                                            History</h5>
                                        <div class="d-flex gap-2">
                                            <div class="input-group input-group-sm" style="width: 200px;">
                                                <span class="input-group-text bg-white border-end-0"><i
                                                        class="fas fa-search text-muted"></i></span>
                                                <input type="text" id="order-search-input"
                                                    class="form-control border-start-0"
                                                    placeholder="Search Order ID...">
                                            </div>
                                            <select class="form-select form-select-sm" style="width: 150px;">
                                                <option>All Status</option>
                                                <option>Completed</option>
                                                <option>Pending</option>
                                                <option>Returned</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="table zenith-table align-middle mb-0">
                                            <thead>
                                                <tr>
                                                    <th class="ps-4">Order ID</th>
                                                    <th>Date</th>
                                                    <th>Items</th>
                                                    <th>Total</th>
                                                    <th>Status</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody id="orders-table-body">
                                                <!-- Populated by JS -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <!-- 3. Preferences Tab -->
                            <div id="tab-preferences" class="tab-content-pane">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="glass-panel p-4 h-100">
                                            <h5 class="fw-bold mb-4"><i
                                                    class="fas fa-comment-dots me-2 text-primary"></i>Communication
                                                Channels</h5>

                                            <div class="toggle-switch">
                                                <div>
                                                    <h6 class="m-0 fw-bold">SMS Notifications</h6>
                                                    <small class="text-muted">Receive updates via SMS</small>
                                                </div>
                                                <label class="switch">
                                                    <input type="checkbox" id="sms-toggle">
                                                    <span class="slider"></span>
                                                </label>
                                            </div>

                                            <div class="toggle-switch">
                                                <div>
                                                    <h6 class="m-0 fw-bold">WhatsApp Updates</h6>
                                                    <small class="text-muted">Order confirmation & tracking</small>
                                                </div>
                                                <label class="switch">
                                                    <input type="checkbox" id="whatsapp-toggle">
                                                    <span class="slider"></span>
                                                </label>
                                            </div>

                                            <div class="toggle-switch">
                                                <div>
                                                    <h6 class="m-0 fw-bold">Email Newsletter</h6>
                                                    <small class="text-muted">Weekly deals and offers</small>
                                                </div>
                                                <label class="switch">
                                                    <input type="checkbox" id="email-toggle">
                                                    <span class="slider"></span>
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="glass-panel p-4 h-100">
                                            <h5 class="fw-bold mb-4"><i
                                                    class="fas fa-bullhorn me-2 text-primary"></i>Marketing & Promo
                                            </h5>

                                            <div class="toggle-switch">
                                                <div>
                                                    <h6 class="m-0 fw-bold">Promotional Offers</h6>
                                                    <small class="text-muted">Allow personalized promotions</small>
                                                </div>
                                                <label class="switch">
                                                    <input type="checkbox" id="promo-toggle">
                                                    <span class="slider"></span>
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 4. Reviews Tab -->
                            <div id="tab-reviews" class="tab-content-pane">
                                <div class="glass-panel p-4 text-center py-5">
                                    <img src="${pageContext.request.contextPath}/resources/images/star-rating.png"
                                        width="80" class="mb-3 opacity-50" alt="Reviews">
                                    <h5 class="text-muted">No reviews submitted by this user yet.</h5>
                                </div>
                            </div>

                        </div>
                        </div>
                    </main>

                    <!-- Order Details Modal -->
                    <div class="modal fade" id="orderDetailsModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-centered">
                            <div class="modal-content border-0 shadow-lg">
                                <div class="modal-header bg-zenith-primary border-0"
                                    style="background: linear-gradient(135deg, #1a1a1a 0%, #4a4a4a 100%); color:white;">
                                    <h5 class="modal-title font-weight-bold">Order Details</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <div class="modal-body p-4" id="orderDetailsContent">
                                    <!-- Content loaded dynamically via JS -->
                                    <div class="text-center py-5">
                                        <div class="spinner-border text-primary" role="status">
                                            <span class="visually-hidden">Loading...</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer border-0 bg-light">
                                    <span class="text-muted small me-auto">Order ID: <span id="modalOrderId"
                                            class="fw-bold">...</span></span>
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Close</button>
                                    <button type="button" class="btn btn-primary" onclick="window.print()">
                                        <i class="fas fa-print me-2"></i>Print Invoice
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Address Modal -->
                    <div class="modal fade" id="addressModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content border-0 shadow-lg">
                                <div class="modal-header bg-white border-bottom-0 pb-0">
                                    <h5 class="modal-title fw-bold" id="addressModalTitle">Add New Address</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <div class="modal-body p-4">
                                    <form id="addressForm">
                                        <input type="hidden" id="addr-id">

                                        <div class="mb-3">
                                            <label class="zenith-form-label">Address Type</label>
                                            <div class="d-flex gap-2">
                                                <input type="radio" class="btn-check" name="addrType" id="type-home"
                                                    value="HOME" checked onchange="toggleReceiverFields()">
                                                <label class="btn btn-outline-primary flex-fill"
                                                    for="type-home">Home</label>

                                                <input type="radio" class="btn-check" name="addrType" id="type-work"
                                                    value="WORK" onchange="toggleReceiverFields()">
                                                <label class="btn btn-outline-primary flex-fill"
                                                    for="type-work">Work</label>

                                                <input type="radio" class="btn-check" name="addrType" id="type-others"
                                                    value="OTHERS" onchange="toggleReceiverFields()">
                                                <label class="btn btn-outline-primary flex-fill"
                                                    for="type-others">Others</label>
                                            </div>
                                        </div>

                                        <div id="receiver-fields" class="mb-3" style="display:none;">
                                            <div class="row g-2">
                                                <div class="col-6">
                                                    <label class="zenith-form-label small">Receiver Name</label>
                                                    <input type="text" id="addr-receiver-name"
                                                        class="form-control zenith-input">
                                                </div>
                                                <div class="col-6">
                                                    <label class="zenith-form-label small">Receiver Phone</label>
                                                    <input type="text" id="addr-receiver-phone"
                                                        class="form-control zenith-input">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label class="zenith-form-label">House/Flat No</label>
                                            <input type="text" id="addr-house-no" class="form-control zenith-input"
                                                placeholder="e.g. Flat 101, Galaxy Apts">
                                        </div>

                                        <div class="mb-3">
                                            <label class="zenith-form-label">Full Address</label>
                                            <textarea id="addr-text" class="form-control zenith-input" rows="3"
                                                placeholder="Enter complete address area, street, etc."></textarea>
                                        </div>

                                        <div class="mb-3">
                                            <label class="zenith-form-label">Landmark</label>
                                            <input type="text" id="addr-landmark" class="form-control zenith-input"
                                                placeholder="Near City Mall">
                                        </div>

                                        <div class="row g-2">
                                            <div class="col-6">
                                                <label class="zenith-form-label small">Latitude</label>
                                                <input type="text" id="addr-lat" class="form-control zenith-input"
                                                    placeholder="0.0000">
                                            </div>
                                            <div class="col-6">
                                                <label class="zenith-form-label small">Longitude</label>
                                                <input type="text" id="addr-lng" class="form-control zenith-input"
                                                    placeholder="0.0000">
                                            </div>
                                        </div>
                                    </form>
                                </div>
                                <div class="modal-footer border-top-0 pt-0">
                                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                    <button type="button" class="btn btn-primary px-4" onclick="saveAddress()">Save
                                        Address</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script src="${pageContext.request.contextPath}/resources/js/user-view.js"></script>
                    <%@ include file="/includes/footer.jsp" %>