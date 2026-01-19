<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Coupons | Admin Media</title>

                <!-- Dependencies -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">

                <!-- Custom CSS -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard-zenith.css">

                <!-- Tailwind CSS -->
                <script src="https://cdn.tailwindcss.com"></script>
                <script type="text/javascript">
                    tailwind.config = {
                        theme: {
                            extend: {
                                colors: {
                                    primary: '#4f46e5',
                                    secondary: '#6b7280',
                                    glass: 'rgba(255, 255, 255, 0.95)',
                                    surface: '#ffffff'
                                },
                                fontFamily: {
                                    sans: ['Inter', 'sans-serif']
                                }
                            }
                        }
                    };
                </script>
                <style>
                    .glass-card {
                        background: rgba(255, 255, 255, 0.9);
                        backdrop-filter: blur(10px);
                        border: 1px solid rgba(255, 255, 255, 0.2);
                        box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.07);
                    }

                    .coupon-card {
                        transition: all 0.3s ease;
                    }

                    .coupon-card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
                    }

                    .status-badge {
                        font-size: 0.75rem;
                        padding: 0.25rem 0.75rem;
                        border-radius: 9999px;
                        font-weight: 500;
                    }

                    .status-active {
                        background-color: #dcfce7;
                        color: #166534;
                    }

                    .status-expired {
                        background-color: #fee2e2;
                        color: #991b1b;
                    }

                    .discount-pill {
                        background: linear-gradient(135deg, #4f46e5 0%, #818cf8 100%);
                        color: white;
                    }

                    .form-control:focus {
                        border-color: #4f46e5;
                        box-shadow: 0 0 0 2px rgba(79, 70, 229, 0.1);
                    }

                    .modal-content {
                        border: none;
                        border-radius: 1rem;
                        overflow: hidden;
                    }

                    .modal-header {
                        background: #f9fafb;
                        border-bottom: 1px solid #e5e7eb;
                    }

                    .btn-primary-custom {
                        background-color: #4f46e5;
                        color: white;
                        border: none;
                        padding: 0.6rem 1.2rem;
                        border-radius: 0.5rem;
                        font-weight: 500;
                        transition: all 0.2s;
                    }

                    .btn-primary-custom:hover {
                        background-color: #4338ca;
                        color: white;
                    }

                    .action-btn {
                        width: 32px;
                        height: 32px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        border-radius: 0.375rem;
                        transition: all 0.2s;
                    }

                    .action-btn:hover {
                        background-color: #f3f4f6;
                    }
                </style>
            </head>

            <body class="bg-gray-50 text-gray-800">

                <div class="d-flex">
                    <!-- Sidebar -->
                    <%@ include file="/includes/sidebar.jsp" %>

                        <!-- Main Content -->
                        <div class="flex-grow-1" style="min-height: 100vh;">
                            <div class="main-content p-4 md:p-8">

                                <!-- Header -->
                                <div class="flex justify-between items-end mb-8 animate-enter">
                                    <div>
                                        <h1 class="text-3xl font-bold text-gray-900">Coupons</h1>
                                        <p class="text-gray-500 mt-1">Manage discounts and promotional offers</p>
                                    </div>
                                    <button onclick="openModal()"
                                        class="btn-primary-custom flex items-center gap-2 shadow-lg shadow-indigo-200">
                                        <i class="fas fa-plus"></i>
                                        <span>New Coupon</span>
                                    </button>
                                </div>

                                <!-- Messages -->
                                <c:if test="${not empty success}">
                                    <div
                                        class="alert alert-success border-0 shadow-sm mb-4 rounded-lg flex items-center gap-2">
                                        <i class="fas fa-check-circle"></i> ${success}
                                    </div>
                                </c:if>
                                <c:if test="${not empty error}">
                                    <div
                                        class="alert alert-danger border-0 shadow-sm mb-4 rounded-lg flex items-center gap-2">
                                        <i class="fas fa-exclamation-circle"></i> ${error}
                                    </div>
                                </c:if>

                                <!-- Coupon Grid -->
                                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                    <c:forEach items="${coupons}" var="coupon">
                                        <div class="glass-card rounded-xl p-6 coupon-card relative">
                                            <!-- Status -->
                                            <div class="absolute top-4 right-4">
                                                <c:choose>
                                                    <c:when test="${coupon.active}">
                                                        <span class="status-badge status-active">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-expired">Inactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <!-- Discount Code -->
                                            <div class="mb-4">
                                                <div
                                                    class="inline-block px-3 py-1 rounded-md bg-indigo-50 text-indigo-700 font-mono font-bold text-lg border border-indigo-100 mb-2">
                                                    ${coupon.code}
                                                </div>
                                                <h3 class="text-2xl font-bold text-gray-800 flex items-center gap-2">
                                                    <c:choose>
                                                        <c:when test="${coupon.discountType == 'PERCENTAGE'}">
                                                            ${coupon.discountValue}% OFF
                                                        </c:when>
                                                        <c:otherwise>
                                                            ₹${coupon.discountValue} OFF
                                                        </c:otherwise>
                                                    </c:choose>
                                                </h3>
                                                <p class="text-sm text-gray-500 mt-1">
                                                    <c:if test="${coupon.discountType == 'PERCENTAGE'}">
                                                        Up to ₹${coupon.maxDiscount}
                                                    </c:if>
                                                    <c:if test="${coupon.discountType == 'AMOUNT'}">
                                                        Flat discount
                                                    </c:if>
                                                    • Min Order ₹${coupon.minOrderValue}
                                                </p>
                                            </div>

                                            <!-- Details -->
                                            <div class="space-y-2 text-sm text-gray-600 mb-6">
                                                <div class="flex justify-between">
                                                    <span><i class="far fa-clock w-5"></i> Valid From</span>
                                                    <span class="font-medium">
                                                        <fmt:parseDate value="${coupon.validFrom}"
                                                            pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                        <fmt:formatDate pattern="dd MMM, yy" value="${parsedDate}" />
                                                    </span>
                                                </div>
                                                <div class="flex justify-between">
                                                    <span><i class="far fa-calendar-times w-5"></i> Expires</span>
                                                    <span class="font-medium">
                                                        <fmt:parseDate value="${coupon.validTill}"
                                                            pattern="yyyy-MM-dd'T'HH:mm" var="parsedTillDate"
                                                            type="both" />
                                                        <fmt:formatDate pattern="dd MMM, yy"
                                                            value="${parsedTillDate}" />
                                                    </span>
                                                </div>
                                                <div class="flex justify-between">
                                                    <span><i class="fas fa-ticket-alt w-5"></i> Usage Limit</span>
                                                    <span class="font-medium">${coupon.usageLimit}</span>
                                                </div>
                                            </div>

                                            <!-- Actions -->
                                            <div class="flex justify-between pt-4 border-t border-gray-100">

                                                <button onclick="openEditModal(this)" data-id="${coupon.id}"
                                                    data-code="${coupon.code}" data-type="${coupon.discountType}"
                                                    data-value="${coupon.discountValue}"
                                                    data-max="${coupon.maxDiscount == null ? 0 : coupon.maxDiscount}"
                                                    data-min="${coupon.minOrderValue}" data-limit="${coupon.usageLimit}"
                                                    data-from="${coupon.validFrom}" data-till="${coupon.validTill}"
                                                    data-active="${coupon.active}"
                                                    class="text-indigo-600 hover:text-indigo-800 font-medium text-sm flex items-center gap-1">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                                <button onclick="deleteCoupon('${coupon.id}')"
                                                    class="text-red-500 hover:text-red-700 font-medium text-sm flex items-center gap-1">
                                                    <i class="fas fa-trash"></i> Delete
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <!-- Empty State -->
                                    <c:if test="${empty coupons}">
                                        <div class="col-span-full py-12 text-center text-gray-400">
                                            <i class="fas fa-ticket-alt text-4xl mb-3 opacity-50"></i>
                                            <p>No coupons found. Create one to get started.</p>
                                        </div>
                                    </c:if>
                                </div>

                            </div>
                        </div>
                </div>

                <!-- Add/Edit Modal -->
                <div class="modal fade" id="couponModal" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title font-bold text-lg" id="modalTitle">Add New Coupon</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body p-6">
                                <form action="${pageContext.request.contextPath}/coupons/save" method="POST"
                                    id="couponForm">
                                    <input type="hidden" name="id" id="couponId">

                                    <div class="mb-4">
                                        <label class="block text-sm font-medium text-gray-700 mb-1">Coupon Code</label>
                                        <input type="text" name="code" id="code"
                                            class="form-control rounded-lg uppercase" placeholder="e.g. WELCOME50"
                                            required>
                                    </div>

                                    <div class="grid grid-cols-2 gap-4 mb-4">
                                        <div>
                                            <label class="block text-sm font-medium text-gray-700 mb-1">Type</label>
                                            <select name="discountType" id="discountType" class="form-select rounded-lg"
                                                onchange="toggleMaxDiscount()">
                                                <option value="PERCENTAGE">Percentage (%)</option>
                                                <option value="AMOUNT">Fixed Amount (₹)</option>
                                            </select>
                                        </div>
                                        <div>
                                            <label class="block text-sm font-medium text-gray-700 mb-1">Value</label>
                                            <input type="number" name="discountValue" id="discountValue"
                                                class="form-control rounded-lg" required>
                                        </div>
                                    </div>

                                    <div class="mb-4" id="maxDiscountField">
                                        <label class="block text-sm font-medium text-gray-700 mb-1">Max Discount
                                            (₹)</label>
                                        <input type="number" name="maxDiscount" id="maxDiscount"
                                            class="form-control rounded-lg">
                                    </div>

                                    <div class="grid grid-cols-2 gap-4 mb-4">
                                        <div>
                                            <label class="block text-sm font-medium text-gray-700 mb-1">Min Order
                                                Value</label>
                                            <input type="number" name="minOrderValue" id="minOrderValue"
                                                class="form-control rounded-lg" required>
                                        </div>
                                        <div>
                                            <label class="block text-sm font-medium text-gray-700 mb-1">Usage
                                                Limit</label>
                                            <input type="number" name="usageLimit" id="usageLimit"
                                                class="form-control rounded-lg" required>
                                        </div>
                                    </div>

                                    <div class="grid grid-cols-2 gap-4 mb-4">
                                        <div>
                                            <label class="block text-sm font-medium text-gray-700 mb-1">Valid
                                                From</label>
                                            <input type="datetime-local" name="validFrom" id="validFrom"
                                                class="form-control rounded-lg" required>
                                        </div>
                                        <div>
                                            <label class="block text-sm font-medium text-gray-700 mb-1">Valid
                                                Till</label>
                                            <input type="datetime-local" name="validTill" id="validTill"
                                                class="form-control rounded-lg" required>
                                        </div>
                                    </div>

                                    <div class="form-check form-switch mb-6">
                                        <input class="form-check-input" type="checkbox" name="active" id="active"
                                            checked>
                                        <label class="form-check-label text-sm font-medium text-gray-700"
                                            for="active">Active Status</label>
                                    </div>

                                    <div class="d-grid">
                                        <button type="submit" class="btn-primary-custom">Save Coupon</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    const modal = new bootstrap.Modal(document.getElementById('couponModal'));

                    function openModal() {
                        document.getElementById('couponForm').reset();
                        document.getElementById('couponId').value = '';
                        document.getElementById('modalTitle').innerText = 'Add New Coupon';
                        document.getElementById('active').checked = true;
                        toggleMaxDiscount();
                        modal.show();
                    }

                    function openEditModal(btn) {
                        const data = btn.dataset;

                        document.getElementById('couponId').value = data.id;
                        document.getElementById('code').value = data.code;
                        document.getElementById('discountType').value = data.type;
                        document.getElementById('discountValue').value = data.value;
                        document.getElementById('maxDiscount').value = data.max;
                        document.getElementById('minOrderValue').value = data.min;
                        document.getElementById('usageLimit').value = data.limit;
                        document.getElementById('validFrom').value = data.from;
                        document.getElementById('validTill').value = data.till;
                        document.getElementById('active').checked = data.active === 'true';

                        document.getElementById('modalTitle').innerText = 'Edit Coupon';
                        toggleMaxDiscount();
                        modal.show();
                    }

                    function toggleMaxDiscount() {
                        const type = document.getElementById('discountType').value;
                        const field = document.getElementById('maxDiscountField');
                        if (type === 'AMOUNT') {
                            field.style.display = 'none';
                        } else {
                            field.style.display = 'block';
                        }
                    }

                    function deleteCoupon(id) {
                        if (confirm('Are you sure you want to delete this coupon?')) {
                            fetch('${pageContext.request.contextPath}/coupons/delete/' + id, {
                                method: 'DELETE'
                            }).then(response => {
                                if (response.ok) {
                                    window.location.reload();
                                } else {
                                    alert('Error deleting coupon');
                                }
                            });
                        }
                    }
                </script>
            </body>

            </html>