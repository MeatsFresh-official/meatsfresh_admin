
document.addEventListener('DOMContentLoaded', function () {

    // --- State ---
    let charts = {};

    // --- Init ---
    initCharts();
    setupEventListeners();

    // --- Charts Logic ---
    function initCharts() {
        initOrdersChart();
        initOrdersPieChart();
        initEarningsChart();
        initUsersChart();
    }

    function initOrdersChart() {
        const ctx = document.getElementById('ordersChart').getContext('2d');
        const gradient = ctx.createLinearGradient(0, 0, 0, 400);
        gradient.addColorStop(0, 'rgba(79, 70, 229, 0.2)');
        gradient.addColorStop(1, 'rgba(79, 70, 229, 0)');

        charts.orders = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                datasets: [{
                    label: 'Orders',
                    data: [45, 52, 38, 65, 48, 70, 85],
                    borderColor: '#4f46e5',
                    borderWidth: 3,
                    backgroundColor: gradient,
                    tension: 0.4,
                    fill: true,
                    pointBackgroundColor: '#4f46e5',
                    pointBorderColor: '#fff',
                    pointHoverRadius: 6,
                    pointHoverBackgroundColor: '#4f46e5',
                    pointHoverBorderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            borderDash: [5, 5],
                            color: '#e2e8f0'
                        },
                        ticks: { color: '#64748b' }
                    },
                    x: {
                        grid: { display: false },
                        ticks: { color: '#64748b' }
                    }
                }
            }
        });
    }

    function initOrdersPieChart() {
        const ctx = document.getElementById('ordersPieChart').getContext('2d');
        charts.ordersPie = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Delivered', 'Pending', 'Cancelled'],
                datasets: [{
                    data: [75, 15, 10],
                    backgroundColor: ['#10b981', '#3b82f6', '#ef4444'],
                    hoverOffset: 4,
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '75%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            usePointStyle: true,
                            padding: 20,
                            font: { size: 12, weight: '600' }
                        }
                    }
                }
            }
        });
    }

    function initEarningsChart() {
        const ctx = document.getElementById('earningsChart').getContext('2d');
        charts.earnings = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [{
                    label: 'Earnings',
                    data: [42000, 56000, 31000, 78000, 52000, 95000],
                    backgroundColor: '#10b981',
                    hoverBackgroundColor: '#059669',
                    borderRadius: 8,
                    barThickness: 20
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: { borderDash: [5, 5], color: '#e2e8f0' },
                        ticks: {
                            color: '#64748b',
                            callback: function (value) { return '₹' + value / 1000 + 'k'; }
                        }
                    },
                    x: { grid: { display: false }, ticks: { color: '#64748b' } }
                }
            }
        });
    }

    function initUsersChart() {
        const ctx = document.getElementById('usersChart').getContext('2d');
        charts.users = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
                datasets: [{
                    label: 'New Users',
                    data: [120, 180, 150, 240],
                    borderColor: '#8b5cf6',
                    borderWidth: 2,
                    backgroundColor: 'transparent',
                    tension: 0.4,
                    pointBackgroundColor: '#8b5cf6'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, grid: { borderDash: [5, 5], color: '#e2e8f0' }, ticks: { color: '#64748b' } },
                    x: { grid: { display: false }, ticks: { color: '#64748b' } }
                }
            }
        });
    }

    // --- Actions ---
    window.setTimeRange = function (days, label) {
        const btn = document.getElementById('timeRangeMenuBtn');
        btn.innerHTML = `${label} <i class="fas fa-chevron-down ml-2 -mr-1 h-5 w-5 text-gray-400"></i>`;
        document.getElementById('timeRangeDropdown').classList.add('hidden');

        // Simulate data refresh
        refreshDashboard();
    };

    window.openCustomDatepicker = function () {
        const picker = document.getElementById('customDateInput');
        // Close dropdown
        document.getElementById('timeRangeDropdown').classList.add('hidden');

        // Trigger native picker
        try {
            picker.showPicker();
        } catch (e) {
            picker.focus();
            picker.click();
        }
    };

    window.handleCustomDateChange = function (input) {
        if (input.value) {
            // Format date for display
            const date = new Date(input.value);
            const formatted = date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
            setTimeRange(0, formatted); // 0 or specific code for custom
        }
    };

    window.refreshDashboard = function () {
        // Randomize data for demo effect
        const newData = Array.from({ length: 7 }, () => Math.floor(Math.random() * 50));
        charts.orders.data.datasets[0].data = newData;
        charts.orders.update();

        // Show loading state if wanted, simplified here
        console.log("Dashboard refreshed");
    };

    function setupEventListeners() {
        // Dropdown toggle logic
        document.getElementById('timeRangeMenuBtn').addEventListener('click', function () {
            document.getElementById('timeRangeDropdown').classList.toggle('hidden');
        });

        // Close dropdown when clicking outside
        document.addEventListener('click', function (e) {
            if (!e.target.closest('.dropdown')) {
                document.getElementById('timeRangeDropdown').classList.add('hidden');
            }
        });
    }

});
