<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="en_IN" />
<%@ include file="/includes/header.jsp" %>

<%-- Include dummy data --%>
<%@ include file="/pages/dummy/user-dummy.jsp" %>

<%
// Get the user ID from request parameter
String userId = request.getParameter("id");

// Find the user from the dummy data
java.util.Map<String, Object> user = null;
for (java.util.Map<String, Object> u : users) {
    if (u.get("id").equals(userId)) {
        user = u;
        break;
    }
}

pageContext.setAttribute("user", user);
%>

<c:if test="${empty user}">
    <div class="alert alert-danger">
        User not found!
    </div>
</c:if>

<c:if test="${not empty user}">
<main class="main-content">
    <div class="container-fluid">
        <div class="page-header pt-2">
            <h1>Edit User</h1>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Edit User Information - ${user.id}</h5>
                        <div>
                            <a href="${pageContext.request.contextPath}/pages/view.jsp?id=${user.id}" class="btn btn-sm btn-outline-light me-2">
                                <i class="fas fa-eye me-1"></i> View
                            </a>
                            <a href="${pageContext.request.contextPath}/pages/user.jsp" class="btn btn-sm btn-outline-light">
                                <i class="fas fa-arrow-left me-1"></i> Back to Shops
                            </a>
                        </div>
                    </div>
                    <form action="${pageContext.request.contextPath}/user/update" method="POST">
                        <input type="hidden" name="id" value="${user.id}">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-3 text-center">
                                    <img src="${not empty user.profileImage ? pageContext.request.contextPath.concat(user.profileImage) : pageContext.request.contextPath.concat('/resources/images/default-avatar.jpg')}"
                                         class="rounded-circle mb-3" width="150" height="150" alt="${user.name}">
                                    <div class="mb-3">
                                        <label for="profileImage" class="form-label">Change Profile Image</label>
                                        <input class="form-control" type="file" id="profileImage" name="profileImage">
                                    </div>
                                </div>
                                <div class="col-md-9">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="name" class="form-label">Full Name</label>
                                                <input type="text" class="form-control" id="name" name="name" value="${user.name}" required>
                                            </div>
                                            <div class="mb-3">
                                                <label for="email" class="form-label">Email</label>
                                                <input type="email" class="form-control" id="email" name="email" value="${user.email}" required>
                                            </div>
                                            <div class="mb-3">
                                                <label for="phone" class="form-label">Phone</label>
                                                <input type="tel" class="form-control" id="phone" name="phone" value="${user.phone}" required>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="userType" class="form-label">User Type</label>
                                                <select class="form-select" id="userType" name="userType" required>
                                                    <option value="NORMAL" ${user.type == 'NORMAL' ? 'selected' : ''}>Normal User</option>
                                                    <option value="PREMIUM" ${user.type == 'PREMIUM' ? 'selected' : ''}>Premium User</option>
                                                    <option value="PRO" ${user.type == 'PRO' ? 'selected' : ''}>Pro User</option>
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label for="city" class="form-label">City</label>
                                                <input type="text" class="form-control" id="city" name="city" value="${user.city}" required>
                                            </div>
                                            <div class="mb-3">
                                                <label for="country" class="form-label">Country</label>
                                                <input type="text" class="form-control" id="country" name="country" value="${user.country}" required>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="address" class="form-label">Address</label>
                                        <textarea class="form-control" id="address" name="address" rows="3" required>${user.address}</textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>Save Changes
                            </button>
                            <a href="${pageContext.request.contextPath}/pages/view.jsp?id=${user.id}" class="btn btn-secondary">
                                <i class="fas fa-times me-2"></i>Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>
</c:if>

<%@ include file="/includes/footer.jsp" %>