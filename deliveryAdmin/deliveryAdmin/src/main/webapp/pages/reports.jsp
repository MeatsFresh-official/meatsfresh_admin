<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

                <!-- HEADER & SIDEBAR INCLUDED via header.jsp -->
                <%@ include file="/includes/header.jsp" %>

                    <!-- External Libraries -->
                    <script src="https://cdn.tailwindcss.com"></script>
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                    <!-- Custom CSS -->
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reports.css">

                    <main class="main-content p-6">

                        <!-- DASHBOARD HEADER -->
                        <div
                            class="glass-header rounded-xl px-6 py-4 mb-8 flex flex-col md:flex-row justify-between items-center shadow-sm">
                            <div>
                                <h1 class="text-2xl font-bold text-gray-800">Business Reports</h1>
                                <p class="text-sm text-gray-500 mt-1">Comprehensive data view</p>
                            </div>

                            <div class="flex items-center gap-4 mt-4 md:mt-0">
                                <!-- Search -->
                                <div class="relative">
                                    <input type="text" id="searchInput"
                                        class="pl-10 pr-4 py-2 bg-white border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 w-64 shadow-sm"
                                        placeholder="Search reports...">
                                    <i class="fas fa-search absolute left-3 top-2.5 text-gray-400"></i>
                                </div>

                                <button
                                    class="bg-indigo-600 hover:bg-indigo-700 text-white font-medium py-2 px-4 rounded-lg shadow-md transition-all flex items-center"
                                    id="downloadPdfBtn">
                                    <i class="fas fa-file-pdf mr-2"></i> Export PDF
                                </button>
                            </div>
                        </div>

                        <!-- TABS -->
                        <div class="report-tabs">
                            <div class="report-tab active" onclick="switchTab('users')">Users</div>
                            <div class="report-tab" onclick="switchTab('vendors')">Vendors</div>
                            <div class="report-tab" onclick="switchTab('deliveries')">Delivery Partners</div>
                        </div>

                        <!-- CONTENT SECTIONS -->
                        <div id="reportsContent">

                            <!-- USERS TABLE -->
                            <div id="usersSection" class="glass-panel animate-fade-in">
                                <h3 class="text-lg font-bold text-gray-800 mb-4 px-4 pt-2">Registered Users</h3>
                                <div class="overflow-x-auto">
                                    <table class="custom-table w-full">
                                        <thead>
                                            <tr>
                                                <th>User ID</th>
                                                <th>Name</th>
                                                <th>Email</th>
                                                <th>Role</th>
                                                <th>Status</th>
                                                <th>Reg. Date</th>
                                            </tr>
                                        </thead>
                                        <tbody id="usersTableBody">
                                            <!-- JS Insert -->
                                        </tbody>
                                    </table>
                                </div>
                                <!-- Pagination Placeholder -->
                                <div class="p-4 border-t border-gray-100 flex justify-end">
                                    <span class="text-sm text-gray-500" id="usersCount">Showing 0 users</span>
                                </div>
                            </div>

                            <!-- VENDORS TABLE -->
                            <div id="vendorsSection" class="glass-panel animate-fade-in hidden">
                                <h3 class="text-lg font-bold text-gray-800 mb-4 px-4 pt-2">Active Vendors</h3>
                                <div class="overflow-x-auto">
                                    <table class="custom-table w-full">
                                        <thead>
                                            <tr>
                                                <th>Vendor ID</th>
                                                <th>Store Name</th>
                                                <th>Owner</th>
                                                <th>Rating</th>
                                                <th>Status</th>
                                                <th>Joined</th>
                                            </tr>
                                        </thead>
                                        <tbody id="vendorsTableBody">
                                            <!-- JS Insert -->
                                        </tbody>
                                    </table>
                                </div>
                                <div class="p-4 border-t border-gray-100 flex justify-end">
                                    <span class="text-sm text-gray-500" id="vendorsCount">Showing 0 vendors</span>
                                </div>
                            </div>

                            <!-- DELIVERIES TABLE -->
                            <div id="deliveriesSection" class="glass-panel animate-fade-in hidden">
                                <h3 class="text-lg font-bold text-gray-800 mb-4 px-4 pt-2">Delivery Partner Performance
                                </h3>
                                <div class="overflow-x-auto">
                                    <table class="custom-table w-full">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Name</th>
                                                <th>Deliveries</th>
                                                <th>Rating</th>
                                                <th>Status</th>
                                                <th>Vehicle</th>
                                            </tr>
                                        </thead>
                                        <tbody id="deliveriesTableBody">
                                            <!-- JS Insert -->
                                        </tbody>
                                    </table>
                                </div>
                                <div class="p-4 border-t border-gray-100 flex justify-end">
                                    <span class="text-sm text-gray-500" id="deliveriesCount">Showing 0 partners</span>
                                </div>
                            </div>

                        </div>

                    </main>

                    <!-- SCRIPTS -->
                    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js"></script>
                    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
                    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
                    <script src="${pageContext.request.contextPath}/resources/js/reports.js"></script>

                    <%@ include file="/includes/footer.jsp" %>