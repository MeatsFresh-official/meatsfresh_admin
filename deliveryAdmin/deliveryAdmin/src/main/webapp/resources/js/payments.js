document.addEventListener('DOMContentLoaded', function () {
    // =================================================================
    // == CONFIGURE YOUR API BASE URL HERE ==
    // =================================================================
    const BASE_URL = 'https://localhost:8080';
    // =================================================================

    const API_ENDPOINTS = {
        getSummary: `${BASE_URL}/api/payments/summary`,
        getPayments: `${BASE_URL}/api/payments`,
        getPaymentDetails: `${BASE_URL}/api/payments/details`,
        recordCashPayment: `${BASE_URL}/api/payments/cash`,
        processRefund: `${BASE_URL}/api/payments/refund`,
    };

    // --- DOM Elements ---
    const cashCollectedEl = document.getElementById('cashCollected');
    const onlinePaymentsEl = document.getElementById('onlinePayments');
    const totalAmountEl = document.getElementById('totalAmount');
    const paymentsTableBody = document.querySelector('#paymentsTable tbody');
    const searchInput = document.getElementById('paymentSearch');
    const searchBtn = document.getElementById('searchPaymentBtn');
    const timeFilterButtons = document.querySelectorAll('.time-filter');
    const customDateBtn = document.getElementById('customDateBtn');
    const applyDateRangeBtn = document.getElementById('applyDateRange');
    const processRefundBtn = document.getElementById('processRefundBtn');

    // --- Modals ---
    const paymentDetailsModal = new bootstrap.Modal(document.getElementById('paymentDetailsModal'));
    const refundConfirmModal = new bootstrap.Modal(document.getElementById('refundConfirmModal'));
    const addCashPaymentModal = new bootstrap.Modal(document.getElementById('addCashPaymentModal'));
    const dateRangeModal = new bootstrap.Modal(document.getElementById('dateRangeModal'));

    // --- State Management ---
    let currentFilters = {
        time: 'today', // 'today', 'week', 'month', 'custom'
        startDate: '',
        endDate: '',
        search: ''
    };

    // --- Toast Notifications ---
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

    // --- Helper Functions ---
    async function fetchData(url) {
        try {
            const response = await fetch(url);
            if (!response.ok) throw new Error(`HTTP error! Status: ${response.status}`);
            return await response.json();
        } catch (error) {
            console.error("Fetch Error:", error);
            showToast(false, "Failed to fetch data from server.");
            return null;
        }
    }

    async function postData(url, data) {
        try {
            const response = await fetch(url, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            });
            if (!response.ok) {
                const err = await response.json();
                throw new Error(err.message || `HTTP error! Status: ${response.status}`);
            }
            return await response.json();
        } catch (error) {
            console.error("Post Error:", error);
            showToast(false, error.message || "An error occurred while sending data.");
            return null;
        }
    }

    function formatCurrency(amount) {
        if (amount === null || typeof amount === 'undefined') return '₹0.00';
        if (amount >= 1000) {
            return `₹${(amount / 1000).toFixed(1).replace(/\.0$/, '')}k`;
        } else {
            return new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR' }).format(amount);
        }
    }

    function buildQueryString(params) {
        const query = new URLSearchParams();
        for (const key in params) {
            if (params[key]) query.append(key, params[key]);
        }
        return query.toString();
    }

    // --- Data Loading & Rendering ---
    function loadSummary() {
        const query = buildQueryString({ time: currentFilters.time, startDate: currentFilters.startDate, endDate: currentFilters.endDate });
        fetchData(`${API_ENDPOINTS.getSummary}?${query}`).then(data => {
            if (data) {
                cashCollectedEl.textContent = formatCurrency(data.cashCollected);
                onlinePaymentsEl.textContent = formatCurrency(data.onlinePayments);
                totalAmountEl.textContent = formatCurrency(data.totalAmount);
            }
        });
    }

    function loadPayments() {
        paymentsTableBody.innerHTML = `<tr><td colspan="7" class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading payments...</td></tr>`;
        const query = buildQueryString(currentFilters);
        fetchData(`${API_ENDPOINTS.getPayments}?${query}`).then(data => {
            renderPaymentsTable(data ? data.payments : []);
        });
    }

    function renderPaymentsTable(payments) {
        paymentsTableBody.innerHTML = '';
        if (!payments || payments.length === 0) {
            paymentsTableBody.innerHTML = `<tr><td colspan="7" class="text-center p-5 text-muted">No payment transactions found.</td></tr>`;
            return;
        }
        payments.forEach((payment, index) => {
            const row = `
                <tr style="animation: fadeInUp 0.3s ease forwards; animation-delay: ${index * 0.05}s; opacity: 0;">
                    <td class="ps-4 fw-medium text-primary">${payment.transactionId}</td>
                    <td class="text-secondary small">${new Date(payment.date).toLocaleString('en-IN')}</td>
                    <td>
                        <div class="d-flex align-items-center">
                             <div class="rounded-circle bg-light text-primary d-flex align-items-center justify-content-center me-3" style="width: 35px; height: 35px; font-weight: 700; font-size: 0.8rem;">
                                ${payment.customerName.charAt(0).toUpperCase()}
                            </div>
                            <div>
                                <h6 class="mb-0 text-dark" style="font-size: 0.9rem;">${payment.customerName}</h6>
                                <small class="text-muted" style="font-size: 0.75rem;">Order #${payment.orderId}</small>
                            </div>
                        </div>
                    </td>
                    <td class="fw-bold text-dark">${formatCurrency(payment.amount)}</td>
                    <td><div class="badge-div bg-${payment.method.toLowerCase()} shadow-sm">${payment.method}</div></td>
                    <td><div class="badge-div bg-${payment.status.toLowerCase()} shadow-sm">${payment.status}</div></td>
                    <td class="text-center pe-4">
                        <div class="btn-group btn-group-sm" role="group">
                            <button class="btn btn-white shadow-sm text-primary hover-scale rounded-start" onclick="viewPaymentDetails('${payment.id}')" title="View Details"><i class="fas fa-eye"></i></button>
                            ${payment.status === 'COMPLETED' && payment.method !== 'CASH' ?
                    `<button class="btn btn-white shadow-sm text-danger hover-scale rounded-end" onclick="confirmRefund('${payment.id}', ${payment.amount})" title="Refund"><i class="fas fa-undo"></i></button>` : ''
                }
                        </div>
                    </td>
                </tr>`;
            paymentsTableBody.insertAdjacentHTML('beforeend', row);
        });
    }

    function refreshData() {
        loadSummary();
        loadPayments();
    }

    // --- Event Handlers ---
    timeFilterButtons.forEach(button => {
        button.addEventListener('click', () => {
            timeFilterButtons.forEach(btn => {
                btn.classList.remove('active', 'text-white', 'btn-primary');
                btn.classList.add('text-muted');
            });
            customDateBtn.classList.remove('text-primary');
            customDateBtn.classList.add('text-muted');

            button.classList.remove('text-muted');
            button.classList.add('active'); // CSS handles active state styling

            currentFilters.time = button.dataset.filter;
            currentFilters.startDate = '';
            currentFilters.endDate = '';
            refreshData();
        });
    });

    applyDateRangeBtn.addEventListener('click', () => {
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;
        if (startDate && endDate) {
            timeFilterButtons.forEach(btn => btn.classList.remove('active'));
            customDateBtn.classList.add('active');
            currentFilters.time = 'custom';
            currentFilters.startDate = startDate;
            currentFilters.endDate = endDate;
            refreshData();
            dateRangeModal.hide();
        } else {
            showToast(false, "Please select both a start and end date.");
        }
    });

    searchBtn.addEventListener('click', () => {
        currentFilters.search = searchInput.value.trim();
        refreshData();
    });

    searchInput.addEventListener('keyup', (event) => {
        if (event.key === 'Enter') searchBtn.click();
    });

    document.getElementById('addCashPaymentForm').addEventListener('submit', function (event) {
        event.preventDefault();
        const data = Object.fromEntries(new FormData(this).entries());
        postData(API_ENDPOINTS.recordCashPayment, data).then(response => {
            if (response) {
                showToast(true, 'Cash payment recorded successfully!');
                addCashPaymentModal.hide();
                this.reset();
                refreshData();
            }
        });
    });

    processRefundBtn.addEventListener('click', () => {
        const paymentId = document.getElementById('refundPaymentId').value;
        const amount = document.getElementById('refundAmount').value;
        const reason = document.getElementById('refundReason').value;
        postData(API_ENDPOINTS.processRefund, { paymentId, amount, reason }).then(response => {
            if (response) {
                showToast(true, 'Refund processed successfully.');
                refundConfirmModal.hide();
                refreshData();
            }
        });
    });

    // --- Global Functions for Button Clicks ---
    window.viewPaymentDetails = function (paymentId) {
        paymentDetailsModal.show();
        const loader = document.getElementById('paymentDetailLoader');
        const content = document.getElementById('paymentDetailContent');
        loader.classList.remove('d-none');
        content.classList.add('d-none');

        fetchData(`${API_ENDPOINTS.getPaymentDetails}?id=${paymentId}`).then(data => {
            if (data) {
                document.getElementById('detailTransactionId').textContent = data.transactionId;
                document.getElementById('detailPaymentDate').textContent = new Date(data.date).toLocaleString('en-IN');
                document.getElementById('detailAmount').textContent = formatCurrency(data.amount);
                document.getElementById('detailPaymentMethod').innerHTML = `<div class="badge-div bg-${data.method.toLowerCase()}">${data.method}</div>`;
                document.getElementById('detailPaymentStatus').innerHTML = `<div class="badge-div bg-${data.status.toLowerCase()}">${data.status}</div>`;
                document.getElementById('detailCustomerName').textContent = data.customerName;
                document.getElementById('detailOrderId').textContent = `Order #${data.orderId}`;

                const onlineDetails = document.getElementById('onlinePaymentDetails');
                const cashDetails = document.getElementById('cashPaymentDetails');

                if (data.method !== 'CASH') {
                    onlineDetails.classList.remove('d-none');
                    cashDetails.classList.add('d-none');
                    document.getElementById('detailGatewayRef').textContent = data.gatewayReference || 'N/A';
                    document.getElementById('detailPaymentMode').textContent = data.paymentMode || 'N/A';
                } else {
                    onlineDetails.classList.add('d-none');
                    cashDetails.classList.remove('d-none');
                    document.getElementById('detailCollectedBy').textContent = data.collectedBy || 'N/A';
                    document.getElementById('detailCollectionTime').textContent = new Date(data.collectionTime).toLocaleString('en-IN') || 'N/A';
                }
                loader.classList.add('d-none');
                content.classList.remove('d-none');
            } else {
                paymentDetailsModal.hide();
                showToast(false, "Could not fetch payment details.");
            }
        });
    };

    window.confirmRefund = function (paymentId, amount) {
        document.getElementById('refundPaymentId').value = paymentId;
        document.getElementById('refundAmount').value = amount;
        document.getElementById('refundReason').value = '';
        refundConfirmModal.show();
    };

    // --- Initial Load ---
    refreshData();
});