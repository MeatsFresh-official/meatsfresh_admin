<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/includes/header.jsp" %>

        <main class="main-content">
            <!-- Toast Notification Container -->
            <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">
                <div id="successToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="toast-header bg-success text-white">
                        <i class="fas fa-check-circle me-2"></i>
                        <strong class="me-auto">Success</strong>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"
                            aria-label="Close"></button>
                    </div>
                    <div class="toast-body" id="toastMessage"></div>
                </div>
            </div>

            <div class="container-fluid px-4 py-4">

                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1 class="h3 mb-0 text-gray-800">Categories Management</h1>
                    <button class="btn btn-primary btn-lg" data-bs-toggle="modal" data-bs-target="#categoryModal"
                        onclick="prepareAddCategory()">
                        <i class="fas fa-plus me-2"></i>Add New Category
                    </button>
                </div>

                <!-- Loading Spinner -->
                <div id="loading-spinner" class="text-center py-5">
                    <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2 text-muted">Loading Categories...</p>
                </div>

                <!-- Main Content (Hidden initially) -->
                <div id="page-content" class="d-none animate-fade-in-up">

                    <!-- Stats Cards -->
                    <div class="row mb-4">
                        <!-- Total -->
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card bg-primary text-white h-100 shadow">
                                <div class="card-body d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="mb-0 text-white-50">Total Categories</h6>
                                        <h3 class="mb-0 fw-bold" id="stat-total-categories">0</h3>
                                    </div>
                                    <i class="fas fa-tags fa-2x opacity-50"></i>
                                </div>
                            </div>
                        </div>

                        <!-- Avg Commission -->
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card bg-success text-white h-100 shadow">
                                <div class="card-body d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="mb-0 text-white-50">Avg. Commission</h6>
                                        <h3 class="mb-0 fw-bold" id="stat-avg-commission">0%</h3>
                                    </div>
                                    <i class="fas fa-percentage fa-2x opacity-50"></i>
                                </div>
                            </div>
                        </div>

                        <!-- No Image -->
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card bg-warning text-white h-100 shadow">
                                <div class="card-body d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="mb-0 text-white-50">No Image</h6>
                                        <h3 class="mb-0 fw-bold" id="stat-no-image">0</h3>
                                    </div>
                                    <i class="fas fa-image fa-2x opacity-50"></i>
                                </div>
                            </div>
                        </div>

                        <!-- Top Commission -->
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card bg-info text-white h-100 shadow">
                                <div class="card-body d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="mb-0 text-white-50">Top Commission</h6>
                                        <h3 class="mb-0 fw-bold" id="stat-top-commission">0%</h3>
                                    </div>
                                    <i class="fas fa-chart-line fa-2x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Content Card -->
                    <!-- Modern/Native UI Content Section -->
                    <div class="glass-container mt-2 animate-fade-in-up delay-200">
                        <div
                            class="d-flex flex-column flex-md-row justify-content-between align-items-center p-4 border-bottom border-light-subtle">
                            <div>
                                <h4 class="mb-1 text-dark fw-bolder tracking-tight">All Categories</h4>
                                <p class="text-muted small mb-0">Manage your product catalog structure</p>
                            </div>

                            <!-- Modern Floating Action Bar -->
                            <div class="d-flex align-items-center gap-3 mt-3 mt-md-0 w-100 w-md-auto">
                                <div class="search-pill-container flex-grow-1 flex-md-grow-0">
                                    <i class="fas fa-search text-gray-400"></i>
                                    <input type="text" id="search-input" class="search-pill-input"
                                        placeholder="Search...">
                                </div>
                                <div class="sort-dropdown-container">
                                    <select id="sort-select" class="sort-select-modern">
                                        <option value="name-asc">A-Z</option>
                                        <option value="name-desc">Z-A</option>
                                        <option value="comm-desc">Highest %</option>
                                        <option value="comm-asc">Lowest %</option>
                                    </select>
                                    <i class="fas fa-chevron-down text-gray-400 ms-2" style="font-size: 0.7rem;"></i>
                                </div>
                            </div>
                        </div>

                        <!-- Modern Table -->
                        <div class="p-2">
                            <!-- Modern Box Grid -->
                            <div class="p-4 bg-light-subtle rounded-bottom-4">
                                <div id="categories-grid" class="row g-4">
                                    <!-- JS Injected Cards -->
                                </div>

                                <!-- Empty State -->
                                <div id="no-results" class="text-center py-5 d-none w-100">
                                    <div class="empty-state-icon mb-3">
                                        <i class="fas fa-search fa-lg"></i>
                                    </div>
                                    <h6 class="text-dark fw-bold">No results found</h6>
                                    <p class="text-muted small">Adjust your filters and try again.</p>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </main>

        <!-- Modal -->
        <div class="modal fade" id="categoryModal" tabindex="-1" aria-labelledby="categoryModalLabel" aria-hidden="true"
            data-bs-backdrop="static">
            <div class="modal-dialog modal-dialog-centered">
                <form class="modal-content" id="categoryForm">
                    <div class="modal-header">
                        <h5 class="modal-title" id="categoryModalLabel">Add New Category</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="categoryId" name="categoryId">

                        <div class="mb-4 text-center">
                            <label class="form-label d-block fw-bold text-muted small text-uppercase">Category
                                Image</label>
                            <div class="position-relative d-inline-block" style="width: 120px; height: 120px;">
                                <img id="image-preview" src="https://via.placeholder.com/120?text=Upload"
                                    class="img-thumbnail w-100 h-100 object-fit-cover rounded-circle shadow-sm cursor-pointer"
                                    onclick="document.getElementById('categoryImage').click()">
                                <button type="button"
                                    class="btn btn-sm btn-primary position-absolute bottom-0 end-0 rounded-circle shadow-sm"
                                    style="width: 32px; height: 32px; padding: 0;"
                                    onclick="document.getElementById('categoryImage').click()">
                                    <i class="fas fa-camera text-xs"></i>
                                </button>
                            </div>
                            <input type="file" class="form-control d-none" id="categoryImage" name="image"
                                accept="image/*">
                            <div class="form-text mt-2 small">Click image to upload</div>
                        </div>

                        <div class="mb-3">
                            <label for="categoryName" class="form-label">Category Name <span
                                    class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="categoryName" name="name" required
                                placeholder="e.g. Dairy Products">
                        </div>
                        <div class="mb-3">
                            <label for="categoryCommission" class="form-label">Commission (%) <span
                                    class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="categoryCommission" name="commission"
                                    step="0.01" min="0" max="100" required placeholder="0">
                                <span class="input-group-text">%</span>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" onclick="saveCategory()" class="btn btn-primary" id="saveCategoryBtn">
                            <span class="spinner-border spinner-border-sm d-none" role="status"
                                aria-hidden="true"></span>
                            Save Category
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <style>
            /* Premium Design System for Categories Page */
            :root {
                --primary-gradient: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
                --success-gradient: linear-gradient(135deg, #10b981 0%, #059669 100%);
                --warning-gradient: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
                --info-gradient: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
                --glass-bg: rgba(255, 255, 255, 0.95);
                --glass-border: 1px solid rgba(255, 255, 255, 0.5);
            }

            body {
                background-color: #f3f4f6;
                /* Soft gray background */
                font-family: 'Inter', system-ui, -apple-system, sans-serif;
            }

            .main-content {
                padding-bottom: 4rem;
            }

            /* Animations */
            .animate-fade-in-up {
                animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Stats Cards - Premium */
            .card.bg-primary {
                background: var(--primary-gradient) !important;
                border: none;
            }

            .card.bg-success {
                background: var(--success-gradient) !important;
                border: none;
            }

            .card.bg-warning {
                background: var(--warning-gradient) !important;
                border: none;
            }

            .card.bg-info {
                background: var(--info-gradient) !important;
                border: none;
            }

            .card.shadow {
                box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05) !important;
                border-radius: 1rem;
                transition: transform 0.3s ease;
            }

            .card.shadow:hover {
                transform: translateY(-5px);
            }

            .card-body h3 {
                font-size: 2rem;
                letter-spacing: -0.025em;
            }

            .opacity-50 {
                opacity: 0.3 !important;
            }

            /* Content Card & Table - Glassmorphismish */
            .card-header {
                background: #fff;
                border-bottom: 1px solid #f3f4f6;
                padding: 1.5rem;
                border-top-left-radius: 1rem !important;
                border-top-right-radius: 1rem !important;
            }

            /* Table Styling */
            .table-responsive {
                border-radius: 0 0 1rem 1rem;
                overflow: hidden;
            }

            .table thead th {
                background-color: #f9fafb;
                color: #6b7280;
                text-transform: uppercase;
                font-size: 0.75rem;
                letter-spacing: 0.05em;
                font-weight: 600;
                padding: 1rem;
                border-bottom: 1px solid #e5e7eb;
            }

            .table tbody td {
                padding: 1rem;
                vertical-align: middle;
                border-bottom: 1px solid #f3f4f6;
                color: #111827;
                font-weight: 500;
                font-size: 0.95rem;
            }

            .table-hover tbody tr:hover {
                background-color: #f9fafb;
            }

            /* Image Thumbnail */
            .img-thumbnail {
                border-radius: 0.75rem !important;
                border: 2px solid #fff;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                padding: 0;
            }

            /* Badges */
            .badge {
                padding: 0.5em 0.75em;
                border-radius: 0.5rem;
                font-weight: 600;
                letter-spacing: 0.025em;
            }

            .badge.bg-light {
                background-color: #eef2ff !important;
                color: #4f46e5 !important;
                border: 1px solid #c7d2fe !important;
            }

            /* Modal Styling */
            .modal-content {
                border: none;
                border-radius: 1.5rem;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            }

            .modal-header {
                border-bottom: 1px solid #f3f4f6;
                padding: 1.5rem 2rem;
                border-radius: 1.5rem 1.5rem 0 0;
            }

            .modal-body {
                padding: 2rem;
            }

            .modal-footer {
                border-top: 1px solid #f3f4f6;
                padding: 1.5rem 2rem;
                border-radius: 0 0 1.5rem 1.5rem;
            }

            /* Form Inputs */
            .form-control,
            .form-select {
                border-radius: 0.75rem;
                padding: 0.75rem 1rem;
                border-color: #e5e7eb;
                box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            }

            .form-control:focus,
            .form-select:focus {
                border-color: #6366f1;
                box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
            }

            /* Buttons */
            .btn-primary {
                background: var(--primary-gradient);
                border: none;
                box-shadow: 0 4px 6px -1px rgba(79, 70, 229, 0.4);
                font-weight: 600;
                padding: 0.75rem 1.5rem;
                border-radius: 0.75rem;
                transition: all 0.2s;
            }

            .btn-primary:hover {
                transform: translateY(-1px);
                box-shadow: 0 10px 15px -3px rgba(79, 70, 229, 0.4);
            }

            .btn-sm {
                padding: 0.4rem 0.8rem;
                border-radius: 0.5rem;
                font-size: 0.85rem;
            }

            /* --- Modern Native UI Styles --- */

            .glass-container {
                background: #fff;
                border-radius: 1.5rem;
                box-shadow: 0 20px 40px -10px rgba(0, 0, 0, 0.05);
                border: 1px solid rgba(0, 0, 0, 0.02);
                overflow: hidden;
            }

            .tracking-tight {
                letter-spacing: -0.025em;
            }

            /* Search Pill */
            .search-pill-container {
                display: flex;
                align-items: center;
                background: #f8fafc;
                border-radius: 100px;
                /* Full pill */
                padding: 0.5rem 1rem;
                border: 1px solid #e2e8f0;
                transition: all 0.2s ease;
                min-width: 240px;
            }

            .search-pill-container:focus-within {
                background: #fff;
                border-color: #6366f1;
                box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            }

            .search-pill-input {
                border: none;
                background: transparent;
                margin-left: 0.5rem;
                width: 100%;
                font-size: 0.9rem;
                outline: none;
                color: #334155;
            }

            .search-pill-input::placeholder {
                color: #94a3b8;
            }

            /* Sort Dropdown - Minimalist */
            .sort-dropdown-container {
                position: relative;
                display: flex;
                align-items: center;
                background: #fff;
                border: 1px solid #e2e8f0;
                border-radius: 12px;
                padding: 0 1rem;
                height: 42px;
                cursor: pointer;
                transition: all 0.2s;
            }

            .sort-dropdown-container:hover {
                background: #f8fafc;
            }

            .sort-select-modern {
                appearance: none;
                border: none;
                background: transparent;
                font-size: 0.85rem;
                font-weight: 600;
                color: #475569;
                padding-right: 1.5rem;
                outline: none;
                cursor: pointer;
            }

            /* Modern Table - Floating Rows */
            .modern-table {
                border-collapse: separate;
                border-spacing: 0 0.5rem;
                /* Gap between rows */
                margin-top: -0.5rem;
            }

            .modern-table thead th {
                border: none;
                background: transparent;
                color: #94a3b8;
                font-size: 0.75rem;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.05em;
                padding: 1rem 1.5rem;
            }

            .modern-table tbody tr {
                background: #fff;
                transition: transform 0.2s, box-shadow 0.2s;
            }

            .modern-table tbody tr:hover {
                transform: scale(1.005);
                box-shadow: 0 10px 20px -5px rgba(0, 0, 0, 0.05);
                /* Soft lift */
                z-index: 10;
                position: relative;
                background: #fff !important;
                /* Override standard hover */
            }

            .modern-table td {
                border-top: 1px solid #f1f5f9;
                border-bottom: 1px solid #f1f5f9;
                padding: 1.25rem 1.5rem;
                color: #334155;
                font-weight: 500;
            }

            .modern-table td:first-child {
                border-left: 1px solid #f1f5f9;
                border-top-left-radius: 1rem;
                border-bottom-left-radius: 1rem;
            }

            .modern-table td:last-child {
                border-right: 1px solid #f1f5f9;
                border-top-right-radius: 1rem;
                border-bottom-right-radius: 1rem;
            }

            /* Modern Box/Grid Layout */
            .category-box {
                background: #fff;
                border-radius: 1.25rem;
                padding: 1.25rem;
                border: 1px solid rgba(0, 0, 0, 0.04);
                transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
                height: 100%;
                display: flex;
                flex-direction: column;
                align-items: center;
                text-align: center;
                position: relative;
            }

            .category-box:hover {
                transform: translateY(-8px);
                box-shadow: 0 15px 30px -10px rgba(0, 0, 0, 0.1);
                border-color: rgba(99, 102, 241, 0.2);
            }

            .cat-box-img {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                object-fit: cover;
                margin-bottom: 1rem;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                border: 3px solid #f8fafc;
            }

            .cat-box-title {
                font-weight: 700;
                color: #1e293b;
                margin-bottom: 0.25rem;
                font-size: 1.1rem;
            }

            .cat-box-badge {
                background: #f1f5f9;
                color: #64748b;
                font-size: 0.8rem;
                font-weight: 600;
                padding: 0.25rem 0.75rem;
                border-radius: 1rem;
                margin-bottom: 1rem;
            }

            .cat-box-actions {
                margin-top: auto;
                display: flex;
                gap: 0.5rem;
                width: 100%;
            }

            .cat-box-btn {
                flex: 1;
                padding: 0.6rem;
                border-radius: 0.75rem;
                border: none;
                font-weight: 600;
                font-size: 0.85rem;
                transition: all 0.2s;
            }

            .btn-edit {
                background: #eef2ff;
                color: #4f46e5;
            }

            .btn-edit:hover {
                background: #4f46e5;
                color: #fff;
            }

            .btn-delete {
                background: #fef2f2;
                color: #ef4444;
            }

            .btn-delete:hover {
                background: #ef4444;
                color: #fff;
            }

            /* Icons and Visuals */
            .empty-state-icon {
                width: 60px;
                height: 60px;
                background: #f1f5f9;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #94a3b8;
                margin: 0 auto;
            }

            .cursor-pointer {
                cursor: pointer;
            }
        </style>

        <%@ include file="/includes/footer.jsp" %>
            <script src="${pageContext.request.contextPath}/resources/js/categories.js"></script>
            ```