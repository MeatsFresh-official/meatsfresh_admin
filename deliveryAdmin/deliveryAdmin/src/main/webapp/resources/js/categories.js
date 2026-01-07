document.addEventListener('DOMContentLoaded', () => {
    // ===================================================================
    // API ENDPOINTS & CONFIG
    // ===================================================================
    const API_BASE = 'http://meatsfresh.org.in:8080/api/vendor';
    const ADMIN_API = `${API_BASE}/admin`;
    const IMAGE_BASE_URL = 'http:///meatsfresh.org.in:8080/';

    // ===================================================================ṭūñṅr̥ṭñ
    // GLOBAL STATE & DOM ELEMENTS
    // ===================================================================
    let allCategories = [];
    const loadingSpinner = document.getElementById('loading-spinner');
    const pageContent = document.getElementById('page-content');
    const categoriesTableBody = document.getElementById('categories-table-body');
    const categoryForm = document.getElementById('categoryForm');
    const categoryModalEl = document.getElementById('categoryModal');
    const categoryModal = new bootstrap.Modal(categoryModalEl);
    const categoryModalLabel = document.getElementById('categoryModalLabel');
    const categoryIdInput = document.getElementById('categoryId');
    const categoryNameInput = document.getElementById('categoryName');
    const categoryCommissionInput = document.getElementById('categoryCommission');
    const categoryImageInput = document.getElementById('categoryImage');
    const searchInput = document.getElementById('search-input');
    const sortSelect = document.getElementById('sort-select');
    const noResultsDiv = document.getElementById('no-results');
    const imagePreviewContainer = document.getElementById('image-preview-container');
    const imagePreview = document.getElementById('image-preview');
    const imageHelpText = document.getElementById('image-help-text');
    const saveCategoryBtn = document.getElementById('saveCategoryBtn');

    // ===================================================================
    // HELPER: API Fetch Function
    // ===================================================================
    const fetchAPI = async (url, options = {}) => {
        const username = 'user';
        const password = 'user';
        const encodedCredentials = btoa(`${username}:${password}`);
        const headers = { ...options.headers };
        if (!(options.body instanceof FormData)) {
             if (!headers['Content-Type']) {
                headers['Content-Type'] = 'application/json';
             }
        } else {
            delete headers['Content-Type']; // Let browser set Content-Type for FormData
        }
        headers['Authorization'] = `Basic ${encodedCredentials}`;
        const fetchOptions = { ...options, cache: 'no-cache', headers };
        try {
            const response = await fetch(url, fetchOptions);
            if (!response.ok) {
                const errorData = await response.json().catch(() => ({ message: response.statusText }));
                throw new Error(errorData.message || `HTTP error! Status: ${response.status}`);
            }
            if (response.status === 200 && response.headers.get('content-length') === '0') {
                 return { success: true };
            }
            return response.json();
        } catch (error) {
            console.error('API Error:', error);
            alert(`An error occurred: ${error.message}`);
            return null;
        }
    };

    // ===================================================================
    // DATA & RENDER FUNCTIONS
    // ===================================================================
    const calculateStats = (categories) => {
        const total = categories.length;
        document.getElementById('stat-total-categories').textContent = total;
        if (total === 0) {
            document.getElementById('stat-avg-commission').textContent = '0%';
            document.getElementById('stat-no-image').textContent = '0';
            document.getElementById('stat-top-commission').textContent = '0%';
            return;
        }
        document.getElementById('stat-no-image').textContent = categories.filter(c => !c.image).length;
        const totalCommission = categories.reduce((sum, c) => sum + (c.commission || c.commision || 0), 0);
        document.getElementById('stat-avg-commission').textContent = `${(totalCommission / total).toFixed(2)}%`;
        const topCommission = categories.reduce((max, c) => Math.max(max, (c.commission || c.commision || 0)), 0);
        document.getElementById('stat-top-commission').textContent = `${topCommission.toFixed(2)}%`;
    };

    const renderCategories = (categories) => {
        noResultsDiv.classList.add('d-none');
        if (categories.length === 0) {
            categoriesTableBody.innerHTML = allCategories.length > 0 ? '' : '<tr><td colspan="4" class="text-center text-muted p-5"><i class="fas fa-folder-open fa-3x mb-3"></i><h4>No categories found.</h4></td></tr>';
            if (allCategories.length > 0) noResultsDiv.classList.remove('d-none');
            return;
        }
        categoriesTableBody.innerHTML = categories.map(cat => {
            const imageUrl = cat.image ? `${IMAGE_BASE_URL}${cat.image}` : 'resources/images/default-category.png';
            const commission = (cat.commission || cat.commision || 0).toFixed(2);
            // This is the critical line that needs `cat.categoryId` from the API.
            return `
                <tr>
                    <td class="ps-4 align-middle"><img src="${imageUrl}" class="rounded" width="60" height="60" alt="${cat.name}" style="object-fit: cover;" onerror="this.onerror=null;this.src='resources/images/default-category.png';"></td>
                    <td class="align-middle fw-bold">${cat.name}</td>
                    <td class="align-middle">${commission}%</td>
                    <td class="text-end pe-4 align-middle">
                        <button class="btn btn-sm btn-outline-secondary edit-btn" data-id="${cat.categoryId}">
                            <i class="fas fa-edit me-1"></i> Edit
                        </button>
                        <button class="btn btn-sm btn-outline-danger delete-btn" data-id="${cat.categoryId}" data-name="${cat.name}">
                            <i class="fas fa-trash me-1"></i> Delete
                        </button>
                    </td>
                </tr>`;
        }).join('');
    };

    const applyFiltersAndSort = () => {
        let filtered = [...allCategories];
        const searchTerm = searchInput.value.toLowerCase();
        if (searchTerm) {
            filtered = filtered.filter(cat => cat.name.toLowerCase().includes(searchTerm));
        }
        const sortValue = sortSelect.value;
        filtered.sort((a, b) => {
            const commissionA = a.commission || a.commision || 0;
            const commissionB = b.commission || b.commision || 0;
            switch (sortValue) {
                case 'name-asc': return a.name.localeCompare(b.name);
                case 'name-desc': return b.name.localeCompare(a.name);
                case 'comm-asc': return commissionA - commissionB;
                case 'comm-desc': return commissionB - commissionA;
                default: return 0;
            }
        });
        renderCategories(filtered);
    };

    // ===================================================================
    // CORE LOGIC & EVENT HANDLERS
    // ===================================================================
    const loadCategories = async () => {
        const categories = await fetchAPI(`${ADMIN_API}/categories`);
        if (categories) {
            allCategories = categories;
            loadingSpinner.classList.add('d-none');
            pageContent.classList.remove('d-none');
            calculateStats(allCategories);
            applyFiltersAndSort();
        } else {
            loadingSpinner.innerHTML = '<p class="text-danger">Failed to load categories.</p>';
        }
    };

    categoryForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        const categoryId = categoryIdInput.value;
        const name = categoryNameInput.value;
        const commission = parseFloat(categoryCommissionInput.value);
        const imageFile = categoryImageInput.files[0];

        const categoryData = { name, commission };
        if (categoryId) {
            categoryData.categoryId = parseInt(categoryId);
        }
        const formData = new FormData();
        formData.append('category', new Blob([JSON.stringify(categoryData)], { type: 'application/json' }));
        if (imageFile) {
            formData.append('image', imageFile);
        }

        const url = categoryId ? `${ADMIN_API}/categories/${categoryId}` : `${ADMIN_API}/categories`;
        const method = categoryId ? 'PUT' : 'POST';

        saveCategoryBtn.disabled = true;
        saveCategoryBtn.querySelector('.spinner-border').classList.remove('d-none');

        const result = await fetchAPI(url, { method, body: formData });

        saveCategoryBtn.disabled = false;
        saveCategoryBtn.querySelector('.spinner-border').classList.add('d-none');

        if (result) {
            alert(`Category ${categoryId ? 'updated' : 'added'} successfully!`);
            categoryModal.hide();
            loadCategories();
        }
    });

    categoriesTableBody.addEventListener('click', async (e) => {
        const editBtn = e.target.closest('.edit-btn');
        const deleteBtn = e.target.closest('.delete-btn');

        if (editBtn) {
            const categoryId = editBtn.dataset.id;
            // This check is what triggers your "Cannot edit" alert. It is correct.
            if (!categoryId || categoryId === 'undefined') {
                alert("Cannot edit: Category ID is missing. Please ensure the API is providing the 'categoryId'.");
                return;
            }
            const category = allCategories.find(c => c.categoryId == categoryId);
            if (!category) {
                alert("Could not find category details. Please refresh the page.");
                return;
            }

            categoryModalLabel.textContent = 'Edit Category';
            categoryIdInput.value = category.categoryId;
            categoryNameInput.value = category.name;
            categoryCommissionInput.value = category.commission || category.commision || 0;
            if (category.image) {
                imagePreview.src = `${IMAGE_BASE_URL}${category.image}`;
                imagePreviewContainer.classList.remove('d-none');
                imageHelpText.textContent = 'Leave blank to keep the current image.';
            }
            categoryModal.show();
        }

        if (deleteBtn) {
            const categoryId = deleteBtn.dataset.id;
            const categoryName = deleteBtn.dataset.name;
            // This check is what triggers your "Cannot delete" alert. It is correct.
            if (!categoryId || categoryId === 'undefined') {
                alert("Cannot delete: Category ID is missing. Please ensure the API is providing the 'categoryId'.");
                return;
            }
            if (confirm(`Are you sure you want to delete the category "${categoryName}"?`)) {
                const result = await fetchAPI(`${ADMIN_API}/categories/${categoryId}`, { method: 'DELETE' });
                if (result) {
                    alert('Category deleted successfully.');
                    loadCategories();
                }
            }
        }
    });

    searchInput.addEventListener('input', applyFiltersAndSort);
    sortSelect.addEventListener('change', applyFiltersAndSort);

    categoryModalEl.addEventListener('hidden.bs.modal', () => {
        categoryForm.reset();
        categoryIdInput.value = '';
        categoryModalLabel.textContent = 'Add New Category';
        imagePreviewContainer.classList.add('d-none');
        imagePreview.src = '';
        imageHelpText.textContent = 'A new image will replace the old one.';
    });

    // Initial data load
    loadCategories();
});