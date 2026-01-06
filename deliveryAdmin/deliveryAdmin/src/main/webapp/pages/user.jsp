<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="en_IN" />
<%@ include file="/includes/header.jsp" %>

<main class="main-content">

    <div class="container-fluid px-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="pt-3">User Management</h1>
            <div class="btn-group">
                <button class="btn btn-primary" id="downloadAllBtn">
                    <i class="fas fa-download me-2"></i>Export Data
                </button>
                <button class="btn btn-primary dropdown-toggle dropdown-toggle-split"
                        data-bs-toggle="dropdown" aria-expanded="false">
                    <span class="visually-hidden">Toggle Dropdown</span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="#" id="downloadBasicBtn">Basic Data (CSV)</a></li>
                    <li><a class="dropdown-item" href="#" id="downloadAdvancedBtn">Advanced Data (Excel)</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="#" id="downloadNumbersBtn">Phone Numbers Only</a></li>
                </ul>
            </div>
        </div>

        <!-- Stats Cards Row -->
        <div class="row mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="card bg-primary text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Total Users</h6>
                                <h3 class="mb-0" id="totalUsers">0</h3>
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
                                <h6 class="mb-0">Active Users (30 days)</h6>
                                <h3 class="mb-0" id="activeUsers">0</h3>
                            </div>
                            <i class="fas fa-user-check fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-md-6">
                <div class="card bg-info text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Total Revenue</h6>
                                <h3 class="mb-0" id="totalRevenue">₹0</h3>
                            </div>
                            <i class="fas fa-rupee-sign fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-md-6">
                <div class="card bg-warning text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Avg. Order Value</h6>
                                <h3 class="mb-0" id="avgOrderValue">₹0</h3>
                            </div>
                            <i class="fas fa-shopping-cart fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>




        <!-- Filters Card -->
        <div class="card shadow-sm mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Filters & Search</h6>
            </div>
            <div class="card-body">
                <div class="row g-3 mb-4">
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Activity Status</label>
                        <select class="form-select" id="activityFilter">
                            <option value="all">All Activity</option>
                            <option value="active">Active (last 30 days)</option>
                            <option value="inactive">Inactive (>30 days)</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Spending Level</label>
                        <select class="form-select" id="spendingFilter">
                            <option value="all">All Spending</option>
                            <option value="high">High Spenders</option>
                            <option value="medium">Medium Spenders</option>
                            <option value="low">Low Spenders</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Date Range</label>
                        <button class="btn btn-outline-secondary w-100 date-range-btn" data-bs-toggle="modal" data-bs-target="#dateRangeModal">
                            <i class="fas fa-calendar-alt me-2"></i> Select Range
                         </button>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-8">
                        <div class="input-group">
                            <span class="input-group-text bg-transparent"><i class="fas fa-search"></i></span>
                            <input type="text" class="form-control" placeholder="Search users by name, email, phone or location..." id="userSearch">
                            <button class="btn btn-outline-secondary" type="button" id="searchBtn">Search</button>
                        </div>
                    </div>
                    <div class="col-md-4 d-flex justify-content-end">
                        <button class="btn btn-outline-danger me-2" id="resetFiltersBtn">
                            <i class="fas fa-filter-circle-xmark me-2"></i>Clear Filters
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Users Table Card -->
        <div class="card shadow-sm">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover" id="usersTable">
                        <thead class="table-light">
                            <tr>
                                <th>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="selectAll">
                                    </div>
                                </th>
                                <th>User</th>
                                <th>Contact</th>
                                <th>Location</th>
                                <th>Orders</th>
                                <th>Total Spent</th>
                                <th>Last Active</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="usersTableBody">
                            <!-- Users will be loaded dynamically via API -->
                        </tbody>
                    </table>
                </div>
                <!-- Loading Indicator -->
                <div id="loadingIndicator" class="text-center py-5">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2">Loading users...</p>
                </div>

                <!-- Pagination -->
                <!-- <div class="d-flex justify-content-between align-items-center mt-4">
                    <div class="text-muted">
                        Showing <span id="showingCount">0</span> of <span id="totalCount">0</span> users
                    </div>
                    <nav aria-label="User pagination">
                        <ul class="pagination">
                            <li class="page-item disabled">
                                <a class="page-link" href="#" tabindex="-1">Previous</a>
                            </li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">3</a></li>
                            <li class="page-item">
                                <a class="page-link" href="#">Next</a>
                            </li>
                        </ul>
                    </nav>
                </div> -->
            </div>
        </div>
    </div>
</main>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">Confirm Deletion</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this user? This action cannot be undone.</p>
                <input type="hidden" id="deleteUserId">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" onclick="deleteUser()">Delete</button>
            </div>
        </div>
    </div>
</div>

<!-- Date Range Modal -->
<div class="modal fade" id="dateRangeModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Select Date Range</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label for="startDate" class="form-label">Start Date</label>
                    <input type="date" class="form-control" id="startDate">
                </div>
                <div class="mb-3">
                    <label for="endDate" class="form-label">End Date</label>
                    <input type="date" class="form-control" id="endDate">
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="saveAsDefault">
                    <label class="form-check-label" for="saveAsDefault">
                        Save as default range
                    </label>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="applyDateRange">Apply</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user.css">
<script src="${pageContext.request.contextPath}/resources/js/user.js"></script>