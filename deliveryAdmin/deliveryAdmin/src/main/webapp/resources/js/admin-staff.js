document.addEventListener('DOMContentLoaded', function () {

    // --- Tooltips ---
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl)
    });

    // --- Role Selection Logic ---
    const staffRoleSelect = document.getElementById('staffRole');
    if (staffRoleSelect) {
        staffRoleSelect.addEventListener('change', updateAccessOptions);
    }

    // --- Filter Logic ---
    const filterLinks = document.querySelectorAll('[data-filter]');
    filterLinks.forEach(link => {
        link.addEventListener('click', function (e) {
            e.preventDefault();
            const filterValue = this.getAttribute('data-filter');
            filterTable(filterValue);

            // Update button text
            const btn = this.closest('.dropdown').querySelector('.dropdown-toggle');
            btn.innerHTML = `<i class="fas fa-filter me-1"></i> ${this.textContent}`;
        });
    });

    // --- Password Toggle ---
    const togglePasswordBtn = document.getElementById('togglePassword');
    if (togglePasswordBtn) {
        togglePasswordBtn.addEventListener('click', function () {
            const input = document.getElementById('passwordField');
            const icon = this.querySelector('i');
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });
    }

});

// --- Functions ---

function filterTable(role) {
    const rows = document.querySelectorAll('#staffTable tbody tr');
    rows.forEach(row => {
        const roleCell = row.querySelector('td:nth-child(2) .badge-zenith'); // Assuming 2nd column has badge
        if (!roleCell) return;

        const rowRole = roleCell.textContent.trim();

        if (role === 'all' || rowRole === role || rowRole.includes(role)) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}

function updateAccessOptions() {
    const role = document.getElementById('staffRole').value;
    const accessCheckboxes = document.querySelectorAll('.page-access');

    // Reset all
    accessCheckboxes.forEach(cb => {
        if (cb.id !== 'dashboardAccess') cb.checked = false;
    });

    // Auto-select based on role
    // Note: These IDs must match the JSP checkboxes
    let idsToSelect = [];

    switch (role) {
        case 'ADMIN':
            idsToSelect = ['userManagementAccess', 'vendorManagementAccess', 'deliverySystemAccess', 'systemSettingsAccess', 'reportsAccess', 'perm_DELIVERY_INCENTIVES'];
            break;
        case 'SUB_ADMIN':
            idsToSelect = ['userManagementAccess', 'vendorManagementAccess', 'deliverySystemAccess', 'reportsAccess', 'perm_DELIVERY_INCENTIVES'];
            break;
        case 'MANAGER':
            idsToSelect = ['userManagementAccess', 'vendorManagementAccess', 'reportsAccess'];
            break;
        case 'RIDER':
            idsToSelect = ['deliverySystemAccess'];
            break;
        case 'SUPPORT':
            idsToSelect = ['userManagementAccess'];
            break;
    }

    idsToSelect.forEach(id => {
        const cb = document.getElementById(id);
        if (cb) {
            cb.checked = true;
            // Trigger change event if needed for dependencies
            cb.dispatchEvent(new Event('change'));
        }
    });
}


// Setup Confirm Delete
window.confirmDelete = function (staffId) {
    const modal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
    document.getElementById('deleteStaffId').value = staffId;
    modal.show();
};

window.deleteStaff = function () {
    const staffId = document.getElementById('deleteStaffId').value;
    // Perform delete action (e.g., submit form or AJAX)
    window.location.href = `deleteStaff?id=${staffId}`;
};

// --- Permissions Modal Logic ---
window.openPermissionsModal = function (staffId) {
    const row = document.querySelector(`tr[data-staff-id="${staffId}"]`);
    if (!row) return;

    const accessPagesStr = row.getAttribute('data-access-pages') || '';
    const accessPages = accessPagesStr.split(',');

    document.getElementById('permStaffId').value = staffId;

    // Reset all checkboxes
    document.querySelectorAll('.perm-check').forEach(cb => {
        if (cb.value === 'DASHBOARD') {
            cb.checked = true; // Always checked
        } else {
            cb.checked = false;
        }
    });

    // Check allowed pages
    accessPages.forEach(page => {
        const checkbox = document.querySelector(`.perm-check[value="${page}"]`);
        if (checkbox) checkbox.checked = true;
    });

    const modal = new bootstrap.Modal(document.getElementById('permissionsModal'));
    modal.show();
};

window.savePermissions = function () {
    const staffId = document.getElementById('permStaffId').value;
    const selectedPages = [];

    document.querySelectorAll('.perm-check:checked').forEach(cb => {
        selectedPages.push(cb.value);
    });

    // Add CSRF token
    const token = document.querySelector("meta[name='_csrf']").getAttribute("content");
    const header = document.querySelector("meta[name='_csrf_header']").getAttribute("content");

    // Show loading state
    const btn = document.querySelector('#permissionsModal .btn-zenith-primary');
    const originalText = btn.innerHTML;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
    btn.disabled = true;

    $.ajax({
        url: `${pageContext.request.contextPath}/admin-staff/update-access-pages`,
        type: 'POST',
        traditional: true, // Important for sending array of strings
        beforeSend: function (xhr) {
            xhr.setRequestHeader(header, token);
        },
        data: {
            staffId: staffId,
            accessPages: selectedPages
        },
        success: function (response) {
            // Reload page to reflect changes (simplest approach)
            window.location.href = `${pageContext.request.contextPath}/admin-staff?success=Permissions updated successfully`;
        },
        error: function (xhr) {
            alert('Error updating permissions: ' + (xhr.responseJSON ? xhr.responseJSON.message : xhr.statusText));
            btn.innerHTML = originalText;
            btn.disabled = false;
        }
    });
};