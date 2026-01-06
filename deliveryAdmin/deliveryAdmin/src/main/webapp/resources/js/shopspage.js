document.addEventListener('DOMContentLoaded', function () {
    // ===================================================================
    // API ENDPOINTS
    // ===================================================================
    const API_BASE = 'http://localhost:8080';
    const VENDORS_API = API_BASE + '/vendor';
    const VENDOR_REGISTER_API = VENDORS_API + '/register';
    const ADMIN_VENDORS_API = API_BASE + '/deliveryAdmin/api/dashboard/all-shops';
    const ADMIN_VENDORS_GLOBAL_SEARCH = API_BASE + '/deliveryAdmin/api/dashboard/search';
    const DELETE_VENDOR_API = (id) => `${VENDORS_API}/${id}`;
    const VENDOR_STATUS_API = (id) => `${VENDORS_API}/admin/${id}/status`;
    const VENDOR_DASHBOARD_API = (id) => `${VENDORS_API}/dashboard?vendor_id=${id}`;
    const API_BASE_LOC = 'http://113.11.231.115:8080/api';
    const LOCATION_API = {
        countries: `${API_BASE_LOC}/address/countries`,
        states: `${API_BASE_LOC}/address/states`,
        districts: `${API_BASE_LOC}/address/districts`,
        cities: `${API_BASE_LOC}/address/cities`
    };

    // ===================================================================
    // DOM & STATE VARIABLES
    // ===================================================================
    const shopsTableBody = document.getElementById('shopsTableBody');
    const vendorDashboardStatsContainer = document.getElementById('vendor-dashboard-stats');
    const shopStatsContainer = document.getElementById('shop-stats-container');
    const vendorForm = document.getElementById('vendorForm');
    const addShopModalEl = document.getElementById('addShopModal');
    const addShopModal = new bootstrap.Modal(addShopModalEl);
    const deleteModalEl = document.getElementById('deleteConfirmationModal');
    const deleteModal = new bootstrap.Modal(deleteModalEl);
    const filterLinks = document.querySelectorAll('.filter-shops');
    const filterStatusText = document.getElementById('filterStatusText');

    let allVendors = [];
    let currentFilters = { status: 'all', availability: 'all' };

    // ===================================================================
    // UTILITY FUNCTIONS
    // ===================================================================
    const showTableLoading = () => { shopsTableBody.innerHTML = `<tr><td colspan="5" class="text-center p-5"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></td></tr>`; };
    const formatCurrency = (amount) => new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', maximumFractionDigits: 0 }).format(amount || 0);
    const formatNumber = (num) => (num >= 1000 ? `${(num / 1000).toFixed(1)}k` : (num || 0).toString());
    const showToastMessage = (message, type = 'success') => {
        let toastContainer = document.getElementById('toast-container');
        if (!toastContainer) {
            toastContainer = document.createElement('div');
            toastContainer.id = 'toast-container';
            toastContainer.className = 'position-fixed top-0 end-0 p-3';
            toastContainer.style.zIndex = '1056';
            document.body.appendChild(toastContainer);
        }
        const toastEl = document.createElement('div');
        toastEl.className = `toast align-items-center text-white bg-${type} border-0`;
        toastEl.setAttribute('role', 'alert');
        toastEl.setAttribute('aria-live', 'assertive');
        toastEl.setAttribute('aria-atomic', 'true');
        toastEl.innerHTML = `<div class="d-flex"><div class="toast-body">${message}</div><button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button></div>`;
        toastContainer.appendChild(toastEl);
        const toast = new bootstrap.Toast(toastEl, { delay: 3000 });
        toast.show();
        toastEl.addEventListener('hidden.bs.toast', () => { toastEl.remove(); });
    };

    // ===================================================================
    // API FETCHING
    // ===================================================================
    const fetchAPI = async (url, options = {}) => {
        const username = 'user';
        const password = 'user';
        const headers = { ...options.headers, 'Authorization': 'Basic ' + btoa(`${username}:${password}`) };

        try {
            const fetchOptions = { ...options, headers, cache: 'no-cache' };
            const response = await fetch(url, fetchOptions);

            if (!response.ok) {
                const errorData = await response.json().catch(() => ({ message: response.statusText }));
                throw new Error(errorData.message || `HTTP error! status: ${response.status}`);
            }
            if (response.status === 204 || response.headers.get('content-length') === '0') {
                return true;
            }
            return response.json();

        } catch (error) {
            // Re-throw the error so that Promise.allSettled can catch it as a 'rejected' promise.
            // This is essential for the graceful error handling in the dashboard calculation.
            throw error;
        }
    };

    // ===================================================================
    // DATA FETCHING & PROCESSING
    // ===================================================================
    const fetchShops = async () => {
        showTableLoading();
        try {
            const vendors = await fetchAPI(ADMIN_VENDORS_API);
            if (!vendors || !Array.isArray(vendors)) {
                shopsTableBody.innerHTML = `<tr><td colspan="5" class="text-center p-4">No shops found or failed to load data.</td></tr>`;
                allVendors = [];
                applyFiltersAndRender();
                calculateAndRenderOverallStats([]);
                calculateAndRenderAggregatedDashboard([]);
                return;
            }

            const statusPromises = vendors.map(vendor => fetchAPI(VENDOR_STATUS_API(vendor.vendorId)).catch(() => null));
            const statusResults = await Promise.all(statusPromises);

            allVendors = vendors.map((vendor, index) => {
                const statusInfo = statusResults[index];
                return (statusInfo && statusInfo.vendorId === vendor.vendorId) ? { ...vendor, isApproved: statusInfo.isApproved } : vendor;
            });

            applyFiltersAndRender();
            calculateAndRenderOverallStats(allVendors);
            calculateAndRenderAggregatedDashboard(allVendors);
        } catch (error) {
            showToastMessage(`Error loading vendors: ${error.message}`, 'danger');
            shopsTableBody.innerHTML = `<tr><td colspan="5" class="text-center p-4 text-danger">Could not load shop data.</td></tr>`;
        }
    };

const fetchGlobalSearchShops = async (search = '') => {
    showTableLoading();
    try {
        const url = search
            ? `${ADMIN_VENDORS_GLOBAL_SEARCH}?search=${encodeURIComponent(search)}`
            : ADMIN_VENDORS_API;

        const vendors = await fetchAPI(url);

        if (!vendors || !Array.isArray(vendors)) {
            shopsTableBody.innerHTML = `
                <tr>
                    <td colspan="5" class="text-center p-4">
                        No shops found.
                    </td>
                </tr>`;
            allVendors = [];
            applyFiltersAndRender();
            calculateAndRenderOverallStats([]);
            calculateAndRenderAggregatedDashboard([]);
            return;
        }

        const statusPromises = vendors.map(vendor =>
            fetchAPI(VENDOR_STATUS_API(vendor.vendorId)).catch(() => null)
        );

        const statusResults = await Promise.all(statusPromises);

        allVendors = vendors.map((vendor, index) => {
            const statusInfo = statusResults[index];
            return (statusInfo && statusInfo.vendorId === vendor.vendorId)
                ? { ...vendor, isApproved: statusInfo.isApproved }
                : vendor;
        });

        applyFiltersAndRender();
        calculateAndRenderOverallStats(allVendors);
        calculateAndRenderAggregatedDashboard(allVendors);

    } catch (error) {
        showToastMessage(`Error loading vendors: ${error.message}`, 'danger');
        shopsTableBody.innerHTML = `
            <tr>
                <td colspan="5" class="text-center p-4 text-danger">
                    Could not load shop data.
                </td>
            </tr>`;
    }
};

    // ===================================================================
    // FILTERING LOGIC
    // ===================================================================
    const applyFiltersAndRender = () => {
        let filteredVendors = [...allVendors];

        if (currentFilters.status === 'ACCEPTED') {
            filteredVendors = filteredVendors.filter(v => v.isApproved === true);
        } else if (currentFilters.status === 'PENDING') {
            filteredVendors = filteredVendors.filter(v => v.isApproved !== true);
        }

        if (currentFilters.availability === 'true') {
            filteredVendors = filteredVendors.filter(v => v.isActive === 'Y');
        } else if (currentFilters.availability === 'false') {
            filteredVendors = filteredVendors.filter(v => v.isActive !== 'Y');
        }

        renderShopsTable(filteredVendors);
    };

    // ===================================================================
    // RENDER FUNCTIONS
    // ===================================================================
    const renderShopsTable = (vendors) => {
        if (!vendors || vendors.length === 0) {
            shopsTableBody.innerHTML = `<tr><td colspan="5" class="text-center p-4 text-muted">No shops match the current filter.</td></tr>`;
            return;
        }
        const IMAGE_BASE_URL = 'http://113.11.231.115:8080/';
        shopsTableBody.innerHTML = vendors.map(shop => {
            const status = shop.isApproved === true ? 'Accepted' : 'Pending';
            const statusClass = shop.isApproved === true ? 'accepted' : 'pending';
            const isAvailable = shop.isActive === 'Y';
            const availabilityText = isAvailable ? 'Available' : 'Unavailable';
            const availabilityClass = isAvailable ? 'available' : 'unavailable';
            const imageUrl = shop.shopPhoto ? `${IMAGE_BASE_URL}${shop.shopPhoto}` : '/resources/images/default-store.jpg';
            return `
                <tr class="animate-on-load">
                    <td class="ps-4">
                        <div class="d-flex align-items-center vendor-info">
                            <img src="${imageUrl}" class="rounded-circle me-3" alt="${shop.vendorName || 'N/A'}" onerror="this.onerror=null;this.src='/resources/images/default-store.jpg';">
                            <div>
                                <h6>${shop.vendorInfo || 'Unnamed Vendor'}</h6>
                                <small class="text-muted">ID: ${shop.vendorId}</small>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div>${shop.email || '-'}</div>
                        <small class="text-muted">${shop.contactDetails || '-'}</small>
                    </td>
                    <td><span class="badge-status ${statusClass}">${status}</span></td>
                    <td><span class="badge-avail ${availabilityClass}">${availabilityText}</span></td>
                    <td class="text-center">
                        <div class="btn-group btn-group-sm" role="group">
                            <a href="viewshop?id=${shop.vendorId}" class="btn btn-outline-primary" title="View"><i class="fas fa-eye"></i></a>
                            <a href="editshop?id=${shop.vendorId}" class="btn btn-outline-secondary" title="Edit"><i class="fas fa-edit"></i></a>
                            <a href="shopspage-admin-actions?id=${shop.vendorId}" class="btn btn-outline-info" title="Actions"><i class="fas fa-user-shield"></i></a>
                            <button class="btn btn-outline-danger delete-vendor" data-vendor-id="${shop.vendorId}" title="Delete"><i class="fas fa-trash"></i></button>
                        </div>
                    </td>
                </tr>`;
        }).join('');
    };

    const calculateAndRenderOverallStats = (vendors) => {
        const stats = vendors.reduce((acc, v) => {
            acc.totalShops++;
            if (v.isApproved === true) acc.acceptedShops++; else acc.pendingShops++;
            if (v.isActive === 'Y') acc.activeShops++;
            return acc;
        }, { totalShops: 0, acceptedShops: 0, pendingShops: 0, activeShops: 0 });

        shopStatsContainer.innerHTML = `
            <div class="row mb-4">
                <div class="col-xl-3 col-md-6 mb-4 animate-on-load"><div class="card bg-primary text-white h-100"><div class="card-body"><div class="d-flex justify-content-between align-items-center"><div><h6 class="mb-0">Total Shops</h6><h3 class="mb-0">${formatNumber(stats.totalShops)}</h3></div><i class="fas fa-store fa-2x"></i></div></div></div></div>
                <div class="col-xl-3 col-md-6 mb-4 animate-on-load" style="animation-delay: 0.1s;"><div class="card bg-success text-white h-100"><div class="card-body"><div class="d-flex justify-content-between align-items-center"><div><h6 class="mb-0">Accepted</h6><h3 class="mb-0">${formatNumber(stats.acceptedShops)}</h3></div><i class="fas fa-check-circle fa-2x"></i></div></div></div></div>
                <div class="col-xl-3 col-md-6 mb-4 animate-on-load" style="animation-delay: 0.2s;"><div class="card bg-warning text-white h-100"><div class="card-body"><div class="d-flex justify-content-between align-items-center"><div><h6 class="mb-0">Pending</h6><h3 class="mb-0">${formatNumber(stats.pendingShops)}</h3></div><i class="fas fa-hourglass-half fa-2x"></i></div></div></div></div>
                <div class="col-xl-3 col-md-6 mb-4 animate-on-load" style="animation-delay: 0.3s;"><div class="card bg-info text-white h-100"><div class="card-body"><div class="d-flex justify-content-between align-items-center"><div><h6 class="mb-0">Currently Active</h6><h3 class="mb-0">${formatNumber(stats.activeShops)}</h3></div><i class="fas fa-power-off fa-2x"></i></div></div></div></div>
            </div>`;
    };

    const calculateAndRenderAggregatedDashboard = async (vendors) => {
        if (vendors.length === 0) {
            renderDashboardStats({});
            return;
        }
        const promises = vendors.map(vendor => fetchAPI(VENDOR_DASHBOARD_API(vendor.vendorId)));
        const results = await Promise.allSettled(promises);

        const finalStats = results.reduce((acc, result) => {
            if (result.status === 'fulfilled' && result.value) {
                const data = result.value;
                acc.completedOrders += data.orders?.completed || 0;
                acc.pendingOrders += data.orders?.pending || 0;
                acc.cancelledOrders += data.orders?.cancelled || 0;
                acc.totalEarnings += data.earnings?.this_month || 0;
            } else if (result.status === 'rejected') {
                // Gracefully handle the backend error. Log it for developers but don't stop the page.
                console.warn(`Could not load dashboard stats for a vendor. Reason:`, result.reason.message);
            }
            return acc;
        }, { completedOrders: 0, pendingOrders: 0, cancelledOrders: 0, totalEarnings: 0 });

        finalStats.totalOrders = finalStats.completedOrders + finalStats.pendingOrders + finalStats.cancelledOrders;
        renderDashboardStats(finalStats);
    };

    const renderDashboardStats = (stats) => {
        const container = document.getElementById('vendor-dashboard-stats');
        if (!container) return;
        const { totalEarnings = 0, totalOrders = 0, completedOrders = 0, pendingOrders = 0, cancelledOrders = 0 } = stats;
        container.innerHTML = `
            <div class="col-lg-5 mb-4 mb-lg-0"><div class="card hero-stat-card h-100"><div class="card-body"><i class="fas fa-rupee-sign hero-icon"></i><h6>Total Earnings (This Month)</h6><h3>${formatCurrency(totalEarnings)}</h3><p class="mb-0 small">Aggregated from all active vendors.</p></div></div></div>
            <div class="col-lg-7"><div class="row g-3">
                <div class="col-md-6"><div class="mini-stat-card"><div class="stat-icon-wrapper bg-primary-light"><i class="fas fa-box"></i></div><div class="ms-3"><h4>${formatNumber(totalOrders)}</h4><p class="mb-0">Total Orders</p></div></div></div>
                <div class="col-md-6"><div class="mini-stat-card"><div class="stat-icon-wrapper bg-success-light"><i class="fas fa-check-circle"></i></div><div class="ms-3"><h4>${formatNumber(completedOrders)}</h4><p class="mb-0">Completed</p></div></div></div>
                <div class="col-md-6"><div class="mini-stat-card"><div class="stat-icon-wrapper bg-warning-light"><i class="fas fa-hourglass-half"></i></div><div class="ms-3"><h4>${formatNumber(pendingOrders)}</h4><p class="mb-0">Pending</p></div></div></div>
                <div class="col-md-6"><div class="mini-stat-card"><div class="stat-icon-wrapper bg-danger-light"><i class="fas fa-times-circle"></i></div><div class="ms-3"><h4>${formatNumber(cancelledOrders)}</h4><p class="mb-0">Cancelled</p></div></div></div>
            </div></div>`;
    };

    // ===================================================================
    // EVENT HANDLERS & MODAL LOGIC
    // ===================================================================
    filterLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const type = this.dataset.filterType;
            const value = this.dataset.filterValue;
            let filterText = 'All Shops';
            if (value === 'all') {
                 currentFilters.status = 'all';
                 currentFilters.availability = 'all';
            } else if (type === 'status') {
                currentFilters.status = value;
                currentFilters.availability = 'all';
                filterText = `${value.charAt(0).toUpperCase() + value.slice(1).toLowerCase()}`;
            } else if (type === 'availability') {
                currentFilters.availability = value;
                currentFilters.status = 'all';
                filterText = `${value === 'true' ? 'Available' : 'Unavailable'}`;
            }
            filterStatusText.textContent = filterText;
            applyFiltersAndRender();
        });
    });

    shopsTableBody.addEventListener('click', e => {
        const deleteButton = e.target.closest('.delete-vendor');
        if (deleteButton) {
            const shopId = deleteButton.dataset.vendorId;
            document.getElementById('deleteConfirmationMessage').textContent = `Are you sure you want to delete shop #${shopId}? This action cannot be undone.`;
            document.getElementById('confirmDeleteBtn').dataset.shopId = shopId;
            deleteModal.show();
        }
    });
    document.getElementById('searchShopBtn').addEventListener('click', () => {
        const searchValue = document.getElementById('globalShopSearch').value.trim();
        fetchGlobalSearchShops(searchValue);
    });


    document.getElementById('confirmDeleteBtn').addEventListener('click', async function() {
        const shopId = this.dataset.shopId;
        if (!shopId) return;
        try {
            await fetchAPI(DELETE_VENDOR_API(shopId), { method: 'DELETE' });
            showToastMessage(`Vendor #${shopId} deleted successfully.`);
            allVendors = allVendors.filter(vendor => vendor.vendorId != shopId);
            applyFiltersAndRender();
            calculateAndRenderOverallStats(allVendors);
            calculateAndRenderAggregatedDashboard(allVendors);
        } catch (error) {
             showToastMessage(`Failed to delete vendor #${shopId}: ${error.message}`, 'danger');
        } finally {
            deleteModal.hide();
        }
    });

    vendorForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        const formData = new FormData(vendorForm);
        try {
            await fetchAPI(VENDOR_REGISTER_API, { method: 'POST', body: formData });
            addShopModal.hide();
            showToastMessage('Vendor added successfully!');
            fetchShops();
        } catch (error) {
             showToastMessage(`Failed to add vendor: ${error.message}`, 'danger');
        }
    });

    (function() {
        const setupLocationDropdowns = () => {
            const countrySelect = vendorForm.querySelector('select[name="countryId"]');
            const stateSelect = vendorForm.querySelector('select[name="stateId"]');
            const districtSelect = vendorForm.querySelector('select[name="districtId"]');
            const citySelect = vendorForm.querySelector('select[name="cityId"]');

            const populate = (select, data, valueField, nameField, defaultOption) => {
                if (!select) return;
                select.innerHTML = `<option value="">${defaultOption}</option>`;
                data?.forEach(item => {
                    const option = document.createElement('option');
                    option.value = item[valueField];
                    option.textContent = item[nameField];
                    select.appendChild(option);
                });
                select.disabled = !data || data.length === 0;
            };

            const resetDropdowns = (startLevel) => {
                const levels = ['state', 'district', 'city'];
                const startIndex = levels.indexOf(startLevel);
                if (startIndex !== -1) {
                    for (let i = startIndex; i < levels.length; i++) {
                        const select = vendorForm.querySelector(`select[name="${levels[i]}Id"]`);
                        if (select) {
                            select.innerHTML = `<option value="">Select ${levels[i].charAt(0).toUpperCase() + levels[i].slice(1)}</option>`;
                            select.disabled = true;
                        }
                    }
                }
            };

            countrySelect?.addEventListener('change', async () => {
                resetDropdowns('state');
                const countryId = countrySelect.value;
                if (!countryId) return;
                stateSelect.innerHTML = '<option value="">Loading...</option>';
                const states = await fetchAPI(`${LOCATION_API.states}?countryId=${countryId}`);
                populate(stateSelect, states, 'stateId', 'stateName', 'Select State');
            });

            stateSelect?.addEventListener('change', async () => {
                resetDropdowns('district');
                const stateId = stateSelect.value;
                if (!stateId) return;
                districtSelect.innerHTML = '<option value="">Loading...</option>';
                const districts = await fetchAPI(`${LOCATION_API.districts}?stateId=${stateId}`);
                populate(districtSelect, districts, 'districtId', 'districtName', 'Select District');
            });

            districtSelect?.addEventListener('change', async () => {
                resetDropdowns('city');
                const districtId = districtSelect.value;
                if (!districtId) return;
                citySelect.innerHTML = '<option value="">Loading...</option>';
                const cities = await fetchAPI(`${LOCATION_API.cities}?districtId=${districtId}`);
                populate(citySelect, cities, 'cityId', 'cityName', 'Select City');
            });

            (async () => {
                const countries = await fetchAPI(LOCATION_API.countries);
                populate(countrySelect, countries, 'countryId', 'countryName', 'Select Country');
                const india = countries?.find(c => c.countryName.toLowerCase() === 'india');
                if (india) {
                    countrySelect.value = india.countryId;
                    countrySelect.dispatchEvent(new Event('change'));
                }
            })();
        };
        addShopModalEl.addEventListener('show.bs.modal', setupLocationDropdowns, { once: true });
    })();

    addShopModalEl.addEventListener('hidden.bs.modal', () => {
        vendorForm.reset();
        const firstTab = document.querySelector('#vendorTabs button:first-child');
        if (firstTab) new bootstrap.Tab(firstTab).show();
    });

    // ===================================================================
    // INITIALIZATION
    // ===================================================================
    fetchShops();
});