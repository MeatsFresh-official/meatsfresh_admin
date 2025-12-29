document.addEventListener('DOMContentLoaded', function() {
    // =================================================================
    // == CONFIGURE YOUR API BASE URL HERE ==
    // =================================================================
    const BASE_URL = 'https://localhost:8080';
    // =================================================================

    const API_ENDPOINTS = {
        getConfig: `${BASE_URL}/api/sms/config`,
        saveConfig: `${BASE_URL}/api/sms/config`,
        updateFeature: `${BASE_URL}/api/sms/features`,
        sendTestSms: `${BASE_URL}/api/sms/test`,
    };

    // --- DOM Elements ---
    const loader = document.getElementById('loader');
    const mainContent = document.getElementById('mainContent');
    const smsConfigForm = document.getElementById('smsConfigForm');
    const smsProviderSelect = document.getElementById('smsProvider');
    const toggleAuthTokenBtn = document.getElementById('toggleAuthToken');
    const authTokenInput = document.getElementById('authTokenInput');
    const sendTestSmsBtn = document.getElementById('sendTestSmsBtn');
    const featureToggles = document.querySelectorAll('.feature-toggle');

    // Provider-specific elements
    const airtelUrlHelp = document.getElementById('airtelUrlHelp');
    const airtelTokenWarning = document.getElementById('airtelTokenWarning');

    // --- Modals ---
    const testSmsModal = new bootstrap.Modal(document.getElementById('testSmsModal'));

    // --- Toast Notifications ---
    const successToast = new bootstrap.Toast(document.getElementById('successToast'));
    const errorToast = new bootstrap.Toast(document.getElementById('errorToast'));

    function showToast(isSuccess, message) {
        document.getElementById(isSuccess ? 'toastMessage' : 'errorMessage').innerText = message;
        (isSuccess ? successToast : errorToast).show();
    }

    // --- API Helper ---
    async function apiRequest(url, method = 'GET', data = null) {
        try {
            const options = {
                method,
                headers: { 'Content-Type': 'application/json' },
            };
            if (data) options.body = JSON.stringify(data);
            const response = await fetch(url, options);
            if (!response.ok) {
                const err = await response.json();
                throw new Error(err.message || `HTTP Error: ${response.status}`);
            }
            return response.status === 204 ? { success: true } : await response.json();
        } catch (error) {
            console.error(`API ${method} Error:`, error);
            showToast(false, error.message || 'An unexpected error occurred.');
            return null;
        }
    }

    // --- UI Logic ---
    function handleProviderChange() {
        const provider = smsProviderSelect.value;
        const isAirtel = provider === 'AIRTEL';
        airtelUrlHelp.classList.toggle('d-none', !isAirtel);
        airtelTokenWarning.classList.toggle('d-none', !isAirtel);
        document.getElementById('apiUrl').readOnly = isAirtel;
    }

    function populateForm(config) {
        // Populate main config form
        document.getElementById('smsProvider').value = config.provider || '';
        document.getElementById('apiUrl').value = config.apiUrl || '';
        document.getElementById('authTokenInput').value = config.authToken || '';
        document.getElementById('otpTemplateId').value = config.templateIds?.otp || '';
        document.getElementById('orderTemplateId').value = config.templateIds?.order || '';
        document.getElementById('alertTemplateId').value = config.templateIds?.alert || '';
        document.getElementById('smsBalance').textContent = config.balance || 'N/A';

        // Populate feature toggles
        document.getElementById('enableSmsFeature').checked = config.features.enabled;
        document.getElementById('enableLoginOtp').checked = config.features.loginOtpEnabled;
        document.getElementById('enablePasswordReset').checked = config.features.passwordResetEnabled;
        document.getElementById('enableOrderUpdates').checked = config.features.orderUpdatesEnabled;
        document.getElementById('enablePromotions').checked = config.features.promotionsEnabled;

        handleProviderChange(); // Apply provider-specific UI changes
    }

    // --- Event Listeners ---
    smsProviderSelect.addEventListener('change', handleProviderChange);

    toggleAuthTokenBtn.addEventListener('click', () => {
        const isPassword = authTokenInput.type === 'password';
        authTokenInput.type = isPassword ? 'text' : 'password';
        toggleAuthTokenBtn.querySelector('i').classList.toggle('fa-eye', !isPassword);
        toggleAuthTokenBtn.querySelector('i').classList.toggle('fa-eye-slash', isPassword);
    });

    smsConfigForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const formData = new FormData(smsConfigForm);
        const data = {
            provider: formData.get('provider'),
            apiUrl: formData.get('apiUrl'),
            authToken: formData.get('authToken'),
            templateIds: {
                otp: formData.get('otpTemplateId'),
                order: formData.get('orderTemplateId'),
                alert: formData.get('alertTemplateId'),
            }
        };
        apiRequest(API_ENDPOINTS.saveConfig, 'POST', data).then(response => {
            if (response) {
                showToast(true, 'Configuration saved successfully!');
            }
        });
    });

    featureToggles.forEach(toggle => {
        toggle.addEventListener('change', () => {
            const feature = toggle.dataset.feature;
            const isEnabled = toggle.checked;
            apiRequest(API_ENDPOINTS.updateFeature, 'POST', { feature, isEnabled }).then(response => {
                if(response) {
                    showToast(true, `Feature '${feature}' updated.`);
                } else {
                    // Revert the toggle on failure
                    toggle.checked = !isEnabled;
                }
            });
        });
    });

    sendTestSmsBtn.addEventListener('click', () => {
        const form = document.getElementById('testSmsForm');
        if(!form.checkValidity()) {
            showToast(false, "Please fill in all required fields.");
            return;
        }
        const data = Object.fromEntries(new FormData(form).entries());
        sendTestSmsBtn.disabled = true;
        sendTestSmsBtn.innerHTML = `<i class="fas fa-spinner fa-spin me-2"></i>Sending...`;

        apiRequest(API_ENDPOINTS.sendTestSms, 'POST', data).then(response => {
            if (response) {
                showToast(true, `Test SMS sent successfully to ${data.phone}!`);
                testSmsModal.hide();
            }
        }).finally(() => {
            sendTestSmsBtn.disabled = false;
            sendTestSmsBtn.innerHTML = `<i class="fas fa-paper-plane me-2"></i>Send Test`;
        });
    });

    // --- Initial Load ---
    async function initializePage() {
        const config = await apiRequest(API_ENDPOINTS.getConfig);
        if (config) {
            populateForm(config);
            loader.classList.add('d-none');
            mainContent.classList.remove('d-none');
        } else {
            loader.innerHTML = `<h5 class="text-danger">Failed to load configuration. Please try again later.</h5>`;
        }
    }

    initializePage();
});