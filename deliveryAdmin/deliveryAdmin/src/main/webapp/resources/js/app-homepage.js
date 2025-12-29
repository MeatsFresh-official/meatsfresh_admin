document.addEventListener('DOMContentLoaded', () => {
    // --- API and Authentication Configuration ---
    const BASE_URL = 'http://113.11.231.115:1279'; // Ensure this is your correct API URL
    const USERNAME = 'user';
    const PASSWORD = 'user';
    const AUTH_HEADER = `Basic ${btoa(`${USERNAME}:${PASSWORD}`)}`;
    const MAX_FILE_SIZE_MB = 2;

    // --- DOM Element References ---
    const bannerContainer = document.getElementById('bannerContainer');
    const addBannerBtn = document.getElementById('addBannerBtn');
    const newBannerForm = document.getElementById('newBannerForm');
    const bannerUploadForm = document.getElementById('bannerUploadForm');
    const cancelBannerBtn = document.getElementById('cancelBannerBtn');
    const bannerImageInput = document.getElementById('bannerImage');
    const imageError = document.getElementById('imageError');
    const updateModal = new bootstrap.Modal(document.getElementById('updateBannerModal'));
    const bannerUpdateForm = document.getElementById('bannerUpdateForm');
    const updateBannerIdInput = document.getElementById('updateBannerId');
    const currentBannerImage = document.getElementById('currentBannerImage');
    const updateBannerImageInput = document.getElementById('updateBannerImage');
    const updateImageError = document.getElementById('updateImageError');
    const deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmationModal'));
    const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
    const successToast = new bootstrap.Toast(document.getElementById('successToast'));
    const toastMessage = document.getElementById('toastMessage');
    const imageViewerModal = new bootstrap.Modal(document.getElementById('imageViewerModal'));
    const modalImage = document.getElementById('modalImage');
    let bannerToDelete = { id: null, element: null };

    const showToast = (message) => {
        toastMessage.textContent = message;
        successToast.show();
    };

    /**
     * Fetches an image from a protected URL using Basic Auth and sets its src to a local blob URL.
     * @param {HTMLImageElement} imgElement The image element to populate.
     */
    const loadAuthenticatedImage = async (imgElement) => {
        const protectedUrl = imgElement.dataset.src;
        if (!protectedUrl) return;
        try {
            const response = await fetch(protectedUrl, { headers: { 'Authorization': AUTH_HEADER } });
            if (!response.ok) throw new Error(`Image fetch failed: ${response.status}`);
            const imageBlob = await response.blob();
            const objectUrl = URL.createObjectURL(imageBlob);
            imgElement.src = objectUrl;
        } catch (error) {
            console.error('Could not load authenticated image:', error);
            imgElement.alt = "Failed to load image.";
        }
    };

    /**
     * Creates the HTML structure for a single banner card with Edit and Delete buttons.
     * @param {object} bannerData The banner data from the API, must include `id` and `imageUrl`.
     * @returns {HTMLDivElement} The banner card element.
     */
    const createBannerCardElement = (bannerData) => {
        const bannerCard = document.createElement('div');
        bannerCard.className = 'col-md-4 mb-3 banner-card';
        bannerCard.setAttribute('data-id', bannerData.id);

        bannerCard.innerHTML = `
            <div class="card h-100">
                <img src="" data-src="${BASE_URL}/api/home/banners/${bannerData.imageUrl}" class="card-img-top" alt="Loading banner..." style="cursor: pointer; min-height: 150px; background-color: #f0f0f0;">
                <div class="card-footer bg-transparent d-flex justify-content-end gap-2">
                    <button class="btn btn-sm btn-outline-secondary edit-banner" data-id="${bannerData.id}" data-image-url="${bannerData.imageUrl}"><i class="fas fa-edit"></i> Edit</button>
                    <button class="btn btn-sm btn-outline-danger delete-banner" data-id="${bannerData.id}"><i class="fas fa-trash"></i> Delete</button>
                </div>
            </div>`;
        return bannerCard;
    };

    /**
     * Fetches the list of all banners from the AUTHENTICATED endpoint and renders them on the page.
     */
    const loadAndDisplayBanners = async () => {
        bannerContainer.innerHTML = '<p class="text-muted col-12">Loading banners...</p>';
        try {
            // CORRECTED: Use the correct endpoint AND add the required Authorization header.
            const response = await fetch(`${BASE_URL}/api/home/banners`, {
                headers: { 'Authorization': AUTH_HEADER }
            });

            if (!response.ok) {
                throw new Error(`Failed to fetch banner list. Server responded with status: ${response.status}`);
            }

            const result = await response.json();
            bannerContainer.innerHTML = ''; // Clear the loading message

            if (result.success && result.data.length > 0) {
                result.data.forEach(banner => {
                    // We assume the response data contains `id` and `imageUrl`.
                    const bannerCard = createBannerCardElement(banner);
                    bannerContainer.appendChild(bannerCard);
                    loadAuthenticatedImage(bannerCard.querySelector('img'));
                });
            } else {
                bannerContainer.innerHTML = `<div id="noBannersMessage" class="col-12 text-center py-4 text-muted"><i class="fas fa-image fa-2x mb-2"></i><p>No banners found</p></div>`;
            }
        } catch (error) {
            console.error("Error loading banners:", error);
            bannerContainer.innerHTML = `<p class="text-danger col-12"><b>Error:</b> ${error.message}.</p>`;
        }
    };

    // --- Main Event Listener for All Banner Card Actions ---
    bannerContainer.addEventListener('click', (event) => {
        const target = event.target;
        const editButton = target.closest('.edit-banner');
        const deleteButton = target.closest('.delete-banner');

        if (target.matches('.card-img-top')) {
            if (target.src && !target.src.includes('undefined')) {
                 modalImage.src = target.src;
                 imageViewerModal.show();
            }
        } else if (editButton) {
            updateBannerIdInput.value = editButton.dataset.id;
            currentBannerImage.src = ''; // Clear previous image before loading
            currentBannerImage.dataset.src = `${BASE_URL}/api/home/banners/${editButton.dataset.imageUrl}`;
            loadAuthenticatedImage(currentBannerImage);
            bannerUpdateForm.reset();
            updateImageError.classList.add('d-none');
            updateModal.show();
        } else if (deleteButton) {
            const bannerCard = deleteButton.closest('.banner-card');
            bannerToDelete.id = bannerCard.dataset.id;
            bannerToDelete.element = bannerCard;
            deleteModal.show();
        }
    });

    // --- Event Listeners for Forms ---
    addBannerBtn.addEventListener('click', () => newBannerForm.classList.remove('d-none'));
    cancelBannerBtn.addEventListener('click', () => {
        newBannerForm.classList.add('d-none');
        bannerUploadForm.reset();
        imageError.classList.add('d-none');
    });

    // --- Form Submission Logic ---

    bannerUploadForm.addEventListener('submit', async (event) => {
        event.preventDefault();
        try {
            const file = bannerImageInput.files[0];
            if (!file || file.size > MAX_FILE_SIZE_MB * 1024 * 1024) {
                 imageError.textContent = file ? `File is too large (Max ${MAX_FILE_SIZE_MB}MB)` : 'Please select an image file.';
                 imageError.classList.remove('d-none');
                 return;
            }
            const formData = new FormData();
            formData.append('image', file);
            const response = await fetch(`${BASE_URL}/api/user/admin/banners`, {
                method: 'POST',
                headers: { 'Authorization': AUTH_HEADER },
                body: formData
            });
            const result = await response.json();
            if (!result.success) throw new Error(result.message);
            showToast('Banner added successfully!');
            cancelBannerBtn.click();
            loadAndDisplayBanners(); // Refresh the entire list
        } catch (error) {
             imageError.textContent = error.message || 'Failed to upload banner.';
             imageError.classList.remove('d-none');
        }
    });

    bannerUpdateForm.addEventListener('submit', async (event) => {
        event.preventDefault();
        try {
            const bannerId = updateBannerIdInput.value;
            const file = updateBannerImageInput.files[0];
             if (!file) {
                updateImageError.textContent = 'Please select a new image file.';
                updateImageError.classList.remove('d-none');
                return;
            }
            const formData = new FormData();
            formData.append('image', file);
            const response = await fetch(`${BASE_URL}/api/user/admin/banners/${bannerId}`, {
                method: 'PUT',
                headers: { 'Authorization': AUTH_HEADER },
                body: formData
            });
            const result = await response.json();
            if (!response.ok) throw new Error(result.message || 'Update failed on server.');
            updateModal.hide();
            showToast('Banner updated successfully.');
            loadAndDisplayBanners(); // Refresh the entire list
        } catch(error) {
            updateImageError.textContent = error.message;
            updateImageError.classList.remove('d-none');
        }
    });

    confirmDeleteBtn.addEventListener('click', async () => {
        if (!bannerToDelete.id) return;
        try {
            const response = await fetch(`${BASE_URL}/api/user/admin/banners/${bannerToDelete.id}`, {
                method: 'DELETE',
                headers: { 'Authorization': AUTH_HEADER }
            });
            if (!response.ok) {
                 const errorResult = await response.json();
                 throw new Error(errorResult.message || 'Failed to delete on server.');
            }
            deleteModal.hide();
            showToast('Banner deleted successfully.');
            loadAndDisplayBanners(); // Refresh the entire list
        } catch (error) {
            alert(error.message);
        } finally {
            bannerToDelete = { id: null, element: null };
        }
    });

    // --- INITIALIZE THE PAGE ---
    loadAndDisplayBanners();
});