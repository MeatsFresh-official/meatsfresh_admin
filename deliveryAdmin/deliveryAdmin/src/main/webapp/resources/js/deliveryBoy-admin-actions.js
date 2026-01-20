$(document).ready(function () {
    // ===================================================================
    // API ENDPOINTS & CONFIG
    // ===================================================================
    const API_BASE = 'http://meatsfresh.org.in:8083/api';
    const RIDER_API = `${API_BASE}/delivery`;
    const ADMIN_API = `${API_BASE}/delivery/admin`;
    const WALLET_API = `${API_BASE}/delivery/wallets`;
    const PAYOUT_API = `${API_BASE}/payouts`;

    const urlParams = new URLSearchParams(window.location.search);
    const riderId = urlParams.get('id');

    // ===================================================================
    // GLOBAL AJAX SETUP FOR BASIC AUTHENTICATION
    // ===================================================================
    const username = 'user';
    const password = 'user';
    const authHeader = 'Basic ' + btoa(username + ':' + password);

    // This will apply to any AJAX call that DOES NOT have its own beforeSend function.
    $.ajaxSetup({
        beforeSend: function (xhr) {
            xhr.setRequestHeader('Authorization', authHeader);
        }
    });

    // ===================================================================
    // INITIALIZATION
    // ===================================================================
    if (!riderId) {
        showError('No Rider ID found. Redirecting...');
        setTimeout(() => window.location.href = 'deliveryBoy-manage', 2000);
        return;
    }

    $('#viewRiderBtn').attr('href', `deliveryBoy-view?id=${riderId}`);
    loadRiderData();

    // ===================================================================
    // EVENT HANDLERS
    // ===================================================================
    $('#approveBtn').on('click', handleApprove);
    $('#rejectBtn').on('click', handleReject);
    $('#creditWalletForm').on('submit', handleCreditWallet);
    $('#debitWalletForm').on('submit', handleDebitWallet);
    $('#payoutForm').on('submit', handlePayout);

    // ===================================================================
    // CORE FUNCTIONS
    // ===================================================================

    function loadRiderData() {
        // This request works fine because it uses the global ajaxSetup.
        $.get(`${RIDER_API}/${riderId}`)
            .done(function (data) {
                $('#riderName').text(`${data.firstName} ${data.lastName}`);
                $('#riderId').text(data.id);
                updateStatusUI(data);

                $('#loading-spinner').addClass('d-none');
                $('#action-container').removeClass('d-none');
            })
            .fail(xhr => {
                showError('Failed to load rider data: ' + getErrorMessage(xhr));
                $('#loading-spinner').html('<div class="alert alert-danger">Could not load rider data.</div>');
            });
    }

    function updateStatusUI(rider) {
        const status = determineRiderStatus(rider);
        $('#riderStatusBadge').html(`<span class="badge ${status.class}">${status.text}</span>`);

        const approvalButtons = $('#approval-buttons');
        const rejectionDisplay = $('#rejection-reason-display');

        rejectionDisplay.addClass('d-none');
        approvalButtons.addClass('d-none');

        if (status.text === 'Pending' || status.text === 'Rejected') {
            approvalButtons.removeClass('d-none');
        }

        if (status.text === 'Rejected' && rider.rejectionReason) {
            rejectionDisplay
                .html(`<strong>Rejection Reason:</strong> ${rider.rejectionReason}`)
                .removeClass('d-none')
                .addClass('alert alert-warning p-2');
        }
    }

    function handleApprove() {
        if (!confirm('Are you sure you want to approve this rider?')) return;
        updateRiderStatus(
            `${ADMIN_API}/${riderId}/approve-partner`,
            'PATCH',
            'Rider approved successfully!'
        );
    }

    function handleReject() {
        const reason = prompt("Please enter the reason for rejection:");
        if (reason && reason.trim()) {
            updateRiderStatus(
                `${ADMIN_API}/${riderId}/reject-partner?rejectionReason=${encodeURIComponent(reason.trim())}`,
                'PUT',
                'Rider rejected successfully.'
            );
        } else if (reason !== null) {
            showError('Rejection reason cannot be empty.');
        }
    }

    function updateRiderStatus(url, method, successMessage) {
        const btn = $('#approveBtn, #rejectBtn');
        $.ajax({
            url: url,
            method: method,
            // MODIFIED: This beforeSend function now also sets the auth header.
            beforeSend: function (xhr) {
                xhr.setRequestHeader('Authorization', authHeader);
                btn.prop('disabled', true);
            },
            success: function () {
                showToast(successMessage);
                loadRiderData(); // Reload data to reflect the new status
            },
            error: xhr => showError('Error updating status: ' + getErrorMessage(xhr)),
            complete: () => btn.prop('disabled', false)
        });
    }

    function handleCreditWallet(e) {
        e.preventDefault();
        const form = $(this);
        const amount = form.find('[name="amount"]').val();
        const description = form.find('[name="description"]').val();
        const url = `${WALLET_API}/${riderId}/credit?amount=${amount}&description=${encodeURIComponent(description)}`;

        performWalletAction(form, url, 'POST', 'Amount credited successfully!');
    }

    function handleDebitWallet(e) {
        e.preventDefault();
        const form = $(this);
        const amount = form.find('[name="amount"]').val();
        const description = form.find('[name="description"]').val();
        const url = `${WALLET_API}/${riderId}/debit?amount=${amount}&description=${encodeURIComponent(description)}`;

        performWalletAction(form, url, 'POST', 'Amount debited successfully!');
    }

    function performWalletAction(form, url, method, successMessage) {
        const btn = form.find('button[type="submit"]');
        const btnText = btn.html();

        $.ajax({
            url: url,
            method: method,
            // MODIFIED: This beforeSend function now also sets the auth header.
            beforeSend: function (xhr) {
                xhr.setRequestHeader('Authorization', authHeader);
                btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Processing...');
            },
            success: function () {
                showToast(successMessage);
                form[0].reset();
            },
            error: xhr => showError('Error performing wallet action: ' + getErrorMessage(xhr)),
            complete: () => btn.prop('disabled', false).html(btnText)
        });
    }

    function handlePayout(e) {
        e.preventDefault();
        const form = $(this);
        const btn = form.find('button[type="submit"]');
        const btnText = btn.html();

        const payload = {
            deliveryPartnerId: parseInt(riderId),
            amount: parseFloat(form.find('[name="amount"]').val()),
            paymentMethod: form.find('[name="paymentMethod"]').val()
        };

        $.ajax({
            url: `${PAYOUT_API}/process`,
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(payload),
            // MODIFIED: This beforeSend function now also sets the auth header.
            beforeSend: function (xhr) {
                xhr.setRequestHeader('Authorization', authHeader);
                btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Processing...');
            },
            success: function (response) {
                showToast(response.message || 'Payout processed successfully!');
                form[0].reset();
            },
            error: xhr => showError('Error processing payout: ' + getErrorMessage(xhr)),
            complete: () => btn.prop('disabled', false).html(btnText)
        });
    }

    // ===================================================================
    // HELPER & UTILITY FUNCTIONS
    // ===================================================================
    function determineRiderStatus(rider) {
        if (rider.approved === null && !rider.rejectionReason) return { text: 'Pending', class: 'bg-warning text-dark' };
        if (rider.rejectionReason || rider.approved === false) return { text: 'Rejected', class: 'bg-danger' };
        if (rider.approved === true) return { text: 'Active', class: 'bg-success' };
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
            try {
                const response = JSON.parse(xhr.responseText);
                if (response.message) return response.message;
            } catch (e) { }
        }
        return xhr.statusText || 'An unknown error occurred.';
    }
});