$(document).ready(function () {
    // ===================================================================
    // API ENDPOINTS & CONFIG
    // ===================================================================
    const API_BASE = 'http://meatsfresh.org.in:8083/api';
    const RIDER_API = `${API_BASE}/delivery`;
    const ADMIN_API = `${API_BASE}/delivery/admin`;
    const PAYOUT_API = `${API_BASE}/payouts`;
    const WALLET_API = `${API_BASE}/delivery/wallets`;

    const urlParams = new URLSearchParams(window.location.search);
    const riderId = urlParams.get('id');

    // ===================================================================
    // GLOBAL AJAX SETUP FOR BASIC AUTHENTICATION
    // ===================================================================
    const username = 'user';
    const password = 'user';
    $.ajaxSetup({
        beforeSend: function (xhr) {
            const authHeader = 'Basic ' + btoa(username + ':' + password);
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

    $('#editRiderBtn').attr('href', `deliveryBoy-edit?id=${riderId}`);
    loadCoreRiderDetails();

    // ===================================================================
    // EVENT HANDLERS
    // ===================================================================
    $(document).on('click', '#approveBtn', function () {
        if (confirm('Are you sure you want to approve this rider?')) {
            updateRiderStatus(`${ADMIN_API}/${riderId}/approve-partner`, 'PATCH', 'Rider approved successfully');
        }
    });

    $(document).on('click', '#rejectBtn', function () {
        const reason = prompt("Please enter the reason for rejection:");
        if (reason && reason.trim()) {
            updateRiderStatus(`${ADMIN_API}/${riderId}/reject-partner?rejectionReason=${encodeURIComponent(reason.trim())}`, 'PUT', 'Rider rejected successfully');
        } else if (reason !== null) {
            showError('Rejection reason cannot be empty.');
        }
    });

    // ===================================================================
    // DATA LOADING FUNCTIONS
    // ===================================================================

    function loadCoreRiderDetails() {
        $('#rider-content').addClass('d-none');
        $('#loading-spinner').removeClass('d-none');

        $.get(`${RIDER_API}/${riderId}`)
            .done(function (rider) {
                renderHeaderAndPersonalTabs(rider);
                loadFinancialData();
                loadEarningsChartData();
                $('#loading-spinner').addClass('d-none');
                $('#rider-content').removeClass('d-none');
            })
            .fail(function (xhr) {
                $('#loading-spinner').html(`<div class="alert alert-danger">Failed to load rider details: ${getErrorMessage(xhr)}</div>`);
            });
    }

    function loadFinancialData() {
        // Use $.when to make multiple API calls in parallel
        $.when(
            $.get(`${PAYOUT_API}/partner-summary/${riderId}`),
            $.get(`${PAYOUT_API}/cash-status?deliveryPartnerId=${riderId}`),
            $.get(`${PAYOUT_API}/summary?deliveryPartnerId=${riderId}`),
            $.get(`${WALLET_API}/${riderId}/transactions`)
        ).done(function (partnerSummary, cashStatus, payoutHistory, transactions) {
            // $.when wraps responses in an array: [data, textStatus, jqXHR]
            renderWalletTab(partnerSummary[0], cashStatus[0], payoutHistory[0], transactions[0]);
        }).fail(function (xhr) {
            $('#wallet').html(`<div class="alert alert-warning">Could not load wallet or payout details: ${getErrorMessage(xhr)}</div>`);
        });
    }

    function loadEarningsChartData() {
        $.get(`${RIDER_API}/earnings/weekly/${riderId}`)
            .done(renderEarningsTab)
            .fail(xhr => $('#earnings').html(`<div class="alert alert-warning">Could not load earnings chart: ${getErrorMessage(xhr)}</div>`));
    }

    // ===================================================================
    // RENDERING FUNCTIONS
    // ===================================================================
    function renderHeaderAndPersonalTabs(rider) {
        const status = determineRiderStatus(rider);
        $('#riderName').text(`${rider.firstName} ${rider.lastName}`);
        $('#riderId').text(rider.id);
        $('#riderSelfie').attr('src', rider.selfiePhotoUrl || 'resources/images/default-avatar.png');
        $('#riderStatus').text(status.text).attr('class', `badge ${status.class}`);

        if (status.text === 'Pending' || status.text === 'Rejected') {
            $('#admin-actions').removeClass('d-none');
            if (status.text === 'Rejected' && rider.rejectionReason) {
                $('#rejection-reason-display').text(`Reason: ${rider.rejectionReason}`).removeClass('d-none');
            } else {
                $('#rejection-reason-display').addClass('d-none');
            }
        } else {
            $('#admin-actions').addClass('d-none');
        }

        renderPersonalTab(rider);
        renderDocumentsTab(rider);
    }

    function renderWalletTab(partnerSummary, cashStatus, payoutHistory, transactions) {
        const historyHtml = payoutHistory && payoutHistory.length > 0 ? payoutHistory.map(p => `
            <tr>
                <td>${p.weekRange}</td>
                <td>${formatCurrency(p.earnings)}</td>
                <td>${formatCurrency(p.deductions)}</td>
                <td><strong>${formatCurrency(p.weeklyPayout)}</strong></td>
                <td>${p.payoutDate ? new Date(p.payoutDate).toLocaleDateString() : 'N/A'}</td>
            </tr>`).join('') : '<tr><td colspan="5" class="text-center text-muted">No payout history found.</td></tr>';

        const transactionHtml = transactions && transactions.length > 0 ? transactions.map(t => `
            <tr>
                <td>${new Date(t.timestamp).toLocaleString()}</td>
                <td>${t.description}</td>
                <td><span class="badge bg-${t.type === 'CREDIT' ? 'success' : 'danger'}">${t.type}</span></td>
                <td class="text-end">${formatCurrency(t.amount)}</td>
            </tr>`).join('') : '<tr><td colspan="4" class="text-center text-muted">No recent transactions.</td></tr>';

        const walletHtml = `
            <div class="row g-4">
                <div class="col-lg-4 col-md-6">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body text-center">
                            <h6 class="text-muted card-title">Available for Payout</h6>
                            <h3 class="display-6">${formatCurrency(partnerSummary.availableBalance)}</h3>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body text-center">
                            <h6 class="text-muted card-title">Total Earnings (${partnerSummary.weekRange})</h6>
                            <h3 class="display-6">${formatCurrency(partnerSummary.totalEarnings)}</h3>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-12">
                     <div class="card h-100 shadow-sm">
                        <div class="card-body">
                            <h6 class="text-muted card-title mb-2">Cash in Hand Status</h6>
                            <div class="progress" style="height: 25px;">
                                <div class="progress-bar" role="progressbar" style="width: ${cashStatus.percentageUsed}%;"
                                     aria-valuenow="${cashStatus.percentageUsed}" aria-valuemin="0" aria-valuemax="100">
                                     ${cashStatus.percentageUsed.toFixed(2)}%
                                </div>
                            </div>
                            <div class="d-flex justify-content-between mt-1">
                                <small><strong>${formatCurrency(cashStatus.currentCash)}</strong> collected</small>
                                <small>Limit: ${formatCurrency(cashStatus.cashLimit)}</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <hr class="my-4">

            <h5>Payout History</h5>
            <div class="table-responsive">
                <table class="table table-sm table-hover">
                    <thead class="table-light"><tr><th>Week</th><th>Earnings</th><th>Deductions</th><th>Net Payout</th><th>Payout Date</th></tr></thead>
                    <tbody>${historyHtml}</tbody>
                </table>
            </div>

            <hr class="my-4">

            <h5>Recent Wallet Transactions</h5>
            <div class="table-responsive">
                <table class="table table-sm table-hover">
                    <thead class="table-light"><tr><th>Date</th><th>Description</th><th>Type</th><th class="text-end">Amount</th></tr></thead>
                    <tbody>${transactionHtml}</tbody>
                </table>
            </div>`;
        $('#wallet').html(walletHtml);
    }

    function renderPersonalTab(rider) {
        const personalHtml = `
            <div class="row">
                <div class="col-md-6">
                    <h5>Personal Information</h5>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item"><strong>Phone:</strong> ${rider.phoneNumber || 'N/A'}</li>
                        <li class="list-group-item"><strong>Gender:</strong> ${rider.gender || 'N/A'}</li>
                        <li class="list-group-item"><strong>Working Type:</strong> ${rider.workingType || 'N/A'}</li>
                        <li class="list-group-item"><strong>T-Shirt Size:</strong> ${rider.tshirtSize || 'N/A'}</li>
                        <li class="list-group-item"><strong>Preferred Zone:</strong> ${rider.preferredDeliveryZone || 'N/A'}</li>
                        <li class="list-group-item"><strong>Registration Date:</strong> ${new Date(rider.registrationDate).toLocaleDateString()}</li>
                    </ul>
                </div>
                <div class="col-md-6 mt-4 mt-md-0">
                    <h5>Vehicle Details</h5>
                     <ul class="list-group list-group-flush">
                        <li class="list-group-item"><strong>Vehicle Type:</strong> <span class="badge ${getVehicleClass(rider.vehicleType)}">${rider.vehicleType || 'N/A'}</span></li>
                        <li class="list-group-item"><strong>Registration No:</strong> ${rider.vehicleRegistrationNumber || 'N/A'}</li>
                        <li class="list-group-item"><strong>Driving License:</strong> ${rider.drivingLicenseNumber || 'N/A'}</li>
                    </ul>
                    <h5 class="mt-4">Bank Details</h5>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item"><strong>Account Holder:</strong> ${rider.bankAccountHolderName || 'N/A'}</li>
                        <li class="list-group-item"><strong>Account No:</strong> ${rider.bankAccountNumber || 'N/A'}</li>
                        <li class="list-group-item"><strong>IFSC Code:</strong> ${rider.ifscCode || 'N/A'}</li>
                    </ul>
                </div>
            </div>`;
        $('#personal').html(personalHtml);
    }

    function renderDocumentsTab(rider) {
        const docHtml = `
            <h5>Uploaded Documents</h5>
            <p class="text-muted">Click on an image to view the full version.</p>
            <div class="row text-center g-3">
                ${createDocumentItem('Aadhaar Front', rider.aadhaarFrontPhotoUrl)}
                ${createDocumentItem('Aadhaar Back', rider.aadhaarBackPhotoUrl)}
                ${createDocumentItem('PAN Card', rider.panPhotoUrl)}
                ${createDocumentItem('Driving License', rider.drivingLicensePhotoUrl)}
                ${createDocumentItem('Vehicle Photo', rider.vehiclePhotoUrl)}
            </div>`;
        $('#documents').html(docHtml);
    }

    function createDocumentItem(title, url) {
        if (!url) return '';
        return `<div class="col-lg-3 col-md-4 col-6">
                    <h6>${title}</h6>
                    <a href="${url}" target="_blank" title="View full image">
                        <img src="${url}" class="img-thumbnail" alt="${title}" style="height: 120px; object-fit: cover; width: 100%;">
                    </a>
                </div>`;
    }

    function renderEarningsTab(data) {
        const ctx = document.getElementById('weeklyEarningsChart').getContext('2d');
        if (window.weeklyChart instanceof Chart) {
            window.weeklyChart.destroy();
        }
        window.weeklyChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: data.chartData.map(d => d.label),
                datasets: [{ label: 'Weekly Earnings (INR)', data: data.chartData.map(d => d.value), backgroundColor: 'rgba(54, 162, 235, 0.7)', borderWidth: 1 }]
            },
            options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero: true } } }
        });
    }

    // ===================================================================
    // HELPER & UTILITY FUNCTIONS
    // ===================================================================
    function updateRiderStatus(url, method, successMessage) {
        $.ajax({
            url: url,
            method: method,
            beforeSend: () => $('#approveBtn, #rejectBtn').prop('disabled', true),
            success: function () {
                showToast(successMessage);
                loadCoreRiderDetails();
            },
            error: xhr => showError('Error updating status: ' + getErrorMessage(xhr)),
            complete: () => $('#approveBtn, #rejectBtn').prop('disabled', false)
        });
    }

    function determineRiderStatus(rider) {
        if (rider.approved === null) return { text: 'Pending', class: 'bg-warning text-dark' };
        if (rider.approved === false) return { text: 'Rejected', class: 'bg-danger' };
        if (rider.approved === true) return { text: 'Active', class: 'bg-success' };
        return { text: 'UNKNOWN', class: 'bg-dark' };
    }

    function getVehicleClass(vehicleType) {
        const v = (vehicleType || '').toUpperCase();
        return { 'ELECTRIC': 'bg-info text-dark', 'PETROL': 'bg-warning text-dark' }[v] || 'bg-secondary';
    }

    function formatCurrency(amount) {
        return new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR' }).format(amount || 0);
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