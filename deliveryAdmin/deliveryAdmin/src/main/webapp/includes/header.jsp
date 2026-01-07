<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>


                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <!-- Add this to your HTML head or form -->
                    <meta name="_csrf" content="${_csrf.token}" />
                    <meta name="_csrf_header" content="${_csrf.headerName}" />
                    <title>Admin Delivery Dashboard</title>

                    <link rel="icon" href="${pageContext.request.contextPath}/resources/images/url-image-logo.png"
                        type="image/png" />
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/resources/css/common/header-menu.css">
                    <!-- Scripts -->
                    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    <!-- WebSocket Libraries -->
                    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.5.2/dist/sockjs.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

                    <!-- Moment.js for date formatting -->
                    <script src="https://cdn.jsdelivr.net/npm/moment@2.29.1/moment.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

                </head>

                <body class="dashboard-body">

                    <!-- Header -->
                    <!-- Header Removed by User Request (Navigation Refactor) -->
                    <!--
    <header class="header">
        <div class="header-left">
            <button class="sidebar-toggle d-lg-none">
                <i class="fas fa-bars"></i>
            </button>
        </div>
        <div class="header-right">
            ...
        </div>
    </header>
    -->

                    <!-- Mobile Toggle Button (Floating) - Optional if needed, but for now removing the bar completely. 
         If mobile toggle is lost, we might need to add it back elsewhere. 
         Adding a floating toggle just in case for mobile. -->
                    <button
                        class="btn btn-primary d-lg-none position-fixed top-0 start-0 m-3 z-50 rounded-circle shadow"
                        onclick="$('.sidebar').toggleClass('active')"
                        style="z-index: 1050; width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;">
                        <i class="fas fa-bars"></i>
                    </button>

                    <!-- Change Password Modal -->
                    <div class="modal fade" id="changePasswordModal" tabindex="-1"
                        aria-labelledby="changePasswordModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="changePasswordModalLabel">Change Password</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <form id="changePasswordForm">
                                    <div class="modal-body">
                                        <!-- Phone Number Input -->
                                        <div class="mb-3">
                                            <label for="phoneNumber" class="form-label">Phone Number</label>
                                            <div class="input-group">
                                                <input type="text" class="form-control" id="phoneNumber"
                                                    name="phoneNumber" required placeholder="Enter your phone number"
                                                    value="${currentStaff.phone}">
                                                <button class="btn btn-outline-secondary" type="button"
                                                    id="generateOtpBtn">Generate OTP</button>
                                            </div>
                                        </div>

                                        <!-- OTP Verification -->
                                        <div class="mb-3">
                                            <label for="otp" class="form-label">OTP Verification</label>
                                            <div class="input-group">
                                                <input type="text" class="form-control" id="otp" name="otp" required
                                                    placeholder="Enter OTP">
                                                <button class="btn btn-outline-secondary" type="button"
                                                    id="verifyOtpBtn">Verify OTP</button>
                                            </div>
                                            <div id="otpStatus" class="form-text"></div>
                                        </div>

                                        <!-- Password Fields (initially disabled) -->
                                        <div class="mb-3">
                                            <label for="newPassword" class="form-label">New Password</label>
                                            <input type="password" class="form-control" id="newPassword"
                                                name="newPassword" required disabled>
                                            <div id="passwordHelp" class="form-text"></div>
                                        </div>
                                        <div class="mb-3">
                                            <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                            <input type="password" class="form-control" id="confirmPassword"
                                                name="confirmPassword" required disabled>
                                            <div id="confirmPasswordHelp" class="form-text"></div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Close</button>
                                        <button type="submit" class="btn btn-primary" id="changePasswordBtn"
                                            disabled>Change Password</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Main Content -->
                    <div class="dashboard-container">
                        <!-- Sidebar -->
                        <%@ include file="/includes/sidebar.jsp" %>


                            <script>
                                $(document).ready(function () {
                                    const token = $("meta[name='_csrf']").attr("content");
                                    const header = $("meta[name='_csrf_header']").attr("content");
                                    const phoneNumberInput = $('#phoneNumber');
                                    const otpInput = $('#otp');
                                    const newPasswordInput = $('#newPassword');
                                    const confirmPasswordInput = $('#confirmPassword');
                                    const otpStatusDiv = $('#otpStatus');
                                    const passwordHelpDiv = $('#passwordHelp');
                                    const confirmPasswordHelpDiv = $('#confirmPasswordHelp');
                                    const generateOtpBtn = $('#generateOtpBtn');
                                    const verifyOtpBtn = $('#verifyOtpBtn');
                                    const changePasswordBtn = $('#changePasswordBtn');

                                    $(document).ajaxSend(function (e, xhr, options) {
                                        if (header && token) {
                                            xhr.setRequestHeader(header, token);
                                        }
                                    });

                                    let isOtpVerified = false;
                                    let otpRequestCount = 0;
                                    const MAX_OTP_REQUESTS = 3;
                                    const OTP_RESEND_TIMEOUT = 60000; // 60 seconds

                                    // Generate OTP button click handler
                                    generateOtpBtn.click(function () {
                                        const phoneNumber = phoneNumberInput.val().trim();

                                        if (!phoneNumber) {
                                            showOtpStatus('Phone number is required', 'error');
                                            return;
                                        }

                                        // Validate phone number format (basic validation)
                                        if (!/^[0-9]{10}$/.test(phoneNumber)) {
                                            showOtpStatus('Please enter a valid 10-digit phone number', 'error');
                                            return;
                                        }

                                        // Check if OTP requests exceeded
                                        if (otpRequestCount >= MAX_OTP_REQUESTS) {
                                            showOtpStatus('OTP request limit reached. Please try again later.', 'error');
                                            generateOtpBtn.prop('disabled', true);
                                            setTimeout(() => {
                                                otpRequestCount = 0;
                                                generateOtpBtn.prop('disabled', false);
                                                showOtpStatus('You can now request OTP again', 'info');
                                            }, OTP_RESEND_TIMEOUT);
                                            return;
                                        }

                                        setButtonLoading(generateOtpBtn, true, 'Sending...');

                                        $.ajax({
                                            url: '${pageContext.request.contextPath}/api/auth/generate-otp',
                                            type: 'POST',
                                            data: { phoneNumber: phoneNumber },
                                            success: function (response) {
                                                console.log("Full API response:", response);
                                                otpRequestCount++;
                                                if (response.message) {
                                                    showOtpStatus(response.message, 'success');
                                                    // Auto-focus OTP field
                                                    otpInput.focus();
                                                    // Enable verify button
                                                    verifyOtpBtn.prop('disabled', false);
                                                } else {
                                                    showOtpStatus('Failed to generate OTP', 'error');
                                                }
                                            },
                                            error: function (xhr) {
                                                console.error("Error details:", {
                                                    status: xhr.status,
                                                    statusText: xhr.statusText,
                                                    responseText: xhr.responseText,
                                                    error: error
                                                });
                                                let errorMsg = 'Error generating OTP';
                                                try {
                                                    const response = JSON.parse(xhr.responseText);
                                                    errorMsg = response.message || errorMsg;
                                                } catch (e) {
                                                    errorMsg = xhr.statusText || errorMsg;
                                                }
                                                showOtpStatus(errorMsg, 'error');
                                            },
                                            complete: function () {
                                                setButtonLoading(generateOtpBtn, false, 'Generate OTP');
                                            }
                                        });
                                    });

                                    // Verify OTP button click handler
                                    verifyOtpBtn.click(function () {
                                        const phoneNumber = phoneNumberInput.val().trim();
                                        const otp = otpInput.val().trim();

                                        if (!phoneNumber || !otp) {
                                            showOtpStatus('Phone number and OTP are required', 'error');
                                            return;
                                        }

                                        // Validate OTP format (6 digits)
                                        if (!/^[0-9]{6}$/.test(otp)) {
                                            showOtpStatus('OTP must be 6 digits', 'error');
                                            return;
                                        }

                                        setButtonLoading(verifyOtpBtn, true, 'Verifying...');

                                        $.ajax({
                                            url: '${pageContext.request.contextPath}/api/auth/verify-otp',
                                            type: 'POST',
                                            data: {
                                                phoneNumber: phoneNumber,
                                                otp: otp
                                            },
                                            success: function (response) {
                                                if (response.success) {
                                                    showOtpStatus(response.message, 'success');
                                                    isOtpVerified = true;
                                                    // Enable password fields
                                                    newPasswordInput.prop('disabled', false);
                                                    confirmPasswordInput.prop('disabled', false);
                                                    newPasswordInput.focus();
                                                    // Disable OTP fields to prevent changes
                                                    otpInput.prop('disabled', true);
                                                    verifyOtpBtn.prop('disabled', true);
                                                } else {
                                                    showOtpStatus(response.message, 'error');
                                                    isOtpVerified = false;
                                                }
                                            },
                                            error: function (xhr) {
                                                let errorMsg = 'Error verifying OTP';
                                                try {
                                                    const response = JSON.parse(xhr.responseText);
                                                    errorMsg = response.message || errorMsg;
                                                } catch (e) {
                                                    errorMsg = xhr.responseText || errorMsg;
                                                }
                                                showOtpStatus(errorMsg, 'error');
                                                isOtpVerified = false;
                                            },
                                            complete: function () {
                                                setButtonLoading(verifyOtpBtn, false, 'Verify OTP');
                                            }
                                        });
                                    });

                                    // Password validation
                                    newPasswordInput.add(confirmPasswordInput).on('keyup', function () {
                                        validatePasswords();
                                    });

                                    // Form submission handler
                                    $('#changePasswordForm').submit(function (e) {
                                        e.preventDefault();

                                        if (!validatePasswords()) {
                                            return;
                                        }

                                        const phoneNumber = phoneNumberInput.val().trim();
                                        const otp = otpInput.val().trim();
                                        const newPassword = newPasswordInput.val();
                                        const confirmPassword = confirmPasswordInput.val();

                                        // Show loading state
                                        setButtonLoading(changePasswordBtn, true, 'Processing...');

                                        $.ajax({
                                            url: '${pageContext.request.contextPath}/api/auth/change-password',
                                            type: 'POST',
                                            data: {
                                                phoneNumber: phoneNumber,
                                                otp: otp,
                                                newPassword: newPassword,
                                                confirmPassword: confirmPassword
                                            },
                                            success: function (response) {
                                                if (response.success) {
                                                    showAlert('Success', 'Password changed successfully', 'success');
                                                    $('#changePasswordModal').modal('hide');
                                                    resetForm();
                                                } else {
                                                    showAlert('Error', response.message || 'Failed to change password', 'error');
                                                }
                                            },
                                            error: function (xhr) {
                                                let errorMsg = 'Error changing password';
                                                try {
                                                    const response = JSON.parse(xhr.responseText);
                                                    errorMsg = response.message || errorMsg;
                                                } catch (e) {
                                                    errorMsg = xhr.responseText || errorMsg;
                                                }
                                                showAlert('Error', errorMsg, 'error');
                                            },
                                            complete: function () {
                                                setButtonLoading(changePasswordBtn, false, 'Change Password');
                                            }
                                        });
                                    });

                                    // Helper function to validate passwords
                                    function validatePasswords() {
                                        const newPassword = newPasswordInput.val();
                                        const confirmPassword = confirmPasswordInput.val();

                                        // Validate password strength
                                        if (newPassword.length > 0 && newPassword.length < 8) {
                                            passwordHelpDiv.text('Password must be at least 8 characters').css('color', 'red');
                                            changePasswordBtn.prop('disabled', true);
                                            return false;
                                        } else {
                                            passwordHelpDiv.text('').css('color', 'green');
                                        }

                                        // Check if passwords match
                                        if (confirmPassword.length > 0) {
                                            if (newPassword !== confirmPassword) {
                                                confirmPasswordHelpDiv.text('Passwords do not match').css('color', 'red');
                                                changePasswordBtn.prop('disabled', true);
                                                return false;
                                            } else {
                                                confirmPasswordHelpDiv.text('Passwords match').css('color', 'green');
                                            }
                                        } else {
                                            confirmPasswordHelpDiv.text('');
                                        }

                                        // Enable submit button if all conditions are met
                                        const isValid = isOtpVerified &&
                                            newPassword.length >= 8 &&
                                            newPassword === confirmPassword;

                                        changePasswordBtn.prop('disabled', !isValid);
                                        return isValid;
                                    }

                                    // Helper function to show OTP status
                                    function showOtpStatus(message, type) {
                                        otpStatusDiv.text(message);
                                        switch (type) {
                                            case 'success':
                                                otpStatusDiv.css('color', 'green');
                                                break;
                                            case 'error':
                                                otpStatusDiv.css('color', 'red');
                                                break;
                                            case 'info':
                                                otpStatusDiv.css('color', 'blue');
                                                break;
                                            default:
                                                otpStatusDiv.css('color', 'black');
                                        }
                                    }

                                    // Helper function to set button loading state
                                    function setButtonLoading(button, isLoading, text) {
                                        if (isLoading) {
                                            button.prop('disabled', true).html(`<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> ${text}`);
                                        } else {
                                            button.prop('disabled', false).text(text);
                                        }
                                    }

                                    // Helper function to show alert
                                    function showAlert(title, message, type) {
                                        // You can replace this with a more sophisticated alert system
                                        alert(`${title}: ${message}`);
                                    }

                                    function resetForm() {
                                        $('#changePasswordForm')[0].reset();
                                        phoneNumberInput.val('${currentStaff.phone}'); // Reset to staff's phone number
                                        otpStatusDiv.text('');
                                        passwordHelpDiv.text('');
                                        confirmPasswordHelpDiv.text('');
                                        newPasswordInput.prop('disabled', true);
                                        confirmPasswordInput.prop('disabled', true);
                                        otpInput.prop('disabled', false);
                                        verifyOtpBtn.prop('disabled', false);
                                        generateOtpBtn.prop('disabled', false);
                                        isOtpVerified = false;
                                        changePasswordBtn.prop('disabled', true);
                                    }

                                    // Reset form when modal is closed
                                    $('#changePasswordModal').on('hidden.bs.modal', function () {
                                        resetForm();
                                    });

                                    // Initial setup
                                    resetForm();
                                    verifyOtpBtn.prop('disabled', true); // Disable verify button initially
                                });
                            </script>