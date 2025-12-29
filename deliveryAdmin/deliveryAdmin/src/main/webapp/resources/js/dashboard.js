/**
 * @file This script manages the interactive dashboard, including handling date range filtering,
 * fetching data from the server, and updating statistical cards and charts.
 * @author Sai Manikanta/MeatsFresh
 * @version 1.0
 */

document.addEventListener("DOMContentLoaded", function () {
    // ===================================================================================
    // INITIALIZATION & CONFIGURATION
    // ===================================================================================

    const config = {
        csrfToken: document.querySelector("meta[name='_csrf']").getAttribute("content"),
        csrfHeader: document.querySelector("meta[name='_csrf_header']").getAttribute("content"),
        timeRangeBtn: document.getElementById("globalTimeRange"),
        timeRangeItems: document.querySelectorAll(".global-time-range"),
        applyDateRangeBtn: document.getElementById("applyDateRange"),
        loadingSpinner: document.getElementById("loadingSpinner"),
        dashboardContent: document.getElementById("dashboardContent"),
        dateRangeModal: document.getElementById("dateRangeModal"),
        statsApi: `${contextPath}/api/dashboard/stats`,
        ordersChartApi: `${contextPath}/api/dashboard/orders-chart`,
        ordersDistributionApi: `${contextPath}/api/dashboard/orders-distribution`,
        earningsChartApi: `${contextPath}/api/dashboard/earnings-chart`,
        userGrowthChartApi: `${contextPath}/api/dashboard/user-growth-chart`,
        ordersChartCtx: document.getElementById("ordersChart").getContext("2d"),
        ordersPieChartCtx: document.getElementById("ordersPieChart").getContext("2d"),
        earningsChartCtx: document.getElementById("earningsChart").getContext("2d"),
        usersChartCtx: document.getElementById("usersChart").getContext("2d"),
    };

    const state = {
        currentDateRange: { preset: "30" },
        previousDateRange: { preset: "60" },
        charts: {}
    };

    // ===================================================================================
    // CORE LOGIC
    // ===================================================================================

    function initializeDashboard() {
        toggleLoading(true);
        setupEventListeners();
        initializeAllCharts();
        updateDashboardData(state.currentDateRange, state.previousDateRange);
    }

    function toggleLoading(isLoading) {
        config.loadingSpinner.style.display = isLoading ? 'flex' : 'none';
        config.dashboardContent.style.display = isLoading ? 'none' : 'block';
    }

    // ===================================================================================
    // EVENT LISTENERS
    // ===================================================================================

    function setupEventListeners() {
        config.timeRangeItems.forEach(item => {
            item.addEventListener("click", handlePresetTimeRangeSelect);
        });
        config.applyDateRangeBtn.addEventListener("click", handleCustomDateRangeApply);
    }

    function handlePresetTimeRangeSelect(e) {
        e.preventDefault();
        const selectedItem = e.currentTarget;
        const range = selectedItem.dataset.range;
        const label = selectedItem.textContent.trim();
        config.timeRangeBtn.innerHTML = `<i class="fas fa-clock me-1"></i> ${label}`;
        state.previousDateRange = { ...state.currentDateRange };
        state.currentDateRange = { preset: range };
        updateDashboardData(state.currentDateRange, state.previousDateRange);
    }

    function handleCustomDateRangeApply() {
        const startDate = document.getElementById("startDate").value;
        const endDate = document.getElementById("endDate").value;
        if (!startDate || !endDate || new Date(startDate) > new Date(endDate)) {
            alert("Please select a valid date range.");
            return;
        }
        const rangeLabel = `${formatDate(startDate)} to ${formatDate(endDate)}`;
        config.timeRangeBtn.innerHTML = `<i class="fas fa-clock me-1"></i> ${rangeLabel}`;
        bootstrap.Modal.getInstance(config.dateRangeModal).hide();
        state.previousDateRange = { ...state.currentDateRange };
        state.currentDateRange = { startDate, endDate };
        updateDashboardData(state.currentDateRange, state.previousDateRange);
    }

    // ===================================================================================
    // DATA FETCHING & UI UPDATES
    // ===================================================================================

    function updateDashboardData(dateRange, previousRange) {
        toggleLoading(true);
        const promises = [
            fetchStats(dateRange, previousRange),
            updateAllCharts(dateRange)
        ];
        Promise.allSettled(promises).finally(() => {
            toggleLoading(false);
        });
    }

    function fetchStats(dateRange, previousRange) {
        return fetchApiData(config.statsApi, dateRange)
            .then(currentStats => {
                if (!currentStats) return;
                updateStatsUI(currentStats);
                if (previousRange) {
                    return fetchApiData(config.statsApi, previousRange)
                        .then(previousStats => {
                            if (previousStats) updateTrendIndicators(currentStats, previousStats);
                        });
                }
            })
            .catch(error => console.error('Error fetching stats:', error));
    }

    function updateStatsUI(stats) {
        document.getElementById("totalOrders").textContent = formatNumber(stats.totalOrders);
        document.getElementById("totalEarnings").textContent = formatCurrency(stats.totalEarnings);
        document.getElementById("refundOrders").textContent = formatNumber(stats.refundOrders);
        document.getElementById("cancelOrders").textContent = formatNumber(stats.cancelOrders);
        document.getElementById("totalShops").textContent = formatNumber(stats.totalShops);
        document.getElementById("totalCategories").textContent = formatNumber(stats.totalCategories);
        document.getElementById("totalStaff").textContent = formatNumber(stats.totalStaff);
        document.getElementById("totalUsers").textContent = formatNumber(stats.totalUsers);
        document.getElementById("totalReviews").textContent = formatNumber(stats.totalReviews);
        document.getElementById("newUsers").textContent = formatNumber(stats.newUsers);
    }

    // ===================================================================================
    // TREND INDICATOR LOGIC
    // ===================================================================================

    function updateTrendIndicators(currentStats, previousStats) {
        const trends = {
            totalOrdersTrend: calculatePercentageChange(previousStats.totalOrders, currentStats.totalOrders),
            totalEarningsTrend: calculatePercentageChange(previousStats.totalEarnings, currentStats.totalEarnings),
            refundOrdersTrend: calculatePercentageChange(previousStats.refundOrders, currentStats.refundOrders),
            cancelOrdersTrend: calculatePercentageChange(previousStats.cancelOrders, currentStats.cancelOrders),
        };
        for (const [elementId, change] of Object.entries(trends)) {
            updateTrendElement(elementId, change);
        }
    }

    function calculatePercentageChange(previous, current) {
        if (previous === 0) return current > 0 ? 100 : 0;
        return ((current - previous) / previous) * 100;
    }

    function updateTrendElement(elementId, change) {
        const element = document.getElementById(elementId);
        if (!element) return;
        let icon, text, colorClass;
        if (change > 0) {
            icon = 'fas fa-arrow-up';
            text = `${change.toFixed(1)}% from previous period`;
            colorClass = 'text-success';
        } else if (change < 0) {
            icon = 'fas fa-arrow-down';
            text = `${Math.abs(change).toFixed(1)}% from previous period`;
            colorClass = 'text-danger';
        } else {
            icon = 'fas fa-minus';
            text = `No change from previous period`;
            colorClass = 'text-secondary';
        }
        element.innerHTML = `<i class="${icon} ${colorClass}"></i> ${text}`;
    }

    // ===================================================================================
    // CHARTING
    // ===================================================================================

    function initializeAllCharts() {
        state.charts.orders = new Chart(config.ordersChartCtx, { type: "line", data: { labels: [], datasets: [{ label: "Orders", data: [], backgroundColor: "rgba(54, 162, 235, 0.2)", borderColor: "rgba(54, 162, 235, 1)", borderWidth: 2, tension: 0.3, fill: true }] }, options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero: true, ticks: { precision: 0 } } } } });
        state.charts.ordersPie = new Chart(config.ordersPieChartCtx, { type: "pie", data: { labels: [], datasets: [{ data: [], backgroundColor: ["#4CAF50", "#F44336", "#FFC107", "#2196F3", "#9C27B0"] }] }, options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'right' } } } });
        state.charts.earnings = new Chart(config.earningsChartCtx, { type: "bar", data: { labels: [], datasets: [{ label: "Earnings (₹)", data: [], backgroundColor: "rgba(75, 192, 192, 0.6)", borderColor: "rgba(75, 192, 192, 1)", borderWidth: 1 }] }, options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero: true, ticks: { callback: (value) => '₹' + value.toLocaleString() } } } } });
        state.charts.users = new Chart(config.usersChartCtx, { type: "line", data: { labels: [], datasets: [{ label: "New Users", data: [], backgroundColor: "rgba(153, 102, 255, 0.2)", borderColor: "rgba(153, 102, 255, 1)", borderWidth: 2, tension: 0.4, fill: true }] }, options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero: true, ticks: { precision: 0 } } } } });
    }

    function updateAllCharts(dateRange) {
        const promises = [
            updateChart(state.charts.orders, config.ordersChartApi, dateRange),
            updateChart(state.charts.ordersPie, config.ordersDistributionApi, dateRange),
            updateChart(state.charts.earnings, config.earningsChartApi, dateRange),
            updateChart(state.charts.users, config.userGrowthChartApi, dateRange)
        ];
        return Promise.all(promises);
    }

    function updateChart(chart, url, dateRange) {
        return fetchApiData(url, dateRange)
            .then(chartData => {
                if (chartData && chartData.labels && chartData.values) {
                    chart.data.labels = chartData.labels;
                    chart.data.datasets[0].data = chartData.values;
                } else {
                    chart.data.labels = ['Data unavailable'];
                    chart.data.datasets[0].data = [];
                }
                chart.update();
            })
            .catch(error => {
                console.error(`Error fetching data for chart from ${url}:`, error);
                chart.data.labels = ['Data unavailable'];
                chart.data.datasets[0].data = [];
                chart.update();
            });
    }

    // ===================================================================================
    // UTILITY & HELPER FUNCTIONS
    // ===================================================================================

    async function fetchApiData(url, body) {
        const response = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', [config.csrfHeader]: config.csrfToken },
            body: JSON.stringify(body)
        });
        if (!response.ok) {
            throw new Error(`API request failed with status ${response.status}`);
        }
        return response.json();
    }

    function formatNumber(num) {
        if (num == null) return '0';
        if (num >= 1000000) return (num / 1000000).toFixed(1).replace(/\.0$/, '') + 'M';
        if (num >= 1000) return (num / 1000).toFixed(1).replace(/\.0$/, '') + 'k';
        return num.toString();
    }

    function formatCurrency(amount) {
        if (amount == null) return '₹0';
        if (amount >= 10000000) return '₹' + (amount / 10000000).toFixed(1).replace(/\.0$/, '') + 'Cr';
        if (amount >= 100000) return '₹' + (amount / 100000).toFixed(1).replace(/\.0$/, '') + 'L';
        if (amount >= 1000) return '₹' + (amount / 1000).toFixed(1).replace(/\.0$/, '') + 'k';
        return '₹' + amount.toLocaleString('en-IN');
    }

    function formatDate(dateString) {
        const date = new Date(dateString);
        return date.toLocaleDateDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric', timeZone: 'UTC' });
    }

    // ===================================================================================
    // SCRIPT EXECUTION
    // ===================================================================================

    initializeDashboard();
});