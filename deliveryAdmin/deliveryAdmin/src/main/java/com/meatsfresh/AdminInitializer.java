package com.meatsfresh;

import com.meatsfresh.entity.Staff;
import com.meatsfresh.entity.StaffRole;
import com.meatsfresh.repository.StaffRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;

@Component
public class AdminInitializer implements CommandLineRunner {

    @Autowired
    private StaffRepository staffRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;
    

    @Override
    @Transactional
    public void run(String... args) throws Exception {
        staffRepository.findByEmail("admin@gmail.com").ifPresentOrElse(
                admin -> {
                    if (!passwordEncoder.matches("admin123", admin.getPassword())) {
                        admin.setPassword(passwordEncoder.encode("admin123"));
                        staffRepository.save(admin);
                    }
                },
                () -> {
                    Staff admin = new Staff();
                    admin.setName("Admin");
                    admin.setEmail("admin@gmail.com");
                    admin.setPassword(passwordEncoder.encode("admin123"));
                    admin.setRole(StaffRole.ADMIN);
                    admin.setActive(true);
                    admin.setAccessPages(Arrays.asList(
                            "DASHBOARD", "USER_MANAGEMENT", "USER_PAGE", "USER_REVIEWS", "USER_CARTS",
                            "VENDOR_MANAGEMENT", "SHOPS_PAGE","CATEGORIES_MANAGEMENT","SHOPS_ADS", "ORDERS_BILLINGS", "COMMISSIONS_REPORT",
                            "DELIVERY_SYSTEM", "DELIVERY_ORDERS", "DELIVERY_MANAGE", "DELIVERY_PAYMENTS",
                            "SYSTEM_SETTINGS", "ADMIN_STAFF", "WEBSITE_ANALYTICS", "APP_HOMEPAGE",
                            "NOTIFICATIONS", "SMS_INTEGRATION", "COUPON_CODE", "HELP_SUPPORT","REPORTS"
                    ));
                    staffRepository.save(admin);
                }
        );
    }
}