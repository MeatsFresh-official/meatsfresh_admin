<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/header.jsp" %>

<!-- Toast/Notification Containers -->
<div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100;">
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
    <div class="container-fluid px-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="pt-3">Notifications Management</h1>
        </div>

        <!-- Notification Types Tabs -->
        <div class="card mb-4">
            <div class="card-header">
                <ul class="nav nav-tabs card-header-tabs" id="notificationTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="templates-tab" data-bs-toggle="tab" data-bs-target="#templates" type="button" role="tab">
                            <i class="fas fa-envelope me-2"></i>Message Templates
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="promotional-tab" data-bs-toggle="tab" data-bs-target="#promotional" type="button" role="tab">
                            <i class="fas fa-bullhorn me-2"></i>Promotional
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="sounds-tab" data-bs-toggle="tab" data-bs-target="#sounds" type="button" role="tab">
                            <i class="fas fa-volume-up me-2"></i>Sound Settings
                        </button>
                    </li>
                </ul>
            </div>
            <div class="card-body tab-content" id="notificationTabContent">
                <!-- Message Templates Tab -->
                <div class="tab-pane fade show active" id="templates" role="tabpanel">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="list-group" id="notificationTemplatesList">
                                <!-- JS will populate this list -->
                                <div class="text-center p-3"><i class="fas fa-spinner fa-spin"></i> Loading templates...</div>
                            </div>
                        </div>
                        <div class="col-md-8">
                            <div id="templateEditor" class="d-none">
                                <form id="templateForm">
                                    <input type="hidden" id="templateId" name="id">
                                    <div class="mb-3">
                                        <label class="form-label">Template Name</label>
                                        <input type="text" class="form-control" id="templateName" name="name" readonly>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Target Audience</label>
                                        <input type="text" class="form-control" id="templateAudience" name="audience" readonly>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Notification Message</label>
                                        <textarea class="form-control" id="templateMessage" name="message" rows="5" required></textarea>
                                        <div class="form-text" id="templateVariables">Available variables:</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Notification Icon</label>
                                        <select class="form-select" id="templateIcon" name="icon">
                                            <option value="fa-bell">Default Bell</option>
                                            <option value="fa-shopping-cart">Shopping Cart</option>
                                            <option value="fa-truck">Delivery Truck</option>
                                            <option value="fa-gift">Gift</option>
                                            <option value="fa-exclamation-circle">Alert</option>
                                        </select>
                                    </div>
                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-2"></i>Save Template
                                        </button>
                                    </div>
                                </form>
                            </div>
                            <div id="templatePlaceholder" class="text-center p-5 border rounded">
                                <i class="fas fa-mouse-pointer fa-3x text-muted mb-3"></i>
                                <h5>Select a template to view or edit</h5>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Promotional Notifications Tab -->
                <div class="tab-pane fade" id="promotional" role="tabpanel">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="mb-0">Promotional Campaigns</h5>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createCampaignModal">
                            <i class="fas fa-plus me-2"></i>Create Campaign
                        </button>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover" id="campaignsTable">
                            <thead>
                                <tr>
                                    <th>Campaign Name</th>
                                    <th>Target</th>
                                    <th>Status</th>
                                    <th>Sent Date</th>
                                    <th>Recipients</th>
                                    <th>Open Rate</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr><td colspan="7" class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading campaigns...</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Sound Settings Tab -->
                <div class="tab-pane fade" id="sounds" role="tabpanel">
                    <!-- Sound settings content will be managed by JS -->
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Create Campaign Modal -->
<div class="modal fade" id="createCampaignModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <form class="modal-content" id="createCampaignForm">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Create Promotional Campaign</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
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