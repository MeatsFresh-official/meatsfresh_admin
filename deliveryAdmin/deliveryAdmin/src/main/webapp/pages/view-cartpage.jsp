<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/header.jsp" %>

<main class="main-content">
    <div class="container-fluid px-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="pt-2">ViewCart Page</h1>
        </div>

        <div class="row">
            <div class="col-lg-12">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Adjust Order Charges</h5>
                    </div>
                    <div class="card-body">
                        <form id="chargesForm" action="${pageContext.request.contextPath}/admin/orders/updateCharges" method="post">
                            <input type="hidden" name="orderId" value="${order.id}">

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="card card-toggle mb-3">
                                        <div class="card-body">
                                            <div class="form-check form-switch mb-3">
                                                <input class="form-check-input charge-toggle" type="checkbox" id="toggleDeliveryFee"
                                                       name="deliveryFeeEnabled" ${order.deliveryFee > 0 ? 'checked' : ''}>
                                                <label class="form-check-label fw-medium" for="toggleDeliveryFee">Delivery Fee</label>
                                            </div>
                                            <div class="input-group ${order.deliveryFee <= 0 ? 'd-none' : ''}" id="deliveryFeeGroup">
                                                <span class="input-group-text">${currencySymbol}</span>
                                                <input type="number" class="form-control" name="deliveryFee"
                                                       value="${order.deliveryFee > 0 ? order.deliveryFee : ''}" step="0.01" min="0">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card card-toggle mb-3">
                                        <div class="card-body">
                                            <div class="form-check form-switch mb-3">
                                                <input class="form-check-input charge-toggle" type="checkbox" id="toggleReinFee"
                                                       name="reinFeeEnabled" ${order.reinFee > 0 ? 'checked' : ''}>
                                                <label class="form-check-label fw-medium" for="toggleReinFee">Rein Fee</label>
                                            </div>
                                            <div class="input-group ${order.reinFee <= 0 ? 'd-none' : ''}" id="reinFeeGroup">
                                                <span class="input-group-text">${currencySymbol}</span>
                                                <input type="number" class="form-control" name="reinFee"
                                                       value="${order.reinFee > 0 ? order.reinFee : ''}" step="0.01" min="0">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="card card-toggle mb-3">
                                        <div class="card-body">
                                            <div class="form-check form-switch mb-3">
                                                <input class="form-check-input charge-toggle" type="checkbox" id="togglePlatformFee"
                                                       name="platformFeeEnabled" ${order.platformFee > 0 ? 'checked' : ''}>
                                                <label class="form-check-label fw-medium" for="togglePlatformFee">Platform Fee</label>
                                            </div>
                                            <div class="input-group ${order.platformFee <= 0 ? 'd-none' : ''}" id="platformFeeGroup">
                                                <span class="input-group-text">${currencySymbol}</span>
                                                <input type="number" class="form-control" name="platformFee"
                                                       value="${order.platformFee > 0 ? order.platformFee : ''}" step="0.01" min="0">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Custom Fees Section -->
                            <div class="card">
                                <div class="card-header bg-light d-flex justify-content-between align-items-center">
                                    <h6 class="mb-0">Custom Fees</h6>
                                    <button type="button" id="addCustomFee" class="btn btn-sm btn-outline-primary">
                                        <i class="fas fa-plus me-1"></i>Add Custom Fee
                                    </button>
                                </div>
                                <div class="card-body">
                                    <div id="customFeesContainer">
                                        <c:forEach items="${order.customFees}" var="customFee" varStatus="loop">
                                            <div class="input-group mb-2 custom-fee-entry">
                                                <input type="text" class="form-control" name="customFeeNames"
                                                       value="${customFee.name}" placeholder="Fee name" required>
                                                <span class="input-group-text">${currencySymbol}</span>
                                                <input type="number" class="form-control" name="customFeeValues"
                                                       value="${customFee.value}" step="0.01" min="0" required>
                                                <button type="button" class="btn btn-danger remove-custom-fee">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>

                            <div class="d-grid gap-2 mt-4">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Update Charges
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- New Delivery Instructions Card -->
        <div class="row">
            <div class="col-lg-12">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Delivery Instructions</h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/orders/updateDeliveryInstructions" method="post" enctype="multipart/form-data">
                             <input type="hidden" name="orderId" value="${order.id}">
                            <div class="mb-3">
                                <label for="deliveryInstructions" class="form-label">Instructions</label>
                                <textarea class="form-control" id="deliveryInstructions" name="deliveryInstructions" rows="4" placeholder="Enter any special delivery instructions...">${order.deliveryInstructions}</textarea>
                            </div>
                            <div class="mb-3">
                                <label for="deliveryImage" class="form-label">Upload Image</label>
                                <input class="form-control" type="file" id="deliveryImage" name="deliveryImage" accept="image/*">
                                <small class="form-text text-muted">You can upload an image (e.g., a map or a specific location) to help the driver.</small>
                            </div>
                             <button type="submit" class="btn btn-secondary">
                                <i class="fas fa-save me-2"></i>Save Instructions
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/includes/footer.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/view-cartpage.css">
<script src="${pageContext.request.contextPath}/resources/js/view-cartpage.js"></script>

<script>
// Define global variables that will be used in the external JS
const currencySymbol = '${currencySymbol}';
const orderId = '${order.id}';
</script>