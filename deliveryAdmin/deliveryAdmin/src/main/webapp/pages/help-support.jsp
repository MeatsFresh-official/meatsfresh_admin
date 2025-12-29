<%@ include file="/includes/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<main class="main-content" data-context-path="${pageContext.request.contextPath}">
    <%-- Hidden inputs to provide context to the JavaScript --%>
    <input type="hidden" id="currentUserId" value="${currentStaff.id}">
    <input type="hidden" id="adminUserId" value="1"> <%-- Assumed for non-admins to connect to --%>


    <div class="container-fluid px-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="pt-3">Help & Support</h1>
        </div>

        <!-- Quick Stats Cards -->
        <div class="row mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="card bg-primary text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Open Tickets</h6>
                                <h3 class="mb-0">${openTickets}</h3>
                            </div>
                            <i class="fas fa-question-circle fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-warning text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">In Progress</h6>
                                <h3 class="mb-0">${inProgressTickets}</h3>
                            </div>
                            <i class="fas fa-clock fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-success text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Resolved</h6>
                                <h3 class="mb-0">${resolvedTickets}</h3>
                            </div>
                            <i class="fas fa-check-circle fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-info text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">Avg. Response Time</h6>
                                <h3 class="mb-0">${avgResponseTime}</h3>
                            </div>
                            <i class="fas fa-stopwatch fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content Tabs -->
        <div class="card mb-4">
            <div class="card-header">
                <ul class="nav nav-tabs card-header-tabs" id="supportTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="tickets-tab" data-bs-toggle="tab" data-bs-target="#tickets" type="button" role="tab">
                            <i class="fas fa-ticket-alt me-2"></i>Support Tickets
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="chat-tab" data-bs-toggle="tab" data-bs-target="#chat" type="button" role="tab">
                            <i class="fas fa-comments me-2"></i>Live Chat
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="faq-tab" data-bs-toggle="tab" data-bs-target="#faq" type="button" role="tab">
                            <i class="fas fa-question-circle me-2"></i>FAQ
                        </button>
                    </li>
                </ul>
            </div>
            <div class="card-body tab-content" id="supportTabContent">
                <!-- Support Tickets Tab -->
                <div class="tab-pane fade show active" id="tickets" role="tabpanel">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="col-md-6">
                            <div class="btn-group" role="group">
                                <button type="button" class="btn btn-outline-primary filter-btn active" data-filter="all">All</button>
                                <button type="button" class="btn btn-outline-warning filter-btn" data-filter="open">Open</button>
                                <button type="button" class="btn btn-outline-info filter-btn" data-filter="progress">In Progress</button>
                                <button type="button" class="btn btn-outline-success filter-btn" data-filter="resolved">Resolved</button>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="Search tickets..." id="ticketSearch">
                                <button class="btn btn-outline-secondary" type="button" id="searchTicketBtn">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover" id="ticketsTable">
                            <thead>
                                <tr>
                                    <th>Ticket ID</th>
                                    <th>Subject</th>
                                    <th>User</th>
                                    <th>Related To</th>
                                    <th>Status</th>
                                    <th>Created</th>
                                    <th>Last Update</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ticket" items="${tickets}">
                                <tr data-status="${ticket.status.toLowerCase().replace(' ', '-')}">
                                    <td>#${ticket.id}</td>
                                    <td>${ticket.subject}</td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${not empty ticket.user.profileImage ? pageContext.request.contextPath.concat(ticket.user.profileImage) : pageContext.request.contextPath.concat('/resources/images/default-avatar.jpg')}"
                                                 class="rounded-circle me-3" width="30" height="30" alt="${ticket.user.name}">
                                            <span>${ticket.user.name}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${ticket.relatedTo == 'SHOP'}">
                                                <div class="badge-div bg-info">Shop: ${ticket.shop.name}</div>
                                            </c:when>
                                            <c:when test="${ticket.relatedTo == 'RIDER'}">
                                                <div class="badge-div bg-secondary">Rider: ${ticket.rider.name}</div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="badge-div bg-light text-dark">General</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="badge-div bg-${ticket.status == 'OPEN' ? 'warning' :
                                                                  ticket.status == 'IN PROGRESS' ? 'info' : 'success'}">
                                            ${ticket.status}
                                        </div>
                                    </td>
                                    <td><fmt:formatDate value="${ticket.createdAt}" pattern="dd MMM yyyy HH:mm"/></td>
                                    <td><fmt:formatDate value="${ticket.updatedAt}" pattern="dd MMM yyyy HH:mm"/></td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal"
                                                data-bs-target="#ticketDetailsModal" data-ticket-id="${ticket.id}">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-success" onclick="changeStatus('${ticket.id}', 'IN PROGRESS')">
                                            <i class="fas fa-play"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger" onclick="confirmClose('${ticket.id}')">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </td>
                                </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>


                <!-- Live Chat Tab -->
                <div class="tab-pane fade" id="chat" role="tabpanel">
                    <c:set var="isAdmin" value="${currentStaff.role == 'ADMIN' || currentStaff.role == 'SUB_ADMIN'}" />

                    <c:if test="${isAdmin}">
                        <!-- =============================================================== -->
                        <!-- ================ ADMIN / SUB-ADMIN CHAT VIEW ================== -->
                        <!-- =============================================================== -->
                        <div id="admin-chat-view" class="row">
                            <div class="col-md-4 border-end">
                                <div class="d-flex justify-content-between align-items-center p-3">
                                    <h5 class="mb-0">Conversations</h5>
                                    <button class="btn btn-sm btn-primary" id="startNewChatBtn" title="Start New Chat">
                                        <i class="fas fa-plus"></i> New Chat
                                    </button>
                                </div>
                                <!-- TABS FOR CONVERSATION LISTS -->
                                <ul class="nav nav-pills nav-fill mb-2 px-2" id="chatUserTypeTabs" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link active" id="customer-chat-tab" data-bs-toggle="tab" data-bs-target="#chatList-customer-pane" type="button">Customers</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="vendor-chat-tab" data-bs-toggle="tab" data-bs-target="#chatList-vendor-pane" type="button">Vendors</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="delivery-chat-tab" data-bs-toggle="tab" data-bs-target="#chatList-delivery-pane" type="button">Delivery</button>
                                    </li>
                                </ul>
                                <div class="tab-content" id="chatUserTypeTabContent" style="height: 60vh; overflow-y: auto;">
                                    <div class="tab-pane fade show active" id="chatList-customer-pane" role="tabpanel">
                                        <div class="list-group list-group-flush" id="chatList-customer">
                                            <!-- Customer chats loaded by JS -->
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="chatList-vendor-pane" role="tabpanel">
                                         <div class="list-group list-group-flush" id="chatList-vendor">
                                            <!-- Vendor chats loaded by JS -->
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="chatList-delivery-pane" role="tabpanel">
                                         <div class="list-group list-group-flush" id="chatList-delivery">
                                            <!-- Delivery chats loaded by JS -->
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-8">
                               <div class="card h-100 d-flex flex-column border-0">
                                    <div class="card-header bg-light d-flex justify-content-between align-items-center">
                                        <h5 class="mb-0" id="chatUserName">Select a conversation</h5>
                                        <div class="dropdown">
                                            <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" id="chatOptionsBtn" disabled><i class="fas fa-ellipsis-v"></i></button>
                                            <ul class="dropdown-menu dropdown-menu-end"><li><a class="dropdown-item text-danger" href="#" id="endChatBtn">End Chat</a></li></ul>
                                        </div>
                                    </div>
                                    <div class="card-body chat-body" id="chatMessages" style="height: 60vh; overflow-y: auto;">
                                        <div class="text-center text-muted h-100 d-flex flex-column justify-content-center align-items-center">
                                            <i class="fas fa-comments fa-3x mb-3"></i>
                                            <p>Select a conversation from the left to start chatting.</p>
                                        </div>
                                    </div>
                                    <div class="card-footer bg-white p-3 d-none" id="chatFormContainer">
                                        <form id="chatForm" autocomplete="off">
                                            <div class="input-group"><input type="text" class="form-control" placeholder="Type your message..." id="chatMessage" required><button class="btn btn-primary" type="submit"><i class="fas fa-paper-plane"></i> Send</button></div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${!isAdmin}">
                        <!-- =============================================================== -->
                        <!-- ================== NON-ADMIN CHAT VIEW ======================== -->
                        <!-- =============================================================== -->
                        <div class="direct-chat-container">
                             <div class="card d-flex flex-column mx-auto" style="max-width: 800px; height: 70vh;">
                                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Chat with Admin Support</h5>
                                </div>
                                <div class="card-body chat-body" id="direct-chat-messages" style="overflow-y: auto;">
                                     <div class="text-center p-5"><div class="spinner-border"></div><p class="mt-2">Connecting to chat...</p></div>
                                </div>
                                <div class="card-footer bg-white p-3">
                                    <form id="directChatForm" autocomplete="off">
                                        <div class="input-group">
                                            <input type="text" class="form-control" placeholder="Type your message..." id="directChatMessage" required disabled>
                                            <button class="btn btn-primary" type="submit" disabled><i class="fas fa-paper-plane"></i> Send</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>


                <!-- FAQ Management Tab -->
                <div class="tab-pane fade" id="faq" role="tabpanel">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="mb-0">Frequently Asked Questions</h5>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addFaqModal">
                            <i class="fas fa-plus me-2"></i>Add FAQ
                        </button>
                    </div>

                    <div class="accordion" id="faqAccordion">
                        <c:forEach var="faq" items="${faqs}" varStatus="loop">
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="heading${loop.index}">
                                <button class="accordion-button ${loop.index != 0 ? 'collapsed' : ''}" type="button"
                                        data-bs-toggle="collapse" data-bs-target="#collapse${loop.index}">
                                    ${faq.question}
                                </button>
                            </h2>
                            <div id="collapse${loop.index}" class="accordion-collapse collapse ${loop.index == 0 ? 'show' : ''}"
                                 data-bs-parent="#faqAccordion">
                                <div class="accordion-body">
                                    <div class="d-flex justify-content-between">
                                        <div>${faq.answer}</div>
                                        <div class="btn-group btn-group-sm">
                                            <button class="btn btn-outline-primary" data-bs-toggle="modal"
                                                    data-bs-target="#editFaqModal" data-faq-id="${faq.id}">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-outline-danger" onclick="confirmDeleteFaq('${faq.id}')">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>


<!-- New Chat Modal -->
<div class="modal fade" id="newChatModal" tabindex="-1" aria-labelledby="newChatModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="newChatModalLabel">Start New Conversation</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label for="userTypeSelect" class="form-label">Select User Type</label>
                    <select class="form-select" id="userTypeSelect">
                        <option value="customers">Customer</option>
                        <option value="vendors">Vendor</option>
                        <option value="delivery">Delivery Staff</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="userSelect" class="form-label">Select User</label>
                    <select class="form-select" id="userSelect">
                        <!-- Options loaded by JS -->
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="startChatBtn">Start Chat</button>
            </div>
        </div>
    </div>
</div>

<!-- Ticket Details Modal -->
<div class="modal fade" id="ticketDetailsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Ticket #<span id="ticketId"></span> - <span id="ticketSubject"></span></h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-body">
                                <h6 class="card-title">Ticket Information</h6>
                                <div class="mb-2">
                                    <strong>Status:</strong>
                                    <span class="badge" id="ticketStatusBadge"></span>
                                </div>
                                <div class="mb-2">
                                    <strong>Created:</strong>
                                    <span id="ticketCreated"></span>
                                </div>
                                <div class="mb-2">
                                    <strong>Last Updated:</strong>
                                    <span id="ticketUpdated"></span>
                                </div>
                                <div class="mb-2">
                                    <strong>Category:</strong>
                                    <span id="ticketCategory"></span>
                                </div>
                                <div>
                                    <strong>Priority:</strong>
                                    <span id="ticketPriority"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-body">
                                <h6 class="card-title">User Information</h6>
                                <div class="d-flex align-items-center mb-3">
                                    <img id="ticketUserImage" src="" class="rounded-circle me-3" width="50" height="50">
                                    <div>
                                        <h6 class="mb-0" id="ticketUserName"></h6>
                                        <small class="text-muted" id="ticketUserEmail"></small>
                                    </div>
                                </div>
                                <div class="mb-2">
                                    <i class="fas fa-phone me-2"></i>
                                    <span id="ticketUserPhone"></span>
                                </div>
                                <div>
                                    <i class="fas fa-history me-2"></i>
                                    <span id="ticketUserHistory"></span> previous tickets
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <h6>Conversation</h6>
                <div class="card mb-3">
                    <div class="card-body">
                        <div class="ticket-message">
                            <div class="message-header">
                                <strong id="ticketInitialSender"></strong>
                                <small class="text-muted" id="ticketInitialTime"></small>
                            </div>
                            <div class="message-content" id="ticketInitialMessage"></div>
                        </div>
                    </div>
                </div>

                <div id="ticketReplies">
                    <!-- Replies will be inserted here -->
                </div>

                <form id="ticketReplyForm">
                    <div class="mb-3">
                        <label class="form-label">Add Reply</label>
                        <textarea class="form-control" rows="3" id="ticketReplyMessage" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Change Status</label>
                        <select class="form-select" id="ticketStatusChange">
                            <option value="OPEN">Open</option>
                            <option value="IN PROGRESS">In Progress</option>
                            <option value="RESOLVED">Resolved</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary">Send Reply</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Add FAQ Modal -->
<div class="modal fade" id="addFaqModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <form class="modal-content" id="addFaqForm">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Add New FAQ</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Question <span class="text-danger">*</span></label>
                    <input type="text" name="question" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Answer <span class="text-danger">*</span></label>
                    <textarea name="answer" class="form-control" rows="4" required></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Category</label>
                    <select name="category" class="form-select">
                        <option value="GENERAL">General</option>
                        <option value="ORDERS">Orders</option>
                        <option value="PAYMENTS">Payments</option>
                        <option value="DELIVERY">Delivery</option>
                        <option value="ACCOUNT">Account</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Add FAQ</button>
            </div>
        </form>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">Confirm Deletion</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this item? This action cannot be undone.</p>
                <input type="hidden" id="deleteItemId">
                <input type="hidden" id="deleteItemType">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" onclick="deleteItem()">Delete</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/help-support.css">
<%-- Include Stomp and SockJS clients --%>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/help-support.js"></script>