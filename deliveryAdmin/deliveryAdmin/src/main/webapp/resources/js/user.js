/**
 * @file This script manages the user list page for the admin panel.
 * @description It handles fetching, displaying, filtering, deleting, and exporting user data.
 * @author Your Sai Manikanta/MeatsFresh
 * @version 1.1 - Added Server-Side Pagination
 */

// ===================================================================================
// CONFIGURATION & GLOBAL STATE
// ===================================================================================

const API_CONFIG = {
    baseUrl: 'http://localhost:8080',
    baseUrl2: 'http://meatsfresh.org.in:8082',
    baseUrl3: 'http://meatsfresh.org.in:8083',
    endpoints: {
        users: '/api/dashboard/table',
        stats: '/deliveryAdmin/api/dashboard/users-card',
        globalSearch: '/api/dashboard/users/search',
        deleteUser: '/api/users/',
        exportBasic: '/api/export/basic',
        exportAdvanced: '/api/export/advanced',
        exportNumbers: '/api/export/numbers'
    }
};

let currentFilters = {};
let userStats = {};

// Pagination State
let currentPage = 0;
let itemsPerPage = 10; // Default
let totalPages = 0;
let totalElements = 0;

// ===================================================================================
// UI & DOM UTILITY FUNCTIONS
// ===================================================================================

function showLoading(show) {
    const loadingIndicator = document.getElementById('loadingIndicator');
    const usersTableBody = document.getElementById('usersTableBody');
    const paginationContainer = document.getElementById('userPagination');

    if (show) {
        loadingIndicator.style.display = 'block';
        usersTableBody.innerHTML = '';
        if (paginationContainer) paginationContainer.style.display = 'none';
    } else {
        loadingIndicator.style.display = 'none';
        if (paginationContainer) paginationContainer.style.display = 'block';
    }
}

function showError(message) {
    alert('Error: ' + message);
}

function showSuccess(message) {
    alert('Success: ' + message);
}

function formatCurrency(amount) {
    if (!amount) return '₹0';
    if (amount >= 100000) {
        return '₹' + +(amount / 100000).toFixed(1) + 'L';
    } else if (amount >= 1000) {
        return '₹' + +(amount / 1000).toFixed(1) + 'k';
    } else {
        return '₹' + amount;
    }
}

function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-IN', {
        day: '2-digit',
        month: 'short',
        year: 'numeric'
    });
}

function formatTime(dateString) {
    const date = new Date(dateString);
    return date.toLocaleTimeString('en-IN', {
        hour: '2-digit',
        minute: '2-digit',
        hour12: true
    });
}

function updateUserCount(count) {
    // Optionally update specific count element if exists
}

function updateStatsDisplay() {
    document.getElementById('totalUsers').textContent = userStats.totalUsers || 0;
    document.getElementById('activeUsers').textContent = userStats.activeUsersLast30Days || 0;
    document.getElementById('totalRevenue').textContent = formatCurrency(userStats.totalRevenue || 0);
    document.getElementById('avgOrderValue').textContent = formatCurrency(userStats.avgOrderValue || 0);
}

function isUserActive(lastActiveDate) {
    if (!lastActiveDate) return false;
    const lastActive = new Date(lastActiveDate);
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
    return lastActive >= thirtyDaysAgo;
}

function bindCheckboxEvents() {
    const selectAll = document.getElementById('selectAll');
    const rowCheckboxes = document.querySelectorAll('.row-checkbox');

    if (!selectAll) return;

    selectAll.addEventListener('change', function () {
        rowCheckboxes.forEach(checkbox => {
            checkbox.checked = selectAll.checked;
        });
    });

    rowCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function () {
            if (!this.checked) {
                selectAll.checked = false;
            } else {
                const allChecked = Array.from(rowCheckboxes).every(cb => cb.checked);
                selectAll.checked = allChecked;
            }
        });
    });
}

// ===================================================================================
// PAGINATION LOGIC
// ===================================================================================

function renderPaginationControls() {
    const container = document.getElementById('userPagination');
    if (!container) return;

    if (totalElements === 0) {
        container.innerHTML = '';
        return;
    }

    // Adjust page index (0-based in backend, 1-based in UI)
    const uiPage = currentPage + 1;

    let html = `
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 p-2 bg-light rounded-3 shadow-sm border border-light">
        <div class="d-flex align-items-center">
            <span class="text-muted small me-2">Show</span>
            <select class="form-select form-select-sm" style="width: 70px;" onchange="changePageSize(this.value)">
                <option value="5" ${itemsPerPage == 5 ? 'selected' : ''}>5</option>
                <option value="10" ${itemsPerPage == 10 ? 'selected' : ''}>10</option>
                <option value="25" ${itemsPerPage == 25 ? 'selected' : ''}>25</option>
                <option value="50" ${itemsPerPage == 50 ? 'selected' : ''}>50</option>
                <option value="100" ${itemsPerPage == 100 ? 'selected' : ''}>100</option>
            </select>
            <span class="text-muted small ms-2">entries</span>
        </div>
        
        <div class="d-flex align-items-center">
            <span class="text-muted small me-3">
                Showing ${currentPage * itemsPerPage + 1} to ${Math.min((currentPage + 1) * itemsPerPage, totalElements)} of ${totalElements}
            </span>

            <nav aria-label="Page navigation">
                <ul class="pagination pagination-sm mb-0">
                    <li class="page-item ${uiPage === 1 ? 'disabled' : ''}">
                        <button class="page-link border-0 rounded-start" onclick="changePage(${currentPage - 1})"><i class="fas fa-chevron-left"></i></button>
                    </li>
    `;

    const maxVisibleButtons = 5;
    let startPage = Math.max(1, uiPage - Math.floor(maxVisibleButtons / 2));
    let endPage = Math.min(totalPages, startPage + maxVisibleButtons - 1);

    if (endPage - startPage + 1 < maxVisibleButtons) {
        startPage = Math.max(1, endPage - maxVisibleButtons + 1);
    }

    if (startPage > 1) {
        html += `<li class="page-item"><button class="page-link border-0" onclick="changePage(0)">1</button></li>`;
        if (startPage > 2) html += `<li class="page-item disabled"><span class="page-link border-0">...</span></li>`;
    }

    for (let i = startPage; i <= endPage; i++) {
        const isActive = i === uiPage;
        // pass i - 1 because generic 'changePage' expects 0-based index
        html += `
            <li class="page-item ${isActive ? 'active' : ''}">
                <button class="page-link border-0 ${isActive ? 'bg-primary text-white shadow-sm' : ''}" onclick="changePage(${i - 1})">${i}</button>
            </li>
        `;
    }

    if (endPage < totalPages) {
        if (endPage < totalPages - 1) html += `<li class="page-item disabled"><span class="page-link border-0">...</span></li>`;
        html += `<li class="page-item"><button class="page-link border-0" onclick="changePage(${totalPages - 1})">${totalPages}</button></li>`;
    }

    html += `
                    <li class="page-item ${uiPage === totalPages ? 'disabled' : ''}">
                        <button class="page-link border-0 rounded-end" onclick="changePage(${currentPage + 1})"><i class="fas fa-chevron-right"></i></button>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
    `;

    container.innerHTML = html;
}

// Global functions for pagination onclick events
window.changePage = function (page) {
    if (page >= 0 && page < totalPages) {
        console.log("Changing to page:", page); // Debug
        fetchUsers({ page: page });
    }
};

window.changePageSize = function (size) {
    console.log("Changing page size to:", size); // Debug
    fetchUsers({ page: 0, size: parseInt(size) });
};


// ===================================================================================
// API INTERACTION FUNCTIONS
// ===================================================================================

function buildQueryString(filters) {
    const queryParams = new URLSearchParams();
    for (const key in filters) {
        const value = filters[key];
        if (value && value !== 'all') {
            queryParams.append(key, value);
        }
    }
    return queryParams;
}

async function fetchStats(filters = {}) {
    try {
        const queryParams = buildQueryString(filters);
        const response = await fetch(`${API_CONFIG.baseUrl}${API_CONFIG.endpoints.stats}?${queryParams}`);

        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);

        userStats = await response.json();
        updateStatsDisplay();

    } catch (error) {
        console.error('Error fetching stats:', error);
    }
}

async function fetchUsers(filters = {}) {
    try {
        showLoading(true);

        // Determine Page and Size
        // If filters has page, use it. Else use current global state.
        // If filters comes from 'Apply Filter' button, it might want to reset page to 0.
        // We'll trust the caller. If specific page not requested in filters, use current.

        let newPage = filters.page !== undefined ? filters.page : currentPage;
        let newSize = filters.size !== undefined ? filters.size : itemsPerPage;

        // If we represent a completely new filter criteria (e.g. searching, filter change),
        // we likely want to reset to page 0. But 'filters' passed here handles that.
        // 'applyFilters' should pass page: 0.

        // Update Global State
        currentPage = newPage;
        itemsPerPage = newSize;

        // Merge filters. However, we should be careful. 'filters' argument contains the *changes*.
        // We need to merge it with currentFilters, but remove page/size from currentFilters first if we want to be clean?
        // Actually, currentFilters should store the *criteria* (activity, spending, search).
        // Page and Size are effectively metadata.

        // Let's separate criteria from pagination.
        // If 'filters' has criteria, update currentFilters.
        if (filters.activity !== undefined || filters.spending !== undefined || filters.search !== undefined || filters.startDate !== undefined) {
            currentFilters = { ...filters };
            delete currentFilters.page;
            delete currentFilters.size;
        }

        // Prepare Request
        const username = "user";
        const password = "user";
        const basicAuth = btoa(`${username}:${password}`);

        // Construct payload combining persisted criteria + current pagination
        const requestBody = {
            activityStatus: ((currentFilters.activity || document.getElementById('activityFilter')?.value || "ALL")).toUpperCase(),
            spendingLevel: ((currentFilters.spending || document.getElementById('spendingFilter')?.value || "ALL")).toUpperCase(),
            startDate: currentFilters.startDate || null,
            endDate: currentFilters.endDate || null,
            search: currentFilters.search || document.getElementById('userSearch')?.value || "", // Support search in main fetch
            page: currentPage,
            size: itemsPerPage
        };

        // Note: The original code used a different endpoint for global search. 
        // We should unify this if possible, or support both.
        // The original fetchUsers didn't use 'search' in body, but 'globalFilterUser' used 'globalSearch' endpoint.
        // THIS IS TRICKY. The user has two separate logic paths.
        // Ideally, the main list endpoint supports search. If not, we have to branch.

        // Strategy: If search is present, use globalSearch endpoint, else users endpoint.
        // BUT currentFilters might not have search if it was cleared.

        let endpoint = API_CONFIG.endpoints.users;
        const searchVal = document.getElementById('userSearch')?.value;
        if (searchVal) {
            endpoint = API_CONFIG.endpoints.globalSearch;
            requestBody.search = searchVal;
        }

        // Fetch stats and users concurrently
        await Promise.all([
            fetchStats(currentFilters),
            (async () => {
                const response = await fetch(`${API_CONFIG.baseUrl2}${endpoint}`,
                    {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'Authorization': `Basic ${basicAuth}`
                        },
                        body: JSON.stringify(requestBody)
                    }
                );
                if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);

                const result = await response.json();

                // Handle different response structures
                // content/data typically contains the array
                // totalPages/totalElements typically at root
                const users = result.data || result.content || [];
                totalElements = result.totalElements || result.total || 0;
                totalPages = result.totalPages || Math.ceil(totalElements / itemsPerPage) || 0;

                // If endpoint returns just array (no pagination metadata), handle gracefully
                // (Though user requested server side pagination, implying API supports it)
                if (!result.totalPages && !result.totalElements && Array.isArray(users)) {
                    totalElements = users.length;
                    totalPages = 1;
                }

                renderUsers(users);
                renderPaginationControls();
                updateUserCount(users.length); // or totalElements
            })()
        ]);

    } catch (error) {
        console.error('Error fetching users:', error);
        showError('Failed to load users. Please try again.');
    } finally {
        showLoading(false);
    }
}

// Renaming globalFilterUser to just trigger fetch with search
// functionality merged into fetchUsers for consistency
async function globalFilterUser() {
    fetchUsers({ page: 0 }); // Will pick up search value from DOM
}

function renderUsers(users) {
    const tbody = document.getElementById('usersTableBody');
    tbody.innerHTML = '';

    if (!users || users.length === 0) {
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

    users.forEach(user => {
        const row = document.createElement('tr');
        row.setAttribute('data-user-id', user.id);
        row.innerHTML = `
            <td>
                <div class="form-check">
                    <input class="form-check-input row-checkbox" type="checkbox" value="${user.id}">
                </div>
            </td>
            <td>
                <div class="d-flex align-items-center">
                    <img src="${user.profileImage || '/resources/images/default-avatar.jpg'}"
                            class="avatar-group-item me-3" alt="${user.name}">
                    <div>
                        <h6 class="mb-0 text-dark fw-bold" style="font-size: 0.9rem;">${user.name}</h6>
                        <small class="text-muted" style="font-size: 0.75rem;">${user.email || 'No email'}</small>
                    </div>
                </div>
            </td>
            <td><div class="fw-medium text-dark">${user.phone}</div></td>
            <td><small class="text-secondary">${user.address || 'N/A'}</small></td>
            <td><div class="fw-bold text-primary">${user.orders}</div></td>
            <td><div class="fw-bold text-success">${formatCurrency(user.totalSpent)}</div></td>
            <td>
                <div class="text-nowrap fw-medium" style="font-size: 0.85rem;">${formatDate(user.lastActive)}</div>
                <small class="text-muted" style="font-size: 0.75rem;">${formatTime(user.lastActive)}</small>
            </td>
            <td>
                <span class="badge badge-zenith ${isUserActive(user.lastActive) ? 'badge-rider' : 'badge-inactive'}">
                    <i class="fas fa-circle me-1" style="font-size: 6px;"></i>
                    ${isUserActive(user.lastActive) ? 'Active' : 'Inactive'}
                </span>
            </td>
            <td class="text-end">
                <div class="d-flex justify-content-end">
                    <a href="user-view?id=${user.id}" class="btn-icon" data-bs-toggle="tooltip" title="View Details">
                        <i class="fas fa-eye text-primary"></i>
                    </a>
                    <a href="user-edit?id=${user.id}" class="btn-icon" data-bs-toggle="tooltip" title="Edit User">
                        <i class="fas fa-edit text-secondary"></i>
                    </a>
                    <button class="btn-icon" onclick="confirmDelete('${user.id}')" data-bs-toggle="tooltip" title="Delete User">
                        <i class="fas fa-trash text-danger"></i>
                    </button>
                </div>
            </td>
        `;

        tbody.appendChild(row);
    });

    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));

    bindCheckboxEvents();
}

function applyFilters() {
    const filters = {
        activity: document.getElementById('activityFilter').value,
        spending: document.getElementById('spendingFilter').value,
        page: 0 // Reset to first page
    };
    fetchUsers(filters);
}

async function downloadData(type) {
    try {
        const selectedIds = Array.from(document.querySelectorAll('.row-checkbox:checked')).map(cb => cb.value);
        const params = {
            ...currentFilters,
            selectedIds: selectedIds.length > 0 ? selectedIds.join(',') : 'all'
        };

        const queryParams = buildQueryString(params);
        const endpoint = API_CONFIG.endpoints[`export${type.charAt(0).toUpperCase() + type.slice(1)}`];
        const url = `${API_CONFIG.baseUrl}${endpoint}?${queryParams}`;

        const response = await fetch(url);
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);

        const contentDisposition = response.headers.get('Content-Disposition');
        let filename = `users_export_${type}.csv`;
        if (contentDisposition) {
            const filenameMatch = contentDisposition.match(/filename="?(.+)"?/);
            if (filenameMatch && filenameMatch.length === 2) {
                filename = filenameMatch[1];
            }
        }

        const blob = await response.blob();
        const downloadUrl = window.URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.href = downloadUrl;
        link.download = filename;
        document.body.appendChild(link);
        link.click();
        link.remove();
        window.URL.revokeObjectURL(downloadUrl);

    } catch (error) {
        console.error('Error downloading data:', error);
        showError('Failed to download data. Please try again.');
    }
}

function confirmDelete(userId) {
    document.getElementById('deleteUserId').value = userId;
    const modal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
    modal.show();
}

async function deleteUser() {
    const userId = document.getElementById('deleteUserId').value;
    const modal = bootstrap.Modal.getInstance(document.getElementById('deleteConfirmModal'));

    try {
        const response = await fetch(`${API_CONFIG.baseUrl}${API_CONFIG.endpoints.deleteUser}${userId}`, {
            method: 'DELETE'
        });

        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);

        showSuccess('User deleted successfully');
        fetchUsers(); // Refresh current view

    } catch (error) {
        console.error('Error deleting user:', error);
        showError('Failed to delete user. Please try again.');
    } finally {
        if (modal) modal.hide();
    }
}

document.addEventListener('DOMContentLoaded', function () {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));

    // Initial Load
    fetchUsers();

    // Event Listener Setup
    document.getElementById('activityFilter').addEventListener('change', applyFilters);
    document.getElementById('spendingFilter').addEventListener('change', applyFilters);

    // Wire up search button and enter key
    document.getElementById('searchBtn').addEventListener('click', () => fetchUsers({ page: 0 }));
    document.getElementById('userSearch').addEventListener('keyup', (event) => {
        if (event.key === 'Enter') fetchUsers({ page: 0 });
    });

    document.getElementById('resetFiltersBtn').addEventListener('click', () => {
        document.getElementById('activityFilter').value = 'all';
        document.getElementById('spendingFilter').value = 'all';
        document.getElementById('userSearch').value = '';
        currentFilters = {};
        fetchUsers({ page: 0, size: 10 });
    });

    document.getElementById('applyDateRange').addEventListener('click', () => {
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;

        if (!startDate || !endDate || new Date(startDate) > new Date(endDate)) {
            showError('Please select a valid date range.');
            return;
        }

        bootstrap.Modal.getInstance(document.getElementById('dateRangeModal')).hide();
        fetchUsers({ startDate, endDate, page: 0 });
    });

    document.getElementById('downloadBasicBtn').addEventListener('click', (e) => { e.preventDefault(); downloadData('basic'); });
    document.getElementById('downloadAdvancedBtn').addEventListener('click', (e) => { e.preventDefault(); downloadData('advanced'); });
    document.getElementById('downloadNumbersBtn').addEventListener('click', (e) => { e.preventDefault(); downloadData('numbers'); });
});