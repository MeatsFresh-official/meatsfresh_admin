$(document).ready(function() {
    // ===================================================================
    // API ENDPOINTS
    // ===================================================================
    const API_BASE = 'http://113.11.231.115:8080/api';
    const RIDERS_API = API_BASE + '/delivery/register';
    const RIDERS_LIST_API = API_BASE + '/delivery';
    const SETTINGS_API = API_BASE + '/delivery/settings';
    const SHOP_API = API_BASE + '/delivery/shop';
    const REPORTS_API = API_BASE + '/delivery/reports';

    const LOCATION_API = {
        countries: API_BASE + '/address/countries',
        states: API_BASE + '/address/states',
        cities: API_BASE + '/address/cities',
        districts: API_BASE + '/address/districts'
    };

    // ===================================================================
    // GLOBAL AJAX SETUP FOR BASIC AUTHENTICATION
    // ===================================================================
    // This will add the Authorization header to EVERY jQuery AJAX request
    const username = 'user';
    const password = 'user';
    $.ajaxSetup({
        beforeSend: function(xhr) {
            const authHeader = 'Basic ' + btoa(username + ':' + password);
            xhr.setRequestHeader('Authorization', authHeader);
        }
    });

    // ===================================================================
    // INITIALIZATION
    // ===================================================================
    let itemToDelete = null;
    let deleteType = null;
    let performanceChart, statusChart;

    initApplication();

    function initApplication() {
        if ($('#performanceChart').length && typeof Chart !== 'undefined') initCharts();
        initLocationDropdowns();
        loadRiders();
        loadShopItems();
        loadSettings();
        if ($('.time-range-option').length) $('.time-range-option[data-range="month"]').trigger('click');
        setupEventHandlers();
        testAPIConnection();
    }

    // ===================================================================
    // EVENT HANDLERS SETUP
    // ===================================================================
    function setupEventHandlers() {
        $('#deliveryBoyTabs button').on('shown.bs.tab', function() {
            if ($(this).attr('data-bs-target') === '#reports' && performanceChart) {
                performanceChart.resize();
                statusChart.resize();
            }
        });

        $('select[name="paymentMode"]').change(function() {
            $('#perKmRateContainer').toggle($(this).val() === 'PER_KM');
            $('#perOrderRateContainer').toggle($(this).val() !== 'PER_KM');
        }).trigger('change');

        $('#searchRiderBtn').click(applyFilters);
        $('#riderSearch').keypress(e => e.which === 13 && applyFilters());
        $('#statusFilter, #vehicleFilter, #ratingFilter').change(applyFilters);
        $('#resetFiltersBtn').click(resetFilters);

        $(document).on('click', '.delete-rider, .delete-shop-item', handleDeleteClick);
        $('#confirmDeleteBtn').click(confirmDelete);

        $('#addRiderForm').submit(handleAddRider);
        $('#addShopItemForm').submit(handleAddShopItem);
        $('#editShopItemForm').submit(handleEditShopItem);
        $('#paymentSettingsForm').submit(handlePaymentSettings);
        $('#incentiveSettingsForm').submit(handleIncentiveSettings);

        $('#applyDateRange').click(applyDateRange);
        $('.time-range-option').click(handleTimeRangeSelection);
        $('#exportReportsBtn').click(exportReports);

        $(document).on('click', '#activeFilters .fa-times', removeFilter);
        $('#shop').on('click', '.edit-shop-item', handleEditShopItemClick);

        $('.modal').on('hidden.bs.modal', function() {
            $(this).find('form')[0].reset();
            $(this).find('.is-invalid').removeClass('is-invalid');
            $(this).find('.invalid-feedback').addClass('d-none').text('');
        });
    }

    // ===================================================================
    // API CONNECTION TESTING
    // ===================================================================
    function testAPIConnection() {
        $.ajax({
            url: RIDERS_LIST_API,
            type: 'GET',
            timeout: 5000,
            success: () => console.log("API connection test: SUCCESS"),
            error: (xhr) => {
                console.error("API connection test: FAILED", xhr);
                showError('Cannot connect to the API server. Please check if the server is running.');
            }
        });
    }

    // ===================================================================
    // DATA LOADING FUNCTIONS
    // ===================================================================
    function loadRiders() {
        $('#ridersTable tbody').html('<tr><td colspan="7" class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading riders...</td></tr>');
        $.ajax({
            url: RIDERS_LIST_API,
            type: 'GET',
            success: function(riders) {
                let counts = { active: 0, rejected: 0, pending: 0 };
                riders.forEach(rider => {
                    if (rider.approved == null) {
                        counts.pending++;
                    } else if (rider.approved === false || rider.rejectionReason) {
                        counts.rejected++;
                    } else if (rider.approved === true) {
                        counts.active++;
                    }
                });

                updateStatCards(riders.length, counts);
                updateStatusChart(counts);
                renderRidersTable(riders);
            },
            error: function(xhr) {
                $('#ridersTable tbody').html(`<tr><td colspan="7" class="text-center text-danger">Error loading riders: ${getErrorMessage(xhr)}</td></tr>`);
                updateStatCards(0, { active: 0, rejected: 0, pending: 0 });
                updateStatusChart({ active: 0, rejected: 0, pending: 0 });
            }
        });
    }

    function loadShopItems() {
        $('#shop .row').html('<div class="col-12 text-center"><i class="fas fa-spinner fa-spin"></i> Loading products...</div>');
        $.get(SHOP_API, renderShopItems).fail(xhr => {
            $('#shop .row').html(`<div class="col-12 text-center text-danger">Error loading shop items: ${getErrorMessage(xhr)}</div>`);
        });
    }

    function loadSettings() {
        $.get(`${SETTINGS_API}/payment`, settings => {
            if (settings) {
                $('select[name="paymentMode"]').val(settings.paymentMode || 'PER_KM').trigger('change');
                $('input[name="perKmRate"]').val(settings.perKmRate || '15.00');
                $('input[name="perOrderRate"]').val(settings.perOrderRate || '30.00');
                $('input[name="registrationFee"]').val(settings.registrationFee || '500.00');
                $('input[name="cashDepositLimit"]').val(settings.cashDepositLimit || '5000.00');
                $('select[name="cashDepositFrequency"]').val(settings.cashDepositFrequency || 'DAILY');
            }
        }).fail(xhr => console.error("Error loading payment settings:", xhr));

        $.get(`${SETTINGS_API}/incentive`, settings => {
            if (settings) {
                $('input[name="monthlyTarget"]').val(settings.monthlyTarget || '100');
                $('input[name="targetBonus"]').val(settings.targetBonus || '2000.00');
                $('input[name="superBonus"]').val(settings.superBonus || '5000.00');
            }
        }).fail(xhr => console.error("Error loading incentive settings:", xhr));
    }

    function loadReports(startDate, endDate) {
            $.get(`${REPORTS_API}?startDate=${startDate}&endDate=${endDate}`, data => {
                updatePerformanceChart(data);
                renderIncentiveReports(data.incentiveReports);
            }).fail(xhr => showError('Error loading reports: ' + getErrorMessage(xhr)));
        }

    // ===================================================================
    // FORM HANDLING FUNCTIONS
    // ===================================================================
    function handleAddRider(e) {
        e.preventDefault();
        highlightErrors(null);

        if ($('#bankAccountNumber').val() !== $('input[name="confirmBankAccountNumber"]').val()) {
            $('input[name="confirmBankAccountNumber"]').addClass('is-invalid').next('.invalid-feedback').text('Bank account numbers do not match.').removeClass('d-none');
            showError("Bank account numbers do not match.");
            return;
        }

        if (!$('select[name="countryId"]').val() || !$('select[name="stateId"]').val() || !$('select[name="cityId"]').val() || !$('select[name="districtId"]').val()) {
            showError("Please select all location fields (Country, State, District, City).");
            return;
        }

        const formData = new FormData(this);
        const submitBtn = $('#addRiderSubmitBtn');

        $.ajax({
            url: RIDERS_API,
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            beforeSend: () => submitBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Adding...'),
            success: () => {
                showToast('Rider added successfully! Awaiting approval.');
                $('#addRiderModal').modal('hide');
                loadRiders();
            },
            error: (xhr) => handleAjaxError(xhr, 'An unexpected error occurred while adding the rider.'),
            complete: () => submitBtn.prop('disabled', false).html('Add Rider')
        });
    }

    function handleAddShopItem(e) {
        e.preventDefault();
        handleFormSubmit(this, SHOP_API, 'POST', 'Product added successfully!', loadShopItems);
    }

    function handleEditShopItem(e) {
        e.preventDefault();
        const url = `${SHOP_API}/${$('#editProductId').val()}`;
        handleFormSubmit(this, url, 'PUT', 'Product updated successfully!', loadShopItems);
    }

    function handlePaymentSettings(e) {
        e.preventDefault();
        saveSettings(this, `${SETTINGS_API}/payment`, 'Payment');
    }

    function handleIncentiveSettings(e) {
        e.preventDefault();
        saveSettings(this, `${SETTINGS_API}/incentive`, 'Incentive');
    }

    function handleFormSubmit(form, url, method, successMessage, callback) {
        const formData = new FormData(form);
        const btn = $(form).find('button[type="submit"]');

        $.ajax({
            url: url,
            type: method,
            data: formData,
            processData: false,
            contentType: false,
            beforeSend: () => btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Saving...'),
            success: () => {
                showToast(successMessage);
                $(form).closest('.modal').modal('hide');
                if (callback) callback();
            },
            error: (xhr) => showError('Error: ' + getErrorMessage(xhr)),
            complete: () => btn.prop('disabled', false).text(method === 'POST' ? 'Add Product' : 'Save Changes')
        });
    }

    function saveSettings(form, url, type) {
        const btn = $(form).find('button[type="submit"]');
        $.ajax({
            url: url,
            type: 'POST',
            data: $(form).serialize(),
            beforeSend: () => btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Saving...'),
            success: () => showToast(`${type} settings saved successfully!`),
            error: (xhr) => showError(`Error saving ${type} settings: ` + getErrorMessage(xhr)),
            complete: () => btn.prop('disabled', false).text('Save Settings')
        });
    }

    // ===================================================================
    // DELETE HANDLING FUNCTIONS
    // ===================================================================
    function handleDeleteClick() {
        const isRider = $(this).hasClass('delete-rider');
        itemToDelete = $(this).data(isRider ? 'rider-id' : 'product-id');
        deleteType = isRider ? 'rider' : 'product';
        $('#deleteConfirmationMessage').text(`Are you sure you want to delete this ${deleteType}? This action cannot be undone.`);
        $('#deleteConfirmationModal').modal('show');
    }

    function confirmDelete() {
        if (!itemToDelete || !deleteType) return;
        const btn = $(this);
        const url = deleteType === 'rider' ? `${RIDERS_LIST_API}/${itemToDelete}` : `${SHOP_API}/${itemToDelete}`;

        $.ajax({
            url: url,
            type: 'DELETE',
            beforeSend: () => btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Deleting...'),
            success: () => {
                showToast(`${deleteType.charAt(0).toUpperCase() + deleteType.slice(1)} deleted successfully!`);
                $('#deleteConfirmationModal').modal('hide');
                if (deleteType === 'rider') loadRiders(); else loadShopItems();
            },
            error: (xhr) => showError(`Error deleting ${deleteType}: ` + getErrorMessage(xhr)),
            complete: () => btn.prop('disabled', false).html('<i class="fas fa-trash me-2"></i>Delete')
        });
    }

    // ===================================================================
    // FILTER FUNCTIONS
    // ===================================================================
    function applyFilters() {
        const searchTerm = $('#riderSearch').val().toLowerCase().trim();
        const statusFilter = $('#statusFilter').val().toUpperCase();
        const vehicleFilter = $('#vehicleFilter').val().toUpperCase();
        const ratingFilter = parseInt($('#ratingFilter').val(), 10);

        updateActiveFiltersDisplay($('#statusFilter').val(), $('#vehicleFilter').val(), $('#ratingFilter').val());

        $('#ridersTable tbody tr').each(function() {
            const row = $(this);
            const rowText = row.text().toLowerCase();
            const rowStatus = (row.find('td:nth-child(2) .badge').text() || '').trim().toUpperCase();
            const rowVehicle = (row.find('td:nth-child(4) .badge').text() || '').trim().toUpperCase();
            const rowRating = row.find('.rating-container .fa-star.text-warning').length;

            const matchesSearch = searchTerm === '' || rowText.includes(searchTerm);
            const matchesStatus = statusFilter === '' || rowStatus === statusFilter;
            const matchesVehicle = vehicleFilter === '' || rowVehicle === vehicleFilter;
            const matchesRating = isNaN(ratingFilter) || ratingFilter === '' || rowRating >= ratingFilter;

            row.toggle(matchesSearch && matchesStatus && matchesVehicle && matchesRating);
        });
    }

    function resetFilters() {
        $('#riderSearch, #statusFilter, #vehicleFilter, #ratingFilter').val('');
        $('#activeFilters').empty();
        applyFilters();
    }

    function removeFilter() {
        $(`#${$(this).data('filter')}Filter`).val('').trigger('change');
    }

    function updateActiveFiltersDisplay(status, vehicle, rating) {
        const activeFilters = $('#activeFilters').empty();
        if (status) activeFilters.append(`<span class="badge bg-primary me-2 mb-1">Status: ${status} <i class="fas fa-times ms-1" data-filter="status" role="button"></i></span>`);
        if (vehicle) activeFilters.append(`<span class="badge bg-success me-2 mb-1">Vehicle: ${vehicle} <i class="fas fa-times ms-1" data-filter="vehicle" role="button"></i></span>`);
        if (rating) activeFilters.append(`<span class="badge bg-warning text-dark me-2 mb-1">Rating: ${rating}+ <i class="fas fa-times ms-1" data-filter="rating" role="button"></i></span>`);
    }

    // ===================================================================
    // REPORT FUNCTIONS
    // ===================================================================
    function applyDateRange() {
        const startDate = $('#startDate').val();
        const endDate = $('#endDate').val();
        if (!startDate || !endDate) return showError('Please select both a start and end date.');
        if (new Date(startDate) > new Date(endDate)) return showError('End date must be after start date.');
        $('#dateRangeDisplay').text(`${startDate} to ${endDate}`);
        $('#dateRangeModal').modal('hide');
        loadReports(startDate, endDate);
    }

    function handleTimeRangeSelection(e) {
        e.preventDefault();
        $('#selectedTimeRange').text($(this).text());
        const range = $(this).data('range');
        let startDate = new Date();
        const endDate = new Date();

        if (range === 'week') startDate.setDate(endDate.getDate() - 7);
        else if (range === 'month') startDate.setMonth(endDate.getMonth() - 1);

        loadReports(startDate.toISOString().split('T')[0], endDate.toISOString().split('T')[0]);
    }

    function exportReports() {
        const thirtyDaysAgo = new Date();
        thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
        const startDate = $('#startDate').val() || thirtyDaysAgo.toISOString().split('T')[0];
        const endDate = $('#endDate').val() || new Date().toISOString().split('T')[0];
        window.open(`${REPORTS_API}/export?startDate=${startDate}&endDate=${endDate}`, '_blank');
    }

    // ===================================================================
    // RENDERING FUNCTIONS
    // ===================================================================
    function renderRidersTable(riders) {
        const tbody = $('#ridersTable tbody').empty();
        if (!riders || riders.length === 0) {
            tbody.html('<tr><td colspan="7" class="text-center">No riders found.</td></tr>');
            return;
        }

        const riderPayoutSummaries = {};
        riders.forEach(rider => {
            $.ajax({
                url: `${API_BASE}/payouts/summary?deliveryPartnerId=${rider.id || rider.partnerId}`,
                type: 'GET',
                async: false,
                success: function(payoutSummary) {
                    riderPayoutSummaries[rider.id || rider.partnerId] = payoutSummary;
                },
                error: function(xhr) {
                    console.error('Error loading payout summary for rider', rider.id || rider.partnerId, xhr);
                    riderPayoutSummaries[rider.id || rider.partnerId] = null;
                }
            });
        });

        riders.sort((a, b) => (a.id || a.partnerId) - (b.id || b.partnerId));

        riders.forEach(rider => {
            const statusInfo = determineRiderStatus(rider);
            const riderId = rider.id || rider.partnerId;
            const payoutSummary = riderPayoutSummaries[riderId];
            const walletBalance = payoutSummary ? payoutSummary.availableBalance : 0;

            const row = `
                <tr data-rider-id="${riderId}">
                    <td>
                        <div class="d-flex align-items-center">
                            <img src="${rider.selfiePhotoUrl || 'resources/images/default-avatar.png'}" class="rounded-circle me-3" width="40" height="40" alt="${rider.firstName}" style="object-fit: cover;">
                            <div>
                                <h6 class="mb-0">${rider.firstName || ''} ${rider.lastName || ''}</h6>
                                <small class="text-muted">ID: ${riderId}</small>
                            </div>
                        </div>
                    </td>
                    <td><span class="badge ${statusInfo.class}">${statusInfo.text}</span></td>
                    <td>${rider.phoneNumber || 'N/A'}</td>
                    <td><span class="badge ${getVehicleClass(rider.vehicleType)}">${rider.vehicleType || 'N/A'}</span></td>
                    <td>${formatCurrency(walletBalance)}</td>
                    <td><div class="rating-container">${getRatingStars(rider.rating)}</div></td>
                    <td>
                        <div class="btn-group btn-group-sm" role="group">
                            <a href="deliveryBoy-view?id=${riderId}" class="btn btn-outline-primary" title="View Details"><i class="fas fa-eye"></i></a>
                            <a href="deliveryBoy-edit?id=${riderId}" class="btn btn-outline-secondary" title="Edit Profile"><i class="fas fa-edit"></i></a>
                            <a href="deliveryBoy-admin-actions?id=${riderId}" class="btn btn-outline-info" title="Admin Actions"><i class="fas fa-user-shield"></i></a>
                            <button class="btn btn-outline-danger delete-rider" data-rider-id="${riderId}" title="Delete Rider"><i class="fas fa-trash"></i></button>
                        </div>
                    </td>
                </tr>`;
            tbody.append(row);
        });
    }

    function renderShopItems(products) {
        const container = $('#shop .row').empty();
        if (!products || products.length === 0) {
            container.html('<div class="col-12 text-center">No products found.</div>');
            return;
        }
        products.forEach(product => {
            container.append(`
            <div class="col-xl-3 col-md-4 col-6 mb-4">
                <div class="card h-100 product-card">
                    <img src="${product.image}" class="card-img-top product-image" alt="${product.name}">
                    <div class="card-body">
                        <h5 class="card-title product-name">${product.name}</h5>
                        <p class="card-text product-description">${product.description || ''}</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <h6 class="mb-0 product-price">${formatCurrency(product.price)}</h6>
                            <span class="stock-indicator ${product.stock > 0 ? 'stock-in' : 'stock-out'}">${product.stock > 0 ? 'In Stock' : 'Out of Stock'}</span>
                        </div>
                    </div>
                    <div class="card-footer bg-transparent">
                        <div class="btn-group w-100" role="group">
                            <button class="btn btn-sm btn-outline-primary edit-shop-item" data-product-id="${product.id}"><i class="fas fa-edit"></i></button>
                            <button class="btn btn-sm btn-outline-danger delete-shop-item" data-product-id="${product.id}"><i class="fas fa-trash"></i></button>
                        </div>
                    </div>
                </div>
            </div>`);
        });
    }

    function renderIncentiveReports(reports) {
        const tbody = $('#reports .table tbody').empty();
        if (!reports || reports.length === 0) {
            tbody.html('<tr><td colspan="5" class="text-center">No incentive data available for the selected period.</td></tr>');
            return;
        }
        reports.forEach(report => {
            const completion = report.completion || 0;
            tbody.append(`
            <tr>
                <td>${report.riderName}</td>
                <td>${report.deliveries}</td>
                <td>${report.target}</td>
                <td>
                    <div class="progress" role="progressbar" aria-valuenow="${completion}" aria-valuemin="0" aria-valuemax="100">
                        <div class="progress-bar bg-${completion >= 100 ? 'success' : 'warning'}" style="width: ${completion}%"></div>
                    </div>
                    <small class="text-muted">${completion.toFixed(1)}%</small>
                </td>
                <td>${formatCurrency(report.bonus)}</td>
            </tr>`);
        });
    }

    function updateStatCards(total, counts) {
        $('.card.bg-primary h3').text(total);
        $('.card.bg-warning h3').text(counts.pending);
        $('.card.bg-success h3').text(counts.active);
        $('.card.bg-danger h3').text(counts.rejected);
    }

    // ===================================================================
    // LOCATION DROPDOWN FUNCTIONS
    // ===================================================================
    function initLocationDropdowns() {
        loadCountries();
        $('select[name="countryId"]').change(loadStates);
        $('select[name="stateId"]').change(loadDistricts);
        $('select[name="districtId"]').change(loadCities);
    }

    function populateDropdown(dropdown, data, valueField, nameField, defaultOption) {
        dropdown.empty().append(`<option value="">${defaultOption}</option>`);
        data.forEach(item => dropdown.append(`<option value="${item[valueField]}">${item[nameField]}</option>`));
        dropdown.prop('disabled', false);
    }

    function loadCountries() {
        $.get(LOCATION_API.countries, countries => {
            const dropdown = $('select[name="countryId"]');
            populateDropdown(dropdown, countries, 'countryId', 'countryName', 'Select Country');
            const india = countries.find(c => c.countryName.toLowerCase() === 'india');
            if (india) dropdown.val(india.countryId).trigger('change');
        }).fail(xhr => handleLocationError('countries', xhr));
    }

    function loadStates() {
        resetDependentDropdowns('state');
        const countryId = $(this).val();
        if (!countryId) return;
        const dropdown = $('select[name="stateId"]').prop('disabled', true).html('<option value="">Loading...</option>');
        $.get(`${LOCATION_API.states}?countryId=${countryId}`, states => populateDropdown(dropdown, states, 'stateId', 'stateName', 'Select State'))
         .fail(xhr => handleLocationError('states', xhr));
    }

    function loadDistricts() {
        resetDependentDropdowns('district');
        const stateId = $(this).val();
        if (!stateId) return;
        const dropdown = $('select[name="districtId"]').prop('disabled', true).html('<option value="">Loading...</option>');
        $.get(`${LOCATION_API.districts}?stateId=${stateId}`, districts => populateDropdown(dropdown, districts, 'districtId', 'districtName', 'Select District'))
         .fail(xhr => handleLocationError('districts', xhr));
    }

    function loadCities() {
        resetDependentDropdowns('city');
        const districtId = $(this).val();
        if (!districtId) return;
        const dropdown = $('select[name="cityId"]').prop('disabled', true).html('<option value="">Loading...</option>');
        $.get(`${LOCATION_API.cities}?districtId=${districtId}`, cities => populateDropdown(dropdown, cities, 'cityId', 'cityName', 'Select City'))
         .fail(xhr => handleLocationError('cities', xhr));
    }

    function resetDependentDropdowns(level) {
        const levels = { state: ['stateId', 'districtId', 'cityId'], district: ['districtId', 'cityId'], city: ['cityId'] };
        if (levels[level]) {
            levels[level].forEach(fieldName => {
                $(`select[name="${fieldName}"]`).prop('disabled', true).html(`<option value="">Select ${fieldName.replace('Id', '')}</option>`);
            });
        }
    }

    function handleLocationError(level, xhr) {
        showError(`Failed to load ${level}.`);
        console.error(`Error loading ${level}:`, xhr);
    }

    // ===================================================================
    // CHART FUNCTIONS
    // ===================================================================
    function initCharts() {
        const commonOptions = { responsive: true, maintainAspectRatio: false };
        performanceChart = new Chart($('#performanceChart'), {
            type: 'bar',
            data: { labels: [], datasets: [{ label: 'Deliveries', data: [], backgroundColor: 'rgba(54, 162, 235, 0.7)' }] },
            options: { ...commonOptions, scales: { y: { beginAtZero: true } } }
        });
        statusChart = new Chart($('#statusChart'), {
            type: 'doughnut',
            data: {
                labels: ['Active', 'Pending', 'Rejected'],
                datasets: [{
                    data: [0, 0, 0],
                    backgroundColor: ['#28a745', '#ffc107', '#dc3545']
                }]
            },
            options: commonOptions
        });
    }

    function updateStatusChart(counts) {
        if (!statusChart) return;
        statusChart.data.datasets[0].data = [
            counts.active,
            counts.pending,
            counts.rejected
        ];
        statusChart.update();
    }

    function updatePerformanceChart(data) {
        if (!performanceChart || !data || !data.performance) return;
        performanceChart.data.labels = data.performance.map(item => item.month);
        performanceChart.data.datasets[0].data = data.performance.map(item => item.deliveries);
        performanceChart.update();
    }

    // ===================================================================
    // UTILITY FUNCTIONS
    // ===================================================================
    function determineRiderStatus(rider) {
        if (rider.approved == null) return { text: 'Inactive', class: 'bg-warning text-dark' };
        if (rider.approved === false || rider.rejectionReason) return { text: 'Rejected', class: 'bg-danger' };
        if (rider.approved === true) return { text: 'Active', class: 'bg-success' };
        return { text: 'UNKNOWN', class: 'bg-secondary' };
    }

    function formatCurrency(amount) {
        return new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR' }).format(amount || 0);
    }

    function getVehicleClass(vehicleType) {
        const v = (vehicleType || '').toUpperCase();
        return { 'ELECTRIC': 'bg-info text-dark', 'PETROL': 'bg-warning text-dark' }[v] || 'bg-secondary';
    }

    function getRatingStars(rating) {
        let stars = '';
        const solidStars = Math.round(rating || 0);
        for (let i = 1; i <= 5; i++) {
            stars += `<i class="fas fa-star ${i <= solidStars ? 'text-warning' : 'text-muted opacity-50'}"></i>`;
        }
        return stars;
    }

    function showToast(message) {
        $('#toastMessage').text(message);
        new bootstrap.Toast($('#successToast')).show();
    }

    function showError(message) {
        $('#errorMessage').text(message);
        new bootstrap.Toast($('#errorToast')).show();
    }

    function getErrorMessage(xhr) {
        if (xhr.responseJSON && xhr.responseJSON.message) return xhr.responseJSON.message;
        if (xhr.responseText) {
            try {
                const response = JSON.parse(xhr.responseText);
                if (response.message) return response.message;
            } catch (e) {
                if (xhr.responseText.length < 150) return xhr.responseText;
            }
        }
        if (xhr.status === 0) return "Network error - Could not connect to the server";
        return xhr.statusText || "An unknown error occurred";
    }

    function handleAjaxError(xhr, defaultMessage) {
        console.error("AJAX Error:", xhr);
        if (xhr.responseJSON && xhr.responseJSON.errors) {
            highlightErrors(xhr.responseJSON.errors);
            showError("Please check the form for errors and try again.");
        } else {
            showError(getErrorMessage(xhr) || defaultMessage);
        }
    }

    function highlightErrors(errors) {
        $('.is-invalid').removeClass('is-invalid');
        $('.invalid-feedback').addClass('d-none');
        if (errors) {
            errors.forEach(error => {
                const field = $(`[name="${error.field}"]`);
                if (field.length) {
                    field.addClass('is-invalid').next('.invalid-feedback').text(error.defaultMessage || 'Invalid input.').removeClass('d-none');
                }
            });
        }
    }

    function handleEditShopItemClick() {
        const card = $(this).closest('.card');
        const productId = $(this).data('product-id');
        $('#editProductId').val(productId);
        $('#editProductName').val(card.find('.product-name').text());
        $('#editProductDescription').val(card.find('.product-description').text());
        const price = parseFloat(card.find('.product-price').text().replace(/[^0-9.]/g, ''));
        $('#editProductPrice').val(price.toFixed(2));
        const imageSrc = card.find('.product-image').attr('src');
        $('#editProductImageName').text(imageSrc.split('/').pop());
        $('#editShopItemModal').modal('show');
    }
});