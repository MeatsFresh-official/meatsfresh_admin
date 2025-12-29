/**
 * @file report.js
 * @description Manages the business reports page, including data fetching and UI interactions.
 */

// ===================================================================================
// CONFIGURATION
// ===================================================================================

const API_ENDPOINTS = {
    users: '/api/reports/users',
    vendors: '/api/reports/vendors',
    deliveries: '/api/reports/deliveries'
};

const TOAST_DELAY = 5000;

// ===================================================================================
// INITIALIZATION
// ===================================================================================

document.addEventListener('DOMContentLoaded', () => {
    // Initialize UI components
    const successToastEl = document.getElementById('successToast');
    const errorToastEl = document.getElementById('errorToast');
    window.successToast = new bootstrap.Toast(successToastEl, { delay: TOAST_DELAY });
    window.errorToast = new bootstrap.Toast(errorToastEl, { delay: TOAST_DELAY });

    // Load data into tables
    loadAllReports();

    // Attach event listeners
    attachEventListeners();
});

// ===================================================================================
// DATA FETCHING AND RENDERING
// ===================================================================================

/**
 * Loads data for all report sections.
 */
function loadAllReports() {
    fetchAndRender(API_ENDPOINTS.users, 'usersTable', renderUserRow);
    fetchAndRender(API_ENDPOINTS.vendors, 'vendorsTable', renderVendorRow);
    fetchAndRender(API_ENDPOINTS.deliveries, 'deliveriesTable', renderDeliveryRow);
}

/**
 * Generic function to fetch data and render it into a table.
 * @param {string} endpoint - The API endpoint to fetch data from.
 * @param {string} tableId - The ID of the table to populate.
 * @param {function} rowRenderer - The function to render a single row.
 */
async function fetchAndRender(endpoint, tableId, rowRenderer) {
    const tableBody = document.querySelector(`#${tableId} tbody`);
    tableBody.innerHTML = '<tr><td colspan="6" class="text-center">Loading...</td></tr>';

    try {
        // This is a mock fetch. Replace with your actual API call.
        const response = await mockFetch(endpoint);
        if (!response.ok) throw new Error(`Failed to load data from ${endpoint}`);
        
        const data = await response.json();
        tableBody.innerHTML = ''; // Clear loading state

        if (data.length === 0) {
            tableBody.innerHTML = '<tr><td colspan="6" class="text-center">No data available.</td></tr>';
        } else {
            data.forEach(item => tableBody.appendChild(rowRenderer(item)));
        }
    } catch (error) {
        console.error(`Error fetching ${endpoint}:`, error);
        tableBody.innerHTML = `<tr><td colspan="6" class="text-center text-danger">Failed to load data. Please try again.</td></tr>`;
        showToast('error', `Failed to load data for ${tableId.replace('Table', '')}.`);
    }
}

/**
 * Renders a single user row.
 * @param {object} user - The user data object.
 * @returns {HTMLTableRowElement} The created table row element.
 */
function renderUserRow(user) {
    const tr = document.createElement('tr');
    tr.innerHTML = `
        <td>${user.id}</td>
        <td>${user.name}</td>
        <td>${user.email}</td>
        <td>${user.regDate}</td>
        <td><span class="badge ${user.status === 'Active' ? 'status-active' : 'status-inactive'}">${user.status}</span></td>
        <td>
            <button class="action-btn view-details" data-type="user" data-id="${user.id}" title="View Details">
                <i class="fas fa-eye"></i>
            </button>
        </td>
    `;
    return tr;
}

/**
 * Renders a single vendor row.
 * @param {object} vendor - The vendor data object.
 * @returns {HTMLTableRowElement} The created table row element.
 */
function renderVendorRow(vendor) {
    const tr = document.createElement('tr');
    tr.innerHTML = `
        <td>${vendor.id}</td>
        <td>${vendor.companyName}</td>
        <td>${vendor.contactPerson}</td>
        <td>${vendor.joinedDate}</td>
        <td>${vendor.rating} <i class="fas fa-star text-warning"></i></td>
        <td>
            <button class="action-btn view-details" data-type="vendor" data-id="${vendor.id}" title="View Details">
                <i class="fas fa-eye"></i>
            </button>
        </td>
    `;
    return tr;
}

/**
 * Renders a single delivery row.
 * @param {object} delivery - The delivery data object.
 * @returns {HTMLTableRowElement} The created table row element.
 */
function renderDeliveryRow(delivery) {
    const tr = document.createElement('tr');
    let statusClass = '';
    switch(delivery.status) {
        case 'Delivered': statusClass = 'status-delivered'; break;
        case 'In Transit': statusClass = 'status-in-transit'; break;
        default: statusClass = 'status-pending';
    }
    tr.innerHTML = `
        <td>${delivery.orderId}</td>
        <td>${delivery.customer}</td>
        <td>${delivery.deliveryPerson}</td>
        <td><span class="badge ${statusClass}">${delivery.status}</span></td>
        <td>${delivery.lastUpdate}</td>
        <td>
            <button class="action-btn view-details" data-type="delivery" data-id="${delivery.orderId}" title="View Details">
                <i class="fas fa-eye"></i>
            </button>
        </td>
    `;
    return tr;
}


// ===================================================================================
// EVENT HANDLING
// ===================================================================================

/**
 * Attaches all necessary event listeners.
 */
function attachEventListeners() {
    document.getElementById('printReportBtn').addEventListener('click', () => window.print());
    document.getElementById('downloadPdfBtn').addEventListener('click', downloadReportAsPDF);

    document.addEventListener('click', event => {
        const target = event.target.closest('.view-details');
        if (target) {
            const type = target.dataset.type;
            const id = target.dataset.id;
            showDetailsModal(type, id);
        }
    });
}

// ===================================================================================
// MODAL AND TOASTS
// ===================================================================================

/**
 * Shows the details modal with information for a specific item.
 * @param {string} type - The type of item (user, vendor, delivery).
 * @param {string} id - The ID of the item.
 */
function showDetailsModal(type, id) {
    const modal = new bootstrap.Modal(document.getElementById('detailsModal'));
    const modalTitle = document.getElementById('detailsModalLabel');
    const modalContent = document.getElementById('modalContent');
    
    // In a real app, you would fetch this data from an API
    const details = getMockDetails(type, id);
    
    modalTitle.textContent = `${capitalizeFirstLetter(type)} Details - ${id}`;
    modalContent.innerHTML = details;
    
    modal.show();
}

/**
 * Shows a toast notification.
 * @param {'success'|'error'} type - The type of toast.
 * @param {string} message - The message to display.
 */
function showToast(type, message) {
    if (type === 'success') {
        document.getElementById('toastMessage').textContent = message;
        window.successToast.show();
    } else {
        document.getElementById('errorToastMessage').textContent = message;
        window.errorToast.show();
    }
}

// ===================================================================================
// UTILITY FUNCTIONS
// ===================================================================================

/**
 * Downloads the main content area as a PDF.
 */
async function downloadReportAsPDF() {
    const mainContent = document.querySelector('.main-content');
    showToast('success', 'Generating PDF, please wait...');

    try {
        const { jsPDF } = window.jspdf;
        const canvas = await html2canvas(mainContent);
        const imgData = canvas.toDataURL('image/png');
        
        const pdf = new jsPDF({
            orientation: 'p',
            unit: 'mm',
            format: 'a4'
        });

        const pdfWidth = pdf.internal.pageSize.getWidth();
        const pdfHeight = (canvas.height * pdfWidth) / canvas.width;
        
        pdf.addImage(imgData, 'PNG', 0, 0, pdfWidth, pdfHeight);
        pdf.save(`business-report-${new Date().toISOString().slice(0,10)}.pdf`);
    } catch (error) {
        console.error('Failed to generate PDF:', error);
        showToast('error', 'Could not generate PDF.');
    }
}

/**
 * Capitalizes the first letter of a string.
 * @param {string} string - The input string.
 * @returns {string} The capitalized string.
 */
function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

// ===================================================================================
// MOCK DATA (for demonstration purposes - replace with real API calls)
// ===================================================================================

const mockData = {
    '/api/reports/users': [
        { id: 'USR-001', name: 'Alice Johnson', email: 'alice@example.com', regDate: '2023-01-15', status: 'Active' },
        { id: 'USR-002', name: 'Bob Williams', email: 'bob@example.com', regDate: '2023-02-20', status: 'Inactive' }
    ],
    '/api/reports/vendors': [
        { id: 'VND-101', companyName: 'Global Tech', contactPerson: 'Charlie Brown', joinedDate: '2022-11-10', rating: 4.8 },
        { id: 'VND-102', companyName: 'Fresh Foods', contactPerson: 'Diana Prince', joinedDate: '2023-03-05', rating: 4.5 }
    ],
    '/api/reports/deliveries': [
        { orderId: 'ORD-501', customer: 'Eve Adams', deliveryPerson: 'Frank White', status: 'Delivered', lastUpdate: '2023-05-20 14:30' },
        { orderId: 'ORD-502', customer: 'Grace Lee', deliveryPerson: 'Heidi Green', status: 'In Transit', lastUpdate: '2023-05-22 09:15' }
    ]
};

function mockFetch(endpoint) {
    return new Promise(resolve => {
        setTimeout(() => {
            resolve({
                ok: true,
                json: () => Promise.resolve(mockData[endpoint] || [])
            });
        }, 500); // Simulate network delay
    });
}

function getMockDetails(type, id) {
    switch(type) {
        case 'user':
            return `<h5>User Information</h5>
                    <p><strong>User ID:</strong> ${id}</p>
                    <p><strong>Name:</strong> Alice Johnson</p>
                    <p><strong>Email:</strong> alice@example.com</p>
                    <p><strong>Phone:</strong> +1 (555) 123-4567</p>
                    <p><strong>Address:</strong> 123 Tech Lane, Silicon Valley</p>`;
        case 'vendor':
            return `<h5>Vendor Information</h5>
                    <p><strong>Vendor ID:</strong> ${id}</p>
                    <p><strong>Company:</strong> Global Tech</p>
                    <p><strong>Contact:</strong> Charlie Brown</p>
                    <p><strong>Products:</strong> Electronics, Gadgets</p>
                    <p><strong>Member Since:</strong> 2022-11-10</p>`;
        case 'delivery':
            return `<h5>Delivery Information</h5>
                    <p><strong>Order ID:</strong> ${id}</p>
                    <p><strong>Customer:</strong> Eve Adams</p>
                    <p><strong>Address:</strong> 456 Main St, Metropolis</p>
                    <p><strong>Items:</strong> 3</p>
                    <p><strong>Status History:</strong> Placed > Shipped > In Transit > Delivered</p>`;
        default:
            return '<p class="text-danger">No details found.</p>';
    }
}