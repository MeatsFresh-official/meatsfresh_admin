document.addEventListener('DOMContentLoaded', function () {
    // --- IMPORTANT: REPLACE WITH YOUR API ENDPOINT ---
    const API_BASE_URL = 'https://localhost:8082/api/admin';

    const API_ENDPOINTS = {
        plans: `${API_BASE_URL}/promotion-plans`,
        requests: `${API_BASE_URL}/promotion-requests`,
        active: `${API_BASE_URL}/promotions/active`,
        metrics: `${API_BASE_URL}/promotions/metrics`
    };

    const plansTableBody = document.getElementById('plansTableBody');
    const requestsTableBody = document.getElementById('requestsTableBody');
    const activePromotionsContainer = document.getElementById('activePromotionsContainer');
    const planModal = new bootstrap.Modal(document.getElementById('planModal'));
    const detailsModal = new bootstrap.Modal(document.getElementById('requestDetailsModal'));
    const confirmModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));

    const planForm = document.getElementById('planForm');
    let currentPlanId = null;

    // --- UTILITY FUNCTIONS ---
    const showLoading = (element) => {
        element.innerHTML = `<tr><td colspan="100%" class="text-center"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></td></tr>`;
    };

    const showEmpty = (element, message) => {
        element.innerHTML = `<tr><td colspan="100%" class="text-center p-4 text-muted">${message}</td></tr>`;
    };

    const formatDate = (dateString) => {
        if (!dateString) return 'N/A';
        const date = new Date(dateString);
        return date.toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' });
    };

    const formatCurrency = (amount) => {
        return new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR' }).format(amount);
    };

    // --- API FETCH FUNCTIONS ---

    const fetchPromotionPlans = async () => {
        showLoading(plansTableBody);
        try {
            const response = await fetch(API_ENDPOINTS.plans);
            if (!response.ok) throw new Error('Network response was not ok');
            const plans = await response.json();
            renderPlansTable(plans);
        } catch (error) {
            console.error('Error fetching promotion plans:', error);
            showEmpty(plansTableBody, 'Could not load promotion plans.');
        }
    };

    const fetchPromotionRequests = async (params = {}) => {
        showLoading(requestsTableBody);
        const query = new URLSearchParams(params).toString();
        try {
            const response = await fetch(`${API_ENDPOINTS.requests}?${query}`);
            if (!response.ok) throw new Error('Network response was not ok');
            const requests = await response.json();
            renderRequestsTable(requests);
        } catch (error) {
            console.error('Error fetching promotion requests:', error);
            showEmpty(requestsTableBody, 'Could not load promotion requests.');
        }
    };

    const fetchActivePromotions = async () => {
        activePromotionsContainer.innerHTML = `<div class="spinner-container"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></div>`;
        try {
            // Fetch metrics first
            const metricsResponse = await fetch(API_ENDPOINTS.metrics);
            const metrics = await metricsResponse.json();
            document.getElementById('activePromotionsHeader').textContent = `Active Promotions (${metrics.activeCount}/${metrics.maxSlots} slots used)`;
            document.getElementById('activePromotionsAlert').innerHTML = `<i class="fas fa-info-circle me-2"></i> Only ${metrics.maxSlots} shops can be promoted at the same time.`;

            // Then fetch active promotions
            const response = await fetch(API_ENDPOINTS.active);
            if (!response.ok) throw new Error('Network response was not ok');
            const promotions = await response.json();
            renderActivePromotions(promotions);
        } catch (error) {
            console.error('Error fetching active promotions:', error);
            activePromotionsContainer.innerHTML = `<div class="empty-data-message">Could not load active promotions.</div>`;
        }
    };

    // --- RENDER FUNCTIONS ---

    const renderPlansTable = (plans) => {
        if (!plans || plans.length === 0) {
            showEmpty(plansTableBody, 'No promotion plans found.');
            return;
        }
        plansTableBody.innerHTML = plans.map(plan => `
            <tr>
                <td>${plan.name}</td>
                <td>${plan.duration} days</td>
                <td>${formatCurrency(plan.price)}</td>
                <td>${plan.maxSlots}</td>
                <td>
                    <span class="badge-position ${plan.position.toLowerCase()}">
                        ${plan.position === 'TOP' ? 'Top Listing' : 'Featured'}
                    </span>
                </td>
                <td>
                    <div class="form-check form-switch">
                        <input class="form-check-input plan-status" type="checkbox" data-plan-id="${plan.id}" ${plan.active ? 'checked' : ''}>
                    </div>
                </td>
                <td>
                    <div class="btn-group btn-group-sm" role="group">
                        <button class="btn btn-outline-primary btn-edit-plan" data-plan-id="${plan.id}">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-outline-danger btn-delete-plan" data-plan-id="${plan.id}" data-plan-name="${plan.name}">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </td>
            </tr>
        `).join('');
    };

    const renderRequestsTable = (requests) => {
        if (!requests || requests.length === 0) {
            showEmpty(requestsTableBody, 'No promotion requests found for the selected criteria.');
            return;
        }
        requestsTableBody.innerHTML = requests.map(request => `
            <tr data-request-id="${request.id}">
                <td>
                    <div class="d-flex align-items-center">
                        <img src="${request.shop.logo || '/resources/images/default-store.png'}"
                             class="rounded-circle me-3" width="40" height="40" alt="${request.shop.name}">
                        <div>
                            <h6 class="mb-0">${request.shop.name}</h6>
                            <small class="text-muted">ID: ${request.shop.id}</small>
                        </div>
                    </div>
                </td>
                <td>${request.plan.name}</td>
                <td>${formatDate(request.requestDate)}</td>
                <td>${formatDate(request.startDate)}</td>
                <td>${formatDate(request.endDate)}</td>
                <td>
                    <span class="badge-status ${request.status.toLowerCase()}">${request.status}</span>
                </td>
                <td>
                    <div class="btn-group btn-group-sm" role="group">
                        <button class="btn btn-outline-primary btn-view-request" data-request-id="${request.id}">
                            <i class="fas fa-eye"></i>
                        </button>
                        ${request.status === 'PENDING' ? `
                        <button class="btn btn-outline-success btn-approve-request" data-request-id="${request.id}">
                            <i class="fas fa-check"></i>
                        </button>
                        <button class="btn btn-outline-danger btn-reject-request" data-request-id="${request.id}">
                            <i class="fas fa-times"></i>
                        </button>
                        ` : ''}
                    </div>
                </td>
            </tr>
        `).join('');
    };

    const renderActivePromotions = (promotions) => {
        if (!promotions || promotions.length === 0) {
            activePromotionsContainer.innerHTML = `<div class="col-12"><div class="empty-data-message">No active promotions at the moment.</div></div>`;
            return;
        }
        activePromotionsContainer.innerHTML = promotions.map(promo => {
            const remainingPercent = Math.max(0, Math.min(100, promo.remainingPercent));
            return `
            <div class="col-xl-3 col-md-4 col-6 mb-4">
                <div class="card h-100 promotion-card">
                    <div class="card-img-top position-relative">
                        <img src="${promo.shop.bannerImage || '/resources/images/default-banner.jpg'}" class="card-img-top" alt="${promo.shop.name}">
                        <div class="badge-position ${promo.plan.position.toLowerCase()} position-absolute top-0 end-0 m-2">
                            ${promo.plan.position === 'TOP' ? 'Top' : 'Featured'}
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-3">
                            <img src="${promo.shop.logo}" class="rounded-circle me-3" width="40" height="40" alt="">
                            <h5 class="mb-0">${promo.shop.name}</h5>
                        </div>
                        <div class="mb-2">
                            <small class="text-muted">Plan:</small>
                            <p class="mb-0 fw-bold">${promo.plan.name}</p>
                        </div>
                        <div class="mb-2">
                            <small class="text-muted">Duration:</small>
                            <p class="mb-0">${formatDate(promo.startDate)} - ${formatDate(promo.endDate)}</p>
                        </div>
                        <div class="progress mb-2" style="height: 6px;">
                            <div class="progress-bar bg-success" role="progressbar" style="width: ${remainingPercent}%"></div>
                        </div>
                        <small class="text-muted">
                            ${promo.remainingDays} days remaining (${remainingPercent}%)
                        </small>
                    </div>
                    <div class="card-footer">
                        <button class="btn btn-sm btn-outline-danger w-100 btn-end-promotion" data-promotion-id="${promo.id}">
                            <i class="fas fa-stop me-2"></i>End Promotion
                        </button>
                    </div>
                </div>
            </div>`;
        }).join('');
    };

    // --- EVENT LISTENERS & HANDLERS ---

    // Load initial data
    fetchPromotionPlans();
    fetchPromotionRequests();
    fetchActivePromotions();
});