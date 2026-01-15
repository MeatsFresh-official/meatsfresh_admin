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

                <!-- Tailwind CSS (for compatibility with existing Zenith styles if needed) -->
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
                        <div class="flex-grow-1" style="margin-left: 260px; min-height: 100vh;">

                            <!-- Main Container -->
                            <div class="main-content">

                                <!-- Header -->
                                <div class="d-flex justify-content-between align-items-end mb-5 animate-enter">
                                    <div>
                                        <h1 class="page-title">Banner Management</h1>
                                        <p class="page-subtitle">Manage your app's marketing banners and promotional
                                            visuals.</p>
                                        <p class="text-xs text-secondary mt-1"><i class="fas fa-info-circle me-1"></i>
                                            Demo Mode Active</p>
                                        <script>console.log("Banners Page Loaded (JSP v1.1)");</script>
                                    </div>
                                </div>

                                <!-- Upload Section -->
                                <div class="glass-panel mb-5 animate-enter" style="animation-delay: 0.1s;">
                                    <div class="upload-zone" id="uploadZone">
                                        <input type="file" id="fileInput" hidden accept="image/*">
                                        <div class="upload-content">
                                            <i class="fas fa-cloud-upload-alt upload-icon"></i>
                                            <div class="upload-text">
                                                <h5>Click or Drag & Drop to Upload</h5>
                                                <p>Supports JPG, PNG, WEBP (Max 5MB)</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Gallery Section -->
                                <div class="glass-panel animate-enter" style="animation-delay: 0.2s;">
                                    <div class="d-flex justify-content-between align-items-center mb-4">
                                        <h4 class="m-0 font-bold text-gray-800">Active Banners</h4>
                                        <button class="btn btn-outline-primary btn-sm rounded-pill px-3"
                                            onclick="loadBanners()">
                                            <i class="fas fa-sync-alt me-1"></i> Refresh
                                        </button>
                                    </div>

                                    <div id="bannerGrid" class="banner-grid">
                                        <!-- Banners will be loaded here via JS -->
                                    </div>
                                </div>

                            </div>
                        </div>
                </div>

                <!-- Scripts -->
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/resources/js/banners.js"></script>
            </body>

            </html>