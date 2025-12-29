document.addEventListener('DOMContentLoaded', function () {
    // =================================================================
    // == CONFIGURE YOUR API BASE URL HERE ==
    // =================================================================
    // Replace 'https://api.yourdomain.com' with your actual API server address.
    const BASE_URL = 'https://localhost:8080';
    // =================================================================


    // API Endpoints - These are now constructed using the BASE_URL
    const API_ENDPOINTS = {
        getDashboardStats:  `${BASE_URL}/api/orders/stats`,
        getAllOrders:       `${BASE_URL}/api/orders/all`,
        getPendingOrders:   `${BASE_URL}/api/orders/pending`,
        getCompletedOrders: `${BASE_URL}/api/orders/completed`,
        getOrderDetails:    `${BASE_URL}/api/orders/details`, // The JS will add query params like ?orderId=123
        updateOrderStatus:  `${BASE_URL}/api/orders/update-status`,
        assignRider:        `${BASE_URL}/api/orders/assign`
    };

    // DOM Elements
    const totalOrdersCount = document.getElementById('totalOrdersCount');
    const pendingOrdersCount = document.getElementById('pendingOrdersCount');
    const completedOrdersCount = document.getElementById('completedOrdersCount');
    const cancelledOrdersCount = document.getElementById('cancelledOrdersCount');

    const allOrdersTable = document.getElementById('ordersTable')?.querySelector('tbody');
    const pendingOrdersTable = document.getElementById('pendingOrdersTable')?.querySelector('tbody');
    const completedOrdersTable = document.getElementById('completedOrdersTable')?.querySelector('tbody');

    const orderDetailsModal = new bootstrap.Modal(document.getElementById('orderDetailsModal'));
    const updateStatusModal = new bootstrap.Modal(document.getElementById('updateStatusModal'));

    // Toast Notifications
    const successToast = new bootstrap.Toast(document.getElementById('successToast'));
    const errorToast = new bootstrap.Toast(document.getElementById('errorToast'));

    function showToast(isSuccess, message) {
        if (isSuccess) {
            document.getElementById('toastMessage').innerText = message;
            successToast.show();
        } else {
            document.getElementById('errorMessage').innerText = message;
            errorToast.show();
        }
    }

    // --- Data Fetching and Rendering ---

    async function fetchData(url) {
        try {
            const response = await fetch(url);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return await response.json();
        } catch (error) {
            console.error('Error fetching data:', error);
            showToast(false, 'Failed to fetch data from the server.');
            return null;
        }
    }

    async function postData(url, data) {
        try {
            const response = await fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data)
            });
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return await response.json();
        } catch(error) {
            console.error('Error posting data:', error);
            showToast(false, 'An error occurred while sending data.');
            return null;
        }
    }


    function loadDashboardStats() {
        fetchData(API_ENDPOINTS.getDashboardStats).then(data => {
            if (data) {
                totalOrdersCount.textContent = data.totalOrders || 0;
                pendingOrdersCount.textContent = data.pendingOrders || 0;
                completedOrdersCount.textContent = data.completedOrders || 0;
                cancelledOrdersCount.textContent = data.cancelledOrders || 0;
            }
        });
    }

    function renderOrders(tableBody, orders, type) {
        tableBody.innerHTML = '';
        if (!orders || orders.length === 0) {
            const colspan = tableBody.parentElement.querySelector('thead tr').children.length;
            tableBody.innerHTML = `<tr><td colspan="${colspan}" class="text-center">No orders found.</td></tr>`;
            return;
        }

        orders.forEach(order => {
            let rowHtml = '';
            // Customize row based on order type (all, pending, completed)
            switch (type) {
                case 'pending':
                    rowHtml = createPendingOrderRow(order);
                    break;
                case 'completed':
                    rowHtml = createCompletedOrderRow(order);
                    break;
                default:
                    rowHtml = createAllOrderRow(order);
            }
            tableBody.insertAdjacentHTML('beforeend', rowHtml);
        });
    }

    // --- Row Creation Functions ---

    function createAllOrderRow(order) {
        const statusClass = getStatusClass(order.status);
        const riderName = order.rider ? order.rider.name : '<span class="text-muted">Not assigned</span>';

        return `
            <tr>
                <td>#${order.orderId}</td>
                <td>${order.customer.name}</td>
                <td>₹${order.totalAmount.toFixed(2)}</td>
                <td class="address-truncate" title="${order.deliveryAddress}">${order.deliveryAddress}</td>
                <td><span class="status-indicator ${statusClass}">${order.status.replace('_', ' ')}</span></td>
                <td>${riderName}</td>
                <td>
                    <div class="btn-group btn-group-sm" role="group">
                        <button class="btn btn-outline-primary" onclick="viewOrderDetails('${order.orderId}')"><i class="fas fa-eye"></i></button>
                        <button class="btn btn-outline-success" onclick="openUpdateStatusModal('${order.orderId}', '${order.status}')"><i class="fas fa-sync-alt"></i></button>
                    </div>
                </td>
            </tr>
        `;
    }

    function createPendingOrderRow(order) {
        const orderTime = new Date(order.orderTime).toLocaleString();
        return `
            <tr>
                <td>#${order.orderId}</td>
                <td>${order.customer.name}</td>
                <td>₹${order.totalAmount.toFixed(2)}</td>
                <td class="address-truncate" title="${order.deliveryAddress}">${order.deliveryAddress}</td>
                <td>${order.distance} km</td>
                <td>${orderTime}</td>
                <td>
                    <div class="btn-group btn-group-sm" role="group">
                        <button class="btn btn-outline-primary" onclick="viewOrderDetails('${order.orderId}')"><i class="fas fa-eye"></i></button>
                        <button class="btn btn-outline-success" onclick="assignToMe('${order.orderId}')"><i class="fas fa-user-check me-1"></i>Accept</button>
                    </div>
                </td>
            </tr>
        `;
    }

    function createCompletedOrderRow(order) {
        const completedTime = new Date(order.completedTime).toLocaleString();
        const ratingStars = getRatingStars(order.rating);
        return `
             <tr>
                <td>#${order.orderId}</td>
                <td>${order.customer.name}</td>
                <td>₹${order.totalAmount.toFixed(2)}</td>
                <td>${completedTime}</td>
                <td><div class="rating-stars">${ratingStars}</div></td>
                <td>
                    <div class="btn-group btn-group-sm" role="group">
                        <button class="btn btn-outline-primary" onclick="viewOrderDetails('${order.orderId}')"><i class="fas fa-eye"></i></button>
                    </div>
                </td>
            </tr>
        `;
    }

    function getStatusClass(status) {
        switch (status) {
            case 'PENDING': return 'status-pending';
            case 'DELIVERED': return 'status-delivered';
            case 'CANCELLED': return 'status-cancelled';
            case 'IN_TRANSIT': return 'status-in_transit';
            default: return '';
        }
    }

    function getRatingStars(rating) {
        let stars = '';
        for(let i = 1; i <= 5; i++) {
            stars += `<i class="fas fa-star${i <= rating ? '' : '-empty'}"></i>`;
        }
        return stars;
    }


    // --- Modal Handling ---

    window.viewOrderDetails = function(orderId) {
        const modalBody = document.querySelector('#orderDetailsModal .modal-body');
        modalBody.innerHTML = '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading...</div>';
        orderDetailsModal.show();

        fetchData(`${API_ENDPOINTS.getOrderDetails}?orderId=${orderId}`).then(data => {
            if (data) {
                document.getElementById('orderDetailId').textContent = data.orderId;
                // Complex render function for all details inside the modal
                renderOrderDetails(modalBody, data);
            } else {
                 modalBody.innerHTML = '<div class="alert alert-danger">Could not load order details.</div>';
            }
        });
    }

    function renderOrderDetails(container, order) {
        // This function would build the complex HTML for the order details modal
        // For brevity, a simplified version is shown here
        container.innerHTML = `
            <div class="row">
                <div class="col-md-6">
                    <h5>Customer Details</h5>
                    <p><strong>Name:</strong> ${order.customer.name}</p>
                    <p><strong>Address:</strong> ${order.deliveryAddress}</p>
                    <p><strong>Phone:</strong> ${order.customer.phone}</p>
                </div>
                <div class="col-md-6">
                     <h5>Order Summary</h5>
                    <p><strong>Status:</strong> ${order.status}</p>
                    <p><strong>Total Amount:</strong> ₹${order.totalAmount.toFixed(2)}</p>
                    <p><strong>Payment Method:</strong> ${order.paymentMethod}</p>
                </div>
            </div>
            <hr>
            <h5>Order Items</h5>
            <table class="table table-sm">
                <thead><tr><th>Item</th><th>Qty</th><th>Price</th></tr></thead>
                <tbody>
                    ${order.items.map(item => `<tr><td>${item.name}</td><td>${item.quantity}</td><td>₹${item.price.toFixed(2)}</td></tr>`).join('')}
                </tbody>
            </table>
        `;
    }

    window.openUpdateStatusModal = function(orderId, currentStatus) {
        document.getElementById('statusUpdateOrderId').value = orderId;
        document.getElementById('currentStatusDisplay').textContent = currentStatus.replace('_', ' ');
        updateStatusModal.show();
    }

     document.getElementById('updateStatusBtn').addEventListener('click', function() {
        const orderId = document.getElementById('statusUpdateOrderId').value;
        const newStatus = document.getElementById('statusSelect').value;

        const payload = { orderId, newStatus };
        // Add more fields to payload if needed (e.g., reason, proof)

        postData(API_ENDPOINTS.updateOrderStatus, payload).then(response => {
            if (response && response.success) {
                showToast(true, 'Order status updated successfully.');
                updateStatusModal.hide();
                // Refresh relevant tables
                loadAllOrders();
            } else {
                showToast(false, response ? response.message : 'Failed to update status.');
            }
        });
    });

    window.assignToMe = function(orderId) {
        if(confirm(`Are you sure you want to accept order #${orderId}?`)) {
            postData(API_ENDPOINTS.assignRider, { orderId }).then(response => {
                if (response && response.success) {
                    showToast(true, 'Order assigned successfully.');
                    loadPendingOrders(); // Refresh pending list
                } else {
                    showToast(false, response ? response.message : 'Failed to assign order.');
                }
            });
        }
    }


    // --- Tab Switching and Initial Load ---

    function loadAllOrders() {
        fetchData(API_ENDPOINTS.getAllOrders).then(data => renderOrders(allOrdersTable, data, 'all'));
    }

    function loadPendingOrders() {
         fetchData(API_ENDPOINTS.getPendingOrders).then(data => renderOrders(pendingOrdersTable, data, 'pending'));
    }

    function loadCompletedOrders() {
         fetchData(API_ENDPOINTS.getCompletedOrders).then(data => renderOrders(completedOrdersTable, data, 'completed'));
    }

    // Add event listeners for tab clicks to reload data
    document.getElementById('all-orders-tab').addEventListener('shown.bs.tab', loadAllOrders);
    document.getElementById('pending-tab').addEventListener('shown.bs.tab', loadPendingOrders);
    document.getElementById('completed-tab').addEventListener('shown.bs.tab', loadCompletedOrders);

    // Initial Load
    loadDashboardStats();
    loadAllOrders(); // Load the default active tab's data
});