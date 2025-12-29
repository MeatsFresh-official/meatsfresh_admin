document.addEventListener('DOMContentLoaded', () => {
    const ChatApp = {
        // --- Configuration & State ---
        config: {
            contextPath: '',
            currentUserId: null,
            adminUserId: 1,
            maxReconnectAttempts: 5,
            syncInterval: 30000,
        },
        state: {
            stompClient: null,
            conversationSubscription: null,
            currentChatId: null,
            isConnecting: false,
            reconnectAttempts: 0,
            viewMode: null,
            unreadCounts: {},
            syncIntervalId: null
        },

        // --- DOM Elements Cache ---
        elements: {
            mainContent: document.querySelector('.main-content'),
            chatTab: document.getElementById('chat-tab'),
            // Admin View
            adminChatView: document.getElementById('admin-chat-view'),
            chatListCustomer: document.getElementById('chatList-customer'),
            chatListVendor: document.getElementById('chatList-vendor'),
            chatListDelivery: document.getElementById('chatList-delivery'),
            chatUserName: document.getElementById('chatUserName'),
            adminChatMessages: document.getElementById('chatMessages'),
            adminChatFormContainer: document.getElementById('chatFormContainer'),
            adminChatForm: document.getElementById('chatForm'),
            adminChatMessageInput: document.getElementById('chatMessage'),
            endChatBtn: document.getElementById('endChatBtn'),
            chatOptionsBtn: document.getElementById('chatOptionsBtn'),
            startNewChatBtn: document.getElementById('startNewChatBtn'),
            // Direct Chat View
            directChatContainer: document.querySelector('.direct-chat-container'),
            directChatMessages: document.getElementById('direct-chat-messages'),
            directChatForm: document.getElementById('directChatForm'),
            directChatMessageInput: document.getElementById('directChatMessage'),
            // Modal
            newChatModal: document.getElementById('newChatModal'),
            userTypeSelect: document.getElementById('userTypeSelect'),
            userSelect: document.getElementById('userSelect'),
            startChatBtn: document.getElementById('startChatBtn'),
        },

        // --- Initialization ---
        init() {
            this.config.contextPath = this.elements.mainContent?.dataset.contextPath || '';
            this.config.currentUserId = document.getElementById('currentUserId')?.value;

            if (!this.config.currentUserId) {
                console.error("Chat is disabled: User could not be identified.");
                return;
            }

            if (this.elements.adminChatView) this.state.viewMode = 'admin';
            else if (this.elements.directChatContainer) this.state.viewMode = 'direct';

            this.bindEvents();

            if (this.elements.chatTab?.classList.contains('active')) {
                this.connectWebSocket();
            }

            // Setup periodic sync for admin view
            if (this.state.viewMode === 'admin') {
                this.setupPeriodicSync();
            }
        },

        // --- Event Binding ---
        bindEvents() {
            this.elements.chatTab?.addEventListener('shown.bs.tab', () => this.connectWebSocket(), { once: true });

            if (this.state.viewMode === 'admin') {
                this.elements.adminChatForm?.addEventListener('submit', (e) => this.handleSendMessage(e));
                this.elements.endChatBtn?.addEventListener('click', () => this.admin.endConversation());
                this.elements.startNewChatBtn?.addEventListener('click', () => new bootstrap.Modal(this.elements.newChatModal).show());
                this.elements.newChatModal?.addEventListener('show.bs.modal', () => this.admin.handleUserTypeChange());
                this.elements.userTypeSelect?.addEventListener('change', () => this.admin.handleUserTypeChange());
                this.elements.startChatBtn?.addEventListener('click', () => this.admin.startNewConversation());
                this.elements.newChatModal?.addEventListener('hide.bs.modal', () => this.elements.startNewChatBtn?.focus());
            } else if (this.state.viewMode === 'direct') {
                this.elements.directChatForm?.addEventListener('submit', (e) => this.handleSendMessage(e));
            }

            // Handle visibility changes for notifications
            document.addEventListener('visibilitychange', () => {
                if (document.visibilityState === 'visible' && this.state.viewMode === 'admin') {
                    this.admin.loadConversations();
                }
            });
        },

        // --- WebSocket Connection ---
        connectWebSocket() {
            if (this.state.isConnecting || (this.state.stompClient?.connected)) return;
            this.state.isConnecting = true;

            const socket = new SockJS(`${this.config.contextPath}/ws-chat`);
            this.state.stompClient = Stomp.over(socket);
            this.state.stompClient.debug = null;

            this.state.stompClient.connect({}, (frame) => {
                this.state.isConnecting = false;
                this.state.reconnectAttempts = 0;

                if (this.state.viewMode === 'admin') this.admin.init();
                else if (this.state.viewMode === 'direct') this.direct.init();

            }, (error) => {
                console.error('WebSocket connection error:', error);
                this.state.isConnecting = false;
                this.state.reconnectAttempts++;
                if (this.state.reconnectAttempts <= this.config.maxReconnectAttempts) {
                    const delay = this.state.reconnectAttempts * 2000;
                    this.ui.showToast(`Chat connection lost. Reconnecting in ${delay / 1000}s...`, 'warning');
                    setTimeout(() => this.connectWebSocket(), delay);
                } else {
                    this.ui.showFatalError("Could not connect to the chat server.");
                }
            });
        },

        // --- Core Logic ---
        handleSendMessage(e) {
            e.preventDefault();
            const isAdmin = this.state.viewMode === 'admin';
            const input = isAdmin ? this.elements.adminChatMessageInput : this.elements.directChatMessageInput;
            const content = input.value.trim();

            if (!content || !this.state.currentChatId) return;

            const messageDTO = {
                conversationId: this.state.currentChatId,
                senderId: this.config.currentUserId,
                content: content,
            };

            this.state.stompClient.send("/app/chat.send", {}, JSON.stringify(messageDTO));
            this.ui.addMessage(messageDTO, true);
            input.value = '';
        },

        // --- API Helper ---
        api: {
            async fetch(endpoint, options = {}) {
                const response = await fetch(`${ChatApp.config.contextPath}${endpoint}`, options);
                if (!response.ok) {
                    const errorText = await response.text();
                    throw new Error(`API Error (${response.status}): ${errorText}`);
                }
                const text = await response.text();
                return text ? JSON.parse(text) : {};
            },
            get(endpoint) { return ChatApp.api.fetch(endpoint); },
            post(endpoint, body) {
                return ChatApp.api.fetch(endpoint, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(body)
                });
            }
        },

        // --- Admin View-Specific Logic ---
        admin: {
            async init() {
                await ChatApp.admin.loadConversations();

                const userQueue = `/user/${ChatApp.config.currentUserId}/queue/messages`;
                ChatApp.state.stompClient.subscribe(userQueue, (message) => {
                    const msg = JSON.parse(message.body);
                    const isCurrentConversation = msg.conversationId.toString() === ChatApp.state.currentChatId;

                    if (isCurrentConversation) {
                        if (msg.senderId.toString() !== ChatApp.config.currentUserId) {
                            ChatApp.ui.addMessage(msg, false);
                            ChatApp.ui.playNotificationSound();
                        }
                    } else {
                        // Only increment unread count if not the current conversation
                        const currentCount = ChatApp.state.unreadCounts[msg.conversationId] || 0;
                        ChatApp.state.unreadCounts[msg.conversationId] = currentCount + 1;
                        ChatApp.ui.updateUnreadCountUI(msg.conversationId);

                        if (document.hidden) {
                            ChatApp.ui.showDesktopNotification('New Message',
                                `From ${msg.senderName || 'User'}: ${msg.content.substring(0, 50)}${msg.content.length > 50 ? '...' : ''}`);
                        }
                    }
                    ChatApp.admin.updateConversationPreview(msg);
                });

                ChatApp.state.stompClient.subscribe('/topic/new-conversations', () => {
                    ChatApp.ui.showToast('A new conversation has started.', 'info');
                    ChatApp.admin.loadConversations();
                });
            },

            setupPeriodicSync() {
                // Clear any existing interval
                if (ChatApp.state.syncIntervalId) {
                    clearInterval(ChatApp.state.syncIntervalId);
                }
                // Set up new interval
                ChatApp.state.syncIntervalId = setInterval(() => {
                    ChatApp.admin.loadConversations();
                }, ChatApp.config.syncInterval);
            },

            async loadConversations() {
                try {
                    const conversations = await ChatApp.api.get(`/api/chat/conversations?adminId=${ChatApp.config.currentUserId}`);
                    // Preserve existing unread counts for conversations not in the new list
                    const newUnreadCounts = {};
                    conversations.forEach(conv => {
                        newUnreadCounts[conv.id] = conv.unreadCount || 0;
                    });
                    ChatApp.state.unreadCounts = newUnreadCounts;
                    ChatApp.ui.renderConversationList(conversations);
                } catch (error) {
                    console.error('Error loading conversations:', error);
                    ChatApp.ui.showToast(error.message, 'danger');
                }
            },

            updateConversationPreview(message) {
                const elementId = `conversation-${message.conversationId}`;
                const item = document.getElementById(elementId);
                if (!item) return;

                const previewEl = item.querySelector('.last-message-preview');
                if (previewEl) previewEl.textContent = message.content;

                const timeEl = item.querySelector('.last-message-time');
                if(timeEl) timeEl.textContent = ChatApp.ui.formatTime(new Date());

                if (item.parentElement) {
                    item.parentElement.prepend(item);
                }
            },

            async loadChat(conversationId, userName) {
                if (ChatApp.state.currentChatId === conversationId) return;

                // Clear unread count in UI immediately
                ChatApp.state.unreadCounts[conversationId] = 0;
                ChatApp.ui.updateUnreadCountUI(conversationId);

                // Update UI
                ChatApp.state.currentChatId = conversationId;
                ChatApp.ui.setActiveConversation(conversationId);
                ChatApp.elements.chatUserName.textContent = userName;
                ChatApp.elements.adminChatMessages.innerHTML = `<div class="text-center p-5"><div class="spinner-border"></div></div>`;
                ChatApp.elements.adminChatFormContainer.classList.remove('d-none');
                ChatApp.elements.chatOptionsBtn.disabled = false;

                try {
                    // Notify server to mark messages as read
                    await ChatApp.api.post(`/api/chat/mark-read/${conversationId}`, ChatApp.config.currentUserId);

                    // Get updated unread count (should be 0 after marking as read)
                    const unreadCount = await ChatApp.api.get(`/api/chat/unread-count/${conversationId}?userId=${ChatApp.config.currentUserId}`);
                    ChatApp.state.unreadCounts[conversationId] = unreadCount;
                    ChatApp.ui.updateUnreadCountUI(conversationId);

                    // Then load messages
                    const messages = await ChatApp.api.get(`/api/chat/messages/${conversationId}`);
                    ChatApp.ui.renderMessages(messages);
                } catch (error) {
                    console.error('Error loading chat:', error);
                    ChatApp.ui.showToast('Failed to load chat messages.', 'danger');
                    // Roll back unread count if error occurred
                    delete ChatApp.state.unreadCounts[conversationId];
                    ChatApp.admin.loadConversations();
                }
            },

            async endConversation() {
                if (!ChatApp.state.currentChatId || !confirm('Are you sure you want to end this conversation?')) return;
                try {
                    await ChatApp.api.post(`/api/chat/end/${ChatApp.state.currentChatId}`);
                    ChatApp.ui.showToast('Conversation has been closed.', 'success');
                    document.getElementById(`conversation-${ChatApp.state.currentChatId}`)?.remove();
                    ChatApp.state.currentChatId = null;
                    ChatApp.elements.adminChatMessages.innerHTML = `<div class="text-center text-muted p-5">Conversation ended.</div>`;
                    ChatApp.elements.chatUserName.textContent = 'Select a conversation';
                    ChatApp.elements.adminChatFormContainer.classList.add('d-none');
                    ChatApp.elements.chatOptionsBtn.disabled = true;
                } catch (error) {
                    ChatApp.ui.showToast(`Error ending chat: ${error.message}`, 'danger');
                }
            },

            async handleUserTypeChange() {
                const userType = ChatApp.elements.userTypeSelect.value;
                ChatApp.elements.userSelect.innerHTML = `<option>Loading...</option>`;
                try {
                    const users = await ChatApp.api.get(`/api/users/${userType}`);
                    ChatApp.elements.userSelect.innerHTML = `<option value="">Select a user...</option>`;
                    users.forEach(user => {
                        ChatApp.elements.userSelect.innerHTML += `<option value="${user.id}">${user.name}</option>`;
                    });
                } catch (error) {
                    ChatApp.elements.userSelect.innerHTML = `<option>Error loading users</option>`;
                }
            },

            async startNewConversation() {
                const userId = ChatApp.elements.userSelect.value;
                if (!userId) {
                    ChatApp.ui.showToast('Please select a user to start a chat.', 'warning');
                    return;
                }
                try {
                    const conversation = await ChatApp.api.post(`/api/chat/start/${userId}?adminId=${ChatApp.config.currentUserId}`);
                    bootstrap.Modal.getInstance(ChatApp.elements.newChatModal).hide();
                    ChatApp.ui.showToast('Conversation started!', 'success');
                    await ChatApp.admin.loadConversations();
                    ChatApp.admin.loadChat(conversation.id, ChatApp.elements.userSelect.options[ChatApp.elements.userSelect.selectedIndex].text);
                } catch (error) {
                    ChatApp.ui.showToast(`Failed to start conversation: ${error.message}`, 'danger');
                }
            },
        },

        // --- Direct (Non-Admin) View-Specific Logic ---
        direct: {
            init() { ChatApp.direct.findOrCreateConversation(); },
            async findOrCreateConversation() {
                try {
                    const conversation = await ChatApp.api.post(`/api/chat/start/${ChatApp.config.currentUserId}?adminId=${ChatApp.config.adminUserId}`);
                    if (!conversation?.id) throw new Error("Failed to get a valid conversation from server.");
                    ChatApp.state.currentChatId = conversation.id;
                    ChatApp.elements.directChatMessageInput.disabled = false;
                    ChatApp.elements.directChatForm.querySelector('button').disabled = false;
                    const messages = await ChatApp.api.get(`/api/chat/messages/${conversation.id}`);
                    ChatApp.ui.renderMessages(messages);
                    ChatApp.state.stompClient.subscribe(`/topic/conversation.${conversation.id}`, (message) => {
                        const msg = JSON.parse(message.body);
                        if (msg.senderId.toString() !== ChatApp.config.currentUserId) {
                            ChatApp.ui.addMessage(msg, false);
                            ChatApp.ui.playNotificationSound();
                        }
                    });
                } catch (error) {
                    console.error("Chat initialization error:", error);
                    ChatApp.ui.showFatalError("Failed to initialize chat. Please refresh and try again.");
                }
            },
        },

        // --- UI Rendering ---
        ui: {
            renderMessages(messages) {
                const container = ChatApp.state.viewMode === 'admin' ? ChatApp.elements.adminChatMessages : ChatApp.elements.directChatMessages;
                container.innerHTML = '';
                if (!messages || messages.length === 0) {
                    container.innerHTML = `<div class="text-center text-muted p-3">No messages yet. Start the conversation!</div>`;
                    return;
                }
                messages.forEach(msg => {
                    const isOutgoing = msg.senderId.toString() === ChatApp.config.currentUserId;
                    ChatApp.ui.addMessage(msg, isOutgoing);
                });
                container.scrollTop = container.scrollHeight;
            },

            addMessage(message, isOutgoing) {
                const container = ChatApp.state.viewMode === 'admin' ? ChatApp.elements.adminChatMessages : ChatApp.elements.directChatMessages;
                const placeholder = container.querySelector('.text-center.text-muted');
                if (placeholder) placeholder.remove();

                const div = document.createElement('div');
                div.className = `d-flex mb-2 ${isOutgoing ? 'justify-content-end' : 'justify-content-start'}`;
                div.innerHTML = `
                    <div class="message ${isOutgoing ? 'bg-primary text-white' : 'bg-light'} rounded p-2" style="max-width: 75%;">
                        ${message.content}
                        <div class="text-end small opacity-75 mt-1">
                            ${ChatApp.ui.formatTime(message.sentAt || new Date())}
                            ${!isOutgoing && message.read ? ' <i class="fas fa-check-double text-muted"></i>' : ''}
                        </div>
                    </div>`;
                container.appendChild(div);
                container.scrollTop = container.scrollHeight;
            },

            renderConversationList(conversations) {
                const lists = {
                    'CUSTOMER': ChatApp.elements.chatListCustomer,
                    'MANAGER': ChatApp.elements.chatListVendor,
                    'RIDER': ChatApp.elements.chatListDelivery
                };
                Object.values(lists).forEach(list => { if (list) list.innerHTML = ''; });
                if (conversations.length === 0) {
                    (lists.CUSTOMER || lists.MANAGER || lists.RIDER).innerHTML = `<li class="list-group-item">No active conversations.</li>`;
                    return;
                }
                conversations.forEach(conv => {
                    const listContainer = lists[conv.userRole] || lists['CUSTOMER'];
                    if (listContainer) {
                        const unreadCount = ChatApp.state.unreadCounts[conv.id] || 0;
                        const isActive = ChatApp.state.currentChatId === conv.id.toString();
                        const item = document.createElement('a');
                        item.className = `list-group-item list-group-item-action chat-item ${isActive ? 'active' : ''}`;
                        item.id = `conversation-${conv.id}`;
                        item.href = '#';
                        item.innerHTML = `
                            <div class="d-flex align-items-center">
                                <img src="${conv.userProfileImage || `${ChatApp.config.contextPath}/resources/images/default-avatar.png`}"
                                     class="rounded-circle me-3" width="45" height="45" alt="User">
                                <div class="flex-grow-1 overflow-hidden">
                                    <h6 class="mb-0 text-truncate">${conv.userName}</h6>
                                    <small class="text-muted text-truncate d-block last-message-preview">
                                        ${conv.lastMessage || '...'}
                                    </small>
                                </div>
                                <div class="d-flex flex-column align-items-end ms-2">
                                    <span class="last-message-time small text-muted">
                                        ${ChatApp.ui.formatTime(conv.lastMessageTimestamp)}
                                    </span>
                                    ${unreadCount > 0 && !isActive ?
                                        `<span class="badge bg-danger rounded-pill mt-1 unread-count-badge">
                                            ${unreadCount > 99 ? '99+' : unreadCount}
                                        </span>` : ''}
                                </div>
                            </div>`;
                        item.addEventListener('click', (e) => {
                            e.preventDefault();
                            ChatApp.admin.loadChat(conv.id, conv.userName);
                        });
                        listContainer.appendChild(item);
                    }
                });
            },

            updateUnreadCountUI(conversationId) {
                const count = ChatApp.state.unreadCounts[conversationId] || 0;
                const conversationItem = document.getElementById(`conversation-${conversationId}`);
                if (!conversationItem) return;
                const badge = conversationItem.querySelector('.unread-count-badge');
                if (!badge) return;
                if (count > 0) {
                    badge.textContent = count > 99 ? '99+' : count;
                    badge.classList.remove('d-none');
                } else {
                    badge.textContent = '';
                    badge.classList.add('d-none');
                }
            },

            setActiveConversation(id) {
                document.querySelectorAll('.chat-item').forEach(item => item.classList.remove('active'));
                const activeItem = document.getElementById(`conversation-${id}`);
                if (activeItem) activeItem.classList.add('active');
            },

            formatTime(dateString) {
                if (!dateString) return '';
                const date = new Date(dateString);
                return isNaN(date.getTime()) ? '' : date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
            },

            playNotificationSound() {
                try {
                    const audio = new Audio(`${ChatApp.config.contextPath}/resources/sounds/notification.mp3`);
                    audio.volume = 0.3;
                    audio.play().catch(e => console.log('Notification sound play failed:', e));
                } catch (e) {
                    console.log('Notification sound error:', e);
                }
            },

            showDesktopNotification(title, message) {
                if (!('Notification' in window)) return;

                if (Notification.permission === 'granted') {
                    new Notification(title, { body: message });
                } else if (Notification.permission !== 'denied') {
                    Notification.requestPermission().then(permission => {
                        if (permission === 'granted') {
                            new Notification(title, { body: message });
                        }
                    });
                }
            },

            showFatalError(message) {
                const container = ChatApp.state.viewMode === 'admin' ?
                    ChatApp.elements.adminChatMessages : ChatApp.elements.directChatMessages;
                if(container) {
                    container.innerHTML = `<div class="alert alert-danger m-3"><strong>Chat Error:</strong> ${message}</div>`;
                }
            },

            showToast(message, type = 'success') {
                const containerId = 'toast-container';
                let container = document.getElementById(containerId);
                if (!container) {
                    container = document.createElement('div');
                    container.id = containerId;
                    container.className = 'position-fixed top-0 end-0 p-3';
                    container.style.zIndex = '1090';
                    document.body.appendChild(container);
                }
                const toastEl = document.createElement('div');
                toastEl.className = `toast align-items-center text-white bg-${type} border-0`;
                toastEl.setAttribute('role', 'alert');
                toastEl.innerHTML = `<div class="d-flex"><div class="toast-body">${message}</div><button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button></div>`;
                container.appendChild(toastEl);
                const toast = new bootstrap.Toast(toastEl, { delay: 5000 });
                toast.show();
                toastEl.addEventListener('hidden.bs.toast', () => toastEl.remove());
            },
        }
    };

    ChatApp.init();
});