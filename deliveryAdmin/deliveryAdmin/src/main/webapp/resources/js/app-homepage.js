document.addEventListener('DOMContentLoaded', () => {

    // --- Config ---
    const USER_API_URL = 'https://meatsfresh.org.in:8082/api/home-banners/all';
    const USER_UPLOAD_API_URL = 'https://meatsfresh.org.in:8082/api/home-banners/upload';

    // --- State ---
    let normalBanners = [];
    let specialBanners = [
        { id: 'sb1', type: 'image', url: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&fit=crop&w=600&q=80', active: true },
        { id: 'sb2', type: 'video', url: 'https://assets.mixkit.co/videos/preview/mixkit-slicing-a-juicy-lime-1563-large.mp4', active: false }
    ];

    let currentUploadType = 'image'; // 'image' or 'video' for special section
    let updateState = { id: null, type: 'normal' };

    // --- DOM ---
    const normalGrid = document.getElementById('normalBannersGrid');
    const specialGrid = document.getElementById('specialBannersGrid');

    const normalInput = document.getElementById('normalFileInput');
    const updateInput = document.getElementById('updateFileInput');
    const specialInput = document.getElementById('specialFileInput');

    const typeImageBtn = document.getElementById('typeImageBtn');
    const typeVideoBtn = document.getElementById('typeVideoBtn');
    const specialUploadText = document.getElementById('specialUploadText');

    const videoModalEl = document.getElementById('videoModal');
    const modalVideoPlayer = document.getElementById('modalVideoPlayer');
    let videoModal = null;
    if (videoModalEl) videoModal = new bootstrap.Modal(videoModalEl);

    // --- Init ---
    fetchNormalBanners();
    renderSpecial();

    // Cleaning up video when modal hides
    if (videoModalEl) {
        videoModalEl.addEventListener('hidden.bs.modal', () => {
            modalVideoPlayer.pause();
            modalVideoPlayer.src = '';
        });
    }

    // --- Auth & Generic ---
    function getAuthHeaders(xhr) {
        xhr.setRequestHeader("Authorization", "Basic " + btoa("user:user"));
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

    // --- API Fetching ---

    function fetchNormalBanners() {
        console.log("App Home: Fetching normal banners...");
        $.ajax({
            url: USER_API_URL,
            method: 'GET',
            beforeSend: getAuthHeaders,
            success: function (response) {
                console.log("App Home: Success fetching banners:", response);
                let bannerList = [];
                if (response && response.data && Array.isArray(response.data)) {
                    bannerList = response.data;
                } else if (Array.isArray(response)) {
                    bannerList = response;
                }

                normalBanners = bannerList.map(b => ({
                    id: b.id !== undefined ? b.id.toString() : Math.random().toString(36).substr(2, 9),
                    image: b.url || b.imageUrl || b.image,
                    active: b.active !== undefined ? b.active : true
                }));

                renderNormal();
            },
            error: function (xhr, status, error) {
                console.error("App Home: Error fetching banners:", error);
                showErrorToast("Failed to load banners from server.");
            }
        });
    }

    // --- Handlers ---

    window.setUploadType = function (type) {
        currentUploadType = type;
        if (type === 'image') {
            typeImageBtn.className = "px-4 py-2 rounded-lg text-sm font-semibold transition-all bg-gray-100 text-gray-900 shadow-sm";
            typeVideoBtn.className = "px-4 py-2 rounded-lg text-sm font-semibold text-gray-500 hover:text-gray-900 transition-all";
            specialInput.accept = "image/*";
            specialUploadText.textContent = "Upload Image";
        } else {
            typeImageBtn.className = "px-4 py-2 rounded-lg text-sm font-semibold text-gray-500 hover:text-gray-900 transition-all";
            typeVideoBtn.className = "px-4 py-2 rounded-lg text-sm font-semibold transition-all bg-purple-100 text-purple-900 shadow-sm";
            specialInput.accept = "video/*";
            specialUploadText.textContent = "Upload Video";
        }
    }


    // Upload Handlers
    normalInput.addEventListener('change', function () {
        if (this.files && this.files[0]) {
            handleUpload(this.files[0], 'create');
            this.value = ''; // reset
        }
    });

    updateInput.addEventListener('change', function () {
        if (this.files && this.files[0] && updateState.id) {
            handleUpload(this.files[0], 'update');
            this.value = ''; // reset
        }
    });

    function handleUpload(file, mode) {
        if (!file.type.startsWith('image/')) {
            showErrorToast('Please select an image file');
            return;
        }

        const formData = new FormData();
        formData.append("file", file);

        const url = (mode === 'update')
            ? `https://meatsfresh.org.in:8082/api/home-banners/update/${updateState.id}`
            : USER_UPLOAD_API_URL;

        const method = (mode === 'update') ? 'PUT' : 'POST';

        $.ajax({
            url: url,
            method: method,
            data: formData,
            processData: false,
            contentType: false,
            beforeSend: getAuthHeaders,
            success: function (response) {
                showToast(`Banner ${mode === 'update' ? 'updated' : 'uploaded'} successfully!`);
                fetchNormalBanners();
            },
            error: function (xhr, status, error) {
                console.error("Upload error:", error);
                showErrorToast(`Failed to ${mode} banner: ` + (xhr.responseText || error));
            }
        });
    }

    specialInput.addEventListener('change', function () {
        if (this.files && this.files[0]) {
            // Mock behavior for special banners as they don't have an API yet
            const url = URL.createObjectURL(this.files[0]);
            specialBanners.push({
                id: 'sb' + Date.now(),
                type: currentUploadType,
                url: url,
                active: true
            });
            renderSpecial();
            this.value = '';
        }
    });


    // --- Render Logic ---

    function renderNormal() {
        const uploadCard = normalGrid.firstElementChild;
        normalGrid.innerHTML = '';
        normalGrid.appendChild(uploadCard);

        normalBanners.forEach(b => {
            const div = document.createElement('div');
            div.className = "relative group aspect-[5/3] rounded-2xl overflow-hidden shadow-md cursor-pointer animate-fade-in-up";
            div.innerHTML = `
                <img src="${b.image}" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110">
                
                <div class="absolute bottom-3 right-3 z-30">
                    <div class="flex items-center gap-1 bg-white/90 backdrop-blur-md p-1.5 rounded-xl shadow-lg border border-white/50">
                        <button onclick="updateNormal('${b.id}')" class="w-8 h-8 rounded-lg text-gray-600 hover:bg-blue-50 hover:text-blue-600 flex items-center justify-center transition-colors" title="Edit">
                            <i class="fas fa-pen text-xs"></i>
                        </button>
                        <div class="w-px h-4 bg-gray-300"></div>
                        <button onclick="deleteNormal('${b.id}')" class="w-8 h-8 rounded-lg text-gray-600 hover:bg-red-50 hover:text-red-500 flex items-center justify-center transition-colors" title="Delete">
                            <i class="fas fa-trash-alt text-xs"></i>
                        </button>
                    </div>
                </div>
             `;
            normalGrid.appendChild(div);
        });
    }

    function renderSpecial() {
        const uploadCard = specialGrid.firstElementChild;
        specialGrid.innerHTML = '';
        specialGrid.appendChild(uploadCard);

        specialBanners.forEach(b => {
            const div = document.createElement('div');
            div.className = "relative group aspect-[4/5] rounded-2xl overflow-hidden shadow-md bg-white animate-fade-in-up";

            let mediaContent = '';
            if (b.type === 'video') {
                mediaContent = `
                    <video src="${b.url}" class="w-full h-full object-cover"></video>
                    <div class="absolute inset-0 flex items-center justify-center pointer-events-none group-hover:opacity-0 transition-opacity">
                         <div class="w-12 h-12 rounded-full bg-black/30 backdrop-blur-sm flex items-center justify-center text-white">
                            <i class="fas fa-play ml-1"></i>
                         </div>
                    </div>
                    <button onclick="playVideo('${b.url}')" class="absolute inset-0 z-0"></button>
                `;
            } else {
                mediaContent = `<img src="${b.url}" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110">`;
            }

            const toggleHtml = `
                <label class="relative inline-flex items-center cursor-pointer pointer-events-auto" onclick="event.stopPropagation()">
                    <input type="checkbox" class="sr-only peer" ${b.active ? 'checked' : ''} onchange="toggleSpecial('${b.id}')">
                    <div class="w-9 h-5 bg-gray-200 peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-purple-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-purple-500"></div>
                </label>
            `;

            div.innerHTML = `
                ${mediaContent}
                <div class="absolute top-3 right-3 z-20">
                     ${toggleHtml}
                </div>
                <div class="absolute bottom-3 right-3 z-30">
                    <div class="flex items-center gap-1 bg-white/90 backdrop-blur-md p-1.5 rounded-xl shadow-lg border border-white/50">
                        <button onclick="updateSpecial('${b.id}')" class="w-8 h-8 rounded-lg text-gray-600 hover:bg-purple-50 hover:text-purple-600 flex items-center justify-center transition-colors" title="Edit">
                            <i class="fas fa-pen text-xs"></i>
                        </button>
                        <div class="w-px h-4 bg-gray-300"></div>
                        <button onclick="deleteSpecial('${b.id}')" class="w-8 h-8 rounded-lg text-gray-600 hover:bg-red-50 hover:text-red-500 flex items-center justify-center transition-colors" title="Delete">
                            <i class="fas fa-trash-alt text-xs"></i>
                        </button>
                    </div>
                </div>
            `;
            specialGrid.appendChild(div);
        });
    }

    // --- Actions ---

    window.deleteNormal = function (id) {
        if (!confirm('Delete this banner?')) return;

        $.ajax({
            url: `https://meatsfresh.org.in:8082/api/home-banners/delete/${id}`,
            method: 'DELETE',
            beforeSend: getAuthHeaders,
            success: function () {
                showToast('Banner deleted successfully');
                fetchNormalBanners();
            },
            error: function (xhr, status, error) {
                showErrorToast('Failed to delete banner');
            }
        });
    }

    window.updateNormal = function (id) {
        updateState = { id: id, type: 'normal' };
        updateInput.click();
    }

    // Special (Still Mock)
    window.deleteSpecial = function (id) {
        if (confirm('Remove this special banner?')) {
            specialBanners = specialBanners.filter(b => b.id !== id);
            renderSpecial();
        }
    }

    window.toggleSpecial = function (id) {
        const b = specialBanners.find(x => x.id === id);
        if (b) b.active = !b.active;
    }

    window.updateSpecial = function (id) {
        specialInput.click();
    }

    window.playVideo = function (url) {
        modalVideoPlayer.src = url;
        videoModal.show();
        modalVideoPlayer.play();
    }

});