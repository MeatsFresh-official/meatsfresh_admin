document.addEventListener('DOMContentLoaded', function () {

    const uploadZone = document.getElementById('uploadZone');
    const fileInput = document.getElementById('fileInput');
    const bannerGrid = document.getElementById('bannerGrid');

    // --- Mock Data (Demo Mode / No API) ---
    // User requested "no api", so we use strictly local data.
    let banners = [
        { id: '1', imageUrl: 'https://images.unsplash.com/photo-1557804506-669a67965ba0?auto=format&fit=crop&w=800&q=80', active: true },
        { id: '2', imageUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?auto=format&fit=crop&w=800&q=80', active: true },
        { id: '3', imageUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?auto=format&fit=crop&w=800&q=80', active: true },
        { id: '4', imageUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=800&q=80', active: false }
    ];

    // --- Initial Load ---
    loadBanners();

    // --- Event Listeners ---

    // Trigger file input on click
    if (uploadZone) {
        uploadZone.addEventListener('click', () => fileInput.click());

        // Drag and Drop
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            uploadZone.addEventListener(eventName, preventDefaults, false);
        });

        ['dragenter', 'dragover'].forEach(eventName => {
            uploadZone.addEventListener(eventName, () => uploadZone.classList.add('dragover'), false);
        });

        ['dragleave', 'drop'].forEach(eventName => {
            uploadZone.addEventListener(eventName, () => uploadZone.classList.remove('dragover'), false);
        });

        uploadZone.addEventListener('drop', handleDrop, false);
    }

    if (fileInput) {
        fileInput.addEventListener('change', function (e) {
            if (this.files && this.files[0]) {
                handleUpload(this.files[0]);
            }
        });
    }

    function preventDefaults(e) {
        e.preventDefault();
        e.stopPropagation();
    }

    function handleDrop(e) {
        const dt = e.dataTransfer;
        const files = dt.files;
        if (files && files[0]) {
            handleUpload(files[0]);
        }
    }

    // --- Local Logic Functions ---

    function loadBanners() {
        console.log("Loading sample banners...");
        renderBanners(banners);
    }

    function handleUpload(file) {
        // Validation
        if (!file.type.startsWith('image/')) {
            alert('Please select an image file');
            return;
        }

        // UI loading state
        if (uploadZone) {
            uploadZone.classList.add('uploading');
            const originalText = uploadZone.innerHTML;
            uploadZone.innerHTML = `
                <div class="d-flex flex-column align-items-center">
                    <div class="loading-spinner mb-3"></div>
                    <h5>Uploading...</h5>
                </div>
            `;

            // Simulate 1s delay then add
            setTimeout(() => {
                // Create a local URL for the uploaded file so it displays immediately
                const objectUrl = URL.createObjectURL(file);

                const newBanner = {
                    id: Date.now().toString(),
                    imageUrl: objectUrl, // Use local blob URL
                    active: true
                };

                banners.unshift(newBanner); // Add to top

                // Reset UI
                uploadZone.classList.remove('uploading');
                uploadZone.innerHTML = originalText;

                // Reload grid
                loadBanners();
            }, 1000);
        }
    }

    // DELETE Banner
    window.deleteBanner = function (id) {
        if (!confirm('Delete this banner? (Demo Mode)')) return;

        banners = banners.filter(b => b.id !== id);
        loadBanners();
    };

    // PUT Update Banner
    window.updateBanner = function (id) {
        const b = banners.find(item => item.id === id);
        if (b) {
            b.active = !b.active;
            loadBanners();
        }
    };


    // --- Render Functions ---

    function showLoading() {
        bannerGrid.innerHTML = '<div class="col-12 text-center py-5"><div class="loading-spinner"></div></div>';
    }

    function showError(msg) {
        bannerGrid.innerHTML = `<div class="col-12 text-center py-5 text-danger">${msg}</div>`;
    }

    function renderBanners(banners) {
        if (!banners || !Array.isArray(banners) || banners.length === 0) {
            bannerGrid.innerHTML = `
                <div class="col-12 empty-state">
                    <i class="fas fa-images fa-3x mb-3 text-gray-300"></i>
                    <p>No banners found. Upload one to get started!</p>
                </div>
            `;
            return;
        }

        bannerGrid.innerHTML = banners.map((banner, index) => {
            // Handle different API response structures (url vs imageUrl)
            const imageUrl = banner.url || banner.imageUrl || banner.file || '';
            const bannerId = banner.id || banner.uuid || index; // Fallback ID

            return `
            <div class="banner-card animate-enter" style="animation-delay: ${index * 0.1}s">
                <img src="${imageUrl}" class="banner-image" alt="Banner">
                <div class="banner-overlay">
                    <button class="btn-delete-banner" onclick="deleteBanner('${bannerId}')" title="Delete Banner">
                        <i class="fas fa-trash-alt"></i>
                    </button>
                     <!-- Optional: Update Button (e.g. reused logic or separate) -->
                    <!-- <button class="btn btn-sm btn-light ms-2" onclick="updateBanner('${bannerId}', ${banner.active})">
                        <i class="fas fa-edit"></i>
                    </button> -->
                </div>
            </div>
        `}).join('');
    }

});
