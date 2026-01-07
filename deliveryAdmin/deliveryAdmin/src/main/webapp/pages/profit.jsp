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
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

                <!-- Custom CSS -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/profit.css">

                <main class="main-content p-6">

                    <!-- DASHBOARD HEADER -->
                    <div
                        class="glass-header rounded-xl px-6 py-4 mb-8 flex flex-col md:flex-row justify-between items-center shadow-sm">
                        <div>
                            <h1 class="text-2xl font-bold text-gray-800">Profit & Revenue Dashboard</h1>
                            <p class="text-sm text-gray-500 mt-1">Real-time financial overview</p>
                        </div>

                        <div class="flex items-center gap-4 mt-4 md:mt-0">
                            <!-- Date Filter -->
                            <div class="relative">
                                <input type="text" id="dateRangePicker"
                                    class="flatpickr-input pl-10 pr-4 py-2 w-64 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                                    placeholder="Select Date Range">
                                <i class="fas fa-calendar absolute left-3 top-3 text-gray-400"></i>
                            </div>

                            <button
                                class="bg-white hover:bg-gray-50 text-gray-700 font-medium py-2 px-4 rounded-lg border border-gray-200 shadow-sm transition-all"
                                id="printProfitBtn">
                                <i class="fas fa-print mr-2"></i> Print
                            </button>
                            <button
                                class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg shadow-md transition-all transform hover:-translate-y-0.5"
                                id="downloadProfitPdfBtn">
                                <i class="fas fa-file-arrow-down mr-2"></i> Export PDF
                            </button>
                        </div>
                    </div>

                    <div id="profitContent">
                        <!-- TOP KPI STATS -->
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                            <!-- Total Revenue -->
                            <div class="glass-panel kpi-card animate-enter" style="animation-delay: 0.1s;">
                                <span class="kpi-title">Total Revenue</span>
                                <span class="kpi-value text-blue-600" id="totalOrder">₹0</span>
                                <i class="fas fa-wallet kpi-icon text-blue-500"></i>
                                <div class="mt-4 text-xs text-green-500 font-semibold flex items-center">
                                    <i class="fas fa-arrow-up mr-1"></i> 12.5% <span
                                        class="text-gray-400 font-normal ml-1">vs last period</span>
                                </div>
                            </div>

                            <!-- Total Commission -->
                            <div class="glass-panel kpi-card animate-enter" style="animation-delay: 0.2s;">
                                <span class="kpi-title">Commission Earned</span>
                                <span class="kpi-value text-indigo-600" id="commission">₹0</span>
                                <i class="fas fa-percent kpi-icon text-indigo-500"></i>
                                <div class="mt-4 text-xs text-green-500 font-semibold flex items-center">
                                    <i class="fas fa-arrow-up mr-1"></i> 8.2% <span
                                        class="text-gray-400 font-normal ml-1">vs last period</span>
                                </div>
                            </div>

                            <!-- Pay to Vendor -->
                            <div class="glass-panel kpi-card animate-enter" style="animation-delay: 0.3s;">
                                <span class="kpi-title">Payable to Vendors</span>
                                <span class="kpi-value text-orange-600" id="payVendor">₹0</span>
                                <i class="fas fa-store kpi-icon text-orange-500"></i>
                                <div class="mt-4 text-xs text-gray-500 font-normal flex items-center">
                                    Pending Settlement
                                </div>
                            </div>

                            <!-- Net Profit -->
                            <div class="glass-panel kpi-card profit-highlight animate-enter"
                                style="animation-delay: 0.4s;">
                                <span class="kpi-title text-white">Net Profit</span>
                                <span class="kpi-value text-white" id="profit">₹0</span>
                                <i class="fas fa-chart-line kpi-icon text-white"></i>
                                <div class="mt-4 text-xs text-white font-semibold flex items-center opacity-90">
                                    <i class="fas fa-check-circle mr-1"></i> Healthy Margin
                                </div>
                            </div>
                        </div>

                        <!-- CHARTS SECTION -->
                        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
                            <!-- Main Trend Chart -->
                            <div class="glass-panel lg:col-span-2 animate-enter" style="animation-delay: 0.5s;">
                                <h3 class="text-lg font-bold text-gray-800 mb-4">Revenue vs Profit Trend</h3>
                                <div class="chart-container">
                                    <canvas id="revenueChart"></canvas>
                                </div>
                            </div>

                            <!-- Breakdown Pie Chart -->
                            <div class="glass-panel animate-enter" style="animation-delay: 0.6s;">
                                <h3 class="text-lg font-bold text-gray-800 mb-4">Revenue Breakdown</h3>
                                <div class="mini-chart-container flex justify-center">
                                    <canvas id="breakdownChart"></canvas>
                                </div>
                                <div class="mt-6 flex flex-col gap-2">
                                    <div class="flex justify-between text-sm">
                                        <span class="text-gray-500"><span
                                                class="w-2 h-2 rounded-full bg-blue-500 inline-block mr-2"></span>Platform
                                            Fees</span>
                                        <span class="font-semibold" id="piePlatform">₹0</span>
                                    </div>
                                    <div class="flex justify-between text-sm">
                                        <span class="text-gray-500"><span
                                                class="w-2 h-2 rounded-full bg-indigo-500 inline-block mr-2"></span>Service
                                            Fees</span>
                                        <span class="font-semibold" id="pieService">₹0</span>
                                    </div>
                                    <div class="flex justify-between text-sm">
                                        <span class="text-gray-500"><span
                                                class="w-2 h-2 rounded-full bg-green-500 inline-block mr-2"></span>Delivery
                                            Fees</span>
                                        <span class="font-semibold" id="pieDelivery">₹0</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- DETAILED FEES BREAKDOWN -->
                        <h3 class="text-xl font-bold text-gray-800 mb-4 animate-enter" style="animation-delay: 0.7s;">
                            Detailed Financial Breakdown</h3>
                        <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 animate-enter" style="animation-delay: 0.8s;">

                            <div
                                class="bg-white rounded-xl p-4 border border-gray-100 shadow-sm flex items-center justify-between">
                                <div>
                                    <p class="text-xs text-gray-400 uppercase font-semibold">Platform Fee</p>
                                    <p class="text-lg font-bold text-gray-800" id="platformFee">₹0</p>
                                </div>
                                <div
                                    class="h-10 w-10 rounded-full bg-blue-50 flex items-center justify-center text-blue-500">
                                    <i class="fas fa-desktop"></i>
                                </div>
                            </div>

                            <div
                                class="bg-white rounded-xl p-4 border border-gray-100 shadow-sm flex items-center justify-between">
                                <div>
                                    <p class="text-xs text-gray-400 uppercase font-semibold">Service Fee</p>
                                    <p class="text-lg font-bold text-gray-800" id="serviceFee">₹0</p>
                                </div>
                                <div
                                    class="h-10 w-10 rounded-full bg-purple-50 flex items-center justify-center text-purple-500">
                                    <i class="fas fa-concierge-bell"></i>
                                </div>
                            </div>

                            <div
                                class="bg-white rounded-xl p-4 border border-gray-100 shadow-sm flex items-center justify-between">
                                <div>
                                    <p class="text-xs text-gray-400 uppercase font-semibold">User Delivery Fee</p>
                                    <p class="text-lg font-bold text-gray-800" id="deliveryUser">₹0</p>
                                </div>
                                <div
                                    class="h-10 w-10 rounded-full bg-green-50 flex items-center justify-center text-green-500">
                                    <i class="fas fa-user"></i>
                                </div>
                            </div>

                            <div
                                class="bg-white rounded-xl p-4 border border-gray-100 shadow-sm flex items-center justify-between">
                                <div>
                                    <p class="text-xs text-gray-400 uppercase font-semibold">Partner Payments</p>
                                    <p class="text-lg font-bold text-gray-800" id="deliveryPartner">₹0</p>
                                </div>
                                <div
                                    class="h-10 w-10 rounded-full bg-red-50 flex items-center justify-center text-red-500">
                                    <i class="fas fa-motorcycle"></i>
                                </div>
                            </div>

                            <div
                                class="bg-white rounded-xl p-4 border border-gray-100 shadow-sm flex items-center justify-between">
                                <div>
                                    <p class="text-xs text-gray-400 uppercase font-semibold">GST Collected</p>
                                    <p class="text-lg font-bold text-gray-800" id="gst">₹0</p>
                                </div>
                                <div
                                    class="h-10 w-10 rounded-full bg-yellow-50 flex items-center justify-center text-yellow-500">
                                    <i class="fas fa-file-invoice-dollar"></i>
                                </div>
                            </div>

                            <div
                                class="bg-white rounded-xl p-4 border border-gray-100 shadow-sm flex items-center justify-between">
                                <div>
                                    <p class="text-xs text-gray-400 uppercase font-semibold">Rain Fees</p>
                                    <p class="text-lg font-bold text-gray-800" id="rainFee">₹0</p>
                                </div>
                                <div
                                    class="h-10 w-10 rounded-full bg-blue-50 flex items-center justify-center text-blue-400">
                                    <i class="fas fa-cloud-rain"></i>
                                </div>
                            </div>
                            <div
                                class="bg-white rounded-xl p-4 border border-gray-100 shadow-sm flex items-center justify-between">
                                <div>
                                    <p class="text-xs text-gray-400 uppercase font-semibold">Packaging Fees</p>
                                    <p class="text-lg font-bold text-gray-800" id="packagingFee">₹0</p>
                                </div>
                                <div
                                    class="h-10 w-10 rounded-full bg-orange-50 flex items-center justify-center text-orange-400">
                                    <i class="fas fa-box"></i>
                                </div>
                            </div>

                        </div>

                    </div>
                </main>

                <!-- SCRIPTS -->
                <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
                <script src="${pageContext.request.contextPath}/resources/js/profit.js"></script>

                <%@ include file="/includes/footer.jsp" %>