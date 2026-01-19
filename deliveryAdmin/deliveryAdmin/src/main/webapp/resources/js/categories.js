document.addEventListener('DOMContentLoaded', () => {

    // --- Mock Data ---
    let categories = [
        { id: '1', name: 'Premium Cuts', commission: 15, image: 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?auto=format&fit=crop&w=150&q=80' },
        { id: '2', name: 'Organic Chicken', commission: 12, image: 'https://images.unsplash.com/photo-1587593810167-a6492031e5fd?auto=format&fit=crop&w=150&q=80' },
        { id: '3', name: 'Marinated Specials', commission: 18, image: '' }, // Test no image
        { id: '4', name: 'Deli & Cold Cuts', commission: 10, image: 'https://images.unsplash.com/photo-1551028150-64b9f398f678?auto=format&fit=crop&w=150&q=80' },
        { id: '5', name: 'Ready to Cook', commission: 25, image: 'https://images.unsplash.com/photo-1544377892-74cc2188fa6c?auto=format&fit=crop&w=150&q=80' },
        { id: '6', name: 'Seafood', commission: 14, image: 'https://images.unsplash.com/photo-1615141982880-13f572a73081?auto=format&fit=crop&w=150&q=80' },
    ];

    // --- DOM Elements ---
    const loadingSpinner = document.getElementById('loading-spinner');
    const pageContent = document.getElementById('page-content');

    // NEW: Grid Container
    const gridContainer = document.getElementById('categories-grid');
    const noResultsDiv = document.getElementById('no-results');

    const searchInput = document.getElementById('search-input');
    const sortSelect = document.getElementById('sort-select');

    // Stats
    const statTotal = document.getElementById('stat-total-categories');
    const statAvg = document.getElementById('stat-avg-commission');
    const statNoImage = document.getElementById('stat-no-image');
    const statTop = document.getElementById('stat-top-commission');

    // Modal
    const modalEl = document.getElementById('categoryModal');
    const modal = new bootstrap.Modal(modalEl);
    const modalTitle = document.getElementById('categoryModalLabel');
    const catIdInput = document.getElementById('categoryId');
    const catNameInput = document.getElementById('categoryName');
    const catCommInput = document.getElementById('categoryCommission');
    const catFileInput = document.getElementById('categoryImage');
    const imagePreview = document.getElementById('image-preview');

    let currentImage = null;

    // --- Simulation Init ---
    setTimeout(() => {
        loadingSpinner.classList.add('d-none');
        pageContent.classList.remove('d-none');
        updateStats();
        renderGrid(categories); // Renamed to renderGrid
    }, 800);


    // --- Event Listeners ---
    searchInput.addEventListener('input', handleSearchSort);
    sortSelect.addEventListener('change', handleSearchSort);

    catFileInput.addEventListener('change', function () {
        if (this.files && this.files[0]) {
            const url = URL.createObjectURL(this.files[0]);
            imagePreview.src = url;
            currentImage = url;
        }
    });


    // --- Core Logic ---

    function handleSearchSort() {
        const term = searchInput.value.toLowerCase();
        const sortVal = sortSelect.value;

        let filtered = categories.filter(c => c.name.toLowerCase().includes(term));

        filtered.sort((a, b) => {
            if (sortVal === 'name-asc') return a.name.localeCompare(b.name);
            if (sortVal === 'name-desc') return b.name.localeCompare(a.name);
            if (sortVal === 'comm-desc') return b.commission - a.commission;
            if (sortVal === 'comm-asc') return a.commission - b.commission;
            return 0;
        });

        renderGrid(filtered);
    }

    function updateStats() {
        statTotal.textContent = categories.length;

        const totalComm = categories.reduce((sum, c) => sum + Number(c.commission), 0);
        const avg = categories.length ? (totalComm / categories.length).toFixed(1) : 0;
        statAvg.textContent = avg + '%';

        const noImgCount = categories.filter(c => !c.image).length;
        statNoImage.textContent = noImgCount;

        const maxComm = Math.max(...categories.map(c => Number(c.commission)), 0);
        statTop.textContent = maxComm + '%';
    }

    // NEW: Render Grid Function
    function renderGrid(data) {
        gridContainer.innerHTML = '';

        if (data.length === 0) {
            noResultsDiv.classList.remove('d-none');
            return;
        }

        noResultsDiv.classList.add('d-none');

        data.forEach(cat => {
            const imgUrl = cat.image || 'https://via.placeholder.com/150?text=No+Img';

            const col = document.createElement('div');
            col.className = 'col-6 col-md-4 col-xl-3'; // Responsive columns

            col.innerHTML = `
                <div class="category-box">
                    <img src="${imgUrl}" class="cat-box-img" alt="${cat.name}">
                    <h5 class="cat-box-title">${cat.name}</h5>
                    <span class="cat-box-badge">
                        <i class="fas fa-percentage text-xs me-1"></i> ${cat.commission}% Comm.
                    </span>
                    
                    <div class="cat-box-actions">
                        <button class="cat-box-btn btn-edit" onclick="editCategory('${cat.id}')">
                            Edit
                        </button>
                        <button class="cat-box-btn btn-delete" onclick="deleteCategory('${cat.id}')">
                            Delete
                        </button>
                    </div>
                </div>
            `;
            gridContainer.appendChild(col);
        });
    }


    // --- Global Actions ---

    window.prepareAddCategory = function () {
        modalTitle.textContent = 'Add New Category'; // Match header text
        catIdInput.value = '';
        catNameInput.value = '';
        catCommInput.value = '';
        catFileInput.value = '';
        imagePreview.src = 'https://via.placeholder.com/120?text=Upload';
        currentImage = null;
    }

    window.editCategory = function (id) {
        const cat = categories.find(c => c.id === id);
        if (!cat) return;

        modalTitle.textContent = 'Edit Category';
        catIdInput.value = cat.id;
        catNameInput.value = cat.name;
        catCommInput.value = cat.commission;
        imagePreview.src = cat.image || 'https://via.placeholder.com/120?text=Upload';
        currentImage = cat.image;

        modal.show();
    }

    window.saveCategory = function () {
        if (!catNameInput.value.trim()) {
            alert('Category Name is required');
            return;
        }
        if (catCommInput.value === '') {
            alert('Commission is required');
            return;
        }

        const id = catIdInput.value;
        const newCat = {
            id: id || 'c' + Date.now(),
            name: catNameInput.value.trim(),
            commission: parseFloat(catCommInput.value),
            image: currentImage || ''
        };

        if (id) {
            const idx = categories.findIndex(c => c.id === id);
            if (idx !== -1) categories[idx] = newCat;
        } else {
            categories.unshift(newCat);
        }

        renderGrid(categories); // Re-render
        updateStats(); // Refresh stats
        modal.hide();
    }

    window.deleteCategory = function (id) {
        if (confirm('Are you sure you want to delete this category?')) {
            categories = categories.filter(c => c.id !== id);
            renderGrid(categories);
            updateStats();
        }
    }

});