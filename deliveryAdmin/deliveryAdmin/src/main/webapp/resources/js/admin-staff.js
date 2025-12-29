// Handle form submission
// Handle form submission with AJAX
document.getElementById('addStaffForm').addEventListener('submit', function(e) {
    e.preventDefault();

    const formData = new FormData(this);
    const toast = new bootstrap.Toast(document.getElementById('successToast'));
    const modal = bootstrap.Modal.getInstance(document.getElementById('addStaffModal'));

    fetch(`${pageContext.request.contextPath}/admin-staff/add`, {
        method: 'POST',
        body: formData,
        headers: {
            'X-CSRF-TOKEN': document.getElementById('csrfToken').value
        }
    })
    .then(response => {
        if (response.redirected) {
            window.location.href = response.url;
        } else {
            return response.text();
        }
    })
    .then(() => {
        // This will only execute if not redirected
        document.getElementById('toastMessage').textContent = 'Staff added successfully';
        toast.show();
        modal.hide();
        // Reset form
        this.reset();
        // Refresh the page after a short delay
        setTimeout(() => window.location.reload(), 1500);
    })
    .catch(error => {
        document.getElementById('toastMessage').textContent = 'Error: ' + error.message;
        toast.show();
    });
});

// Close modal when clicking outside or pressing ESC
document.getElementById('addStaffModal').addEventListener('hidden.bs.modal', function () {
    // Reset form when modal is closed
    document.getElementById('addStaffForm').reset();
    // Reset any role-specific access options
    updateAccessOptions();
});

function refreshStaffTable() {
    fetch(`${pageContext.request.contextPath}/admin-staff/list`, {
        headers: {
            'Accept': 'text/html'
        }
    })
    .then(response => response.text())
    .then(html => {
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, 'text/html');
        const newTable = doc.getElementById('staffTable');
        document.getElementById('staffTable').innerHTML = newTable.innerHTML;
    });
}
// Toggle password visibility
document.getElementById('togglePassword').addEventListener('click', function() {
    const passwordField = document.getElementById('passwordField');
    const icon = this.querySelector('i');

    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        icon.classList.remove('fa-eye');
        icon.classList.add('fa-eye-slash');
    } else {
        passwordField.type = 'password';
        icon.classList.remove('fa-eye-slash');
        icon.classList.add('fa-eye');
    }
});

// Filter staff by role
document.querySelectorAll('[data-filter]').forEach(item => {
    item.addEventListener('click', function(e) {
        e.preventDefault();
        const filter = this.getAttribute('data-filter');

        document.querySelectorAll('#staffTable tbody tr').forEach(row => {
            if (filter === 'all') {
                row.style.display = '';
            } else {
                const role = row.querySelector('td:nth-child(2) div').textContent.trim().replace(' ', '_');
                row.style.display = role === filter ? '' : 'none';
            }
        });
    });
});

function confirmDelete(staffId, staffName = 'this staff member') {
    console.log('Staff ID to delete:', staffId);

    // Set the staff ID in the hidden field
    document.getElementById('deleteStaffId').value = staffId;

    // Update confirmation message with staff name if provided
    const confirmationMessage = document.getElementById('confirmationMessage');
    if (confirmationMessage && staffName) {
        confirmationMessage.textContent = `Are you sure you want to delete ${staffName}? This action cannot be undone.`;
    }

    // Show the modal
    new bootstrap.Modal(document.getElementById('deleteConfirmModal')).show();
}

async function deleteStaff() {
    const staffId = document.getElementById('deleteStaffId').value;
    const toast = new bootstrap.Toast(document.getElementById('operationToast'));
    const toastMessage = document.getElementById('toastMessage');
    const deleteButton = document.getElementById('confirmDeleteButton');
    const originalButtonText = deleteButton.innerHTML;

    try {
        // Show loading state
        deleteButton.disabled = true;
        deleteButton.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Deleting...';

        const response = await fetch(`${pageContext.request.contextPath}/admin-staff/delete/${staffId}`, {
            method: 'DELETE',
            headers: {
                'X-CSRF-TOKEN': document.getElementById('csrfToken').value,
                'Content-Type': 'application/json'
            }
        });

        console.log('Response status:', response.status);

        if (!response.ok) {
            const errorData = await response.json().catch(() => ({}));
            throw new Error(errorData.message || `Delete failed: ${response.status} ${response.statusText}`);
        }

        // Success handling
        toastMessage.textContent = 'Staff member deleted successfully';
        toastMessage.className = 'text-success';

        // Remove the row from the table
        const row = document.querySelector(`tr[data-staff-id="${staffId}"]`);
        if (row) {
            row.classList.add('table-danger');
            setTimeout(() => row.remove(), 500); // Smooth removal with fade effect
        }

        // Close the modal
        const modal = bootstrap.Modal.getInstance(document.getElementById('deleteConfirmModal'));
        if (modal) {
            modal.hide();
        }

    } catch (error) {
        console.error('Delete error:', error);
        toastMessage.textContent = error.message || 'An unexpected error occurred while deleting the staff member';
        toastMessage.className = 'text-danger';
    } finally {
        // Reset button state
        deleteButton.disabled = false;
        deleteButton.innerHTML = originalButtonText;

        // Show toast notification
        toast.show();
    }
}


// Open permissions modal
function openPermissionModal(staffId) {
    document.getElementById('permissionStaffId').value = staffId;
    new bootstrap.Modal(document.getElementById('permissionsModal')).show();
}

// Handle permissions form submission
document.getElementById('permissionsForm').addEventListener('submit', function(e) {
    e.preventDefault();

    const staffId = document.getElementById('permissionStaffId').value;
    const selectedPermissions = Array.from(document.querySelectorAll('#permissionsForm input[name="perms"]:checked'))
        .map(checkbox => checkbox.value);

    const toastMessage = document.getElementById('toastMessage');
    const successToast = new bootstrap.Toast(document.getElementById('successToast'));

    fetch(`${pageContext.request.contextPath}/admin-staff/permissions/${staffId}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': document.getElementById('csrfToken').value
        },
        body: JSON.stringify(selectedPermissions)
    })
    .then(response => {
        if (response.ok) {
            toastMessage.textContent = 'Permissions updated successfully';
            successToast.show();
            bootstrap.Modal.getInstance(document.getElementById('permissionsModal')).hide();
            // Optionally update the UI to reflect new permissions
        } else {
            throw new Error('Failed to update permissions');
        }
    })
    .catch(error => {
        toastMessage.textContent = error.message;
        successToast.show();
    });
});