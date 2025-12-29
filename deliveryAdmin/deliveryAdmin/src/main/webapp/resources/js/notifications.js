document.addEventListener('DOMContentLoaded', function() {
    // =================================================================
    // == CONFIGURE YOUR API BASE URL HERE ==
    // =================================================================
    const BASE_URL = 'https://localhost:8080';
    // =================================================================

    const API_ENDPOINTS = {
        getTemplates: `${BASE_URL}/api/notifications/templates`,
        updateTemplate: `${BASE_URL}/api/notifications/templates`,
        getCampaigns: `${BASE_URL}/api/notifications/campaigns`,
        createCampaign: `${BASE_URL}/api/notifications/campaigns`,
    };

    // --- DOM Elements ---
    const templatesListContainer = document.getElementById('notificationTemplatesList');
    const templateEditor = document.getElementById('templateEditor');
    const templatePlaceholder = document.getElementById('templatePlaceholder');
    const templateForm = document.getElementById('templateForm');
    const campaignsTableBody = document.querySelector('#campaignsTable tbody');
    const createCampaignForm = document.getElementById('createCampaignForm');
    const scheduleTypeSelect = document.getElementById('scheduleType');
    const scheduleDateContainer = document.getElementById('scheduleDateContainer');

    // --- Modals ---
    const createCampaignModal = new bootstrap.Modal(document.getElementById('createCampaignModal'));

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

    // =======================================================
    // == MESSAGE TEMPLATES TAB LOGIC
    // =======================================================

    function loadTemplates() {
        templatesListContainer.innerHTML = `<div class="text-center p-3"><i class="fas fa-spinner fa-spin"></i> Loading templates...</div>`;
        apiRequest(API_ENDPOINTS.getTemplates).then(templates => {
            renderTemplateList(templates || []);
        });
    }

    function renderTemplateList(templates) {
        templatesListContainer.innerHTML = '';
        if (templates.length === 0) {
            templatesListContainer.innerHTML = `<div class="text-center p-3">No templates found.</div>`;
            return;
        }
        templates.forEach(template => {
            const item = document.createElement('a');
            item.href = '#';
            item.className = 'list-group-item list-group-item-action';
            item.textContent = template.name;
            item.dataset.templateId = template.id;
            item.addEventListener('click', (e) => {
                e.preventDefault();
                document.querySelectorAll('#notificationTemplatesList .list-group-item').forEach(el => el.classList.remove('active'));
                item.classList.add('active');
                displayTemplateForEditing(template);
            });
            templatesListContainer.appendChild(item);
        });
    }

    function displayTemplateForEditing(template) {
        templatePlaceholder.classList.add('d-none');
        templateEditor.classList.remove('d-none');

        document.getElementById('templateId').value = template.id;
        document.getElementById('templateName').value = template.name;
        document.getElementById('templateAudience').value = template.audience;
        document.getElementById('templateMessage').value = template.message;
        document.getElementById('templateIcon').value = template.icon;
        document.getElementById('templateVariables').textContent = `Available variables: ${template.variables.join(', ')}`;
    }

    templateForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const data = Object.fromEntries(new FormData(templateForm).entries());
        apiRequest(`${API_ENDPOINTS.updateTemplate}/${data.id}`, 'PUT', data).then(response => {
            if(response) {
                showToast(true, 'Template saved successfully!');
            }
        });
    });

    // =======================================================
    // == PROMOTIONAL TAB LOGIC
    // =======================================================

    function loadCampaigns() {
        campaignsTableBody.innerHTML = `<tr><td colspan="7" class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading campaigns...</td></tr>`;
        apiRequest(API_ENDPOINTS.getCampaigns).then(campaigns => {
            renderCampaignsTable(campaigns || []);
        });
    }

    function renderCampaignsTable(campaigns) {
        campaignsTableBody.innerHTML = '';
        if (campaigns.length === 0) {
            campaignsTableBody.innerHTML = `<tr><td colspan="7" class="text-center">No campaigns found.</td></tr>`;
            return;
        }
        campaigns.forEach(campaign => {
            const statusBadge = campaign.status === 'SENT' ? `<span class="badge bg-success">Sent</span>` : `<span class="badge bg-warning text-dark">Scheduled</span>`;
            const row = `
                <tr>
                    <td>${campaign.name}</td>
                    <td>${campaign.target}</td>
                    <td>${statusBadge}</td>
                    <td>${new Date(campaign.sentDate).toLocaleString('en-IN')}</td>
                    <td>${campaign.recipients.toLocaleString('en-IN')}</td>
                    <td>
                        <div class="progress" style="height: 6px;">
                            <div class="progress-bar bg-info" role="progressbar" style="width: ${campaign.openRate}%"></div>
                        </div>
                        <small>${campaign.openRate}%</small>
                    </td>
                    <td>
                        <div class="btn-group btn-group-sm" role="group">
                            <button class="btn btn-outline-primary" title="View Report"><i class="fas fa-chart-line"></i></button>
                            <button class="btn btn-outline-secondary" title="Duplicate Campaign"><i class="fas fa-copy"></i></button>
                        </div>
                    </td>
                </tr>`;
            campaignsTableBody.insertAdjacentHTML('beforeend', row);
        });
    }

    scheduleTypeSelect.addEventListener('change', (e) => {
        scheduleDateContainer.classList.toggle('d-none', e.target.value !== 'SCHEDULE');
    });

    createCampaignForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const formData = new FormData(createCampaignForm);
        // Using FormData is better for file uploads
        // Note: For file uploads, the apiRequest helper needs adjustment to not set Content-Type header
        // For now, assuming JSON submission.
        const data = Object.fromEntries(formData.entries());

        apiRequest(API_ENDPOINTS.createCampaign, 'POST', data).then(response => {
            if(response) {
                showToast(true, 'Campaign created successfully!');
                createCampaignModal.hide();
                createCampaignForm.reset();
                scheduleDateContainer.classList.add('d-none');
                loadCampaigns();
            }
        });
    });

    // =======================================================
    // == SOUNDS TAB LOGIC (Placeholder)
    // =======================================================

    function loadSoundSettings() {
        // This would fetch and populate the sound settings form
        console.log("Loading sound settings...");
    }

    // =======================================================
    // == TAB SWITCHING & INITIAL LOAD
    // =======================================================

    const tabs = {
        'templates-tab': loadTemplates,
        'promotional-tab': loadCampaigns,
        'sounds-tab': loadSoundSettings
    };

    document.querySelectorAll('#notificationTabs .nav-link').forEach(tabEl => {
        tabEl.addEventListener('shown.bs.tab', (event) => {
            const tabId = event.target.id;
            if (tabs[tabId]) {
                tabs[tabId]();
            }
        });
    });

    // Initial Load for the default active tab
    loadTemplates();
});