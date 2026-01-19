/**
 * User Details View - Logic for Tab Navigation and Mock Data
 */

// Mock Address Data (Global for accessibility)
let mockAddresses = [
    {
        id: 101,
        type: 'HOME',
        houseNo: 'Flat 402, Tower B',
        address: 'Blue Ridge Apartments, Hinjewadi Phase 1',
        landmark: 'Opposite Wipro Circle',
        lat: 18.5913,
        lng: 73.7389
    },
    {
        id: 102,
        type: 'WORK',
        houseNo: 'Office 203',
        address: 'Tech Park One, Yerwada',
        landmark: 'Near Airport Road',
        lat: 18.5529,
        lng: 73.8877
    },
    {
        id: 103,
        type: 'OTHERS',
        houseNo: 'Row House 7',
        address: 'Golden Palms Society, Wakad',
        landmark: 'Near D-Mart',
        receiverName: 'Rahul (Friend)',
        receiverPhone: '+91 98989 89898',
        lat: 18.5983,
        lng: 73.7638
    }
];

document.addEventListener('DOMContentLoaded', function () {
    initTabs();
    initPreferenceToggles();
    loadMockData();
    initSearch();
});

function initSearch() {
    const searchInput = document.getElementById('order-search-input');
    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            const searchTerm = e.target.value.toLowerCase();
            const rows = document.querySelectorAll('#orders-table-body tr');

            rows.forEach(row => {
                const orderId = row.querySelector('td:first-child').textContent.toLowerCase();
                if (orderId.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    }
}

function initTabs() {
    const tabBtns = document.querySelectorAll('.zenith-tab-btn');
    tabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            // Remove active class from all
            tabBtns.forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.tab-content-pane').forEach(p => p.classList.remove('active'));

            // Add active to current
            btn.classList.add('active');
            const targetId = btn.getAttribute('data-tab');
            document.getElementById(targetId).classList.add('active');
        });
    });
}

function loadMockData() {
    // Check if we have an ID in URL, otherwise default to a mock user
    const params = new URLSearchParams(window.location.search);
    const userId = params.get('id') || '101';

    // Mock User Data
    const mockUser = {
        id: userId,
        name: "Abhishek Sharma",
        email: "abhishek.sharma@example.com",
        phone: "+91 98765 43210",
        dob: "1995-08-15",
        profileImage: "https://ui-avatars.com/api/?name=Abhishek+Sharma&background=0D8ABC&color=fff&size=150",
        address: "Block B, Sector 18, Noida, Uttar Pradesh",
        stats: {
            orders: 24,
            spent: 15400,
            wallet: 250,
            activeDays: 5
        },
        preferences: {
            sms: true,
            whatsapp: true,
            email: false,
            promo: true
        }
    };

    // Populate Header
    document.getElementById('header-name').textContent = mockUser.name;
    document.getElementById('header-email').innerHTML = `<i class="fas fa-envelope me-2"></i>${mockUser.email}`;
    document.getElementById('header-phone').innerHTML = `<i class="fas fa-phone me-2"></i>${mockUser.phone}`;
    document.getElementById('header-img').src = mockUser.profileImage;

    // Status Badge Logic
    const statusVal = document.getElementById('header-status-val');
    const isActive = mockUser.stats.activeDays <= 30; // Example logic

    if (statusVal) {
        statusVal.textContent = isActive ? 'Active' : 'Inactive';
        statusVal.className = `h3 fw-bold ${isActive ? 'text-success' : 'text-danger'} mb-0`;
    }


    // Populate Profile Inputs
    document.getElementById('input-name').value = mockUser.name;
    document.getElementById('input-email').value = mockUser.email;
    document.getElementById('input-phone').value = mockUser.phone;
    document.getElementById('input-dob').value = mockUser.dob;

    // Populate Preferences
    document.getElementById('sms-toggle').checked = mockUser.preferences.sms;
    document.getElementById('whatsapp-toggle').checked = mockUser.preferences.whatsapp;
    document.getElementById('email-toggle').checked = mockUser.preferences.email;
    document.getElementById('promo-toggle').checked = mockUser.preferences.promo;

    // Populate Orders (Mock)
    renderOrders();

    // Initialize Addresses (Select first by default)
    if (typeof mockAddresses !== 'undefined') {
        if (mockAddresses.length > 0) {
            selectAddress(mockAddresses[0].id);
        } else {
            renderAddresses(); // Just render empty list
            createNewAddress();
        }
    }
}

function renderOrders() {
    const mockOrders = [
        { id: '#ORD-9921', date: '18 Jan 2026', items: 'Chicken Curry Cut (500g)', status: 'Delivered', amount: '₹450' },
        { id: '#ORD-9920', date: '15 Jan 2026', items: 'Mutton Keema (1kg)', status: 'Delivered', amount: '₹850' },
        { id: '#ORD-9890', date: '10 Jan 2026', items: 'Farm Fresh Eggs (30pcs)', status: 'Cancelled', amount: '₹210' },
        { id: '#ORD-9855', date: '05 Jan 2026', items: 'Fish Fillet (250g)', status: 'Returned', amount: '₹340' }
    ];

    const tbody = document.getElementById('orders-table-body');
    tbody.innerHTML = mockOrders.map(order => `
        <tr>
            <td class="fw-bold text-primary">${order.id}</td>
            <td>${order.date}</td>
            <td>${order.items}</td>
            <td class="fw-bold">${order.amount}</td>
            <td>
                <span class="zenith-badge ${getStatusBadge(order.status)}">${order.status}</span>
            </td>
            <td>
                <button class="btn btn-sm btn-light text-primary" onclick="showOrderDetails('${order.id}')"><i class="fas fa-eye"></i></button>
            </td>
        </tr>
    `).join('');
}

function getStatusBadge(status) {
    switch (status.toLowerCase()) {
        case 'delivered': return 'success';
        case 'cancelled': return 'danger';
        case 'returned': return 'warning';
        default: return 'secondary';
    }
}

// Global scope to be accessible from HTML onclick
window.showOrderDetails = function (orderId) {
    // Mock Detailed Data (simulating a fetch)
    const orderDetails = {
        id: orderId,
        date: '18 Jan 2026, 02:30 PM',
        status: 'Delivered',
        vendor: {
            name: "Fresh Meat House",
            address: "Shop 12, Market Complex, Sector 18",
            phone: "+91 9988776655"
        },
        partner: {
            name: "Ramesh Kumar",
            phone: "+91 8877665544",
            vehicle: "Bike (UP-16-AB-1234)"
        },
        items: [
            { name: "Chicken Curry Cut (500g)", price: 225, qty: 2, total: 450 },
            { name: "Spicy Marinade", price: 50, qty: 1, total: 50 }
        ],
        bill: {
            subtotal: 500,
            deliveryFee: 40,
            tax: 25,
            discount: 50,
            total: 515
        }
    };

    // Construct Modal User Interface
    // Construct Modal User Interface
    const modalContent = `
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <span class="text-muted text-uppercase small ls-1">Order ID</span>
                <h4 class="mb-0 fw-bold">#${orderDetails.id.replace('#', '')}</h4>
                <small class="text-muted"><i class="far fa-clock me-1"></i> ${orderDetails.date}</small>
            </div>
            <div class="text-end">
                <span class="text-muted text-uppercase small ls-1">Status</span>
                <div>
                   <span class="zenith-badge ${getStatusBadge(orderDetails.status)} fs-6 mt-1">${orderDetails.status}</span>
                </div>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <!-- Vendor Card -->
            <div class="col-md-6">
                <div class="zenith-info-card">
                    <div class="d-flex align-items-center mb-2">
                        <div class="zenith-info-icon zenith-bg-blue me-3">
                            <i class="fas fa-store"></i>
                        </div>
                        <h6 class="fw-bold m-0 text-dark">Vendor Details</h6>
                    </div>
                    <h6 class="mb-1">${orderDetails.vendor.name}</h6>
                    <p class="text-muted small mb-2">${orderDetails.vendor.address}</p>
                    <a href="#" class="btn btn-sm btn-light rounded-pill px-3"><i class="fas fa-phone-alt me-1"></i> ${orderDetails.vendor.phone}</a>
                </div>
            </div>
            <!-- Partner Card -->
            <div class="col-md-6">
                 <div class="zenith-info-card">
                    <div class="d-flex align-items-center mb-2">
                        <div class="zenith-info-icon zenith-bg-purple me-3">
                            <i class="fas fa-motorcycle"></i>
                        </div>
                        <h6 class="fw-bold m-0 text-dark">Delivery Partner</h6>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="mb-1">${orderDetails.partner.name}</h6>
                            <p class="text-muted small mb-0">${orderDetails.partner.vehicle}</p>
                        </div>
                        <a href="#" class="btn btn-sm btn-light rounded-circle" style="width:36px;height:36px;display:flex;align-items:center;justify-content:center;"><i class="fas fa-phone-alt"></i></a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Products List -->
        <h6 class="text-uppercase small fw-bold text-muted mb-3 ls-1">Items Ordered</h6>
        <div class="zenith-item-list">
            ${orderDetails.items.map(item => `
            <div class="zenith-item-row">
                <div class="d-flex align-items-center">
                    <div class="bg-light rounded p-2 me-3 text-center" style="width:40px; height:40px;">
                        <span class="fw-bold text-muted small">${item.qty}x</span>
                    </div>
                    <div>
                        <h6 class="mb-0 text-dark font-weight-bold">${item.name}</h6>
                        <small class="text-muted">Unit: ₹${item.price}</small>
                    </div>
                </div>
                <div class="fw-bold text-dark">₹${item.total}</div>
            </div>
            `).join('')}
        </div>

        <!-- Bill Details -->
        <div class="zenith-bill-summary">
            <div class="zenith-bill-row">
                <span>Item Total</span>
                <span class="fw-medium text-dark">₹${orderDetails.bill.subtotal}</span>
            </div>
            <div class="zenith-bill-row">
                <span>Delivery Fee</span>
                <span class="fw-medium text-dark">₹${orderDetails.bill.deliveryFee}</span>
            </div>
            <div class="zenith-bill-row">
                <span>Taxes & Charges</span>
                <span class="fw-medium text-dark">₹${orderDetails.bill.tax}</span>
            </div>
            <div class="zenith-bill-row text-success">
                <span>Discount</span>
                <span class="fw-bold">- ₹${orderDetails.bill.discount}</span>
            </div>
            <div class="zenith-bill-total">
                <span>Total Amount</span>
                <span class="text-primary">₹${orderDetails.bill.total}</span>
            </div>
        </div>
    `;

    document.getElementById('orderDetailsContent').innerHTML = modalContent;
    document.getElementById('modalOrderId').textContent = orderId;

    // Show Modal
    new bootstrap.Modal(document.getElementById('orderDetailsModal')).show();
};

// Master-Detail Address Logic
function renderAddresses() {
    const container = document.getElementById('address-list-container');
    if (!container) return; // Should not happen if on correct page

    // Sort by most recent add time (simulated by ID desc)
    const storedAddrs = mockAddresses.sort((a, b) => b.id - a.id);

    container.innerHTML = storedAddrs.map(addr => `
        <div class="address-item ${selectedAddrId === addr.id ? 'active' : ''}" onclick="selectAddress(${addr.id})">
            <div class="d-flex justify-content-between align-items-center mb-1">
                <span class="badge rounded-pill bg-light text-dark border">${addr.type}</span>
                ${selectedAddrId === addr.id ? '<i class="fas fa-check-circle text-primary"></i>' : ''}
            </div>
            <h6 class="mb-1 text-truncate">${addr.houseNo ? addr.houseNo + ', ' : ''}${addr.landmark || ''}</h6>
            <p>${addr.address}</p>
        </div>
    `).join('');

    // If no selection yet, select first
    // If empty list, force create mode
    if (storedAddrs.length === 0) {
        createNewAddress();
        selectedAddrId = null;
    }
    // Note: We REMOVED the auto-select logic here to allow "Create New" (null selection) to persist.
    // Initial selection is now handled in loadMockData().
}

let selectedAddrId = null;

window.selectAddress = function (id) {
    selectedAddrId = id;
    const addr = mockAddresses.find(a => a.id === id);
    if (addr) {
        populateAddressForm(addr);
        document.getElementById('addr-detail-title').textContent = "Edit Address";
        document.getElementById('btn-delete-addr').classList.remove('d-none');
    }
    renderAddresses(); // Re-render to update active class
}

window.createNewAddress = function () {
    selectedAddrId = null;
    document.getElementById('addressForm').reset();
    document.getElementById('addr-id').value = '';

    // Defaults
    document.getElementById('type-home').checked = true;
    toggleReceiverFields();
    document.getElementById('addr-detail-title').textContent = "New Address";
    document.getElementById('btn-delete-addr').classList.add('d-none');

    // Focus first field
    document.getElementById('addr-house-no').focus();

    renderAddresses(); // Remove active selection
}

function populateAddressForm(addr) {
    document.getElementById('addr-id').value = addr.id;

    // Type Radio
    if (addr.type === 'HOME') document.getElementById('type-home').checked = true;
    else if (addr.type === 'WORK') document.getElementById('type-work').checked = true;
    else document.getElementById('type-others').checked = true;

    toggleReceiverFields();

    document.getElementById('addr-house-no').value = addr.houseNo || '';
    document.getElementById('addr-text').value = addr.address || '';
    document.getElementById('addr-landmark').value = addr.landmark || '';
    document.getElementById('addr-lat').value = addr.lat || '';
    document.getElementById('addr-lng').value = addr.lng || '';

    if (addr.type === 'OTHERS') {
        document.getElementById('addr-receiver-name').value = addr.receiverName || '';
        document.getElementById('addr-receiver-phone').value = addr.receiverPhone || '';
    }
}

window.toggleReceiverFields = function () {
    const isOthers = document.getElementById('type-others').checked;
    document.getElementById('receiver-fields').style.display = isOthers ? 'block' : 'none';
}

window.saveAddressMasterDetail = function () {
    const id = document.getElementById('addr-id').value;
    const type = document.querySelector('input[name="addrType"]:checked').value;

    const newAddr = {
        id: id ? parseInt(id) : Date.now(),
        type: type,
        houseNo: document.getElementById('addr-house-no').value,
        address: document.getElementById('addr-text').value,
        landmark: document.getElementById('addr-landmark').value,
        lat: document.getElementById('addr-lat').value || 12.9716, // Mock Lat
        lng: document.getElementById('addr-lng').value || 77.5946  // Mock Lng
    };

    if (type === 'OTHERS') {
        newAddr.receiverName = document.getElementById('addr-receiver-name').value;
        newAddr.receiverPhone = document.getElementById('addr-receiver-phone').value;
    }

    if (id) {
        const index = mockAddresses.findIndex(a => a.id == id);
        if (index !== -1) mockAddresses[index] = newAddr;
    } else {
        mockAddresses.unshift(newAddr); // Add to top
    }

    // Re-select the saved address
    selectAddress(newAddr.id);
}

window.deleteCurrentAddress = function () {
    if (selectedAddrId && confirm('Permanently delete this address?')) {
        mockAddresses = mockAddresses.filter(a => a.id !== selectedAddrId);
        selectedAddrId = null;

        // Select next available or create new
        if (mockAddresses.length > 0) {
            selectAddress(mockAddresses[0].id);
        } else {
            renderAddresses();
            createNewAddress();
        }
    }
}

function initPreferenceToggles() {
    const toggles = document.querySelectorAll('.toggle-switch input');
    toggles.forEach(toggle => {
        toggle.addEventListener('change', (e) => {
            const feature = e.target.id.replace('-toggle', '');
            const state = e.target.checked ? 'Enabled' : 'Disabled';

            // Show toast (Mock)
            // In real app, call API here
            console.log(`${feature} is now ${state}`);

            // Simple visual feedback if no toast library
            const label = e.target.closest('.toggle-switch').querySelector('h6');
            const originalText = label.textContent;
            label.textContent = `${originalText} (Updating...)`;
            setTimeout(() => {
                label.textContent = originalText;
            }, 800);
        });
    });
}
