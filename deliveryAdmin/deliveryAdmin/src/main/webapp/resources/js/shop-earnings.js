document.addEventListener('DOMContentLoaded', function () {
    const API_URL = '/api/earnings'; // Replace with your actual API endpoint

    // --- DOM ELEMENT REFERENCES ---
    const statsContainer = document.getElementById('earnings-stats-container');
    const chartContainer = document.getElementById('earningsChartContainer');
    const tableBody = document.getElementById('shopsEarningsTableBody');
    const searchInput = document.getElementById('searchInput');
    const paginationInfo = document.getElementById('pagination-info');
    const paginationControls = document.getElementById('pagination-controls');
    const dropdownButton = document.getElementById('earningsDropdown').querySelector('span');
    const dropdownItems = document.querySelectorAll('.earnings-range');
    const dateRangeModal = new bootstrap.Modal(document.getElementById('dateRangeModal'));
    const applyDateRangeBtn = document.getElementById('applyDateRange');

    let earningsChart; // To hold the Chart.js instance

    // --- STATE MANAGEMENT ---
    let state = {
        timeRange: 'month', // 'today', 'week', 'month', 'year', 'custom'
        customStartDate: null,
        customEndDate: null,
        currentPage: 1,
        searchQuery: '',
    };

    // --- MOCK DATA (Replace with actual API calls) ---
    const mockApi = {
        getStats: async (range, start, end) => {
            console.log(`Fetching stats for range: ${range}`, { start, end });
            await new Promise(res => setTimeout(res, 500)); // Simulate network delay
            return {
                totalEarnings: 125400.50,
                thisMonthEarnings: 18340.75,
                thisWeekEarnings: 4560.20,
                todayEarnings: 780.00
            };
        },
        getChartData: async (range, start, end) => {
            console.log(`Fetching chart data for range: ${range}`, { start, end });
            await new Promise(res => setTimeout(res, 500));
            // Return different data based on the range for demonstration
            if (range === 'week') {
                return {
                    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                    data: [650, 590, 800, 810, 560, 550, 400]
                };
            }
            return {
                labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
                data: [4215, 5312, 4890, 3923]
            };
        },
        getShopsData: async (page, search, range, start, end) => {
            console.log(`Fetching shops for page: ${page}, search: '${search}', range: ${range}`);
            await new Promise(res => setTimeout(res, 800));
            const allShops = [
                { id: 'VID001', name: 'Green Grocers', contact: 'contact@greengrocers.com', phone: '123-456-7890', status: 'ACCEPTED', totalEarnings: 15200.50, periodEarnings: 2100.25, avatar: 'G' },
                { id: 'VID002', name: 'Fresh Farms', contact: 'info@freshfarms.net', phone: '987-654-3210', status: 'ACCEPTED', totalEarnings: 28300.00, periodEarnings: 4500.50, avatar: 'F' },
                { id: 'VID003', name: 'Daily Needs Store', contact: 'support@dailyneeds.com', phone: '555-123-4567', status: 'PENDING', totalEarnings: 5400.75, periodEarnings: 800.00, avatar: 'D' },
                { id: 'VID004', name: 'Organic World', contact: 'hello@organicworld.dev', phone: '555-987-6543', status: 'REJECTED', totalEarnings: 45000.20, periodEarnings: 6850.75, avatar: 'O' }
            ];
             const filteredShops = allShops.filter(s => s.name.toLowerCase().includes(search.toLowerCase()));
            return {
                shops: filteredShops,
                totalPages: 1,
                currentPage: 1,
                totalItems: filteredShops.length
            };
        }
    };

    // --- DATA RENDERING FUNCTIONS ---
    function renderStats(stats) {
        statsContainer.innerHTML = `
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card bg-primary text-white">
                    <div class="card-body">
                        <h6 class="mb-0">Total Earnings</h6>
                        <h3 class="mb-0">₹${stats.totalEarnings.toFixed(2)}</h3>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card bg-success text-white">
                    <div class="card-body">
                        <h6 class="mb-0">This Month</h6>
                        <h3 class="mb-0">₹${stats.thisMonthEarnings.toFixed(2)}</h3>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card bg-info text-white">
                    <div class="card-body">
                        <h6 class="mb-0">This Week</h6>
                        <h3 class="mb-0">₹${stats.thisWeekEarnings.toFixed(2)}</h3>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card bg-warning text-white">
                    <div class="card-body">
                        <h6 class="mb-0">Today</h6>
                        <h3 class="mb-0">₹${stats.todayEarnings.toFixed(2)}</h3>
                    </div>
                </div>
            </div>
        `;
    }

    function renderChart(chartData) {
        chartContainer.innerHTML = '<canvas id="earningsChart"></canvas>'; // Clear skeleton and add canvas
        const ctx = document.getElementById('earningsChart').getContext('2d');
        if (earningsChart) {
            earningsChart.destroy();
        }
        earningsChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: chartData.labels,
                datasets: [{
                    label: 'Earnings',
                    data: chartData.data,
                    backgroundColor: 'rgba(78, 115, 223, 0.05)',
                    borderColor: 'rgba(78, 115, 223, 1)',
                    pointRadius: 3,
                    pointBackgroundColor: 'rgba(78, 115, 223, 1)',
                    pointBorderColor: 'rgba(78, 115, 223, 1)',
                    pointHoverRadius: 5,
                    tension: 0.3,
                    fill: true
                }]
            },
            options: {
                maintainAspectRatio: false,
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                             callback: function(value) {
                                return '₹' + value;
                            }
                        }
                    }
                },
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return ` Earnings: ₹${context.raw.toFixed(2)}`;
                            }
                        }
                    }
                }
            }
        });
    }

    function renderTable(data) {
        if (!data.shops || data.shops.length === 0) {
            tableBody.innerHTML = `<tr><td colspan="5" class="text-center p-5">No shop earnings data found.</td></tr>`;
            return;
        }

        const statusBadges = {
            'ACCEPTED': 'bg-success-light',
            'PENDING': 'bg-warning-light',
            'REJECTED': 'bg-danger-light'
        };

        tableBody.innerHTML = data.shops.map(shop => `
            <tr>
                <td class="ps-4">
                    <div class="vendor-info">
                        <div class="vendor-avatar" style="background-color: #4e73df;">${shop.avatar}</div>
                        <div>
                            <p class="vendor-name">${shop.name}</p>
                            <span class="vendor-id">${shop.id}</span>
                        </div>
                    </div>
                </td>
                <td>
                    <div>${shop.contact}</div>
                    <small class="text-muted">${shop.phone}</small>
                </td>
                <td class="text-center status-column"><span class="badge ${statusBadges[shop.status] || 'bg-secondary-light'}">${shop.status}</span></td>
                <td class="text-end earnings-amount">₹${shop.totalEarnings.toFixed(2)}</td>
                <td class="text-end pe-4 earnings-amount text-primary">₹${shop.periodEarnings.toFixed(2)}</td>
            </tr>
        `).join('');
    }

    function renderPagination(data) {
        paginationInfo.textContent = `Showing ${data.shops.length} of ${data.totalItems} shops.`;
        // Pagination logic would be implemented here if totalPages > 1
        paginationControls.innerHTML = '';
    }

    // --- DATA FETCHING & UI UPDATE ---
    async function updateDashboard() {
        // Show skeletons while loading
        showSkeletons();

        // Fetch all data in parallel
        const [stats, chartData, shopsData] = await Promise.all([
            mockApi.getStats(state.timeRange, state.customStartDate, state.customEndDate),
            mockApi.getChartData(state.timeRange, state.customStartDate, state.customEndDate),
            mockApi.getShopsData(state.currentPage, state.searchQuery, state.timeRange, state.customStartDate, state.customEndDate)
        ]);

        // Render components with fetched data
        renderStats(stats);
        renderChart(chartData);
        renderTable(shopsData);
        renderPagination(shopsData);
    }

    function showSkeletons() {
        statsContainer.innerHTML = Array(4).fill('<div class="col-xl-3 col-md-6 mb-4"><div class="card skeleton" style="height: 120px;"></div></div>').join('');
        chartContainer.innerHTML = '<div class="skeleton w-100" style="height: 300px;"></div>';
        tableBody.innerHTML = `<tr><td colspan="5" class="text-center p-5"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></td></tr>`;
    }

    // --- EVENT LISTENERS ---
    dropdownItems.forEach(item => {
        item.addEventListener('click', function (e) {
            e.preventDefault();
            const newRange = this.dataset.range;

            if (state.timeRange !== newRange) {
                state.timeRange = newRange;
                state.customStartDate = null;
                state.customEndDate = null;
                state.currentPage = 1; // Reset to first page
                dropdownButton.textContent = this.textContent;
                dropdownItems.forEach(i => i.classList.remove('active'));
                this.classList.add('active');
                updateDashboard();
            }
        });
    });

    applyDateRangeBtn.addEventListener('click', () => {
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;

        if (startDate && endDate) {
            state.timeRange = 'custom';
            state.customStartDate = startDate;
            state.customEndDate = endDate;
            state.currentPage = 1;
            dropdownButton.textContent = `Custom`;
            dropdownItems.forEach(i => i.classList.remove('active'));
            dateRangeModal.hide();
            updateDashboard();
        } else {
            alert('Please select both a start and end date.');
        }
    });

    let searchTimeout;
    searchInput.addEventListener('input', () => {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(() => {
            state.searchQuery = searchInput.value;
            state.currentPage = 1;
            updateDashboard();
        }, 300); // Debounce for 300ms
    });

    // --- INITIAL LOAD ---
    updateDashboard();
});