document.addEventListener('DOMContentLoaded', function () {
    const API_BASE = 'http://meatsfresh.org.in:8080/api';
    const ADMIN_VENDORS_API = `${API_BASE}/vendor/allVendors`;
    const VENDOR_STATUS_API = (id) => `${API_BASE}/vendor/admin/${id}/status`;
    const VENDOR_UPDATE_API = (id) => `${API_BASE}/vendor/admin/update/${id}`;
    const IMAGE_BASE_URL = 'http://meatsfresh.org.in:8080/';

    const editVendorForm = document.getElementById('editVendorForm');
    const mainTitle = document.getElementById('edit-vendor-title-main');
    const formLoadingSpinner = document.getElementById('form-loading-spinner');

    const getVendorIdFromUrl = () => new URLSearchParams(window.location.search).get('id');
    const VENDOR_ID = getVendorIdFromUrl();

    // Modified to include Basic Authentication
    const fetchAPI = async (url, options = {}) => {
        try {
            // --- START: Added for Basic Authentication ---
            const username = 'user';
            const password = 'user';
            const headers = {
                ...options.headers, // Preserve existing headers
                'Authorization': 'Basic ' + btoa(`${username}:${password}`)
            };
            // --- END: Added for Basic Authentication ---

            const fetchOptions = { ...options, headers, cache: 'no-cache' }; // Use the new headers
            const response = await fetch(url, fetchOptions);

            if (!response.ok) {
                const errorData = await response.json().catch(() => ({ message: 'Request failed' }));
                throw new Error(errorData.message);
            }
            if (response.status === 204 || response.headers.get('content-length') === '0') return { success: true };

            return response.json();
        } catch (error) {
            console.error(`API Error on ${url}:`, error);
            alert(`Error: ${error.message}`);
            return null;
        }
    };

    const populateForm = (vendor) => {
        mainTitle.textContent = `Edit Shop: ${vendor.vendorName}`;

        for (const key in vendor) {
            const input = editVendorForm.querySelector(`[name="${key}"]`);
            if (input) {
                if (key === 'isApproved') {
                    input.value = String(vendor.isApproved);
                } else if (key === 'isActive') {
                    input.value = vendor.isActive;
                } else {
                    input.value = vendor[key];
                }
            }
        }

        const vendorIdInput = editVendorForm.querySelector('[name="vendorId"]');
        if (vendorIdInput) vendorIdInput.value = vendor.vendorId;

        const shopPhotoEl = document.getElementById('currentShopPhoto');
        if (vendor.shopPhoto) {
            shopPhotoEl.innerHTML = `<img src="${IMAGE_BASE_URL}${vendor.shopPhoto}" class="img-fluid rounded" alt="Current Photo" /><small class="text-muted d-block mt-2">Current photo. Upload to replace.</small>`;
        } else {
            shopPhotoEl.innerHTML = `<span class="text-muted small">No photo uploaded.</span>`;
        }
    };

    // Modified to include Basic Authentication
    const handleFormSubmit = async (e) => {
        e.preventDefault();
        if (!VENDOR_ID) { alert('Error: No vendor ID found.'); return; }

        const formData = new FormData(editVendorForm);
        const submitButton = editVendorForm.querySelector('button[type="submit"]');
        submitButton.disabled = true;
        submitButton.innerHTML = `<i class="fas fa-spinner fa-spin me-2"></i>Saving...`;

        // --- START: Added for Basic Authentication ---
        const username = 'user';
        const password = 'user';
        const headers = new Headers(); // Use Headers constructor for FormData
        headers.append('Authorization', 'Basic ' + btoa(`${username}:${password}`));
        // --- END: Added for Basic Authentication ---

        try {
            // Pass the authentication headers into the fetch request options
            const response = await fetch(VENDOR_UPDATE_API(VENDOR_ID), {
                method: 'PUT',
                body: formData,
                headers: headers // Add the headers here
            });
            if (!response.ok) {
                const errorData = await response.json().catch(() => ({ message: 'Update failed with no specific error message.' }));
                throw new Error(errorData.message);
            }
            alert('Vendor updated successfully!');
            window.location.href = `shopspage.jsp`;
        } catch (error) {
            console.error('Update failed:', error);
            alert(`Failed to update vendor: ${error.message}`);
        } finally {
            submitButton.disabled = false;
            submitButton.innerHTML = `<i class="fas fa-save me-2"></i>Save Changes`;
        }
    };

    async function init() {
        if (!VENDOR_ID) {
            mainTitle.textContent = 'Error: No Vendor ID Provided';
            formLoadingSpinner.classList.add('d-none');
            return;
        }

        // These calls will now be authenticated via the updated fetchAPI function
        const [vendors, statusInfo] = await Promise.all([
            fetchAPI(ADMIN_VENDORS_API),
            fetchAPI(VENDOR_STATUS_API(VENDOR_ID))
        ]);

        const vendor = vendors ? vendors.find(v => v.vendorId == VENDOR_ID) : null;

        if (vendor && statusInfo) {
            const updatedVendor = { ...vendor, isApproved: statusInfo.isApproved };
            populateForm(updatedVendor);
        } else {
            mainTitle.textContent = `Error: Vendor with ID ${VENDOR_ID} not found.`;
        }

        formLoadingSpinner.classList.add('d-none');
        editVendorForm.classList.remove('d-none');
    }

    editVendorForm.addEventListener('submit', handleFormSubmit);
    init();
});