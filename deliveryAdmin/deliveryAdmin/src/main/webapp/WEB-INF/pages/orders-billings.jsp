<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Orders Management | Zenith Admin</title>

                <!-- Tailwind CSS -->
                <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
                <!-- Font Awesome -->
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <!-- Google Fonts -->
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <!-- Custom CSS -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/orders-billings.css">

                <!-- Flatpickr (Date Picker) -->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
            </head>

            <body class="bg-gray-50 text-gray-800 antialiased">

                <div class="flex h-screen overflow-hidden">

                    <!-- Sidebar (Placeholder for now, assuming included via standard means or standalone for this demo) -->
                    <jsp:include page="/includes/sidebar.jsp" />

                    <!-- Main Content -->
                    <div class="relative flex flex-col flex-1 overflow-y-auto overflow-x-hidden">

                        <!-- Sticky Header -->
                        <header class="glass-header w-full px-8 py-4 flex justify-between items-center">
                            <div>
                                <h1
                                    class="text-2xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-indigo-600">
                                    Orders Management
                                </h1>
                                <p class="text-sm text-gray-500 mt-1">Manage and track all customer orders in real-time.
                                </p>
                            </div>

                            <div class="flex items-center space-x-4">
                                <!-- Date Filter -->
                                <div class="flex items-center gap-2 bg-white rounded-lg p-1 border border-gray-200">
                                    <button
                                        class="px-3 py-1.5 text-xs font-medium text-gray-600 hover:text-blue-600 hover:bg-blue-50 rounded transition-colors"
                                        onclick="setDateRange('today')">Today</button>
                                    <button
                                        class="px-3 py-1.5 text-xs font-medium text-gray-600 hover:text-blue-600 hover:bg-blue-50 rounded transition-colors"
                                        onclick="setDateRange('week')">This Week</button>
                                    <button
                                        class="px-3 py-1.5 text-xs font-medium text-gray-600 hover:text-blue-600 hover:bg-blue-50 rounded transition-colors"
                                        onclick="setDateRange('month')">This Month</button>
                                    <button
                                        class="px-3 py-1.5 text-xs font-medium text-gray-600 hover:text-blue-600 hover:bg-blue-50 rounded transition-colors"
                                        onclick="setDateRange('year')">This Year</button>
                                    <div class="h-4 w-px bg-gray-200 mx-1"></div>
                                    <div class="relative">
                                        <input type="text" id="dateRangePicker"
                                            class="text-sm border-none focus:ring-0 text-gray-600 w-48 pl-2"
                                            placeholder="Select Date">
                                    </div>
                                </div>

                                <!-- User Profile Dropdown (Simplified) -->
                                <div
                                    class="h-10 w-10 rounded-full bg-gradient-to-tr from-blue-500 to-purple-500 flex items-center justify-center text-white font-bold shadow-lg cursor-pointer">
                                    A
                                </div>
                            </div>
                        </header>

                        <main class="w-full h-full p-8">

                            <!-- Quick Stats -->
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8 animate-slide-up">
                                <div class="stat-card glass-panel p-6 flex items-center justify-between">
                                    <div>
                                        <p class="text-sm font-medium text-gray-500">Total Orders</p>
                                        <h3 class="text-3xl font-bold text-gray-800 mt-1" id="stat-total-orders">--</h3>
                                        <span class="text-xs text-green-500 font-medium">+12.5% vs last week</span>
                                    </div>
                                    <div class="stat-icon-wrapper bg-blue-50 text-blue-600">
                                        <i class="fas fa-shopping-bag"></i>
                                    </div>
                                </div>

                                <div class="stat-card glass-panel p-6 flex items-center justify-between">
                                    <div>
                                        <p class="text-sm font-medium text-gray-500">Pending</p>
                                        <h3 class="text-3xl font-bold text-gray-800 mt-1" id="stat-pending-orders">--
                                        </h3>
                                        <span class="text-xs text-yellow-500 font-medium">Requires Action</span>
                                    </div>
                                    <div class="stat-icon-wrapper bg-yellow-50 text-yellow-600">
                                        <i class="fas fa-clock"></i>
                                    </div>
                                </div>

                                <div class="stat-card glass-panel p-6 flex items-center justify-between">
                                    <div>
                                        <p class="text-sm font-medium text-gray-500">Delivered</p>
                                        <h3 class="text-3xl font-bold text-gray-800 mt-1" id="stat-delivered-orders">--
                                        </h3>
                                        <span class="text-xs text-gray-400 font-medium">Completed today</span>
                                    </div>
                                    <div class="stat-icon-wrapper bg-green-50 text-green-600">
                                        <i class="fas fa-check-circle"></i>
                                    </div>
                                </div>

                                <div class="stat-card glass-panel p-6 flex items-center justify-between">
                                    <div>
                                        <p class="text-sm font-medium text-gray-500">Total Revenue</p>
                                        <h3 class="text-3xl font-bold text-gray-800 mt-1" id="stat-revenue">--</h3>
                                        <span class="text-xs text-green-500 font-medium">+8.2% vs last week</span>
                                    </div>
                                    <div class="stat-icon-wrapper bg-purple-50 text-purple-600">
                                        <i class="fas fa-rupee-sign"></i>
                                    </div>
                                </div>
                            </div>

                            <!-- Main Content Panel -->
                            <div class="glass-panel p-6 animate-slide-up" style="animation-delay: 0.1s;">

                                <!-- Toolbar -->
                                <div
                                    class="flex flex-col md:flex-row justify-between items-center mb-6 space-y-4 md:space-y-0">

                                    <!-- Status Tabs -->
                                    <div class="status-tabs-container flex-1 mr-4 w-full md:w-auto">
                                        <div class="flex space-x-2" id="statusTabs">
                                            <button class="status-tab active" data-filter="ALL">All Orders</button>

                                            <!-- Pending Group -->
                                            <button class="status-tab" data-filter="PENDING_VENDOR_APPROVAL">Pending
                                                Approval</button>
                                            <button class="status-tab" data-filter="PLACED">Placed</button>

                                            <!-- Processing Group -->
                                            <button class="status-tab"
                                                data-filter="ACCEPTED_BY_VENDOR">Accepted</button>
                                            <button class="status-tab" data-filter="ORDER_PREPARING">Preparing</button>
                                            <button class="status-tab" data-filter="ORDER_READY">Ready</button>

                                            <!-- Delivery Group -->
                                            <button class="status-tab" data-filter="DELIVERY_PARTNER_ASSIGNED">Partner
                                                Assigned</button>
                                            <button class="status-tab" data-filter="ORDER_PICKED">Picked Up</button>
                                            <button class="status-tab" data-filter="ON_THE_WAY">On The Way</button>

                                            <!-- Completed Group -->
                                            <button class="status-tab" data-filter="DELIVERED">Delivered</button>
                                            <button class="status-tab" data-filter="CANCELLED">Cancelled</button>
                                        </div>
                                    </div>

                                    <!-- Search -->
                                    <div class="relative w-full md:w-64 flex-shrink-0">
                                        <input type="text" id="searchInput"
                                            class="w-full pl-10 pr-4 py-2 rounded-lg border-gray-200 bg-gray-50 focus:bg-white focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                                            placeholder="Search orders...">
                                        <i class="fas fa-search absolute left-3 top-2.5 text-gray-400"></i>
                                    </div>
                                </div>

                                <!-- Table -->
                                <div class="overflow-x-auto rounded-lg">
                                    <table class="custom-table w-full">
                                        <thead>
                                            <tr>
                                                <th>Order Info</th>
                                                <th>Status</th>
                                                <th>Customer</th>
                                                <th>Total</th>
                                                <th>Date</th>
                                                <th>Delivery</th>
                                                <th class="text-right">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody id="ordersTableBody">
                                            <!-- JS will populate this -->
                                            <tr>
                                                <td colspan="7" class="text-center py-12 text-gray-400">
                                                    <i class="fas fa-spinner fa-spin text-2xl mb-2"></i>
                                                    <p>Loading orders...</p>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Pagination (Simplified) -->
                                <div class="flex justify-between items-center mt-6">
                                    <span class="text-sm text-gray-500">Showing <span id="showingCount">0</span> of
                                        <span id="totalCount">0</span> orders</span>
                                    <div class="flex space-x-2">
                                        <button
                                            class="px-4 py-2 rounded-lg border border-gray-200 text-sm font-medium hover:bg-gray-50 disabled:opacity-50"
                                            id="prevPageBtn" disabled>Previous</button>
                                        <button
                                            class="px-4 py-2 rounded-lg bg-blue-600 text-white text-sm font-medium hover:bg-blue-700 disabled:opacity-50"
                                            id="nextPageBtn">Next</button>
                                    </div>
                                </div>
                            </div>

                        </main>
                    </div>
                </div>

                <!-- Modals -->

                <!-- Order Details Modal -->
                <div id="orderDetailsModal" class="fixed inset-0 z-50 hidden overflow-y-auto"
                    aria-labelledby="modal-title" role="dialog" aria-modal="true">
                    <div
                        class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
                        <div class="fixed inset-0 bg-gray-900 bg-opacity-60 transition-opacity modal-overlay"
                            aria-hidden="true" onclick="closeModal('orderDetailsModal')"></div>
                        <span class="hidden sm:inline-block sm:align-middle sm:h-screen"
                            aria-hidden="true">&#8203;</span>
                        <div
                            class="inline-block align-bottom bg-white rounded-2xl text-left overflow-hidden shadow-2xl transform transition-all sm:my-8 sm:align-middle sm:max-w-4xl sm:w-full">

                            <!-- Modal Header -->
                            <div
                                class="bg-gradient-to-r from-blue-600 to-indigo-700 px-6 py-4 flex justify-between items-center">
                                <div>
                                    <h3 class="text-xl font-bold text-white flex items-center">
                                        Order Details <span id="viewModalOrderCode"
                                            class="ml-2 px-3 py-1 bg-white bg-opacity-20 rounded-lg text-sm font-mono">#---</span>
                                    </h3>
                                    <p class="text-blue-100 text-sm mt-1" id="viewModalDate">---</p>
                                </div>
                                <button onclick="closeModal('orderDetailsModal')"
                                    class="text-white hover:text-gray-200 transition-colors">
                                    <i class="fas fa-times text-xl"></i>
                                </button>
                            </div>

                            <!-- Modal Body -->
                            <div class="p-6 bg-gray-50 flex flex-col md:flex-row gap-6">

                                <!-- Left Column: Items & Summary -->
                                <div class="flex-1 space-y-6">
                                    <!-- Items List -->
                                    <div class="bg-white rounded-xl shadow-sm p-4 border border-gray-100">
                                        <h4 class="font-semibold text-gray-800 mb-4 border-b pb-2">Items</h4>
                                        <div class="space-y-4" id="viewModalItems">
                                            <!-- Items injected here -->
                                        </div>
                                    </div>

                                    <!-- Payment & Totals -->
                                    <div class="bg-white rounded-xl shadow-sm p-4 border border-gray-100">
                                        <h4 class="font-semibold text-gray-800 mb-3">Bill Details</h4>
                                        <div class="space-y-2 text-sm text-gray-600">
                                            <div class="flex justify-between"><span>Item Total</span> <span
                                                    id="viewModalSubtotal">$0.00</span></div>
                                            <div class="flex justify-between"><span>Delivery Fee</span> <span
                                                    id="viewModalDelivery">$0.00</span></div>
                                            <div class="flex justify-between"><span>Taxes</span> <span
                                                    id="viewModalTax">$0.00</span></div>
                                            <div
                                                class="flex justify-between font-bold text-gray-800 pt-2 border-t mt-2 text-lg">
                                                <span>Total Amount</span> <span id="viewModalTotal"
                                                    class="text-blue-600">$0.00</span>
                                            </div>
                                        </div>
                                        <div class="mt-4 pt-3 border-t">
                                            <span class="text-xs font-semibold text-gray-500 uppercase">Payment
                                                Method</span>
                                            <p class="text-gray-800 font-medium flex items-center mt-1">
                                                <i class="far fa-credit-card mr-2 text-blue-500"></i> <span
                                                    id="viewModalPayment">Online</span>
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <!-- Right Column: Status & Info -->
                                <div class="w-full md:w-80 space-y-6">

                                    <!-- Customer Info -->
                                    <div class="bg-white rounded-xl shadow-sm p-4 border border-gray-100">
                                        <h4 class="font-semibold text-gray-800 mb-3">Customer</h4>
                                        <div class="flex items-start space-x-3">
                                            <div
                                                class="h-10 w-10 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-600 font-bold shrink-0">
                                                <i class="fas fa-user"></i>
                                            </div>
                                            <div>
                                                <p class="font-bold text-gray-800" id="viewModalCustomer">---</p>
                                                <p class="text-sm text-gray-500 mt-1" id="viewModalPhone">+1 234 567 890
                                                </p>
                                                <p class="text-xs text-gray-400 mt-1 max-w-[200px]"
                                                    id="viewModalAddress">123 Street, City</p>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Current Status -->
                                    <div class="bg-white rounded-xl shadow-sm p-4 border border-gray-100">
                                        <h4 class="font-semibold text-gray-800 mb-3">Order Status</h4>
                                        <div class="text-center py-4 bg-gray-50 rounded-lg border border-gray-100">
                                            <span id="viewModalStatusBadge" class="badge text-sm">---</span>
                                        </div>
                                    </div>

                                    <!-- Delivery Partner -->
                                    <div class="bg-white rounded-xl shadow-sm p-4 border border-gray-100">
                                        <h4 class="font-semibold text-gray-800 mb-3">Delivery Partner</h4>
                                        <div class="flex items-start space-x-3">
                                            <div
                                                class="h-10 w-10 rounded-full bg-green-100 flex items-center justify-center text-green-600 font-bold shrink-0">
                                                <i class="fas fa-biking"></i>
                                            </div>
                                            <div>
                                                <p class="font-bold text-gray-800" id="viewModalRider">Unassigned</p>
                                                <button
                                                    class="text-xs text-blue-600 font-medium hover:underline mt-1">Assign
                                                    / Change</button>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <!-- Footer -->
                            <div class="bg-gray-50 px-6 py-4 border-t flex justify-end space-x-3">
                                <button type="button"
                                    class="px-4 py-2 bg-white border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 text-sm font-medium transition-colors">
                                    <i class="fas fa-print mr-2"></i> Print Invoice
                                </button>
                                <button type="button" onclick="closeModal('orderDetailsModal')"
                                    class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 text-sm font-medium transition-colors">
                                    Close
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Edit Order Modal -->
                <div id="editOrderModal" class="fixed inset-0 z-50 hidden overflow-y-auto" aria-labelledby="modal-title"
                    role="dialog" aria-modal="true">
                    <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
                        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity modal-overlay"
                            aria-hidden="true" onclick="closeModal('editOrderModal')"></div>
                        <span class="hidden sm:inline-block sm:align-middle sm:h-screen"
                            aria-hidden="true">&#8203;</span>
                        <div
                            class="inline-block align-bottom bg-white rounded-2xl text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
                            <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                                <div class="sm:flex sm:items-start">
                                    <div
                                        class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-blue-100 sm:mx-0 sm:h-10 sm:w-10">
                                        <i class="fas fa-edit text-blue-600"></i>
                                    </div>
                                    <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left w-full">
                                        <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">Update
                                            Order Status</h3>
                                        <div class="mt-4">
                                            <p class="text-sm text-gray-500 mb-4">Update status for Order <span
                                                    id="editModalOrderCode" class="font-bold text-gray-700">#---</span>
                                            </p>

                                            <label class="block text-sm font-medium text-gray-700 mb-1">New
                                                Status</label>
                                            <select id="editStatusSelect"
                                                class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring focus:ring-blue-200 focus:ring-opacity-50 py-2 px-3 border">
                                                <option value="PENDING_VENDOR_APPROVAL">Pending Vendor Approval</option>
                                                <option value="ACCEPTED_BY_VENDOR">Accepted by Vendor</option>
                                                <option value="ORDER_PREPARING">Preparing</option>
                                                <option value="ORDER_READY">Ready</option>
                                                <option value="DELIVERY_PARTNER_ASSIGNED">Partner Assigned</option>
                                                <option value="ORDER_PICKED">Picked Up</option>
                                                <option value="ON_THE_WAY">On The Way</option>
                                                <option value="DELIVERED">Delivered</option>
                                                <option value="CANCELLED">Cancelled</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                                <button type="button" onclick="saveOrderStatus()"
                                    class="w-full inline-flex justify-center rounded-lg border border-transparent shadow-sm px-4 py-2 bg-blue-600 text-base font-medium text-white hover:bg-blue-700 sm:ml-3 sm:w-auto sm:text-sm">
                                    Update Status
                                </button>
                                <button type="button" onclick="closeModal('editOrderModal')"
                                    class="mt-3 w-full inline-flex justify-center rounded-lg border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                                    Cancel
                                </button>
                            </div>
                        </div>
                    </div>
                </div>


                <!-- Scripts -->
                <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
                <script src="${pageContext.request.contextPath}/resources/js/orders-billings.js"></script>
            </body>

            </html>