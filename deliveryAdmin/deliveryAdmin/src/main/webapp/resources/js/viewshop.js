document.addEventListener('DOMContentLoaded', function () {
    const API_BASE = 'http://meatsfresh.org.in:8080/api/vendor';
    const IMAGE_BASE_URL = 'http://meatsfresh.org.in:8080';

    const ADMIN_VENDORS_API = `${API_BASE}/allVendors`;
    const VENDOR_STATUS_API = (id) => `${API_BASE}/admin/${id}/status`;
    const ALL_PRODUCTS_API = `${API_BASE}/products`; // API to get all products

    const loadingSpinner = document.getElementById('loading-spinner');
    const viewContent = document.getElementById('view-content');
    const pageTitle = document.getElementById('vendor-page-title');
    const productsTableBody = document.getElementById('products-table-body'); // Element for the products table

    const getVendorIdFromUrl = () => new URLSearchParams(window.location.search).get('id');
    const VENDOR_ID = getVendorIdFromUrl();

    // Modified to include Basic Authentication
    const fetchAPI = async (url, options = {}) => {
        try {
            // --- START: Added for Basic Authentication ---
            const username = 'user';
            const password = 'user';
            const headers = {
                ...options.headers, // Preserve existing headers
                'Authorization': 'Basic ' + btoa(`${username}:${password}`)
            };
            // --- END: Added for Basic Authentication ---

            const fetchOptions = { ...options, headers, cache: 'no-cache' }; // Use the new headers
            const response = await fetch(url, fetchOptions);

            if (!response.ok) {
                const errorData = await response.json().catch(() => ({ message: response.statusText }));
                throw new Error(errorData.message || `HTTP error! status: ${response.status}`);
            }
            if (response.status === 204) return null; // Handle No Content success response

            return response.json();
        } catch (error) {
            console.error(`Fetch error from ${url}:`, error);
            // Optionally, provide user-facing feedback
            // alert(`Failed to fetch data: ${error.message}`);
            return null;
        }
    };


    const populateField = (id, value) => {
        const el = document.getElementById(id);
        if (el) el.textContent = value || 'N/A';
    };

    const renderShopDetails = (vendor) => {
        pageTitle.textContent = `Shop Details: ${vendor.vendorName}`;
        populateField('vendorName', vendor.vendorName);
        populateField('summary-contactPerson', vendor.contactPerson);
        populateField('summary-phone', vendor.phoneNumber);

        const shopPhoto = document.getElementById('shopPhoto');
        if (vendor.shopPhoto) {
            shopPhoto.src = `${IMAGE_BASE_URL}${vendor.shopPhoto}`;
        }
        shopPhoto.onerror = () => { shopPhoto.src = '/resources/images/default-store.jpg'; };

        const status = vendor.isApproved === true ? 'Accepted' : 'Pending';
        const isAvailable = vendor.isActive === 'Y';
        const availabilityText = isAvailable ? 'Available' : 'Unavailable';
        const statusBadges = document.getElementById('statusBadges');
        statusBadges.innerHTML = `
            <span class="badge-status ${status.toLowerCase()}">${status}</span>
            <span class="badge-avail ${isAvailable ? 'available' : 'unavailable'}">${availabilityText}</span>
        `;

        populateField('detail-panNumber', vendor.panNumber);
        populateField('detail-fssaiNumber', vendor.fssaiNumber);
        populateField('detail-gstNumber', vendor.gstNumber);
        populateField('detail-email', vendor.email);
        populateField('detail-openingTime', vendor.openingTime);
        populateField('detail-closingTime', vendor.closingTime);
        populateField('location-address', vendor.address);
        populateField('location-city', vendor.cityName);
        populateField('location-district', vendor.districtName);
        populateField('location-state', vendor.stateName);
        populateField('location-zipcode', vendor.zipCode);
        populateField('bank-holderName', vendor.bankHolderName);
        populateField('bank-bankName', vendor.bankName);
        populateField('bank-accountNumber', vendor.accountNumber);
        populateField('bank-ifscCode', vendor.ifscCode);
    };

    const renderProducts = (products, vendorId) => {
        const vendorProducts = products.filter(p => p.vendorId == vendorId);
        if (vendorProducts.length === 0) {
            productsTableBody.innerHTML = '<tr><td colspan="4" class="text-center text-muted p-4">No products found for this vendor.</td></tr>';
            return;
        }
        productsTableBody.innerHTML = vendorProducts.map(p => {
            const imageUrl = p.productImageUrl ? `${IMAGE_BASE_URL}${p.productImageUrl}` : '/resources/images/default-product.png';
            const statusBadge = p.isActive ? '<span class="badge bg-light text-success border">Active</span>' : '<span class="badge bg-light text-secondary border">Inactive</span>';
            return `
            <tr>
                <td class="ps-4"><div class="d-flex align-items-center"><img src="${imageUrl}" class="me-3 rounded" width="45" height="45" alt="${p.title}" style="object-fit: cover;" onerror="this.onerror=null;this.src='/resources/images/default-product.png';"/><div><h6 class="mb-0 fw-bold">${p.title}</h6><small class="text-muted">ID: ${p.id}</small></div></div></td>
                <td>₹${p.price.toFixed(2)}</td>
                <td>${p.category || 'N/A'}</td>
                <td>${statusBadge}</td>
            </tr>`;
        }).join('');
    };

    async function init() {
        if (!VENDOR_ID) {
            pageTitle.textContent = 'Error: No Shop ID Provided';
            loadingSpinner.classList.add('d-none');
            return;
        }

        // Fetch vendor details, status, and all products in parallel
        const [vendors, statusInfo, products] = await Promise.all([
            fetchAPI(ADMIN_VENDORS_API),
            fetchAPI(VENDOR_STATUS_API(VENDOR_ID)),
            fetchAPI(ALL_PRODUCTS_API)
        ]);

        const vendor = vendors ? vendors.find(v => v.vendorId == VENDOR_ID) : null;

        if (vendor && statusInfo) {
            const updatedVendor = { ...vendor, isApproved: statusInfo.isApproved };
            renderShopDetails(updatedVendor);

            // Render products if they were fetched successfully
            if (products) {
                renderProducts(products, VENDOR_ID);
            }

            loadingSpinner.classList.add('d-none');
            viewContent.classList.remove('d-none');
        } else {
            pageTitle.textContent = `Error: Shop with ID ${VENDOR_ID} not found.`;
            loadingSpinner.classList.add('d-none');
        }
    }

    init();
});