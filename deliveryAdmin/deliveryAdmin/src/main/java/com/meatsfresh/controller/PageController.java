package com.meatsfresh.controller;

import com.meatsfresh.StaffUserDetails;
import com.meatsfresh.entity.Staff;
import com.meatsfresh.service.StaffService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
@CrossOrigin
@Controller
public class PageController {

    @Autowired
    private StaffService staffService;

    @GetMapping("/dashboard")
    public String dashboard(@AuthenticationPrincipal StaffUserDetails userDetails, Model model) {
        // Make sure to load the staff with access pages
        Staff currentStaff = staffService.findByEmailWithAccessPages(userDetails.getUsername());
        model.addAttribute("currentStaff", currentStaff);
        return "dashboard";
    }

    /* USER SECTION */

    @GetMapping("/user")
    public String getUser() {
        return "user";
    }

    @GetMapping("/user-view")
    public String getUserView() {
        return "user-view";
    }

    @GetMapping("/user-edit")
    public String getUserEdit() {
        return "user-edit";
    }

    @GetMapping("/user-earnings")
    public String getUsersEarnings() {
        return "user-earnings";
    }

    @GetMapping("/users-reviewAndratings")
    public String getUserReviews() {
        return "users-reviewAndratings";
    }

    @GetMapping("/pie-chart")
    public String getPieChart() {
        return "pie-chart";
    }

    @GetMapping("/view-cartpage")
    public String getViewCartPage() {
        return "view-cartpage";
    }


    /* VENDOR/SHOP SECTION */

    @GetMapping("/shopspage")
    public String getShopsPage() {
        return "shopspage";
    }

    @GetMapping("/viewshop")
    public String getViewShopPage() {
        return "viewshop";
    }

    @GetMapping("/editshop")
    public String getEditShopPage() {
        return "editshop";
    }

    @GetMapping("/shopspage-admin-actions")
    public String getShopsPageAdminActions() {
        return "shopspage-admin-actions";
    }

    @GetMapping("/categories")
    public String getCategoriesPage() {
        return "categories";
    }

    @GetMapping("/shop-earnings")
    public String getShopsEarnings() {
        return "shop-earnings";
    }

    @GetMapping("/shops-adsAndpromotion")
    public String getShopsAdsAndPromotion() {
        return "shops-adsAndpromotion";
    }

    @GetMapping("/orders-billings")
    public String getOrdersAndBillings() {
        return "orders-billings";
    }

    @GetMapping("/commissions-report")
    public String getCommissionsReport() {
        return "commissions-report";
    }

    /* DELIVERY SECTION */

    @GetMapping("/deliveryBoy-orders")
    public String getDeliveryBoyOrders() {
        return "deliveryBoy-orders";
    }

    @GetMapping("/deliveryBoy-manage")
    public String getDeliveryBoyManage() {
        return "deliveryBoy-manage";
    }

    @GetMapping("/deliveryBoy-view")
    public String getDeliveryBoyView() {
        return "deliveryBoy-view";
    }

    @GetMapping("/deliveryBoy-edit")
    public String getDeliveryBoyEdit() {
        return "deliveryBoy-edit";
    }

    @GetMapping("/deliveryBoy-admin-actions")
    public String getDeliveryBoyAdminActions() {
        return "deliveryBoy-admin-actions";
    }

    @GetMapping("/deliveryBoy-earnings")
    public String getDeliveryBoyEarnings() {
        return "deliveryBoy-earnings";
    }

    @GetMapping("/payments")
    public String getPayments() {
        return "payments";
    }

    /* SETTINGS */

    @GetMapping("/website-analysis")
    public String getWebsiteAnalysis() {
        return "website-analysis";
    }

    @GetMapping("/app-homepage")
    public String getAppHomepage() {
        return "app-homepage";
    }

    @GetMapping("/notifications")
    public String getNotifications() {
        return "notifications";
    }

    @GetMapping("/sms-integration")
    public String getSmsIntegration() {
        return "sms-integration";
    }

    @GetMapping("/coupon-code")
    public String getCouponCode() {
        return "coupon-code";
    }

    @GetMapping("/reports")
    public String getReports() {
        return "reports";
    }
    @GetMapping("/profit")
    public String getProfit() {
        return "profit";
    }



}