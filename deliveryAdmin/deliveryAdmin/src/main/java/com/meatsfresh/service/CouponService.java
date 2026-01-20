package com.meatsfresh.service;

import com.meatsfresh.entity.Coupon;
import com.meatsfresh.repository.CouponRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class CouponService {

    @Autowired
    private CouponRepository couponRepository;

    public List<Coupon> getAllCoupons() {
        return couponRepository.findAll();
    }

    public Coupon getCouponById(Long id) {
        return couponRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Coupon not found with id: " + id));
    }

    @Transactional
    public Coupon saveCoupon(Coupon coupon) {
        // Check if code already exists for new coupons
        if (coupon.getId() == null && couponRepository.existsByCode(coupon.getCode())) {
            throw new RuntimeException("Coupon code already exists: " + coupon.getCode());
        }
        
        // For updates, ensure we're not changing code to one that exists elsewhere
        if (coupon.getId() != null) {
            Optional<Coupon> existing = couponRepository.findByCode(coupon.getCode());
            if (existing.isPresent() && !existing.get().getId().equals(coupon.getId())) {
                throw new RuntimeException("Coupon code already exists: " + coupon.getCode());
            }
        }
        
        return couponRepository.save(coupon);
    }

    @Transactional
    public void deleteCoupon(Long id) {
        couponRepository.deleteById(id);
    }
}
