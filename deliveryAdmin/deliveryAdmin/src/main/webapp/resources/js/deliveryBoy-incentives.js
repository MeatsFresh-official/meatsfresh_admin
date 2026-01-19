document.addEventListener('DOMContentLoaded', () => {

    // --- HELPER: CURRENCY FORMATTER ---
    const formatCurrencyCompact = (amount) => {
        if (amount >= 10000000) return '₹' + (amount / 10000000).toFixed(2) + 'Cr';
        if (amount >= 100000) return '₹' + (amount / 100000).toFixed(2) + 'L';
        if (amount >= 1000) return '₹' + (amount / 1000).toFixed(1) + 'K';
        return '₹' + amount.toLocaleString('en-IN');
    };

    const showToast = (message) => {
        const toastEl = document.getElementById('successToast');
        if (toastEl) {
            document.getElementById('toastMessage').innerText = message;
            const toast = new bootstrap.Toast(toastEl);
            toast.show();
        }
    };

    // --- MOCK DATA ---
    let mockIncentives = [
        { id: 'INC001', orders: 50, slots: 5, amount: 1500.00 },
        { id: 'INC002', orders: 100, slots: 10, amount: 3500.00 },
        { id: 'INC003', orders: 25, slots: 3, amount: 500.00 }
    ];

    let mockIncentiveHistory = [
        { rider: 'Raju Kumar', plan: '50 Orders / 5 Slots', progress: 100, status: 'completed', reward: 1500.00 },
        { rider: 'Suresh Raina', plan: '100 Orders / 10 Slots', progress: 85, status: 'in_progress', reward: 3500.00 },
        { rider: 'Amit Singh', plan: '25 Orders / 3 Slots', progress: 40, status: 'in_progress', reward: 500.00 },
        { rider: 'Deepak Chahar', plan: '50 Orders / 5 Slots', progress: 100, status: 'completed', reward: 1500.00 }
    ];


    // --- RENDERING FUNCTIONS ---
    const renderIncentives = () => {
        const grid = document.getElementById('activeIncentivesGrid');
        if (!grid) return;

        if (mockIncentives.length === 0) {
            grid.innerHTML = '<div class="text-center p-5 col-12 text-muted">No active incentives. Creates one to get started.</div>';
            return;
        }

        grid.innerHTML = mockIncentives.map(inc => `
            <div class="col-md-6 mb-3">
                <div class="card h-100 border-0 shadow-sm incentive-card" style="border-radius: 12px; background: #f8fafc;">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div>
                                <h4 class="fw-bold text-dark mb-0">${formatCurrencyCompact(inc.amount)}</h4>
                                <small class="text-muted text-uppercase fw-bold" style="font-size: 0.7rem;">Incentive</small>
                            </div>
                             <div class="dropdown">
                                <button class="btn btn-sm btn-white border-0 shadow-none text-muted" type="button" data-bs-toggle="dropdown"><i class="fas fa-ellipsis-v"></i></button>
                                <ul class="dropdown-menu border-0 shadow-sm scroll-menu">
                                    <li><a class="dropdown-item text-danger delete-incentive" href="#" data-id="${inc.id}">Delete</a></li>
                                </ul>
                            </div>
                        </div>
                        <div class="d-flex gap-2">
                            <span class="badge bg-white text-primary border border-primary-subtle rounded-pill px-3 py-2"><i class="fas fa-box me-1"></i>${inc.orders} Orders</span>
                            <span class="badge bg-white text-secondary border border-secondary-subtle rounded-pill px-3 py-2"><i class="fas fa-calendar-check me-1"></i>${inc.slots} Slots</span>
                        </div>
                    </div>
                </div>
            </div>
        `).join('');

        // Attach listeners
        document.querySelectorAll('.delete-incentive').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                const id = e.target.dataset.id;
                deleteIncentive(id);
            });
        });
    };

    const deleteIncentive = (id) => {
        if (confirm('Are you sure you want to delete this incentive program?')) {
            mockIncentives = mockIncentives.filter(i => i.id !== id);
            renderIncentives();
            showToast('Incentive deleted');
        }
    };

    const renderIncentiveHistory = (filter = 'week') => {
        const tbody = document.getElementById('incentiveHistoryBody');
        if (!tbody) return;

        // Simple mock filtering logic just to show interactivity
        let data = mockIncentiveHistory;
        // In real app, we would filter 'data' based on 'filter' (week/month)

        tbody.innerHTML = data.map(item => `
            <tr class="animate-on-load">
                <td class="ps-4 fw-medium text-dark">${item.rider}</td>
                <td class="text-secondary small">${item.plan}</td>
                <td class="align-middle">
                     <div class="progress" style="height: 6px; border-radius: 10px; width: 100px; margin: 0 auto;">
                        <div class="progress-bar ${item.progress === 100 ? 'bg-success' : 'bg-primary'}" role="progressbar" style="width: ${item.progress}%" aria-valuenow="${item.progress}" aria-valuemin="0" aria-valuemax="100"></div>
                     </div>
                     <div class="text-center mt-1"><small class="text-muted" style="font-size: 0.7rem;">${item.progress}%</small></div>
                </td>
                <td class="text-center">
                    <span class="badge ${item.status === 'completed' ? 'bg-soft-success text-success' : 'bg-soft-warning text-warning'} rounded-pill" style="font-size: 0.7rem;">
                        ${item.status === 'completed' ? 'COMPLETED' : 'IN PROGRESS'}
                    </span>
                </td>
                <td class="text-end pe-4 fw-bold ${item.status === 'completed' ? 'text-success' : 'text-muted'}">
                    ${formatCurrencyCompact(item.reward)}
                </td>
            </tr>
        `).join('');
    };

    // --- FORM LISTENER ---
    const createIncentiveForm = document.getElementById('createIncentiveForm');
    if (createIncentiveForm) {
        createIncentiveForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const orders = document.getElementById('incOrderCount').value;
            const slots = document.getElementById('incSlots').value;
            const amount = document.getElementById('incAmount').value;

            if (orders && slots && amount) {
                const newInc = {
                    id: `INC${Math.floor(Math.random() * 1000)}`,
                    orders: parseInt(orders),
                    slots: parseInt(slots),
                    amount: parseFloat(amount)
                };
                mockIncentives.unshift(newInc); // Add to top
                renderIncentives();
                createIncentiveForm.reset();
                showToast('Incentive Created Successfully');
            }
        });
    }

    // --- FILTER LISTENERS ---
    document.querySelectorAll('.filter-pill').forEach(pill => {
        pill.addEventListener('click', (e) => {
            document.querySelectorAll('.filter-pill').forEach(p => p.classList.remove('btn-zenith-primary', 'active', 'text-white'));
            document.querySelectorAll('.filter-pill').forEach(p => p.classList.add('text-secondary')); // Reset

            e.target.classList.add('btn-zenith-primary', 'active', 'text-white');
            e.target.classList.remove('text-secondary');

            renderIncentiveHistory(e.target.dataset.range);
        });
    });

    // --- INITIAL LOAD ---
    renderIncentives();
    renderIncentiveHistory();

});
