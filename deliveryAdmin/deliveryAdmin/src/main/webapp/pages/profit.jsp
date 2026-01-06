<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/includes/header.jsp" %>

<main class="main-content">
    <div class="container-fluid">

        <!-- PAGE HEADER -->
        <div class="page-header py-3 d-flex justify-content-between align-items-center">
            <h1 class="m-0">Profit Report</h1>
            <div>
                <button class="btn btn-outline-secondary" id="printProfitBtn">
                    <i class="fas fa-print me-2"></i>Print
                </button>
                <button class="btn btn-primary" id="downloadProfitPdfBtn">
                    <i class="fas fa-file-pdf me-2"></i>Download PDF
                </button>
            </div>
        </div>

        <!-- FILTER CARD -->
        <div class="card mb-4">
            <div class="card-header py-3">
                <h4 class="m-0"><i class="fas fa-filter me-2"></i>Filters</h4>
            </div>
            <div class="card-body d-flex flex-wrap gap-2">
                <button class="btn btn-outline-primary" onclick="applyFilter('today')">Today</button>
                <button class="btn btn-outline-primary" onclick="applyFilter('yesterday')">Yesterday</button>
                <button class="btn btn-outline-primary" onclick="applyFilter('week')">This Week</button>
                <button class="btn btn-outline-primary" onclick="applyFilter('month')">This Month</button>
                <button class="btn btn-outline-primary" onclick="applyFilter('year')">This Year</button>

                <input type="date" class="form-control w-auto" id="fromDate">
                <input type="date" class="form-control w-auto" id="toDate">
                <button class="btn btn-primary" onclick="applyCustom()">Apply</button>
            </div>
        </div>

        <!-- PROFIT CARDS -->
        <div class="row" id="profitContent">

            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                <div class="card shadow h-100">
                    <div class="card-body">
                        <h6 class="text-muted">Total Order Amount</h6>
                        <h4 id="totalOrder">₹0</h4>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                <div class="card shadow h-100">
                    <div class="card-body">
                        <h6 class="text-muted">Platform Fee</h6>
                        <h4 id="platformFee">₹0</h4>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                <div class="card shadow h-100">
                    <div class="card-body">
                        <h6 class="text-muted">Delivery Fee (Users)</h6>
                        <h4 id="deliveryUser">₹0</h4>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                <div class="card shadow h-100">
                    <div class="card-body">
                        <h6 class="text-muted">Service Fee</h6>
                        <h4 id="serviceFee">₹0</h4>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                <div class="card shadow h-100">
                    <div class="card-body">
                        <h6 class="text-muted">Pay To Vendor</h6>
                        <h4 id="payVendor">₹0</h4>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                <div class="card shadow h-100">
                    <div class="card-body">
                        <h6 class="text-muted">Commission</h6>
                        <h4 id="commission">₹0</h4>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                <div class="card shadow h-100">
                    <div class="card-body">
                        <h6 class="text-muted">GST</h6>
                        <h4 id="gst">₹0</h4>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                <div class="card shadow h-100">
                    <div class="card-body">
                        <h6 class="text-muted">Rain Fee</h6>
                        <h4 id="rainFee">₹0</h4>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                <div class="card shadow h-100">
                    <div class="card-body">
                        <h6 class="text-muted">Packaging Fee</h6>
                        <h4 id="packagingFee">₹0</h4>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                <div class="card shadow h-100">
                    <div class="card-body">
                        <h6 class="text-muted">Delivery Fee (Partner)</h6>
                        <h4 id="deliveryPartner">₹0</h4>
                    </div>
                </div>
            </div>

            <!-- PROFIT -->
            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                <div class="card bg-success text-white shadow h-100">
                    <div class="card-body">
                        <h5>PROFIT</h5>
                        <h3 id="profit">₹0</h3>
                    </div>
                </div>
            </div>

        </div>

    </div>
</main>

<%@ include file="/includes/footer.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>

<script>
    function applyFilter(type) {
        console.log("Filter:", type);
        loadData(mockData());
    }

    function applyCustom() {
        const from = document.getElementById("fromDate").value;
        const to = document.getElementById("toDate").value;
        if (!from || !to) {
            alert("Select both dates");
            return;
        }
        loadData(mockData());
    }

    function loadData(d) {
        totalOrder.innerText = `₹${d.totalOrder}`;
        platformFee.innerText = `₹${d.platformFee}`;
        deliveryUser.innerText = `₹${d.deliveryUser}`;
        serviceFee.innerText = `₹${d.serviceFee}`;
        payVendor.innerText = `₹${d.payVendor}`;
        commission.innerText = `₹${d.commission}`;
        gst.innerText = `₹${d.gst}`;
        rainFee.innerText = `₹${d.rainFee}`;
        packagingFee.innerText = `₹${d.packagingFee}`;
        deliveryPartner.innerText = `₹${d.deliveryPartner}`;
        profit.innerText = `₹${d.profit}`;
    }

    function mockData() {
        return {
            totalOrder: 125000,
            platformFee: 5000,
            deliveryUser: 8000,
            serviceFee: 3000,
            payVendor: 85000,
            commission: 10000,
            gst: 4500,
            rainFee: 1200,
            packagingFee: 2500,
            deliveryPartner: 7000,
            profit: 9800
        };
    }

    loadData(mockData());

    document.getElementById("printProfitBtn").onclick = () => window.print();

    document.getElementById("downloadProfitPdfBtn").onclick = () => {
        html2canvas(document.getElementById("profitContent")).then(canvas => {
            const pdf = new jspdf.jsPDF();
            pdf.addImage(canvas.toDataURL("image/png"), "PNG", 10, 10, 190, 0);
            pdf.save("profit-report.pdf");
        });
    };
</script>
