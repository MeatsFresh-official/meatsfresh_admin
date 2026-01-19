<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/includes/header.jsp" %>

        <!-- Toast/Notification Containers -->
        <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100;">
            <div id="successToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header bg-success text-white">
                    <strong class="me-auto">Success</strong>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"
                        aria-label="Close"></button>
                </div>
                <div class="toast-body" id="toastMessage"></div>
            </div>
            <div id="errorToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header bg-danger text-white">
                    <strong class="me-auto">Error</strong>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"
                        aria-label="Close"></button>
                </div>
                <div class="toast-body" id="errorMessage"></div>
            </div>
        </div>

        <main class="main-content">
            <div class="container-fluid px-4">
                <div class="d-flex justify-content-between align-items-center mb-5">
                    <div>
                        <h1 class="display-5 fw-bold text-gradient">Notifications Center</h1>
                        <p class="text-muted lead">Manage and send FCM notifications to your ecosystem</p>
                    </div>
                    <div class="date-display text-muted">
                        <i class="far fa-calendar-alt me-2"></i><span id="currentDate"></span>
                    </div>
                </div>

                <!-- Notification Sections -->
                <div class="row g-4">
                    <div class="col-12">
                        <div class="glass-panel p-4">
                            <ul class="nav nav-pills nav-fill mb-4 p-1 glass-header rounded-pill" id="notificationTabs"
                                role="tablist"
                                style="border: 1px solid rgba(255,255,255,0.5); background: rgba(255,255,255,0.3);">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active rounded-pill fw-bold" id="user-tab"
                                        data-bs-toggle="pill" data-bs-target="#user-section" type="button" role="tab">
                                        <i class="fas fa-users me-2"></i>User App
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link rounded-pill fw-bold" id="vendor-tab" data-bs-toggle="pill"
                                        data-bs-target="#vendor-section" type="button" role="tab">
                                        <i class="fas fa-store me-2"></i>Vendor App
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link rounded-pill fw-bold" id="partner-tab" data-bs-toggle="pill"
                                        data-bs-target="#partner-section" type="button" role="tab">
                                        <i class="fas fa-motorcycle me-2"></i>Partner App
                                    </button>
                                </li>
                            </ul>

                            <div class="tab-content" id="notificationTabContent">

                                <!-- User Section -->
                                <div class="tab-pane fade show active" id="user-section" role="tabpanel">
                                    <div class="row justify-content-center">
                                        <div class="col-lg-8">
                                            <div class="text-center mb-4">
                                                <h3 class="fw-bold">Send to Users</h3>
                                                <p class="text-muted">Create engaging notifications for your customer
                                                    base</p>
                                            </div>
                                            <form id="userForm">
                                                <div class="mb-3">
                                                    <label class="form-label text-muted fw-bold">Notification
                                                        Title</label>
                                                    <input type="text" class="form-control glass-input" id="userTitle"
                                                        placeholder="e.g. 50% Off Today Only!" required>
                                                </div>
                                                <div class="mb-4">
                                                    <label class="form-label text-muted fw-bold">Message Body</label>
                                                    <textarea class="form-control glass-input" id="userBody" rows="4"
                                                        placeholder="Enter your message here..." required></textarea>
                                                </div>
                                                <button type="submit"
                                                    class="btn btn-primary btn-lg w-100 rounded-pill shadow-sm">
                                                    <i class="fas fa-paper-plane me-2"></i>Send to All Users
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <!-- Vendor Section -->
                                <div class="tab-pane fade" id="vendor-section" role="tabpanel">
                                    <div class="row justify-content-center">
                                        <div class="col-lg-8">
                                            <div class="text-center mb-4">
                                                <h3 class="fw-bold">Send to Vendors</h3>
                                                <p class="text-muted">Update your vendors with important announcements
                                                </p>
                                            </div>
                                            <form id="vendorForm">
                                                <div class="mb-3">
                                                    <label class="form-label text-muted fw-bold">Notification
                                                        Title</label>
                                                    <input type="text" class="form-control glass-input" id="vendorTitle"
                                                        placeholder="e.g. New Order System Update" required>
                                                </div>
                                                <div class="mb-4">
                                                    <label class="form-label text-muted fw-bold">Message Body</label>
                                                    <textarea class="form-control glass-input" id="vendorBody" rows="4"
                                                        placeholder="Enter instructions for vendors..."
                                                        required></textarea>
                                                </div>
                                                <button type="submit"
                                                    class="btn btn-success btn-lg w-100 rounded-pill shadow-sm">
                                                    <i class="fas fa-paper-plane me-2"></i>Send to All Vendors
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <!-- Partner Section -->
                                <div class="tab-pane fade" id="partner-section" role="tabpanel">
                                    <div class="row justify-content-center">
                                        <div class="col-lg-8">
                                            <div class="text-center mb-4">
                                                <h3 class="fw-bold">Send to Partners</h3>
                                                <p class="text-muted">Broadcast alerts to your delivery fleet</p>
                                            </div>
                                            <form id="partnerForm">
                                                <div class="mb-3">
                                                    <label class="form-label text-muted fw-bold">Notification
                                                        Title</label>
                                                    <input type="text" class="form-control glass-input"
                                                        id="partnerTitle" placeholder="e.g. High Demand Area Alert"
                                                        required>
                                                </div>
                                                <div class="mb-4">
                                                    <label class="form-label text-muted fw-bold">Message Body</label>
                                                    <textarea class="form-control glass-input" id="partnerBody" rows="4"
                                                        placeholder="Alert partners about demand..."
                                                        required></textarea>
                                                </div>
                                                <button type="submit"
                                                    class="btn btn-warning btn-lg w-100 rounded-pill shadow-sm text-white">
                                                    <i class="fas fa-paper-plane me-2"></i>Send to All Partners
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Extra Styles for this page specifically -->
            <style>
                .text-gradient {
                    background: linear-gradient(135deg, #4f46e5 0%, #3b82f6 100%);
                    background-clip: text;
                    -webkit-background-clip: text;
                    -webkit-text-fill-color: transparent;
                }

                .nav-pills .nav-link {
                    color: #6b7280;
                    transition: all 0.3s ease;
                }

                .nav-pills .nav-link.active {
                    background: linear-gradient(135deg, #4f46e5, #3b82f6);
                    color: white;
                    box-shadow: 0 4px 15px -3px rgba(79, 70, 229, 0.4);
                }

                .glass-input {
                    background: rgba(255, 255, 255, 0.5);
                    border: 1px solid rgba(229, 231, 235, 0.5);
                    border-radius: 12px;
                    padding: 12px 16px;
                    transition: all 0.3s;
                }

                .glass-input:focus {
                    background: #fff;
                    box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
                    border-color: #4f46e5;
                }

                .floating-anim {
                    animation: float 6s ease-in-out infinite;
                }

                @keyframes float {
                    0% {
                        transform: translateY(0px);
                    }

                    50% {
                        transform: translateY(-20px);
                    }

                    100% {
                        transform: translateY(0px);
                    }
                }
            </style>
        </main>

        <!-- Create Campaign Modal -->
        <div class="modal fade" id="createCampaignModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <form class="modal-content" id="createCampaignForm">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">Create Promotional Campaign</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Campaign Name</label>
                                    <input type="text" class="form-control" name="campaignName" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Target Audience</label>
                                    <select class="form-select" name="campaignAudience" required>
                                        <option value="">Select Audience</option>
                                        <option value="ALL_USERS">All Users</option>
                                        <option value="NEW_USERS">New Users (last 30 days)</option>
                                        <option value="INACTIVE_USERS">Inactive Users</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Schedule</label>
                                    <select class="form-select" name="scheduleType" id="scheduleType" required>
                                        <option value="NOW">Send Immediately</option>
                                        <option value="SCHEDULE">Schedule for later</option>
                                    </select>
                                </div>
                                <div class="mb-3 d-none" id="scheduleDateContainer">
                                    <label class="form-label">Schedule Date & Time</label>
                                    <input type="datetime-local" class="form-control" name="scheduleDate">
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Campaign Message</label>
                            <textarea class="form-control" name="campaignMessage" rows="4" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Campaign Image (Optional)</label>
                            <input type="file" class="form-control" name="campaignImage" accept="image/*">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Create Campaign</button>
                    </div>
                </form>
            </div>
        </div>

        <%@ include file="/includes/footer.jsp" %>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/notifications.css">
            <script src="${pageContext.request.contextPath}/resources/js/notifications.js"></script>