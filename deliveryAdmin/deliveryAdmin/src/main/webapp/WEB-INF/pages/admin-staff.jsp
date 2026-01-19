<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <%@ include file="/includes/header.jsp" %>

                    <meta name="_csrf" content="${_csrf.token}" />
                    <meta name="_csrf_header" content="${_csrf.headerName}" />

                    <main class="main-content">
                        <!-- Success/Error Messages -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                ${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>

                        <div class="d-flex justify-content-between align-items-center mb-5 animate-enter">
                            <div>
                                <h1 class="page-title">Admin & Staff Management</h1>
                                <p class="page-subtitle">Manage roles, permissions, and team performance</p>
                            </div>
                            <button class="btn-zenith-primary d-flex align-items-center" data-bs-toggle="modal"
                                data-bs-target="#addStaffModal">
                                <i class="fas fa-plus me-2"></i> Add New Staff
                            </button>
                        </div>

                        <!-- Quick Stats Cards -->
                        <div class="stats-grid mb-5 animate-enter" style="animation-delay: 0.1s;">
                            <div class="glass-panel stat-card">
                                <div class="stat-info">
                                    <h6>Total Staff</h6>
                                    <h3>${totalStaff}</h3>
                                </div>
                                <div class="stat-icon icon-blue">
                                    <i class="fas fa-users"></i>
                                </div>
                            </div>

                            <div class="glass-panel stat-card">
                                <div class="stat-info">
                                    <h6>Active Members</h6>
                                    <h3>${activeStaff}</h3>
                                </div>
                                <div class="stat-icon icon-green">
                                    <i class="fas fa-user-check"></i>
                                </div>
                            </div>

                            <div class="glass-panel stat-card">
                                <div class="stat-info">
                                    <h6>Pending Tasks</h6>
                                    <h3>${pendingTasks}</h3>
                                </div>
                                <div class="stat-icon icon-yellow">
                                    <i class="fas fa-tasks"></i>
                                </div>
                            </div>

                            <div class="glass-panel stat-card">
                                <div class="stat-info">
                                    <h6>Rejected</h6>
                                    <h3>${rejectedStaff}</h3>
                                </div>
                                <div class="stat-icon icon-red">
                                    <i class="fas fa-user-times"></i>
                                </div>
                            </div>
                        </div>

                        <!-- Main Staff Management Panel -->
                        <div class="glass-panel mb-5 animate-enter" style="animation-delay: 0.2s;">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h5 class="fw-bold fs-4 mb-0">Team Members</h5>
                                <div class="btn-group">
                                    <button class="btn btn-zenith btn-light dropdown-toggle" type="button"
                                        data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="fas fa-filter me-2 text-primary"></i> Filter by Role
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end border-0 shadow-lg">
                                        <li><a class="dropdown-item py-2" href="#" data-filter="all">All Roles</a></li>
                                        <li>
                                            <hr class="dropdown-divider">
                                        </li>
                                        <li><a class="dropdown-item py-2" href="#" data-filter="ADMIN">Admins</a></li>
                                        <li><a class="dropdown-item py-2" href="#" data-filter="SUB_ADMIN">Sub
                                                Admins</a></li>
                                        <li><a class="dropdown-item py-2" href="#" data-filter="MANAGER">Managers</a>
                                        </li>
                                        <li><a class="dropdown-item py-2" href="#" data-filter="RIDER">Delivery
                                                Riders</a></li>
                                    </ul>
                                </div>
                            </div>

                            <div class="zenith-table-container">
                                <table class="zenith-table" id="staffTable">
                                    <thead>
                                        <tr>
                                            <th>Staff Member</th>
                                            <th>Role & Status</th>
                                            <th>Contact</th>
                                            <th>Access</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="staff" items="${staffList}">
                                            <c:set var="accessStr">
                                                <c:forEach items="${staff.accessPages}" var="p" varStatus="s">${p}${not
                                                    s.last ? ',' : ''}</c:forEach>
                                            </c:set>
                                            <tr data-staff-id="${staff.id}" data-access-pages="${accessStr}">
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <img src="${not empty staff.profileImage ? staff.profileImage : pageContext.request.contextPath.concat('/resources/images/default-avatar.jpg')}"
                                                            class="avatar-group-item me-3" alt="${staff.name}">
                                                        <div>
                                                            <h6 class="mb-0 fw-bold">${staff.name}</h6>
                                                            <small class="text-secondary">${staff.email}</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="d-flex flex-column gap-2">
                                                        <span class="badge-zenith ${staff.role == 'ADMIN' ? 'badge-admin' :
                                                           staff.role == 'SUB_ADMIN' ? 'badge-subadmin' :
                                                           staff.role == 'MANAGER' ? 'badge-manager' :
                                                           staff.role == 'RIDER' ? 'badge-rider' : 'badge-inactive'}">
                                                            <i class="fas fa-shield-alt"></i> ${staff.role}
                                                        </span>
                                                        <span
                                                            class="badge-zenith ${staff.active ? 'badge-rider' : 'badge-inactive'}">
                                                            <i class="fas fa-circle fs-xs"></i> ${staff.active ?
                                                            'Active' : 'Inactive'}
                                                        </span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center text-secondary">
                                                        <i class="fas fa-phone-alt me-2 fs-xs"></i> ${staff.phone}
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty staff.accessPages}">
                                                        <div class="d-flex align-items-center text-primary fw-medium">
                                                            <i class="fas fa-layer-group me-2"></i>
                                                            ${fn:length(staff.accessPages)} Pages
                                                        </div>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <div class="d-flex">
                                                        <button class="btn-icon"
                                                            onclick="openPermissionsModal('${staff.id}')"
                                                            data-bs-toggle="tooltip" title="Manage Access">
                                                            <i class="fas fa-key"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Manage Access Modal -->
                        <div class="modal fade" id="permissionsModal" tabindex="-1">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content glass-modal">
                                    <div class="modal-header">
                                        <h5 class="modal-title fw-bold">Manage Page Access</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body p-4">
                                        <p class="text-muted mb-4">Select the pages this staff member is allowed to
                                            access.
                                            Unchecked pages will be hidden from their sidebar.</p>
                                        <form id="permissionsForm">
                                            <input type="hidden" id="permStaffId" name="staffId">

                                            <div class="row g-3">
                                                <div class="col-12 mb-2">
                                                    <h6 class="fw-bold text-primary border-bottom pb-2">Core Access</h6>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="DASHBOARD" id="perm_DASHBOARD" checked disabled>
                                                        <label class="form-check-label"
                                                            for="perm_DASHBOARD">Dashboard</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="ADMIN_STAFF" id="perm_ADMIN_STAFF">
                                                        <label class="form-check-label" for="perm_ADMIN_STAFF">Admin &
                                                            Staff</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="SYSTEM_SETTINGS" id="perm_SYSTEM_SETTINGS">
                                                        <label class="form-check-label"
                                                            for="perm_SYSTEM_SETTINGS">System Settings Grp</label>
                                                    </div>
                                                </div>

                                                <div class="col-12 mt-3 mb-2">
                                                    <h6 class="fw-bold text-primary border-bottom pb-2">User Management
                                                    </h6>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="USER_MANAGEMENT" id="perm_USER_MANAGEMENT">
                                                        <label class="form-check-label" for="perm_USER_MANAGEMENT">User
                                                            Menu Grp</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="USER_PAGE" id="perm_USER_PAGE">
                                                        <label class="form-check-label" for="perm_USER_PAGE">Users
                                                            List</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="USER_EARNINGS" id="perm_USER_EARNINGS">
                                                        <label class="form-check-label" for="perm_USER_EARNINGS">User
                                                            Revenue</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="USER_REVIEWS" id="perm_USER_REVIEWS">
                                                        <label class="form-check-label" for="perm_USER_REVIEWS">Ratings
                                                            & Reviews</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="USER_CARTS" id="perm_USER_CARTS">
                                                        <label class="form-check-label"
                                                            for="perm_USER_CARTS">Carts</label>
                                                    </div>
                                                </div>

                                                <div class="col-12 mt-3 mb-2">
                                                    <h6 class="fw-bold text-primary border-bottom pb-2">Vendor
                                                        Management</h6>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="VENDOR_MANAGEMENT" id="perm_VENDOR_MANAGEMENT">
                                                        <label class="form-check-label"
                                                            for="perm_VENDOR_MANAGEMENT">Vendor Menu Grp</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="SHOPS_PAGE" id="perm_SHOPS_PAGE">
                                                        <label class="form-check-label" for="perm_SHOPS_PAGE">Shops
                                                            List</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="CATEGORIES_MANAGEMENT"
                                                            id="perm_CATEGORIES_MANAGEMENT">
                                                        <label class="form-check-label"
                                                            for="perm_CATEGORIES_MANAGEMENT">Categories</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="SHOPS_EARNINGS" id="perm_SHOPS_EARNINGS">
                                                        <label class="form-check-label" for="perm_SHOPS_EARNINGS">Shop
                                                            Earnings</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="SHOPS_ADS" id="perm_SHOPS_ADS">
                                                        <label class="form-check-label" for="perm_SHOPS_ADS">Ads &
                                                            Promo</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="ORDERS_BILLINGS" id="perm_ORDERS_BILLINGS">
                                                        <label class="form-check-label"
                                                            for="perm_ORDERS_BILLINGS">Orders & Billing</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="COMMISSIONS_REPORT" id="perm_COMMISSIONS_REPORT">
                                                        <label class="form-check-label"
                                                            for="perm_COMMISSIONS_REPORT">Commissions</label>
                                                    </div>
                                                </div>

                                                <div class="col-12 mt-3 mb-2">
                                                    <h6 class="fw-bold text-primary border-bottom pb-2">Delivery System
                                                    </h6>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="DELIVERY_SYSTEM" id="perm_DELIVERY_SYSTEM">
                                                        <label class="form-check-label"
                                                            for="perm_DELIVERY_SYSTEM">Delivery Menu Grp</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="DELIVERY_ORDERS" id="perm_DELIVERY_ORDERS">
                                                        <label class="form-check-label"
                                                            for="perm_DELIVERY_ORDERS">Delivery Orders</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="DELIVERY_MANAGE" id="perm_DELIVERY_MANAGE">
                                                        <label class="form-check-label"
                                                            for="perm_DELIVERY_MANAGE">Delivery Boys</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input perm-check" type="checkbox"
                                                            value="DELIVERY_EARNINGS" id="perm_DELIVERY_EARNINGS">
                                                        <label class="form-check-label"
                                                            for="perm_DELIVERY_EARNINGS">Delivery Earnings</label>
                                                    </div>
                                                </div>
                                                <div class="form-check">
                                                    <input class="form-check-input perm-check" type="checkbox"
                                                        value="DELIVERY_PAYMENTS" id="perm_DELIVERY_PAYMENTS">
                                                    <label class="form-check-label"
                                                        for="perm_DELIVERY_PAYMENTS">Payments</label>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-check">
                                                    <input class="form-check-input perm-check" type="checkbox"
                                                        value="DELIVERY_INCENTIVES" id="perm_DELIVERY_INCENTIVES">
                                                    <label class="form-check-label"
                                                        for="perm_DELIVERY_INCENTIVES">Incentives</label>
                                                </div>
                                            </div>

                                            <div class="col-12 mt-3 mb-2">
                                                <h6 class="fw-bold text-primary border-bottom pb-2">Operations &
                                                    Analytics</h6>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-check">
                                                    <input class="form-check-input perm-check" type="checkbox"
                                                        value="REPORTS" id="perm_REPORTS">
                                                    <label class="form-check-label" for="perm_REPORTS">Reports
                                                        (Main)</label>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-check">
                                                    <input class="form-check-input perm-check" type="checkbox"
                                                        value="PROFIT" id="perm_PROFIT">
                                                    <label class="form-check-label" for="perm_PROFIT">Profit</label>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-check">
                                                    <input class="form-check-input perm-check" type="checkbox"
                                                        value="BANNERS" id="perm_BANNERS">
                                                    <label class="form-check-label" for="perm_BANNERS">Banners</label>
                                                </div>
                                            </div>

                                            <div class="col-md-4">
                                                <div class="form-check">
                                                    <input class="form-check-input perm-check" type="checkbox"
                                                        value="RECIPES" id="perm_RECIPES">
                                                    <label class="form-check-label" for="perm_RECIPES">Recipes</label>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-check">
                                                    <input class="form-check-input perm-check" type="checkbox"
                                                        value="APP_HOMEPAGE" id="perm_APP_HOMEPAGE">
                                                    <label class="form-check-label" for="perm_APP_HOMEPAGE">App
                                                        Homepage</label>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-check">
                                                    <input class="form-check-input perm-check" type="checkbox"
                                                        value="NOTIFICATIONS" id="perm_NOTIFICATIONS">
                                                    <label class="form-check-label"
                                                        for="perm_NOTIFICATIONS">Notifications</label>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-check">
                                                    <input class="form-check-input perm-check" type="checkbox"
                                                        value="SMS_INTEGRATION" id="perm_SMS_INTEGRATION">
                                                    <label class="form-check-label" for="perm_SMS_INTEGRATION">SMS
                                                        Integration</label>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-check">
                                                    <input class="form-check-input perm-check" type="checkbox"
                                                        value="COUPON_CODE" id="perm_COUPON_CODE">
                                                    <label class="form-check-label" for="perm_COUPON_CODE">Coupon
                                                        Codes</label>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-check">
                                                    <input class="form-check-input perm-check" type="checkbox"
                                                        value="HELP_SUPPORT" id="perm_HELP_SUPPORT">
                                                    <label class="form-check-label" for="perm_HELP_SUPPORT">Help &
                                                        Support</label>
                                                </div>
                                            </div>
                                    </div>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                    <button type="button" class="btn btn-zenith-primary"
                                        onclick="savePermissions()">Save Changes</button>
                                </div>
                            </div>
                        </div>
                        </div>


                        <!-- Add Staff Modal -->
                        <div class="modal fade" id="addStaffModal" tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <form class="modal-content glass-modal" id="addStaffForm" method="post"
                                    action="${pageContext.request.contextPath}/admin-staff/add"
                                    enctype="multipart/form-data">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"
                                        id="csrfToken" />

                                    <div class="modal-header">
                                        <h5 class="modal-title fw-bold">Add New Staff Member</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>

                                    <div class="modal-body p-4">
                                        <div class="row g-4">
                                            <div class="col-md-6">
                                                <div class="form-floating-zenith mb-3">
                                                    <label class="form-label ms-1 small fw-bold text-secondary">Full
                                                        Name</label>
                                                    <input type="text" name="name" class="form-control" required
                                                        placeholder="John Doe">
                                                </div>
                                                <div class="form-floating-zenith mb-3">
                                                    <label class="form-label ms-1 small fw-bold text-secondary">Email
                                                        Address</label>
                                                    <input type="email" name="email" class="form-control" required
                                                        placeholder="john@example.com">
                                                </div>
                                                <div class="form-floating-zenith mb-3">
                                                    <label class="form-label ms-1 small fw-bold text-secondary">Phone
                                                        Number</label>
                                                    <input type="tel" name="phone" class="form-control"
                                                        placeholder="+91 98765 43210">
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="form-floating-zenith mb-3">
                                                    <label class="form-label ms-1 small fw-bold text-secondary">Assign
                                                        Role</label>
                                                    <select name="role" class="form-select" required id="staffRole"
                                                        onchange="updateAccessOptions()">
                                                        <option value="">Select Role...</option>
                                                        <option value="ADMIN">Admin</option>
                                                        <option value="SUB_ADMIN">Sub Admin</option>
                                                        <option value="MANAGER">Manager</option>
                                                        <option value="RIDER">Delivery Rider</option>
                                                        <option value="SUPPORT">Customer Support</option>
                                                    </select>
                                                </div>
                                                <div class="form-floating-zenith mb-3">
                                                    <label
                                                        class="form-label ms-1 small fw-bold text-secondary">Password</label>
                                                    <div class="input-group">
                                                        <input type="password" name="password" class="form-control"
                                                            required id="passwordField" style="border-right: none;">
                                                        <button
                                                            class="btn btn-outline-secondary bg-white border-start-0"
                                                            type="button" id="togglePassword"
                                                            style="border-color: #e5e7eb;">
                                                            <i class="fas fa-eye text-secondary"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                                <div class="form-floating-zenith mb-3">
                                                    <label class="form-label ms-1 small fw-bold text-secondary">Profile
                                                        Photo</label>
                                                    <input type="file" name="profileImage" class="form-control"
                                                        accept="image/*">
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Page Access Section -->
                                        <div class="mt-4">
                                            <label class="form-label fw-bold mb-3 d-block">Access Permissions
                                                (Auto-selected
                                                by Role)</label>
                                            <div class="p-3 bg-light rounded-3 border">
                                                <div class="row g-3">
                                                    <div class="col-md-4">
                                                        <div class="form-check">
                                                            <input class="form-check-input page-access" type="checkbox"
                                                                name="accessPages" value="DASHBOARD"
                                                                id="dashboardAccess" checked disabled>
                                                            <label class="form-check-label fw-medium"
                                                                for="dashboardAccess">Dashboard</label>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="form-check">
                                                            <input class="form-check-input page-access" type="checkbox"
                                                                name="accessPages" value="USER_MANAGEMENT"
                                                                id="userManagementAccess">
                                                            <label class="form-check-label fw-medium"
                                                                for="userManagementAccess">User Management</label>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="form-check">
                                                            <input class="form-check-input page-access" type="checkbox"
                                                                name="accessPages" value="VENDOR_MANAGEMENT"
                                                                id="vendorManagementAccess">
                                                            <label class="form-check-label fw-medium"
                                                                for="vendorManagementAccess">Vendor Management</label>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="form-check">
                                                            <input class="form-check-input page-access" type="checkbox"
                                                                name="accessPages" value="DELIVERY_SYSTEM"
                                                                id="deliverySystemAccess">
                                                            <label class="form-check-label fw-medium"
                                                                for="deliverySystemAccess">Delivery System</label>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="form-check">
                                                            <input class="form-check-input page-access" type="checkbox"
                                                                name="accessPages" value="REPORTS" id="reportsAccess">
                                                            <label class="form-check-label fw-medium"
                                                                for="reportsAccess">Reports & Stats</label>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="form-check">
                                                            <input class="form-check-input page-access" type="checkbox"
                                                                name="accessPages" value="SYSTEM_SETTINGS"
                                                                id="systemSettingsAccess">
                                                            <label class="form-check-label fw-medium"
                                                                for="systemSettingsAccess">System Settings</label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </div>

                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-light"
                                            data-bs-dismiss="modal">Cancel</button>
                                        <button type="submit" class="btn btn-zenith-primary">Create Account</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Delete Confirm Modal -->
                        <div class="modal fade" id="deleteConfirmModal" tabindex="-1">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content glass-modal text-center p-4">
                                    <div class="modal-body">
                                        <div class="mb-3 text-danger">
                                            <i class="fas fa-exclamation-circle fa-3x"></i>
                                        </div>
                                        <h5 class="fw-bold mb-2">Remove Staff Member?</h5>
                                        <p class="text-secondary mb-4">This action cannot be undone. Their access to the
                                            system will be revoked immediately.</p>
                                        <input type="hidden" id="deleteStaffId">
                                        <div class="d-flex justify-content-center gap-3">
                                            <button type="button" class="btn btn-light px-4"
                                                data-bs-dismiss="modal">Cancel</button>
                                            <button type="button" class="btn btn-danger px-4"
                                                onclick="deleteStaff()">Confirm Delete</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <script src="https://cdn.tailwindcss.com"></script>
                        <%@ include file="/includes/footer.jsp" %>
                            <link rel="stylesheet"
                                href="${pageContext.request.contextPath}/resources/css/admin-staff.css">
                            <script src="${pageContext.request.contextPath}/resources/js/admin-staff.js"></script>

                            <script>
                                const pageContext = {
                                    request: {
                                        contextPath: '${pageContext.request.contextPath}'
                                    }
                                };
                            </script>