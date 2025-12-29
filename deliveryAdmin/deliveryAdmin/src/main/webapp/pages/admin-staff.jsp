<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/includes/header.jsp" %>

<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<main class="main-content">
    <!-- Success/Error Messages -->
    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div id="successToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header">
            <strong class="me-auto">Notification</strong>
            <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body">
            <span id="toastMessage"></span>
        </div>
    </div>

    <div class="container-fluid px-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="pt-3">Admin & Staff Management</h1>
        </div>

        <!-- Quick Stats Cards -->
        <div class="row mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="card bg-primary text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Total Staff</h6>
                                <h3 class="mb-0">${totalStaff}</h3>
                            </div>
                            <i class="fas fa-users fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-success text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Active Staff</h6>
                                <h3 class="mb-0">${activeStaff}</h3>
                            </div>
                            <i class="fas fa-user-check fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-warning text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Pending Tasks</h6>
                                <h3 class="mb-0">${pendingTasks}</h3>
                            </div>
                            <i class="fas fa-tasks fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-danger text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Rejected Staff</h6>
                                <h3 class="mb-0">${rejectedStaff}</h3>
                            </div>
                            <i class="fas fa-user-times fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Staff Management Card -->
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Staff Members</h5>
                <div>
                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addStaffModal">
                        <i class="fas fa-plus me-1"></i> Add Staff
                    </button>
                    <div class="btn-group ms-2">
                        <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button"
                                data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-filter me-1"></i> Filter
                        </button>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#" data-filter="all">All Staff</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="#" data-filter="ADMIN">Admins</a></li>
                            <li><a class="dropdown-item" href="#" data-filter="SUB_ADMIN">Sub Admins</a></li>
                            <li><a class="dropdown-item" href="#" data-filter="MANAGER">Managers</a></li>
                            <li><a class="dropdown-item" href="#" data-filter="RIDER">Riders</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover" id="staffTable">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Role</th>
                                <th>Contact</th>
                                <th>Status</th>
                                <th>Access Pages</th>
                                <th>Permissions</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="staff" items="${staffList}">
                            <tr data-staff-id="${staff.id}">
                                <td>
                                    <div class="d-flex align-items-center">
                                        <img src="${not empty staff.profileImage ? staff.profileImage : pageContext.request.contextPath.concat('/resources/images/default-avatar.jpg')}"
                                             class="rounded-circle me-3" width="40" height="40" alt="${staff.name}">
                                        <div>
                                            <h6 class="mb-0">${staff.name}</h6>
                                            <small class="text-muted">${staff.email}</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="badge-div ${staff.role == 'ADMIN' ? 'bg-primary' :
                                                           staff.role == 'SUB_ADMIN' ? 'bg-purple' :
                                                           staff.role == 'MANAGER' ? 'bg-info' :
                                                           staff.role == 'RIDER' ? 'bg-success' : 'bg-secondary'}">
                                        ${staff.role}
                                    </div>
                                </td>
                                <td>${staff.phone}</td>
                                <td>
                                    <div class="badge-div ${staff.active ? 'bg-success' : 'bg-secondary'}">
                                        ${staff.active ? 'Active' : 'Inactive'}
                                    </div>
                                </td>
                                <td>
                                    <c:if test="${not empty staff.accessPages}">
                                        <div class="badge-div bg-light text-dark">${fn:length(staff.accessPages)} pages</div>
                                    </c:if>
                                </td>
                                <td>
                                    <c:if test="${not empty staff.permissions}">
                                        <div class="badge-div bg-light text-dark">${fn:length(staff.permissions)} perms</div>
                                    </c:if>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-primary" data-bs-toggle="tooltip" title="Permissions">
                                            <i class="fas fa-key"></i>
                                        </button>
                                        <a href="editStaff?id=${staff.id}" class="btn btn-outline-secondary" data-bs-toggle="tooltip" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <button class="btn btn-outline-danger" onclick="confirmDelete('${staff.id}')" data-bs-toggle="tooltip" title="Delete">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Role Management Section -->
        <div class="row">
            <div class="col-lg-6">
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Role Permissions</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-sm">
                                <thead>
                                    <tr>
                                        <th>Role</th>
                                        <th>Default Access</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Admin</td>
                                        <td>All Pages</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary disabled">Edit</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Sub Admin</td>
                                        <td>Customizable</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary">Edit</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Manager</td>
                                        <td>Dashboard, User Management, Vendor Management</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary">Edit</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Rider</td>
                                        <td>Delivery System only</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary">Edit</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Salary Management</h5>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            Salary features will be available in the next update
                        </div>
                        <div class="d-grid gap-2">
                            <button class="btn btn-outline-primary" disabled>
                                <i class="fas fa-file-invoice-dollar me-2"></i>Generate Salary Reports
                            </button>
                            <button class="btn btn-outline-success" disabled>
                                <i class="fas fa-money-bill-wave me-2"></i>Process Payments
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Add Staff Modal -->
<div class="modal fade" id="addStaffModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <form class="modal-content" id="addStaffForm" method="post" action="/admin-staff/add" enctype="multipart/form-data">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" id="csrfToken"/>
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Add New Staff Member</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label">Full Name <span class="text-danger">*</span></label>
                            <input type="text" name="name" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email <span class="text-danger">*</span></label>
                            <input type="email" name="email" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Phone</label>
                            <input type="tel" name="phone" class="form-control">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label">Role <span class="text-danger">*</span></label>
                            <select name="role" class="form-select" required id="staffRole" onchange="updateAccessOptions()">
                                <option value="">Select Role</option>
                                <option value="ADMIN">Admin</option>
                                <option value="SUB_ADMIN">Sub Admin</option>
                                <option value="MANAGER">Manager</option>
                                <option value="RIDER">Rider</option>
                                <option value="SUPPORT">Customer Support</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Password <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="password" name="password" class="form-control" required id="passwordField">
                                <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            <div class="form-text">Minimum 8 characters</div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Profile Image</label>
                            <input type="file" name="profileImage" class="form-control" accept="image/*">
                        </div>
                    </div>
                </div>

                <!-- Page Access Permissions Section -->
                <div class="row mt-3">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header bg-light">
                                <h6 class="mb-0">Page Access Permissions</h6>
                            </div>
                            <div class="card-body">
                                <div class="alert alert-warning">
                                    <i class="fas fa-exclamation-circle me-2"></i>
                                    Select the pages this staff member can access based on their role
                                </div>

                                <div class="row">
                                    <!-- Dashboard -->
                                    <div class="col-md-4 mb-3">
                                        <div class="form-check">
                                            <input class="form-check-input page-access" type="checkbox" name="accessPages" value="DASHBOARD" id="dashboardAccess" checked disabled>
                                            <label class="form-check-label" for="dashboardAccess">
                                                Dashboard
                                            </label>
                                        </div>
                                    </div>

                                    <!-- User Management -->
                                    <div class="col-md-8 mb-3">
                                        <div class="form-check">
                                            <input class="form-check-input page-access" type="checkbox" name="accessPages" value="USER_MANAGEMENT" id="userManagementAccess">
                                            <label class="form-check-label" for="userManagementAccess">
                                                User Management
                                            </label>
                                        </div>
                                        <div class="ps-4 mt-2">
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="USER_PAGE" id="userPageAccess">
                                                <label class="form-check-label" for="userPageAccess">Users</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="USER_EARNINGS" id="userEarningsAccess">
                                                <label class="form-check-label" for="userEarningsAccess">User Earnings</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="USER_REVIEWS" id="userReviewsAccess">
                                                <label class="form-check-label" for="userReviewsAccess">Reviews</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="USER_CARTS" id="userCartsAccess">
                                                <label class="form-check-label" for="userCartsAccess">Carts</label>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Vendor Management -->
                                    <div class="col-md-8 mb-3">
                                        <div class="form-check">
                                            <input class="form-check-input page-access" type="checkbox" name="accessPages" value="VENDOR_MANAGEMENT" id="vendorManagementAccess">
                                            <label class="form-check-label" for="vendorManagementAccess">
                                                Vendor Management
                                            </label>
                                        </div>
                                        <div class="ps-4 mt-2">
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="SHOPS_PAGE" id="shopsPageAccess">
                                                <label class="form-check-label" for="shopsPageAccess">Shops</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="CATEGORIES_MANAGEMENT" id="categoriesAccess">
                                                <label class="form-check-label" for="categoriesAccess">Categories</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="SHOPS_EARNINGS" id="shopsEarningsAccess">
                                                <label class="form-check-label" for="shopsEarningsAccess">Shops Earnings</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="SHOPS_ADS" id="shopsAdsAccess">
                                                <label class="form-check-label" for="shopsAdsAccess">Ads</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="ORDERS_BILLINGS" id="ordersBillingsAccess">
                                                <label class="form-check-label" for="ordersBillingsAccess">Orders</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="COMMISSIONS_REPORT" id="commissionsReportAccess">
                                                <label class="form-check-label" for="commissionsReportAccess">Commissions</label>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Delivery System -->
                                    <div class="col-md-8 mb-3">
                                        <div class="form-check">
                                            <input class="form-check-input page-access" type="checkbox" name="accessPages" value="DELIVERY_SYSTEM" id="deliverySystemAccess">
                                            <label class="form-check-label" for="deliverySystemAccess">
                                                Delivery System
                                            </label>
                                        </div>
                                        <div class="ps-4 mt-2">
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="DELIVERY_ORDERS" id="deliveryOrdersAccess">
                                                <label class="form-check-label" for="deliveryOrdersAccess">Orders</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="DELIVERY_MANAGE" id="deliveryManageAccess">
                                                <label class="form-check-label" for="deliveryManageAccess">Riders</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="DELIVERY_EARNINGS" id="deliveryEarningsAccess">
                                                <label class="form-check-label" for="deliveryEarningsAccess">Earnings</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="DELIVERY_PAYMENTS" id="deliveryPaymentsAccess">
                                                <label class="form-check-label" for="deliveryPaymentsAccess">Payments</label>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- System Settings -->
                                    <div class="col-md-8 mb-3">
                                        <div class="form-check">
                                            <input class="form-check-input page-access" type="checkbox" name="accessPages" value="SYSTEM_SETTINGS" id="systemSettingsAccess">
                                            <label class="form-check-label" for="systemSettingsAccess">
                                                System Settings
                                            </label>
                                        </div>
                                        <div class="ps-4 mt-2">
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="ADMIN_STAFF" id="adminStaffAccess">
                                                <label class="form-check-label" for="adminStaffAccess">Admin & Staff</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="WEBSITE_ANALYTICS" id="websiteAnalyticsAccess">
                                                <label class="form-check-label" for="websiteAnalyticsAccess">Analytics</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="APP_HOMEPAGE" id="appHomepageAccess">
                                                <label class="form-check-label" for="appHomepageAccess">App Home</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="NOTIFICATIONS" id="notificationsAccess">
                                                <label class="form-check-label" for="notificationsAccess">Notifications</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="SMS_INTEGRATION" id="smsIntegrationAccess">
                                                <label class="form-check-label" for="smsIntegrationAccess">SMS</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="COUPON_CODE" id="couponCodeAccess">
                                                <label class="form-check-label" for="couponCodeAccess">Coupons</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input subpage-access" type="checkbox" name="accessPages" value="HELP_SUPPORT" id="helpSupportAccess">
                                                <label class="form-check-label" for="helpSupportAccess">Help</label>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Reports -->
                                    <div class="col-md-4 mb-3">
                                        <div class="form-check">
                                            <input class="form-check-input page-access" type="checkbox" name="accessPages" value="REPORTS" id="reportsAccess">
                                            <label class="form-check-label" for="reportsAccess">
                                                Reports
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                <div class="mt-3">
                                    <button type="button" class="btn btn-sm btn-outline-secondary" onclick="selectAllPages()">
                                        <i class="fas fa-check-circle me-1"></i> Select All
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-secondary ms-2" onclick="deselectAllPages()">
                                        <i class="fas fa-times-circle me-1"></i> Deselect All
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Add Staff</button>
            </div>
        </form>
    </div>
</div>

<!-- Permissions Modal -->
<div class="modal fade" id="permissionsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <form class="modal-content" id="permissionsForm">
            <input type="hidden" name="staffId" id="permissionStaffId">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Manage Permissions</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>
                    Select the permissions you want to grant to this staff member
                </div>

                <div class="table-responsive">
                    <table class="table table-sm table-bordered">
                        <thead class="table-light">
                            <tr>
                                <th>Module</th>
                                <th class="text-center">View</th>
                                <th class="text-center">Create</th>
                                <th class="text-center">Edit</th>
                                <th class="text-center">Delete</th>
                                <th class="text-center">Full</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Dashboard</td>
                                <td class="text-center"><input type="checkbox" name="perms" value="DASHBOARD_VIEW"></td>
                                <td class="text-center">-</td>
                                <td class="text-center">-</td>
                                <td class="text-center">-</td>
                                <td class="text-center"><input type="checkbox" name="perms" value="DASHBOARD_FULL"></td>
                            </tr>
                            <tr>
                                <td>Staff Management</td>
                                <td class="text-center"><input type="checkbox" name="perms" value="STAFF_VIEW"></td>
                                <td class="text-center"><input type="checkbox" name="perms" value="STAFF_CREATE"></td>
                                <td class="text-center"><input type="checkbox" name="perms" value="STAFF_EDIT"></td>
                                <td class="text-center"><input type="checkbox" name="perms" value="STAFF_DELETE"></td>
                                <td class="text-center"><input type="checkbox" name="perms" value="STAFF_FULL"></td>
                            </tr>
                            <tr>
                                <td>Customer Management</td>
                                <td class="text-center"><input type="checkbox" name="perms" value="CUSTOMER_VIEW"></td>
                                <td class="text-center"><input type="checkbox" name="perms" value="CUSTOMER_CREATE"></td>
                                <td class="text-center"><input type="checkbox" name="perms" value="CUSTOMER_EDIT"></td>
                                <td class="text-center"><input type="checkbox" name="perms" value="CUSTOMER_DELETE"></td>
                                <td class="text-center"><input type="checkbox" name="perms" value="CUSTOMER_FULL"></td>
                            </tr>
                            <tr>
                                <td>Vendor Management</td>
                                <td class="text-center"><input type="checkbox" name="perms" value="VENDOR_VIEW"></td>
                                <td class="text-center"><input type="checkbox" name="perms" value="VENDOR_CREATE"></td>
                                <td class="text-center"><input type="checkbox" name="perms" value="VENDOR_EDIT"></td>
                                <td class="text-center"><input type="checkbox" name="perms" value="VENDOR_DELETE"></td>
                                <td class="text-center"><input type="checkbox" name="perms" value="VENDOR_FULL"></td>
                            </tr>
                            <tr>
                                <td>Delivery System</td>
                                <td class="text-center"><input type="checkbox" name="perms" value="DELIVERY_VIEW"></td>
                                <td class="text-center"><input type="checkbox" name="perms" value="DELIVERY_CREATE"></td>
                                <td class="text-center"><input type="checkbox" name="perms" value="DELIVERY_EDIT"></td>
                                <td class="text-center"><input type="checkbox" name="perms" value="DELIVERY_DELETE"></td>
                                <td class="text-center"><input type="checkbox" name="perms" value="DELIVERY_FULL"></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Permissions</button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="deleteConfirmModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Confirm Delete</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this staff member?</p>
                <input type="hidden" id="deleteStaffId">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" onclick="deleteStaff()">Delete</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin-staff.css">
<script src="${pageContext.request.contextPath}/resources/js/admin-staff.js"></script>

<script>
const pageContext = {
    request: {
        contextPath: '${pageContext.request.contextPath}'
    }
};

// Helper function to check access boxes
function checkAccess(accessName) {
    const checkbox = document.querySelector(`input[name="accessPages"][value="${accessName}"]`);
    if (checkbox) {
        checkbox.checked = true;
    }
}

function updateAccessOptions() {
    const role = document.getElementById('staffRole').value;
    const checkboxes = document.querySelectorAll('.page-access, .subpage-access');

    // First, uncheck all except dashboard
    checkboxes.forEach(checkbox => {
        if (checkbox.id !== 'dashboardAccess') {
            checkbox.checked = false;
            checkbox.disabled = false;
        }
    });

    // Apply role-based templates
    switch(role) {
        case 'ADMIN':
            // Admin gets all access including Reports
            checkboxes.forEach(checkbox => {
                checkbox.checked = true;
            });
            break;

        case 'SUB_ADMIN':
            // Sub admin gets most access plus HELP_SUPPORT and REPORTS
            const subAdminAccess = [
                'USER_MANAGEMENT', 'USER_PAGE', 'USER_EARNINGS', 'USER_REVIEWS', 'USER_CARTS',
                'VENDOR_MANAGEMENT', 'SHOPS_PAGE', 'CATEGORIES_MANAGEMENT', 'SHOPS_EARNINGS',
                'SHOPS_ADS', 'ORDERS_BILLINGS', 'COMMISSIONS_REPORT',
                'DELIVERY_SYSTEM', 'DELIVERY_ORDERS', 'DELIVERY_MANAGE', 'DELIVERY_EARNINGS', 'DELIVERY_PAYMENTS',
                'SYSTEM_SETTINGS', 'WEBSITE_ANALYTICS', 'APP_HOMEPAGE', 'NOTIFICATIONS', 'HELP_SUPPORT',
                'REPORTS'
            ];
            subAdminAccess.forEach(access => checkAccess(access));
            break;

        case 'MANAGER':
            // Manager gets user and vendor management plus HELP_SUPPORT and REPORTS
            const managerAccess = [
                'USER_MANAGEMENT', 'USER_PAGE', 'USER_EARNINGS', 'USER_REVIEWS', 'USER_CARTS',
                'VENDOR_MANAGEMENT', 'SHOPS_PAGE', 'CATEGORIES_MANAGEMENT', 'SHOPS_EARNINGS',
                'SHOPS_ADS', 'ORDERS_BILLINGS', 'COMMISSIONS_REPORT',
                'HELP_SUPPORT', 'REPORTS'
            ];
            managerAccess.forEach(access => checkAccess(access));
            break;

        case 'RIDER':
            // Rider only gets delivery system plus HELP_SUPPORT and REPORTS
            const riderAccess = [
                'DELIVERY_SYSTEM', 'DELIVERY_ORDERS', 'DELIVERY_MANAGE', 'DELIVERY_EARNINGS', 'DELIVERY_PAYMENTS',
                'HELP_SUPPORT', 'REPORTS'
            ];
            riderAccess.forEach(access => checkAccess(access));
            break;

        case 'SUPPORT':
            // Support gets user management and help/support plus REPORTS
            const supportAccess = [
                'USER_MANAGEMENT', 'USER_PAGE',
                'SYSTEM_SETTINGS', 'HELP_SUPPORT',
                'REPORTS'
            ];
            supportAccess.forEach(access => checkAccess(access));
            break;
    }

    // Trigger change events for parent checkboxes to update subpages
    document.querySelectorAll('.page-access').forEach(checkbox => {
        if (checkbox.checked) {
            checkbox.dispatchEvent(new Event('change'));
        }
    });
}

// Function to setup checkbox dependencies
function setupCheckboxDependencies() {
    // User Management dependencies
    const userManagement = document.getElementById('userManagementAccess');
    const userSubpages = document.querySelectorAll('input[name="accessPages"][value^="USER_"]:not([value="USER_MANAGEMENT"])');

    userManagement.addEventListener('change', function() {
        userSubpages.forEach(subpage => {
            subpage.checked = this.checked;
            subpage.disabled = !this.checked;
        });
    });

    // Vendor Management dependencies
    const vendorManagement = document.getElementById('vendorManagementAccess');
    const vendorSubpages = document.querySelectorAll('input[name="accessPages"][value^="SHOPS_"], input[name="accessPages"][value="CATEGORIES_MANAGEMENT"], input[name="accessPages"][value="ORDERS_BILLINGS"], input[name="accessPages"][value="COMMISSIONS_REPORT"]');

    vendorManagement.addEventListener('change', function() {
        vendorSubpages.forEach(subpage => {
            subpage.checked = this.checked;
            subpage.disabled = !this.checked;
        });
    });

    // Delivery System dependencies
    const deliverySystem = document.getElementById('deliverySystemAccess');
    const deliverySubpages = document.querySelectorAll('input[name="accessPages"][value^="DELIVERY_"]:not([value="DELIVERY_SYSTEM"])');

    deliverySystem.addEventListener('change', function() {
        deliverySubpages.forEach(subpage => {
            subpage.checked = this.checked;
            subpage.disabled = !this.checked;
        });
    });

    // System Settings dependencies
    const systemSettings = document.getElementById('systemSettingsAccess');
    const systemSubpages = document.querySelectorAll('input[name="accessPages"][value="ADMIN_STAFF"], input[name="accessPages"][value="WEBSITE_ANALYTICS"], input[name="accessPages"][value="APP_HOMEPAGE"], input[name="accessPages"][value="NOTIFICATIONS"], input[name="accessPages"][value="SMS_INTEGRATION"], input[name="accessPages"][value="COUPON_CODE"], input[name="accessPages"][value="HELP_SUPPORT"]');

    systemSettings.addEventListener('change', function() {
        systemSubpages.forEach(subpage => {
            subpage.checked = this.checked;
            subpage.disabled = !this.checked;
        });
    });
}

// Function to select all pages
function selectAllPages() {
    const checkboxes = document.querySelectorAll('.page-access, .subpage-access');
    checkboxes.forEach(checkbox => {
        checkbox.checked = true;
        checkbox.disabled = false;
    });
}

// Function to deselect all pages (except dashboard)
function deselectAllPages() {
    const checkboxes = document.querySelectorAll('.page-access, .subpage-access');
    checkboxes.forEach(checkbox => {
        if (checkbox.id !== 'dashboardAccess') {
            checkbox.checked = false;
            checkbox.disabled = false;
        }
    });

    // Re-enable all subpages
    document.querySelectorAll('.subpage-access').forEach(subpage => {
        subpage.disabled = false;
    });
}

// Initialize when modal is shown
document.getElementById('addStaffModal').addEventListener('shown.bs.modal', function() {
    updateAccessOptions();
    setupCheckboxDependencies();
});

// Password toggle functionality
document.getElementById('togglePassword').addEventListener('click', function() {
    const passwordField = document.getElementById('passwordField');
    const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password';
    passwordField.setAttribute('type', type);
    this.innerHTML = type === 'password' ? '<i class="fas fa-eye"></i>' : '<i class="fas fa-eye-slash"></i>';
});

// Filter functionality
document.querySelectorAll('.dropdown-item[data-filter]').forEach(item => {
    item.addEventListener('click', function(e) {
        e.preventDefault();
        const filter = this.getAttribute('data-filter');
        // Implement your filter logic here
        console.log('Filter by:', filter);
    });
});

// Tooltip initialization
document.addEventListener('DOMContentLoaded', function() {
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function(tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});

// Delete confirmation
function confirmDelete(staffId) {
    document.getElementById('deleteStaffId').value = staffId;
    new bootstrap.Modal(document.getElementById('deleteConfirmModal')).show();
}

function deleteStaff() {
    const staffId = document.getElementById('deleteStaffId').value;
    // Implement delete functionality here
    console.log('Delete staff:', staffId);
    // Close modal after deletion
    bootstrap.Modal.getInstance(document.getElementById('deleteConfirmModal')).hide();
}
</script>