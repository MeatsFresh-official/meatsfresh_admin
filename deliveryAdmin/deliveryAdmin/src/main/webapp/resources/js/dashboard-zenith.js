
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
        charts.orders = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                datasets: [{
                    label: 'Orders',
                    data: [12, 19, 3, 5, 2, 3, 10],
                    borderColor: '#4f46e5',
                    backgroundColor: 'rgba(79, 70, 229, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, grid: { borderDash: [2, 2] } },
                    x: { grid: { display: false } }
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
                    data: [300, 50, 100],
                    backgroundColor: ['#10b981', '#f59e0b', '#ef4444'],
                    borderWidth: 0,
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '70%',
                plugins: { legend: { position: 'bottom' } }
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
                    label: 'Earnings (₹)',
                    data: [12000, 19000, 3000, 5000, 2000, 3000],
                    backgroundColor: '#10b981',
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, grid: { borderDash: [2, 2] } },
                    x: { grid: { display: false } }
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
                    data: [50, 60, 70, 80],
                    borderColor: '#8b5cf6',
                    backgroundColor: 'rgba(139, 92, 246, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, grid: { borderDash: [2, 2] } },
                    x: { grid: { display: false } }
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
