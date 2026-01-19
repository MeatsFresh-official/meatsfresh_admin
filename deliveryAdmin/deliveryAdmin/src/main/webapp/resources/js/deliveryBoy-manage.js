$(document).ready(function () {
    // ===================================================================
    // API ENDPOINTS
    // ===================================================================
    const API_BASE = 'http://meatsfresh.org.in:8083/api';
    const RIDERS_API = API_BASE + '/delivery/register';
    const RIDERS_LIST_API = API_BASE + '/delivery';
    const SHOP_API = API_BASE + '/delivery/shop';

    const username = 'user';
    const password = 'user';
    $.ajaxSetup({
        beforeSend: function (xhr) {
            const authHeader = 'Basic ' + btoa(username + ':' + password);
            xhr.setRequestHeader('Authorization', authHeader);
        }
    });

    // ===================================================================
    // MOCK DATA GENERATORS (OPTIMISTIC UI)
    // ===================================================================
    const getMockRiders = () => [
        { id: 101, firstName: 'Rahul', lastName: 'Kumar', status: 'ACTIVE', vehicleType: 'ELECTRIC', phoneNumber: '9876543210', walletBalance: 1250.00, rating: 4.8 },
        { id: 102, firstName: 'Amit', lastName: 'Singh', status: 'ACTIVE', vehicleType: 'PETROL', phoneNumber: '9876543211', walletBalance: 450.50, rating: 4.2 },
        { id: 103, firstName: 'Vikram', lastName: 'Verma', status: 'INACTIVE', vehicleType: 'PETROL', phoneNumber: '9876543212', walletBalance: 0.00, rating: 3.5 },
        { id: 104, firstName: 'Suresh', lastName: 'Reddy', status: 'REJECTED', vehicleType: 'ELECTRIC', phoneNumber: '9876543213', walletBalance: 0.00, rating: 0 },
        { id: 105, firstName: 'Priya', lastName: 'Sharma', status: 'ACTIVE', vehicleType: 'ELECTRIC', phoneNumber: '9876543214', walletBalance: 2100.00, rating: 5.0 },
        { id: 106, firstName: 'Karan', lastName: 'Mehta', status: 'ACTIVE', vehicleType: 'ELECTRIC', phoneNumber: '9876543215', walletBalance: 800.00, rating: 4.5 },
        { id: 107, firstName: 'Arjun', lastName: 'Das', status: 'PENDING', vehicleType: 'CYCLE', phoneNumber: '9876543216', walletBalance: 0.00, rating: 0 }
    ];

    const getMockShopItems = () => [
        { id: 1, name: 'Rider T-Shirt (L)', description: 'Official MeatsFresh Uniform', price: 499, stock: 50, category: 'UNIFORM', image: 'resources/images/tshirt.png' },
        { id: 2, name: 'Delivery Bag', description: 'Insulated thermal bag', price: 1200, stock: 20, category: 'EQUIPMENT', image: 'resources/images/bag.png' },
        { id: 3, name: 'Helmet', description: 'Safety certified helmet', price: 1500, stock: 15, category: 'SAFETY', image: 'resources/images/helmet.png' }
    ];

    const getMockStats = () => ({ total: 12, active: 8, pending: 3, rejected: 1 });

    // ===================================================================
    // STATE & PAGINATION
    // ===================================================================
    let allRiders = [];
    // Initialize Pagination Utility
    // 10 items per page, rendering callback is 'renderRidersPage'
    const ridersPaginator = new PaginationUtils('ridersPagination', 10, renderRidersPage);

    initApplication();

    function initApplication() {
        // Optimistic Load
        const mockRiders = getMockRiders();
        allRiders = mockRiders;
        ridersPaginator.setData(mockRiders); // This triggers renderRidersPage internally

        renderShopItems(getMockShopItems());
        updateStatCards(getMockStats());

        if ($('#performanceChart').length && typeof Chart !== 'undefined') initCharts();

        // Background Fetch
        loadRidersBackground();
        loadShopItemsBackground();
        setupEventHandlers();
    }

    // ===================================================================
    // DATA LOADING
    // ===================================================================
    function loadRidersBackground() {
        $.ajax({
            url: RIDERS_LIST_API,
            type: 'GET',
            success: function (riders) {
                if (riders && riders.length > 0) {
                    allRiders = riders;
                    ridersPaginator.setData(riders); // Update Paginator with Real Data
                    calculateAndRenderStats(riders);
                }
            },
            error: function (xhr) {
                console.warn("Using mock riders due to API error:", xhr.statusText);
            }
        });
    }

    function loadShopItemsBackground() {
        $.get(SHOP_API, function (items) {
            if (items && items.length > 0) {
                renderShopItems(items);
            }
        });
    }

    function calculateAndRenderStats(riders) {
        let counts = { total: riders.length, active: 0, rejected: 0, pending: 0 };
        riders.forEach(r => {
            if (r.approved === true || r.status === 'ACTIVE') counts.active++;
            else if (r.approved === false || r.status === 'REJECTED') counts.rejected++;
            else counts.pending++;
        });
        updateStatCards(counts);
    }

    // ===================================================================
    // RENDERING FUNCTIONS
    // ===================================================================

    // Callback function used by PaginationUtils
    function renderRidersPage(ridersForPage) {
        const tbody = $('#ridersTable tbody').empty();

        if (!ridersForPage || ridersForPage.length === 0) {
            tbody.html('<tr><td colspan="7" class="text-center text-muted py-5">No riders found.</td></tr>');
            return;
        }

        ridersForPage.forEach(rider => {
            const status = determineRiderStatus(rider);
            const riderId = rider.id || rider.partnerId || 'N/A';
            const wallet = rider.walletBalance !== undefined ? rider.walletBalance : 0;

            const rowHtml = `
            <tr>
                <td>
                    <div class="d-flex align-items-center">
                        <img src="${rider.avatar || 'resources/images/default-avatar.png'}" 
                             class="rider-avatar-small" 
                             alt="${rider.firstName}"
                             onerror="this.src='resources/images/default-avatar.png'">
                        <div class="rider-meta">
                            <span class="rider-name-list">${rider.firstName} ${rider.lastName}</span>
                            <span class="rider-id-list">ID: ${riderId}</span>
                        </div>
                    </div>
                </td>
                <td><span class="small fw-bold text-dark">${rider.phoneNumber || 'N/A'}</span></td>
                <td><span class="zenith-badge ${status.bgClass}">${status.text}</span></td>
                <td>${getVehicleBadge(rider.vehicleType)}</td>
                <td class="fw-bold text-dark">${formatCurrency(wallet)}</td>
                <td>
                    <div class="small">
                        <span class="fw-bold text-primary me-1">${rider.rating || 'New'}</span>
                        <i class="fas fa-star text-warning"></i>
                    </div>
                </td>
                <td class="text-end">
                    <button class="btn-icon" title="View Details"><i class="fas fa-eye"></i></button>
                    <button class="btn-icon" title="Edit Profile"><i class="fas fa-pen"></i></button>
                    <button class="btn-icon btn-icon-danger" title="Delete"><i class="fas fa-trash"></i></button>
                </td>
            </tr>`;
            tbody.append(rowHtml);
        });
    }

    function renderShopItems(items) {
        const container = $('#shopItemsGrid').empty();
        items.forEach(item => {
            const html = `
             <div class="col-xl-3 col-md-4 col-sm-6">
                <div class="card zenith-card h-100 overflow-hidden border-0 shadow-sm">
                    <div class="position-relative" style="height: 160px; background: #f8f9fa;">
                         <img src="${item.image}" class="w-100 h-100" style="object-fit: contain;" alt="${item.name}" 
                              onerror="this.src='resources/images/default-product.png'">
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                             <h6 class="fw-bold mb-0 text-truncate" title="${item.name}">${item.name}</h6>
                             <span class="badge bg-light text-dark border">${item.category || 'Item'}</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <h5 class="mb-0 text-primary fw-bold">${formatCurrency(item.price)}</h5>
                            <small class="${item.stock > 0 ? 'text-success' : 'text-danger'} fw-bold">
                                ${item.stock > 0 ? item.stock + ' in stock' : 'Out of Stock'}
                            </small>
                        </div>
                    </div>
                </div>
             </div>`;
            container.append(html);
        });
    }

    function updateStatCards(stats) {
        $('.stat-card').eq(0).find('h2').text(stats.total);
        $('.stat-card').eq(1).find('h2').text(stats.active);
        $('.stat-card').eq(2).find('h2').text(stats.pending);
        $('.stat-card').eq(3).find('h2').text(stats.rejected);
    }

    // ===================================================================
    // HELPERS
    // ===================================================================
    function determineRiderStatus(rider) {
        const status = (rider.status || '').toUpperCase();
        if (status === 'ACTIVE' || rider.approved === true) return { text: 'Active', bgClass: 'zenith-badge-success' };
        if (status === 'REJECTED' || rider.approved === false) return { text: 'Rejected', bgClass: 'zenith-badge-danger' };
        return { text: 'Pending', bgClass: 'zenith-badge-warning' };
    }

    function getVehicleBadge(type) {
        if (!type) return '<span class="text-muted small">-</span>';
        let cls = 'zenith-badge-secondary';
        if (type === 'ELECTRIC') cls = 'zenith-badge-info';
        if (type === 'PETROL') cls = 'zenith-badge-warning';
        return `<span class="zenith-badge ${cls}">${type}</span>`;
    }

    function formatCurrency(amount) {
        return new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', maximumFractionDigits: 0 }).format(amount);
    }

    function initCharts() {
        const ctx = document.getElementById('performanceChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [{
                    label: 'Deliveries',
                    data: [65, 59, 80, 81, 56, 95],
                    fill: true,
                    backgroundColor: 'rgba(99, 102, 241, 0.1)',
                    borderColor: '#6366f1',
                    tension: 0.4
                }]
            },
            options: { responsive: true, plugins: { legend: { display: false } } }
        });
    }

    // ===================================================================
    // EVENT HANDLERS
    // ===================================================================
    function setupEventHandlers() {
        // --- 1. Filter Logic ---
        $('#statusFilter, #vehicleFilter').change(function () {
            const status = $('#statusFilter').val();
            const vehicle = $('#vehicleFilter').val();

            let filtered = allRiders;
            if (status) filtered = filtered.filter(r => (r.status || '').toUpperCase() === status);
            if (vehicle) filtered = filtered.filter(r => r.vehicleType === vehicle);

            ridersPaginator.setData(filtered); // Update pagination with filtered set
        });

        $('#resetFiltersBtn').click(() => {
            $('#statusFilter, #vehicleFilter').val('');
            ridersPaginator.setData(allRiders);
        });

        $('#riderSearch').on('keyup', function () {
            const val = $(this).val().toLowerCase();
            const filtered = allRiders.filter(r =>
                r.firstName.toLowerCase().includes(val) ||
                r.lastName.toLowerCase().includes(val) ||
                (r.phoneNumber && r.phoneNumber.includes(val))
            );
            ridersPaginator.setData(filtered);
        });

        // --- 2. Add Rider Form Submission (Bug Fix) ---
        $('#addRiderForm').on('submit', function (e) {
            e.preventDefault();
            const formData = new FormData(this);
            const submitBtn = $('#addRiderSubmitBtn');
            const originalText = submitBtn.text();

            submitBtn.prop('disabled', true).text('Creating...');

            $.ajax({
                url: RIDERS_API,
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function (resp) {
                    $('#addRiderModal').modal('hide');
                    showToast('Rider created successfully!', 'success');
                    $('#addRiderForm')[0].reset();
                    loadRidersBackground(); // Reload list
                },
                error: function (xhr) {
                    showToast('Failed to create rider: ' + xhr.responseText, 'error');
                },
                complete: function () {
                    submitBtn.prop('disabled', false).text(originalText);
                }
            });
        });
    }

    function showToast(msg, type) {
        const toastEl = type === 'success' ? $('#successToast') : $('#errorToast');
        toastEl.find('.toast-body').text(msg);
        const toast = new bootstrap.Toast(toastEl[0]);
        toast.show();
    }
});