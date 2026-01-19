<%@ taglib prefix="c" uri="jakarta.tags.core" %>
  <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
    <div class="sidebar">
      <!-- Sidebar Header -->
      <div class="sidebar-header d-flex align-items-center">
        <i class="fas fa-shipping-fast logo-icon"></i>
        <h3 class="sidebar-title">Delivery Dashboard</h3>
      </div>

      <!-- Sidebar Menu -->
      <div class="sidebar-menu">
        <ul class="nav flex-column">

          <!-- Dashboard Section -->
          <c:if test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'DASHBOARD')}">
            <li class="nav-item">
              <a class="nav-link ${pageContext.request.requestURI.endsWith('/dashboard') ? 'active' : ''}"
                href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-tachometer-alt"></i>
                <span>Dashboard</span>
              </a>
            </li>
          </c:if>

          <!-- User Management -->
          <c:if test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'USER_MANAGEMENT')}">
            <li class="nav-item">
              <a class="nav-link collapsed ${pageContext.request.requestURI.contains('/user') ? 'active' : ''}"
                data-bs-toggle="collapse" href="#userCollapse">
                <i class="fas fa-users"></i>
                <span>User Management</span>
                <i class="fas fa-angle-down sidebar-collapse-icon"></i>
              </a>
              <div class="collapse ${pageContext.request.requestURI.contains('/user') ? 'show' : ''}" id="userCollapse">
                <ul class="nav flex-column submenu">
                  <c:if test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'USER_PAGE')}">
                    <li><a href="${pageContext.request.contextPath}/user"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/user') ? 'active' : ''}">
                        <i class="fas fa-user-edit"></i> User</a></li>
                  </c:if>
                  <c:if
                    test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'USER_EARNINGS')}">
                    <li><a href="${pageContext.request.contextPath}/user-earnings"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/user-earnings') ? 'active' : ''}">
                        <i class="fas fa-money-bill-wave"></i> User Revenue</a></li>
                  </c:if>
                  <c:if test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'USER_REVIEWS')}">
                    <li><a href="${pageContext.request.contextPath}/users-reviewAndratings"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/users-reviewAndratings') ? 'active' : ''}">
                        <i class="fas fa-star"></i> Ratings & Reviews</a></li>
                  </c:if>
                  <c:if test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'USER_CARTS')}">
                    <li><a href="${pageContext.request.contextPath}/view-cartpage"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/view-cartpage') ? 'active' : ''}">
                        <i class="fas fa-shopping-cart"></i> Carts</a></li>
                  </c:if>
                  <li><a href="${pageContext.request.contextPath}/pie-chart"
                      class="nav-link ${pageContext.request.requestURI.endsWith('/users-reviewAndratings') ? 'active' : ''}">
                      <i class="fas fa-star"></i> Pie Chart</a></li>
                  <li><a href="${pageContext.request.contextPath}/recipes"
                      class="nav-link ${pageContext.request.requestURI.endsWith('/recipes') ? 'active' : ''}">
                      <i class="fas fa-book-open"></i> Recipes</a></li>
                </ul>
              </div>
            </li>
          </c:if>

          <!-- Vendor Management -->
          <c:if test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'VENDOR_MANAGEMENT')}">
            <li class="nav-item">
              <a class="nav-link collapsed ${pageContext.request.requestURI.contains('/shop') ? 'active' : ''}"
                data-bs-toggle="collapse" href="#vendorCollapse">
                <i class="fas fa-store"></i>
                <span>Vendor Management</span>
                <i class="fas fa-angle-down sidebar-collapse-icon"></i>
              </a>
              <div class="collapse ${pageContext.request.requestURI.contains('/shop') ? 'show' : ''}"
                id="vendorCollapse">
                <ul class="nav flex-column submenu">
                  <c:if test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'SHOPS_PAGE')}">
                    <li><a href="${pageContext.request.contextPath}/shopspage"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/shopspage') ? 'active' : ''}">
                        <i class="fas fa-store-alt"></i> Shops</a></li>
                  </c:if>
                  <c:if
                    test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'CATEGORIES_MANAGEMENT')}">
                    <li><a href="${pageContext.request.contextPath}/categories"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/categories') ? 'active' : ''}">
                        <i class="fas fa-utensils"></i> Categories</a></li>
                  </c:if>
                  <c:if
                    test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'SHOPS_EARNINGS')}">
                    <li><a href="${pageContext.request.contextPath}/shop-earnings"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/shop-earnings') ? 'active' : ''}">
                        <i class="fas fa-money-bill-wave"></i> Shop Earnings</a></li>
                  </c:if>
                  <c:if test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'SHOPS_ADS')}">
                    <li><a href="${pageContext.request.contextPath}/shops-adsAndpromotion"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/shops-adsAndpromotion') ? 'active' : ''}">
                        <i class="fas fa-bullhorn"></i> Ads & Promotions</a></li>
                  </c:if>
                  <c:if
                    test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'ORDERS_BILLINGS')}">
                    <li><a href="${pageContext.request.contextPath}/orders-billings"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/orders-billings') ? 'active' : ''}">
                        <i class="fas fa-receipt"></i> Orders & Billings</a></li>
                  </c:if>
                  <c:if
                    test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'COMMISSIONS_REPORT')}">
                    <li><a href="${pageContext.request.contextPath}/commissions-report"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/commissions-report') ? 'active' : ''}">
                        <i class="fas fa-chart-pie"></i> Commissions Report</a></li>
                  </c:if>

                </ul>
              </div>
            </li>
          </c:if>

          <!-- Banner Management (Separate Page) -->
          <c:if test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'BANNERS')}">
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/banners"
                class="nav-link ${pageContext.request.requestURI.endsWith('/banners') ? 'active' : ''}">
                <i class="fas fa-images"></i> <span>Banners</span>
              </a>
            </li>
          </c:if>

          <!-- Coupon Management -->
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/coupons"
              class="nav-link ${pageContext.request.requestURI.endsWith('/coupons') ? 'active' : ''}">
              <i class="fas fa-ticket-alt"></i> <span>Coupons</span>
            </a>
          </li>

          <!-- Delivery System -->
          <c:if test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'DELIVERY_SYSTEM')}">
            <li class="nav-item">
              <a class="nav-link collapsed ${pageContext.request.requestURI.contains('/deliveryBoy') ? 'active' : ''}"
                data-bs-toggle="collapse" href="#deliveryCollapse">
                <i class="fas fa-shipping-fast"></i>
                <span>Delivery System</span>
                <i class="fas fa-angle-down sidebar-collapse-icon"></i>
              </a>
              <div class="collapse ${pageContext.request.requestURI.contains('/deliveryBoy') ? 'show' : ''}"
                id="deliveryCollapse">
                <ul class="nav flex-column submenu">
                  <c:if
                    test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'DELIVERY_ORDERS')}">
                    <li><a href="${pageContext.request.contextPath}/deliveryBoy-orders"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/deliveryBoy-orders') ? 'active' : ''}">
                        <i class="fas fa-box-open"></i> Orders</a></li>
                  </c:if>
                  <c:if
                    test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'DELIVERY_MANAGE')}">
                    <li><a href="${pageContext.request.contextPath}/deliveryBoy-manage"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/deliveryBoy-manage') ? 'active' : ''}">
                        <i class="fas fa-motorcycle"></i> Delivery Boys</a></li>
                  </c:if>
                  <c:if
                    test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'DELIVERY_EARNINGS')}">
                    <li><a href="${pageContext.request.contextPath}/deliveryBoy-earnings"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/deliveryBoy-earnings') ? 'active' : ''}">
                        <i class="fas fa-wallet"></i> Delivery Earnings</a></li>
                  </c:if>
                  <c:if
                    test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'DELIVERY_INCENTIVES')}">
                    <li><a href="${pageContext.request.contextPath}/delivery-incentives"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/delivery-incentives') ? 'active' : ''}">
                        <i class="fas fa-gift"></i> Incentives</a></li>
                  </c:if>
                  <c:if
                    test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'DELIVERY_PAYMENTS')}">
                    <li><a href="${pageContext.request.contextPath}/payments"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/payments') ? 'active' : ''}">
                        <i class="fas fa-credit-card"></i> Payments</a></li>
                  </c:if>
                </ul>
              </div>
            </li>
          </c:if>

          <!-- System Settings -->
          <c:if test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'SYSTEM_SETTINGS')}">
            <li class="nav-item">
              <a class="nav-link collapsed ${pageContext.request.requestURI.contains('/admin-staff') ? 'active' : ''}"
                data-bs-toggle="collapse" href="#systemCollapse">
                <i class="fas fa-cogs"></i>
                <span>System Settings</span>
                <i class="fas fa-angle-down sidebar-collapse-icon"></i>
              </a>
              <div class="collapse ${pageContext.request.requestURI.contains('/admin-staff') ? 'show' : ''}"
                id="systemCollapse">
                <ul class="nav flex-column submenu">
                  <c:if test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'ADMIN_STAFF')}">
                    <li><a href="${pageContext.request.contextPath}/admin-staff"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/admin-staff') ? 'active' : ''}">
                        <i class="fas fa-user-shield"></i> Admin & Staff</a></li>
                  </c:if>

                  <c:if test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'APP_HOMEPAGE')}">
                    <li><a href="${pageContext.request.contextPath}/app-homepage"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/app-homepage') ? 'active' : ''}">
                        <i class="fas fa-mobile-alt"></i> App Homepage</a></li>
                  </c:if>
                  <c:if
                    test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'NOTIFICATIONS')}">
                    <li><a href="${pageContext.request.contextPath}/notifications"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/notifications') ? 'active' : ''}">
                        <i class="fas fa-bell"></i> Notifications</a></li>
                  </c:if>
                  <c:if
                    test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'SMS_INTEGRATION')}">
                    <li><a href="${pageContext.request.contextPath}/sms-integration"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/sms-integration') ? 'active' : ''}">
                        <i class="fas fa-sms"></i> SMS Integration</a></li>
                  </c:if>

                  <c:if test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'HELP_SUPPORT')}">
                    <li><a href="${pageContext.request.contextPath}/help-support"
                        class="nav-link ${pageContext.request.requestURI.endsWith('/help-support') ? 'active' : ''}">
                        <i class="fas fa-question-circle"></i> Help & Support</a></li>
                  </c:if>
                </ul>
              </div>
            </li>
          </c:if>

          <!-- Reports Section - Fixed -->
          <c:if test="${currentStaff.role == 'ADMIN' || fn:contains(currentStaff.accessPages, 'REPORTS')}">
            <li class="nav-item">
              <a class="nav-link ${pageContext.request.requestURI.contains('/reports') ? 'active' : ''}"
                href="${pageContext.request.contextPath}/reports"
                aria-current="${pageContext.request.requestURI.endsWith('/reports') ? 'active' : ''}">
                <i class="fas fa-chart-bar"></i>
                <span>Reports</span>
              </a>
            </li>
          </c:if>
          <!-- Profit Section -->
          <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/profit') ? 'active' : ''}"
              href="${pageContext.request.contextPath}/profit">
              <i class="fas fa-hand-holding-usd"></i>
              <span>Profit</span>
            </a>
          </li>

          <!-- Admin Profile Sections (Visible to all logged in staff) -->
          <li class="nav-item">
            <a class="nav-link collapsed ${pageContext.request.requestURI.contains('/admin-profile') ? 'active' : ''}"
              data-bs-toggle="collapse" href="#adminProfileCollapse">
              <img
                src="${not empty currentStaff.profileImage ? currentStaff.profileImage : pageContext.request.contextPath.concat('/resources/images/user-setting.png')}"
                alt="${currentStaff.name}" width="32" height="32" class="rounded-circle me-2 object-cover">
              <div class="d-flex flex-column" style="overflow: hidden;">
                <strong class="text-truncate">${currentStaff.name}</strong>
                <small class="text-muted text-truncate" style="font-size: 0.75rem;">${currentStaff.role}</small>
              </div>
              <i class="fas fa-angle-down sidebar-collapse-icon"></i>
            </a>
            <div class="collapse ${pageContext.request.requestURI.contains('/admin-profile') ? 'show' : ''}"
              id="adminProfileCollapse">
              <ul class="nav flex-column submenu">
                <li>
                  <div class="px-3 py-2 border-bottom">
                    <p class="mb-0 fw-bold text-dark">${currentStaff.name}</p>
                    <p class="mb-0 text-muted small text-truncate">${currentStaff.email}</p>
                  </div>
                </li>
                <li><a class="dropdown-item py-2" href="#" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                    <i class="fas fa-key me-2 text-secondary"></i> Change Password
                  </a></li>
                <li>
                  <hr class="dropdown-divider">
                </li>
                <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/login">
                    <i class="fas fa-sign-out-alt me-2"></i> Sign out
                  </a></li>
              </ul>
            </div>
          </li>
        </ul>
      </div>
    </div>


    <style>
      /* Fix for Tailwind CSS conflict with Bootstrap Collapse */
      .sidebar .collapse {
        visibility: visible !important;
      }

      /* Sidebar Container */
      .sidebar {
        width: 260px;
        background: #fff;
        border-right: 1px solid #eaeaea;
        height: 100vh;
        display: flex;
        flex-direction: column;
        font-family: 'Inter', sans-serif;
      }

      /* Header */
      .sidebar-header {
        padding: 16px 24px;
        border-bottom: 1px solid #f0f0f0;
      }

      .logo-icon {
        font-size: 1.5rem;
        color: #4e73df;
        margin-right: 12px;
      }

      .sidebar-title {
        font-size: 1.1rem;
        font-weight: 600;
        margin: 0;
      }

      /* Menu */
      .sidebar-menu {
        flex: 1;
        overflow-y: auto;
        padding: 16px 0;
      }

      .nav-item {
        margin-bottom: 4px;
      }

      .nav-link {
        display: flex;
        align-items: center;
        padding: 12px 24px;
        color: #444;
        font-size: 0.95rem;
        border-radius: 8px;
        transition: background 0.2s;
      }

      .nav-link i {
        font-size: 1rem;
        margin-right: 12px;
        color: #6c757d;
      }

      .nav-link:hover {
        background: #f7f8fa;
      }

      .nav-link.active {
        background: #eef2ff;
        color: #4e73df;
        font-weight: 600;
      }

      .nav-link.active i {
        color: #4e73df;
      }

      /* Collapse Icon */
      .sidebar-collapse-icon {
        margin-left: auto;
        transition: transform 0.2s;
      }

      .nav-link[aria-expanded="true"] .sidebar-collapse-icon {
        transform: rotate(180deg);
      }

      /* Submenu */
      .submenu {
        padding-left: 40px;
        margin: 4px 0 8px;
      }

      .submenu .nav-link {
        padding: 8px 16px;
        font-size: 0.9rem;
        color: #666;
      }

      .submenu .nav-link i {
        font-size: 0.9rem;
      }

      .submenu .nav-link.active {
        background: transparent;
        color: #4e73df;
      }

      /* Capacity Card */
      .sidebar-capacity {
        padding: 16px;
        margin: 16px;
        border-radius: 12px;
        background: #f9f9ff;
        text-align: center;
      }

      .capacity-circle {
        width: 56px;
        height: 56px;
        border-radius: 50%;
        background: #eef2ff;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 600;
        color: #4e73df;
        margin: 0 auto 12px;
      }

      .capacity-text {
        font-size: 0.85rem;
        color: #444;
      }

      .capacity-text .small {
        font-size: 0.75rem;
        color: #777;
      }

      .btn-upgrade {
        display: inline-block;
        margin-top: 12px;
        background: #4e73df;
        color: #fff;
        padding: 8px 16px;
        border-radius: 8px;
        font-size: 0.85rem;
        text-decoration: none;
      }

      .btn-upgrade:hover {
        background: #3b5bcc;
      }

      /* Footer */
      .sidebar-footer {
        padding: 16px;
        border-top: 1px solid #f0f0f0;
      }

      .footer-link {
        display: flex;
        align-items: center;
        font-size: 0.9rem;
        color: #444;
        margin-bottom: 8px;
      }

      .footer-link i {
        margin-right: 8px;
      }

      .footer-profile {
        display: flex;
        align-items: center;
        margin-top: 8px;
      }

      .footer-profile img {
        border-radius: 50%;
        margin-right: 8px;
      }

      .footer-profile span {
        font-size: 0.9rem;
        font-weight: 500;
      }
    </style>