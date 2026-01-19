<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!-- HEADER & SIDEBAR INCLUDED via header.jsp -->
            <%@ include file="/includes/header.jsp" %>

                <!-- External Libraries -->
                <script src="https://cdn.tailwindcss.com"></script>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

                <!-- Custom CSS -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard-zenith.css">

                <main class="main-content p-6">

                    <!-- HEADER -->
                    <div
                        class="glass-header relative z-30 rounded-xl px-6 py-4 mb-8 flex flex-col md:flex-row justify-between items-center shadow-sm">
                        <div>
                            <h1 class="text-2xl font-bold text-gray-800">Overview</h1>
                            <p class="text-sm text-gray-500 mt-1">Welcome back, Admin</p>
                        </div>

                        <div class="flex items-center gap-4 mt-4 md:mt-0">
                            <!-- Time Range Selector -->
                            <div class="dropdown relative inline-block text-left">
                                <button type="button"
                                    class="inline-flex justify-center w-full rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50"
                                    id="timeRangeMenuBtn" aria-expanded="true" aria-haspopup="true">
                                    Last 30 Days
                                    <i class="fas fa-chevron-down ml-2 -mr-1 h-5 w-5 text-gray-400"></i>
                                </button>
                                <div class="origin-top-right absolute right-0 mt-2 w-56 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 focus:outline-none hidden z-50"
                                    id="timeRangeDropdown">
                                    <div class="py-1">
                                        <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                                            onclick="setTimeRange(7, 'Last 7 Days')">Last 7 Days</a>
                                        <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                                            onclick="setTimeRange(30, 'Last 30 Days')">Last 30 Days</a>
                                        <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                                            onclick="setTimeRange(90, 'Last 90 Days')">Last 90 Days</a>
                                        <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                                            onclick="setTimeRange(365, 'Last 1 Year')">Last 1 Year</a>
                                        <div class="border-t border-gray-100 my-1"></div>
                                        <a href="#"
                                            class="block px-4 py-2 text-sm text-blue-600 hover:bg-blue-50 font-medium"
                                            onclick="openCustomDatepicker()">Custom Range</a>
                                        <input type="date" id="customDateInput" class="absolute opacity-0 w-0 h-0"
                                            style="bottom: 0; left: 0;" onchange="handleCustomDateChange(this)">
                                    </div>
                                </div>
                            </div>

                            <button
                                class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg shadow-md transition-all"
                                onclick="refreshDashboard()">
                                <i class="fas fa-sync-alt mr-2"></i> Refresh
                            </button>
                        </div>
                    </div>

                    <!-- MAIN METRICS ROW 1 -->
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                        <!-- Total Orders -->
                        <div class="glass-panel animate-enter flex items-center justify-between"
                            style="animation-delay: 0.1s;">
                            <div>
                                <p class="stat-card-title">Total Orders</p>
                                <p class="stat-card-value" id="totalOrders">${totalOrders == null ? '0' : totalOrders}
                                </p>
                            </div>
                            <div class="stat-icon bg-gradient-primary">
                                <i class="fas fa-shopping-bag"></i>
                            </div>
                        </div>
                        <!-- Total Earnings -->
                        <div class="glass-panel animate-enter flex items-center justify-between"
                            style="animation-delay: 0.2s;">
                            <div>
                                <p class="stat-card-title">Total Earnings</p>
                                <p class="stat-card-value" id="totalEarnings">${totalEarnings == null ?
                                    '₹0' : totalEarnings}</p>
                            </div>
                            <div class="stat-icon bg-gradient-success">
                                <i class="fas fa-rupee-sign"></i>
                            </div>
                        </div>
                        <!-- Refund Orders -->
                        <div class="glass-panel animate-enter flex items-center justify-between"
                            style="animation-delay: 0.3s;">
                            <div>
                                <p class="stat-card-title">Refunds</p>
                                <p class="stat-card-value" id="refundOrders">${refundOrders == null ? '0' :
                                    refundOrders}</p>
                            </div>
                            <div class="stat-icon bg-gradient-danger">
                                <i class="fas fa-exchange-alt"></i>
                            </div>
                        </div>
                        <!-- Canceled Orders -->
                        <div class="glass-panel animate-enter flex items-center justify-between"
                            style="animation-delay: 0.4s;">
                            <div>
                                <p class="stat-card-title">Canceled</p>
                                <p class="stat-card-value" id="cancelOrders">${cancelOrders == null ?
                                    '0' : cancelOrders}</p>
                            </div>
                            <div class="stat-icon bg-gradient-warning">
                                <i class="fas fa-times-circle"></i>
                            </div>
                        </div>
                    </div>

                    <!-- CHARTS ROW 1 -->
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
                        <!-- Orders Overview (Line/Bar) -->
                        <div class="glass-panel lg:col-span-2 animate-enter" style="animation-delay: 0.5s;">
                            <div class="flex justify-between items-center mb-6">
                                <h3 class="text-lg font-bold text-gray-800">Orders Overview</h3>
                                <div class="flex gap-2">
                                    <span class="w-3 h-3 rounded-full bg-blue-500"></span>
                                    <span class="text-xs text-gray-400 fw-bold">Daily Orders</span>
                                </div>
                            </div>
                            <div class="chart-container-lg">
                                <canvas id="ordersChart"></canvas>
                            </div>
                        </div>
                        <!-- Recent Activity or Pie -->
                        <div class="glass-panel animate-enter" style="animation-delay: 0.6s;">
                            <h3 class="text-lg font-bold text-gray-800 mb-6">Status Status</h3>
                            <div class="chart-container-sm flex justify-center">
                                <canvas id="ordersPieChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- RECENT ORDERS TABLE SECTION (New Zenith Table) -->
                    <div class="glass-panel mb-8 p-0 animate-enter" style="animation-delay: 0.7s; overflow: hidden;">
                        <div class="p-4 border-bottom border-light flex justify-between items-center">
                            <h3 class="text-lg font-bold text-gray-800">Recent Deliveries</h3>
                            <a href="/deliveryBoy-orders"
                                class="text-blue-600 text-sm font-bold no-underline hover:text-blue-700">View All <i
                                    class="fas fa-arrow-right ml-1"></i></a>
                        </div>
                        <div class="overflow-x-auto">
                            <table class="zenith-table">
                                <thead>
                                    <tr>
                                        <th class="ps-4">Order ID</th>
                                        <th>Customer</th>
                                        <th>Vendor</th>
                                        <th>Rider</th>
                                        <th>Status</th>
                                        <th class="text-end pe-4">Earnings</th>
                                    </tr>
                                </thead>
                                <tbody id="recentOrdersBody">
                                    <!-- Populated by JS -->
                                    <tr class="clickable-row">
                                        <td class="ps-4 fw-bold text-blue-600">#ORD-1024</td>
                                        <td class="fw-medium">Rahul Sharma</td>
                                        <td class="text-secondary small">KFC - Central Mall</td>
                                        <td class="fw-medium">Amit Kumar</td>
                                        <td><span class="zenith-badge bg-soft-success text-success">Delivered</span>
                                        </td>
                                        <td class="text-end pe-4 fw-bold text-gray-800">₹145.00</td>
                                    </tr>
                                    <tr class="clickable-row">
                                        <td class="ps-4 fw-bold text-blue-600">#ORD-1023</td>
                                        <td class="fw-medium">Sonia Gupta</td>
                                        <td class="text-secondary small">Burger King</td>
                                        <td class="fw-medium">Raju Driver</td>
                                        <td><span class="zenith-badge bg-soft-primary text-primary">In Transit</span>
                                        </td>
                                        <td class="text-end pe-4 fw-bold text-gray-800">₹120.00</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- MAIN METRICS ROW 2 (Smaller cards) -->
                    <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4 mb-8 animate-enter"
                        style="animation-delay: 0.8s;">
                        <!-- Shops -->
                        <div class="glass-panel text-center p-4">
                            <div class="text-indigo-500 text-2xl mb-2"><i class="fas fa-store"></i></div>
                            <p class="text-gray-500 text-xs font-semibold uppercase">Shops</p>
                            <p class="text-xl font-bold text-gray-800" id="totalShops">${totalShops == null ? '0' :
                                totalShops}</p>
                        </div>
                        <!-- Categories -->
                        <div class="glass-panel text-center p-4">
                            <div class="text-pink-500 text-2xl mb-2"><i class="fas fa-tags"></i></div>
                            <p class="text-gray-500 text-xs font-semibold uppercase">Categories</p>
                            <p class="text-xl font-bold text-gray-800" id="totalCategories">${totalCategories == null ?
                                '0' : totalCategories}</p>
                        </div>
                        <!-- Staff -->
                        <div class="glass-panel text-center p-4">
                            <div class="text-teal-500 text-2xl mb-2"><i class="fas fa-user-tie"></i></div>
                            <p class="text-gray-500 text-xs font-semibold uppercase">Staff</p>
                            <p class="text-xl font-bold text-gray-800" id="totalStaff">${totalStaff == null ? '0' :
                                totalStaff}</p>
                        </div>
                        <!-- Users -->
                        <div class="glass-panel text-center p-4">
                            <div class="text-purple-500 text-2xl mb-2"><i class="fas fa-users"></i></div>
                            <p class="text-gray-500 text-xs font-semibold uppercase">Total Users</p>
                            <p class="text-xl font-bold text-gray-800" id="totalUsers">${totalUsers == null ? '0' :
                                totalUsers}</p>
                        </div>
                        <!-- Reviews -->
                        <div class="glass-panel text-center p-4">
                            <div class="text-yellow-500 text-2xl mb-2"><i class="fas fa-star"></i></div>
                            <p class="text-gray-500 text-xs font-semibold uppercase">Reviews</p>
                            <p class="text-xl font-bold text-gray-800" id="totalReviews">${totalReviews == null ? '0' :
                                totalReviews}</p>
                        </div>
                        <!-- New Users -->
                        <div class="glass-panel text-center p-4">
                            <div class="text-blue-500 text-2xl mb-2"><i class="fas fa-user-plus"></i></div>
                            <p class="text-gray-500 text-xs font-semibold uppercase">New Users</p>
                            <p class="text-xl font-bold text-gray-800" id="newUsers">${newUsers == null ? '0' :
                                newUsers}</p>
                        </div>
                    </div>

                    <!-- CHARTS ROW 2 -->
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
                        <!-- Earnings Overview -->
                        <div class="glass-panel animate-enter" style="animation-delay: 0.8s;">
                            <h3 class="text-lg font-bold text-gray-800 mb-4">Earnings Overview</h3>
                            <div class="chart-container-lg">
                                <canvas id="earningsChart"></canvas>
                            </div>
                        </div>
                        <!-- User Growth -->
                        <div class="glass-panel animate-enter" style="animation-delay: 0.9s;">
                            <h3 class="text-lg font-bold text-gray-800 mb-4">User Growth</h3>
                            <div class="chart-container-lg">
                                <canvas id="usersChart"></canvas>
                            </div>
                        </div>
                    </div>

                </main>

                <%@ include file="/includes/footer.jsp" %>
                    <script src="${pageContext.request.contextPath}/resources/js/dashboard-zenith.js"></script>