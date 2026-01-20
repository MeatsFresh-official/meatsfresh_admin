document.addEventListener('DOMContentLoaded', () => {

    const API_URL = 'http://meatsfresh.org.in:8080/api/vendor/admin/categories';
    let categories = [];

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

    // --- Init ---
    fetchCategories();

    // --- API Functions ---

    function getAuthHeaders(xhr) {
        xhr.setRequestHeader("Authorization", "Basic " + btoa("user:user"));
    }

    function fetchCategories() {
        loadingSpinner.classList.remove('d-none');
        pageContent.classList.add('d-none');

        $.ajax({
            url: API_URL,
            method: 'GET',
            beforeSend: getAuthHeaders,
            success: function (response) {
                // Map response to handle "commision" typo from API if present
                categories = response.map(item => ({
                    id: item.id,
                    name: item.name,
                    // Handle both spellings just in case
                    commission: item.commision !== undefined ? item.commision : item.commission,
                    image: item.image
                }));

                loadingSpinner.classList.add('d-none');
                pageContent.classList.remove('d-none');
                updateStats();
                renderGrid(categories);
            },
            error: function (xhr, status, error) {
                console.error("Error fetching categories:", error);
                loadingSpinner.classList.add('d-none');
                // show error state or empty
                pageContent.classList.remove('d-none');
                alert("Failed to load categories");
            }
        });
    }

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

        const totalComm = categories.reduce((sum, c) => sum + Number(c.commission || 0), 0);
        const avg = categories.length ? (totalComm / categories.length).toFixed(1) : 0;
        statAvg.textContent = avg + '%';

        const noImgCount = categories.filter(c => !c.image).length;
        statNoImage.textContent = noImgCount;

        const maxComm = categories.length > 0 ? Math.max(...categories.map(c => Number(c.commission || 0))) : 0;
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
        // Need to find by ID, which might be number or string depending on API
        const cat = categories.find(c => c.id == id);
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
        const nameVal = catNameInput.value.trim();
        const commVal = catCommInput.value;
        const file = catFileInput.files[0];
        const id = catIdInput.value;

        if (!nameVal) {
            alert('Category Name is required');
            return;
        }
        if (commVal === '') {
            alert('Commission is required');
            return;
        }

        // Determine Add or Update
        const isUpdate = !!id;
        const url = isUpdate ? `${API_URL}/${id}` : API_URL;
        const method = isUpdate ? 'PUT' : 'POST';

        const form = new FormData();
        form.append("name", nameVal);
        form.append("commission", commVal); // Sending "commission" (correct spelling)
        if (file) {
            form.append("image", file);
        }

        const submitBtn = document.querySelector('#categoryModal .btn-primary');
        const originalText = submitBtn.textContent;
        submitBtn.disabled = true;
        submitBtn.textContent = 'Saving...';

        const settings = {
            "url": url,
            "method": method,
            "timeout": 0,
            "processData": false,
            "mimeType": "multipart/form-data",
            "contentType": false,
            "data": form,
            "beforeSend": getAuthHeaders
        };
        console.log(`Sending ${method} request to ${url}`);

        $.ajax(settings).done(function (response) {
            console.log(response);
            showToast(`Category ${isUpdate ? 'updated' : 'saved'} successfully!`);
            modal.hide();
            fetchCategories(); // Reload to get fresh data
        }).fail(function (jqXHR, textStatus, errorThrown) {
            console.error('Error:', textStatus, errorThrown);
            showToast('Error: ' + (jqXHR.responseText || errorThrown), true);
        }).always(function () {
            submitBtn.disabled = false;
            submitBtn.textContent = originalText;
        });
    }

    window.deleteCategory = function (id) {
        if (confirm('Are you sure you want to delete this category?')) {
            $.ajax({
                url: `${API_URL}/${id}`,
                method: 'DELETE',
                beforeSend: getAuthHeaders,
                success: function () {
                    showToast('Category deleted successfully');
                    fetchCategories();
                },
                error: function (xhr, status, error) {
                    console.error('Delete error:', error);
                    showToast('Failed to delete category', true);
                }
            });
        }
    }

    function showToast(message, isError = false) {
        const toastId = isError ? 'errorToast' : 'successToast';
        const msgId = isError ? 'errorMessage' : 'toastMessage';

        // If error toast doesn't exist in categories.jsp yet, fallback to success with style
        // but for now I'll just use the one I added.

        $(`#${msgId}`).text(message);
        const toastEl = document.getElementById(toastId) || document.getElementById('successToast');
        if (toastEl) {
            const toast = new bootstrap.Toast(toastEl);
            toast.show();
        } else {
            alert(message); // Fallback
        }
    }

});