package com.meatsfresh.controller;

import com.meatsfresh.entity.Staff;
import com.meatsfresh.service.OTPService;
import com.meatsfresh.service.StaffService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class PasswordController {
    private final OTPService otpService;
    private final StaffService staffService;
    private final PasswordEncoder passwordEncoder;

    public PasswordController(OTPService otpService, StaffService staffService,
                              PasswordEncoder passwordEncoder) {
        this.otpService = otpService;
        this.staffService = staffService;
        this.passwordEncoder = passwordEncoder;
    }

    @PostMapping("/generate-otp")
    public ResponseEntity<?> generateOTP(@RequestParam("phoneNumber") String phoneNumber) {
        Map<String, Object> response = new HashMap<>();
        try {
            Staff staff = staffService.findByPhone(phoneNumber);

            if(staff == null){
                response.put("message", "Staff Not Found!");
                response.put("staff", null);
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }else {
                String otp = otpService.generateOTP(phoneNumber);
                response.put("message", "OTP sent successfully.");
                response.put("otp", otp);

                System.out.println(response.toString());

                return new ResponseEntity<>(response, HttpStatus.OK);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.put("message", "Internal server error: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/verify-otp")
    public ResponseEntity<?> verifyOTP(@RequestParam String phoneNumber,
                                       @RequestParam String otp) {
        Map<String, Object> response = new HashMap<>();
        try {
            boolean isValid = otpService.validateOTP(phoneNumber, otp);
            if (isValid) {
                response.put("success", true);
                response.put("message", "OTP verified successfully");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "Invalid OTP or OTP expired");
                return ResponseEntity.badRequest().body(response);
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error verifying OTP: " + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }

    @PostMapping("/change-password")
    public ResponseEntity<?> changePassword(@RequestParam String phoneNumber,
                                            @RequestParam String otp,
                                            @RequestParam String newPassword,
                                            @RequestParam String confirmPassword) {
        Map<String, Object> response = new HashMap<>();
        try {
            // Validate OTP first
            if (!otpService.validateOTP(phoneNumber, otp)) {
                response.put("success", false);
                response.put("message", "Invalid OTP");
                return ResponseEntity.badRequest().body(response);
            }

            // Check if passwords match
            if (!newPassword.equals(confirmPassword)) {
                response.put("success", false);
                response.put("message", "Passwords do not match");
                return ResponseEntity.badRequest().body(response);
            }

            // Validate password strength
            if (newPassword.length() < 8) {
                response.put("success", false);
                response.put("message", "Password must be at least 8 characters");
                return ResponseEntity.badRequest().body(response);
            }

            // Find staff by phone number
            Staff staff = staffService.findByPhone(phoneNumber);
            if (staff == null) {
                response.put("success", false);
                response.put("message", "Staff not found");
                return ResponseEntity.badRequest().body(response);
            }

            // Update password
            staff.setPassword(newPassword);
            staffService.save(staff);

            response.put("success", true);
            response.put("message", "Password changed successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error changing password: " + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }
}