package com.meatsfresh.config;

import com.meatsfresh.StaffUserDetails;
import com.meatsfresh.entity.Staff;
import com.meatsfresh.entity.StaffRole;
import com.meatsfresh.service.StaffService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class PageAccessFilter extends OncePerRequestFilter {

    private final StaffService staffService;
    private final Map<String, String> uriToAccessCode;

    public PageAccessFilter(StaffService staffService) {
        this.staffService = staffService;
        this.uriToAccessCode = initializeUriMappings();
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        String requestURI = request.getRequestURI();

        // Skip filtering for static resources and API endpoints
        if (shouldSkipFilter(requestURI)) {
            filterChain.doFilter(request, response);
            return;
        }

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication != null && authentication.isAuthenticated() &&
                !(authentication instanceof AnonymousAuthenticationToken)) {

            StaffUserDetails userDetails = (StaffUserDetails) authentication.getPrincipal();
            Staff staff = userDetails.getStaff();

            if (!isPageAllowed(requestURI, staff)) {
                response.sendRedirect(request.getContextPath() + "/access-denied");
                return;
            }
        }

        filterChain.doFilter(request, response);
    }

    private boolean shouldSkipFilter(String requestURI) {
        return requestURI.startsWith("/resources/") ||
                requestURI.startsWith("/webjars/") ||
                requestURI.startsWith("/uploads/") ||
                requestURI.startsWith("/api/") ||
                requestURI.equals("/login") ||
                requestURI.equals("/logout") ||
                requestURI.equals("/help-support") ||
                requestURI.equals("/access-denied");
    }

    private boolean isPageAllowed(String requestURI, Staff staff) {
        String accessCode = uriToAccessCode.get(requestURI);

        // Allow access if no specific access code is required
        if (accessCode == null) {
            return true;
        }

        // Admin has full access to all pages
        if (staff.getRole() == StaffRole.ADMIN) {
            return true;
        }

        // Check if staff has the required access page
        return staff.getAccessPages() != null && staff.getAccessPages().contains(accessCode);
    }

    private Map<String, String> initializeUriMappings() {
        Map<String, String> mappings = new HashMap<>();

        // Dashboard
        mappings.put("/pages/dashboard.jsp", "DASHBOARD");

        // User Management
        mappings.put("/pages/user.jsp", "USER_PAGE");
        mappings.put("/pages/users-reviewAndratings.jsp", "USER_REVIEWS");
        mappings.put("/pages/view-cartpage.jsp", "USER_CARTS");

        // Vendor Management
        mappings.put("/pages/shopspage.jsp", "SHOPS_PAGE");
        mappings.put("/pages/categories.jsp", "CATEGORIES_MANAGEMENT");
        mappings.put("/pages/shops-adsAndpromotion.jsp", "SHOPS_ADS");
        mappings.put("/pages/orders-billings.jsp", "ORDERS_BILLINGS");
        mappings.put("/pages/commissions-report.jsp", "COMMISSIONS_REPORT");

        // Delivery System
        mappings.put("/pages/deliveryBoy-orders.jsp", "DELIVERY_ORDERS");
        mappings.put("/pages/deliveryBoy-manage.jsp", "DELIVERY_MANAGE");
        mappings.put("/pages/payments.jsp", "DELIVERY_PAYMENTS");

        // System Settings
        mappings.put("/pages/admin-staff.jsp", "ADMIN_STAFF");
        mappings.put("/pages/website-analysis.jsp", "WEBSITE_ANALYTICS");
        mappings.put("/pages/app-homepage.jsp", "APP_HOMEPAGE");
        mappings.put("/pages/notifications.jsp", "NOTIFICATIONS");
        mappings.put("/pages/sms-integration.jsp", "SMS_INTEGRATION");
        mappings.put("/pages/coupon-code.jsp", "COUPON_CODE");
        mappings.put("/pages/help-support.jsp", "HELP_SUPPORT");

        return mappings;
    }
}
