document.addEventListener('DOMContentLoaded', function () {

    // --- State ---
    let banners = {
        vendor: [
            { id: 'v1', imageUrl: 'https://images.unsplash.com/photo-1557804506-669a67965ba0?auto=format&fit=crop&w=800&q=80', active: true },
            { id: 'v2', imageUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?auto=format&fit=crop&w=800&q=80', active: true }
        ],
        partner: [
            { id: 'p1', imageUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?auto=format&fit=crop&w=800&q=80', active: true }
        ]
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
    renderAll();

    // --- Event Setup Helper ---
    function setupUpload(type) {
        const z = zones[type];
        if (!z.upload || !z.input) return;

        // Click handled by inline onclick in JSP or we can add it here if preferred. 
        // JSP has onclick="document.getElementById('...').click()" so we just need change event.

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

    // Setup both
    setupUpload('vendor');
    setupUpload('partner');


    // --- Core Logic ---

    function handleUpload(file, type) {
        if (!file.type.startsWith('image/')) {
            alert('Please select an image file');
            return;
        }

        const z = zones[type];

        // Loading State
        z.upload.classList.add('uploading');
        const originalHtml = z.upload.innerHTML;
        z.upload.innerHTML = `
            <div class="d-flex flex-column align-items-center">
                <div class="loading-spinner mb-3"></div>
                <h5>Uploading to ${type === 'vendor' ? 'Vendor' : 'Partner'}...</h5>
            </div>
        `;

        setTimeout(() => {
            const newBanner = {
                id: Date.now().toString(),
                imageUrl: URL.createObjectURL(file),
                active: true
            };

            banners[type].unshift(newBanner);

            // Reset UI
            z.upload.classList.remove('uploading');
            z.upload.innerHTML = originalHtml;

            renderAll();
        }, 1200);
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
                    alert('Please select an image file');
                    return;
                }

                // Process Update
                if (updateState.id && updateState.type) {
                    const list = banners[updateState.type];
                    const banner = list.find(b => b.id === updateState.id);
                    if (banner) {
                        banner.imageUrl = URL.createObjectURL(file); // Update Image
                        renderAll();
                    }
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
        banners[type] = banners[type].filter(b => b.id !== id);
        renderAll();
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
                        <span class="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-0.5">ID: ${b.id.substring(0, 6)}</span>
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

});
