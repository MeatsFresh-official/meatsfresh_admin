document.addEventListener('DOMContentLoaded', () => {

    // --- Mock Data ---
    let normalBanners = [
        { id: 'nb1', image: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80' },
        { id: 'nb2', image: 'https://images.unsplash.com/photo-1606787366850-de6330128bfc?auto=format&fit=crop&w=800&q=80' }
    ];

    let specialBanners = [
        { id: 'sb1', type: 'image', url: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&fit=crop&w=600&q=80', active: true },
        { id: 'sb2', type: 'video', url: 'https://assets.mixkit.co/videos/preview/mixkit-slicing-a-juicy-lime-1563-large.mp4', active: false }
    ];

    let currentUploadType = 'image'; // 'image' or 'video' for special section

    // --- DOM ---
    const normalGrid = document.getElementById('normalBannersGrid');
    const specialGrid = document.getElementById('specialBannersGrid');

    const normalInput = document.getElementById('normalFileInput');
    const specialInput = document.getElementById('specialFileInput');

    const typeImageBtn = document.getElementById('typeImageBtn');
    const typeVideoBtn = document.getElementById('typeVideoBtn');
    const specialUploadText = document.getElementById('specialUploadText');

    const videoModalEl = document.getElementById('videoModal');
    const modalVideoPlayer = document.getElementById('modalVideoPlayer');
    let videoModal = null;
    if (videoModalEl) videoModal = new bootstrap.Modal(videoModalEl);

    // --- Init ---
    renderNormal();
    renderSpecial();

    // Cleaning up video when modal hides
    if (videoModalEl) {
        videoModalEl.addEventListener('hidden.bs.modal', () => {
            modalVideoPlayer.pause();
            modalVideoPlayer.src = '';
        });
    }

    // --- Handlers ---

    window.setUploadType = function (type) {
        currentUploadType = type;

        // Update Buttons
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
            const url = URL.createObjectURL(this.files[0]);
            normalBanners.push({ id: 'nb' + Date.now(), image: url });
            renderNormal();
            this.value = ''; // reset
        }
    });

    specialInput.addEventListener('change', function () {
        if (this.files && this.files[0]) {
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
        // Keep the first child (the upload card)
        const uploadCard = normalGrid.firstElementChild;
        normalGrid.innerHTML = '';
        normalGrid.appendChild(uploadCard);

        normalBanners.forEach(b => {
            const div = document.createElement('div');
            div.className = "relative group aspect-[5/3] rounded-2xl overflow-hidden shadow-md cursor-pointer animate-fade-in-up";
            div.innerHTML = `
                <img src="${b.image}" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110">
                
                <!-- Action Pill -->
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

            // Toggle Switch HTML
            const toggleHtml = `
                <label class="relative inline-flex items-center cursor-pointer pointer-events-auto" onclick="event.stopPropagation()">
                    <input type="checkbox" class="sr-only peer" ${b.active ? 'checked' : ''} onchange="toggleSpecial('${b.id}')">
                    <div class="w-9 h-5 bg-gray-200 peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-purple-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-purple-500"></div>
                </label>
            `;

            div.innerHTML = `
                ${mediaContent}
                
                <!-- Top Actions -->
                <div class="absolute top-3 right-3 z-20">
                     ${toggleHtml}
                </div>
                
                <!-- Action Pill -->
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

    // Normal
    window.deleteNormal = function (id) {
        if (confirm('Delete this banner?')) {
            normalBanners = normalBanners.filter(b => b.id !== id);
            renderNormal();
        }
    }

    // For update, we use a hidden input trick (globally or creating one)
    // For simplicity in this demo, we'll just simulate a click on the main input
    // In a real app, you'd track WHICH ID is being updated.
    window.updateNormal = function (id) {
        normalInput.click();
        // NOTE: In a real app we would need to know we are in "update mode" for this ID
        // But for this mock, we just add a new one which is fine for visual demo
    }

    // Special
    window.deleteSpecial = function (id) {
        if (confirm('Remove this special banner?')) {
            specialBanners = specialBanners.filter(b => b.id !== id);
            renderSpecial();
        }
    }

    window.toggleSpecial = function (id) {
        const b = specialBanners.find(x => x.id === id);
        if (b) b.active = !b.active;
        // No re-render needed for checkbox as visual state updates automatically
        // But in real app, we'd send API call here
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