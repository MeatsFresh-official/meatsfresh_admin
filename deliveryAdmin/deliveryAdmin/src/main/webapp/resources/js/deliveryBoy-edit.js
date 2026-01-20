$(document).ready(function () {
    // ===================================================================
    // API ENDPOINTS & CONFIG
    // ===================================================================
    const API_BASE = 'http://meatsfresh.org.in:8083/api';
    const RIDER_API = `${API_BASE}/delivery`;

    const urlParams = new URLSearchParams(window.location.search);
    const riderId = urlParams.get('id');

    let originalRiderData = null; // Store the original fetched data

    // ===================================================================
    // GLOBAL AJAX SETUP FOR BASIC AUTHENTICATION
    // ===================================================================
    const username = 'user';
    const password = 'user';
    $.ajaxSetup({
        beforeSend: function (xhr) {
            // This function runs before every AJAX request and adds the auth header.
            const authHeader = 'Basic ' + btoa(username + ':' + password);
            xhr.setRequestHeader('Authorization', authHeader);
        }
    });

    // ===================================================================
    // INITIALIZATION
    // ===================================================================
    if (!riderId) {
        showError('No Rider ID found. Redirecting to the main list.');
        setTimeout(() => window.location.href = 'deliveryBoy-manage', 2000);
        return;
    }

    $('#viewRiderBtn').attr('href', `deliveryBoy-view?id=${riderId}`);
    loadRiderData();

    // ===================================================================
    // EVENT HANDLERS
    // ===================================================================
    $('#editRiderForm').on('submit', handleSaveChanges);

    // ===================================================================
    // CORE FUNCTIONS
    // ===================================================================

    function loadRiderData() {
        // This $.get request will automatically be authenticated by ajaxSetup
        $.get(`${RIDER_API}/${riderId}`)
            .done(function (data) {
                originalRiderData = data;
                populateForm(data);
                updateStatusUI(data);

                $('#loading-spinner').addClass('d-none');
                $('#edit-form-container').removeClass('d-none');
            })
            .fail(xhr => {
                showError('Failed to load rider data: ' + getErrorMessage(xhr));
                $('#loading-spinner').html('<div class="alert alert-danger">Could not load rider data.</div>');
            });
    }

    function populateForm(rider) {
        // Simple key-value mapping for most fields
        for (const key in rider) {
            if (rider.hasOwnProperty(key)) {
                const el = $(`#editRiderForm [name="${key}"]`);
                if (el.length) {
                    el.val(rider[key]);
                }
            }
        }
    }

    function updateStatusUI(rider) {
        const status = determineRiderStatus(rider);
        $('#riderStatusBadge').html(`<span class="badge ${status.class}">${status.text}</span>`);
    }

    function handleSaveChanges(e) {
        e.preventDefault();
        const submitBtn = $(this).find('button[type="submit"]');

        const updatedData = { ...originalRiderData };
        $('#editRiderForm').find('input, select').each(function () {
            const name = $(this).attr('name');
            if (name && updatedData.hasOwnProperty(name)) {
                updatedData[name] = $(this).val();
            }
        });

        // This $.ajax request will also be automatically authenticated
        $.ajax({
            url: `${RIDER_API}/${riderId}`,
            method: 'PUT',
            contentType: 'application/json',
            data: JSON.stringify(updatedData),
            beforeSend: () => submitBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Saving...'),
            success: function () {
                showToast('Profile updated successfully!');
                setTimeout(() => window.location.href = `deliveryBoy-view?id=${riderId}`, 1500);
            },
            error: xhr => showError('Error updating profile: ' + getErrorMessage(xhr)),
            complete: () => submitBtn.prop('disabled', false).html('<i class="fas fa-save me-2"></i>Save Changes')
        });
    }

    // ===================================================================
    // HELPER & UTILITY FUNCTIONS
    // ===================================================================
    function determineRiderStatus(rider) {
        if (rider.rejectionReason) return { text: 'Rejected', class: 'bg-danger' };
        if (rider.approved === null) return { text: 'Pending', class: 'bg-warning text-dark' };
        if (rider.approved === true) return { text: 'Active', class: 'bg-success' };
        if (rider.approved === false) return { text: 'Inactive', class: 'bg-secondary' };
        return { text: 'UNKNOWN', class: 'bg-dark' };
    }

    function showToast(message) {
        $('#toastMessage').text(message);
        new bootstrap.Toast($('#successToast').get(0)).show();
    }

    function showError(message) {
        $('#errorMessage').text(message);
        new bootstrap.Toast($('#errorToast').get(0)).show();
    }

    function getErrorMessage(xhr) {
        if (xhr && xhr.responseJSON && xhr.responseJSON.message) return xhr.responseJSON.message;
        if (xhr && xhr.responseText) {
            try { return JSON.parse(xhr.responseText).message; } catch (e) { }
        }
        return xhr.statusText || 'An unknown error occurred.';
    }
});