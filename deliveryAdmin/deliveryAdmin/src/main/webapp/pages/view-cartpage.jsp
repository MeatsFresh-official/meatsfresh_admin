<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/includes/header.jsp" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>

            <main class="main-content p-6">
                <div class="view-cart-container">
                    <!-- Page Header -->
                    <div class="page-header d-flex justify-content-between align-items-center animate-enter">
                        <div>
                            <h1 class="page-title">Order #${order.id}</h1>
                            <p class="page-subtitle">Manage charges and delivery details</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/orders-billings"
                            class="btn-zenith-secondary text-decoration-none">
                            <i class="fas fa-arrow-left me-2"></i>Back to Orders
                        </a>
                    </div>

                    <div class="row g-4">
                        <!-- Left Column: Charges Adjustment -->
                        <div class="col-lg-8 animate-enter" style="animation-delay: 0.1s;">
                            <form id="chargesForm" action="http://meatsfresh.org.in:8082/api/fee-config" method="post">
                                <input type="hidden" name="orderId" value="${order.id}">

                                <div class="glass-panel">
                                    <div class="d-flex align-items-center mb-4">
                                        <span class="p-2 rounded-circle bg-blue-50 text-blue-600 me-3">
                                            <i class="fas fa-calculator fa-lg"></i>
                                        </span>
                                        <h3 class="fw-bold mb-0">Adjust Order Charges</h3>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <!-- Base Delivery Fee -->
                                            <div class="toggle-card">
                                                <div class="toggle-header">
                                                    <div class="toggle-label">
                                                        <div class="toggle-icon"><i class="fas fa-truck"></i></div>
                                                        Base Delivery Fee
                                                    </div>
                                                    <label class="zenith-switch">
                                                        <input type="checkbox" class="charge-toggle"
                                                            id="toggleBaseDeliveryFee" name="deliveryFeeEnabled"
                                                            ${order.baseDeliveryFee> 0 ? 'checked' : ''}>
                                                        <span class="slider"></span>
                                                    </label>
                                                </div>
                                                <div class="input-reveal" id="baseDeliveryFeeGroup">
                                                    <div class="zenith-input-group">
                                                        <span class="zenith-input-text">${currencySymbol}</span>
                                                        <input type="number" class="zenith-input-field"
                                                            name="baseDeliveryFee"
                                                            value="${order.baseDeliveryFee > 0 ? order.baseDeliveryFee : ''}"
                                                            step="0.01" min="0" placeholder="0.00">
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Rain Fee -->
                                            <div class="toggle-card">
                                                <div class="toggle-header">
                                                    <div class="toggle-label">
                                                        <div class="toggle-icon"><i class="fas fa-cloud-rain"></i></div>
                                                        Rain Fee
                                                    </div>
                                                    <label class="zenith-switch">
                                                        <input type="checkbox" class="charge-toggle" id="toggleRainFee"
                                                            name="rainFeeEnabled" ${order.rainFee> 0 ? 'checked' : ''}>
                                                        <span class="slider"></span>
                                                    </label>
                                                </div>
                                                <div class="input-reveal" id="rainFeeGroup">
                                                    <div class="zenith-input-group">
                                                        <span class="zenith-input-text">${currencySymbol}</span>
                                                        <input type="number" class="zenith-input-field" name="rainFee"
                                                            value="${order.rainFee > 0 ? order.rainFee : ''}"
                                                            step="0.01" min="0" placeholder="0.00">
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Packaging Charge -->
                                            <div class="toggle-card">
                                                <div class="toggle-header">
                                                    <div class="toggle-label">
                                                        <div class="toggle-icon"><i class="fas fa-box-open"></i></div>
                                                        Packaging Fee
                                                    </div>
                                                    <label class="zenith-switch">
                                                        <input type="checkbox" class="charge-toggle"
                                                            id="togglePackagingCharge" name="packagingChargeEnabled"
                                                            ${order.packagingCharge> 0 ? 'checked' : ''}>
                                                        <span class="slider"></span>
                                                    </label>
                                                </div>
                                                <div class="input-reveal" id="packagingChargeGroup">
                                                    <div class="zenith-input-group">
                                                        <span class="zenith-input-text">${currencySymbol}</span>
                                                        <input type="number" class="zenith-input-field"
                                                            name="packagingCharge"
                                                            value="${order.packagingCharge > 0 ? order.packagingCharge : ''}"
                                                            step="0.01" min="0" placeholder="0.00">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <!-- Platform Fee -->
                                            <div class="toggle-card">
                                                <div class="toggle-header">
                                                    <div class="toggle-label">
                                                        <div class="toggle-icon"><i class="fas fa-laptop-code"></i>
                                                        </div>
                                                        Platform Fee (%)
                                                    </div>
                                                    <label class="zenith-switch">
                                                        <input type="checkbox" class="charge-toggle"
                                                            id="togglePlatformFee" name="platformFeeEnabled"
                                                            ${order.platformFeeRate> 0 ? 'checked' : ''}>
                                                        <span class="slider"></span>
                                                    </label>
                                                </div>
                                                <div class="input-reveal" id="platformFeeGroup">
                                                    <div class="zenith-input-group">
                                                        <span class="zenith-input-text">%</span>
                                                        <input type="number" class="zenith-input-field"
                                                            name="platformFeeRate"
                                                            value="${order.platformFeeRate > 0 ? order.platformFeeRate : ''}"
                                                            step="0.01" min="0" placeholder="0.00">
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Service Charge -->
                                            <div class="toggle-card">
                                                <div class="toggle-header">
                                                    <div class="toggle-label">
                                                        <div class="toggle-icon"><i class="fas fa-concierge-bell"></i>
                                                        </div>
                                                        Service Charge
                                                    </div>
                                                    <label class="zenith-switch">
                                                        <input type="checkbox" class="charge-toggle"
                                                            id="toggleServiceCharge" name="serviceChargeEnabled"
                                                            ${order.serviceCharge> 0 ? 'checked' : ''}>
                                                        <span class="slider"></span>
                                                    </label>
                                                </div>
                                                <div class="input-reveal" id="serviceChargeGroup">
                                                    <div class="zenith-input-group">
                                                        <span class="zenith-input-text">${currencySymbol}</span>
                                                        <input type="number" class="zenith-input-field"
                                                            name="serviceCharge"
                                                            value="${order.serviceCharge > 0 ? order.serviceCharge : ''}"
                                                            step="0.01" min="0" placeholder="0.00">
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- GST -->
                                            <div class="toggle-card">
                                                <div class="toggle-header">
                                                    <div class="toggle-label">
                                                        <div class="toggle-icon"><i class="fas fa-percentage"></i></div>
                                                        GST Rate (%)
                                                    </div>
                                                    <label class="zenith-switch">
                                                        <input type="checkbox" class="charge-toggle" id="toggleGstRate"
                                                            name="gstRateEnabled" ${order.gstRate> 0 ? 'checked' : ''}>
                                                        <span class="slider"></span>
                                                    </label>
                                                </div>
                                                <div class="input-reveal" id="gstRateGroup">
                                                    <div class="zenith-input-group">
                                                        <span class="zenith-input-text">%</span>
                                                        <input type="number" class="zenith-input-field" name="gstRate"
                                                            value="${order.gstRate > 0 ? order.gstRate : ''}"
                                                            step="0.01" min="0" placeholder="0.00">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div> <!-- end row -->

                                    <!-- Custom Fees -->
                                    <div class="mt-4 pt-4 border-top">
                                        <h5 class="fw-bold mb-3">Custom Fees</h5>
                                        <div id="customFeesContainer" class="custom-fee-list mb-3">
                                            <c:forEach items="${order.customFees}" var="customFee">
                                                <div class="custom-fee-item">
                                                    <div class="zenith-input-group flex-grow-1">
                                                        <input type="text" class="zenith-input-field"
                                                            name="customFeeNames" value="${customFee.name}"
                                                            placeholder="Fee Name" required>
                                                    </div>
                                                    <div class="zenith-input-group" style="width: 140px;">
                                                        <span class="zenith-input-text">${currencySymbol}</span>
                                                        <input type="number" class="zenith-input-field"
                                                            name="customFeeValues" value="${customFee.value}"
                                                            step="0.01" min="0" required>
                                                    </div>
                                                    <button type="button" class="btn-remove-fee remove-custom-fee">
                                                        <i class="fas fa-trash-alt"></i>
                                                    </button>
                                                </div>
                                            </c:forEach>
                                        </div>
                                        <button type="button" id="addCustomFee" class="add-fee-btn">
                                            <i class="fas fa-plus me-2"></i>Add Custom Fee
                                        </button>
                                    </div>

                                    <div class="mt-4 pt-4">
                                        <button type="submit" class="btn-zenith-primary">
                                            <i class="fas fa-save me-2"></i>Update Charges
                                        </button>
                                    </div>

                                </div>
                            </form>
                        </div>

                        <!-- Right Column: Delivery Instructions -->
                        <div class="col-lg-4 animate-enter" style="animation-delay: 0.2s;">
                            <div class="glass-panel h-100">
                                <div class="d-flex align-items-center mb-4">
                                    <span class="p-2 rounded-circle bg-orange-50 text-orange-500 me-3">
                                        <i class="fas fa-map-marked-alt fa-lg"></i>
                                    </span>
                                    <h3 class="fw-bold mb-0">Delivery Details</h3>
                                </div>

                                <form
                                    action="${pageContext.request.contextPath}/admin/orders/updateDeliveryInstructions"
                                    method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="orderId" value="${order.id}">

                                    <div class="mb-4">
                                        <label for="deliveryInstructions"
                                            class="form-label fw-bold text-secondary text-uppercase fs-7">Rider
                                            Instructions</label>
                                        <textarea class="zenith-input-field rounded-3" id="deliveryInstructions"
                                            name="deliveryInstructions" rows="6"
                                            placeholder="Example: Leave at front desk, code is 1234...">${order.deliveryInstructions}</textarea>
                                    </div>

                                    <div class="mb-4">
                                        <label for="deliveryImage"
                                            class="form-label fw-bold text-secondary text-uppercase fs-7">Location
                                            Image</label>
                                        <div class="p-4 border-2 border-dashed rounded-3 text-center bg-light">
                                            <i class="fas fa-cloud-upload-alt fa-2x text-gray-400 mb-2"></i>
                                            <input class="form-control" type="file" id="deliveryImage"
                                                name="deliveryImage" accept="image/*">
                                            <small class="d-block text-muted mt-2">Upload map screenshot or
                                                landmark</small>
                                        </div>
                                    </div>

                                    <button type="submit" class="btn-zenith-secondary w-100">
                                        <i class="fas fa-check me-2"></i>Save Instructions
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

            <%@ include file="/includes/footer.jsp" %>
                <script src="https://cdn.tailwindcss.com"></script>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/view-cart.css">
                <script src="${pageContext.request.contextPath}/resources/js/view-cart.js"></script>

                <script>
                    const currencySymbol = '${currencySymbol}';
                    const orderId = '${order.id}';
                </script>