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
            <h1 class="pt-3">SMS Integration</h1>
        </div>

        <!-- Main Content Area -->
        <div id="loader" class="text-center p-5">
            <i class="fas fa-spinner fa-spin fa-3x"></i>
            <h5 class="mt-3">Loading Configuration...</h5>
        </div>

        <div id="mainContent" class="d-none">
            <!-- SMS API Configuration Card -->
            <div class="card mb-4">
                <div class="card-header"><h5 class="mb-0">SMS Gateway Configuration</h5></div>
                <div class="card-body">
                    <form id="smsConfigForm">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">SMS Provider</label>
                                    <select class="form-select" name="provider" id="smsProvider">
                                        <option value="">Select Provider</option>
                                        <option value="TWILIO">Twilio</option>
                                        <option value="MSG91">MSG91</option>
                                        <option value="NEXMO">Nexmo (Vonage)</option>
                                        <option value="AIRTEL">Airtel Enterprise</option>
                                        <option value="OTHER">Other</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">API URL</label>
                                    <input type="url" class="form-control" name="apiUrl" id="apiUrl" placeholder="https://api.smsprovider.com/send">
                                    <div class="form-text d-none" id="airtelUrlHelp">Airtel Enterprise uses a fixed URL provided during onboarding</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Auth Token / Password</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" name="authToken" id="authTokenInput">
                                        <button class="btn btn-outline-secondary" type="button" id="toggleAuthToken"><i class="fas fa-eye"></i></button>
                                    </div>
                                    <div class="alert alert-warning mt-2 d-none" id="airtelTokenWarning">
                                        <i class="fas fa-exclamation-triangle me-2"></i>Airtel Enterprise tokens require periodic renewal.
                                    </div>
                                </div>
                            </div>
                        </div>
                        <h6 class="mt-4 mb-3">Template IDs (Required for some providers)</h6>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Login OTP Template</label>
                                <input type="text" class="form-control" name="otpTemplateId" id="otpTemplateId" placeholder="Template ID">
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Order Notification</label>
                                <input type="text" class="form-control" name="orderTemplateId" id="orderTemplateId" placeholder="Template ID">
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Alert/Reminder</label>
                                <input type="text" class="form-control" name="alertTemplateId" id="alertTemplateId" placeholder="Template ID">
                            </div>
                        </div>
                        <div class="d-flex justify-content-end mt-3">
                            <button type="button" class="btn btn-secondary me-2" data-bs-toggle="modal" data-bs-target="#testSmsModal">
                                <i class="fas fa-paper-plane me-2"></i>Test SMS
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>Save Configuration
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- SMS Features Toggle Card -->
            <div class="card">
                <div class="card-header"><h5 class="mb-0">SMS Features Management</h5></div>
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <div class="form-check form-switch mb-4">
                                <input class="form-check-input feature-toggle" type="checkbox" id="enableSmsFeature" data-feature="enabled">
                                <label class="form-check-label" for="enableSmsFeature">
                                    <h6 class="mb-0">Enable SMS Services</h6>
                                    <small class="text-muted">Master switch for all SMS functionality</small>
                                </label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>SMS credits remaining: <strong id="smsBalance">N/A</strong>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card mb-4"><div class="card-body">
                                <h6 class="card-title mb-3">Authentication</h6>
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input feature-toggle" type="checkbox" id="enableLoginOtp" data-feature="loginOtpEnabled">
                                    <label class="form-check-label" for="enableLoginOtp">Login OTP Verification</label>
                                </div>
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input feature-toggle" type="checkbox" id="enablePasswordReset" data-feature="passwordResetEnabled">
                                    <label class="form-check-label" for="enablePasswordReset">Password Reset SMS</label>
                                </div>
                            </div></div>
                        </div>
                        <div class="col-md-6">
                            <div class="card mb-4"><div class="card-body">
                                <h6 class="card-title mb-3">Notifications</h6>
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input feature-toggle" type="checkbox" id="enableOrderUpdates" data-feature="orderUpdatesEnabled">
                                    <label class="form-check-label" for="enableOrderUpdates">Order Status Updates</label>
                                </div>
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input feature-toggle" type="checkbox" id="enablePromotions" data-feature="promotionsEnabled">
                                    <label class="form-check-label" for="enablePromotions">Promotions/Alerts</label>
                                </div>
                            </div></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Test SMS Modal -->
<div class="modal fade" id="testSmsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Test SMS Configuration</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="testSmsForm">
                    <div class="mb-3">
                        <label class="form-label">Phone Number (with country code)</label>
                        <input type="tel" class="form-control" name="phone" placeholder="+919876543210" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Message Type</label>
                        <select class="form-select" name="type" required>
                            <option value="">Select Message Type</option>
                            <option value="OTP">OTP Message</option>
                            <option value="ORDER">Order Notification</option>
                            <option value="ALERT">Alert Message</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="sendTestSmsBtn">
                    <i class="fas fa-paper-plane me-2"></i>Send Test
                </button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sms-integration.css">
<script src="${pageContext.request.contextPath}/resources/js/sms-integration.js"></script>