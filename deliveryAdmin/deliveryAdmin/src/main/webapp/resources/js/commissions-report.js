document.addEventListener('DOMContentLoaded', function () {
    // --- IMPORTANT: REPLACE WITH YOUR API ENDPOINT ---
    const API_BASE_URL = 'https://localhost:8082/api/admin';

    const API_ENDPOINTS = {
        summary: `${API_BASE_URL}/commissions/summary`,
        vendors: `${API_BASE_URL}/commissions/vendors`,
        vendorDetails: (id) => `${API_BASE_URL}/commissions/vendors/${id}`
    };

    // --- DOM ELEMENT REFERENCES ---
    const summaryContainer = document.getElementById('summary-cards-container');
    const commissionsTableBody = document.getElementById('commissionsTableBody');
    const searchInput = document.getElementById('vendorSearchInput');
    const detailsModal = new bootstrap.Modal(document.getElementById('vendorDetailsModal'));
    const dateRangeModal = new bootstrap.Modal(document.getElementById('dateRangeModal'));

    let searchTimeout;
    let currentFilters = {
        range: 'today', // default filter
        startDate: '',
        endDate: '',
        search: ''
    };

    // --- UTILITY FUNCTIONS ---
    const showTableLoading = () => {
        commissionsTableBody.innerHTML = `<tr><td colspan="7" class="text-center p-5"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></td></tr>`;
    };

    const showTableEmpty = (message) => {
        commissionsTableBody.innerHTML = `<tr><td colspan="7" class="text-center p-5 text-muted">${message}</td></tr>`;
    };

    const formatCurrency = (amount) => {
        return new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR' }).format(amount || 0);
    };

    const getApiParams = () => {
        const params = new URLSearchParams();
        if (currentFilters.search) {
            params.append('search', currentFilters.search);
        }

        // Add date range based on the selected filter
        const today = new Date();
        let startDate, endDate = new Date(today.setHours(23, 59, 59, 999));

        switch (currentFilters.range) {
            case 'week':
                startDate = new Date(today.setDate(today.getDate() - today.getDay()));
                break;
            case 'month':
                startDate = new Date(today.getFullYear(), today.getMonth(), 1);
                break;
            case 'custom':
                startDate = new Date(currentFilters.startDate);
                endDate = new Date(currentFilters.endDate);
                break;
            case 'today':
            default:
                startDate = new Date(today.setHours(0, 0, 0, 0));
                break;
        }

        if (startDate) params.append('startDate', startDate.toISOString().split('T')[0]);
        if (endDate) params.append('endDate', endDate.toISOString().split('T')[0]);

        return params;
    };

    // --- API FETCH FUNCTIONS ---

    const fetchSummary = async () => {
        const params = getApiParams();
        try {
            const response = await fetch(`${API_ENDPOINTS.summary}?${params.toString()}`);
            if (!response.ok) throw new Error('Failed to load summary');
            const summary = await response.json();
            renderSummaryCards(summary);
        } catch (error) {
            console.error("Error fetching summary:", error);
            summaryContainer.innerHTML = `<div class="col-12"><div class="alert alert-danger">Could not load summary data.</div></div>`;
        }
    };

    const fetchVendorCommissions = async () => {
        showTableLoading();
        const params = getApiParams();
        try {
            const response = await fetch(`${API_ENDPOINTS.vendors}?${params.toString()}`);
            if (!response.ok) throw new Error('Failed to load commissions');
            const vendors = await response.json();
            renderCommissionsTable(vendors);
        } catch (error) {
            console.error("Error fetching commissions:", error);
            showTableEmpty('Could not load vendor commissions.');
        }
    };

    // --- RENDER FUNCTIONS ---

    const renderSummaryCards = (summary) => {
        summaryContainer.innerHTML = `
            <div class="col-xl-4 col-md-6 mb-4">
                <div class="card bg-primary text-white h-100">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div><h6 class="mb-0">Total Revenue</h6><h3 class="mb-0">${formatCurrency(summary.totalRevenue)}</h3></div>
                        <i class="fas fa-money-bill-wave fa-2x"></i>
                    </div>
                </div>
            </div>
            <div class="col-xl-4 col-md-6 mb-4">
                <div class="card bg-success text-white h-100">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div><h6 class="mb-0">Vendor Earnings</h6><h3 class="mb-0">${formatCurrency(summary.vendorEarnings)}</h3></div>
                        <i class="fas fa-store fa-2x"></i>
                    </div>
                </div>
            </div>
            <div class="col-xl-4 col-md-6 mb-4">
                <div class="card bg-warning text-dark h-100">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div><h6 class="mb-0">Admin Commission</h6><h3 class="mb-0">${formatCurrency(summary.adminCommission)}</h3></div>
                        <i class="fas fa-hand-holding-usd fa-2x"></i>
                    </div>
                </div>
            </div>
        `;
    };

    const renderCommissionsTable = (vendors) => {
        if (!vendors || vendors.length === 0) {
            showTableEmpty('No vendor commissions found for the selected period.');
            return;
        }

        commissionsTableBody.innerHTML = vendors.map(vendor => `
            <tr data-vendor-id="${vendor.id}">
                <td>
                    <div class="d-flex align-items-center">
                        <img src="${vendor.profileImage || '/resources/images/default-store.jpg'}" class="rounded-circle me-3" width="40" height="40" alt="${vendor.name}">
                        <div>
                            <h6 class="mb-0">${vendor.name}</h6>
                            <small class="text-muted">ID: ${vendor.id}</small>
                        </div>
                    </div>
                </td>
                <td>${vendor.productsSold}</td>
                <td>${formatCurrency(vendor.totalSales)}</td>
                <td>${vendor.commissionRate}%</td>
                <td class="text-danger fw-bold">${formatCurrency(vendor.commissionAmount)}</td>
                <td class="text-success fw-bold">${formatCurrency(vendor.vendorEarnings)}</td>
                <td>
                    <button class="btn btn-sm btn-outline-primary action-btn" data-action="details"><i class="fas fa-eye me-1"></i> Details</button>
                    <button class="btn btn-sm btn-outline-secondary action-btn" data-action="invoice"><i class="fas fa-file-invoice me-1"></i> Invoice</button>
                </td>
            </tr>
        `).join('');
    };

    const renderVendorDetailsModal = async (vendorId) => {
        const modalBody = document.getElementById('vendorDetailsBody');
        modalBody.innerHTML = `<div class="text-center p-5"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></div>`;
        detailsModal.show();

        try {
            const response = await fetch(API_ENDPOINTS.vendorDetails(vendorId) + `?${getApiParams().toString()}`);
            if (!response.ok) throw new Error('Failed to load vendor details');
            const data = await response.json();

            modalBody.innerHTML = `
                <!-- Vendor Info -->
                <div class="row mb-4">
                    <div class="col-md-6"><div class="d-flex align-items-center mb-3">
                        <img src="${data.profileImage || '/resources/images/default-store.jpg'}" class="rounded-circle me-3" width="60" height="60" alt="${data.name}">
                        <div><h5 class="mb-0">${data.name}</h5><small class="text-muted">ID: ${data.id}</small></div>
                    </div></div>
                    <div class="col-md-6"><div class="card"><div class="card-body">
                        <div class="row mb-2"><div class="col-6">Commission Rate:</div><div class="col-6 text-end fw-bold">${data.commissionRate}%</div></div>
                        <div class="row mb-2"><div class="col-6">Total Sales:</div><div class="col-6 text-end">${formatCurrency(data.totalSales)}</div></div>
                        <div class="row mb-2"><div class="col-6">Commission:</div><div class="col-6 text-end text-danger">${formatCurrency(data.commissionAmount)}</div></div>
                        <hr class="my-2">
                        <div class="row"><div class="col-6 fw-bold">Vendor Earnings:</div><div class="col-6 text-end fw-bold text-success">${formatCurrency(data.vendorEarnings)}</div></div>
                    </div></div></div>
                </div>

                <!-- Top Products -->
                <h6>Top Selling Products in Period</h6>
                <div class="table-responsive">
                    <table class="table table-sm">
                        <thead><tr><th>Product</th><th>Price</th><th>Sold</th><th>Total</th></tr></thead>
                        <tbody>${data.topProducts.map(p => `
                            <tr>
                                <td>${p.name}</td>
                                <td>${formatCurrency(p.price)}</td>
                                <td>${p.quantitySold}</td>
                                <td>${formatCurrency(p.total)}</td>
                            </tr>`).join('') || `<tr><td colspan="4" class="text-center text-muted">No products sold in this period.</td></tr>`}
                        </tbody>
                    </table>
                </div>`;
        } catch (error) {
            console.error('Error fetching vendor details:', error);
            modalBody.innerHTML = `<div class="alert alert-danger">Could not load vendor details.</div>`;
        }
    };

    // --- EVENT LISTENERS & HANDLERS ---

    function refreshData() {
        fetchSummary();
        fetchVendorCommissions();
    }

    // Quick time filters
    document.querySelectorAll('.time-filter').forEach(button => {
        button.addEventListener('click', () => {
            document.querySelector('.time-filter.active').classList.remove('active');
            button.classList.add('active');
            currentFilters.range = button.dataset.range;
            currentFilters.startDate = '';
            currentFilters.endDate = '';
            document.getElementById('customDateRangeText').textContent = 'Select Custom Range';
            refreshData();
        });
    });

    // Custom date range
    document.getElementById('applyDateRange').addEventListener('click', () => {
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;
        if (startDate && endDate) {
            currentFilters.range = 'custom';
            currentFilters.startDate = startDate;
            currentFilters.endDate = endDate;

            document.querySelector('.time-filter.active')?.classList.remove('active');
            const startFormatted = new Date(startDate).toLocaleDateString('en-GB');
            const endFormatted = new Date(endDate).toLocaleDateString('en-GB');
            document.getElementById('customDateRangeText').textContent = `${startFormatted} - ${endFormatted}`;

            dateRangeModal.hide();
            refreshData();
        }
    });

    // Search input handler
    searchInput.addEventListener('keyup', () => {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(() => {
            currentFilters.search = searchInput.value.trim();
            fetchVendorCommissions();
        }, 500); // Debounce for 500ms
    });

    // Table action buttons handler
    commissionsTableBody.addEventListener('click', (e) => {
        const actionBtn = e.target.closest('.action-btn');
        if (!actionBtn) return;

        const vendorId = actionBtn.closest('tr').dataset.vendorId;
        const action = actionBtn.dataset.action;

        if (action === 'details') {
            renderVendorDetailsModal(vendorId);
        } else if (action === 'invoice') {
            alert(`Generating invoice for vendor #${vendorId}...`);
            // Add actual invoice generation logic here
        }
    });

    // Initial data load
    refreshData();
});