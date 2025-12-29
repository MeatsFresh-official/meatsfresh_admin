<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/header.jsp" %>

<main class="main-content">
    <div class="container-fluid px-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="pt-2">Orders & Billing</h1>
        </div>

        <!-- Quick Stats Cards -->
        <div class="row mb-4" id="stats-cards-container">
            <!-- Stats will be loaded here by JavaScript -->
            <div class="col-xl-2 col-md-4 col-6"><div class="card skeleton mb-4" style="height: 100px;"></div></div>
            <div class="col-xl-2 col-md-4 col-6"><div class="card skeleton mb-4" style="height: 100px;"></div></div>
            <div class="col-xl-2 col-md-4 col-6"><div class="card skeleton mb-4" style="height: 100px;"></div></div>
            <div class="col-xl-2 col-md-4 col-6"><div class="card skeleton mb-4" style="height: 100px;"></div></div>
            <div class="col-xl-2 col-md-4 col-6"><div class="card skeleton mb-4" style="height: 100px;"></div></div>
            <div class="col-xl-2 col-md-4 col-6"><div class="card skeleton mb-4" style="height: 100px;"></div></div>
        </div>

        <!-- Filters and Search -->
        <div class="card mb-4">
            <div class="card-body">
                <div class="row align-items-center g-3">
                    <div class="col-lg-6">
                        <div class="input-group">
                             <span class="input-group-text"><i class="fas fa-search"></i></span>
                            <input type="text" class="form-control" placeholder="Search by Order ID, Customer, or Shop..." id="orderSearchInput">
                        </div>
                    </div>
                    <div class="col-lg-6 d-flex justify-content-lg-end">
                        <div class="btn-group me-2">
                             <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-filter me-1"></i> <span id="statusFilterText">All Orders</span>
                            </button>
                            <ul class="dropdown-menu" id="statusFilterDropdown">
                                <li><a class="dropdown-item" href="#" data-filter="all">All Orders</a></li>
                                <li><a class="dropdown-item" href="#" data-filter="ACCEPTED">Accepted</a></li>
                                <li><a class="dropdown-item" href="#" data-filter="PACKING">Packing</a></li>
                                <li><a class="dropdown-item" href="#" data-filter="SHIPPING">Shipping</a></li>
                                <li><a class="dropdown-item" href="#" data-filter="DELIVERED">Delivered</a></li>
                                <li><a class="dropdown-item" href="#" data-filter="CANCELLED">Cancelled</a></li>
                                <li><a class="dropdown-item" href="#" data-filter="REFUNDED">Refunded</a></li>
                            </ul>
                        </div>
                         <div class="btn-group">
                            <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="timeRangeDropdown" data-bs-toggle="dropdown">
                                <i class="fas fa-calendar-day me-1"></i> <span>This Month</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item time-range-option" href="#" data-range="today">Today</a></li>
                                <li><a class="dropdown-item time-range-option" href="#" data-range="week">This Week</a></li>
                                <li><a class="dropdown-item time-range-option" href="#" data-range="month">This Month</a></li>
                                <li><a class="dropdown-item time-range-option" href="#" data-range="custom" data-bs-toggle="modal" data-bs-target="#dateRangeModal">Custom Range...</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0" id="ordersTable">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Total</th>
                                <th>Shop</th>
                                <th>Delivery</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="ordersTableBody">
                            <!-- Orders will be loaded here by JavaScript -->
                        </tbody>
                    </table>
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
                <h5 class="modal-title">Order Details - #<span id="modalOrderId"></span></h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="orderDetailsBody">
                <!-- Details will be loaded here by JavaScript -->
                 <div class="text-center p-5"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></div>
            </div>
             <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button class="btn btn-primary" id="printInvoiceBtn">
                    <i class="fas fa-print me-2"></i>Print Invoice
                </button>
            </div>
        </div>
    </div>
</div>


<!-- Edit Order Modal -->
<div class="modal fade" id="editOrderModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <form class="modal-content" id="editOrderForm">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Edit Order - #<span id="editOrderId"></span></h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="editOrderBody">
                 <!-- Form content will be loaded here -->
                 <div class="text-center p-5"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<!-- Cancel Confirmation Modal -->
<div class="modal fade" id="cancelConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">Confirm Cancellation</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to cancel order #<strong id="cancelOrderIdText"></strong>? This action cannot be undone.</p>
                <input type="hidden" id="cancelOrderId">
                <div class="mb-3">
                    <label class="form-label">Cancellation Reason</label>
                    <textarea class="form-control" id="cancelReason" rows="2" placeholder="Optional reason for cancellation"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No, Keep It</button>
                <button type="button" class="btn btn-danger" id="confirmCancelBtn">Yes, Cancel Order</button>
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

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/orders-billings.css">
<script src="${pageContext.request.contextPath}/resources/js/orders-billings.js"></script>