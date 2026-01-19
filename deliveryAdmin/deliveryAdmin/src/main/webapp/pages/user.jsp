<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <fmt:setLocale value="en_IN" />
                <%@ include file="/includes/header.jsp" %>

                    <main class="main-content">

                        <div class="container-fluid px-4 animate-enter">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <div>
                                    <h1 class="page-title">User Management</h1>
                                    <p class="page-subtitle">Manage and monitor platform users</p>
                                </div>
                                <div class="d-flex gap-2">
                                    <button class="btn btn-zenith-primary" id="downloadAllBtn">
                                        <i class="fas fa-download me-2"></i>Export Data
                                    </button>
                                    <div class="dropdown">
                                        <button class="btn btn-zenith bg-white border dropdown-toggle" type="button"
                                            data-bs-toggle="dropdown" aria-expanded="false">
                                            <i class="fas fa-ellipsis-v text-secondary"></i>
                                        </button>
                                        <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0">
                                            <li><a class="dropdown-item py-2" href="#" id="downloadBasicBtn">
                                                    <i class="fas fa-file-csv me-2 text-primary"></i>Basic Data (CSV)
                                                </a></li>
                                            <li><a class="dropdown-item py-2" href="#" id="downloadAdvancedBtn">
                                                    <i class="fas fa-file-excel me-2 text-success"></i>Advanced Data
                                                    (Excel)
                                                </a></li>
                                            <li>
                                                <hr class="dropdown-divider">
                                            </li>
                                            <li><a class="dropdown-item py-2" href="#" id="downloadNumbersBtn">
                                                    <i class="fas fa-phone me-2 text-info"></i>Phone Numbers Only
                                                </a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Stats Grid -->
                            <div class="stats-grid">
                                <div class="glass-panel stat-card">
                                    <div class="stat-info">
                                        <h6>Total Users</h6>
                                        <h3 id="totalUsers">0</h3>
                                    </div>
                                    <div class="stat-icon icon-blue">
                                        <i class="fas fa-users"></i>
                                    </div>
                                </div>

                                <div class="glass-panel stat-card">
                                    <div class="stat-info">
                                        <h6>Active (30d)</h6>
                                        <h3 id="activeUsers">0</h3>
                                    </div>
                                    <div class="stat-icon icon-green">
                                        <i class="fas fa-user-check"></i>
                                    </div>
                                </div>

                                <div class="glass-panel stat-card">
                                    <div class="stat-info">
                                        <h6>Total Revenue</h6>
                                        <div class="h3 mb-0" id="totalRevenue">₹0</div>
                                    </div>
                                    <div class="stat-icon icon-yellow">
                                        <i class="fas fa-rupee-sign"></i>
                                    </div>
                                </div>

                                <div class="glass-panel stat-card">
                                    <div class="stat-info">
                                        <h6>Avg. Order Value</h6>
                                        <div class="h3 mb-0" id="avgOrderValue">₹0</div>
                                    </div>
                                    <div class="stat-icon icon-red">
                                        <i class="fas fa-shopping-cart"></i>
                                    </div>
                                </div>
                            </div>

                            <!-- Filters & Table Section -->
                            <div class="glass-panel mb-4">
                                <div class="d-flex flex-wrap gap-3 mb-4 align-items-end">
                                    <div class="flex-grow-1" style="min-width: 200px;">
                                        <div class="form-floating-zenith">
                                            <input type="text" class="form-control" placeholder="Search users..."
                                                id="userSearch">
                                        </div>
                                    </div>
                                    <div style="min-width: 150px;">
                                        <div class="form-floating-zenith">
                                            <select class="form-select" id="activityFilter">
                                                <option value="all">All Activity</option>
                                                <option value="active">Active (30 days)</option>
                                                <option value="inactive">Inactive</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div style="min-width: 150px;">
                                        <div class="form-floating-zenith">
                                            <select class="form-select" id="spendingFilter">
                                                <option value="all">All Spending</option>
                                                <option value="high">High Spenders</option>
                                                <option value="medium">Medium Spenders</option>
                                                <option value="low">Low Spenders</option>
                                            </select>
                                        </div>
                                    </div>
                                    <button class="btn btn-white border px-3 py-2 rounded-3" data-bs-toggle="modal"
                                        data-bs-target="#dateRangeModal">
                                        <i class="fas fa-calendar-alt text-secondary"></i>
                                    </button>
                                    <button class="btn btn-zenith-primary px-3 py-2" id="searchBtn">
                                        <i class="fas fa-search"></i>
                                    </button>
                                    <button class="btn btn-light px-3 py-2 text-danger" id="resetFiltersBtn"
                                        data-bs-toggle="tooltip" title="Reset Filters">
                                        <i class="fas fa-undo"></i>
                                    </button>
                                </div>

                                <div class="zenith-table-container">
                                    <table class="zenith-table" id="usersTable">
                                        <thead>
                                            <tr>
                                                <th style="width: 40px;">
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="checkbox" id="selectAll">
                                                    </div>
                                                </th>
                                                <th>User Details</th>
                                                <th>Contact</th>
                                                <th>Location</th>
                                                <th>Orders</th>
                                                <th>Total Spent</th>
                                                <th>Last Active</th>
                                                <th>Status</th>
                                                <th class="text-end">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody id="usersTableBody">
                                            <!-- Content loaded via JS -->
                                        </tbody>
                                    </table>
                                </div>
                                <!-- Pagination Container -->
                                <div id="userPagination" class="mt-3"></div>

                                <!-- Loading Indicator -->
                                <div id="loadingIndicator" class="text-center py-5" style="display: none;">
                                    <div class="spinner-border text-primary" role="status">
                                        <span class="visually-hidden">Loading...</span>
                                    </div>
                                    <p class="mt-2 text-secondary small">Loading user data...</p>
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
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <p>Are you sure you want to delete this user? This action cannot be undone.</p>
                                    <input type="hidden" id="deleteUserId">
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Cancel</button>
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
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
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
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Cancel</button>
                                    <button type="button" class="btn btn-primary" id="applyDateRange">Apply</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%@ include file="/includes/footer.jsp" %>

                        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user.css">
                        <script src="${pageContext.request.contextPath}/resources/js/user.js"></script>