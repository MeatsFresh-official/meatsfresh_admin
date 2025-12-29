<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="en_IN" />
<%@ include file="/includes/header.jsp" %>

<main class="main-content">
    <div class="container-fluid px-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="pt-2">Ads & Promotion Management</h1>
        </div>

        <!-- Promotion Plans Section -->
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Promotion Plans</h5>
                <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addPlanModal">
                    <i class="fas fa-plus me-1"></i> Create New Plan
                </button>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover" id="plansTable">
                        <thead>
                            <tr>
                                <th>Plan Name</th>
                                <th>Duration</th>
                                <th>Price</th>
                                <th>Max Slots</th>
                                <th>Position</th>
                                <th>Active</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="plansTableBody">
                            <!-- Data will be dynamically inserted here by JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Promotion Requests Section -->
        <div class="card mb-4">
            <div class="card-header">
                <h5 class="mb-0">Promotion Requests</h5>
            </div>
            <div class="card-body">
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Search shops..." id="shopSearch">
                            <button class="btn btn-outline-secondary" type="button" id="searchShopBtn">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="btn-toolbar float-end">
                            <div class="btn-group me-2">
                                <button class="btn btn-outline-secondary dropdown-toggle" type="button"
                                        data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-filter me-1"></i>
                                    <span id="filterStatusText">All Requests</span>
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item filter-requests" href="#" data-filter="all">All Requests</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item filter-requests" href="#" data-filter="pending">Pending</a></li>
                                    <li><a class="dropdown-item filter-requests" href="#" data-filter="approved">Approved</a></li>
                                    <li><a class="dropdown-item filter-requests" href="#" data-filter="rejected">Rejected</a></li>
                                </ul>
                            </div>
                            <div class="btn-group">
                                <button class="btn btn-outline-secondary dropdown-toggle" type="button"
                                        id="requestsTimeRange" data-bs-toggle="dropdown">
                                    <i class="fas fa-calendar me-1"></i> Last 30 Days
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item time-range" href="#" data-range="today">Today</a></li>
                                    <li><a class="dropdown-item time-range" href="#" data-range="week">This Week</a></li>
                                    <li><a class="dropdown-item time-range" href="#" data-range="month">Last 30 Days</a></li>
                                </ul>
                                <button class="btn btn-outline-secondary" id="requestsDateRangeBtn" title="Custom Date Range" data-bs-toggle="modal" data-bs-target="#dateRangeModal">
                                    <i class="fas fa-calendar-alt"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover" id="requestsTable">
                        <thead>
                            <tr>
                                <th>Shop</th>
                                <th>Plan</th>
                                <th>Request Date</th>
                                <th>Start Date</th>
                                <th>End Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="requestsTableBody">
                            <!-- Data will be dynamically inserted here by JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Active Promotions Section -->
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0" id="activePromotionsHeader">Active Promotions</h5>
            </div>
            <div class="card-body">
                <div class="alert alert-info" id="activePromotionsAlert">
                    <i class="fas fa-info-circle me-2"></i>
                    <!-- Info message will be updated by JavaScript -->
                </div>
                <div class="row" id="activePromotionsContainer">
                    <!-- Active promotions will be dynamically inserted here by JavaScript -->
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Add/Edit Plan Modal -->
<div class="modal fade" id="planModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <form class="modal-content" id="planForm">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="planModalTitle">Create Promotion Plan</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="planId" name="id">
                <div class="mb-3">
                    <label class="form-label">Plan Name <span class="text-danger">*</span></label>
                    <input type="text" id="planName" name="name" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea id="planDescription" name="description" class="form-control" rows="3"></textarea>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Duration (days) <span class="text-danger">*</span></label>
                        <input type="number" id="planDuration" name="duration" class="form-control" required min="1">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Price <span class="text-danger">*</span></label>
                        <input type="number" step="0.01" id="planPrice" name="price" class="form-control" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Position <span class="text-danger">*</span></label>
                        <select id="planPosition" name="position" class="form-select" required>
                            <option value="TOP">Top Listing</option>
                            <option value="FEATURED">Featured Section</option>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Max Slots <span class="text-danger">*</span></label>
                        <input type="number" id="planMaxSlots" name="maxSlots" class="form-control" required min="1">
                    </div>
                </div>
                <div class="mb-3 form-check form-switch">
                    <input class="form-check-input" type="checkbox" name="active" id="planActive" checked>
                    <label class="form-check-label" for="planActive">
                        Active
                    </label>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary" id="savePlanBtn">Create Plan</button>
            </div>
        </form>
    </div>
</div>

<!-- Request Details Modal -->
<div class="modal fade" id="requestDetailsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Promotion Request Details</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                 <!-- Content will be populated by JavaScript -->
            </div>
            <div class="modal-footer" id="requestModalFooter">
                 <!-- Buttons will be populated by JavaScript -->
            </div>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">Confirm Action</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p id="deleteConfirmMessage"></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Confirm</button>
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
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="applyDateRange">Apply</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/shops-adsAndpromotion.css">
<script src="${pageContext.request.contextPath}/resources/js/shops-adsAndpromotion.js"></script>