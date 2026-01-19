<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <%@ include file="/includes/header.jsp" %>

                <!-- External Libraries (Chart.js & Flatpickr) -->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

                <!-- Custom CSS -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/profit.css">

                <main class="main-content">
                    <div class="container-fluid px-4 pt-4">

                        <!-- DASHBOARD HEADER -->
                        <div class="d-flex justify-content-between align-items-center mb-5 fade-in-up">
                            <div>
                                <h1 class="fw-bold text-dark mb-1">Profit & Revenue Dashboard</h1>
                                <p class="text-muted small">Real-time financial overview and reports</p>
                            </div>

                            <div class="d-flex gap-2">
                                <!-- Date Filter -->
                                <div class="input-group" style="width: 250px;">
                                    <span class="input-group-text bg-white"><i
                                            class="fas fa-calendar-alt text-primary"></i></span>
                                    <input type="text" id="dateRangePicker" class="form-control"
                                        placeholder="Select Date Range">
                                </div>

                                <div class="btn-group">
                                    <button class="btn btn-white border shadow-sm" id="printProfitBtn">
                                        <i class="fas fa-print me-2 text-muted"></i> Print
                                    </button>
                                    <button class="btn btn-zenith-primary shadow-sm" id="downloadProfitPdfBtn">
                                        <i class="fas fa-file-download me-2"></i> Export PDF
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div id="profitContent">
                            <!-- TOP KPI STATS -->
                            <div class="row g-4 mb-4">
                                <!-- Total Revenue -->
                                <div class="col-md-6 col-lg-3 animate-enter" style="animation-delay: 0.1s;">
                                    <div class="glass-panel kpi-card h-100 p-4">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <h6 class="kpi-title mb-2">Total Revenue</h6>
                                                <h2 class="kpi-value text-primary mb-0" id="totalOrder">₹0</h2>
                                            </div>
                                            <div class="icon-circle bg-primary-light text-primary">
                                                <i class="fas fa-wallet"></i>
                                            </div>
                                        </div>
                                        <div class="mt-3 text-success small fw-bold">
                                            <i class="fas fa-arrow-up me-1"></i> 12.5% <span
                                                class="text-muted fw-normal ms-1">vs last period</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Total Commission -->
                                <div class="col-md-6 col-lg-3 animate-enter" style="animation-delay: 0.2s;">
                                    <div class="glass-panel kpi-card h-100 p-4">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <h6 class="kpi-title mb-2">Commission Earned</h6>
                                                <h2 class="kpi-value text-indigo mb-0" id="commission">₹0</h2>
                                            </div>
                                            <div class="icon-circle bg-indigo-light text-indigo">
                                                <i class="fas fa-percent"></i>
                                            </div>
                                        </div>
                                        <div class="mt-3 text-success small fw-bold">
                                            <i class="fas fa-arrow-up me-1"></i> 8.2% <span
                                                class="text-muted fw-normal ms-1">vs last period</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Pay to Vendor -->
                                <div class="col-md-6 col-lg-3 animate-enter" style="animation-delay: 0.3s;">
                                    <div class="glass-panel kpi-card h-100 p-4">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <h6 class="kpi-title mb-2">Payable to Vendors</h6>
                                                <h2 class="kpi-value text-warning mb-0" id="payVendor">₹0</h2>
                                            </div>
                                            <div class="icon-circle bg-warning-light text-warning">
                                                <i class="fas fa-store"></i>
                                            </div>
                                        </div>
                                        <div class="mt-3 text-muted small">
                                            Pending Settlement
                                        </div>
                                    </div>
                                </div>

                                <!-- Net Profit -->
                                <div class="col-md-6 col-lg-3 animate-enter" style="animation-delay: 0.4s;">
                                    <div class="glass-panel kpi-card profit-highlight h-100 p-4 text-white">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <h6 class="kpi-title text-white-50 mb-2">Net Profit</h6>
                                                <h2 class="kpi-value text-white mb-0" id="profit">₹0</h2>
                                            </div>
                                            <div class="icon-circle bg-white text-success bg-opacity-25">
                                                <i class="fas fa-chart-line text-white"></i>
                                            </div>
                                        </div>
                                        <div class="mt-3 text-white small opacity-75">
                                            <i class="fas fa-check-circle me-1"></i> Healthy Margin
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- CHARTS SECTION -->
                            <div class="row g-4 mb-5">
                                <!-- Main Trend Chart -->
                                <div class="col-lg-8 animate-enter" style="animation-delay: 0.5s;">
                                    <div class="glass-panel p-4 h-100">
                                        <h5 class="fw-bold mb-4 text-dark">Revenue vs Profit Trend</h5>
                                        <div class="chart-container" style="position: relative; height: 350px;">
                                            <canvas id="revenueChart"></canvas>
                                        </div>
                                    </div>
                                </div>

                                <!-- Breakdown Pie Chart -->
                                <div class="col-lg-4 animate-enter" style="animation-delay: 0.6s;">
                                    <div class="glass-panel p-4 h-100">
                                        <h5 class="fw-bold mb-4 text-dark">Revenue Breakdown</h5>
                                        <div class="mini-chart-container d-flex justify-content-center"
                                            style="position: relative; height: 250px;">
                                            <canvas id="breakdownChart"></canvas>
                                        </div>
                                        <div class="mt-4 d-flex flex-column gap-2">
                                            <div class="d-flex justify-content-between small">
                                                <span class="text-muted"><i
                                                        class="fas fa-circle text-primary me-2"></i>Platform Fees</span>
                                                <span class="fw-bold" id="piePlatform">₹0</span>
                                            </div>
                                            <div class="d-flex justify-content-between small">
                                                <span class="text-muted"><i
                                                        class="fas fa-circle text-indigo me-2"></i>Service Fees</span>
                                                <span class="fw-bold" id="pieService">₹0</span>
                                            </div>
                                            <div class="d-flex justify-content-between small">
                                                <span class="text-muted"><i
                                                        class="fas fa-circle text-success me-2"></i>Delivery Fees</span>
                                                <span class="fw-bold" id="pieDelivery">₹0</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- DETAILED FEES BREAKDOWN -->
                            <div class="mb-5 animate-enter" style="animation-delay: 0.7s;">
                                <h5 class="fw-bold text-dark mb-3">Detailed Financial Breakdown</h5>
                                <div class="row g-3">
                                    <div class="col-md-3">
                                        <div
                                            class="bg-white rounded-3 p-3 border shadow-sm d-flex justify-content-between align-items-center">
                                            <div>
                                                <small class="text-muted text-uppercase fw-bold"
                                                    style="font-size: 0.7rem;">Platform Fee</small>
                                                <h5 class="mb-0 fw-bold text-dark" id="platformFee">₹0</h5>
                                            </div>
                                            <div class="icon-circle-sm bg-primary-light text-primary"><i
                                                    class="fas fa-desktop"></i></div>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div
                                            class="bg-white rounded-3 p-3 border shadow-sm d-flex justify-content-between align-items-center">
                                            <div>
                                                <small class="text-muted text-uppercase fw-bold"
                                                    style="font-size: 0.7rem;">Service Fee</small>
                                                <h5 class="mb-0 fw-bold text-dark" id="serviceFee">₹0</h5>
                                            </div>
                                            <div class="icon-circle-sm bg-indigo-light text-indigo"><i
                                                    class="fas fa-concierge-bell"></i></div>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div
                                            class="bg-white rounded-3 p-3 border shadow-sm d-flex justify-content-between align-items-center">
                                            <div>
                                                <small class="text-muted text-uppercase fw-bold"
                                                    style="font-size: 0.7rem;">User Delivery</small>
                                                <h5 class="mb-0 fw-bold text-dark" id="deliveryUser">₹0</h5>
                                            </div>
                                            <div class="icon-circle-sm bg-success-light text-success"><i
                                                    class="fas fa-user-tag"></i></div>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div
                                            class="bg-white rounded-3 p-3 border shadow-sm d-flex justify-content-between align-items-center">
                                            <div>
                                                <small class="text-muted text-uppercase fw-bold"
                                                    style="font-size: 0.7rem;">Partner Pay</small>
                                                <h5 class="mb-0 fw-bold text-dark" id="deliveryPartner">₹0</h5>
                                            </div>
                                            <div class="icon-circle-sm bg-danger-light text-danger"><i
                                                    class="fas fa-motorcycle"></i></div>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div
                                            class="bg-white rounded-3 p-3 border shadow-sm d-flex justify-content-between align-items-center">
                                            <div>
                                                <small class="text-muted text-uppercase fw-bold"
                                                    style="font-size: 0.7rem;">GST Collected</small>
                                                <h5 class="mb-0 fw-bold text-dark" id="gst">₹0</h5>
                                            </div>
                                            <div class="icon-circle-sm bg-warning-light text-warning"><i
                                                    class="fas fa-file-invoice-dollar"></i></div>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div
                                            class="bg-white rounded-3 p-3 border shadow-sm d-flex justify-content-between align-items-center">
                                            <div>
                                                <small class="text-muted text-uppercase fw-bold"
                                                    style="font-size: 0.7rem;">Rain Fees</small>
                                                <h5 class="mb-0 fw-bold text-dark" id="rainFee">₹0</h5>
                                            </div>
                                            <div class="icon-circle-sm bg-info-light text-info"><i
                                                    class="fas fa-cloud-rain"></i></div>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div
                                            class="bg-white rounded-3 p-3 border shadow-sm d-flex justify-content-between align-items-center">
                                            <div>
                                                <small class="text-muted text-uppercase fw-bold"
                                                    style="font-size: 0.7rem;">Packaging</small>
                                                <h5 class="mb-0 fw-bold text-dark" id="packagingFee">₹0</h5>
                                            </div>
                                            <div class="icon-circle-sm bg-secondary-light text-secondary"><i
                                                    class="fas fa-box"></i></div>
                                        </div>
                                    </div>
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