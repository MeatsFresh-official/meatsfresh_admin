/**
 * @file This script manages the user list page for the admin panel.
 * @description It handles fetching, displaying, filtering, deleting, and exporting user data.
 * @author Your Sai Manikanta/MeatsFresh
 * @version 1.0
 */

// ===================================================================================
// CONFIGURATION & GLOBAL STATE
// ===================================================================================

/**
 * Centralized configuration for all API requests.
 * Storing this here makes it easy to update the base URL or endpoints in one place.
 */
const API_CONFIG = {
    baseUrl: 'http://localhost:8080',
    endpoints: {
        users: '/api/users',
        stats: '/api/users/stats',
        deleteUser: '/api/users/', // Note: User ID will be appended to this
        exportBasic: '/api/export/basic',
        exportAdvanced: '/api/export/advanced',
        exportNumbers: '/api/export/numbers'
    }
};

/**
 * @global
 * @description Holds the currently active filter settings. This is used to re-apply
 * filters when refreshing data (e.g., after a deletion) and for export requests.
 */
let currentFilters = {};

/**
 * @global
 * @description Caches the latest user statistics fetched from the API.
 */
let userStats = {};

// ===================================================================================
// UI & DOM UTILITY FUNCTIONS
// ===================================================================================

/**
 * Shows or hides the loading indicator.
 * @param {boolean} show - If true, displays the loading spinner; otherwise, hides it.
 */
function showLoading(show) {
    const loadingIndicator = document.getElementById('loadingIndicator');
    const usersTableBody = document.getElementById('usersTableBody');

    if (show) {
        loadingIndicator.style.display = 'block';
        // Clear the table while loading to prevent showing stale data.
        usersTableBody.innerHTML = '';
    } else {
        loadingIndicator.style.display = 'none';
    }
}

/**
 * Displays an error message to the user.
 * NOTE: This is a simple implementation using `alert`. For a better user experience,
 * replace this with a more sophisticated toast notification library (e.g., Toastr, SweetAlert2).
 * @param {string} message - The error message to display.
 */
function showError(message) {
    alert('Error: ' + message);
}

/**
 * Displays a success message to the user.
 * NOTE: Like showError, this can be upgraded to a toast notification.
 * @param {string} message - The success message to display.
 */
function showSuccess(message) {
    alert('Success: ' + message);
}

/**
 * Formats a number into a compact Indian currency string (e.g., 150000 -> ₹1.5L).
 * @param {number} amount - The currency amount to format.
 * @returns {string} The formatted currency string.
 */
function formatCurrency(amount) {
    if (amount >= 100000) {
        return '₹' + (amount / 100000).toFixed(1) + 'L';
    } else if (amount >= 1000) {
        return '₹' + (amount / 1000).toFixed(1) + 'k';
    } else {
        return '₹' + amount;
    }
}

/**
 * Formats a date string into a readable format (e.g., "05 Sep 2025").
 * @param {string} dateString - The ISO date string from the server.
 * @returns {string} The formatted date string.
 */
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-IN', {
        day: '2-digit',
        month: 'short',
        year: 'numeric'
    });
}

/**
 * Formats a date string into a readable time format (e.g., "03:50 PM").
 * @param {string} dateString - The ISO date string from the server.
 * @returns {string} The formatted time string.
 */
function formatTime(dateString) {
    const date = new Date(dateString);
    return date.toLocaleTimeString('en-IN', {
        hour: '2-digit',
        minute: '2-digit',
        hour12: true
    });
}

/**
 * Updates the "Showing X of Y users" count in the UI.
 * @param {number} count - The number of users currently displayed in the table.
 */
function updateUserCount(count) {
    document.getElementById('showingCount').textContent = count;
    // The total count is now updated from the stats object, so we can use that.
    document.getElementById('totalCount').textContent = userStats.totalUsers || 0;
}

/**
 * Updates the statistic cards at the top of the page with the latest data.
 */
function updateStatsDisplay() {
    document.getElementById('totalUsers').textContent = userStats.totalUsers || 0;
    document.getElementById('activeUsers').textContent = userStats.activeUsers || 0;
    document.getElementById('totalRevenue').textContent = formatCurrency(userStats.totalRevenue || 0);
    document.getElementById('avgOrderValue').textContent = formatCurrency(userStats.avgOrderValue || 0);
}

/**
 * Binds event listeners to the "select all" and individual row checkboxes.
 * This needs to be called every time the table rows are re-rendered.
 */
function bindCheckboxEvents() {
    const selectAll = document.getElementById('selectAll');
    const rowCheckboxes = document.querySelectorAll('.row-checkbox');

    if (!selectAll) return; // Guard clause if the element doesn't exist

    // Event listener for the "Select All" checkbox in the table header.
    selectAll.addEventListener('change', function() {
        rowCheckboxes.forEach(checkbox => {
            checkbox.checked = selectAll.checked;
        });
    });

    // Event listeners for each individual row checkbox.
    rowCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            if (!this.checked) {
                // If any row is unchecked, the "Select All" checkbox must also be unchecked.
                selectAll.checked = false;
            } else {
                // Check if all row checkboxes are now checked.
                const allChecked = Array.from(rowCheckboxes).every(cb => cb.checked);
                selectAll.checked = allChecked;
            }
        });
    });
}

// ===================================================================================
// API INTERACTION FUNCTIONS
// ===================================================================================

/**
 * Builds a URL query string from a filter object, ignoring 'all' or empty values.
 * @param {object} filters - The filter object (e.g., { activity: 'active', search: 'john' }).
 * @returns {URLSearchParams} A URLSearchParams object ready to be appended to a URL.
 */
function buildQueryString(filters) {
    const queryParams = new URLSearchParams();
    for (const key in filters) {
        const value = filters[key];
        // Only add the parameter if it has a meaningful value.
        if (value && value !== 'all') {
            queryParams.append(key, value);
        }
    }
    return queryParams;
}

/**
 * Fetches user statistics from the API based on the provided filters.
 * @param {object} filters - The filter object to send to the API.
 */
async function fetchStats(filters = {}) {
    try {
        const queryParams = buildQueryString(filters);
        const response = await fetch(`${API_CONFIG.baseUrl}${API_CONFIG.endpoints.stats}?${queryParams}`);

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        // Store the response in the global state and update the UI.
        userStats = await response.json();
        updateStatsDisplay();

    } catch (error) {
        console.error('Error fetching stats:', error);
        // Don't show a user-facing error here, as the main user list might still load.
    }
}

/**
 * Main function to fetch the list of users and their aggregate stats.
 * It orchestrates showing the loading state, fetching data, and rendering the results.
 * @param {object} [filters={}] - An object containing all filter criteria.
 */
async function fetchUsers(filters = {}) {
    try {
        showLoading(true);
        currentFilters = filters; // Update the global state with the latest filters.

        // Fetch stats and users concurrently for better performance.
        await Promise.all([
            fetchStats(filters),
            (async () => {
                const queryParams = buildQueryString(filters);
                const response = await fetch(`${API_CONFIG.baseUrl}${API_CONFIG.endpoints.users}?${queryParams}`);
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                const users = await response.json();
                renderUsers(users); // Render the table with the fetched user data.
                updateUserCount(users.length); // Update the user count display.
            })()
        ]);

    } catch (error) {
        console.error('Error fetching users:', error);
        showError('Failed to load users. Please try again.');
    } finally {
        // The 'finally' block ensures the loading indicator is hidden,
        // regardless of whether the fetch succeeded or failed.
        showLoading(false);
    }
}

/**
 * Renders the user data into the HTML table.
 * @param {Array<object>} users - An array of user objects from the API.
 */
function renderUsers(users) {
    const tbody = document.getElementById('usersTableBody');
    tbody.innerHTML = ''; // Clear any existing content.

    // Display a message if no users match the criteria.
    if (users.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="9" class="text-center py-4">
                    <i class="fas fa-users fa-2x text-muted mb-2"></i>
                    <p class="text-muted">No users found matching your criteria</p>
                </td>
            </tr>
        `;
        return;
    }

    // Create a table row for each user.
    users.forEach(user => {
        const row = document.createElement('tr');
        // Set data-* attributes. This can be useful for advanced filtering or styling.
        row.setAttribute('data-user-id', user.id);

        // Use template literals for clean and readable HTML generation.
        row.innerHTML = `
            <td>
                <div class="form-check">
                    <input class="form-check-input row-checkbox" type="checkbox" value="${user.id}">
                </div>
            </td>
            <td>
                <div class="d-flex align-items-center">
                    <div class="avatar me-3">
                        <img src="${user.profileImage || '/resources/images/default-avatar.jpg'}"
                             class="rounded-circle" width="40" height="40" alt="${user.name}">
                    </div>
                    <div>
                        <h6 class="mb-0">${user.name}</h6>
                        <small class="text-muted">ID: ${user.id}</small>
                    </div>
                </div>
            </td>
            <td>
                <div class="fw-medium">${user.phone}</div>
                <small class="text-muted">${user.email}</small>
            </td>
            <td>
                <div>${user.city}, ${user.country}</div>
                <small class="text-muted">${user.address}</small>
            </td>
            <td>
                <span class="badge bg-primary rounded-pill">${user.totalOrders}</span>
            </td>
            <td class="fw-bold text-success">${formatCurrency(user.totalSpent)}</td>
            <td>
                <div class="text-nowrap">${formatDate(user.lastActive)}</div>
                <small class="text-muted">${formatTime(user.lastActive)}</small>
            </td>
            <td>
                <span class="badge ${user.lastActiveDays <= 30 ? 'bg-success' : 'bg-secondary'}">
                    ${user.lastActiveDays <= 30 ? 'Active' : 'Inactive'}
                </span>
            </td>
            <td>
                <div class="btn-group btn-group-sm" role="group">
                    <a href="user-view?id=${user.id}" class="btn btn-outline-primary" data-bs-toggle="tooltip" title="View"><i class="fas fa-eye"></i></a>
                    <a href="user-edit?id=${user.id}" class="btn btn-outline-secondary" data-bs-toggle="tooltip" title="Edit"><i class="fas fa-edit"></i></a>
                    <button class="btn btn-outline-danger" onclick="confirmDelete('${user.id}')" data-bs-toggle="tooltip" title="Delete"><i class="fas fa-trash"></i></button>
                </div>
            </td>
        `;

        tbody.appendChild(row);
    });

    // IMPORTANT: After adding new elements to the DOM, any libraries that interact with them
    // (like Bootstrap's Tooltip) must be re-initialized.
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));

    // We also need to re-bind events for the new checkboxes.
    bindCheckboxEvents();
}

// ===================================================================================
// EVENT HANDLER & BUSINESS LOGIC FUNCTIONS
// ===================================================================================

/**
 * Gathers all filter values from the input fields and triggers a user fetch.
 */
function applyFilters() {
    const filters = {
        activity: document.getElementById('activityFilter').value,
        spending: document.getElementById('spendingFilter').value,
        type: document.getElementById('typeFilter').value,
        search: document.getElementById('userSearch').value
    };

    fetchUsers(filters);
}

/**
 * Handles the logic for downloading user data in various formats.
 * @param {string} type - The type of export ('basic', 'advanced', 'numbers').
 */
async function downloadData(type) {
    try {
        // Collect IDs of selected users for a targeted export.
        const selectedIds = Array.from(document.querySelectorAll('.row-checkbox:checked')).map(cb => cb.value);

        // Combine current filters with export-specific parameters.
        const params = {
            ...currentFilters,
            selectedIds: selectedIds.length > 0 ? selectedIds.join(',') : 'all'
        };

        const queryParams = buildQueryString(params);
        const endpoint = API_CONFIG.endpoints[`export${type.charAt(0).toUpperCase() + type.slice(1)}`];
        const url = `${API_CONFIG.baseUrl}${endpoint}?${queryParams}`;

        const response = await fetch(url);

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        // Extract filename from the 'Content-Disposition' header sent by the server.
        const contentDisposition = response.headers.get('Content-Disposition');
        let filename = `users_export_${type}.csv`; // A sensible default.
        if (contentDisposition) {
            const filenameMatch = contentDisposition.match(/filename="?(.+)"?/);
            if (filenameMatch && filenameMatch.length === 2) {
                filename = filenameMatch[1];
            }
        }

        // To trigger a file download, we convert the response body into a 'blob',
        // create a temporary URL for it, and programmatically click a hidden link.
        const blob = await response.blob();
        const downloadUrl = window.URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.href = downloadUrl;
        link.download = filename;
        document.body.appendChild(link);
        link.click();

        // Clean up by removing the link and revoking the temporary URL.
        link.remove();
        window.URL.revokeObjectURL(downloadUrl);

    } catch (error) {
        console.error('Error downloading data:', error);
        showError('Failed to download data. Please try again.');
    }
}

/**
 * Shows a confirmation modal before deleting a user.
 * @param {string} userId - The ID of the user to be deleted.
 */
function confirmDelete(userId) {
    // Pass the user ID to the modal's hidden input field.
    document.getElementById('deleteUserId').value = userId;
    // Use Bootstrap's JavaScript API to show the modal.
    const modal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
    modal.show();
}

/**
 * Executes the actual user deletion after confirmation.
 */
async function deleteUser() {
    const userId = document.getElementById('deleteUserId').value;
    const modal = bootstrap.Modal.getInstance(document.getElementById('deleteConfirmModal'));

    try {
        const response = await fetch(`${API_CONFIG.baseUrl}${API_CONFIG.endpoints.deleteUser}${userId}`, {
            method: 'DELETE'
            // Headers for CSRF token or Authorization would go here if needed.
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        showSuccess('User deleted successfully');
        // Refresh the user list to reflect the deletion, using the last active filters.
        fetchUsers(currentFilters);

    } catch (error) {
        console.error('Error deleting user:', error);
        showError('Failed to delete user. Please try again.');
    } finally {
        // Ensure the modal is hidden after the operation.
        if (modal) modal.hide();
    }
}

// ===================================================================================
// INITIALIZATION
// ===================================================================================

/**
 * This is the main entry point. The 'DOMContentLoaded' event ensures that this
 * script runs only after the entire HTML document has been loaded and parsed.
 */
document.addEventListener('DOMContentLoaded', function() {
    // Initialize Bootstrap components like tooltips.
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));

    // --- Initial Data Load ---
    // Fetch the initial list of users and stats without any filters.
    fetchUsers();

    // --- Event Listener Setup ---
    // Attach event listeners to all interactive elements on the page.

    // Filter controls
    document.getElementById('activityFilter').addEventListener('change', applyFilters);
    document.getElementById('spendingFilter').addEventListener('change', applyFilters);
    document.getElementById('typeFilter').addEventListener('change', applyFilters);
    document.getElementById('searchBtn').addEventListener('click', applyFilters);
    document.getElementById('userSearch').addEventListener('keyup', (event) => {
        if (event.key === 'Enter') applyFilters();
    });

    // Reset filters button
    document.getElementById('resetFiltersBtn').addEventListener('click', () => {
        document.getElementById('activityFilter').value = 'all';
        document.getElementById('spendingFilter').value = 'all';
        document.getElementById('typeFilter').value = 'all';
        document.getElementById('userSearch').value = '';
        fetchUsers(); // Fetch with no filters.
    });

    // Date range modal "Apply" button
    document.getElementById('applyDateRange').addEventListener('click', () => {
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;

        // Simple validation
        if (!startDate || !endDate || new Date(startDate) > new Date(endDate)) {
            showError('Please select a valid date range.');
            return;
        }

        // Hide the modal and apply the date range along with other active filters.
        bootstrap.Modal.getInstance(document.getElementById('dateRangeModal')).hide();
        const filtersWithDate = { ...currentFilters, startDate, endDate };
        fetchUsers(filtersWithDate);
    });

    // Download buttons
    document.getElementById('downloadBasicBtn').addEventListener('click', (e) => {
        e.preventDefault(); downloadData('basic');
    });
    document.getElementById('downloadAdvancedBtn').addEventListener('click', (e) => {
        e.preventDefault(); downloadData('advanced');
    });
    document.getElementById('downloadNumbersBtn').addEventListener('click', (e) => {
        e.preventDefault(); downloadData('numbers');
    });

    // Final confirmation button in the delete modal
    document.getElementById('confirmDeleteBtn').addEventListener('click', deleteUser);
});