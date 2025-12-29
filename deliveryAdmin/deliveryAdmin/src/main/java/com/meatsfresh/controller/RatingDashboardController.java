package com.meatsfresh.controller;

import com.meatsfresh.dto.OrderTableDTO;
import com.meatsfresh.dto.RatingDashboardDTO;
import com.meatsfresh.dto.VendorListDTO;
import com.meatsfresh.service.OrderService;
import com.meatsfresh.service.RatingDashboardService;
import com.meatsfresh.service.VendorService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/dashboard")
public class RatingDashboardController {

    private final RatingDashboardService ratingDashboardService;
    private final VendorService vendorService;
    private final OrderService orderService;


    public RatingDashboardController(RatingDashboardService ratingDashboardService, VendorService vendorService, OrderService orderService) {
        this.ratingDashboardService = ratingDashboardService;
        this.vendorService = vendorService;
        this.orderService = orderService;
    }

    @GetMapping("/dashboard-card")
    public ResponseEntity<RatingDashboardDTO> getRatingDashboard() {
        return ResponseEntity.ok(ratingDashboardService.getRatingDashboardStats());
    }




    @GetMapping("/all-shops")
    public ResponseEntity<List<VendorListDTO>> getAllShops() {
        return ResponseEntity.ok(vendorService.getAllVendors());
    }

    @GetMapping("/search")
    public ResponseEntity<List<VendorListDTO>> globalSearch(
            @RequestParam(required = false, defaultValue = "") String search) {

        return ResponseEntity.ok(vendorService.globalSearchVendors(search));
    }


//OrderBilling
    @GetMapping("/table")
    public ResponseEntity<List<OrderTableDTO>> getOrdersTable() {
        return ResponseEntity.ok(orderService.getOrderTable());
    }
}
