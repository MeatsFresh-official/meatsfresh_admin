/* Zenith Admin - Orders Logic */

document.addEventListener('DOMContentLoaded', function () {

    // --- State ---
    let allOrders = [];
    let currentFilter = 'ALL';
    let dateRange = { start: moment().subtract(7, 'days').format('YYYY-MM-DD'), end: moment().format('YYYY-MM-DD') };
    let fpInstance = null;

    // --- Initialization ---
    initDateRangePicker();
    generateSampleData();
    renderStats();
    renderTable();
    setupEventListeners();

    // --- Date Picker ---
    function initDateRangePicker() {
        fpInstance = flatpickr("#dateRangePicker", {
            mode: "range",
            dateFormat: "Y-m-d",
            defaultDate: [dateRange.start, dateRange.end],
            onChange: function (selectedDates) {
                if (selectedDates.length === 2) {
                    dateRange = {
                        start: moment(selectedDates[0]).format('YYYY-MM-DD'),
                        end: moment(selectedDates[1]).format('YYYY-MM-DD')
                    };
                    renderTable();
                }
            }
        });
    }

    // --- Sample Data Generation ---
    function generateSampleData() {
        // ... (Same as before)
        const statuses = [
            'PENDING_VENDOR_APPROVAL', 'ACCEPTED_BY_VENDOR', 'ORDER_PREPARING',
            'ORDER_READY', 'AWAITING_DELIVERY_PARTNER_CONFIRMATION', 'PLACED',
            'DELIVERY_PARTNER_ASSIGNED', 'REACHED_VENDOR', 'ORDER_PICKED',
            'ON_THE_WAY', 'REACHED_CUSTOMER', 'DELIVERED', 'PAYMENT_PENDING',
            'REJECTED_BY_PARTNER', 'APPROVED', 'COLLECTED_ORDER', 'RETURN',
            'VENDOR_DECLINED', 'CANCELLED'
        ];

        const customers = ['John Doe', 'Sarah Smith', 'Michael Johnson', 'Emily Davis', 'David Wilson', 'Priya Patel', 'Rahul Sharma'];
        const shops = ['Meat Masters', 'Fresh Cuts', 'Ocean Catch', 'Green Valley Farms', 'Organic Choice'];
        const meals = ['Premium Angus Steak', 'Organic Chicken Breast', 'Fresh Atlantic Salmon', 'Spicy Lamb Chops', 'Gourmet Sausages', 'Tiger Prawns'];

        for (let i = 0; i < 45; i++) {
            const date = moment().subtract(Math.floor(Math.random() * 30), 'days').subtract(Math.floor(Math.random() * 24), 'hours'); // Increased range for demo
            const status = statuses[Math.floor(Math.random() * statuses.length)];
            const itemCount = Math.floor(Math.random() * 5) + 1;

            // Generate Items
            let items = [];
            let subtotal = 0;
            for (let j = 0; j < itemCount; j++) {
                const price = (Math.random() * 200 + 50).toFixed(2); // Increased prices for Rupees
                const qty = Math.floor(Math.random() * 3) + 1;
                subtotal += price * qty;
                items.push({
                    name: meals[Math.floor(Math.random() * meals.length)],
                    qty: qty,
                    price: price
                });
            }

            const deliveryFee = (Math.random() * 50 + 20).toFixed(2);
            const tax = (subtotal * 0.05).toFixed(2);
            const total = (subtotal + parseFloat(deliveryFee) + parseFloat(tax)).toFixed(2);

            allOrders.push({
                id: 1000 + i,
                orderCode: 'ORD-' + (2024000 + i),
                customer: customers[Math.floor(Math.random() * customers.length)],
                phone: '+91 98765 ' + (Math.floor(Math.random() * 89999) + 10000),
                address: (Math.floor(Math.random() * 99) + 1) + ' MG Road, Bengaluru, KA',
                shop: shops[Math.floor(Math.random() * shops.length)],
                total: total,
                subtotal: subtotal.toFixed(2),
                deliveryFee: deliveryFee,
                tax: tax,
                status: status,
                date: date.format('YYYY-MM-DD HH:mm'),
                deliveryBoy: status.includes('DELIVER') || status === 'ON_THE_WAY' ? 'Rider ' + (Math.floor(Math.random() * 5) + 1) : 'Unassigned',
                itemCount: itemCount + ' Items',
                itemsList: items
            });
        }

        // Sort by date desc
        allOrders.sort((a, b) => new Date(b.date) - new Date(a.date));
    }

    // --- Rendering ---
    function renderStats() {
        document.getElementById('stat-total-orders').textContent = allOrders.length;
        document.getElementById('stat-pending-orders').textContent = allOrders.filter(o => o.status.includes('PENDING') || o.status === 'PLACED').length;
        document.getElementById('stat-delivered-orders').textContent = allOrders.filter(o => o.status === 'DELIVERED').length;

        const totalRev = allOrders.reduce((sum, order) => sum + parseFloat(order.total), 0);
        document.getElementById('stat-revenue').textContent = '₹' + totalRev.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }

    function renderTable() {
        const tbody = document.getElementById('ordersTableBody');
        tbody.innerHTML = '';

        let filtered = allOrders;

        // Status Filter
        if (currentFilter !== 'ALL') {
            filtered = filtered.filter(o => o.status === currentFilter);
        }

        // Date Filter
        if (dateRange.start && dateRange.end) {
            const start = moment(dateRange.start).startOf('day');
            const end = moment(dateRange.end).endOf('day');
            filtered = filtered.filter(o => {
                const d = moment(o.date);
                return d.isBetween(start, end, null, '[]');
            });
        }

        // Search Filter
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        if (searchTerm) {
            filtered = filtered.filter(o =>
                o.orderCode.toLowerCase().includes(searchTerm) ||
                o.customer.toLowerCase().includes(searchTerm) ||
                o.shop.toLowerCase().includes(searchTerm)
            );
        }

        document.getElementById('showingCount').textContent = filtered.length;
        document.getElementById('totalCount').textContent = allOrders.length;

        if (filtered.length === 0) {
            tbody.innerHTML = `<tr><td colspan="7" class="text-center py-8 text-gray-400">No orders found matching your criteria.</td></tr>`;
            return;
        }

        filtered.forEach(order => {
            const tr = document.createElement('tr');
            tr.className = 'group cursor-pointer hover:bg-gray-50';

            tr.innerHTML = `
                <td>
                    <div class="flex flex-col">
                        <span class="font-bold text-gray-800">${order.orderCode}</span>
                        <span class="text-xs text-gray-500">${order.itemCount} • ${order.shop}</span>
                    </div>
                </td>
                <td>
                    <span class="badge status-${order.status}">
                        <span class="badge-dot"></span>
                        ${formatStatus(order.status)}
                    </span>
                </td>
                <td>
                    <div class="flex items-center">
                        <div class="h-8 w-8 rounded-full bg-gray-200 flex items-center justify-center text-xs font-bold text-gray-600 mr-2">
                            ${order.customer.charAt(0)}
                        </div>
                        <span class="text-sm font-medium text-gray-700">${order.customer}</span>
                    </div>
                </td>
                <td class="font-semibold text-gray-700">₹${order.total}</td>
                <td class="text-sm text-gray-500">${moment(order.date).format('MMM D, h:mm A')}</td>
                <td>
                    ${order.deliveryBoy !== 'Unassigned' ?
                    `<span class="text-xs bg-blue-50 text-blue-600 px-2 py-1 rounded-md font-medium"><i class="fas fa-biking mr-1"></i>${order.deliveryBoy}</span>` :
                    `<span class="text-xs text-gray-400">Pending</span>`
                }
                </td>
                <td class="text-right">
                    <button class="text-blue-600 hover:text-blue-800 p-2 rounded-full hover:bg-blue-50 transition-colors" onclick="openEditModal(${order.id})" title="Edit Order">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="text-gray-400 hover:text-gray-600 p-2 rounded-full hover:bg-gray-100 transition-colors" onclick="openViewModal(${order.id})" title="View Details">
                        <i class="fas fa-eye"></i>
                    </button>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }

    function formatStatus(status) {
        return status.replace(/_/g, ' ').toLowerCase().replace(/\b\w/g, l => l.toUpperCase());
    }

    // --- Events ---
    function setupEventListeners() {
        document.querySelectorAll('.status-tab').forEach(tab => {
            tab.addEventListener('click', (e) => {
                document.querySelectorAll('.status-tab').forEach(t => t.classList.remove('active'));
                e.target.classList.add('active');
                currentFilter = e.target.getAttribute('data-filter');
                renderTable();
            });
        });
        document.getElementById('searchInput').addEventListener('input', renderTable);
    }

    // --- Global Actions ---
    window.setDateRange = function (type) {
        let start, end;
        const today = moment();

        switch (type) {
            case 'today':
                start = today.clone().startOf('day');
                end = today.clone().endOf('day');
                break;
            case 'week':
                start = today.clone().startOf('week'); // or subtract(6, 'days')
                end = today.clone().endOf('day');
                break;
            case 'month':
                start = today.clone().startOf('month');
                end = today.clone().endOf('day');
                break;
            case 'year':
                start = today.clone().startOf('year');
                end = today.clone().endOf('day');
                break;
        }

        if (start && end) {
            dateRange = {
                start: start.format('YYYY-MM-DD'),
                end: end.format('YYYY-MM-DD')
            };
            // Update Picker UI
            if (fpInstance) {
                fpInstance.setDate([dateRange.start, dateRange.end], true);
            }
            renderTable();
        }
    };

    window.openEditModal = function (id) {
        // ... (Same as before)
        const order = allOrders.find(o => o.id === id);
        if (!order) return;
        document.getElementById('editModalOrderCode').textContent = order.orderCode;
        document.getElementById('editStatusSelect').value = order.status;
        window.currentEditingId = id;
        document.getElementById('editOrderModal').classList.remove('hidden');
    };

    window.openViewModal = function (id) {
        const order = allOrders.find(o => o.id === id);
        if (!order) return;

        // Header
        document.getElementById('viewModalOrderCode').textContent = order.orderCode;
        document.getElementById('viewModalDate').textContent = moment(order.date).format('MMMM Do YYYY, h:mm A');

        // Customer
        document.getElementById('viewModalCustomer').textContent = order.customer;
        document.getElementById('viewModalPhone').textContent = order.phone;
        document.getElementById('viewModalAddress').textContent = order.address;

        // Items
        const itemsContainer = document.getElementById('viewModalItems');
        itemsContainer.innerHTML = '';
        order.itemsList.forEach(item => {
            itemsContainer.innerHTML += `
                <div class="flex justify-between items-center text-sm">
                    <div class="flex items-center">
                        <div class="h-8 w-8 rounded bg-gray-100 flex items-center justify-center text-gray-500 text-xs font-bold mr-3">${item.qty}x</div>
                        <span class="text-gray-700 font-medium">${item.name}</span>
                    </div>
                    <span class="text-gray-900 font-semibold">₹${(item.price * item.qty).toFixed(2)}</span>
                </div>
            `;
        });

        // Totals
        document.getElementById('viewModalSubtotal').textContent = '₹' + order.subtotal;
        document.getElementById('viewModalDelivery').textContent = '₹' + order.deliveryFee;
        document.getElementById('viewModalTax').textContent = '₹' + order.tax;
        document.getElementById('viewModalTotal').textContent = '₹' + order.total;

        // Status & Rider
        document.getElementById('viewModalStatusBadge').className = `badge status-${order.status} text-sm`;
        document.getElementById('viewModalStatusBadge').textContent = formatStatus(order.status);
        document.getElementById('viewModalRider').textContent = order.deliveryBoy;

        document.getElementById('orderDetailsModal').classList.remove('hidden');
    };

    window.closeModal = function (modalId) {
        document.getElementById(modalId).classList.add('hidden');
    };

    window.saveOrderStatus = function () {
        if (!window.currentEditingId) return;
        const newStatus = document.getElementById('editStatusSelect').value;
        const orderIndex = allOrders.findIndex(o => o.id === window.currentEditingId);

        if (orderIndex > -1) {
            allOrders[orderIndex].status = newStatus;
            renderStats();
            renderTable();
            closeModal('editOrderModal');
        }
    };
});