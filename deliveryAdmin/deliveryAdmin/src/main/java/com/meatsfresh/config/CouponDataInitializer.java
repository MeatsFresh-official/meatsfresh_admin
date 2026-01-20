package com.meatsfresh.config;

import com.meatsfresh.entity.Coupon;
import com.meatsfresh.entity.DiscountType;
import com.meatsfresh.repository.CouponRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.LocalDateTime;

@Configuration
public class CouponDataInitializer {

    @Bean
    public CommandLineRunner initCoupons(CouponRepository repository) {
        return args -> {
            if (repository.count() == 0) {
                Coupon c1 = new Coupon();
                c1.setCode("WELCOME50");
                c1.setDiscountType(DiscountType.PERCENTAGE);
                c1.setDiscountValue(50.0);
                c1.setMaxDiscount(100.0);
                c1.setMinOrderValue(299.0);
                c1.setUsageLimit(100);
                c1.setValidFrom(LocalDateTime.now().minusDays(1));
                c1.setValidTill(LocalDateTime.now().plusMonths(1));
                c1.setActive(true);
                repository.save(c1);

                Coupon c2 = new Coupon();
                c2.setCode("FLAT100");
                c2.setDiscountType(DiscountType.AMOUNT);
                c2.setDiscountValue(100.0);
                c2.setMinOrderValue(500.0);
                c2.setUsageLimit(50);
                c2.setValidFrom(LocalDateTime.now().minusDays(5));
                c2.setValidTill(LocalDateTime.now().plusWeeks(2));
                c2.setActive(true);
                repository.save(c2);
                
                Coupon c3 = new Coupon();
                c3.setCode("SUMMER25");
                c3.setDiscountType(DiscountType.PERCENTAGE);
                c3.setDiscountValue(25.0);
                c3.setMaxDiscount(150.0);
                c3.setMinOrderValue(1000.0);
                c3.setUsageLimit(200);
                c3.setValidFrom(LocalDateTime.now().minusDays(10));
                c3.setValidTill(LocalDateTime.now().minusDays(1)); // Expired
                c3.setActive(false);
                repository.save(c3);
            }
        };
    }
}
