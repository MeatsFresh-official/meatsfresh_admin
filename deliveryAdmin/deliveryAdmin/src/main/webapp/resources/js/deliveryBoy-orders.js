document.addEventListener('DOMContentLoaded', () => {
    // --- STATE MANAGEMENT ---
    let state = {
        allOrders: [],
        pendingOrders: [],
        completedOrders: [],
        cancelledOrders: [],
        currentPage: 1,
        itemsPerPage: 10,
        filters: {
            dateRange: 'today',
            search: ''
        }
    };

    // --- DOM ELEMENT REFERENCES ---
    const elements = {
        tabs: document.querySelectorAll('#orderTabs button'),
        searchInput: document.getElementById('orderSearch'),
        filterPills: document.querySelectorAll('.filter-pill'),
        tableBodies: {
            all: document.querySelector('#ordersTable tbody'),
            pending: document.querySelector('#pendingOrdersTable tbody'),
            completed: document.querySelector('#completedOrdersTable tbody')
        },
        paginations: {
            all: document.getElementById('allOrdersPagination'),
            pending: document.getElementById('pendingOrdersPagination'),
            completed: document.getElementById('completedOrdersPagination')
        },
        stats: {
            total: document.getElementById('totalOrdersCount'),
            pending: document.getElementById('pendingOrdersCount'),
            completed: document.getElementById('completedOrdersCount'),
            cancelled: document.getElementById('cancelledOrdersCount')
        },
        offcanvas: {
            element: document.getElementById('orderDetailsOffcanvas'),
            instance: null,
            fields: {
                id: document.getElementById('offOrderId'),
                status: document.getElementById('offStatus'),
                time: document.getElementById('offTime'),
                vendor: document.getElementById('offVendor'),
                customer: document.getElementById('offCustomer'),
                address: document.getElementById('offAddress'),
                total: document.getElementById('offTotalAmount'),
                baseFee: document.getElementById('offBaseFee'),
                surgeFee: document.getElementById('offSurgeFee'),
                riderEarnings: document.getElementById('offRiderEarnings'),
                tip: document.getElementById('offTip'),
                incentive: document.getElementById('offIncentive'),
                itemsList: document.getElementById('offItemsList')
            }
        }
    };

    // Initialize Bootstrap Offcanvas
    if (elements.offcanvas.element) {
        elements.offcanvas.instance = new bootstrap.Offcanvas(elements.offcanvas.element);
    }

    // --- UTILITIES ---
    const formatCurrency = (amount) => {
        return new Intl.NumberFormat('en-IN', {
            style: 'currency',
            currency: 'INR',
            maximumFractionDigits: 2
        }).format(amount);
    };

    const formatDate = (dateString) => {
        if (!dateString) return 'N/A';
        const date = new Date(dateString);
        return date.toLocaleString('en-IN', {
            month: 'short', day: 'numeric',
            hour: 'numeric', minute: 'numeric', hour12: true
        });
    };

    const getStatusBadge = (status) => {
        let badgeClass = 'bg-soft-secondary text-secondary';
        let icon = '';

        switch (status) {
            case 'PENDING':
                badgeClass = 'bg-soft-warning text-warning';
                icon = '<i class="fas fa-clock me-1"></i>';
                break;
            case 'CONFIRMED':
            case 'PREPARING':
            case 'READY_FOR_PICKUP':
                badgeClass = 'bg-soft-info text-info';
                icon = '<i class="fas fa-spinner fa-spin me-1"></i>';
                break;
            case 'PICKED_UP':
            case 'IN_TRANSIT':
                badgeClass = 'bg-soft-primary text-primary';
                icon = '<i class="fas fa-motorcycle me-1"></i>';
                break;
            case 'DELIVERED':
                badgeClass = 'bg-soft-success text-success';
                icon = '<i class="fas fa-check-circle me-1"></i>';
                break;
            case 'CANCELLED':
                badgeClass = 'bg-soft-danger text-danger';
                icon = '<i class="fas fa-times-circle me-1"></i>';
                break;
        }
        return `<span class="zenith-badge ${badgeClass}">${icon}${status}</span>`;
    };

    // --- DATA FETCHING ---
    const fetchOrders = async () => {
        // Show Loading State
        Object.values(elements.tableBodies).forEach(tbody => {
            if (tbody) tbody.innerHTML = `<tr><td colspan="7" class="text-center p-5"><div class="spinner-border text-primary"></div></td></tr>`;
        });

        try {
            // Simulate API call delay
            // const response = await fetch('/api/vendor/orders'); 
            // const data = await response.json();

            // MOCK DATA for logic testing
            const mockData = Array.from({ length: 15 }).map((_, i) => ({
                orderId: `ORD-${1000 + i}`,
                customerName: ['Alice Smith', 'Bob Jones', 'Charlie Brown'][i % 3],
                totalAmount: (Math.random() * 2000 + 200).toFixed(2),
                deliveryAddress: '123 Main St, Springfield',
                status: ['PENDING', 'DELIVERED', 'CANCELLED', 'IN_TRANSIT'][i % 4],
                riderName: i % 4 === 0 ? null : 'Raju Driver',
                orderTime: new Date().toISOString(),
                items: [
                    { name: 'Chicken Curry', quantity: 1, price: 350 },
                    { name: 'Naan', quantity: 2, price: 40 }
                ],
                // Mock Financials for redesign
                baseFee: (Math.random() * 50 + 20).toFixed(2),
                surgeFee: (Math.random() * 20).toFixed(2),
                tip: (Math.random() * 50).toFixed(2),
                incentive: (Math.random() > 0.7 ? 15.00 : 0.00).toFixed(2)
            }));

            state.allOrders = mockData;
            state.pendingOrders = mockData.filter(o => ['PENDING', 'CONFIRMED', 'PREPARING', 'READY_FOR_PICKUP', 'PICKED_UP', 'IN_TRANSIT'].includes(o.status));
            state.completedOrders = mockData.filter(o => o.status === 'DELIVERED');
            state.cancelledOrders = mockData.filter(o => o.status === 'CANCELLED');

            updateStats();
            renderTables();

        } catch (error) {
            console.error('Error fetching orders:', error);
            showToast('Failed to load orders', 'error');
        }
    };

    const updateStats = () => {
        elements.stats.total.innerText = state.allOrders.length;
        elements.stats.pending.innerText = state.pendingOrders.length;
        elements.stats.completed.innerText = state.completedOrders.length;
        elements.stats.cancelled.innerText = state.cancelledOrders.length;
    };

    // --- RENDERING ---
    const renderTables = () => {
        renderTable(elements.tableBodies.all, state.allOrders, 'all');
        if (elements.tableBodies.pending) renderTable(elements.tableBodies.pending, state.pendingOrders, 'pending');
        if (elements.tableBodies.completed) renderTable(elements.tableBodies.completed, state.completedOrders, 'completed');
    };

    const renderTable = (tbody, data, type) => {
        if (!tbody) return;
        tbody.innerHTML = '';

        if (data.length === 0) {
            tbody.innerHTML = `<tr><td colspan="7" class="text-center p-5 text-muted">No orders found.</td></tr>`;
            return;
        }

        data.forEach(order => {
            const tr = document.createElement('tr');
            tr.className = 'clickable-row animate-on-load';

            // Different columns based on tab type if needed, but for now generic structure
            let rowContent = '';

            if (type === 'all') {
                rowContent = `
                    <td class="ps-4 fw-bold text-primary">${order.orderId}</td>
                    <td>
                        <div class="d-flex align-items-center">
                            <div class="avatar-circle bg-soft-info text-info me-2 sm-avatar"><i class="fas fa-user"></i></div>
                            <span class="fw-medium">${order.customerName}</span>
                        </div>
                    </td>
                    <td class="fw-bold text-dark">${formatCurrency(order.totalAmount)}</td>
                    <td><small class="text-muted text-truncate d-inline-block" style="max-width: 150px;">${order.deliveryAddress}</small></td>
                    <td>${getStatusBadge(order.status)}</td>
                     <td>${order.riderName ? `<span class="text-dark fw-medium"><i class="fas fa-motorcycle me-1 text-secondary"></i>${order.riderName}</span>` : '<span class="badge bg-light text-secondary">Unassigned</span>'}</td>
                    <td class="text-center pe-4">
                        <button class="btn btn-sm btn-white border shadow-sm rounded-circle action-btn"><i class="fas fa-chevron-right text-secondary"></i></button>
                    </td>
                `;
            } else if (type === 'pending') {
                rowContent = `
                    <td class="ps-4 fw-bold text-primary">${order.orderId}</td>
                    <td>${order.customerName}</td>
                    <td class="fw-bold">${formatCurrency(order.totalAmount)}</td>
                    <td>
                        <div class="d-flex flex-column">
                             <small class="text-truncate" style="max-width: 150px;">${order.deliveryAddress}</small>
                             <span class="badge bg-light text-secondary border mt-1" style="width: fit-content;"><i class="fas fa-location-arrow me-1"></i>2.5 km</span>
                        </div>
                    </td>
                    <td><small class="text-muted fw-bold">${formatDate(order.orderTime)}</small></td>
                    <td class="text-center pe-4">
                        <button class="btn btn-sm btn-zenith-primary shadow-sm action-btn">Assign</button>
                    </td>
                `;
            } else if (type === 'completed') {
                rowContent = `
                    <td class="ps-4 fw-bold text-primary">${order.orderId}</td>
                    <td>${order.customerName}</td>
                    <td class="fw-bold">${formatCurrency(order.totalAmount)}</td>
                    <td><small class="text-muted">${formatDate(order.orderTime)}</small></td>
                    <td>
                        <div class="text-warning small"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i></div>
                    </td>
                    <td class="text-center pe-4">
                        <button class="btn btn-sm btn-white border shadow-sm rounded-circle action-btn"><i class="fas fa-eye text-primary"></i></button>
                    </td>
                `;
            }

            tr.innerHTML = rowContent;

            // Add click event for Offcanvas
            tr.addEventListener('click', (e) => {
                // Prevent trigger if clicking a button inside
                /* if (e.target.closest('button')) return; */ // Actually, let's open details for all clicks for now, unless specific action
                openOrderDetails(order);
            });

            tbody.appendChild(tr);
        });
    };

    // --- OFFCANVAS DETAILS LOGIC ---
    const openOrderDetails = (order) => {
        const f = elements.offcanvas.fields;

        // Populate Logistics
        f.id.innerText = order.orderId;
        f.status.innerHTML = order.status; // Could use getStatusBadge but simple text is fine or use badge class update
        f.status.className = `badge rounded-pill px-3 ${order.status === 'DELIVERED' ? 'bg-soft-success text-success' : 'bg-soft-primary text-primary'}`;
        f.time.innerText = formatDate(order.orderTime);
        f.vendor.innerText = "MeatsFresh Hub"; // Mock vendor
        f.customer.innerText = order.customerName;
        f.address.innerText = order.deliveryAddress;

        // Populate Financials (The Heart Card)
        const total = parseFloat(order.totalAmount);
        const base = parseFloat(order.baseFee);
        const surge = parseFloat(order.surgeFee);
        const tip = parseFloat(order.tip);
        const incentive = parseFloat(order.incentive);
        const riderTotal = base + surge + tip + incentive;

        f.total.innerText = formatCurrency(total);
        f.baseFee.innerText = formatCurrency(base);
        f.surgeFee.innerText = formatCurrency(surge);
        f.riderEarnings.innerText = formatCurrency(riderTotal);
        f.tip.innerText = formatCurrency(tip);
        f.incentive.innerText = formatCurrency(incentive);

        // Populate Items
        if (f.itemsList) {
            f.itemsList.innerHTML = order.items.map(item => `
                <li class="list-group-item d-flex justify-content-between align-items-center px-3 py-2 border-light">
                    <div>
                        <span class="badge bg-light text-dark border me-2">${item.quantity}x</span>
                        <span class="fw-medium text-dark">${item.name}</span>
                    </div>
                    <span class="fw-bold text-secondary">${formatCurrency(item.price * item.quantity)}</span>
                </li>
            `).join('');
        }

        // Show Offcanvas
        if (elements.offcanvas.instance) {
            elements.offcanvas.instance.show();
        }
    };

    // --- EVENT LISTENERS ---

    // Tab Switching
    elements.tabs.forEach(tab => {
        tab.addEventListener('shown.bs.tab', (e) => {
            // Can add logic to refresh specific data if needed
            // console.log('Tab switched to', e.target.id);
        });
    });

    // Filtering
    elements.filterPills.forEach(pill => {
        pill.addEventListener('click', (e) => {
            e.preventDefault();
            elements.filterPills.forEach(p => p.classList.remove('active', 'btn-zenith-primary'));
            elements.filterPills.forEach(p => p.classList.add('text-secondary', 'hover-bg-light'));
            e.target.classList.add('active', 'btn-zenith-primary');
            e.target.classList.remove('text-secondary', 'hover-bg-light');

            state.filters.dateRange = e.target.dataset.range;
            // Re-fetch or filter existing data
            fetchOrders();
        });
    });

    // Toast Helper
    const showToast = (message, type = 'success') => {
        const toastEl = type === 'error' ? document.getElementById('errorToast') : document.getElementById('successToast');
        if (toastEl) {
            const toastBody = toastEl.querySelector('.toast-body');
            if (toastBody) toastBody.innerText = message;
            const toast = new bootstrap.Toast(toastEl);
            toast.show();
        }
    };

    // --- INITIALIZATION ---
    fetchOrders();
});