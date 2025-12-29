<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="en_IN" />
<%@ include file="/includes/header.jsp" %>

<!-- Toast/Notification Containers -->
<div class="toast-container position-fixed bottom-0 end-0 p-3">
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
    <div class="container-fluid">
        <div class="page-header pt-2">
            <h1>Delivery Order Management</h1>
        </div>

        <!-- Overview Cards -->
        <div class="row mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="card bg-primary text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Total Orders</h6>
                                <h3 class="mb-0" id="totalOrdersCount">0</h3>
                            </div>
                            <i class="fas fa-shopping-bag fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-warning text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Pending Delivery</h6>
                                <h3 class="mb-0" id="pendingOrdersCount">0</h3>
                            </div>
                            <i class="fas fa-clock fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-success text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Completed</h6>
                                <h3 class="mb-0" id="completedOrdersCount">0</h3>
                            </div>
                            <i class="fas fa-check-circle fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-danger text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Cancelled</h6>
                                <h3 class="mb-0" id="cancelledOrdersCount">0</h3>
                            </div>
                            <i class="fas fa-times-circle fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content Tabs -->
        <div class="card mb-4">
            <div class="card-header">
                <ul class="nav nav-tabs card-header-tabs" id="orderTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="all-orders-tab" data-bs-toggle="tab"
                                data-bs-target="#all-orders" type="button" role="tab">
                            <i class="fas fa-list me-2"></i>All Orders
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="pending-tab" data-bs-toggle="tab"
                                data-bs-target="#pending" type="button" role="tab">
                            <i class="fas fa-clock me-2"></i>Pending
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="completed-tab" data-bs-toggle="tab"
                                data-bs-target="#completed" type="button" role="tab">
                            <i class="fas fa-check-circle me-2"></i>Completed
                        </button>
                    </li>
                </ul>
            </div>

            <div class="card-body tab-content" id="orderTabContent">
                <!-- All Orders Tab -->
                <div class="tab-pane fade show active" id="all-orders" role="tabpanel">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="col-md-6">
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="Search orders..." id="orderSearch">
                                <button class="btn btn-outline-secondary" type="button" id="searchOrderBtn">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                        <div class="col-md-6 text-end">
                            <div class="btn-group" role="group">
                                <button class="btn btn-outline-secondary" id="filterOrdersBtn" data-bs-toggle="modal" data-bs-target="#filterModal">
                                    <i class="fas fa-filter me-2"></i>Filter
                                </button>
                                <button class="btn btn-outline-secondary" id="exportOrdersBtn">
                                    <i class="fas fa-file-export me-2"></i>Export
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover" id="ordersTable">
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Customer</th>
                                    <th>Amount</th>
                                    <th>Delivery Address</th>
                                    <th>Status</th>
                                    <th>Assigned Rider</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td colspan="7" class="text-center">
                                        <i class="fas fa-spinner fa-spin me-2"></i>Loading orders...
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- Pagination will be added by JS -->
                </div>

                <!-- Pending Orders Tab -->
                <div class="tab-pane fade" id="pending" role="tabpanel">
                    <div class="table-responsive">
                        <table class="table table-hover" id="pendingOrdersTable">
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Customer</th>
                                    <th>Amount</th>
                                    <th>Delivery Address</th>
                                    <th>Distance</th>
                                    <th>Order Time</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                               <tr>
                                    <td colspan="7" class="text-center">
                                        <i class="fas fa-spinner fa-spin me-2"></i>Loading pending orders...
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Completed Orders Tab -->
                <div class="tab-pane fade" id="completed" role="tabpanel">
                    <div class="table-responsive">
                        <table class="table table-hover" id="completedOrdersTable">
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Customer</th>
                                    <th>Amount</th>
                                    <th>Completed On</th>
                                    <th>Rating</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td colspan="6" class="text-center">
                                        <i class="fas fa-spinner fa-spin me-2"></i>Loading completed orders...
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Order Details Modal -->
<div class="modal fade" id="orderDetailsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Order Details - #<span id="orderDetailId"></span></h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- JS will populate this -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="printOrderDetailsBtn">
                    <i class="fas fa-print me-2"></i>Print
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Update Status Modal -->
<div class="modal fade" id="updateStatusModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Update Order Status</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="statusUpdateOrderId">
                <div class="mb-3">
                    <label class="form-label">Current Status</label>
                    <div class="form-control-plaintext" id="currentStatusDisplay"></div>
                </div>
                <div class="mb-3">
                    <label for="statusSelect" class="form-label">Update Status To</label>
                    <select class="form-select" id="statusSelect">
                        <option value="PICKED_UP">Picked Up</option>
                        <option value="IN_TRANSIT">In Transit</option>
                        <option value="DELIVERED">Delivered</option>
                        <option value="CANCELLED">Cancelled</option>
                    </select>
                </div>
                <div class="mb-3" id="deliveryProofContainer" style="display: none;">
                    <label for="deliveryProof" class="form-label">Delivery Proof (Photo)</label>
                    <input type="file" class="form-control" id="deliveryProof" accept="image/*">
                </div>
                <div class="mb-3" id="cancellationReasonContainer" style="display: none;">
                    <label for="cancellationReason" class="form-label">Cancellation Reason</label>
                    <textarea class="form-control" id="cancellationReason" rows="2"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="updateStatusBtn">Update Status</button>
            </div>
        </div>
    </div>
</div>

<!-- Filter Modal -->
<div class="modal fade" id="filterModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Filter Orders</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="filterForm">
                    <!-- Filter options here -->
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="applyFilterBtn">Apply Filters</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/deliveryBoy-orders.css">
<script src="${pageContext.request.contextPath}/resources/js/deliveryBoy-orders.js"></script>