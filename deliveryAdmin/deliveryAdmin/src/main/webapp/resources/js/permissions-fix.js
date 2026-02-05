// TEST: Direct button click handler
console.log("PERMISSIONS FIX SCRIPT LOADED");

$(document).ready(function () {
    console.log("jQuery ready - setting up permissions handler");

    // TEST: Listen to ALL clicks on the entire document
    $(document).on('click', function (e) {
        console.log("GLOBAL CLICK TARGET:", e.target);
        console.log("GLOBAL CLICK PARENT:", e.target.parentElement);
        console.log("GLOBAL CLICK ID:", e.target.id);
        console.log("GLOBAL CLICK CLASS:", e.target.className);
    });

    // Listen on the entire modal
    $('#permissionsModal').on('click', '#savePermissionsBtn', function (e) {
        console.log("SAVE BUTTON CLICKED VIA MODAL DELEGATION!");

        const staffId = $('#permStaffId').val();
        const selectedPages = [];
        $('.perm-check:checked').each(function () {
            selectedPages.push($(this).val());
        });

        console.log("StaffID:", staffId, "Pages:", selectedPages);

        // Make AJAX call
        const token = $("meta[name='_csrf']").attr("content");
        const header = $("meta[name='_csrf_header']").attr("content");

        $.ajax({
            url: contextPath + "/admin-staff/update-access-pages",
            type: 'POST',
            traditional: true,
            beforeSend: function (xhr) {
                if (header && token) {
                    xhr.setRequestHeader(header, token);
                }
            },
            data: {
                staffId: staffId,
                accessPages: selectedPages
            },
            success: function (response) {
                console.log("Success:", response);
                alert("Permissions updated successfully!");
                location.reload();
            },
            error: function (xhr) {
                console.error("Error:", xhr);
                alert("Error: " + (xhr.responseJSON ? xhr.responseJSON.message : xhr.status));
            }
        });

        e.preventDefault();
        e.stopPropagation();
    });

    console.log("Modal click delegation registered");
});
