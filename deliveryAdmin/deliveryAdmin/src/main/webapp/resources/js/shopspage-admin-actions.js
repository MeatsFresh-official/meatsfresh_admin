document.addEventListener('DOMContentLoaded', () => {
    // ===================================================================
    // API ENDPOINTS
    // ===================================================================
    const API_BASE = 'http://113.11.231.115:1275/api/vendor';
    const ADMIN_API = `${API_BASE}/admin`;
    const VENDOR_ID = new URLSearchParams(window.location.search).get('id');

    // Vendor APIs
    const ALL_VENDORS_API = `${API_BASE}/allVendors`;
    const VENDOR_STATUS_API = (id) => `${ADMIN_API}/${id}/status`;
    const VENDOR_APPROVE_API = (id) => `${ADMIN_API}/${id}/approve`;
    const VENDOR_DISAPPROVE_API = (id) => `${ADMIN_API}/${id}/disapprove`;
    const VENDOR_UPDATE_ACTIVE_API = (id, isActive) => `${API_BASE}/dashboard/updateStatus?vendors_id=${id}&isactive=${isActive}`;
    const VENDOR_DASHBOARD_API = (id) => `${API_BASE}/dashboard?vendor_id=${id}`;

    // Product APIs
    const CATEGORIES_API = `${ADMIN_API}/categories`;
    const PRODUCTS_BY_VENDOR_API = (vendorId) => `${API_BASE}/products/${vendorId}`;
    const PRODUCT_GET_SINGLE_API = (productId) => `${API_BASE}/products/id/${productId}`;
    const ADD_PRODUCT_API = `${API_BASE}/products`;
    const PRODUCT_ACTION_API = (productId) => `${API_BASE}/products/${productId}`;


    // ===================================================================
    // DOM ELEMENTS
    // ===================================================================
    const loadingSpinner = document.getElementById('loading-spinner');
    const adminContent = document.getElementById('admin-content');
    const pageTitle = document.getElementById('admin-page-title');
    const vendorNameHeader = document.getElementById('vendor-name-header');
    const vendorIdBadge = document.getElementById('vendor-id-badge');
    const approvalStatusText = document.getElementById('approval-status-text');
    const approveBtn = document.getElementById('approve-btn');
    const disapproveBtn = document.getElementById('disapprove-btn');
    const availabilitySwitch = document.getElementById('availability-switch');
    const availabilityLabel = document.getElementById('availability-label');
    const dashboardContainer = document.getElementById('vendor-dashboard-stats');
    const productsTableBody = document.getElementById('productsTableBody');
    const productModalEl = document.getElementById('productModal');
    const productModal = new bootstrap.Modal(productModalEl);
    const productForm = document.getElementById('productForm');
    const productModalLabel = document.getElementById('productModalLabel');
    const productCategorySelect = document.getElementById('productCategory');
    const addProductBtn = document.getElementById('addProductBtn');
    const viewProductModalEl = document.getElementById('viewProductModal');
    const viewProductModal = new bootstrap.Modal(viewProductModalEl);
    const deleteModalEl = document.getElementById('deleteConfirmationModal');
    const deleteModal = new bootstrap.Modal(deleteModalEl);


    // ===================================================================
    // HELPER FUNCTIONS
    // ===================================================================
    const fetchAPI = async (url, options = {}) => {
        const username = 'user';
        const password = 'user';
        const headers = { 'Authorization': 'Basic ' + btoa(`${username}:${password}`) };

        // Let the browser set the Content-Type for FormData, otherwise set it for JSON
        if (!(options.body instanceof FormData) && options.body) {
            headers['Content-Type'] = 'application/json';
        }

        const fetchOptions = { ...options, headers, cache: 'no-cache' };

        try {
            const response = await fetch(url, fetchOptions);
            if (!response.ok) {
                const errorData = await response.json().catch(() => ({ message: response.statusText }));
                throw new Error(errorData.message || `HTTP error! status: ${response.status}`);
            }
            const responseText = await response.text();
            return responseText ? JSON.parse(responseText) : { success: true };
        } catch (error) {
            console.error(`API Error at ${url}:`, error);
            // Re-throw the error so the calling function can decide how to handle it
            throw error;
        }
    };

    const formatCurrency = (amount) => new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', maximumFractionDigits: 0 }).format(amount || 0);

    // ===================================================================
    // RENDER FUNCTIONS
    // ===================================================================
    const renderVendorDetails = (vendor, statusInfo) => {
        pageTitle.textContent = `Admin Console: ${vendor.vendorName}`;
        vendorNameHeader.textContent = vendor.vendorName;
        vendorIdBadge.textContent = `ID: ${vendor.vendorId}`;
        const isApproved = statusInfo.isApproved;
        approvalStatusText.textContent = isApproved ? 'Approved' : 'Pending';
        approvalStatusText.className = isApproved ? 'text-success fw-bold' : 'text-warning fw-bold';
        approveBtn.disabled = isApproved;
        disapproveBtn.disabled = !isApproved;
        const isActive = vendor.isActive === 'Y';
        availabilitySwitch.checked = isActive;
        availabilityLabel.textContent = isActive ? 'Shop is Available' : 'Shop is Unavailable';
    };

    const renderDashboard = (data) => {
        if (!data || !data.earnings || !data.orders) {
            dashboardContainer.innerHTML = `<div class="p-3 text-muted">Could not load dashboard data due to a server error. Please check the developer console for details.</div>`;
            return;
        }
        dashboardContainer.innerHTML = `
            <div class="mb-4">
                <h6 class="text-muted">Earnings Overview</h6>
                <div class="card bg-light border-0">
                    <div class="card-body d-flex justify-content-around text-center">
                        <div><small class="text-muted d-block">Today</small><h5 class="fw-bold text-primary mb-0">${formatCurrency(data.earnings.today)}</h5></div>
                        <div><small class="text-muted d-block">This Week</small><h5 class="fw-bold text-info mb-0">${formatCurrency(data.earnings.this_week)}</h5></div>
                        <div><small class="text-muted d-block">This Month</small><h5 class="fw-bold text-success mb-0">${formatCurrency(data.earnings.this_month)}</h5></div>
                    </div>
                </div>
            </div>
            <div>
                <h6 class="text-muted">Order Summary</h6>
                <div class="row g-2">
                    <div class="col-6 col-sm-3"><div class="card"><div class="card-body text-center p-2"><h6 class="mb-0">${data.orders.pending || 0}</h6><small class="text-muted">Pending</small></div></div></div>
                    <div class="col-6 col-sm-3"><div class="card"><div class="card-body text-center p-2"><h6 class="mb-0">${data.orders.completed || 0}</h6><small class="text-muted">Completed</small></div></div></div>
                    <div class="col-6 col-sm-3"><div class="card"><div class="card-body text-center p-2"><h6 class="mb-0">${data.orders.cancelled || 0}</h6><small class="text-muted">Cancelled</small></div></div></div>
                    <div class="col-6 col-sm-3"><div class="card"><div class="card-body text-center p-2"><h6 class="mb-0">${data.orders.returned || 0}</h6><small class="text-muted">Returned</small></div></div></div>
                </div>
            </div>`;
    };

    const fetchAndRenderProducts = async () => {
        productsTableBody.innerHTML = `<tr><td colspan="5" class="text-center p-4">Loading products...</td></tr>`;
        try {
            const vendorProducts = await fetchAPI(PRODUCTS_BY_VENDOR_API(VENDOR_ID));
            if (!vendorProducts || vendorProducts.length === 0) {
                productsTableBody.innerHTML = `<tr><td colspan="5" class="text-center p-4 text-muted">No products found for this vendor.</td></tr>`;
                return;
            }
            productsTableBody.innerHTML = vendorProducts.map(product => {
                const statusBadge = product.isActive ? `<span class="badge bg-success">Active</span>` : `<span class="badge bg-danger">Inactive</span>`;
                const imageUrl = product.productImageUrl ? `http://113.11.231.115:8080${product.productImageUrl}` : 'resources/images/default-product.png';
                return `
                    <tr>
                        <td class="ps-4">
                            <div class="d-flex align-items-center">
                                <img src="${imageUrl}" class="rounded me-3" alt="${product.title}" width="50" height="50" style="object-fit: cover;" onerror="this.onerror=null;this.src='resources/images/default-product.png';">
                                <div><h6 class="mb-0">${product.title}</h6><small class="text-muted">ID: ${product.id}</small></div>
                            </div>
                        </td>
                        <td>${formatCurrency(product.price)}</td>
                        <td>${product.category || 'N/A'}</td>
                        <td>${statusBadge}</td>
                        <td class="text-center">
                            <div class="btn-group btn-group-sm">
                                <button class="btn btn-outline-primary btn-view" data-product-id="${product.id}" title="View"><i class="fas fa-eye"></i></button>
                                <button class="btn btn-outline-secondary btn-edit" data-product-id="${product.id}" title="Edit"><i class="fas fa-edit"></i></button>
                                <button class="btn btn-outline-danger btn-delete" data-product-id="${product.id}" title="Delete"><i class="fas fa-trash"></i></button>
                            </div>
                        </td>
                    </tr>`;
            }).join('');
        } catch (error) {
            productsTableBody.innerHTML = `<tr><td colspan="5" class="text-center p-4 text-danger">Could not load products.</td></tr>`;
            console.error("Product Load Error:", error.message);
        }
    };

    const populateCategoryDropdown = async () => {
        try {
            const categories = await fetchAPI(CATEGORIES_API);
            if (categories && categories.length > 0) {
                productCategorySelect.innerHTML = '<option selected disabled value="">Choose a category...</option>';
                categories.forEach(cat => {
                    productCategorySelect.innerHTML += `<option value="${cat.name}">${cat.name}</option>`;
                });
            } else {
                productCategorySelect.innerHTML = '<option selected disabled value="">No categories found</option>';
            }
        } catch (error) {
            console.error("Category Dropdown Error:", error.message);
            productCategorySelect.innerHTML = '<option selected disabled value="">Could not load categories</option>';
        }
    };

    // ===================================================================
    // EVENT HANDLERS
    // ===================================================================
    const handleProductFormSubmit = async (e) => {
        e.preventDefault();

        const productId = productForm.querySelector('#productId').value;
        const title = productForm.querySelector('#productTitle').value;
        const description = productForm.querySelector('#productDescription').value;
        const price = parseFloat(productForm.querySelector('#productPrice').value);
        const category = productForm.querySelector('#productCategory').value;
        const isActive = productForm.querySelector('#isActive').checked;
        const recommendedForUser = productForm.querySelector('#recommendedForUser').checked;
        const productImageFile = productForm.querySelector('#productImage').files[0];

        const productData = {
            title, description, price, category, isActive, recommendedForUser,
            priceMethod: 'MANUAL',
            vendorId: parseInt(VENDOR_ID)
        };

        const formData = new FormData();
        formData.append('product', new Blob([JSON.stringify(productData)], { type: 'application/json' }));

        if (productImageFile) {
            formData.append('productImage', productImageFile);
        }

        const method = productId ? 'PUT' : 'POST';
        const url = productId ? PRODUCT_ACTION_API(productId) : ADD_PRODUCT_API;

        try {
            await fetchAPI(url, { method, body: formData });
            alert(`Product ${productId ? 'updated' : 'added'} successfully!`);
            productModal.hide();
            fetchAndRenderProducts();
        } catch (error) {
            alert(`Error saving product: ${error.message}`);
        }
    };

    const handleProductActions = async (e) => {
        const target = e.target.closest('button');
        if (!target) return;
        const productId = target.dataset.productId;

        try {
            if (target.classList.contains('btn-delete')) {
                document.getElementById('confirmDeleteBtn').dataset.productId = productId;
                deleteModal.show();
            } else if (target.classList.contains('btn-edit') || target.classList.contains('btn-view')) {
                const product = await fetchAPI(PRODUCT_GET_SINGLE_API(productId));
                if (!product) throw new Error("Product details could not be found.");

                if (target.classList.contains('btn-edit')) {
                    productModalLabel.textContent = 'Edit Product';
                    productForm.reset();
                    productForm.querySelector('#productId').value = product.id;
                    productForm.querySelector('#productTitle').value = product.title;
                    productForm.querySelector('#productDescription').value = product.description;
                    productForm.querySelector('#productPrice').value = product.price;
                    productForm.querySelector('#productCategory').value = product.category;
                    productForm.querySelector('#isActive').checked = product.isActive;
                    productForm.querySelector('#recommendedForUser').checked = product.recommendedForUser;
                    productModal.show();
                } else { // View button
                    viewProductModalEl.querySelector('#viewProductImage').src = product.productImageUrl ? `http://113.11.231.115:8080${product.productImageUrl}` : 'resources/images/default-product.png';
                    viewProductModalEl.querySelector('#viewProductTitle').textContent = product.title;
                    viewProductModalEl.querySelector('#viewProductPrice').textContent = formatCurrency(product.price);
                    viewProductModalEl.querySelector('#viewProductCategory').textContent = product.category || 'N/A';
                    viewProductModalEl.querySelector('#viewProductDescription').textContent = product.description;
                    viewProductModalEl.querySelector('#viewProductStatus').innerHTML = product.isActive ? `<span class="badge bg-success">Active</span>` : `<span class="badge bg-danger">Inactive</span>`;
                    viewProductModalEl.querySelector('#viewProductRecommended').innerHTML = product.recommendedForUser ? `<span class="badge bg-info">Yes</span>` : `<span class="badge bg-secondary">No</span>`;
                    viewProductModal.show();
                }
            }
        } catch (error) {
            alert(`Error: ${error.message}`);
        }
    };

    // ===================================================================
    // INITIALIZATION & MAIN LOGIC
    // ===================================================================
    const loadAllData = async () => {
        if (!VENDOR_ID) {
            pageTitle.textContent = 'Error: No Vendor ID provided.';
            loadingSpinner.classList.add('d-none');
            return;
        }
        try {
            // Fetch critical data needed for the page to function
            const [vendors, statusInfo] = await Promise.all([
                fetchAPI(ALL_VENDORS_API),
                fetchAPI(VENDOR_STATUS_API(VENDOR_ID))
            ]);

            const currentVendor = vendors ? vendors.find(v => v.vendorId == VENDOR_ID) : null;
            if (!currentVendor || !statusInfo) {
                throw new Error('Could not load essential vendor details.');
            }

            // Render the main parts of the page that depend on critical data
            renderVendorDetails(currentVendor, statusInfo);
            fetchAndRenderProducts();
            populateCategoryDropdown();

            // Fetch non-critical dashboard data separately. If this fails, the page still works.
            try {
                const dashboardData = await fetchAPI(VENDOR_DASHBOARD_API(VENDOR_ID));
                renderDashboard(dashboardData);
            } catch (dashboardError) {
                console.error("Dashboard Load Error (non-critical):", dashboardError.message);
                renderDashboard(null); // Render the dashboard in its error state
            }

            loadingSpinner.classList.add('d-none');
            adminContent.classList.remove('d-none');

        } catch (error) {
            // This catches critical errors and displays an alert
            console.error("Critical Page Load Error:", error);
            alert(`A critical error occurred: ${error.message}`);
            pageTitle.textContent = 'Error: Could not load vendor data.';
            loadingSpinner.classList.add('d-none');
        }
    };

    // --- Event Listeners Setup ---
    approveBtn.addEventListener('click', async () => {
        if (confirm('Approve this vendor?')) {
            try {
                await fetchAPI(VENDOR_APPROVE_API(VENDOR_ID), { method: 'POST' });
                loadAllData(); // Reload all data to reflect status change
            } catch (e) {
                alert(`Error: ${e.message}`);
            }
        }
    });

    disapproveBtn.addEventListener('click', async () => {
        if (confirm('Disapprove this vendor?')) {
            try {
                await fetchAPI(VENDOR_DISAPPROVE_API(VENDOR_ID), { method: 'POST' });
                loadAllData();
            } catch (e) {
                alert(`Error: ${e.message}`);
            }
        }
    });

    availabilitySwitch.addEventListener('change', async (e) => {
        const newStatus = e.target.checked ? 'Y' : 'N';
        try {
            await fetchAPI(VENDOR_UPDATE_ACTIVE_API(VENDOR_ID, newStatus), { method: 'PUT' });
            availabilityLabel.textContent = e.target.checked ? 'Shop is Available' : 'Shop is Unavailable';
        } catch (error) {
            alert(`Error updating status: ${error.message}`);
            e.target.checked = !e.target.checked; // Revert switch on failure
        }
    });

    addProductBtn.addEventListener('click', () => {
        productModalLabel.textContent = 'Add New Product';
        productForm.reset();
        productForm.querySelector('#productId').value = '';
        // Set defaults for a new product
        productForm.querySelector('#isActive').checked = true;
        productForm.querySelector('#recommendedForUser').checked = false;
        productModal.show();
    });

    productForm.addEventListener('submit', handleProductFormSubmit);
    productsTableBody.addEventListener('click', handleProductActions);

    document.getElementById('confirmDeleteBtn').addEventListener('click', async function() {
        const productId = this.dataset.productId;
        try {
            await fetchAPI(PRODUCT_ACTION_API(productId), { method: 'DELETE' });
            alert('Product deleted successfully.');
            deleteModal.hide();
            fetchAndRenderProducts();
        } catch (error) {
            alert(`Error: ${error.message}`);
        }
    });

    loadAllData();
});