/**
 * Admin Staff Management JS - v3.0
 */

(function () {
    console.log("admin-staff.js v3.0 started");

    // Helper to log with timestamp
    function debugLog(msg, data) {
        const time = new Date().toLocaleTimeString();
        if (data) console.log(`[${time}] ${msg}`, data);
        else console.log(`[${time}] ${msg}`);
    }

    // --- Global Helper Functions ---
    window.openPermissionsModal = function (staffId) {
        debugLog("Triggering permissions modal for ID:", staffId);

        const row = document.querySelector(`tr[data-staff-id="${staffId}"]`);
        if (!row) {
            console.error("Row not found for staff ID:", staffId);
            return;
        }

        const accessPagesStr = row.getAttribute('data-access-pages') || '';
        const accessPages = accessPagesStr.split(',').map(s => s.trim()).filter(s => s !== '');
        debugLog("Current access pages:", accessPages);

        const staffIdInput = document.getElementById('permStaffId');
        if (staffIdInput) staffIdInput.value = staffId;

        // Reset check boxes
        document.querySelectorAll('.perm-check').forEach(cb => {
            if (cb.value === 'DASHBOARD') {
                cb.checked = true;
            } else {
                cb.checked = accessPages.includes(cb.value);
            }
        });

        const modalEl = document.getElementById('permissionsModal');
        if (modalEl) {
            const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
            modal.show();
            debugLog("Modal show() executed");
        }
    };

    window.savePermissions = function () {
        debugLog("savePermissions function called!");

        const staffIdInput = document.getElementById('permStaffId');
        if (!staffIdInput) {
            console.error("Error: permStaffId element not found!");
            return;
        }

        const staffId = staffIdInput.value;
        if (!staffId) {
            alert("Error: No Staff ID selected!");
            return;
        }

        const selectedPages = [];
        document.querySelectorAll('.perm-check:checked').forEach(cb => {
            selectedPages.push(cb.value);
        });

        const tokenMeta = document.querySelector("meta[name='_csrf']");
        const headerMeta = document.querySelector("meta[name='_csrf_header']");
        const token = tokenMeta ? tokenMeta.getAttribute("content") : "";
        const header = headerMeta ? headerMeta.getAttribute("content") : "";

        debugLog("Data collection successful", {
            staffId,
            selectedPages,
            csrfToken: token ? "FOUND" : "MISSING",
            csrfHeader: header || "MISSING"
        });

        // UI State
        const btn = document.getElementById('savePermissionsBtn');
        const originalText = btn ? btn.innerHTML : "Save Changes";
        if (btn) {
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
            btn.disabled = true;
        }

        // Context path handling - ensure no double slashes
        let ctx = window.contextPath || '';
        if (ctx.endsWith('/')) ctx = ctx.slice(0, -1);
        const url = ctx + "/admin-staff/update-access-pages";

        debugLog("Final Request URL:", url);

        $.ajax({
            url: url,
            type: 'POST',
            traditional: true,
            beforeSend: function (xhr) {
                if (header && token) {
                    xhr.setRequestHeader(header, token);
                    debugLog("CSRF header added to request");
                }
            },
            data: {
                staffId: staffId,
                accessPages: selectedPages
            },
            success: function (response) {
                debugLog("Success response received", response);
                alert("Success! Permissions updated.");
                window.location.reload();
            },
            error: function (xhr) {
                debugLog("Error response received", xhr);
                let errorMsg = "Update failed (Status: " + xhr.status + ")";

                if (xhr.status === 403) {
                    errorMsg = "Access Denied (403): Possible session timeout or CSRF error. Please reload the page.";
                } else if (xhr.responseJSON && xhr.responseJSON.message) {
                    errorMsg = xhr.responseJSON.message;
                } else if (xhr.responseText) {
                    try {
                        const parsed = JSON.parse(xhr.responseText);
                        if (parsed.message) errorMsg = parsed.message;
                    } catch (e) { }
                }

                alert("API Error: " + errorMsg);

                if (btn) {
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                }
            }
        });
    };

    window.handleEditClick = function (btn) {
        const d = btn.dataset;
        document.getElementById('editStaffId').value = d.id || '';
        document.getElementById('editStaffName').value = d.name || '';
        document.getElementById('editStaffEmail').value = d.email || '';
        document.getElementById('editStaffPhone').value = d.phone || '';
        document.getElementById('editStaffRole').value = d.role || '';
        document.getElementById('editStaffActive').checked = (d.active === 'true');

        const modalEl = document.getElementById('editStaffModal');
        if (modalEl) bootstrap.Modal.getOrCreateInstance(modalEl).show();
    };

    window.confirmDelete = function (id) {
        document.getElementById('deleteStaffId').value = id;
        const modalEl = document.getElementById('deleteConfirmModal');
        if (modalEl) bootstrap.Modal.getOrCreateInstance(modalEl).show();
    };

    window.deleteStaff = function () {
        const id = document.getElementById('deleteStaffId').value;
        const token = document.querySelector("meta[name='_csrf']").getAttribute("content");
        const header = document.querySelector("meta[name='_csrf_header']").getAttribute("content");
        const ctx = window.contextPath || '';

        $.ajax({
            url: ctx + "/admin-staff/delete/" + id,
            type: 'DELETE',
            beforeSend: function (xhr) { xhr.setRequestHeader(header, token); },
            success: function () { window.location.reload(); },
            error: function () { alert("Delete failed"); }
        });
    };

    // --- DOM Init ---
    document.addEventListener('DOMContentLoaded', function () {
        debugLog("DOM Initializing");

        // Setup Filter listener
        document.querySelectorAll('[data-filter]').forEach(link => {
            link.addEventListener('click', function (e) {
                e.preventDefault();
                const filter = this.dataset.filter;
                const rows = document.querySelectorAll('#staffTable tbody tr');
                rows.forEach(row => {
                    const badge = row.querySelector('.badge-zenith');
                    const role = badge ? badge.textContent.trim() : '';
                    row.style.display = (filter === 'all' || role.includes(filter)) ? '' : 'none';
                });
            });
        });



        // Use jQuery event delegation - works with dynamically modified elements
        $(document).on('click', '#savePermissionsBtn', function (e) {
            debugLog("Save button clicked via jQuery delegation!");
            e.preventDefault();
            e.stopPropagation();
            window.savePermissions();
        });
        debugLog("jQuery delegation for Save button registered");

        // Debug: Inspect button when modal opens
        $('#permissionsModal').on('shown.bs.modal', function () {
            const btn = document.getElementById('savePermissionsBtn');
            if (btn) {
                console.log("=== BUTTON FOUND ===");
                console.log("Button HTML:", btn.outerHTML);
                console.log("Disabled?", btn.disabled);


                // Add mousedown listener - fires before click
                btn.addEventListener('mousedown', function (e) {
                    console.log("✓ MOUSEDOWN - Calling savePermissions!");
                    e.stopPropagation();
                    e.preventDefault();
                    window.savePermissions();
                }, true);

                btn.addEventListener('click', function () {
                    console.log("✓ CLICK detected!");
                }, true);
            } else {
                console.error("Button NOT found!");
            }
        });

        debugLog("Initialization complete");
    });

})();
