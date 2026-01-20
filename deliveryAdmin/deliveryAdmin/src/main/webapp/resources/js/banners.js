$(document).ready(function () {
    console.log("Banners JS: Ready function fired");

    // --- Config & State ---
    const BASE_URL_8080 = 'http://meatsfresh.org.in:8080';
    const BASE_URL_8083 = 'http://meatsfresh.org.in:8083';

    // Endpoints
    const VENDOR_API_URL = `${BASE_URL_8080}/api/vendor/banners`;
    const VENDOR_UPLOAD_URL = `${BASE_URL_8080}/api/vendor/banners/upload`;

    const PARTNER_API_URL = `${BASE_URL_8083}/api/delivery-partner/banners`;
    const PARTNER_LIST_URL = `${PARTNER_API_URL}/all`;
    const PARTNER_UPLOAD_URL = `${PARTNER_API_URL}/upload`;

    let banners = {
        vendor: [],
        partner: []
    };

    // --- DOM Elements ---
    const zones = {
        vendor: {
            upload: document.getElementById('uploadZoneVendor'),
            input: document.getElementById('fileInputVendor'),
            grid: document.getElementById('vendorGrid'),
            count: document.getElementById('vendorCount')
        },
        partner: {
            upload: document.getElementById('uploadZonePartner'),
            input: document.getElementById('fileInputPartner'),
            grid: document.getElementById('partnerGrid'),
            count: document.getElementById('partnerCount')
        }
    };

    // --- Init ---
    console.log("Banners JS: Initializing fetch...");
    fetchBanners();

    // --- Core Functions ---

    function getAuthHeaders(xhr) {
        const auth = btoa("user:user");
        xhr.setRequestHeader("Authorization", "Basic " + auth);
        console.log("Banners JS: Auth header set");
    }

    function fetchBanners() {
        console.log("Banners JS: fetchBanners() logic started");
        fetchVendorBanners();
        fetchPartnerBanners();
    }

    function fetchVendorBanners() {
        console.log("Banners JS: fetchVendorBanners() called. URL:", VENDOR_API_URL);
        $.ajax({
            url: VENDOR_API_URL,
            method: 'GET',
            beforeSend: getAuthHeaders,
            success: function (response) {
                console.log("Banners JS: Vendor API Success. Response:", response);
                let bannerList = [];
                if (response.data && Array.isArray(response.data)) {
                    bannerList = response.data;
                } else if (Array.isArray(response)) {
                    bannerList = response;
                }

                banners.vendor = bannerList.map(b => ({
                    id: b.id?.toString() || Math.random().toString(36).substr(2, 9),
                    imageUrl: b.imageUrl || b.url || b.image,
                    active: b.active !== undefined ? b.active : true
                }));

                hideDemoMode();
                renderSection('vendor');
            },
            error: function (xhr, status, error) {
                console.error("Banners JS: Vendor API Error:", error);
                renderError('vendor', error);
            }
        });
    }

    function fetchPartnerBanners() {
        console.log("Banners JS: [Partner] Initiating fetch from:", PARTNER_LIST_URL);
        $.ajax({
            url: PARTNER_LIST_URL,
            method: 'GET',
            dataType: 'json',
            beforeSend: getAuthHeaders,
            success: function (response) {
                console.log("Banners JS: [Partner] Success via Port 8083. Response:", response);
                let bannerList = [];

                if (response) {
                    if (response.data && Array.isArray(response.data)) {
                        bannerList = response.data;
                    } else if (response.banners && Array.isArray(response.banners)) {
                        bannerList = response.banners;
                    } else if (Array.isArray(response)) {
                        bannerList = response;
                    }
                }

                banners.partner = bannerList.map(b => {
                    // Normalize ID to string
                    const id = (b.id !== undefined && b.id !== null) ? String(b.id) : Math.random().toString(36).substr(2, 9);
                    // Use imageName as priority for partner banners
                    const imageUrl = b.imageName || b.imageUrl || b.url || b.image;
                    return {
                        id: id,
                        imageUrl: imageUrl,
                        active: (b.active !== undefined && b.active !== null) ? b.active : true
                    };
                });

                console.log("Banners JS: [Partner] State updated. Count:", banners.partner.length);
                renderSection('partner');
                hideDemoMode();
            },
            error: function (xhr, status, error) {
                console.error("Banners JS: [Partner] API Error:", status, error);
                const errorMsg = (xhr.status === 0)
                    ? "Connection refused. Ensure the backend on port 8083 is running."
                    : (error || "Failed to load data");
                renderError('partner', errorMsg);
            }
        });
    }

    function renderError(type, error) {
        const grid = zones[type]?.grid;
        if (grid) {
            grid.innerHTML = `
                <div class="col-12 py-5 text-center text-red-500 bg-red-50 rounded-lg border-2 border-dashed border-red-200">
                    <i class="fas fa-exclamation-circle fa-2x mb-2"></i>
                    <p class="text-sm font-semibold">Failed to load ${type} banners</p>
                    <p class="text-xs opacity-75">${error || 'Connection error'}</p>
                </div>
            `;
        }
    }

    function handleUpload(file, type) {
        if (!file.type.startsWith('image/')) {
            showErrorToast('Please select an image file');
            return;
        }

        const z = zones[type];
        const uploadUrl = type === 'partner' ? PARTNER_UPLOAD_URL : VENDOR_UPLOAD_URL;

        // Loading State
        z.upload.classList.add('uploading');
        const originalHtml = z.upload.innerHTML;

        let targetName = type === 'partner' ? 'Partner' : 'Vendor';

        z.upload.innerHTML = `
            <div class="d-flex flex-column align-items-center">
                <div class="loading-spinner mb-3"></div>
                <h5>Uploading to ${targetName}...</h5>
            </div>
        `;

        const formData = new FormData();
        formData.append("file", file);

        $.ajax({
            url: uploadUrl,
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            beforeSend: getAuthHeaders,
            success: function (response) {
                console.log("Upload success:", response);
                showToast('Banner uploaded successfully!');

                fetchBanners(); // Refresh from server

                // Reset UI
                z.upload.classList.remove('uploading');
                z.upload.innerHTML = originalHtml;
            },
            error: function (xhr, status, error) {
                console.error("Upload error:", error);
                showErrorToast('Failed to upload banner: ' + (xhr.responseText || error));

                // Reset UI
                z.upload.classList.remove('uploading');
                z.upload.innerHTML = originalHtml;
            }
        });
    }

    // --- Update Logic (Image Replacement) ---

    // Global Update State
    let updateState = {
        id: null,
        type: null
    };

    const updateInput = document.getElementById('updateFileInput');

    if (updateInput) {
        updateInput.addEventListener('change', function (e) {
            if (this.files && this.files[0]) {
                const file = this.files[0];
                if (!file.type.startsWith('image/')) {
                    showErrorToast('Please select an image file');
                    return;
                }

                // Process Update
                if (updateState.id) {
                    const formData = new FormData();
                    formData.append("file", file);

                    const updateUrl = updateState.type === 'partner'
                        ? `${PARTNER_API_URL}/update/${updateState.id}`
                        : `${BASE_URL_8080}/api/vendor/banners/update/${updateState.id}`;

                    $.ajax({
                        url: updateUrl,
                        method: 'PUT',
                        data: formData,
                        processData: false,
                        contentType: false,
                        beforeSend: getAuthHeaders,
                        success: function (response) {
                            console.log("Update success:", response);
                            showToast('Banner updated successfully!');
                            fetchBanners(); // Refresh from server
                        },
                        error: function (xhr, status, error) {
                            console.error("Update error:", error);
                            showErrorToast('Failed to update banner: ' + (xhr.responseText || error));
                        }
                    });
                }

                // Reset State
                updateState = { id: null, type: null };
                this.value = ''; // Allow re-selecting same file
            }
        });
    }

    window.triggerUpdate = function (id, type) {
        // Set state and open file dialog
        updateState = { id, type };
        if (updateInput) updateInput.click();
    };


    window.deleteBanner = function (id, type) {
        if (!confirm('Delete this banner?')) return;

        const deleteUrl = type === 'partner'
            ? `${PARTNER_API_URL}/delete/${id}`
            : `${BASE_URL_8080}/api/vendor/banners/delete/${id}`;

        $.ajax({
            url: deleteUrl,
            method: 'DELETE',
            beforeSend: getAuthHeaders,
            success: function () {
                showToast('Banner deleted successfully');
                fetchBanners(); // Refresh logic
            },
            error: function (xhr, status, error) {
                console.error('Delete error:', error);
                showErrorToast('Failed to delete banner: ' + (xhr.responseText || error));
            }
        });
    }

    // --- Rendering ---

    function renderAll() {
        renderSection('vendor');
        renderSection('partner');
    }

    function renderSection(type) {
        const list = banners[type];
        const grid = zones[type].grid;
        const countSpan = zones[type].count;

        if (!grid) return;

        // Update count
        if (countSpan) countSpan.textContent = `${list.length} Active`;

        if (list.length === 0) {
            grid.innerHTML = `
                <div class="col-12 py-5 text-center text-gray-400 bg-gray-50 rounded-lg border-2 border-dashed border-gray-200">
                    <i class="fas fa-image fa-2x mb-2 opacity-50"></i>
                    <p class="text-sm">No ${type} banners yet.</p>
                </div>
            `;
            return;
        }

        grid.innerHTML = list.map((b, idx) => `
            <div class="banner-card group relative overflow-hidden rounded-xl shadow-md border border-gray-100 bg-white transition-all hover:shadow-lg animate-enter" style="animation-delay: ${idx * 0.05}s">
                <!-- Image Section -->
                <div class="aspect-w-16 aspect-h-9 w-full h-48 relative bg-gray-100 border-b border-gray-100">
                    <img src="${b.imageUrl}" class="w-full h-full object-cover" alt="Banner">
                    
                    <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                         <button onclick="triggerUpdate('${b.id}', '${type}')" class="px-4 py-2 bg-white/90 text-gray-900 rounded-lg font-medium text-sm hover:bg-white shadow-lg transform translate-y-2 group-hover:translate-y-0 transition-all duration-300">
                            Change Image
                        </button>
                    </div>
                </div>
                
                <!-- Action Footer -->
                <div class="p-3 flex justify-between items-center bg-white">
                     <div class="flex flex-col">
                        <span class="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-0.5">ID: ${String(b.id).substring(0, 8)}</span>
                    </div>
                    
                    <div class="flex items-center gap-2">
                        <!-- Update Button (Icon) -->
                         <button onclick="triggerUpdate('${b.id}', '${type}')" 
                                 class="w-8 h-8 rounded-lg bg-blue-50 text-blue-600 flex items-center justify-center hover:bg-blue-100 transition-colors" 
                                 title="Update Image">
                            <i class="fas fa-camera text-xs"></i>
                        </button>
                        
                        <!-- Delete Button -->
                        <button onclick="deleteBanner('${b.id}', '${type}')" 
                                class="w-8 h-8 rounded-lg bg-red-50 text-red-500 flex items-center justify-center hover:bg-red-100 hover:text-red-700 transition-colors" 
                                title="Delete Banner">
                            <i class="fas fa-trash-alt text-xs"></i>
                        </button>
                    </div>
                </div>
            </div>
        `).join('');
    }

    // --- Event Setup Helper ---
    function setupUpload(type) {
        const z = zones[type];
        if (!z.upload || !z.input) return;

        z.input.addEventListener('change', function (e) {
            if (this.files && this.files[0]) handleUpload(this.files[0], type);
        });

        // Drag & Drop
        const prevent = (e) => { e.preventDefault(); e.stopPropagation(); };
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(evt => z.upload.addEventListener(evt, prevent));

        ['dragenter', 'dragover'].forEach(evt => z.upload.addEventListener(evt, () => z.upload.classList.add('dragover')));
        ['dragleave', 'drop'].forEach(evt => z.upload.addEventListener(evt, () => z.upload.classList.remove('dragover')));

        z.upload.addEventListener('drop', (e) => {
            const files = e.dataTransfer.files;
            if (files && files[0]) handleUpload(files[0], type);
        });
    }

    // Setup all sections
    setupUpload('vendor');
    setupUpload('partner');

    function hideDemoMode() {
        const demoBadge = document.getElementById('demo-mode-badge');
        if (demoBadge) {
            demoBadge.innerHTML = '<i class="fas fa-check-circle me-1"></i> Live Data Connected';
            demoBadge.classList.replace('text-secondary', 'text-green-500');
        }
    }

    function showToast(message) {
        $('#toastMessage').text(message);
        const toastEl = document.getElementById('successToast');
        if (toastEl) {
            const toast = new bootstrap.Toast(toastEl);
            toast.show();
        }
    }

    function showErrorToast(message) {
        $('#errorMessage').text(message);
        const toastEl = document.getElementById('errorToast');
        if (toastEl) {
            const toast = new bootstrap.Toast(toastEl);
            toast.show();
        }
    }

});
