<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="en_IN" />
<%@ include file="/includes/header.jsp" %>

<%-- Include dummy data --%>
<%@ include file="/pages/dummy/user-dummy.jsp" %>
<%@ include file="/pages/dummy/order-dummy.jsp" %>

<%
// Get the user ID from request parameter
String currentUserId = request.getParameter("id");

// Find the user from the dummy data
java.util.Map<String, Object> user = null;
for (java.util.Map<String, Object> u : users) {
    if (u.get("id").equals(currentUserId)) {
        user = u;
        break;
    }
}

// Get orders for this user
java.util.List<java.util.Map<String, Object>> userOrders = new java.util.ArrayList<>();
for (java.util.Map<String, Object> order : orders) {
    if (order.get("userId").equals(currentUserId)) {
        userOrders.add(order);
    }
}

pageContext.setAttribute("user", user);
pageContext.setAttribute("userOrders", userOrders);
%>

<c:if test="${empty user}">
    <div class="alert alert-danger">
        User not found!
    </div>
</c:if>

<c:if test="${not empty user}">
<main class="main-content">
    <div class="container-fluid">
        <div class="page-header py-2 d-flex justify-content-between align-items-center">
            <h1>User Details</h1>
            <div class="d-flex align-items-center">
               <a href="${pageContext.request.contextPath}/pages/user.jsp" class="btn btn-primary">
                   <i class="fas fa-arrow-left me-2"></i>Back to Users
               </a>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">User Information - ${user.id}</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 text-center">
                                <img src="${not empty user.profileImage ? pageContext.request.contextPath.concat(user.profileImage) : pageContext.request.contextPath.concat('/resources/images/default-avatar.jpg')}"
                                     class="rounded-circle mb-3" width="150" height="150" alt="${user.name}">
                                <h4>${user.name}</h4>
                                <div class="badge-div bg-${user.type == 'PREMIUM' ? 'warning' :
                                                         user.type == 'PRO' ? 'info' : 'secondary'}">
                                    ${user.type}
                                </div>
                            </div>
                            <div class="col-md-9">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Email</label>
                                            <input type="text" class="form-control" value="${user.email}" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Phone</label>
                                            <input type="text" class="form-control" value="${user.phone}" readonly>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Location</label>
                                            <input type="text" class="form-control"
                                                   value="${user.city}, ${user.country}" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Address</label>
                                            <textarea class="form-control" rows="2" readonly>${user.address}</textarea>
                                        </div>
                                    </div>
                                </div>
                                <hr>
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="stat-card bg-light p-3 rounded text-center">
                                            <h6 class="stat-title">Total Orders</h6>
                                            <h3 class="stat-value">${user.totalOrders}</h3>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="stat-card bg-light p-3 rounded text-center">
                                            <h6 class="stat-title">Total Spent</h6>
                                            <h3 class="stat-value"><fmt:formatNumber value="${user.totalSpent}" type="currency"/></h3>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="stat-card bg-light p-3 rounded text-center">
                                            <h6 class="stat-title">Last Active</h6>
                                            <h3 class="stat-value"><fmt:formatDate value="${user.lastActive}" pattern="dd MMM yyyy"/></h3>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="stat-card bg-light p-3 rounded text-center">
                                            <h6 class="stat-title">Active Days</h6>
                                            <h3 class="stat-value">${user.lastActiveDays} days</h3>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Order History Section -->
        <div class="row mt-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Order History</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty userOrders}">
                                <div class="alert alert-info">
                                    This user hasn't placed any orders yet.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Order ID</th>
                                                <th>Date</th>
                                                <th>Items</th>
                                                <th>Total</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="order" items="${userOrders}">
                                            <tr>
                                                <td>${order.orderId}</td>
                                                <td>
                                                    <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy"/>
                                                    <small class="text-muted d-block">
                                                        <fmt:formatDate value="${order.orderDate}" pattern="hh:mm a"/>
                                                    </small>
                                                </td>
                                                <td>
                                                    <c:forEach var="item" items="${order.items}" varStatus="loop">
                                                        ${item.name} (${item.quantity})<c:if test="${!loop.last}">, </c:if>
                                                    </c:forEach>
                                                </td>
                                                <td><fmt:formatNumber value="${order.totalAmount}" type="currency"/></td>
                                                <td>
                                                    <div class="badge-div bg-${order.status == 'Delivered' ? 'success' :
                                                                          order.status == 'Shipped' ? 'info' :
                                                                          order.status == 'Processing' ? 'warning' :
                                                                          order.status == 'Cancelled' ? 'danger' : 'secondary'}">
                                                        ${order.status}
                                                    </div>
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal"
                                                            data-bs-target="#orderDetailsModal"
                                                            onclick="showOrderDetails('${order.orderId}')">
                                                        <i class="fas fa-eye"></i> View
                                                    </button>
                                                </td>
                                            </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
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
                <h5 class="modal-title">Order Details - <span id="modalOrderId"></span></h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="orderDetailsContent">
                <!-- Content will be loaded dynamically -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" onclick="printOrder()">
                    <i class="fas fa-print me-2"></i>Print
                </button>
            </div>
        </div>
    </div>
</div>

<script>
function showOrderDetails(orderId) {
    // In a real application, you would fetch this data from the server
    // For demo purposes, we'll use the dummy data

    // Find the order
    let order = null;
    <c:forEach var="o" items="${userOrders}">
        if ('${o.orderId}' === orderId) {
            order = {
                orderId: '${o.orderId}',
                orderDate: '<fmt:formatDate value="${o.orderDate}" pattern="dd MMM yyyy hh:mm a"/>',
                status: '${o.status}',
                paymentMethod: '${o.paymentMethod}',
                shippingAddress: '${o.shippingAddress}',
                items: [
                    <c:forEach var="item" items="${o.items}">
                    {
                        name: '${item.name}',
                        quantity: ${item.quantity},
                        price: <fmt:formatNumber value="${item.price}" type="currency"/>,
                        total: <fmt:formatNumber value="${item.price * item.quantity}" type="currency"/>
                    },
                    </c:forEach>
                ],
                subtotal: <fmt:formatNumber value="${o.subtotal}" type="currency"/>,
                tax: <fmt:formatNumber value="${o.tax}" type="currency"/>,
                shipping: <fmt:formatNumber value="${o.shipping}" type="currency"/>,
                totalAmount: <fmt:formatNumber value="${o.totalAmount}" type="currency"/>
            };
        }
    </c:forEach>

    if (order) {
        document.getElementById('modalOrderId').textContent = order.orderId;

        let html = `
            <div class="row">
                <div class="col-md-6">
                    <h6>Order Information</h6>
                    <table class="table table-sm">
                        <tr>
                            <th>Order Date:</th>
                            <td>${order.orderDate}</td>
                        </tr>
                        <tr>
                            <th>Status:</th>
                            <td><span class="badge bg-${order.status == 'Delivered' ? 'success' :
                                                  order.status == 'Shipped' ? 'info' :
                                                  order.status == 'Processing' ? 'warning' :
                                                  order.status == 'Cancelled' ? 'danger' : 'secondary'}">
                                ${order.status}</span></td>
                        </tr>
                        <tr>
                            <th>Payment Method:</th>
                            <td>${order.paymentMethod}</td>
                        </tr>
                    </table>
                </div>
                <div class="col-md-6">
                    <h6>Shipping Address</h6>
                    <address>${order.shippingAddress}</address>
                </div>
            </div>

            <h6 class="mt-4">Order Items</h6>
            <table class="table table-sm">
                <thead>
                    <tr>
                        <th>Item</th>
                        <th>Quantity</th>
                        <th>Price</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>`;

        order.items.forEach(item => {
            html += `
                <tr>
                    <td>${item.name}</td>
                    <td>${item.quantity}</td>
                    <td>${item.price}</td>
                    <td>${item.total}</td>
                </tr>`;
        });

        html += `
                </tbody>
                <tfoot>
                    <tr>
                        <th colspan="3" class="text-end">Subtotal:</th>
                        <td>${order.subtotal}</td>
                    </tr>
                    <tr>
                        <th colspan="3" class="text-end">Tax:</th>
                        <td>${order.tax}</td>
                    </tr>
                    <tr>
                        <th colspan="3" class="text-end">Shipping:</th>
                        <td>${order.shipping}</td>
                    </tr>
                    <tr>
                        <th colspan="3" class="text-end">Total:</th>
                        <td><strong>${order.totalAmount}</strong></td>
                    </tr>
                </tfoot>
            </table>`;

        document.getElementById('orderDetailsContent').innerHTML = html;
    }
}

function printOrder() {
    // Implement print functionality
    const printContent = document.getElementById('orderDetailsContent').innerHTML;
    const originalContent = document.body.innerHTML;

    document.body.innerHTML = `
        <h2>Order #${document.getElementById('modalOrderId').textContent}</h2>
        ${printContent}
    `;

    window.print();
    document.body.innerHTML = originalContent;
    // Re-show the modal
    const modal = new bootstrap.Modal(document.getElementById('orderDetailsModal'));
    modal.show();
}
</script>
</c:if>

<%@ include file="/includes/footer.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/view-user.css">