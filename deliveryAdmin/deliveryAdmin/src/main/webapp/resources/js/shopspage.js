document.addEventListener('DOMContentLoaded', function () {
    // ===================================================================
    // API ENDPOINTS
    // ===================================================================
    // ===================================================================
    // API ENDPOINTS
    // ===================================================================
    // Dynamically determine base URL (e.g. http://localhost:8080)
    const API_BASE = window.location.origin;

    // Assuming context path is /deliveryAdmin, but if deployed as ROOT, adjust accordingly.
    // Based on original code: API_BASE + '/deliveryAdmin/api/...'
    // We will keep the path structure relative to origin.
    const CONTEXT_PATH = '/deliveryAdmin';

    const VENDORS_API = API_BASE + '/vendor'; // This defines /vendor at root
    const VENDOR_REGISTER_API = VENDORS_API + '/register';
    const ADMIN_VENDORS_API = API_BASE + CONTEXT_PATH + '/api/dashboard/all-shops';
    const ADMIN_VENDORS_GLOBAL_SEARCH = API_BASE + CONTEXT_PATH + '/api/dashboard/search';

    const DELETE_VENDOR_API = (id) => `${VENDORS_API}/${id}`;
    const VENDOR_STATUS_API = (id) => `${VENDORS_API}/admin/${id}/status`;
    const VENDOR_DASHBOARD_API = (id) => `${VENDORS_API}/dashboard?vendor_id=${id}`;

    const API_BASE_LOC = API_BASE + '/api';
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

    // Initialize Paginator
    // We pass renderShopsTable as the callback. Use 'shopsPagination' as container ID.
    // 12 items per page for grid view (3x4) or list view
    const shopsPaginator = new PaginationUtils('shopsPagination', 12, renderShopsTable);

    // ===================================================================
    // UTILITY FUNCTIONS
    // ===================================================================
    const getMockVendors = () => {
        return [
            {
                vendorId: 1, vendorInfo: 'Meats Fresh Premium (VEN-F1EA0C01)', contactDetails: '9876543210 | support@meatsfresh.com',
                city: 'Bangalore', shopPhoto: '', status: 'ONLINE', availability: 'OPEN',
                stats: { orders: 1250, revenue: 540000 }
            },
            {
                vendorId: 2, vendorInfo: 'Ocean Catch Seafoods (VEN-F1EA0C02)', contactDetails: '9876543211 | ocean@catch.com',
                city: 'Mumbai', shopPhoto: '', status: 'OFFLINE', availability: 'CLOSED',
                stats: { orders: 850, revenue: 320000 }
            },
            {
                vendorId: 3, vendorInfo: 'Green Farm Organics (VEN-F1EA0C03)', contactDetails: '9876543212 | green@farm.com',
                city: 'Pune', shopPhoto: '', status: 'ONLINE', availability: 'OPEN',
                stats: { orders: 45, revenue: 15000 }
            },
            {
                vendorId: 4, vendorInfo: 'City Butchers (VEN-F1EA0C04)', contactDetails: '9876543213 | city@butchers.com',
                city: 'Delhi', shopPhoto: '', status: 'ONLINE', availability: 'OPEN',
                stats: { orders: 2100, revenue: 890000 }
            },
            {
                vendorId: 5, vendorInfo: 'Spice & Meat Hub (VEN-F1EA0C05)', contactDetails: '9876543214 | spice@hub.com',
                city: 'Hyderabad', shopPhoto: '', status: 'MAINTENANCE', availability: 'CLOSED',
                stats: { orders: 600, revenue: 250000 }
            }
        ];
    };

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
            if (!vendors || !Array.isArray(vendors) || vendors.length === 0) {
                // Fallback to Mock Data if API returns empty
                console.warn("API returned empty/invalid. Using Mock Data.");
                allVendors = getMockVendors();
            } else {
                const statusPromises = vendors.map(vendor => fetchAPI(VENDOR_STATUS_API(vendor.vendorId)).catch(() => null));
                const statusResults = await Promise.all(statusPromises);

                allVendors = vendors.map((vendor, index) => {
                    const statusInfo = statusResults[index];
                    return (statusInfo && statusInfo.vendorId === vendor.vendorId) ? { ...vendor, isApproved: statusInfo.isApproved } : vendor;
                });
            }

            applyFiltersAndRender();
            calculateAndRenderOverallStats(allVendors);
            calculateAndRenderAggregatedDashboard(allVendors);

        } catch (error) {
            console.error("Fetch error, falling back to mock data:", error);
            showToastMessage(`Error loading vendors (Using Mock Data): ${error.message}`, 'warning');
            allVendors = getMockVendors();
            applyFiltersAndRender();
            calculateAndRenderOverallStats(allVendors);
            calculateAndRenderAggregatedDashboard(allVendors);
        }
    };


    const fetchGlobalSearchShops = async (search = '') => {
        showTableLoading();
        try {
            const url = search
                ? `${ADMIN_VENDORS_GLOBAL_SEARCH}?search=${encodeURIComponent(search)}`
                : ADMIN_VENDORS_API;

            const vendors = await fetchAPI(url);

            if (!vendors || !Array.isArray(vendors) || vendors.length === 0) {
                console.warn("Search returned empty. Using Mock Data for demo if empty.");
                // Only use mock data if specifically requested or maybe just show empty
                // For now, let's just show mock data if search is empty to verify UI
                // But realistically search should show empty. 
                // User asked to add sample data, so let's force mock data on empty search/load for now? 
                // Actually, let's keep search acting real, but load acting mock. 
                // If search fails completely (error), we might show mock.

                shopsTableBody.innerHTML = `
                <tr>
                    <td colspan="5" class="text-center p-4">
                        No shops found matching "${search}".
                    </td>
                </tr>`;
                allVendors = [];
                // Removed return to allow stats clearing
            } else {
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
            }

            applyFiltersAndRender();
            calculateAndRenderOverallStats(allVendors);
            calculateAndRenderAggregatedDashboard(allVendors);
            return;

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

        // Pass filtered data to paginator, which will trigger renderShopsTable with the current page slice
        shopsPaginator.setData(filteredVendors);
    };

    // ===================================================================
    // RENDER FUNCTIONS (ZENITH GRID & LIST)
    // ===================================================================
    function renderShopsTable(vendors) {
        const container = document.getElementById('shops-container');
        if (!vendors || vendors.length === 0) {
            container.innerHTML = `<div class="col-12 text-center py-5"><h5 class="text-muted">No shops found.</h5></div>`;
            return;
        }

        const viewMode = document.querySelector('input[name="viewMode"]:checked').id; // view-grid or view-list
        const isGrid = viewMode === 'view-grid';
        const IMAGE_BASE_URL = 'http://meatsfresh.org.in:8080/';

        container.innerHTML = vendors.map(shop => {
            const status = shop.status || 'UNKNOWN';
            const statusClass = status === 'ONLINE' ? 'success' : 'secondary';
            const availability = shop.availability || 'CLOSED';
            const isAvailable = availability === 'OPEN';
            const imageUrl = shop.shopPhoto ? `${IMAGE_BASE_URL}${shop.shopPhoto}` : 'resources/images/default-store.jpg';

            if (isGrid) {
                // ZENITH CARD VIEW
                return `
                <div class="col-md-6 col-lg-4 col-xl-3 animate-on-load">
                    <div class="card h-100 border-0 shadow-sm hover-shadow-lg transition-all" style="border-radius: 16px; overflow: hidden;">
                        <div class="position-relative" style="height: 140px;">
                            <img src="${imageUrl}" class="w-100 h-100 object-fit-cover" alt="${shop.vendorInfo}" onerror="this.src='resources/images/default-store.jpg'">
                            <span class="position-absolute top-0 end-0 m-2 badge bg-white text-dark shadow-sm rounded-pill px-3">
                                <i class="fas fa-star text-warning me-1"></i> 4.5
                            </span>
                        </div>
                        <div class="card-body p-3">
                            <div class="d-flex justify-content-between mb-2">
                                <span class="badge bg-${statusClass} bg-opacity-10 text-${statusClass} rounded-pill border border-${statusClass} px-2 py-1" style="font-size: 0.7rem;">${status}</span>
                                <span class="badge bg-${isAvailable ? 'success' : 'danger'} bg-opacity-10 text-${isAvailable ? 'success' : 'danger'} rounded-pill px-2 py-1" style="font-size: 0.7rem;">${availability}</span>
                            </div>
                            <h6 class="fw-bold text-truncate mb-1" title="${shop.vendorInfo}">${shop.vendorInfo || 'Unnamed Shop'}</h6>
                            <p class="text-muted small mb-2"><i class="fas fa-map-marker-alt me-1"></i> ${shop.contactDetails ? shop.contactDetails.split('|')[0] : 'N/A'}</p>
                            
                            <div class="d-flex align-items-center justify-content-between mt-3 pt-3 border-top">
                                <div class="small text-muted">
                                    <i class="fas fa-box me-1"></i> ID: ${shop.vendorId}
                                </div>
                                <a href="viewshop?id=${shop.vendorId}" class="btn btn-sm btn-outline-primary rounded-pill px-3">View Details</a>
                            </div>
                        </div>
                    </div>
                </div>`;
            } else {
                // ZENITH LIST VIEW (Row based)
                return `
                <div class="col-12 animate-on-load">
                    <div class="glass-panel p-3 d-flex align-items-center flex-wrap gap-3">
                        <img src="${imageUrl}" class="rounded-3 shadow-sm" width="60" height="60" style="object-fit: cover;" onerror="this.src='resources/images/default-store.jpg'">
                        
                        <div class="flex-grow-1" style="min-width: 200px;">
                            <h6 class="fw-bold mb-0">${shop.vendorInfo || 'Unnamed Shop'}</h6>
                            <small class="text-muted"><i class="fas fa-id-badge me-1"></i> ID: ${shop.vendorId} | ${shop.contactDetails || ''}</small>
                        </div>

                        <div style="min-width: 150px;">
                            <div class="d-flex gap-2">
                                <span class="zenith-badge ${statusClass}">${status}</span>
                                <span class="zenith-badge ${isAvailable ? 'success' : 'danger'}">${availability}</span>
                            </div>
                        </div>

                        <div class="text-end" style="min-width: 120px;">
                             <a href="viewshop?id=${shop.vendorId}" class="btn btn-sm btn-light text-primary rounded-circle"><i class="fas fa-eye"></i></a>
                             <a href="editshop?id=${shop.vendorId}" class="btn btn-sm btn-light text-secondary rounded-circle"><i class="fas fa-pen"></i></a>
                             <button class="btn btn-sm btn-light text-danger rounded-circle delete-vendor" data-vendor-id="${shop.vendorId}"><i class="fas fa-trash"></i></button>
                        </div>
                    </div>
                </div>`;
            }
        }).join('');
    };

    // View Mode Toggle Listeners
    document.querySelectorAll('input[name="viewMode"]').forEach(radio => {
        radio.addEventListener('change', () => applyFiltersAndRender());
    });


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
        link.addEventListener('click', function (e) {
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


    document.getElementById('confirmDeleteBtn').addEventListener('click', async function () {
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

    (function () {
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