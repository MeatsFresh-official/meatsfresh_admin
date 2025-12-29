document.addEventListener('DOMContentLoaded', function() {
    // =================================================================
    // == CONFIGURE YOUR API BASE URL HERE ==
    // =================================================================
    const BASE_URL = 'https://localhost:8080';
    // =================================================================

    const API_ENDPOINTS = {
        getStats: `${BASE_URL}/api/coupons/stats`,
        getCoupons: `${BASE_URL}/api/coupons`,
        getCouponById: `${BASE_URL}/api/coupons`,
        createCoupon: `${BASE_URL}/api/coupons`,
        updateCoupon: `${BASE_URL}/api/coupons`,
        deleteCoupon: `${BASE_URL}/api/coupons`,
    };

    // --- DOM Elements ---
    const stats = {
        total: document.getElementById('totalCouponsCount'),
        active: document.getElementById('activeCouponsCount'),
        expiring: document.getElementById('expiringSoonCount'),
        expired: document.getElementById('expiredCouponsCount'),
    };
    const tableBody = document.querySelector('#couponsTable tbody');
    const filterOptions = document.querySelectorAll('.filter-option');
    const filterLabel = document.getElementById('filter-label');

    // --- Modals & Forms ---
    const createCouponModal = new bootstrap.Modal(document.getElementById('createCouponModal'));
    const editCouponModal = new bootstrap.Modal(document.getElementById('editCouponModal'));
    const deleteConfirmModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
    const createCouponForm = document.getElementById('createCouponForm');
    const editCouponForm = document.getElementById('editCouponForm');

    // --- State ---
    let currentFilter = 'all';

    // --- Toast Notifications ---
    const successToast = new bootstrap.Toast(document.getElementById('successToast'));
    const errorToast = new bootstrap.Toast(document.getElementById('errorToast'));

    function showToast(isSuccess, message) {
        document.getElementById(isSuccess ? 'toastMessage' : 'errorMessage').innerText = message;
        (isSuccess ? successToast : errorToast).show();
    }

    // --- API Helpers ---
    async function apiRequest(url, method = 'GET', data = null) {
        try {
            const options = {
                method,
                headers: { 'Content-Type': 'application/json' },
            };
            if (data) options.body = JSON.stringify(data);

            const response = await fetch(url, options);
            if (!response.ok) {
                const err = await response.json();
                throw new Error(err.message || `HTTP Error: ${response.status}`);
            }
            return method === 'DELETE' ? { success: true } : await response.json();
        } catch (error) {
            console.error(`API ${method} Error:`, error);
            showToast(false, error.message || 'An unexpected error occurred.');
            return null;
        }
    }

    // --- Data Loading & Rendering ---
    function loadStats() {
        apiRequest(API_ENDPOINTS.getStats).then(data => {
            if (data) {
                stats.total.textContent = data.totalCoupons || 0;
                stats.active.textContent = data.activeCoupons || 0;
                stats.expiring.textContent = data.expiringSoon || 0;
                stats.expired.textContent = data.expiredCoupons || 0;
            }
        });
    }

    function loadCoupons() {
        tableBody.innerHTML = `<tr><td colspan="7" class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading coupons...</td></tr>`;
        apiRequest(`${API_ENDPOINTS.getCoupons}?filter=${currentFilter}`).then(data => {
            renderCouponsTable(data || []);
        });
    }

    function renderCouponsTable(coupons) {
        tableBody.innerHTML = '';
        if (coupons.length === 0) {
            tableBody.innerHTML = `<tr><td colspan="7" class="text-center">No coupons found.</td></tr>`;
            return;
        }
        coupons.forEach(coupon => {
            const now = new Date();
            const expiryDate = new Date(coupon.expiryDate);
            const daysUntilExpiry = (expiryDate - now) / (1000 * 60 * 60 * 24);

            let status = { text: 'Expired', class: 'expired' };
            if (coupon.isActive) {
                if (daysUntilExpiry < 0) {
                    status = { text: 'Expired', class: 'expired' };
                } else if (daysUntilExpiry <= 7) {
                    status = { text: 'Expiring', class: 'expiring' };
                } else {
                    status = { text: 'Active', class: 'active' };
                }
            }

            const usagePercent = coupon.usageLimit > 0 ? (coupon.usageCount / coupon.usageLimit) * 100 : 0;
            const discount = coupon.discountType === 'PERCENTAGE' ? `${coupon.discountValue}% OFF` : `₹${coupon.discountValue} OFF`;

            const row = `
                <tr>
                    <td>
                        <div class="d-flex align-items-center">
                            <div class="coupon-badge me-3">${coupon.code}</div>
                            <div>
                                <h6 class="mb-0">${coupon.name}</h6>
                                <small class="text-muted">${coupon.description || ''}</small>
                            </div>
                        </div>
                    </td>
                    <td>${discount}</td>
                    <td>${new Date(coupon.validFrom).toLocaleDateString('en-IN')} - ${expiryDate.toLocaleDateString('en-IN')}</td>
                    <td><div class="badge-div bg-${status.class}">${status.text}</div></td>
                    <td><div class="badge-div bg-${coupon.createdBy.toLowerCase()}">${coupon.createdBy}</div></td>
                    <td>
                        <div class="progress"><div class="progress-bar" role="progressbar" style="width: ${usagePercent}%"></div></div>
                        <small>${coupon.usageCount}/${coupon.usageLimit} used</small>
                    </td>
                    <td>
                        <div class="btn-group btn-group-sm" role="group">
                            <button class="btn btn-outline-primary" onclick="openEditModal('${coupon.id}')"><i class="fas fa-edit"></i></button>
                            <button class="btn btn-outline-danger" onclick="confirmDelete('${coupon.id}', '${coupon.code}')"><i class="fas fa-trash"></i></button>
                        </div>
                    </td>
                </tr>`;
            tableBody.insertAdjacentHTML('beforeend', row);
        });
    }

    function refreshData() {
        loadStats();
        loadCoupons();
    }

    // --- Event Listeners ---
    filterOptions.forEach(option => {
        option.addEventListener('click', e => {
            e.preventDefault();
            currentFilter = e.target.dataset.filter;
            filterLabel.textContent = e.target.textContent;
            loadCoupons();
        });
    });

    createCouponForm.addEventListener('submit', e => {
        e.preventDefault();
        const data = Object.fromEntries(new FormData(createCouponForm).entries());
        data.isActive = document.getElementById('createIsActive').checked;
        apiRequest(API_ENDPOINTS.createCoupon, 'POST', data).then(response => {
            if (response) {
                showToast(true, 'Coupon created successfully!');
                createCouponModal.hide();
                createCouponForm.reset();
                refreshData();
            }
        });
    });

    editCouponForm.addEventListener('submit', e => {
        e.preventDefault();
        const data = Object.fromEntries(new FormData(editCouponForm).entries());
        data.isActive = document.getElementById('editIsActive').checked;
        apiRequest(`${API_ENDPOINTS.updateCoupon}/${data.id}`, 'PUT', data).then(response => {
            if (response) {
                showToast(true, 'Coupon updated successfully!');
                editCouponModal.hide();
                refreshData();
            }
        });
    });

    document.getElementById('confirmDeleteBtn').addEventListener('click', () => {
        const id = document.getElementById('deleteCouponId').value;
        apiRequest(`${API_ENDPOINTS.deleteCoupon}/${id}`, 'DELETE').then(response => {
            if (response) {
                showToast(true, 'Coupon deleted successfully.');
                deleteConfirmModal.hide();
                refreshData();
            }
        });
    });

    // --- Global Functions for onclick ---
    window.openEditModal = function(id) {
        editCouponModal.show();
        const loader = document.getElementById('editModalLoader');
        const content = document.getElementById('editModalContent');
        loader.classList.remove('d-none');
        content.classList.add('d-none');

        apiRequest(`${API_ENDPOINTS.getCouponById}/${id}`).then(coupon => {
            if (coupon) {
                document.getElementById('editCouponId').value = coupon.id;
                document.getElementById('editCouponCode').value = coupon.code;
                document.getElementById('editCouponName').value = coupon.name;
                document.getElementById('editCouponDescription').value = coupon.description;
                document.getElementById('editExpiryDate').value = coupon.expiryDate.split('T')[0];
                document.getElementById('editMinOrderAmount').value = coupon.minOrderAmount;
                document.getElementById('editIsActive').checked = coupon.isActive;

                loader.classList.add('d-none');
                content.classList.remove('d-none');
            } else {
                editCouponModal.hide();
            }
        });
    };

    window.confirmDelete = function(id, code) {
        document.getElementById('deleteCouponId').value = id;
        document.getElementById('couponCodeToDelete').textContent = code;
        deleteConfirmModal.show();
    };

    // --- Initial Load ---
    refreshData();
});