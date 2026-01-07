
document.addEventListener('DOMContentLoaded', function () {

    // --- State ---
    let currentTab = 'users';

    // --- Init ---
    initData();
    renderCurrentTab();

    // --- Tabs Logic ---
    window.switchTab = function (tabName) {
        currentTab = tabName;

        // Update UI Tabs
        document.querySelectorAll('.report-tab').forEach(t => t.classList.remove('active'));
        const activeTab = Array.from(document.querySelectorAll('.report-tab'))
            .find(t => t.innerText.toLowerCase().includes(tabName === 'deliveries' ? 'delivery' : tabName.slice(0, -1)));
        if (activeTab) activeTab.classList.add('active');

        // Show/Hide Sections
        document.getElementById('usersSection').classList.add('hidden');
        document.getElementById('vendorsSection').classList.add('hidden');
        document.getElementById('deliveriesSection').classList.add('hidden');

        const section = document.getElementById(`${tabName}Section`);
        if (section) {
            section.classList.remove('hidden');
            section.classList.add('animate-fade-in');
        }
    };

    // --- Data Generation ---
    function initData() {
        renderUsersTable();
        renderVendorsTable();
        renderDeliveriesTable();
    }

    function renderUsersTable() {
        const tbody = document.getElementById('usersTableBody');
        let html = '';
        for (let i = 0; i < 15; i++) {
            const id = 1000 + i;
            const name = `User ${i + 1}`;
            const email = `user${i + 1}@example.com`;
            const date = moment().subtract(i, 'days').format('YYYY-MM-DD');
            const status = i % 5 === 0 ? 'inactive' : 'active';
            const badgeClass = status === 'active' ? 'badge-success' : 'badge-danger';

            html += `
                <tr>
                    <td class="font-mono text-xs">#USR-${id}</td>
                    <td class="font-medium">${name}</td>
                    <td class="text-gray-500">${email}</td>
                    <td><span class="text-xs bg-gray-100 px-2 py-1 rounded">Customer</span></td>
                    <td><span class="badge ${badgeClass}">${status.toUpperCase()}</span></td>
                    <td class="text-gray-500 text-sm">${date}</td>
                </tr>
            `;
        }
        tbody.innerHTML = html;
        document.getElementById('usersCount').innerText = 'Showing 15 latest users';
    }

    function renderVendorsTable() {
        const tbody = document.getElementById('vendorsTableBody');
        let html = '';
        const stores = ['Meat King', 'Fresh Farm', 'City Butcher', 'Organic Meats', 'Sea Catch'];

        for (let i = 0; i < 10; i++) {
            const id = 500 + i;
            const store = stores[i % stores.length] + ' ' + (i + 1);
            const rating = (4 + Math.random()).toFixed(1);

            html += `
                <tr>
                    <td class="font-mono text-xs">#VND-${id}</td>
                    <td class="font-medium text-indigo-600">${store}</td>
                    <td>Owner ${i + 1}</td>
                    <td><span class="text-yellow-500"><i class="fas fa-star mr-1"></i>${rating}</span></td>
                    <td><span class="badge badge-success">VERIFIED</span></td>
                    <td class="text-gray-500 text-sm">${moment().subtract(i * 10, 'days').format('MMM D, YYYY')}</td>
                </tr>
            `;
        }
        tbody.innerHTML = html;
        document.getElementById('vendorsCount').innerText = 'Showing 10 active vendors';
    }

    function renderDeliveriesTable() {
        const tbody = document.getElementById('deliveriesTableBody');
        let html = '';

        for (let i = 0; i < 12; i++) {
            const id = 200 + i;
            const name = `Rider ${i + 1}`;
            const deliveries = Math.floor(Math.random() * 500) + 50;
            const status = i % 4 === 0 ? 'Busy' : 'Available';
            const badgeClass = status === 'Available' ? 'badge-success' : 'badge-warning';

            html += `
                <tr>
                    <td class="font-mono text-xs">#DLV-${id}</td>
                    <td class="font-medium">${name}</td>
                    <td>${deliveries} Orders</td>
                    <td><span class="text-yellow-500"><i class="fas fa-star mr-1"></i>4.8</span></td>
                    <td><span class="badge ${badgeClass}">${status.toUpperCase()}</span></td>
                    <td class="text-gray-500"><i class="fas fa-motorcycle mr-2"></i>Bike</td>
                </tr>
            `;
        }
        tbody.innerHTML = html;
        document.getElementById('deliveriesCount').innerText = 'Showing 12 partners';
    }

    // --- Search ---
    document.getElementById('searchInput').addEventListener('input', function (e) {
        const term = e.target.value.toLowerCase();
        // Simple search implementation for demo (would normally re-filter data arrays)
        document.querySelectorAll('tbody tr').forEach(row => {
            row.style.display = row.innerText.toLowerCase().includes(term) ? '' : 'none';
        });
    });

    // --- PDF Export ---
    document.getElementById('downloadPdfBtn').onclick = () => {
        const element = document.getElementById('reportsContent');
        html2canvas(element).then(canvas => {
            const imgData = canvas.toDataURL('image/png');
            const { jsPDF } = window.jspdf;
            const pdf = new jsPDF('p', 'mm', 'a4');
            const imgProps = pdf.getImageProperties(imgData);
            const pdfWidth = pdf.internal.pageSize.getWidth();
            const pdfHeight = (imgProps.height * pdfWidth) / imgProps.width;
            pdf.addImage(imgData, 'PNG', 0, 0, pdfWidth, pdfHeight);
            pdf.save(`report-${currentTab}.pdf`);
        });
    };

});