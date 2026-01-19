document.addEventListener('DOMContentLoaded', function () {
    const API_URL = '/api/earnings';

    // --- DOM ELEMENT REFERENCES ---
    const statsContainer = document.getElementById('earnings-stats-container');
    const chartContainer = document.getElementById('earningsChartContainer');
    const tableBody = document.getElementById('shopsEarningsTableBody');
    const searchInput = document.getElementById('searchInput');
    const paginationInfo = document.getElementById('pagination-info');
    const paginationControls = document.getElementById('pagination-controls');
    const dropdownButton = document.getElementById('earningsDropdownLabel');
    const dropdownItems = document.querySelectorAll('.earnings-range');
    const dateRangeModalElement = document.getElementById('dateRangeModal');
    const dateRangeModal = dateRangeModalElement ? new bootstrap.Modal(dateRangeModalElement) : null;
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

    // --- MOCK DATA ---
    const mockApi = {
        getStats: async (range) => {
            // No delay
            const variance = Math.random() * 0.1 + 0.95;
            return {
                totalEarnings: 1254320.50 * variance,
                thisMonthEarnings: 148340.75 * variance,
                thisWeekEarnings: 42560.20 * variance,
                todayEarnings: 7890.00 * variance
            };
        },
        getChartData: async (range) => {
            // No delay
            if (range === 'today') {
                return {
                    labels: ['12 AM', '4 AM', '8 AM', '12 PM', '4 PM', '8 PM'],
                    data: [120, 80, 450, 1200, 1500, 1100]
                };
            }
            if (range === 'week') {
                return {
                    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                    data: [12500, 15900, 18000, 18100, 25600, 29500, 24000]
                };
            }
            if (range === 'year') {
                return {
                    labels: ['Jan', 'Mar', 'May', 'Jul', 'Sep', 'Nov'],
                    data: [120000, 128000, 155000, 158000, 185000, 210000]
                };
            }
            // Month default
            return {
                labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
                data: [42150, 53120, 48900, 69230]
            };
        },
        getShopsData: async (page, search, range) => {
            // No delay
            const allShops = [
                { id: 'SHP-001', name: 'Fresh Choice Market', contact: 'john@freshchoice.com', phone: '+91 98765 43210', status: 'ACCEPTED', totalEarnings: 452000.50, periodEarnings: 45000.00 },
                { id: 'SHP-002', name: 'Organic Greens', contact: 'sarah@organicgreens.com', phone: '+91 98765 12345', status: 'ACCEPTED', totalEarnings: 328000.00, periodEarnings: 32000.50 },
                { id: 'SHP-003', name: 'Meats & More', contact: 'support@meatsmore.com', phone: '+91 99887 76655', status: 'PENDING', totalEarnings: 12500.75, periodEarnings: 1200.00 },
                { id: 'SHP-004', name: 'Daily Essentials', contact: 'contact@dailyessentials.net', phone: '+91 88776 65544', status: 'REJECTED', totalEarnings: 0.00, periodEarnings: 0.00 },
                { id: 'SHP-005', name: 'Gourmet Basket', contact: 'info@gourmetbasket.com', phone: '+91 77665 54433', status: 'ACCEPTED', totalEarnings: 156000.25, periodEarnings: 15600.00 },
                { id: 'SHP-006', name: 'City Supermarket', contact: 'manager@citysuper.com', phone: '+91 66554 43322', status: 'ACCEPTED', totalEarnings: 895000.00, periodEarnings: 95000.00 },
                { id: 'SHP-007', name: 'Corner Store', contact: 'hello@cornerstore.in', phone: '+91 55443 32211', status: 'ACCEPTED', totalEarnings: 56000.30, periodEarnings: 5600.00 },
                { id: 'SHP-008', name: 'Vegan Delight', contact: 'vegan@delight.com', phone: '+91 44332 21100', status: 'PENDING', totalEarnings: 23000.90, periodEarnings: 2300.90 },
                { id: 'SHP-009', name: 'Baker\'s Dozen', contact: 'orders@baker.com', phone: '+91 33221 10099', status: 'ACCEPTED', totalEarnings: 112000.50, periodEarnings: 11200.50 },
                { id: 'SHP-010', name: 'Spice Route', contact: 'spices@route.com', phone: '+91 22110 09988', status: 'ACCEPTED', totalEarnings: 78000.00, periodEarnings: 7800.00 }
            ];

            const term = search ? search.toLowerCase() : '';
            const filtered = allShops.filter(s =>
                s.name.toLowerCase().includes(term) ||
                s.contact.toLowerCase().includes(term)
            );

            return {
                shops: filtered,
                totalItems: filtered.length
            };
        }
    };

    // --- RENDERING ---
    function renderStats(stats) {
        if (!statsContainer) return;
        const items = [
            { label: 'Total Earnings', val: stats.totalEarnings, color: 'text-indigo-600', bg: 'bg-indigo-50', icon: 'fa-rupee-sign' },
            { label: 'This Month', val: stats.thisMonthEarnings, color: 'text-emerald-600', bg: 'bg-emerald-50', icon: 'fa-calendar-alt' },
            { label: 'This Week', val: stats.thisWeekEarnings, color: 'text-blue-600', bg: 'bg-blue-50', icon: 'fa-chart-line' },
            { label: 'Today', val: stats.todayEarnings, color: 'text-amber-600', bg: 'bg-amber-50', icon: 'fa-clock' }
        ];

        statsContainer.innerHTML = items.map(i => `
            <div class="card-base p-6 fade-in">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-slate-500 mb-1">${i.label}</p>
                        <h3 class="text-2xl font-bold text-slate-900 tracking-tight">₹${i.val.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</h3>
                    </div>
                    <div class="stat-icon-wrapper ${i.bg} ${i.color}">
                        <i class="fas ${i.icon}"></i>
                    </div>
                </div>
            </div>
        `).join('');
    }

    function renderChart(chartData) {
        if (!chartContainer) return;
        chartContainer.innerHTML = '<canvas id="earningsChart"></canvas>';
        const ctx = document.getElementById('earningsChart').getContext('2d');
        if (earningsChart) earningsChart.destroy();

        const gradient = ctx.createLinearGradient(0, 0, 0, 300);
        gradient.addColorStop(0, 'rgba(99, 102, 241, 0.2)');
        gradient.addColorStop(1, 'rgba(99, 102, 241, 0)');

        earningsChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: chartData.labels,
                datasets: [{
                    label: 'Earnings',
                    data: chartData.data,
                    backgroundColor: gradient,
                    borderColor: '#6366f1',
                    borderWidth: 2,
                    pointBackgroundColor: '#ffffff',
                    pointBorderColor: '#6366f1',
                    pointBorderWidth: 2,
                    pointRadius: 4,
                    pointHoverRadius: 6,
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                maintainAspectRatio: false,
                responsive: true,
                interaction: { mode: 'index', intersect: false },
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: '#1e293b',
                        titleColor: '#f8fafc',
                        bodyColor: '#f8fafc',
                        borderColor: '#334155',
                        borderWidth: 1,
                        padding: 10,
                        displayColors: false,
                        callbacks: {
                            label: (ctx) => ` Revenue: ₹${ctx.raw.toLocaleString('en-IN')}`
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: { color: '#f1f5f9', drawBorder: false },
                        ticks: {
                            font: { family: "'Inter', sans-serif", size: 11 },
                            color: '#64748b',
                            callback: (val) => '₹' + val.toLocaleString('en-IN', { notation: "compact" })
                        }
                    },
                    x: {
                        grid: { display: false },
                        ticks: { font: { family: "'Inter', sans-serif", size: 11 }, color: '#64748b' }
                    }
                }
            }
        });
    }

    function renderTable(data) {
        if (!tableBody) return;
        if (!data.shops || data.shops.length === 0) {
            tableBody.innerHTML = `<tr><td colspan="5" class="px-6 py-12 text-center text-slate-500 italic">No shop earnings data found.</td></tr>`;
            return;
        }

        const statusConfig = {
            'ACCEPTED': { class: 'bg-emerald-100 text-emerald-800', label: 'Active', icon: 'fa-check-circle' },
            'PENDING': { class: 'bg-amber-100 text-amber-800', label: 'Pending', icon: 'fa-clock' },
            'REJECTED': { class: 'bg-rose-100 text-rose-800', label: 'Inactive', icon: 'fa-times-circle' }
        };

        tableBody.innerHTML = data.shops.map(shop => {
            const status = statusConfig[shop.status] || { class: 'bg-slate-100 text-slate-800', label: shop.status, icon: 'fa-info-circle' };
            const initials = shop.name.split(' ').map(n => n[0]).join('').substring(0, 2).toUpperCase();
            return `
            <tr class="hover:bg-slate-50 transition-colors duration-150">
                <td class="px-6 py-4 whitespace-nowrap">
                    <div class="flex items-center">
                        <div class="flex-shrink-0 h-10 w-10">
                            <div class="h-10 w-10 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-700 font-bold text-sm">${initials}</div>
                        </div>
                        <div class="ml-4">
                            <div class="text-sm font-medium text-slate-900">${shop.name}</div>
                            <div class="text-xs text-slate-500 font-mono">${shop.id}</div>
                        </div>
                    </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                    <div class="text-sm text-slate-900">${shop.contact}</div>
                    <div class="text-sm text-slate-500">${shop.phone}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-center">
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${status.class}">
                        <i class="fas ${status.icon} mr-1.5"></i> ${status.label}
                    </span>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-right text-sm text-slate-900 font-semibold">
                    ₹${shop.totalEarnings.toLocaleString('en-IN', { minimumFractionDigits: 2 })}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-right text-sm text-indigo-600 font-medium">
                    +₹${shop.periodEarnings.toLocaleString('en-IN', { minimumFractionDigits: 2 })}
                </td>
            </tr>
            `;
        }).join('');
    }

    function renderPagination(data) {
        if (!paginationInfo || !paginationControls) return;
        paginationInfo.textContent = `Showing ${data.shops.length} entries`;
        // Simplified
        paginationControls.innerHTML = `
            <span class="relative inline-flex items-center px-2 py-2 rounded-md border border-slate-300 bg-white text-sm font-medium text-slate-500">
                1
            </span>
        `;
    }

    function showSkeletons() {
        if (statsContainer) statsContainer.innerHTML = Array(4).fill('<div class="card-base p-6"><div class="animate-pulse flex space-x-4"><div class="flex-1 space-y-4 py-1"><div class="h-4 bg-slate-200 rounded w-3/4"></div><div class="h-8 bg-slate-200 rounded"></div></div><div class="rounded-full bg-slate-200 h-12 w-12"></div></div></div>').join('');
        if (chartContainer) chartContainer.innerHTML = '<div class="animate-pulse bg-slate-200 h-full w-full rounded-lg"></div>';
        if (tableBody) tableBody.innerHTML = Array(5).fill('<tr><td colspan="5" class="px-6 py-4"><div class="animate-pulse h-4 bg-slate-200 rounded w-full"></div></td></tr>').join('');
    }

    async function updateDashboard() {
        showSkeletons();
        try {
            const [stats, chartData, shopsData] = await Promise.all([
                mockApi.getStats(state.timeRange),
                mockApi.getChartData(state.timeRange),
                mockApi.getShopsData(state.currentPage, state.searchQuery, state.timeRange)
            ]);
            renderStats(stats);
            renderChart(chartData);
            renderTable(shopsData);
            renderPagination(shopsData);
        } catch (error) {
            console.error("Dashboard error:", error);
            if (tableBody) tableBody.innerHTML = `<tr><td colspan="5" class="text-center text-red-500 p-4">Error loading data. Check console.</td></tr>`;
        }
    }

    // --- LISTENERS ---
    dropdownItems.forEach(item => {
        item.addEventListener('click', (e) => {
            e.preventDefault();
            const range = item.dataset.range;
            if (state.timeRange !== range) {
                state.timeRange = range;
                if (dropdownButton) dropdownButton.textContent = item.textContent.trim();
                updateDashboard();
            }
        });
    });

    if (searchInput) {
        let timeout;
        searchInput.addEventListener('input', () => {
            clearTimeout(timeout);
            timeout = setTimeout(() => {
                state.searchQuery = searchInput.value;
                updateDashboard();
            }, 300);
        });
    }

    if (applyDateRangeBtn && dateRangeModal) {
        applyDateRangeBtn.addEventListener('click', () => {
            // Placeholder logic for custom range
            state.timeRange = 'custom';
            if (dropdownButton) dropdownButton.textContent = 'Custom';
            dateRangeModal.hide();
            updateDashboard();
        });
    }

    // Init
    updateDashboard();
});