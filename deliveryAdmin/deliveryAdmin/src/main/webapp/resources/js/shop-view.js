document.addEventListener('DOMContentLoaded', function () {
    loadShopMockData();
    initTabs();
    renderProducts();
    renderShopOrders();
    initStatusToggle();
});

// Mock Data
const mockShop = {
    id: 99,
    name: "Fresh Cuts & Meats",
    image: "https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60",
    rating: 4.8,
    isOnline: true,
    owner: "Michael Scott",
    phone: "+91 98765 43210",
    email: "freshcuts@example.com",
    address: "123, Meat Market Lane, Indiranagar, Bangalore",
    pan: "ABCD1234E",
    fssai: "12345678901234",
    gst: "29ABCDE1234F1Z5",
    bank: {
        holder: "Michael Scott",
        name: "HDFC Bank",
        account: "50100123456789",
        ifsc: "HDFC0001234"
    }
};

const mockProducts = [
    { id: 1, name: "Premium Chicken Curry Cut", category: "Chicken", price: 280, image: "https://placehold.co/400x300?text=Chicken", status: "Available" },
    { id: 2, name: "Mutton Biryani Cut", category: "Mutton", price: 650, image: "https://placehold.co/400x300?text=Mutton", status: "Available" },
    { id: 3, name: "Farm Fresh Eggs (6pcs)", category: "Eggs", price: 80, image: "https://placehold.co/400x300?text=Eggs", status: "Out of Stock" },
    { id: 4, name: "Boneless Chicken Breast", category: "Chicken", price: 320, image: "https://placehold.co/400x300?text=Breast", status: "Available" },
];

const mockShopOrders = [
    { id: "#ORD-991", date: "Jan 18, 2026", customer: "Alice Johnson", items: "Chicken x2, Eggs x1", total: 640, status: "Delivered" },
    { id: "#ORD-988", date: "Jan 17, 2026", customer: "Bob Smith", items: "Mutton x1", total: 650, status: "Pending" },
    { id: "#ORD-985", date: "Jan 16, 2026", customer: "Charlie", items: "Chicken x1", total: 280, status: "Cancelled" },
];

function loadShopMockData() {
    document.getElementById('header-shop-name').textContent = mockShop.name;
    document.getElementById('header-shop-img').src = mockShop.image;
    document.getElementById('header-owner').innerHTML = `<i class="fas fa-user-tie me-2"></i>${mockShop.owner}`;
    document.getElementById('header-phone').innerHTML = `<i class="fas fa-phone me-2"></i>${mockShop.phone}`;

    // Status
    updateStatusUI(mockShop.isOnline);

    // Profile Tab Inputs
    document.getElementById('input-shop-name').value = mockShop.name;
    document.getElementById('input-owner').value = mockShop.owner;
    document.getElementById('input-email').value = mockShop.email;
    document.getElementById('input-phone').value = mockShop.phone;
    document.getElementById('input-address').value = mockShop.address;

    document.getElementById('input-pan').value = mockShop.pan;
    document.getElementById('input-fssai').value = mockShop.fssai;
    document.getElementById('input-gst').value = mockShop.gst;

    document.getElementById('input-bank-holder').value = mockShop.bank.holder;
    document.getElementById('input-bank-name').value = mockShop.bank.name;
    document.getElementById('input-bank-acc').value = mockShop.bank.account;
    document.getElementById('input-bank-ifsc').value = mockShop.bank.ifsc;
}

function updateStatusUI(isOnline) {
    const toggle = document.getElementById('shop-status-toggle-wrapper');
    const checkbox = document.getElementById('status-checkbox');
    const text = document.getElementById('status-text');

    checkbox.checked = isOnline;

    if (isOnline) {
        toggle.classList.remove('offline');
        toggle.classList.add('online');
        text.textContent = "Online";
    } else {
        toggle.classList.remove('online');
        toggle.classList.add('offline');
        text.textContent = "Offline";
    }
}

function initStatusToggle() {
    const checkbox = document.getElementById('status-checkbox');
    checkbox.addEventListener('change', function () {
        updateStatusUI(this.checked);
        // Here you would call API to update status
    });
}

function initTabs() {
    const tabBtns = document.querySelectorAll('.zenith-tab-btn');
    const tabPanes = document.querySelectorAll('.tab-content-pane');

    tabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            // Remove active
            tabBtns.forEach(b => b.classList.remove('active'));
            tabPanes.forEach(p => p.classList.remove('active'));

            // Add active
            btn.classList.add('active');
            const tabId = btn.getAttribute('data-tab');
            document.getElementById(tabId).classList.add('active');
        });
    });
}

function renderProducts() {
    const container = document.getElementById('products-grid');
    container.innerHTML = mockProducts.map(prod => `
        <div class="col-md-6 col-lg-3">
            <div class="zenith-product-card">
                <div class="product-img-container">
                    <img src="${prod.image}" class="product-img" alt="${prod.name}">
                    <span class="product-badge text-${prod.status === 'Available' ? 'success' : 'danger'}">${prod.status}</span>
                </div>
                <div class="product-body">
                    <h6 class="product-title text-truncate">${prod.name}</h6>
                    <small class="product-cat">${prod.category}</small>
                    <div class="product-footer">
                        <span class="product-price">₹${prod.price}</span>
                        <div>
                            <button class="btn btn-sm btn-light rounded-circle shadow-sm" onclick="editProduct(${prod.id})"><i class="fas fa-pen text-primary"></i></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    `).join('') + `
        <div class="col-md-6 col-lg-3">
            <div class="zenith-product-card d-flex align-items-center justify-content-center" style="border: 2px dashed #ddd; cursor: pointer; background: #fafafa;" onclick="openProductModal()">
                <div class="text-center text-muted">
                    <i class="fas fa-plus-circle fa-2x mb-2 text-primary opacity-50"></i>
                    <h6 class="fw-bold">Add New Product</h6>
                </div>
            </div>
        </div>
    `;
}

function renderShopOrders() {
    const tbody = document.getElementById('shop-orders-body');
    tbody.innerHTML = mockShopOrders.map(order => `
        <tr>
            <td class="fw-bold text-primary">${order.id}</td>
            <td>${order.date}</td>
            <td>${order.customer}</td>
            <td>${order.items}</td>
            <td class="fw-bold">₹${order.total}</td>
            <td><span class="zenith-badge ${getStatusClass(order.status)}">${order.status}</span></td>
            <td><button class="btn btn-sm btn-light text-primary"><i class="fas fa-eye"></i></button></td>
        </tr>
    `).join('');
}

function getStatusClass(status) {
    if (status === 'Delivered') return 'success';
    if (status === 'Cancelled') return 'danger';
    if (status === 'Pending') return 'warning';
    return 'secondary';
}

// Product Modal
window.openProductModal = function (id = null) {
    const modal = new bootstrap.Modal(document.getElementById('productModal'));
    document.getElementById('productForm').reset();

    if (id) {
        document.getElementById('productModalTitle').textContent = "Edit Product";
        const prod = mockProducts.find(p => p.id === id);
        if (prod) {
            document.getElementById('prod-name').value = prod.name;
            document.getElementById('prod-price').value = prod.price;
            document.getElementById('prod-cat').value = prod.category;
            document.getElementById('prod-status').value = prod.status;
        }
    } else {
        document.getElementById('productModalTitle').textContent = "Add Product";
    }

    modal.show();
}

window.editProduct = function (id) {
    openProductModal(id);
}
