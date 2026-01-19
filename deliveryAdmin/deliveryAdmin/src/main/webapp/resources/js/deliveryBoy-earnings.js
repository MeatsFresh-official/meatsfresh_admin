document.addEventListener('DOMContentLoaded', () => {
    // --- DOM ELEMENTS ---
    const statsContainer = document.getElementById('payout-stats-container');
    const payoutsDropdown = document.getElementById('payoutsDropdown');
    const filterStatusText = document.getElementById('filterStatusText');
    const paginationInfo = document.getElementById('pagination-info');
    const paginationControls = document.getElementById('pagination-controls');
    const processPayoutModal = new bootstrap.Modal(document.getElementById('processPayoutModal'));
    const dateRangeModal = new bootstrap.Modal(document.getElementById('dateRangeModal'));
    const successToast = new bootstrap.Toast(document.getElementById('successToast'));
    const errorToast = new bootstrap.Toast(document.getElementById('errorToast'));

    // --- MOCK DATA ---
    const mockStats = {
        totalPaid: 182500.50,
        pendingPayouts: 42350.50,
        thisMonthEarnings: 58600.00,
        ridersToPay: 9
    };

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
    // --- HELPER FUNCTIONS ---
    const formatCurrencyCompact = (amount) => {
        if (amount >= 1000000) {
            return '₹' + (amount / 1000000).toFixed(1).replace(/\.0$/, '') + 'M';
        }
        if (amount >= 1000) {
            return '₹' + (amount / 1000).toFixed(1).replace(/\.0$/, '') + 'K';
        }
        return '₹' + amount.toLocaleString('en-IN');
    };

    const renderStats = (stats) => {
        statsContainer.innerHTML = `
            <div class="col-xl-3 col-md-6 mb-4 animate-on-load" style="animation-delay: 0s;">
                <div class="hero-stat-card bg-gradient-success-zenith shadow-lg">
                    <div class="card-body">
                        <i class="fas fa-check-circle stat-icon text-white"></i>
                        <h6>Total Paid Out</h6>
                        <h3>${formatCurrencyCompact(stats.totalPaid)}</h3>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4 animate-on-load" style="animation-delay: 0.1s;">
                <div class="hero-stat-card bg-gradient-danger-zenith shadow-lg">
                    <div class="card-body">
                        <i class="fas fa-exclamation-circle stat-icon text-white"></i>
                        <h6>Pending Payouts</h6>
                        <h3>${formatCurrencyCompact(stats.pendingPayouts)}</h3>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4 animate-on-load" style="animation-delay: 0.2s;">
                <div class="hero-stat-card bg-gradient-primary-zenith shadow-lg">
                    <div class="card-body">
                        <i class="fas fa-wallet stat-icon text-white"></i>
                        <h6>Period Earnings</h6>
                        <h3>${formatCurrencyCompact(stats.thisMonthEarnings)}</h3>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4 animate-on-load" style="animation-delay: 0.3s;">
                <div class="hero-stat-card bg-gradient-warning-zenith shadow-lg">
                    <div class="card-body">
                        <i class="fas fa-users stat-icon text-white"></i>
                        <h6>Riders to Pay</h6>
                        <h3>${stats.ridersToPay}</h3>
                    </div>
                </div>
            </div>
        `;
    };

    const currentWeekTableBody = document.getElementById('currentWeekTableBody');
    const historyTableBody = document.getElementById('historyTableBody');

    // --- MOCK DATA FOR TABBED VIEW ---
    const mockCurrentWeekData = [
        { id: 'R001', name: 'Raju Kumar', avatar: 'RK', phone: '+91 98765 43210', activeOrders: 12, currentEarnings: 4500.00, status: 'pending' },
        { id: 'R002', name: 'Vikram Malhotra', avatar: 'VM', phone: '+91 76543 21098', activeOrders: 15, currentEarnings: 5200.00, status: 'pending' },
        { id: 'R003', name: 'Amit Singh', avatar: 'AS', phone: '+91 98989 89898', activeOrders: 8, currentEarnings: 2800.50, status: 'pending' },
        { id: 'R004', name: 'Suresh Raina', avatar: 'SR', phone: '+91 99887 76655', activeOrders: 20, currentEarnings: 6750.00, status: 'pending' },
        { id: 'R005', name: 'Deepak Chahar', avatar: 'DC', phone: '+91 88776 65544', activeOrders: 5, currentEarnings: 1500.00, status: 'pending' },
        { id: 'R006', name: 'Rishabh Pant', avatar: 'RP', phone: '+91 77665 54433', activeOrders: 18, currentEarnings: 6100.00, status: 'pending' },
        { id: 'R007', name: 'Hardik Pandya', avatar: 'HP', phone: '+91 66554 43322', activeOrders: 10, currentEarnings: 3200.00, status: 'pending' },
        { id: 'R008', name: 'Jasprit Bumrah', avatar: 'JB', phone: '+91 55443 32211', activeOrders: 22, currentEarnings: 7500.00, status: 'pending' },
        { id: 'R009', name: 'Ravindra Jadeja', avatar: 'RJ', phone: '+91 44332 21100', activeOrders: 14, currentEarnings: 4800.00, status: 'pending' }
    ];

    const mockHistoryData = [
        { txId: 'TXN-1001', date: '2023-10-15', rider: { name: 'Raju Kumar', avatar: 'RK' }, status: 'paid', amount: 4200.00 },
        { txId: 'TXN-1002', date: '2023-10-14', rider: { name: 'Suresh Raina', avatar: 'SR' }, status: 'paid', amount: 3100.00 },
        { txId: 'TXN-1003', date: '2023-10-12', rider: { name: 'Amit Singh', avatar: 'AS' }, status: 'failed', amount: 2800.00 },
        { txId: 'TXN-1004', date: '2023-10-10', rider: { name: 'Vikram Malhotra', avatar: 'VM' }, status: 'paid', amount: 5000.00 },
        { txId: 'TXN-1005', date: '2023-10-09', rider: { name: 'Deepak Chahar', avatar: 'DC' }, status: 'paid', amount: 1800.00 },
        { txId: 'TXN-1006', date: '2023-10-08', rider: { name: 'Rishabh Pant', avatar: 'RP' }, status: 'paid', amount: 5900.00 },
        { txId: 'TXN-1007', date: '2023-10-06', rider: { name: 'Hardik Pandya', avatar: 'HP' }, status: 'paid', amount: 3500.00 },
        { txId: 'TXN-1008', date: '2023-10-05', rider: { name: 'Jasprit Bumrah', avatar: 'JB' }, status: 'paid', amount: 8000.00 },
        { txId: 'TXN-1009', date: '2023-10-04', rider: { name: 'Ravindra Jadeja', avatar: 'RJ' }, status: 'paid', amount: 4100.00 },
        { txId: 'TXN-1010', date: '2023-10-01', rider: { name: 'Raju Kumar', avatar: 'RK' }, status: 'paid', amount: 3900.00 }
    ];


    const renderCurrentWeekTable = (riders) => {
        if (!riders || riders.length === 0) {
            currentWeekTableBody.innerHTML = `<tr><td colspan="5" class="text-center p-5 text-muted">No pending payouts for this week.</td></tr>`;
            return;
        }

        currentWeekTableBody.innerHTML = riders.map((rider, index) => `
            <tr class="animate-on-load clickable-row" style="animation-delay: ${index * 0.05}s;" onclick="openRiderDetails('${rider.id}')">
                <td class="ps-4">
                    <div class="rider-info">
                        <div class="rider-avatar shadow-sm" style="background-color: hsl(${rider.id.charCodeAt(3) * 20}, 70%, 50%);">${rider.avatar}</div>
                        <div>
                            <p class="rider-name text-dark mb-0">${rider.name}</p>
                            <small class="rider-id text-muted" style="font-size: 0.75rem;">${rider.id}</small>
                        </div>
                    </div>
                </td>
                <td class="text-secondary fw-medium">${rider.phone}</td>
                <td class="text-center"><span class="zenith-badge bg-soft-info text-info rounded-pill px-3">${rider.activeOrders} Active</span></td>
                <td class="text-end fw-bold text-dark fs-6">₹${rider.currentEarnings.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</td>
                <td class="text-center pe-4">
                    <button class="btn btn-zenith-primary btn-sm pay-btn shadow-sm px-4" onclick="openPayoutModal(event, '${rider.id}', '${rider.name}', ${rider.currentEarnings})">
                        <i class="fas fa-paper-plane me-2"></i> Pay
                    </button>
                </td>
            </tr>
        `).join('');
    };

    // --- PAYOUT MODAL LOGIC ---
    window.openPayoutModal = (event, riderId, riderName, amount) => {
        event.stopPropagation(); // Prevent opening the rider details slide-over

        document.getElementById('payoutRiderId').value = riderId;
        document.getElementById('payoutRiderName').textContent = riderName;
        document.getElementById('payoutAmount').textContent = `₹${parseFloat(amount).toLocaleString('en-IN', { minimumFractionDigits: 2 })}`;
        document.getElementById('transactionId').value = '';
        document.getElementById('payoutConfirmationCheck').checked = false;
        document.getElementById('confirmPayoutBtn').disabled = true;

        processPayoutModal.show();
    };


    // --- RIDER DETAILS OFFCANVAS LOGIC ---
    window.openRiderDetails = async (riderId) => {
        const offcanvasEl = document.getElementById('riderDetailsOffcanvas');
        const bsOffcanvas = new bootstrap.Offcanvas(offcanvasEl);
        bsOffcanvas.show();

        // 1. Find basic rider info from data (or fetch)
        // For now, looking up in mockCurrentWeekData or mockHistoryData
        let rider = mockCurrentWeekData.find(r => r.id === riderId);
        if (!rider) {
            // If not in current week, maybe construct dummy data or fetch
            rider = { id: riderId, name: 'Suresh Raina', avatar: 'SR', status: 'Active', totalPaid: 125000 }; // Fallback
        }

        // 2. Populate Header
        document.getElementById('offcanvasRiderName').textContent = rider.name || 'Unknown Rider';
        document.getElementById('offcanvasRiderId').textContent = rider.id;
        document.getElementById('offcanvasRiderAvatar').textContent = rider.avatar || 'XX';
        document.getElementById('offcanvasRiderAvatar').style.backgroundColor = `hsl(${rider.id.charCodeAt(3) * 20}, 70%, 50%)`;

        // 3. Mock Fetch History for this Rider
        const historyList = document.getElementById('riderHistoryList');
        historyList.innerHTML = `<div class="text-center p-5"><div class="spinner-border text-primary" role="status"></div></div>`;

        await new Promise(r => setTimeout(r, 600)); // Sim delay

        // Generate specific mock history
        const specificHistory = Array(8).fill(0).map((_, i) => ({
            date: new Date(new Date().setDate(new Date().getDate() - i * 7)), // Weekly
            amount: Math.floor(Math.random() * 5000) + 1500,
            status: Math.random() > 0.1 ? 'paid' : 'failed',
            txId: `TXN-${9000 + i}`
        }));

        // Calculate Stats
        const totalPaid = specificHistory.filter(t => t.status === 'paid').reduce((acc, curr) => acc + curr.amount, 0);
        document.getElementById('offcanvasTotalPaid').textContent = formatCurrencyCompact(totalPaid);
        document.getElementById('offcanvasPendingAmount').textContent = formatCurrencyCompact(4500);

        historyList.innerHTML = specificHistory.map(tx => `
            <div class="list-group-item p-3 border-light border-bottom d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center gap-3">
                    <div class="icon-circle ${tx.status === 'paid' ? 'bg-soft-success text-success' : 'bg-soft-danger text-danger'}" style="width: 40px; height: 40px;">
                        <i class="fas ${tx.status === 'paid' ? 'fa-check' : 'fa-times'}"></i>
                    </div>
                    <div>
                        <h6 class="mb-0 fw-bold text-dark">Weekly Payout</h6>
                        <small class="text-muted">${tx.date.toLocaleDateString('en-IN', { day: 'numeric', month: 'short' })} • ${tx.txId}</small>
                    </div>
                </div>
                <div class="text-end">
                     <h6 class="mb-0 fw-bold bg-white">₹${tx.amount.toLocaleString('en-IN')}</h6>
                     <span class="badge ${tx.status === 'paid' ? 'bg-soft-success text-success' : 'bg-soft-danger text-danger'} rounded-pill" style="font-size: 0.7rem;">${tx.status.toUpperCase()}</span>
                </div>
            </div>
        `).join('');
    };

    const renderHistoryTable = (transactions) => {
        if (!transactions || transactions.length === 0) {
            historyTableBody.innerHTML = `<tr><td colspan="6" class="text-center p-5 text-muted">No transaction history found.</td></tr>`;
            return;
        }

        historyTableBody.innerHTML = transactions.map((tx, index) => `
            <tr class="animate-on-load" style="animation-delay: ${index * 0.05}s;">
                <td class="ps-4 text-primary fw-medium font-monospace">${tx.txId}</td>
                <td class="text-secondary">${new Date(tx.date).toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' })}</td>
                <td>
                    <div class="d-flex align-items-center gap-2">
                        <div class="rider-avatar small" style="width: 32px; height: 32px; font-size: 0.8rem; background-color: #e5e7eb; color: #6b7280;">${tx.rider.avatar}</div>
                        <span class="fw-medium text-dark">${tx.rider.name}</span>
                    </div>
                </td>
                <td class="text-center"><span class="zenith-badge ${tx.status}">${tx.status.toUpperCase()}</span></td>
                <td class="text-end fw-bold text-dark">₹${formatCurrencyCompact(tx.amount)}</td>
                <td class="text-center pe-4">
                     <button class="btn btn-sm btn-white shadow-sm text-secondary hover-scale"><i class="fas fa-file-invoice"></i></button>
                </td>
            </tr>
        `).join('');
    };

    const renderTable = (data) => {
        if (!data.riders || data.riders.length === 0) {
            tableBody.innerHTML = `<tr><td colspan="6" class="text-center p-5 text-muted">No riders found for the selected criteria.</td></tr>`;
            return;
        }

        tableBody.innerHTML = data.riders.map((rider, index) => `
            <tr class="animate-on-load" style="animation-delay: ${index * 0.05}s;">
                <td class="ps-4">
                    <div class="rider-info">
                        <div class="rider-avatar shadow-sm" style="background-color: hsl(${rider.id.charCodeAt(5) * 10}, 65%, 50%);">${rider.avatar}</div>
                        <div>
                            <p class="rider-name text-dark">${rider.name}</p>
                            <span class="rider-id badge bg-light text-secondary border px-2 py-0 mt-1">${rider.id}</span>
                        </div>
                    </div>
                </td>
                <td class="text-secondary fw-medium">${rider.phone}</td>
                <td class="text-center payout-status-column">
                    <span class="zenith-badge ${rider.status}">${rider.status.toUpperCase()}</span>
                </td>
                <td class="text-end fw-bold text-dark">₹${rider.periodEarnings.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</td>
                <td class="text-end fw-bold ${rider.pendingAmount > 0 ? 'text-danger' : 'text-success'}">₹${rider.pendingAmount.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</td>
                <td class="text-center pe-4">
                    ${rider.status === 'pending' || rider.status === 'failed' ?
                `<button class="btn btn-zenith-primary btn-sm pay-btn shadow-sm" data-id="${rider.id}" data-name="${rider.name}" data-amount="${rider.pendingAmount}">
                        <i class="fas fa-paper-plane me-1"></i> Pay Now
                    </button>` :
                `<button class="btn btn-secondary btn-sm rounded-pill px-3 shadow-sm border-0" style="background: #e5e7eb; color: #6b7280;" disabled><i class="fas fa-check-double me-1"></i> Paid</button>`
            }
                </td>
            </tr>
        `).join('');
    };

    const renderPagination = (data) => {
        if (paginationInfo) paginationInfo.textContent = `Showing ${data.riders.length} of ${data.totalItems} riders.`;
        if (paginationControls) paginationControls.innerHTML = '';
    };

    // --- MAIN DATA FETCH & UPDATE ---
    const updateDashboard = async () => {
        renderStats(mockStats);
        renderCurrentWeekTable(mockCurrentWeekData);
        renderHistoryTable(mockHistoryData);
        if (paginationInfo) {
            paginationInfo.textContent = `Showing 1-10 of ${mockHistoryData.length} transactions`;
        }
    };

    // --- EVENT LISTENERS ---
    // Handle new Pill Filters for Current Week
    document.querySelectorAll('.filter-pill').forEach(pill => {
        pill.addEventListener('click', (e) => {
            e.preventDefault();
            // Remove active class from all pills
            document.querySelectorAll('.filter-pill').forEach(p => {
                p.classList.remove('active', 'btn-primary', 'text-white');
                p.classList.add('text-secondary');
            });

            // Add active state to clicked pill
            const target = e.target; // In case clicking inside the a tag
            target.classList.add('active');
            target.classList.remove('text-secondary');

            const newRange = target.dataset.range;
            if (state.timeRange !== newRange) {
                state.timeRange = newRange;
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
            document.querySelectorAll('.payout-range').forEach(i => i.classList.remove('active'));
            dateRangeModal.hide();
            updateDashboard();
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