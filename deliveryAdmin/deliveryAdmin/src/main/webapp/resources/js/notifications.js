
/**
 * Notifications Management Logic
 * Handles FCM notification sending for Users, Vendors, and Partners
 */

$(document).ready(function () {
    // Current date display
    const dateOptions = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
    $('#currentDate').text(new Date().toLocaleDateString('en-US', dateOptions));

    // Handle form submissions
    setupNotificationForm('userForm', 'userTitle', 'userBody', 'User');
    setupNotificationForm('vendorForm', 'vendorTitle', 'vendorBody', 'Vendor');
    setupNotificationForm('partnerForm', 'partnerTitle', 'partnerBody', 'Partner');
});

/**
 * Setup form submission handler for a specific notification type
 */
function setupNotificationForm(formId, titleId, bodyId, type) {
    $('#' + formId).on('submit', function (e) {
        e.preventDefault();

        const title = $('#' + titleId).val().trim();
        const body = $('#' + bodyId).val().trim();

        if (!title || !body) {
            showToast('error', 'Please fill in both title and body for the notification.');
            return;
        }

        // Simulate API call/processing
        const btn = $(this).find('button[type="submit"]');
        const originalText = btn.html();

        btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Sending...');

        // Simulate network delay
        setTimeout(function () {
            console.log(`Sending ${type} Notification:`, { title, body });

            // Success simulation
            showToast('success', `${type} notification sent successfully!`);

            // Reset form
            $('#' + formId)[0].reset();

            // Restore button
            btn.prop('disabled', false).html(originalText);
        }, 1500);
    });
}

/**
 * Show Toast Notification
 * @param {string} type - 'success' or 'error'
 * @param {string} message - Message to display
 */
function showToast(type, message) {
    const toastId = type === 'success' ? 'successToast' : 'errorToast';
    const msgId = type === 'success' ? 'toastMessage' : 'errorMessage';

    $('#' + msgId).text(message);
    const toastEl = document.getElementById(toastId);
    const toast = new bootstrap.Toast(toastEl);
    toast.show();
}