package com.meatsfresh.config;

import com.meatsfresh.StaffUserDetails;
import com.meatsfresh.entity.Staff;
import com.meatsfresh.service.StaffService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalControllerAdvice {

    private static final Logger logger = LoggerFactory.getLogger(GlobalControllerAdvice.class);

    @Autowired
    private StaffService staffService;

    @ModelAttribute("currentStaff")
    public Staff addGlobalAttributes() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication != null && authentication.isAuthenticated() && authentication.getPrincipal() instanceof StaffUserDetails) {
            StaffUserDetails userDetails = (StaffUserDetails) authentication.getPrincipal();
            String userEmail = userDetails.getUsername();

            logger.info("GlobalControllerAdvice: Found authenticated user '{}'. Fetching details.", userEmail);

            try {
                Staff staff = staffService.findByEmailWithAccessPages(userEmail);
                if (staff != null) {
                    logger.info("GlobalControllerAdvice: Successfully fetched Staff ID '{}' for user '{}'.", staff.getId(), userEmail);
                } else {
                    logger.warn("GlobalControllerAdvice: staffService returned null for user '{}'.", userEmail);
                }
                return staff;
            } catch (Exception e) {
                logger.error("GlobalControllerAdvice: Error fetching staff details for user '{}'.", userEmail, e);
                return null; // Return null on error
            }
        } else {
            logger.warn("GlobalControllerAdvice: No authenticated user found or principal is not StaffUserDetails.");
        }
        return null;
    }
}