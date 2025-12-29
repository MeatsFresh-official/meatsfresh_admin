<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/header.jsp" %>

<main class="main-content">
    <div class="container-fluid px-4">
        <!-- Header -->
        <div class="pb-4 d-flex justify-content-between align-items-center flex-wrap">
            <div>
                <h1 class="pt-4">Categories Management</h1>
            </div>
            <button class="btn btn-primary btn-lg" data-bs-toggle="modal" data-bs-target="#categoryModal">
                <i class="fas fa-plus me-2"></i>Add New Category
            </button>
        </div>

        <!-- Loading Spinner -->
        <div id="loading-spinner" class="text-center py-5">
            <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;"><span class="visually-hidden">Loading...</span></div>
            <p class="mt-2 text-muted">Loading Categories...</p>
        </div>

        <div id="page-content" class="d-none">
            <!-- Stats Cards -->
            <div class="row mb-4">
                <div class="col-xl-3 col-md-6 mb-4 animate-on-load">
                    <div class="card bg-primary text-white h-100">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div><h6 class="mb-0">Total Categories</h6><h3 class="mb-0" id="stat-total-categories">0</h3></div>
                            <i class="fas fa-tags fa-2x"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4 animate-on-load" style="animation-delay: 0.1s;">
                    <div class="card bg-success text-white h-100">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div><h6 class="mb-0">Avg. Commission</h6><h3 class="mb-0" id="stat-avg-commission">0%</h3></div>
                            <i class="fas fa-percentage fa-2x"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4 animate-on-load" style="animation-delay: 0.2s;">
                    <div class="card bg-warning text-white h-100">
                        <div class="card-body d-flex justify-content-between align-items-center">
                           <div> <h6 class="mb-0">No Image</h6><h3 class="mb-0" id="stat-no-image">0</h3></div>
                            <i class="fas fa-image fa-2x"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4 animate-on-load" style="animation-delay: 0.3s;">
                    <div class="card bg-info text-white h-100">
                         <div class="card-body d-flex justify-content-between align-items-center">
                            <div><h6 class="mb-0">Top Commission Rate</h6><h3 class="mb-0" id="stat-top-commission">0%</h3></div>
                            <i class="fas fa-chart-line fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Content: Categories Table -->
            <div class="card" id="categories-content">
                <div class="card-header bg-light d-flex flex-wrap justify-content-between align-items-center">
                     <h5 class="mb-0 py-2">All Categories</h5>
                     <div class="d-flex align-items-center gap-2">
                        <input type="text" id="search-input" class="form-control" placeholder="Search by name...">
                        <select id="sort-select" class="form-select" style="width: auto;">
                            <option value="name-asc">Sort by Name (A-Z)</option>
                            <option value="name-desc">Sort by Name (Z-A)</option>
                            <!-- MODIFIED: Re-enabled commission sorting -->
                            <option value="comm-desc">Sort by Commission (High-Low)</option>
                            <option value="comm-asc">Sort by Commission (Low-High)</option>
                        </select>
                     </div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-4" style="width: 100px;">Image</th>
                                    <th>Category Name</th>
                                    <th>Commission</th>
                                    <th class="text-end pe-4">Actions</th>
                                </tr>
                            </thead>
                            <tbody id="categories-table-body"></tbody>
                        </table>
                    </div>
                    <div id="no-results" class="text-center p-5 d-none">
                        <i class="fas fa-search fa-3x text-muted mb-3"></i>
                        <h4 class="text-muted">No categories match your search.</h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Category Add/Edit Modal -->
<div class="modal fade" id="categoryModal" tabindex="-1" aria-labelledby="categoryModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <form class="modal-content" id="categoryForm">
      <div class="modal-header">
          <h5 class="modal-title" id="categoryModalLabel">Add New Category</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
          <input type="hidden" id="categoryId" name="categoryId">
          <div id="image-preview-container" class="mb-3 text-center d-none">
              <label class="form-label">Current Image</label>
              <img id="image-preview" src="" class="rounded" style="max-height: 150px; max-width: 100%;" alt="Current Image">
          </div>
          <div class="mb-3">
              <label for="categoryName" class="form-label">Category Name *</label>
              <input type="text" class="form-control" id="categoryName" name="name" required>
          </div>
          <div class="mb-3">
              <label for="categoryCommission" class="form-label">Commission (%) *</label>
              <input type="number" class="form-control" id="categoryCommission" name="commission" step="0.01" min="0" required>
          </div>
          <div class="mb-3">
              <label for="categoryImage" class="form-label">Category Image</label>
              <input type="file" class="form-control" id="categoryImage" name="image" accept="image/*">
              <small id="image-help-text" class="form-text text-muted">A new image will replace the old one.</small>
          </div>
      </div>
      <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
          <button type="submit" class="btn btn-primary" id="saveCategoryBtn">
            <span class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
            Save Category
          </button>
      </div>
    </form>
  </div>
</div>

<%@ include file="/includes/footer.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/categories.css">
<script src="${pageContext.request.contextPath}/resources/js/categories.js"></script>