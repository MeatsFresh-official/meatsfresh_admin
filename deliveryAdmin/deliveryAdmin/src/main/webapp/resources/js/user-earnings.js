document.addEventListener('DOMContentLoaded', () => {
    // --- DOM ELEMENT REFERENCES ---
    const statsContainer = document.getElementById('analytics-stats-container');
    const loadingIndicator = document.getElementById('loadingIndicator');
    const dropdownButtonText = document.getElementById('dateRangeDropdown').querySelector('span');
    const dateRangeModal = new bootstrap.Modal(document.getElementById('dateRangeModal'));
    const revenueChartCtx = document.getElementById('revenueChart').getContext('2d');
    const orderStatusChartCtx = document.getElementById('orderStatusChart').getContext('2d');

    // --- STATE MANAGEMENT ---
    let state = {
        timeRange: 'month',
        customStartDate: null,
        customEndDate: null,
    };

    let chartInstances = {
        revenueChart: null,
        orderStatusChart: null,
    };

    // --- MOCK API (Replace with your actual API endpoints) ---
    const mockApi = {
        getStats: async (range) => {
            console.log(`Fetching stats for range: ${range}`);
            await new Promise(res => setTimeout(res, 500)); // Simulate network delay
            return {
                totalRevenue: 540350.75,
                periodRevenue: 45210.50,
                totalOrders: 1840,
                avgOrderValue: 293.67,
            };
        },
        getChartData: async (range) => {
            console.log(`Fetching chart data for range: ${range}`);
            await new Promise(res => setTimeout(res, 800)); // Simulate network delay
            // This data would dynamically change based on the 'range' in a real app
            return {
                revenueTrend: {
                    labels: ['Wk 1', 'Wk 2', 'Wk 3', 'Wk 4', 'Wk 5', 'Wk 6', 'Wk 7', 'Wk 8'],
                    data: [12000, 19000, 15000, 24000, 22000, 30000, 28000, 35000],
                },
                orderStatus: {
                    labels: ['Completed', 'Pending', 'Cancelled', 'Returned'],
                    data: [1250, 210, 85, 30],
                },
            };
        }
    };

    // --- DATA RENDERING FUNCTIONS ---
    const renderStats = (stats) => {
        const formatCurrency = (value) => `₹${value.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;

        statsContainer.innerHTML = `
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-start border-primary border-4 h-100">
                    <div class="card-body">
                        <div class="text-xs fw-bold text-primary text-uppercase mb-1">Total Lifetime Revenue</div>
                        <div class="h5 mb-0 fw-bold text-gray-800">${formatCurrency(stats.totalRevenue)}</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-start border-success border-4 h-100">
                    <div class="card-body">
                        <div class="text-xs fw-bold text-success text-uppercase mb-1">Revenue (${dropdownButtonText.textContent})</div>
                        <div class="h5 mb-0 fw-bold text-gray-800">${formatCurrency(stats.periodRevenue)}</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-start border-info border-4 h-100">
                    <div class="card-body">
                        <div class="text-xs fw-bold text-info text-uppercase mb-1">Total Orders</div>
                        <div class="h5 mb-0 fw-bold text-gray-800">${stats.totalOrders.toLocaleString('en-IN')}</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-start border-warning border-4 h-100">
                    <div class="card-body">
                        <div class="text-xs fw-bold text-warning text-uppercase mb-1">Average Order Value</div>
                        <div class="h5 mb-0 fw-bold text-gray-800">${formatCurrency(stats.avgOrderValue)}</div>
                    </div>
                </div>
            </div>
        `;
    };

    const renderCharts = (chartData) => {
        // Destroy existing chart instances before creating new ones to prevent conflicts
        if (chartInstances.revenueChart) chartInstances.revenueChart.destroy();
        if (chartInstances.orderStatusChart) chartInstances.orderStatusChart.destroy();

        // Revenue Line Chart
        chartInstances.revenueChart = new Chart(revenueChartCtx, {
            type: 'line',
            data: {
                labels: chartData.revenueTrend.labels,
                datasets: [{
                    label: 'Revenue',
                    data: chartData.revenueTrend.data,
                    borderColor: '#4e73df',
                    backgroundColor: 'rgba(78, 115, 223, 0.05)',
                    fill: true,
                    tension: 0.3,
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: { beginAtZero: true, ticks: { callback: (value) => `₹${value / 1000}k` } }
                },
                plugins: { legend: { display: false } }
            }
        });

        // Order Status Doughnut Chart
        chartInstances.orderStatusChart = new Chart(orderStatusChartCtx, {
            type: 'doughnut',
            data: {
                labels: chartData.orderStatus.labels,
                datasets: [{
                    data: chartData.orderStatus.data,
                    backgroundColor: ['#1cc88a', '#f6c23e', '#e74a3b', '#858796'],
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'bottom' } },
                cutout: '80%'
            }
        });
    };

    // --- MAIN DATA FETCH & UI UPDATE ---
    const updateDashboard = async () => {
        loadingIndicator.classList.remove('d-none');
        statsContainer.innerHTML = ''; // Clear stats for loading effect

        try {
            // Fetch all data in parallel
            const [statsData, chartData] = await Promise.all([
                mockApi.getStats(state.timeRange),
                mockApi.getChartData(state.timeRange)
            ]);

            renderStats(statsData);
            renderCharts(chartData);
        } catch (error) {
            console.error("Failed to update dashboard:", error);
            statsContainer.innerHTML = `<div class="col-12"><div class="alert alert-danger">Failed to load analytics data. Please try again later.</div></div>`;
        } finally {
            loadingIndicator.classList.add('d-none');
        }
    };

    // --- EVENT LISTENERS ---
    document.querySelectorAll('.date-range-option').forEach(item => {
        item.addEventListener('click', (e) => {
            e.preventDefault();
            const newRange = e.target.dataset.range;
            if (state.timeRange !== newRange) {
                state.timeRange = newRange;
                state.customStartDate = null;
                state.customEndDate = null;
                dropdownButtonText.textContent = e.target.textContent;
                document.querySelectorAll('.date-range-option').forEach(i => i.classList.remove('active'));
                e.target.classList.add('active');
                updateDashboard();
            }
        });
    });

    document.getElementById('applyDateRangeBtn').addEventListener('click', () => {
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;
        if (startDate && endDate) {
            state.timeRange = 'custom';
            state.customStartDate = startDate;
            state.customEndDate = endDate;
            dropdownButtonText.textContent = `${startDate} to ${endDate}`;
            document.querySelectorAll('.date-range-option').forEach(i => i.classList.remove('active'));
            dateRangeModal.hide();
            updateDashboard();
        } else {
            alert('Please select both a start and end date.');
        }
    });

    document.getElementById('resetFiltersBtn').addEventListener('click', () => {
        state.timeRange = 'month';
        state.customStartDate = null;
        state.customEndDate = null;
        dropdownButtonText.textContent = 'This Month';
        document.querySelectorAll('.date-range-option').forEach(i => i.classList.remove('active'));
        document.querySelector('.date-range-option[data-range="month"]').classList.add('active');
        updateDashboard();
    });

    // --- INITIAL LOAD ---
    updateDashboard();
});