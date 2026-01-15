
document.addEventListener('DOMContentLoaded', function () {

    // --- State ---
    let chartInstance = null;
    let pieInstance = null;

    // --- Init ---
    initDatePicker();
    renderDashboard();

    // --- Date Picker ---
    function initDatePicker() {
        flatpickr("#dateRangePicker", {
            mode: "range",
            dateFormat: "Y-m-d",
            defaultDate: [moment().subtract(30, 'days').format('YYYY-MM-DD'), moment().format('YYYY-MM-DD')],
            onChange: function (selectedDates) {
                if (selectedDates.length === 2) {
                    renderDashboard();
                }
            }
        });
    }

    // --- Data Generation ---
    function generateFinancialData() {
        // Mock data logic
        const revenue = Math.floor(Math.random() * 500000) + 200000;
        const commission = Math.floor(revenue * 0.15); // 15% commission
        const payVendor = Math.floor(revenue * 0.70); // 70% to vendor

        const platformFee = Math.floor(Math.random() * 10000) + 5000;
        const serviceFee = Math.floor(Math.random() * 5000) + 2000;
        const deliveryUser = Math.floor(Math.random() * 15000) + 8000;
        const deliveryPartner = Math.floor(Math.random() * 12000) + 6000;
        const gst = Math.floor(revenue * 0.05);
        const rainFee = Math.floor(Math.random() * 2000);
        const packagingFee = Math.floor(Math.random() * 5000) + 1000;

        // Net Profit = Commission + Platform + Service + DeliveryUser + Rain + Packaging - GST - DeliveryPartner
        // Simplified for demo:
        const profit = commission + platformFee + serviceFee + (deliveryUser - deliveryPartner);

        return {
            totalOrder: revenue,
            commission: commission,
            payVendor: payVendor,
            platformFee: platformFee,
            serviceFee: serviceFee,
            deliveryUser: deliveryUser,
            deliveryPartner: deliveryPartner,
            gst: gst,
            rainFee: rainFee,
            packagingFee: packagingFee,
            profit: profit
        };
    }

    function renderDashboard() {
        const data = generateFinancialData();

        // Update Text
        updateText('totalOrder', data.totalOrder);
        updateText('commission', data.commission);
        updateText('payVendor', data.payVendor);
        updateText('profit', data.profit);

        updateText('platformFee', data.platformFee);
        updateText('serviceFee', data.serviceFee);
        updateText('deliveryUser', data.deliveryUser);
        updateText('deliveryPartner', data.deliveryPartner);
        updateText('gst', data.gst);
        updateText('rainFee', data.rainFee);
        updateText('packagingFee', data.packagingFee);

        updateText('piePlatform', data.platformFee);
        updateText('pieService', data.serviceFee);
        updateText('pieDelivery', data.deliveryUser);

        // Render Charts
        renderTrendChart();
        renderBreakdownChart(data);
    }

    function updateText(id, value) {
        const el = document.getElementById(id);
        if (el) el.innerText = '₹' + value.toLocaleString('en-IN');
    }

    // --- Charts ---
    function renderTrendChart() {
        const ctx = document.getElementById('revenueChart').getContext('2d');

        // Mock Labels (last 7 days)
        const labels = Array.from({ length: 7 }, (_, i) => moment().subtract(6 - i, 'days').format('MMM D'));

        const revenueData = labels.map(() => Math.floor(Math.random() * 50000) + 10000);
        const profitData = revenueData.map(r => Math.floor(r * 0.2));

        if (chartInstance) chartInstance.destroy();

        chartInstance = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'Revenue',
                        data: revenueData,
                        borderColor: '#3b82f6',
                        backgroundColor: 'rgba(59, 130, 246, 0.1)',
                        tension: 0.4,
                        fill: true
                    },
                    {
                        label: 'Net Profit',
                        data: profitData,
                        borderColor: '#10b981',
                        backgroundColor: 'rgba(16, 185, 129, 0.1)',
                        tension: 0.4,
                        fill: true
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'top' }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: { borderDash: [2, 2] }
                    },
                    x: {
                        grid: { display: false }
                    }
                }
            }
        });
    }

    function renderBreakdownChart(data) {
        const ctx = document.getElementById('breakdownChart').getContext('2d');

        if (pieInstance) pieInstance.destroy();

        pieInstance = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Platform Fees', 'Service Fees', 'Delivery Fees'],
                datasets: [{
                    data: [data.platformFee, data.serviceFee, data.deliveryUser],
                    backgroundColor: ['#3b82f6', '#6366f1', '#10b981'],
                    borderWidth: 0,
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '70%',
                plugins: {
                    legend: { display: false }
                }
            }
        });
    }

    // --- Export ---
    document.getElementById("printProfitBtn").onclick = () => window.print();

    document.getElementById("downloadProfitPdfBtn").onclick = () => {
        const element = document.getElementById('profitContent');
        const opt = {
            margin: 0.5,
            filename: 'profit_report_' + moment().format('YYYY-MM-DD') + '.pdf',
            image: { type: 'jpeg', quality: 0.98 },
            html2canvas: { scale: 2 },
            jsPDF: { unit: 'in', format: 'letter', orientation: 'landscape' }
        };
        // Simple check if html2pdf is available or use custom logic
        // Since we imported jspdf/html2canvas manually in JSP:
        html2canvas(element).then(canvas => {
            const imgData = canvas.toDataURL('image/png');
            const { jsPDF } = window.jspdf;
            const pdf = new jsPDF('l', 'mm', 'a4');
            const imgProps = pdf.getImageProperties(imgData);
            const pdfWidth = pdf.internal.pageSize.getWidth();
            const pdfHeight = (imgProps.height * pdfWidth) / imgProps.width;
            pdf.addImage(imgData, 'PNG', 0, 0, pdfWidth, pdfHeight);
            pdf.save('profit_report.pdf');
        });
    };

});
