
document.addEventListener('DOMContentLoaded', function () {

    // --- Initialize Toggles ---
    const allToggles = document.querySelectorAll('.charge-toggle');
    allToggles.forEach(toggle => {
        setupToggleListener(toggle);
    });

    function setupToggleListener(toggle) {
        // Find the associated input group
        // The HTML structure assumes the input group is a sibling or identifiable by ID convention
        // e.g., toggle ID "toggleFeeName" -> input group ID "feeNameGroup"

        const toggleId = toggle.id;
        const targetGroupId = toggleId.replace('toggle', '').replace(/^[A-Z]/, c => c.toLowerCase()) + 'Group';
        // Wait, replace 'toggle' then lowercase 1st letter: toggleBaseDeliveryFee -> baseDeliveryFeeGroup

        const targetGroup = document.getElementById(targetGroupId);

        if (targetGroup) {
            // Initial state
            if (toggle.checked) {
                targetGroup.classList.remove('d-none'); // Bootstrap class removal if present
                targetGroup.classList.add('show');
                targetGroup.style.maxHeight = targetGroup.scrollHeight + "px";
                targetGroup.style.opacity = "1";
                targetGroup.style.marginTop = "1rem";
            } else {
                targetGroup.classList.remove('show');
                targetGroup.style.maxHeight = "0";
                targetGroup.style.opacity = "0";
                targetGroup.style.marginTop = "0";
            }

            // Change listener
            toggle.addEventListener('change', function () {
                if (this.checked) {
                    targetGroup.classList.remove('d-none');
                    targetGroup.classList.add('show');
                    targetGroup.style.maxHeight = targetGroup.scrollHeight + "px";
                    targetGroup.style.opacity = "1";
                    targetGroup.style.marginTop = "1rem";

                    // Focus input if exists
                    const input = targetGroup.querySelector('input');
                    if (input) input.focus();

                } else {
                    targetGroup.classList.remove('show');
                    targetGroup.style.maxHeight = "0";
                    targetGroup.style.opacity = "0";
                    targetGroup.style.marginTop = "0";
                }
            });
        }
    }

    // --- Custom Fees Dynamic Add ---
    const addFeeBtn = document.getElementById('addCustomFee');
    const customFeesContainer = document.getElementById('customFeesContainer');

    if (addFeeBtn && customFeesContainer) {
        addFeeBtn.addEventListener('click', function () {
            const newFeeRow = document.createElement('div');
            newFeeRow.className = 'custom-fee-item animate-enter';
            newFeeRow.innerHTML = `
                <div class="zenith-input-group flex-grow-1">
                    <input type="text" class="zenith-input-field" name="customFeeNames" placeholder="Fee Name" required>
                </div>
                <div class="zenith-input-group" style="width: 140px;">
                    <span class="zenith-input-text">${typeof currencySymbol !== 'undefined' ? currencySymbol : '₹'}</span>
                    <input type="number" class="zenith-input-field" name="customFeeValues" placeholder="0.00" step="0.01" min="0" required>
                </div>
                <button type="button" class="btn-remove-fee">
                    <i class="fas fa-trash-alt"></i>
                </button>
            `;

            customFeesContainer.appendChild(newFeeRow);

            // Add remove listener
            newFeeRow.querySelector('.btn-remove-fee').addEventListener('click', function () {
                newFeeRow.remove();
            });
        });

        // Add remove listeners to existing items (if any, from server-side loop)
        const existingRemoveBtns = document.querySelectorAll('.remove-custom-fee'); // Note: Make sure to update JSP class
        existingRemoveBtns.forEach(btn => {
            btn.addEventListener('click', function () {
                this.closest('.custom-fee-item').remove();
            });
        });
    }

});
