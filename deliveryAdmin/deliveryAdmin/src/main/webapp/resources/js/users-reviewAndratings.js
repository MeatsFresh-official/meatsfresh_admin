/**
 * @file This script manages the "Reviews and Ratings" page in the admin panel.
 * @description It handles fetching, displaying, filtering, sorting, and managing reviews,
 *              as well as displaying performance reports for vendors and delivery personnel.
 * @author Your Sai Manikanta/MeatsFresh
 * @version 1.0
 */

// ===================================================================================
// CONFIGURATION
// ===================================================================================

/**
 * @const {string} API_BASE_URL
 * @description The base URL for all API requests. Centralizing this makes it easy to switch
 *              between development, staging, and production environments.
 */
const API_BASE_URL = 'http://localhost:8080';
const API_BASE_URL2 = 'http://meatsfresh.org.in:8082';
/**
 * @const {object} API_ENDPOINTS
 * @description A map of all API endpoints used in this module. Using placeholders like ':id'
 *              allows for dynamic endpoint generation.
 */
const API_ENDPOINTS = {
    DASHBOARD_CARDS: '/deliveryAdmin/api/dashboard/dashboard-card',
    SEARCH: '/api/reviews/dashboard',
    GLOBAL_SEARCH: '/api/reviews/global-search',
    REVIEWS: '/reviews',
    REVIEW_DETAIL: '/reviews/:id',
    REVIEW_REPLY: '/reviews/:id/reply',
    REVIEW_STATUS: '/reviews/:id/status',
    VENDOR_PERFORMANCE: '/reports/vendor-performance',
    DELIVERY_PERFORMANCE: '/reports/delivery-performance',
    EXPORT_REVIEWS: '/reviews/export'
};

// ===================================================================================
// API SERVICE LAYER
// ===================================================================================

/**
 * @namespace apiService
 * @description An object that encapsulates all API communication. This pattern (a Service or
 *              Repository pattern) centralizes data fetching logic, making the rest of the
 *              application cleaner and easier to maintain.
 */
const apiService = {
    /**
     * @async
     * @description A generic, reusable function for making API requests. It handles URL
     *              construction, headers, and basic error handling.
     * @param {string} endpoint - The API endpoint to call (e.g., '/reviews').
     * @param {object} [options={}] - The configuration object for the `fetch` call (e.g., method, body).
     * @returns {Promise<object>} A promise that resolves to the JSON response from the API.
     * @throws {Error} Throws an error if the network response is not OK.
     */
    async request(endpoint, options = {}) {
        const url = `${API_BASE_URL}${endpoint}`;
        const config = {
            headers: {
                'Content-Type': 'application/json',
                // Example of adding an auth token. Uncomment and adapt as needed.
                // 'Authorization': `Bearer ${localStorage.getItem('token')}`
            },
            ...options // Merge custom options (like method, body)
        };

        try {
            const response = await fetch(url, config);
            if (!response.ok) {
                // If the server returns an error status (e.g., 404, 500), throw an error.
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return await response.json();
        } catch (error) {
            console.error('API request failed:', error);
            throw error; // Re-throw the error to be caught by the calling function.
        }
    },

    /**
     * @async
     * @description Fetches a list of reviews, applying any provided filters.
     * @param {object} [filters={}] - An object containing filter key-value pairs.
     * @returns {Promise<object>} The API response containing the reviews.
     */
    async getReviews(filters = {}) {
        /*const queryParams = new URLSearchParams();
        // Dynamically build the query string from the filters object.
        Object.keys(filters).forEach(key => {
            if (filters[key] && filters[key] !== 'all') {
                queryParams.append(key, filters[key]);
            }
        });
        const endpoint = `${API_ENDPOINTS.REVIEWS}?${queryParams.toString()}`;
        return this.request(endpoint);*/
        const response = await fetch(`${API_BASE_URL2}${API_ENDPOINTS.SEARCH}`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                reviewType: filters.type.toUpperCase(),
                rating: filters.rating == "all" ? null : Number(filters.rating),
                status: filters.status.toUpperCase()
            })
        });
        const data = await response.json();
        return data;
    },

    /**
     * @async
     * @description Fetches the detailed information for a single review.
     * @param {string} reviewId - The ID of the review to fetch.
     * @returns {Promise<object>} The review detail object.
     */
    async getReviewDetails(reviewId) {
        const endpoint = API_ENDPOINTS.REVIEW_DETAIL.replace(':id', reviewId);
        return this.request(endpoint);
    },

    /**
     * @async
     * @description Submits a reply to a specific review.
     * @param {string} reviewId - The ID of the review being replied to.
     * @param {object} replyData - The reply data, e.g., { reply: 'Thanks!', sendEmail: true }.
     * @returns {Promise<object>} The API confirmation response.
     */
    async submitReply(reviewId, replyData) {
        const endpoint = API_ENDPOINTS.REVIEW_REPLY.replace(':id', reviewId);
        return this.request(endpoint, {
            method: 'POST',
            body: JSON.stringify(replyData)
        });
    },

    /**
     * @async
     * @description Updates the status of a review (e.g., 'APPROVED', 'REJECTED').
     * @param {string} reviewId - The ID of the review to update.
     * @param {string} status - The new status.
     * @returns {Promise<object>} The API confirmation response.
     */
    async updateReviewStatus(reviewId, status) {
        const endpoint = API_ENDPOINTS.REVIEW_STATUS.replace(':id', reviewId);
        return this.request(endpoint, {
            method: 'PUT',
            body: JSON.stringify({ status })
        });
    },

    /**
     * @async
     * @description Fetches the vendor performance report data.
     * @returns {Promise<object>} The vendor performance data.
     */
    async getVendorPerformance() {
        return this.request(API_ENDPOINTS.VENDOR_PERFORMANCE);
    },

    /**
     * @async
     * @description Fetches the delivery performance report data.
     * @returns {Promise<object>} The delivery performance data.
     */
    async getDeliveryPerformance() {
        return this.request(API_ENDPOINTS.DELIVERY_PERFORMANCE);
    },

    /**
     * @async
     * @description Handles the API call to export reviews and triggers a file download.
     * @param {string} [format='csv'] - The desired export format (e.g., 'csv', 'xlsx').
     * @param {object} [filters={}] - The current filters to apply to the export.
     * @returns {Promise<object>} An object indicating success and the downloaded filename.
     */
    async exportReviews(format = 'csv', filters = {}) {
        const queryParams = new URLSearchParams();
        queryParams.append('format', format);
        Object.keys(filters).forEach(key => {
            if (filters[key] && filters[key] !== 'all') {
                queryParams.append(key, filters[key]);
            }
        });
        const endpoint = `${API_ENDPOINTS.EXPORT_REVIEWS}?${queryParams.toString()}`;

        // NOTE: File downloads require special handling and cannot use the generic `request`
        // function because we need to process the response as a 'blob' instead of JSON.
        try {
            const response = await fetch(`${API_BASE_URL}${endpoint}`);
            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);

            // 1. Get the filename from the 'Content-Disposition' header sent by the server.
            const contentDisposition = response.headers.get('content-disposition');
            let filename = `reviews_export.${format}`; // Provide a sensible default.
            if (contentDisposition) {
                const filenameMatch = contentDisposition.match(/filename="?(.+)"?/);
                if (filenameMatch && filenameMatch.length === 2) filename = filenameMatch[1];
            }

            // 2. Convert the response body into a Blob (Binary Large Object).
            const blob = await response.blob();
            // 3. Create a temporary URL that points to the Blob in the browser's memory.
            const url = window.URL.createObjectURL(blob);
            // 4. Create a hidden anchor element to trigger the download.
            const a = document.createElement('a');
            a.style.display = 'none';
            a.href = url;
            a.download = filename;
            // 5. Programmatically click the link and then clean up.
            document.body.appendChild(a);
            a.click();
            window.URL.revokeObjectURL(url); // Free up memory.
            document.body.removeChild(a);

            return { success: true, filename };
        } catch (error) {
            console.error('Export failed:', error);
            throw error;
        }
    }
};
async function loadDashboardCards() {
    try {
        const data = await apiService.request(API_ENDPOINTS.DASHBOARD_CARDS);

        document.getElementById("avgVendorRating").innerText = data.avgVendorRating.toFixed(1);
        document.getElementById("avgDeliveryRating").innerText = data.avgDeliveryRating.toFixed(1);
        document.getElementById("totalReviews").innerText = data.totalReviews;
        document.getElementById("pendingModeration").innerText = data.pendingModeration;

    } catch (e) {
        console.error("Failed to load dashboard cards", e);
    }
}
// ===================================================================================
// APPLICATION STATE MANAGEMENT
// ===================================================================================

/**
 * @namespace appState
 * @description A single source of truth for the application's dynamic data.
 *              This includes current filters, sorting preferences, and cached data from the API.
 *              Using a state object helps keep the application's logic predictable.
 */
let appState = {
    currentFilters: { type: 'all', rating: 'all', status: 'all', search: '' },
    currentSort: 'newest',
    reviews: [],
    vendorPerformance: [],
    deliveryPerformance: []
};

// ===================================================================================
// APPLICATION INITIALIZATION & LIFECYCLE
// ===================================================================================

/**
 * @description Main entry point. This event listener ensures the script runs only
 *              after the entire HTML document has been loaded and parsed.
 */
document.addEventListener('DOMContentLoaded', initializeApp);

/**
 * @async
 * @description Initializes the application by loading all necessary data, setting up UI
 *              components, and attaching all primary event listeners.
 */
async function initializeApp() {
    try {
        // Use Promise.all to fetch initial data concurrently for faster load times.
        await Promise.all([
            loadDashboardCards(),
            loadReviews(),
            //loadVendorPerformance(),
            //loadDeliveryPerformance()
        ]);

        // Once data is loaded, set up the interactive parts of the UI.
        initializeFilters();
        initializeModals();
        initializeSorting();
        setupEventListeners();

    } catch (error) {
        showAlert('Failed to initialize application. Please refresh the page.', 'error');
        console.error('Initialization error:', error);
    }
}

/**
 * @description Centralized function to set up all event listeners for the page.
 */
function setupEventListeners() {
    document.getElementById('reviewTypeFilter').addEventListener('change', filterReviews);
    document.getElementById('ratingFilter').addEventListener('change', filterReviews);
    document.getElementById('statusFilter').addEventListener('change', filterReviews);
    document.getElementById('reviewSearch').addEventListener('keyup', debounce(filterReviews, 300));
    document.getElementById('searchReviewBtn').addEventListener('click', loadGlobalSearch);
    document.getElementById('exportBtn').addEventListener('click', exportReviews);
    document.getElementById('replyForm').addEventListener('submit', handleReplySubmit);
}

// ===================================================================================
// DATA LOADING FUNCTIONS
// ===================================================================================

/**
 * @async
 * @description Fetches reviews from the API using the current filters, updates the app state, and re-renders the table.
 */
async function loadReviews() {
    try {
        const response = await apiService.getReviews(appState.currentFilters);
        appState.reviews = response.customerReviews; // Handle different API response structures
        renderReviewsTable(); // Re-render the table with new data
        appState.vendorPerformance = response.vendorPerformance;
        renderVendorPerformance();
        appState.deliveryPerformance = response.deliveryPerformance;
        renderDeliveryPerformance();
    } catch (error) {
        // The error is logged by the apiService, so we just show a user-facing message here.
        showAlert('Failed to load reviews. Please try again.', 'error');
    }
}
async function loadGlobalSearch() {
    try {
            const response = await fetch(`${API_BASE_URL2}${API_ENDPOINTS.GLOBAL_SEARCH}`, {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json"
                        },
                        body: JSON.stringify({
                            search: document.getElementById('reviewSearch').value
                        })
            });
            const data = await response.json();
            appState.reviews = data.customerReviews; // Handle different API response structures
            renderReviewsTable(); // Re-render the table with new data
            appState.vendorPerformance = data.vendorPerformance;
            renderVendorPerformance();
            appState.deliveryPerformance = data.deliveryPerformance;
            renderDeliveryPerformance();
        } catch (error) {
            // The error is logged by the apiService, so we just show a user-facing message here.
            showAlert('Failed to load reviews. Please try again.', 'error');
        }
}

/**
 * @async
 * @description Fetches vendor performance data, updates the state, and re-renders the corresponding table.
 */
async function loadVendorPerformance() {
    try {
        const response = await apiService.getVendorPerformance();
        appState.vendorPerformance = response.data || response;
        renderVendorPerformance();
    } catch (error) {
        showAlert('Failed to load vendor performance data.', 'error');
    }
}

/**
 * @async
 * @description Fetches delivery performance data, updates the state, and re-renders the corresponding table.
 */
async function loadDeliveryPerformance() {
    try {
        const response = await apiService.getDeliveryPerformance();
        appState.deliveryPerformance = response.data || response;
        renderDeliveryPerformance();
    } catch (error) {
        showAlert('Failed to load delivery performance data.', 'error');
    }
}

// ===================================================================================
// UI INITIALIZATION & RENDERING
// ===================================================================================

/**
 * @description Reads URL query parameters on page load to pre-select filters.
 *              This allows for sharing/bookmarking filtered views.
 */
function initializeFilters() {
    const urlParams = new URLSearchParams(window.location.search);
    const filtersToSet = {
        type: urlParams.get('type'),
        rating: urlParams.get('rating'),
        status: urlParams.get('status'),
        search: urlParams.get('search')
    };

    if (filtersToSet.type) {
        document.getElementById('reviewTypeFilter').value = filtersToSet.type;
        appState.currentFilters.type = filtersToSet.type;
    }
    if (filtersToSet.rating) {
        document.getElementById('ratingFilter').value = filtersToSet.rating;
        appState.currentFilters.rating = filtersToSet.rating;
    }
    if (filtersToSet.status) {
        document.getElementById('statusFilter').value = filtersToSet.status;
        appState.currentFilters.status = filtersToSet.status;
    }
    if (filtersToSet.search) {
        document.getElementById('reviewSearch').value = filtersToSet.search;
        appState.currentFilters.search = filtersToSet.search;
    }
}

/**
 * @description Sets up event listeners for Bootstrap modals to handle dynamic content loading.
 */
function initializeModals() {
    const replyModal = document.getElementById('replyModal');
    if (replyModal) {
        // This event fires just before the modal is shown.
        replyModal.addEventListener('show.bs.modal', function(event) {
            const button = event.relatedTarget; // The button that triggered the modal
            const reviewId = button.getAttribute('data-review-id');
            document.getElementById('replyReviewId').value = reviewId;
        });
    }

    const detailModal = document.getElementById('detailModal');
    if (detailModal) {
        detailModal.addEventListener('show.bs.modal', function(event) {
            const button = event.relatedTarget;
            const reviewId = button.getAttribute('data-review-id');
            loadReviewDetails(reviewId); // Fetch and display details when modal opens.
        });
    }

    const imageModal = document.getElementById('imageModal');
    if (imageModal) {
        imageModal.addEventListener('show.bs.modal', function(event) {
            const button = event.relatedTarget;
            const imageSrc = button.getAttribute('data-image-src');
            document.getElementById('modalImage').src = imageSrc;
        });
    }
}

/**
 * @description Attaches click event listeners to the sorting options.
 */
function initializeSorting() {
    const sortOptions = document.querySelectorAll('.sort-option');
    sortOptions.forEach(option => {
        option.addEventListener('click', function(e) {
            e.preventDefault();
            const sortBy = this.getAttribute('data-sort');
            sortReviews(sortBy);

            // Visually update which sort option is active.
            sortOptions.forEach(opt => opt.classList.remove('active'));
            this.classList.add('active');
        });
    });
}

/**
 * @description Renders the main reviews table with data from the application state.
 */
function renderReviewsTable() {
    const tbody = document.querySelector('#reviewsTable tbody');

    if (!appState.reviews || appState.reviews.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="7" class="text-center py-4">
                    <div class="empty-state">
                        <i class="fas fa-comment-slash fa-2x text-muted mb-2"></i>
                        <h5>No reviews found</h5>
                        <p class="text-muted">Try adjusting your filters to see more results.</p>
                    </div>
                </td>
            </tr>
        `;
        return;
    }

    // Use map to transform the array of review objects into an array of HTML strings.
    tbody.innerHTML = appState.reviews.map(review => `
        <tr>
            <td>
                <div class="d-flex align-items-center">
                    <img src="${review.reviewerName || '/resources/images/default-avatar.jpg'}"
                         class="rounded-circle me-3" width="40" height="40" alt="${review.reviewerName}">
                    <div>
                        <h6 class="mb-0">${review.reviewerName}</h6>
                    </div>
                </div>
            </td>
            <td><p>${review.type}</p></td>
            <td><div class="rating-stars">${generateStars(review.rating)}<span class="ms-1 small">(${review.rating})</span></div></td>
            <td>
                <p class="mb-1 review-comment">${review.comment}</p>
                ${review.images && review.images.length > 0 ? `
                <div class="review-images mt-2">
                    ${review.images.map(image => `<img src="${image}" class="img-thumbnail me-1" width="50" height="50" data-bs-toggle="modal" data-bs-target="#imageModal" data-image-src="${image}">`).join('')}
                </div>` : ''}
            </td>
            <td>${formatDate(review.date)}</td>
            <td><p>${review.status}</p></td>
            <td>
                <div class="btn-group btn-group-sm" role="group">
                    ${review.status === 'PENDING' ? `
                    <button class="btn btn-outline-success" onclick="approveReview('${review.id}')" title="Approve"><i class="fas fa-check"></i></button>
                    <button class="btn btn-outline-danger" onclick="rejectReview('${review.id}')" title="Reject"><i class="fas fa-times"></i></button>` : ''}
                    <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#replyModal" data-review-id="${review.id}" title="Reply"><i class="fas fa-reply"></i></button>
                    <button class="btn btn-outline-info" data-bs-toggle="modal" data-bs-target="#detailModal" data-review-id="${review.id}" title="View Details"><i class="fas fa-eye"></i></button>
                </div>
            </td>
        </tr>
    `).join('');


}

/**
 * @description Renders the vendor performance table.
 */
function renderVendorPerformance() {
    const tbody = document.querySelector('#vendorTable tbody');
    if (!appState.vendorPerformance || appState.vendorPerformance.length === 0) {
        tbody.innerHTML = `<tr><td colspan="9" class="text-center py-4"><i class="fas fa-store-slash fa-2x text-muted mb-2"></i><p class="text-muted">No vendor data available</p></td></tr>`;
        return;
    }
    tbody.innerHTML = appState.vendorPerformance.map(vendor => `
        <tr>
            <td>
                <div class="d-flex align-items-center">
                    <img src="${vendor.profilePic || '/resources/images/default-vendor.jpg'}" class="rounded-circle me-3" width="40" height="40" alt="${vendor.vendorName}">
                    <div><h6 class="mb-0">${vendor.vendorName}</h6></div>
                </div>
            </td>
            <td><div class="d-flex align-items-center"><strong class="me-2">${vendor.rating.toFixed(1)}</strong><div class="rating-stars small">${generateStars(vendor.rating)}</div></div></td>
            <td>${vendor.totalReviews}</td>
            <td><span class="text-success">${vendor.fiveStar}</span></td>
            <td>${vendor.fourStar}</td>
            <td>${vendor.threeStar}</td>
            <td>${vendor.twoStar}</td>
            <td><span class="text-danger">${vendor.oneStar}</span></td>
            <td><button class="btn btn-sm btn-outline-primary" onclick="viewVendorReviews('${vendor.id}')">View All</button></td>
        </tr>
    `).join('');
}

/**
 * @description Renders the delivery performance table.
 */
function renderDeliveryPerformance() {
    const tbody = document.querySelector('#deliveryTable tbody');
    if (!appState.deliveryPerformance || appState.deliveryPerformance.length === 0) {
        tbody.innerHTML = `<tr><td colspan="9" class="text-center py-4"><i class="fas fa-motorcycle fa-2x text-muted mb-2"></i><p class="text-muted">No delivery data available</p></td></tr>`;
        return;
    }
    tbody.innerHTML = appState.deliveryPerformance.map(delivery => `
        <tr>
            <td>
                <div class="d-flex align-items-center">
                    <img src="${delivery.profilePic || '/resources/images/default-delivery.jpg'}" class="rounded-circle me-3" width="40" height="40" alt="${delivery.deliveryPerson}">
                    <div><h6 class="mb-0">${delivery.deliveryPerson}</h6></div>
                </div>
            </td>
            <td><div class="d-flex align-items-center"><strong class="me-2">${delivery.rating.toFixed(1)}</strong><div class="rating-stars small">${generateStars(delivery.rating)}</div></div></td>
            <td>${delivery.totalReviews}</td>
            <td><span class="text-success">${delivery.fiveStar}</span></td>
            <td>${delivery.fourStar}</td>
            <td>${delivery.threeStar}</td>
            <td>${delivery.twoStar}</td>
            <td><span class="text-danger">${delivery.oneStar}</span></td>
            <td><button class="btn btn-sm btn-outline-primary" onclick="viewDeliveryReviews('${delivery.id}')">View All</button></td>
        </tr>
    `).join('');
}


// ... (loadReviewDetails - the original function is complete and would be here)


// ===================================================================================
// EVENT HANDLERS & BUSINESS LOGIC
// ===================================================================================

/**
 * @async
 * @description Event handler that triggers when any filter value changes. It updates the
 *              application state, fetches a new list of reviews, and updates the URL.
 */
async function filterReviews() {
    appState.currentFilters = {
        type: document.getElementById('reviewTypeFilter').value,
        rating: document.getElementById('ratingFilter').value,
        status: document.getElementById('statusFilter').value,
        search: document.getElementById('reviewSearch').value
    };
    await loadReviews();
    updateUrlParams(appState.currentFilters);
}

/**
 * @description Sorts the locally stored reviews array based on the chosen criterion and re-renders the table.
 * @param {string} sortBy - The sorting key ('newest', 'oldest', 'highest', 'lowest').
 */
function sortReviews(sortBy) {
    appState.currentSort = sortBy;
    appState.reviews.sort((a, b) => {
        switch (sortBy) {
            case 'newest': return new Date(b.date) - new Date(a.date);
            case 'oldest': return new Date(a.date) - new Date(b.date);
            case 'highest': return b.rating - a.rating;
            case 'lowest': return a.rating - b.rating;
            default: return 0;
        }
    });
    renderReviewsTable(); // Re-render the table with the sorted data.
}

/**
 * @async
 * @description Handles the submission of the reply form in the modal.
 * @param {Event} event - The form submission event.
 */
async function handleReplySubmit(event) {
    event.preventDefault(); // Prevent default form submission which reloads the page.
    const form = event.target;
    const reviewId = form.querySelector('#replyReviewId').value;
    const reply = form.querySelector('#replyText').value;
    const sendEmail = form.querySelector('#sendEmailCheckbox').checked;
    const submitBtn = form.querySelector('button[type="submit"]');

    // Provide user feedback by disabling the button and showing a spinner.
    const originalText = submitBtn.innerHTML;
    submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Sending...';
    submitBtn.disabled = true;

    try {
        await apiService.submitReply(reviewId, { reply, sendEmail });
        showAlert('Reply sent successfully!', 'success');
        bootstrap.Modal.getInstance(document.getElementById('replyModal')).hide();
        form.reset();
        await loadReviews(); // Refresh the list to show any status changes.
    } catch (error) {
        showAlert('Failed to send reply. Please try again.', 'error');
    } finally {
        // Always restore the button to its original state.
        submitBtn.innerHTML = originalText;
        submitBtn.disabled = false;
    }
}

/**
 * @async
 * @description Approves a review after user confirmation.
 * @param {string} reviewId - The ID of the review to approve.
 */
async function approveReview(reviewId) {
    if (confirm('Are you sure you want to approve this review?')) {
        try {
            await apiService.updateReviewStatus(reviewId, 'APPROVED');
            showAlert('Review approved successfully!', 'success');
            await loadReviews(); // Refresh the list.
        } catch (error) {
            showAlert('Failed to approve review.', 'error');
        }
    }
}

/**
 * @async
 * @description Rejects a review after user confirmation.
 * @param {string} reviewId - The ID of the review to reject.
 */
async function rejectReview(reviewId) {
    if (confirm('Are you sure you want to reject this review?')) {
        try {
            await apiService.updateReviewStatus(reviewId, 'REJECTED');
            showAlert('Review rejected successfully!', 'success');
            await loadReviews(); // Refresh the list.
        } catch (error) {
            showAlert('Failed to reject review.', 'error');
        }
    }
}

/**
 * @description A helper function to filter the main review list by vendor and scroll to it.
 * @param {string} vendorId - The ID of the vendor.
 */
function viewVendorReviews(vendorId) {
    document.getElementById('reviewTypeFilter').value = 'VENDOR';
    // Note: A more robust implementation would also filter by vendorId if the API supports it.
    // e.g., appState.currentFilters.vendorId = vendorId;
    filterReviews();
    document.getElementById('reviewsTable').scrollIntoView({ behavior: 'smooth' });
}

/**
 * @description A helper function to filter the main review list by delivery and scroll to it.
 * @param {string} deliveryId - The ID of the delivery person.
 */
function viewDeliveryReviews(deliveryId) {
    document.getElementById('reviewTypeFilter').value = 'DELIVERY';
    filterReviews();
    document.getElementById('reviewsTable').scrollIntoView({ behavior: 'smooth' });
}

/**
 * @async
 * @description Initiates the export process using the current filters.
 */
async function exportReviews() {
    try {
        await apiService.exportReviews('csv', appState.currentFilters);
        showAlert('Export started. Your download will begin shortly.', 'success');
    } catch (error) {
        showAlert('Failed to export reviews.', 'error');
    }
}

// ===================================================================================
// UTILITY & HELPER FUNCTIONS
// ===================================================================================

/**
 * @description Generates the HTML for star ratings.
 * @param {number} rating - The rating value (e.g., 4).
 * @returns {string} The HTML string of star icons.
 */
function generateStars(rating) {
    let stars = '';
    for (let i = 1; i <= 5; i++) {
        stars += `<i class="${i <= rating ? 'fas' : 'far'} fa-star"></i>`;
    }
    return stars;
}

/**
 * @description Formats an ISO date string into a more readable format (e.g., "Sep 5, 2025").
 * @param {string} dateString - The date string from the API.
 * @returns {string} The formatted date.
 */
function formatDate(dateString) {
    return new Date(dateString).toLocaleDateString('en-US', {
        year: 'numeric', month: 'short', day: 'numeric'
    });
}

/**
 * @description Displays a temporary, dismissible alert message to the user.
 * @param {string} message - The message to display.
 * @param {'success'|'error'} type - The type of alert, which determines its color.
 */
function showAlert(message, type) {
    const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
    const alertHtml = `
        <div class="alert ${alertClass} alert-dismissible fade show position-fixed" style="top: 20px; right: 20px; z-index: 1050;" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    `;
    document.body.insertAdjacentHTML('beforeend', alertHtml);

    // Auto-dismiss the alert after 3 seconds for better user experience.
    setTimeout(() => {
        const newAlert = document.body.querySelector('.alert-dismissible:last-of-type');
        if (newAlert) bootstrap.Alert.getOrCreateInstance(newAlert).close();
    }, 3000);
}

/**
 * @description Updates the URL's query parameters without reloading the page.
 * @param {object} params - An object of key-value pairs to set as query parameters.
 */
function updateUrlParams(params) {
    const url = new URL(window.location);
    Object.entries(params).forEach(([key, value]) => {
        if (value && value !== 'all') {
            url.searchParams.set(key, value);
        } else {
            url.searchParams.delete(key);
        }
    });
    // `replaceState` modifies the history entry instead of creating a new one.
    window.history.replaceState({}, '', url);
}

/**
 * @description A debounce utility. It limits the rate at which a function gets called.
 *              This is crucial for performance on inputs that fire many events, like a search box's 'keyup'.
 * @param {Function} func - The function to debounce.
 * @param {number} wait - The delay in milliseconds.
 * @returns {Function} A new debounced version of the function.
 */
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// ===================================================================================
// GLOBAL FUNCTION EXPOSURE
// ===================================================================================

/**
 * @description Functions that are called directly from inline HTML attributes (e.g., `onclick="..."`)
 *              must be attached to the global `window` object to be accessible from that scope.
 *              While modern approaches favor adding event listeners programmatically (event delegation),
 *              this method is a straightforward way to handle events on dynamically generated content.
 */
window.approveReview = approveReview;
window.rejectReview = rejectReview;
window.viewVendorReviews = viewVendorReviews;
window.viewDeliveryReviews = viewDeliveryReviews;