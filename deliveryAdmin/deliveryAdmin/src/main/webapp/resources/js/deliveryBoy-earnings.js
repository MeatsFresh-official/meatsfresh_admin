document.addEventListener('DOMContentLoaded', () => {
    // --- DOM ELEMENT REFERENCES ---
    const statsContainer = document.getElementById('payout-stats-container');
    const tableBody = document.getElementById('payoutsTableBody');
    const paginationInfo = document.getElementById('pagination-info');
    const paginationControls = document.getElementById('pagination-controls');
    const dropdownButtonText = document.getElementById('payoutsDropdown').querySelector('span');
    const filterStatusText = document.getElementById('filterStatusText');
    const processPayoutModal = new bootstrap.Modal(document.getElementById('processPayoutModal'));
    const dateRangeModal = new bootstrap.Modal(document.getElementById('dateRangeModal'));
    const successToast = new bootstrap.Toast(document.getElementById('successToast'));
    const errorToast = new bootstrap.Toast(document.getElementById('errorToast'));

    // --- STATE MANAGEMENT ---
    let state = {
        timeRange: 'month', // 'today', 'week', 'month', 'year', 'custom'
        statusFilter: 'all', // 'all', 'pending', 'paid', 'failed'
        customStartDate: null,
        customEndDate: null,
        currentPage: 1,
    };

    // --- MOCK API (Replace with your actual API calls) ---
    const mockApi = {
        getStats: async (range, start, end) => {
            await new Promise(res => setTimeout(res, 600)); // Simulate delay
            return {
                totalPaid: 85450.00,
                pendingPayouts: 12300.50,
                thisMonthEarnings: 21500.75,
                ridersToPay: 8
            };
        },
        getRiders: async (page, range, status) => {
            await new Promise(res => setTimeout(res, 1000));
            const allRiders = [
                { id: 'RID001', name: 'Arun Kumar', phone: '9876543210', avatar: 'AK', status: 'pending', periodEarnings: 2850.50, pendingAmount: 2850.50 },
                { id: 'RID002', name: 'Bhavna Singh', phone: '8765432109', avatar: 'BS', status: 'paid', periodEarnings: 3200.00, pendingAmount: 0.00 },
                { id: 'RID003', name: 'Chetan Sharma', phone: '7654321098', avatar: 'CS', status: 'pending', periodEarnings: 1980.75, pendingAmount: 4500.00 },
                { id: 'RID004', name: 'Divya Mehta', phone: '6543210987', avatar: 'DM', status: 'paid', periodEarnings: 4100.25, pendingAmount: 0.00 },
                { id: 'RID005', name: 'Eshan Jain', phone: '5432109876', avatar: 'EJ', status: 'failed', periodEarnings: 2200.00, pendingAmount: 2200.00 },
            ];
            const filtered = allRiders.filter(r => status === 'all' || r.status === status);
            return {
                riders: filtered,
                totalPages: 1,
                currentPage: 1,
                totalItems: filtered.length
            };
        },
        processPayout: async (riderId, transactionId) => {
            await new Promise(res => setTimeout(res, 1200));
            if (transactionId.trim() === '') return { success: false, message: 'Transaction ID cannot be empty.' };
            console.log(`Processing payout for ${riderId} with TxID: ${transactionId}`);
            return { success: true, message: `Payout for rider ${riderId} processed successfully.` };
        }
    };

    // --- DATA RENDERING FUNCTIONS ---
    const renderStats = (stats) => {
        statsContainer.innerHTML = `
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card bg-success text-white">
                    <div class="card-body">
                        <h6 class="mb-0">Total Paid Out</h6>
                        <h3 class="mb-0">₹${stats.totalPaid.toLocaleString('en-IN')}</h3>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card bg-danger text-white">
                    <div class="card-body">
                        <h6 class="mb-0">Pending Payouts</h6>
                        <h3 class="mb-0">₹${stats.pendingPayouts.toLocaleString('en-IN')}</h3>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card bg-primary text-white">
                    <div class="card-body">
                        <h6 class="mb-0">This Period's Earnings</h6>
                        <h3 class="mb-0">₹${stats.thisMonthEarnings.toLocaleString('en-IN')}</h3>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card bg-warning text-white">
                    <div class="card-body">
                        <h6 class="mb-0">Riders to Pay</h6>
                        <h3 class="mb-0">${stats.ridersToPay}</h3>
                    </div>
                </div>
            </div>
        `;
    };

    const renderTable = (data) => {
        if (!data.riders || data.riders.length === 0) {
            tableBody.innerHTML = `<tr><td colspan="6" class="text-center p-5">No riders found for the selected criteria.</td></tr>`;
            return;
        }

        tableBody.innerHTML = data.riders.map(rider => `
            <tr>
                <td class="ps-3">
                    <div class="rider-info">
                        <div class="rider-avatar" style="background-color: hsl(${rider.id.charCodeAt(5)}, 60%, 50%);">${rider.avatar}</div>
                        <div>
                            <p class="rider-name">${rider.name}</p>
                            <span class="rider-id">${rider.id}</span>
                        </div>
                    </div>
                </td>
                <td>${rider.phone}</td>
                <td class="text-center payout-status-column">
                    <span class="badge rounded-pill payout-status status-${rider.status}">${rider.status.toUpperCase()}</span>
                </td>
                <td class="text-end earnings-amount">₹${rider.periodEarnings.toLocaleString('en-IN', {minimumFractionDigits: 2})}</td>
                <td class="text-end earnings-amount ${rider.pendingAmount > 0 ? 'pending-amount' : ''}">₹${rider.pendingAmount.toLocaleString('en-IN', {minimumFractionDigits: 2})}</td>
                <td class="text-center">
                    ${rider.status === 'pending' || rider.status === 'failed' ?
                    `<button class="btn btn-primary btn-sm pay-btn" data-id="${rider.id}" data-name="${rider.name}" data-amount="${rider.pendingAmount}">
                        <i class="fas fa-hand-holding-usd me-1"></i> Pay Now
                    </button>` :
                    `<button class="btn btn-outline-secondary btn-sm" disabled><i class="fas fa-check me-1"></i> Paid</button>`
                    }
                </td>
            </tr>
        `).join('');
    };

    const renderPagination = (data) => {
        paginationInfo.textContent = `Showing ${data.riders.length} of ${data.totalItems} riders.`;
        paginationControls.innerHTML = ''; // Add logic for multiple pages if needed
    };

    // --- MAIN DATA FETCH & UPDATE ---
    const updateDashboard = async () => {
        // Show loaders
        statsContainer.innerHTML = Array(4).fill('<div class="col-xl-3 col-md-6 mb-4"><div class="card skeleton" style="height: 110px;"></div></div>').join('');
        tableBody.innerHTML = `<tr><td colspan="6" class="text-center p-5"><div class="spinner-border text-primary"></div></td></tr>`;

        const [statsData, ridersData] = await Promise.all([
            mockApi.getStats(state.timeRange, state.customStartDate, state.customEndDate),
            mockApi.getRiders(state.currentPage, state.timeRange, state.statusFilter)
        ]);

        renderStats(statsData);
        renderTable(ridersData);
        renderPagination(ridersData);
    };

    // --- EVENT LISTENERS ---
    document.querySelectorAll('.payout-range').forEach(item => {
        item.addEventListener('click', (e) => {
            e.preventDefault();
            const newRange = e.target.dataset.range;
            if (state.timeRange !== newRange) {
                state.timeRange = newRange;
                dropdownButtonText.textContent = e.target.textContent;
                document.querySelectorAll('.payout-range').forEach(i => i.classList.remove('active'));
                e.target.classList.add('active');
                updateDashboard();
            }
        });
    });

    document.querySelectorAll('.filter-payout').forEach(item => {
        item.addEventListener('click', (e) => {
            e.preventDefault();
            state.statusFilter = e.target.dataset.filter;
            filterStatusText.textContent = e.target.textContent;
            updateDashboard();
        });
    });

    document.getElementById('applyDateRange').addEventListener('click', () => {
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;
        if (startDate && endDate) {
            state.timeRange = 'custom';
            state.customStartDate = startDate;
            state.customEndDate = endDate;
            dropdownButtonText.textContent = 'Custom';
            document.querySelectorAll('.payout-range').forEach(i => i.classList.remove('active'));
            dateRangeModal.hide();
            updateDashboard();
        }
    });

    // Payout Modal Logic
    document.getElementById('payoutsTableBody').addEventListener('click', (e) => {
        const payButton = e.target.closest('.pay-btn');
        if (payButton) {
            document.getElementById('payoutRiderId').value = payButton.dataset.id;
            document.getElementById('payoutRiderName').textContent = payButton.dataset.name;
            document.getElementById('payoutAmount').textContent = `₹${parseFloat(payButton.dataset.amount).toLocaleString('en-IN', {minimumFractionDigits: 2})}`;
            document.getElementById('transactionId').value = '';
            document.getElementById('payoutConfirmationCheck').checked = false;
            document.getElementById('confirmPayoutBtn').disabled = true;
            processPayoutModal.show();
        }
    });

    document.getElementById('payoutConfirmationCheck').addEventListener('change', (e) => {
        document.getElementById('confirmPayoutBtn').disabled = !e.target.checked;
    });

    document.getElementById('confirmPayoutBtn').addEventListener('click', async (e) => {
        const btn = e.target;
        btn.disabled = true;
        btn.innerHTML = `<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Processing...`;

        const riderId = document.getElementById('payoutRiderId').value;
        const transactionId = document.getElementById('transactionId').value;

        const result = await mockApi.processPayout(riderId, transactionId);

        if (result.success) {
            document.getElementById('successToastMessage').textContent = result.message;
            successToast.show();
            processPayoutModal.hide();
            await updateDashboard();
        } else {
            document.getElementById('errorToastMessage').textContent = result.message;
            errorToast.show();
        }

        btn.disabled = false;
        btn.innerHTML = `<i class="fas fa-check-circle me-2"></i>Confirm Payout`;
    });

    // --- INITIAL LOAD ---
    updateDashboard();
});