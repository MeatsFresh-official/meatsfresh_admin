<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/header.jsp" %>

<main class="main-content">
    <div class="container-fluid">
        <div class="page-header pt-2">
            <h1>User Ratings & Reviews</h1>
        </div>

        <!-- Summary Cards -->
        <div class="row mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="card bg-primary text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Avg. Vendor Rating</h6>
                                <div class="d-flex align-items-center">
                                    <h3 class="mb-0 me-2" id="avgVendorRating">--</h3>
                                    <div class="rating-stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star${i <= avgVendorRating ? '' : '-empty'}"></i>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                            <i class="fas fa-store fa-2x"></i>
                        </div>
                        <div class="mt-2 small">
                            <span>Based on ${vendorReviewCount} reviews</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-success text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Avg. Delivery Rating</h6>
                                <div class="d-flex align-items-center">
                                    <h3 class="mb-0 me-2" id="avgDeliveryRating">--</h3>
                                    <div class="rating-stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star${i <= avgDeliveryRating ? '' : '-empty'}"></i>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                            <i class="fas fa-motorcycle fa-2x"></i>
                        </div>
                        <div class="mt-2 small">
                            <span>Based on ${deliveryReviewCount} reviews</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-info text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Total Reviews</h6>
                                <h3 class="mb-0" id="totalReviews">--</h3>
                            </div>
                            <i class="fas fa-comment-alt fa-2x"></i>
                        </div>
                        <div class="mt-2 small">
                            <span>All-time customer feedback</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-warning text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Pending Moderation</h6>
                                <h3 class="mb-0" id="pendingModeration">--</h3>
                            </div>
                            <i class="fas fa-clock fa-2x"></i>
                        </div>
                        <div class="mt-2 small">
                            <span>Awaiting approval</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="card mb-4">
            <div class="card-header bg-light">
                <h5 class="mb-0">Filter Reviews</h5>
            </div>
            <div class="card-body">
                <div class="row align-items-center">
                    <div class="col-md-3 mb-2">
                        <label class="form-label">Review Type</label>
                        <select class="form-select" id="reviewTypeFilter">
                            <option value="all">All Reviews</option>
                            <option value="vendor">Vendor Reviews</option>
                            <option value="delivery">Delivery Reviews</option>
                        </select>
                    </div>
                    <div class="col-md-3 mb-2">
                        <label class="form-label">Rating</label>
                        <select class="form-select" id="ratingFilter">
                            <option value="all">All Ratings</option>
                            <option value="5">5 Stars</option>
                            <option value="4">4 Stars</option>
                            <option value="3">3 Stars</option>
                            <option value="2">2 Stars</option>
                            <option value="1">1 Star</option>
                        </select>
                    </div>
                    <div class="col-md-3 mb-2">
                        <label class="form-label">Status</label>
                        <select class="form-select" id="statusFilter">
                            <option value="all">All Status</option>
                            <option value="APPROVED">Approved</option>
                            <option value="PENDING">Pending</option>
                            <option value="REJECTED">Rejected</option>
                        </select>
                    </div>
                    <div class="col-md-3 mb-2">
                        <label class="form-label">Search</label>
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Search reviews..." id="reviewSearch">
                            <button class="btn btn-primary" type="button" id="searchReviewBtn">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Reviews Table -->
        <div class="card mb-4">
            <div class="card-header bg-light d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Customer Reviews</h5>
                <div class="d-flex">
                    <button class="btn btn-sm btn-outline-secondary me-2" id="exportBtn">
                        <i class="fas fa-download me-1"></i> Export
                    </button>
                    <div class="dropdown">
                        <button class="btn btn-sm btn-outline-primary dropdown-toggle" type="button" id="sortDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-sort me-1"></i> Sort By
                        </button>
                        <ul class="dropdown-menu" aria-labelledby="sortDropdown">
                            <li><a class="dropdown-item sort-option active" href="#" data-sort="newest">Newest First</a></li>
                            <li><a class="dropdown-item sort-option" href="#" data-sort="oldest">Oldest First</a></li>
                            <li><a class="dropdown-item sort-option" href="#" data-sort="highest">Highest Rating</a></li>
                            <li><a class="dropdown-item sort-option" href="#" data-sort="lowest">Lowest Rating</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover" id="reviewsTable">
                        <thead>
                            <tr>
                                <th>Reviewer</th>
                                <th>Type</th>
                                <th>Rating</th>
                                <th>Review</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Review rows will be dynamically inserted here by JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Vendor Performance -->
        <div class="card mb-4">
            <div class="card-header bg-light">
                <h5 class="mb-0">Vendor Performance</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-sm table-striped" id="vendorTable">
                        <thead>
                            <tr>
                                <th>Vendor</th>
                                <th>Rating</th>
                                <th>Total Reviews</th>
                                <th>5 Star</th>
                                <th>4 Star</th>
                                <th>3 Star</th>
                                <th>2 Star</th>
                                <th>1 Star</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Vendor rows will be dynamically inserted here by JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Delivery Performance -->
        <div class="card">
            <div class="card-header bg-light">
                <h5 class="mb-0">Delivery Performance</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-sm table-striped" id="deliveryTable">
                        <thead>
                            <tr>
                                <th>Delivery Person</th>
                                <th>Rating</th>
                                <th>Total Reviews</th>
                                <th>5 Star</th>
                                <th>4 Star</th>
                                <th>3 Star</th>
                                <th>2 Star</th>
                                <th>1 Star</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                           <!-- Delivery rows will be dynamically inserted here by JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Reply Modal -->
<div class="modal fade" id="replyModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <form class="modal-content" id="replyForm">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Reply to Review</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="reviewId" id="replyReviewId">
                <div class="mb-3">
                    <label class="form-label">Your Reply</label>
                    <textarea class="form-control" name="reply" rows="4" required placeholder="Type your response here..."></textarea>
                </div>
                <div class="form-check mb-3">
                    <input class="form-check-input" type="checkbox" name="sendEmail" id="sendEmail" checked>
                    <label class="form-check-label" for="sendEmail">
                        Send email notification to customer
                    </label>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Send Reply</button>
            </div>
        </form>
    </div>
</div>

<!-- Review Detail Modal -->
<div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title">Review Details</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="reviewDetailContent">
                <!-- Content will be loaded via JavaScript -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Image Modal -->
<div class="modal fade" id="imageModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Review Image</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center">
                <img src="" id="modalImage" class="img-fluid" alt="Review image">
            </div>
        </div>
    </div>
</div>
<script>
    const APP_CONTEXT = {
        path: '${pageContext.request.contextPath}'
    };
</script>

<%@ include file="/includes/footer.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/users-reviewAndratings.css">
<script src="${pageContext.request.contextPath}/resources/js/users-reviewAndratings.js"></script>