<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/includes/header.jsp" %>

        <!-- Tailwind CSS & Fonts -->
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">
        <!-- Alpine.js for interactions (optional but good for UI state) -->
        <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>

        <style>
            /* Custom Scrollbar */
            ::-webkit-scrollbar {
                width: 6px;
                height: 6px;
            }

            ::-webkit-scrollbar-track {
                background: transparent;
            }

            ::-webkit-scrollbar-thumb {
                background: #cbd5e1;
                border-radius: 3px;
            }

            ::-webkit-scrollbar-thumb:hover {
                background: #94a3b8;
            }

            body {
                font-family: 'Inter', sans-serif;
                background-color: #f8fafc;
                /* Slate-50 */
                color: #0f172a;
                /* Slate-900 */
            }

            /* Card Utilities */
            .card-base {
                background: #ffffff;
                border: 1px solid #e2e8f0;
                /* Slate-200 */
                border-radius: 12px;
                box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
                transition: all 0.2s ease-in-out;
            }

            .card-base:hover {
                box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
                border-color: #cbd5e1;
                /* Slate-300 */
            }

            /* Stat Card Specifics */
            .stat-icon-wrapper {
                width: 48px;
                height: 48px;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.25rem;
            }

            /* Table Styles */
            .table-row-hover:hover {
                background-color: #f8fafc;
            }

            /* Animation Utilities */
            .fade-in {
                animation: fadeIn 0.4s ease-out forwards;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(10px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Skeleton Loading */
            .skeleton {
                background: linear-gradient(90deg, #f1f5f9 25%, #e2e8f0 50%, #f1f5f9 75%);
                background-size: 200% 100%;
                animation: shimmer 1.5s infinite;
                border-radius: 6px;
            }

            @keyframes shimmer {
                0% {
                    background-position: 200% 0;
                }

                100% {
                    background-position: -200% 0;
                }
            }

            /* Custom Input Focus */
            .input-focus:focus {
                outline: none;
                border-color: #6366f1;
                /* Indigo-500 */
                box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            }
        </style>

        <main class="main-content min-h-screen pb-12">
            <div class="max-w-[1600px] mx-auto px-4 sm:px-6 lg:px-8 pt-8">

                <!-- Header Section -->
                <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4 fade-in">
                    <div>
                        <h1 class="text-2xl font-bold text-slate-900 tracking-tight">Shop Earnings</h1>
                        <p class="text-slate-500 text-sm mt-1">Monitor revenue streams and vendor performance.</p>
                    </div>
                    <div class="flex items-center gap-3">
                        <button
                            class="inline-flex items-center px-4 py-2 bg-white border border-slate-300 rounded-lg text-sm font-medium text-slate-700 hover:bg-slate-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors shadow-sm">
                            <i class="fas fa-download mr-2 text-slate-400"></i> Export
                        </button>
                        <div class="relative dropdown">
                            <button
                                class="inline-flex items-center px-4 py-2 bg-indigo-600 border border-transparent rounded-lg text-sm font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors shadow-sm dropdown-toggle"
                                type="button" id="mainDateDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="far fa-calendar-alt mr-2"></i>
                                <span id="earningsDropdownLabel">This Month</span>
                                <i class="fas fa-chevron-down ml-2 text-xs opacity-80"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow-lg rounded-lg border border-slate-100 py-1"
                                aria-labelledby="mainDateDropdown">
                                <li><a class="dropdown-item px-4 py-2 text-sm text-slate-700 hover:bg-indigo-50 hover:text-indigo-700 earnings-range flex items-center gap-2"
                                        href="#" data-range="today"><span>Today</span></a></li>
                                <li><a class="dropdown-item px-4 py-2 text-sm text-slate-700 hover:bg-indigo-50 hover:text-indigo-700 earnings-range flex items-center gap-2"
                                        href="#" data-range="week"><span>Last 7 Days</span></a></li>
                                <li><a class="dropdown-item px-4 py-2 text-sm text-slate-700 hover:bg-indigo-50 hover:text-indigo-700 earnings-range active flex items-center gap-2"
                                        href="#" data-range="month"><span>This Month</span></a></li>
                                <li><a class="dropdown-item px-4 py-2 text-sm text-slate-700 hover:bg-indigo-50 hover:text-indigo-700 earnings-range flex items-center gap-2"
                                        href="#" data-range="year"><span>This Year</span></a></li>
                                <li>
                                    <hr class="dropdown-divider my-1 border-slate-100">
                                </li>
                                <li><a class="dropdown-item px-4 py-2 text-sm text-indigo-600 font-medium hover:bg-indigo-50 earnings-range"
                                        href="#" data-bs-toggle="modal" data-bs-target="#dateRangeModal">Custom
                                        Range...</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Stats Grid -->
                <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-6 mb-8" id="earnings-stats-container">
                    <!-- Stats will be injected by JS here -->
                </div>

                <!-- content grid: Chart + Table -->
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">

                    <!-- Earnings Over Time Chart -->
                    <div class="lg:col-span-2 card-base p-6 fade-in" style="animation-delay: 0.1s;">
                        <div class="flex items-center justify-between mb-6">
                            <h2 class="text-base font-semibold text-slate-800">Earnings Overview</h2>
                            <span
                                class="text-xs font-medium text-emerald-600 bg-emerald-50 px-2 py-1 rounded-full">+12.5%
                                vs last period</span>
                        </div>
                        <div class="relative h-[350px] w-full" id="earningsChartContainer">
                            <!-- Chart canvas -->
                            <div class="skeleton h-full w-full rounded-lg"></div>
                        </div>
                    </div>

                    <!-- Top Performing or Summary (Placeholder for now, or maybe the list fits here?) -->
                    <!-- Let's put the List below instead for full width, and maybe use this space for something else or make chart full width -->
                    <!-- For this design, I'll make the Chart full width or 2/3 and maybe a small donut chart? -->
                    <!-- I'll stick to a 2/3 1/3 split or full width. JS expects 1 chart. Let's make chart full width for now if no secondary widget. -->
                    <!-- Actually, I'll keep the grid and make the second column a "Quick Actions" or "Recent Activity" placeholder or just make chart full width. -->
                    <!-- Decision: Chart takes full row for better visibility. -->
                    <div class="lg:col-span-3 card-base p-6 fade-in" style="animation-delay: 0.15s;">
                        <div class="flex items-center justify-between mb-6">
                            <h2 class="text-base font-semibold text-slate-800">Earnings Analysis</h2>
                            <div class="flex gap-2">
                                <!-- Legend or toggles could go here -->
                                <span class="flex items-center text-xs text-slate-500"><span
                                        class="w-2 h-2 rounded-full bg-indigo-500 mr-1"></span> Revenue</span>
                            </div>
                        </div>
                        <div class="relative h-[400px] w-full" id="earningsChartContainerWrapper">
                            <!-- JS will target #earningsChartContainer. I will wrap it to be safe or re-use ID. -->
                            <!-- JS targets 'earningsChartContainer' innerHTML. So I'll put that ID on a div inside. -->
                            <div id="earningsChartContainer" class="h-full w-full">
                                <div class="skeleton h-full w-full rounded-lg"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Shop Table Section -->
                <div class="card-base overflow-hidden fade-in" style="animation-delay: 0.2s;">
                    <div
                        class="px-6 py-4 border-b border-slate-100 flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white">
                        <h2 class="text-base font-semibold text-slate-800">Vendor Performance</h2>
                        <div class="relative max-w-sm w-full">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-search text-slate-400 text-sm"></i>
                            </div>
                            <input type="text" id="searchInput"
                                class="block w-full pl-10 pr-3 py-2 border border-slate-300 rounded-lg leading-5 bg-white placeholder-slate-400 focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm transition duration-150 ease-in-out"
                                placeholder="Search shops by name, ID or email...">
                        </div>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-slate-200">
                            <thead class="bg-slate-50">
                                <tr>
                                    <th scope="col"
                                        class="px-6 py-3 text-left text-xs font-semibold text-slate-500 uppercase tracking-wider">
                                        Vendor</th>
                                    <th scope="col"
                                        class="px-6 py-3 text-left text-xs font-semibold text-slate-500 uppercase tracking-wider">
                                        Contact</th>
                                    <th scope="col"
                                        class="px-6 py-3 text-center text-xs font-semibold text-slate-500 uppercase tracking-wider">
                                        Status</th>
                                    <th scope="col"
                                        class="px-6 py-3 text-right text-xs font-semibold text-slate-500 uppercase tracking-wider">
                                        Total Earnings</th>
                                    <th scope="col"
                                        class="px-6 py-3 text-right text-xs font-semibold text-slate-500 uppercase tracking-wider">
                                        Current Period</th>
                                </tr>
                            </thead>
                            <tbody id="shopsEarningsTableBody" class="bg-white divide-y divide-slate-200">
                                <!-- Rows injected by JS -->
                                <tr>
                                    <td colspan="5" class="px-6 py-12 text-center">
                                        <div class="flex justify-center">
                                            <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-600">
                                            </div>
                                        </div>
                                        <p class="mt-2 text-sm text-slate-500">Loading data...</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="bg-white px-6 py-4 border-t border-slate-100 flex items-center justify-between">
                        <span class="text-sm text-slate-500" id="pagination-info">Showing 0 results</span>
                        <nav class="flex z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination"
                            id="pagination-controls">
                            <!-- Pagination injected by JS -->
                        </nav>
                    </div>
                </div>

            </div>
        </main>

        <!-- Modern Modal -->
        <div class="modal fade" id="dateRangeModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-xl rounded-xl overflow-hidden">
                    <div class="modal-header bg-slate-50 border-b border-slate-100 px-6 py-4">
                        <h5 class="text-base font-semibold text-slate-900">Select Date Range</h5>
                        <button type="button" class="btn-close text-xs" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-6 bg-white">
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label for="startDate" class="block text-sm font-medium text-slate-700 mb-1">Start
                                    Date</label>
                                <input type="date"
                                    class="block w-full px-3 py-2 border border-slate-300 rounded-lg shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm text-slate-900 input-focus"
                                    id="startDate">
                            </div>
                            <div>
                                <label for="endDate" class="block text-sm font-medium text-slate-700 mb-1">End
                                    Date</label>
                                <input type="date"
                                    class="block w-full px-3 py-2 border border-slate-300 rounded-lg shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm text-slate-900 input-focus"
                                    id="endDate">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer bg-slate-50 border-t border-slate-100 px-6 py-3">
                        <button type="button"
                            class="px-4 py-2 border border-slate-300 rounded-lg text-sm font-medium text-slate-700 hover:bg-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors"
                            data-bs-dismiss="modal">Cancel</button>
                        <button type="button"
                            class="px-4 py-2 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors"
                            id="applyDateRange">Apply Range</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Note: Footer includes scripts -->
        <%@ include file="/includes/footer.jsp" %>
            <script src="${pageContext.request.contextPath}/resources/js/shop-earnings.js"></script>