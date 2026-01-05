<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/includes/header.jsp" %>

<div class="container mt-4">
    <h2 class="text-center mb-4">Fee Distribution</h2>

    <div class="text-center mb-3">
        <button class="btn btn-primary me-2" onclick="updateChart('today')">Today</button>
        <button class="btn btn-primary me-2" onclick="updateChart('weekly')">Weekly</button>
        <button class="btn btn-primary me-2" onclick="updateChart('monthly')">Monthly</button>
        <button class="btn btn-primary me-2" onclick="updateChart('yearly')">This Year</button>
    </div>

    <div class="card p-3 mx-auto" style="max-width: 500px;">
        <canvas id="feePieChart"></canvas>
    </div>
</div>

<script>
$(document).ready(function () {

    const feeData = {
        today: [120, 80, 150, 40, 60],
        weekly: [900, 650, 1100, 300, 450],
        monthly: [4000, 3200, 5200, 1200, 1800],
        yearly: [48000, 36000, 62000, 14000, 20000]
    };

    const labels = [
        "Platform Fee",
        "Packaging Fee",
        "Service Fee",
        "Rain Fee",
        "Donation"
    ];

    const canvas = document.getElementById("feePieChart");

    if (!canvas) {
        console.error("Canvas not found");
        return;
    }

    window.pieChart = new Chart(canvas, {
        type: "pie",
        data: {
            labels: labels,
            datasets: [{
                data: feeData.today,
                backgroundColor: [
                    "#FF6384",
                    "#36A2EB",
                    "#FFCE56",
                    "#4BC0C0",
                    "#9966FF"
                ]
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: "bottom"
                }
            }
        }
    });

    window.updateChart = function (filter) {
        pieChart.data.datasets[0].data = feeData[filter];
        pieChart.update();
    };
});
</script>

<%@ include file="/includes/footer.jsp" %>
