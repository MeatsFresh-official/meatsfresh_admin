<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Banner Management | Admin</title>

                <!-- Dependencies -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">

                <!-- Custom CSS -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard-zenith.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/banners.css">

                <!-- Tailwind CSS -->
                <script src="https://cdn.tailwindcss.com"></script>
                <script>
                    tailwind.config = {
                        theme: {
                            extend: {
                                colors: {
                                    primary: '#4f46e5',
                                    secondary: '#6b7280',
                                    glass: 'rgba(255, 255, 255, 0.95)'
                                },
                                fontFamily: {
                                    sans: ['Inter', 'sans-serif'],
                                }
                            }
                        }
                    }
                </script>
            </head>

            <body class="bg-gray-50 text-gray-800">

                <div class="d-flex">
                    <!-- Sidebar -->
                    <%@ include file="/includes/sidebar.jsp" %>

                        <!-- Main Content -->
                        <div class="flex-grow-1" style="min-height: 100vh;">

                            <!-- Main Container -->
                            <div class="main-content">

                                <!-- Header -->
                                <div class="d-flex justify-content-between align-items-end mb-5 animate-enter">
                                    <div>
                                        <h1 class="page-title">Banner Management</h1>
                                        <p class="page-subtitle">Manage promotional visuals for Vendors and Delivery
                                            Partners.</p>
                                        <p class="text-xs text-secondary mt-1"><i class="fas fa-info-circle me-1"></i>
                                            Demo Mode Active</p>
                                    </div>
                                </div>

                                <!-- SECTIONS CONTAINER -->
                                <div class="space-y-12">

                                    <!-- SECTION 1: VENDOR BANNERS -->
                                    <section id="vendorSection" class="animate-enter" style="animation-delay: 0.1s;">
                                        <h2 class="text-2xl font-bold mb-4 text-gray-800 flex items-center gap-2">
                                            <span class="p-2 bg-blue-100 rounded-lg text-blue-600"><i
                                                    class="fas fa-store"></i></span>
                                            Vendor Banners
                                        </h2>

                                        <!-- Vendor Upload -->
                                        <div class="glass-panel mb-4 p-0 overflow-hidden">
                                            <div class="upload-zone" id="uploadZoneVendor"
                                                onclick="document.getElementById('fileInputVendor').click()">
                                                <input type="file" id="fileInputVendor" hidden accept="image/*">
                                                <div class="upload-content">
                                                    <i class="fas fa-cloud-upload-alt upload-icon text-blue-500"></i>
                                                    <div class="upload-text">
                                                        <h5>Upload Vendor Banner</h5>
                                                        <p>Click or Drag & Drop (Max 5MB)</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Vendor Grid -->
                                        <div class="glass-panel">
                                            <div class="d-flex justify-content-between align-items-center mb-4">
                                                <h4
                                                    class="m-0 font-bold text-gray-800 text-sm uppercase tracking-wider">
                                                    Active Vendor Banners</h4>
                                                <span class="badge bg-blue-100 text-blue-800 px-3 py-1 rounded-full"
                                                    id="vendorCount">0 Active</span>
                                            </div>
                                            <div id="vendorGrid" class="banner-grid">
                                                <!-- JS Injected -->
                                            </div>
                                        </div>
                                    </section>


                                    <!-- SECTION 2: DELIVERY PARTNER BANNERS -->
                                    <section id="partnerSection" class="animate-enter" style="animation-delay: 0.2s;">
                                        <h2 class="text-2xl font-bold mb-4 text-gray-800 flex items-center gap-2">
                                            <span class="p-2 bg-green-100 rounded-lg text-green-600"><i
                                                    class="fas fa-motorcycle"></i></span>
                                            Delivery Partner Banners
                                        </h2>

                                        <!-- Partner Upload -->
                                        <div class="glass-panel mb-4 p-0 overflow-hidden">
                                            <div class="upload-zone" id="uploadZonePartner"
                                                onclick="document.getElementById('fileInputPartner').click()">
                                                <input type="file" id="fileInputPartner" hidden accept="image/*">
                                                <div class="upload-content">
                                                    <i class="fas fa-cloud-upload-alt upload-icon text-green-500"></i>
                                                    <div class="upload-text">
                                                        <h5>Upload Partner Banner</h5>
                                                        <p>Click or Drag & Drop (Max 5MB)</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Partner Grid -->
                                        <div class="glass-panel">
                                            <div class="d-flex justify-content-between align-items-center mb-4">
                                                <h4
                                                    class="m-0 font-bold text-gray-800 text-sm uppercase tracking-wider">
                                                    Active Partner Banners</h4>
                                                <span class="badge bg-green-100 text-green-800 px-3 py-1 rounded-full"
                                                    id="partnerCount">0 Active</span>
                                            </div>
                                            <div id="partnerGrid" class="banner-grid">
                                                <!-- JS Injected -->
                                            </div>
                                        </div>
                                        <!-- Hidden Input for Updating Banners -->
                                        <input type="file" id="updateFileInput" hidden accept="image/*">

                                    </section>

                                </div>
                                <!-- END SECTIONS CONTAINER -->

                            </div>
                        </div>
                </div>

                <!-- Scripts -->
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/resources/js/banners.js"></script>
            </body>

            </html>