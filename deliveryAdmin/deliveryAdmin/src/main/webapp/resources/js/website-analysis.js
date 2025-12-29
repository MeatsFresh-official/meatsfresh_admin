document.addEventListener("DOMContentLoaded", function () {
    // ===== Time Range Dropdown Handling =====
    const timeRangeBtn = document.getElementById("globalTimeRange");
    const timeRangeItems = document.querySelectorAll(".global-time-range");
    const applyBtn = document.getElementById("applyDateRange");

    timeRangeItems.forEach(item => {
        item.addEventListener("click", (e) => {
            e.preventDefault();
            const range = item.dataset.range;
            const label = item.textContent.trim();
            timeRangeBtn.innerHTML = `<i class="fas fa-clock me-1"></i> ${label}`;

            updateWebsiteAnalysisData({ preset: range });
        });
    });

    applyBtn.addEventListener("click", () => {
        const startDate = document.getElementById("startDate").value;
        const endDate = document.getElementById("endDate").value;

        if (!startDate || !endDate || new Date(startDate) > new Date(endDate)) {
            alert("Please select a valid date range.");
            return;
        }

        const rangeLabel = `${startDate} to ${endDate}`;
        timeRangeBtn.innerHTML = `<i class="fas fa-clock me-1"></i> ${rangeLabel}`;

        const modal = bootstrap.Modal.getInstance(document.getElementById("dateRangeModal"));
        modal.hide();

        updateWebsiteAnalysisData({ startDate, endDate });
    });

    // ===== Dummy Update Function (simulate AJAX/backend integration) =====
    function updateWebsiteAnalysisData(params) {
        console.log("Website analysis data requested for:", params);

        // Simulate updating stats
        document.getElementById("totalVisitors").textContent = "9.2k";
        document.getElementById("totalCustomers").textContent = "6.7k";
        document.getElementById("bounceRate").textContent = "39%";

        updateCharts();
    }

    // ===== Chart.js Initialization =====
    const visitorsChart = new Chart(document.getElementById("visitorsChart").getContext("2d"), {
        type: "line",
        data: {
            labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
            datasets: [{
                label: "Visitors",
                data: [800, 950, 700, 1100, 1300, 1250, 1000],
                borderColor: "#36A2EB",
                backgroundColor: "rgba(54,162,235,0.2)",
                borderWidth: 2,
                tension: 0.3,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });

    const osChart = new Chart(document.getElementById("osChart").getContext("2d"), {
        type: "doughnut",
        data: {
            labels: ["Windows", "macOS", "Linux", "iOS", "Android"],
            datasets: [{
                data: [40, 25, 10, 15, 10],
                backgroundColor: ["#007bff", "#6f42c1", "#28a745", "#ffc107", "#dc3545"]
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: "bottom"
                }
            }
        }
    });

    function updateCharts() {
        visitorsChart.data.datasets[0].data = [900, 1000, 750, 1150, 1400, 1300, 1100];
        visitorsChart.update();

        osChart.data.datasets[0].data = [38, 26, 12, 14, 10];
        osChart.update();
    }
});
