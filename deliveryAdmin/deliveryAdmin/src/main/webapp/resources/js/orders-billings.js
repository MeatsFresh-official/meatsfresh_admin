document.addEventListener('DOMContentLoaded', function () {
    // --- IMPORTANT: REPLACE WITH YOUR API ENDPOINT ---
    const API_BASE_URL = 'https://localhost:8082/api/admin';

    const API_ENDPOINTS = {
        orders: `${API_BASE_URL}/orders`,
        stats: `${API_BASE_URL}/orders/stats`,
        shops: `${API_BASE_URL}/shops/list`,
        deliveryPersons: `${API_BASE_URL}/delivery-persons/list`
    };

    // --- DOM ELEMENT REFERENCES ---
    const statsContainer = document.getElementById('stats-cards-container');
    const ordersTableBody = document.getElementById('ordersTableBody');
    const searchInput = document.getElementById('orderSearchInput');
    const detailsModal = new bootstrap.Modal(document.getElementById('orderDetailsModal'));
    const editModal = new bootstrap.Modal(document.getElementById('editOrderModal'));
    const cancelModal = new bootstrap.Modal(document.getElementById('cancelConfirmModal'));

    let searchTimeout;
    let currentFilters = {
        status: 'all',
        search: '',
        startDate: '',
        endDate: ''
    };

    // --- UTILITY FUNCTIONS ---
    const showLoading = (element) => {
        element.innerHTML = `<tr><td colspan="8" class="text-center p-5"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></td></tr>`;
    };

    const showEmpty = (element, message) => {
        element.innerHTML = `<tr><td colspan="8" class="text-center p-5 text-muted">${message}</td></tr>`;
    };

    const formatDate = (dateString) => {
        if (!dateString) return 'N/A';
        const options = { day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' };
        return new Date(dateString).toLocaleDateString('en-GB', options);
    };

    const formatCurrency = (amount) => {
        return new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR' }).format(amount);
    };

    const getStatusBadge = (status) => {
        return `<span class="order-status status-${status.toLowerCase()}">${status}</span>`;
    };

    // --- API FETCH FUNCTIONS ---

    const fetchOrderStats = async () => {
        try {
            const response = await fetch(API_ENDPOINTS.stats);
            if (!response.ok) throw new Error('Failed to load stats');
            const stats = await response.json();
            renderStats(stats);
        } catch (error) {
            console.error("Error fetching stats:", error);
            statsContainer.innerHTML = `<div class="col-12"><div class="alert alert-danger">Could not load order statistics.</div></div>`;
        }
    };

    const fetchOrders = async () => {
        showLoading(ordersTableBody);
        const params = new URLSearchParams();
        if (currentFilters.status && currentFilters.status !== 'all') params.append('status', currentFilters.status);
        if (currentFilters.search) params.append('search', currentFilters.search);
        if (currentFilters.startDate) params.append('startDate', currentFilters.startDate);
        if (currentFilters.endDate) params.append('endDate', currentFilters.endDate);

        try {
            const response = await fetch(`${API_ENDPOINTS.orders}?${params.toString()}`);
            if (!response.ok) throw new Error('Failed to load orders');
            const orders = await response.json();
            renderOrdersTable(orders);
        } catch (error) {
            console.error("Error fetching orders:", error);
            showEmpty(ordersTableBody, 'Could not load orders.');
        }
    };

    // --- RENDER FUNCTIONS ---

    const renderStats = (stats) => {
        statsContainer.innerHTML = `
            <div class="col-xl-2 col-md-4 col-6"><div class="card bg-primary text-white"><div class="card-body d-flex justify-content-between align-items-center"><div><h6 class="mb-0">Total</h6><h3 class="mb-0">${stats.total || 0}</h3></div><i class="fas fa-shopping-cart fa-2x"></i></div></div></div>
            <div class="col-xl-2 col-md-4 col-6"><div class="card bg-success text-white"><div class="card-body d-flex justify-content-between align-items-center"><div><h6 class="mb-0">Completed</h6><h3 class="mb-0">${stats.completed || 0}</h3></div><i class="fas fa-check-circle fa-2x"></i></div></div></div>
            <div class="col-xl-2 col-md-4 col-6"><div class="card bg-info text-white"><div class="card-body d-flex justify-content-between align-items-center"><div><h6 class="mb-0">In Progress</h6><h3 class="mb-0">${stats.inProgress || 0}</h3></div><i class="fas fa-truck fa-2x"></i></div></div></div>
            <div class="col-xl-2 col-md-4 col-6"><div class="card bg-warning text-dark"><div class="card-body d-flex justify-content-between align-items-center"><div><h6 class="mb-0">Pending</h6><h3 class="mb-0">${stats.pending || 0}</h3></div><i class="fas fa-clock fa-2x"></i></div></div></div>
            <div class="col-xl-2 col-md-4 col-6"><div class="card bg-danger text-white"><div class="card-body d-flex justify-content-between align-items-center"><div><h6 class="mb-0">Cancelled</h6><h3 class="mb-0">${stats.cancelled || 0}</h3></div><i class="fas fa-times-circle fa-2x"></i></div></div></div>
            <div class="col-xl-2 col-md-4 col-6"><div class="card bg-secondary text-white"><div class="card-body d-flex justify-content-between align-items-center"><div><h6 class="mb-0">Refunded</h6><h3 class="mb-0">${stats.refunded || 0}</h3></div><i class="fas fa-money-bill-wave fa-2x"></i></div></div></div>
        `;
    };

    const renderOrdersTable = (orders) => {
        if (!orders || orders.length === 0) {
            showEmpty(ordersTableBody, 'No orders found matching your criteria.');
            return;
        }

        ordersTableBody.innerHTML = orders.map(order => `
            <tr data-order-id="${order.id}">
                <td><strong>#${order.id}</strong></td>
                <td>
                    <div class="d-flex align-items-center">
                        <img src="${order.customer.profileImage || '/resources/images/default-avatar.jpg'}" class="rounded-circle me-3" width="40" height="40" alt="${order.customer.name}">
                        <div>
                            <h6 class="mb-0">${order.customer.name}</h6>
                            <small class="text-muted">${order.customer.phone}</small>
                        </div>
                    </div>
                </td>
                <td>${formatDate(order.orderDate)}</td>
                <td>${getStatusBadge(order.status)}</td>
                <td><strong>${formatCurrency(order.totalAmount)}</strong></td>
                <td>${order.shop.name}</td>
                <td>
                    ${order.deliveryPerson ? `
                    <div class="d-flex align-items-center">
                        <img src="${order.deliveryPerson.profileImage || '/resources/images/default-avatar.jpg'}" class="rounded-circle me-2" width="30" height="30" alt="${order.deliveryPerson.name}">
                        <div>${order.deliveryPerson.name}</div>
                    </div>
                    ` : `<div class="text-muted">Not assigned</div>`}
                </td>
                <td>
                    <div class="btn-group btn-group-sm">
                        <button class="btn btn-outline-primary action-btn" data-action="view" title="View Details"><i class="fas fa-eye"></i></button>
                        <button class="btn btn-outline-secondary action-btn" data-action="edit" title="Edit Order"><i class="fas fa-edit"></i></button>
                        ${order.status !== 'CANCELLED' && order.status !== 'REFUNDED' ? `<button class="btn btn-outline-danger action-btn" data-action="cancel" title="Cancel Order"><i class="fas fa-times"></i></button>` : ''}
                    </div>
                </td>
            </tr>
        `).join('');
    };

    // --- EVENT LISTENERS & HANDLERS ---

    // Search input handler
    searchInput.addEventListener('keyup', () => {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(() => {
            currentFilters.search = searchInput.value.trim();
            fetchOrders();
        }, 500); // Debounce for 500ms
    });

    // Filter button handlers
    document.getElementById('statusFilterDropdown').addEventListener('click', (e) => {
        if (e.target.matches('a.dropdown-item')) {
            e.preventDefault();
            const filter = e.target.dataset.filter;
            currentFilters.status = filter;
            document.querySelector('#statusFilterText').textContent = e.target.textContent;
            fetchOrders();
        }
    });

    // Table action buttons handler (Event Delegation)
    ordersTableBody.addEventListener('click', (e) => {
        const actionBtn = e.target.closest('.action-btn');
        if (!actionBtn) return;

        const orderId = actionBtn.closest('tr').dataset.orderId;
        const action = actionBtn.dataset.action;

        if (action === 'view') {
            // Handle view
            detailsModal.show();
        } else if (action === 'edit') {
            // Handle edit
            editModal.show();
        } else if (action === 'cancel') {
            // Handle cancel
            document.getElementById('cancelOrderIdText').textContent = orderId;
            document.getElementById('cancelOrderId').value = orderId;
            cancelModal.show();
        }
    });

    // Initial data load
    fetchOrderStats();
    fetchOrders();
});