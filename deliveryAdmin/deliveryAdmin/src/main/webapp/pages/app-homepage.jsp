<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/includes/header.jsp" %>

<main class="main-content">
    <div class="container-fluid">
        <div class="page-header py-3">
            <h1 class="m-0">App Home Management</h1>
        </div>

        <!-- Banner Management Card -->
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center py-3">
                <div>
                    <h4 class="m-0">Homepage Banners</h4>
                    <small class="text-muted">Max 10 banners allowed</small>
                </div>
                <div>
                    <button type="button" class="btn btn-primary" id="addBannerBtn">
                        <i class="fas fa-plus me-2"></i>Add Banner
                    </button>
                </div>
            </div>
            <div class="card-body">
                <!--
                  This container is a placeholder.
                  JavaScript will fetch the banners and render them here on page load.
                -->
                <div id="bannerContainer" class="row g-3">
                    <!-- JavaScript will add a loading message or banner cards here -->
                </div>

                <!-- ADD NEW BANNER FORM (Initially Hidden) -->
                <div id="newBannerForm" class="card mt-3 d-none">
                    <div class="card-body">
                        <h5 class="card-title">Upload New Banner</h5>
                        <form id="bannerUploadForm" enctype="multipart/form-data">
                            <div class="mb-3">
                                <label for="bannerImage" class="form-label">Banner Image</label>
                                <input class="form-control" type="file" id="bannerImage" name="image" accept="image/jpeg, image/png, image/webp" required>
                                <small class="text-muted">Recommended size: 1200x600px (Max 2MB)</small>
                                <div id="imageError" class="text-danger mt-1 d-none"></div>
                            </div>
                            <div class="d-flex justify-content-end">
                                <button type="button" class="btn btn-secondary me-2" id="cancelBannerBtn">Cancel</button>
                                <button type="submit" class="btn btn-primary" id="uploadBannerBtn">Upload Banner</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- ======================= MODALS AND TOASTS ======================= -->

<!-- IMAGE VIEWER MODAL -->
<div class="modal fade" id="imageViewerModal" tabindex="-1" aria-labelledby="imageViewerModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="imageViewerModalLabel">Banner Image</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center">
                <img id="modalImage" src="" class="img-fluid" alt="Banner Image">
            </div>
        </div>
    </div>
</div>

<!-- UPDATE BANNER MODAL -->
<div class="modal fade" id="updateBannerModal" tabindex="-1" aria-labelledby="updateBannerModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="updateBannerModalLabel">Update Banner</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="bannerUpdateForm" novalidate>
                <div class="modal-body">
                    <input type="hidden" id="updateBannerId" name="id">
                    <div class="mb-3 text-center">
                        <p class="mb-2 text-muted">Current Image:</p>
                        <img id="currentBannerImage" src="" alt="Current Banner" class="img-fluid rounded border" style="max-height: 200px;">
                    </div>
                    <div class="mb-3">
                        <label for="updateBannerImage" class="form-label">Upload New Image</label>
                        <input class="form-control" type="file" id="updateBannerImage" name="image" accept="image/jpeg, image/png, image/webp" required>
                        <small class="text-muted">Select a new file to replace the current one.</small>
                        <div id="updateImageError" class="text-danger mt-1 d-none"></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary" id="saveBannerUpdateBtn">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- DELETE CONFIRMATION MODAL -->
<div class="modal fade" id="deleteConfirmationModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Confirm Delete</h5><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button></div>
            <div class="modal-body">
                <p>Are you sure you want to delete this banner?</p>
                <p class="text-muted">This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Delete</button>
            </div>
        </div>
    </div>
</div>

<!-- SUCCESS NOTIFICATION TOAST -->
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
    <div id="successToast" class="toast align-items-center text-white bg-success" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body"><i class="fas fa-check-circle me-2"></i><span id="toastMessage"></span></div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
<script src="${pageContext.request.contextPath}/resources/js/app-homepage.js"></script>