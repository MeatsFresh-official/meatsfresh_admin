/**
 * @file This script manages the "Edit Order Charges" page using jQuery.
 * @description It handles fetching initial order details, dynamically adjusting charge fields,
 *              adding/removing custom fees, and submitting the updated charges to the server via API.
 * @author Your Name/Team
 * @version 1.1
 */

// ===================================================================================
// CONFIGURATION
// ===================================================================================

/**
 * @const {object} API_CONFIG
 * @description Centralized configuration for all API requests. Storing this here makes it
 *              easy to update the base URL or endpoints in one place.
 */
const API_CONFIG = {
    baseUrl: 'http://meatsfresh.org.in:8082',
    endpoints: {
        updateCharges: '/api/fee-config',
        getOrder: '/orders' // Note: Order ID will be appended to this.
    }
};

// ===================================================================================
// INITIALIZATION & LIFECYCLE
// ===================================================================================

/**
 * @description The main entry point for the script, using jQuery's document ready handler.
 *              This function ensures that the DOM is fully loaded and ready for manipulation
 *              before any of our code runs. It's the equivalent of the vanilla JavaScript
 *              `document.addEventListener('DOMContentLoaded', ...)` event.
 */
$(document).ready(function() {
    // Sequentially initialize all interactive components on the page.
    initChargeToggles();
    initCustomFees();
    initFormSubmission();
    initTooltips();

    // Fetch initial data needed for the page.
    // Note: This assumes a global `orderId` variable is available, likely set by the server-side template.
    fetchOrderDetails();
});

// ===================================================================================
// UI INITIALIZATION FUNCTIONS
// ===================================================================================

/**
 * @description Initializes the show/hide functionality for charge input groups based on their associated toggle switches.
 */
function initChargeToggles() {
    // Attaches a 'change' event listener to all elements with the class 'charge-toggle'.
    $('.charge-toggle').change(function() {
        // `this` refers to the checkbox that was changed.
        // We construct the ID of the target container (e.g., 'toggleDeliveryFee' -> 'deliveryFeeGroup').
        const targetId = $(this).attr('id').replace('toggle', '') + 'Group';
        const $targetGroup = $('#' + targetId); // The jQuery object for the target container.

        if ($(this).is(':checked')) {
            // If the toggle is checked, remove the 'd-none' (display: none) class to show the inputs.
            $targetGroup.removeClass('d-none');
            const input = $targetGroup.find('input');
            // Pre-fill with '0.00' if it's empty, for better UX.
            if (!input.val() || input.val() === '0') {
                input.val('0.00');
            }
        } else {
            // If unchecked, hide the inputs and clear their value to avoid submitting unwanted data.
            $targetGroup.addClass('d-none');
            $targetGroup.find('input').val('');
        }
    });

    // IMPORTANT: Programmatically trigger the 'change' event on page load.
    // This ensures the UI reflects the initial state of the checkboxes (e.g., if a box is already checked when the page loads).
    $('.charge-toggle').trigger('change');
}

/**
 * @description Initializes the functionality for adding and removing custom fee input fields dynamically.
 */
function initCustomFees() {
    // Add a new custom fee entry when the 'add' button is clicked.
    $('#addCustomFee').click(function() {
        // Use a template literal to define the HTML for a new fee entry.
        // Note: This assumes a global `currencySymbol` variable is available.
        const newEntry = `
            <div class="input-group mb-2 custom-fee-entry">
                <input type="text" class="form-control" name="customFeeNames" placeholder="Fee name" required>
                <span class="input-group-text">${currencySymbol}</span>
                <input type="number" class="form-control" name="customFeeValues" step="0.01" min="0" required>
                <button type="button" class="btn btn-danger remove-custom-fee">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        `;
        // Append the new HTML to the container.
        $('#customFeesContainer').append(newEntry);
    });

    // Handle removal of a custom fee entry.
    // IMPORTANT: This uses EVENT DELEGATION. The click listener is attached to the static `document`
    // and listens for clicks on elements that match '.remove-custom-fee'. This is necessary
    // because the remove buttons are added dynamically and don't exist when the page first loads.
    $(document).on('click', '.remove-custom-fee', function() {
        // `this` is the clicked remove button.
        // `.closest('.custom-fee-entry')` traverses up the DOM tree to find the nearest parent
        // with that class and removes the entire input group.
        $(this).closest('.custom-fee-entry').remove();
    });
}

/**
 * @description Initializes the main form submission logic, including validation and API communication.
 */
function initFormSubmission() {
    // Attach a 'submit' event listener to the form.
    $('#chargesForm').on('submit', function(e) {
        // 1. Prevent the default browser action of a full-page reload on form submission.
        e.preventDefault();

        // 2. Perform basic client-side validation.
        if (!validateForm()) {
            showAlert('Please fill all visible required fields.', 'danger');
            return; // Stop the submission process if validation fails.
        }

        // 3. Prepare form data for the API.
        // `FormData` is a standard browser API that makes it easy to construct a set of
        // key/value pairs representing form fields and their values.
        //const formData = new FormData(this);

        // 4. Provide user feedback by showing a loading state on the submit button.
        const $submitBtn = $(this).find('button[type="submit"]');
        const originalText = $submitBtn.html();
        $submitBtn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Updating...');

        // 5. Make the API call to update the charges.
        updateOrderChargesJSON()
            .then(data => {
                // Handle a successful API response.
                if (data.success) {
                    showAlert('Charges updated successfully!', 'success');
                    // Reload the page after a short delay to ensure the user sees the success message
                    // and the server has time to process everything.
                    setTimeout(() => location.reload(), 1500);
                } else {
                    // If the API returns success: false, treat it as an error.
                    throw new Error(data.message || 'Failed to update charges');
                }
            })
            .catch(error => {
                // Handle network errors or errors thrown from the .then() block.
                console.error('Submission Error:', error);
                showAlert(error.message || 'An error occurred while updating charges.', 'danger');
            })
            .finally(() => {
                // 6. The `.finally()` block runs regardless of success or failure.
                // It's the perfect place to restore the button to its original state.
                $submitBtn.prop('disabled', false).html(originalText);
            });
    });
}

/**
 * @description Activates Bootstrap tooltips for any elements with the `data-bs-toggle="tooltip"` attribute.
 */
function initTooltips() {
    $('[data-bs-toggle="tooltip"]').tooltip();
}

// ===================================================================================
// API SERVICE LAYER / DATA FETCHING
// ===================================================================================

/**
 * @async
 * @description Sends the updated charges data to the server.
 * @param {FormData} formData - The FormData object containing all form values.
 * @returns {Promise<object>} A promise that resolves to the JSON response from the server.
 */
function updateOrderChargesJSON() {

    const body = {
        baseDeliveryFee: Number($('input[name="baseDeliveryFee"]').val() || 0),
        deliveryFeePerKm: Number($('input[name="deliveryFeePerKm"]').val() || 0),

        deliveryFeeEnabled: $('#toggleBaseDeliveryFee').is(':checked'),

        platformFeeRate: Number($('input[name="platformFeeRate"]').val() || 0),
        platformFeeEnabled: $('#togglePlatformFee').is(':checked'),

        rainFee: Number($('input[name="rainFee"]').val() || 0),
        rainFeeEnabled: $('#toggleRainFee').is(':checked'),

        packagingCharge: Number($('input[name="packagingCharge"]').val() || 0),
        packagingChargeEnabled: $('#togglePackagingCharge').is(':checked'),

        serviceCharge: Number($('input[name="serviceCharge"]').val() || 0),
        serviceChargeEnabled: $('#toggleServiceCharge').is(':checked'),

        gstRate: Number($('input[name="gstRate"]').val() || 0),
        gstRateEnabled: $('#toggleGstRate').is(':checked'),

        customFees: collectCustomFees()
    };

    function collectCustomFees() {
        const fees = [];

        $('.custom-fee-entry').each(function () {
            const name = $(this).find('input[name="customFeeNames"]').val();
            const value = Number($(this).find('input[name="customFeeValues"]').val() || 0);

            if (name && value > 0) {
                fees.push({
                    name: name,
                    value: value
                });
            }
        });

        return fees;
    }


    console.log("Sending JSON:", body);

    return fetch("http://meatsfresh.org.in:8082/api/fee-config", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(body)
    })
    .then(res => {
        if (!res.ok) throw new Error("API failed");
        return res.json();
    });
}

/**
 * @async
 * @description Fetches the initial order details to populate the page.
 * @description NOTE: The current implementation only logs the data. This function should be
 *              expanded to populate form fields with the fetched data.
 */
function fetchOrderDetails() {
    // `orderId` is assumed to be a global variable set by the server.
    const url = `${API_CONFIG.baseUrl}${API_CONFIG.endpoints.getOrder}/${orderId}`;

    fetch(url)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // TODO: Implement UI updates with the fetched data.
                // For example: $('#deliveryFeeInput').val(data.order.deliveryFee);
                console.log('Order data received:', data.order);
            } else {
                 showAlert('Could not load initial order details.', 'warning');
            }
        })
        .catch(error => {
            console.error('Error fetching order details:', error);
            showAlert('An error occurred while loading order details.', 'danger');
        });
}

// ===================================================================================
// UTILITY FUNCTIONS
// ===================================================================================

/**
 * @description Validates all visible required input fields in the form.
 * @returns {boolean} `true` if the form is valid, otherwise `false`.
 */
function validateForm() {
    let isValid = true;

    // Select all inputs that have the 'required' attribute.
    $('input[required]').each(function() {
        // We only validate inputs that are visible. This prevents validation errors on
        // fields hidden by the charge toggles.
        if ($(this).is(':visible') && !$(this).val()) {
            $(this).addClass('is-invalid'); // Add Bootstrap's error class.
            isValid = false;
        } else {
            $(this).removeClass('is-invalid'); // Remove error class if valid.
        }
    });

    return isValid;
}

/**
 * @description Displays a dismissible alert message at the top of the main content area.
 * @param {string} message - The message to display in the alert.
 * @param {'success'|'danger'|'warning'|'info'} type - The type of alert, which determines its color and icon.
 */
function showAlert(message, type) {
    // Ensure only one alert is visible at a time by removing any existing ones.
    $('.alert-dismissible').remove();

    const alertClass = `alert-${type}`;
    const icon = type === 'success' ? 'fa-check-circle' :
                 type === 'danger' ? 'fa-exclamation-circle' :
                 type === 'warning' ? 'fa-exclamation-triangle' : 'fa-info-circle';

    const alertHtml = `
        <div class="alert ${alertClass} alert-dismissible fade show" role="alert">
            <i class="fas ${icon} me-2"></i>
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    `;

    // Prepend the alert to the main content area so it appears at the top.
    $('.main-content').prepend(alertHtml);

    // Automatically close the alert after 5 seconds for a better user experience.
    setTimeout(() => {
        // Use Bootstrap's JavaScript API to gracefully close the alert.
        $('.alert-dismissible').alert('close');
    }, 5000);
}