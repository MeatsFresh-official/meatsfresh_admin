package com.meatsfresh.controller;

import com.meatsfresh.entity.Coupon;
import com.meatsfresh.entity.DiscountType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/coupons")
public class CouponController {

    @GetMapping
    public String listCoupons(Model model) {
        // Mock data for UI visualization as requested
        List<Coupon> coupons = new ArrayList<>();
        
        Coupon c1 = new Coupon();
        c1.setId(1L);
        c1.setCode("WELCOME50");
        c1.setDiscountType(DiscountType.PERCENTAGE);
        c1.setDiscountValue(50.0);
        c1.setMaxDiscount(100.0);
        c1.setMinOrderValue(299.0);
        c1.setUsageLimit(100);
        c1.setValidFrom(LocalDateTime.now().minusDays(1));
        c1.setValidTill(LocalDateTime.now().plusMonths(1));
        c1.setActive(true);
        coupons.add(c1);

        Coupon c2 = new Coupon();
        c2.setId(2L);
        c2.setCode("FLAT100");
        c2.setDiscountType(DiscountType.AMOUNT);
        c2.setDiscountValue(100.0);
        c2.setMinOrderValue(500.0);
        c2.setUsageLimit(50);
        c2.setValidFrom(LocalDateTime.now().minusDays(5));
        c2.setValidTill(LocalDateTime.now().plusWeeks(2));
        c2.setActive(true);
        coupons.add(c2);
        
        Coupon c3 = new Coupon();
        c3.setId(3L);
        c3.setCode("SUMMER25");
        c3.setDiscountType(DiscountType.PERCENTAGE);
        c3.setDiscountValue(25.0);
        c3.setMaxDiscount(150.0);
        c3.setMinOrderValue(1000.0);
        c3.setUsageLimit(200);
        c3.setValidFrom(LocalDateTime.now().minusDays(10));
        c3.setValidTill(LocalDateTime.now().minusDays(1)); // Expired
        c3.setActive(false);
        coupons.add(c3);

        model.addAttribute("coupons", coupons);
        return "coupons";
    }

    @PostMapping("/save")
    public String saveCoupon(RedirectAttributes redirectAttributes) {
        // Dummy save for UI testing
        redirectAttributes.addFlashAttribute("success", "Coupon saved successfully (Mock)");
        return "redirect:/coupons";
    }

    @DeleteMapping("/delete/{id}")
    @ResponseBody
    public String deleteCoupon(@PathVariable Long id) {
        // Dummy delete for UI testing
        return "ok";
    }
}
