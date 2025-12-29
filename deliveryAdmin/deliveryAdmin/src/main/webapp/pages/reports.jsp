<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/includes/header.jsp" %>

<main class="main-content">
    <div class="container-fluid">
        <div class="page-header py-3 d-flex justify-content-between align-items-center">
            <h1 class="m-0">Business Reports</h1>
            <div>
                <button class="btn btn-outline-secondary" id="printReportBtn">
                    <i class="fas fa-print me-2"></i>Print Report
                </button>
                <button class="btn btn-primary" id="downloadPdfBtn">
                    <i class="fas fa-file-pdf me-2"></i>Download PDF
                </button>
            </div>
        </div>

        <!-- User Data Card -->
        <div class="card mb-4">
            <div class="card-header py-3">
                <h4 class="m-0"><i class="fas fa-users me-2"></i>User Data</h4>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover" id="usersTable">
                        <thead class="table-light">
                            <tr>
                                <th>User ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Registration Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Data will be loaded by JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Vendor Data Card -->
        <div class="card mb-4">
            <div class="card-header py-3">
                <h4 class="m-0"><i class="fas fa-store-alt me-2"></i>Vendor Data</h4>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover" id="vendorsTable">
                        <thead class="table-light">
                            <tr>
                                <th>Vendor ID</th>
                                <th>Company Name</th>
                                <th>Contact Person</th>
                                <th>Joined Date</th>
                                <th>Rating</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Data will be loaded by JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Delivery Data Card -->
        <div class="card mb-4">
            <div class="card-header py-3">
                <h4 class="m-0"><i class="fas fa-truck-loading me-2"></i>Delivery Data</h4>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover" id="deliveriesTable">
                        <thead class="table-light">
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Delivery Person</th>
                                <th>Status</th>
                                <th>Last Update</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Data will be loaded by JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- ======================= MODALS AND TOASTS ======================= -->

<!-- DETAILS VIEWER MODAL -->
<div class="modal fade" id="detailsModal" tabindex="-1" aria-labelledby="detailsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="detailsModalLabel">Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="modalContent" class="p-2">
                    <!-- Dynamic content will be injected here -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- SUCCESS NOTIFICATION TOAST -->
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
    <div id="successToast" class="toast align-items-center text-white bg-success" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body"><i class="fas fa-check-circle me-2"></i><span id="toastMessage"></span></div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
</div>

<!-- ERROR NOTIFICATION TOAST -->
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
    <div id="errorToast" class="toast align-items-center text-white bg-danger" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body"><i class="fas fa-exclamation-circle me-2"></i><span id="errorToastMessage"></span></div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/report.js"></script>