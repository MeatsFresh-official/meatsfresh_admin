package com.meatsfresh.controller;

import com.meatsfresh.StaffUserDetails;
import com.meatsfresh.entity.Staff;
import com.meatsfresh.entity.StaffRole;
import com.meatsfresh.service.StaffService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/admin-staff")
public class AdminStaffController {

    @Autowired
    private StaffService staffService;

    @GetMapping
    public String staffManagement(
            @RequestParam(value = "success", required = false) String success,
            @RequestParam(value = "error", required = false) String error,
            @AuthenticationPrincipal StaffUserDetails userDetails,
            Model model) {

        if (userDetails == null) {
            return "redirect:/login";
        }

        // Load current staff with access pages
        Staff currentStaff = staffService.findByEmailWithAccessPages(userDetails.getUsername());
        model.addAttribute("currentStaff", currentStaff);

        // Add success/error messages if present
        if (success != null) {
            model.addAttribute("success", success);
        }
        if (error != null) {
            model.addAttribute("error", error);
        }

        // Load all staff data
        refreshStaffData(model);
        return "admin-staff";
    }

    @PostMapping("/add")
    public String addStaff(
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String phone,
            @RequestParam String password,
            @RequestParam String role,
            @RequestParam(required = false) MultipartFile profileImage,
            @RequestParam(value = "accessPages", required = false) List<String> accessPages,
            RedirectAttributes redirectAttributes) {

        try {
            Staff staff = new Staff();
            staff.setName(name);
            staff.setEmail(email);
            staff.setPhone(phone);
            staff.setPassword(password);
            staff.setRole(StaffRole.valueOf(role));

            // Initialize accessPages if null
            if (accessPages == null) {
                accessPages = new ArrayList<>();
            }

            // Ensure dashboard access is always included
            if (!accessPages.contains("DASHBOARD")) {
                accessPages.add("DASHBOARD");
            }

            // Automatically add HELP_SUPPORT for specific roles
            StaffRole staffRole = StaffRole.valueOf(role);
            if ((staffRole == StaffRole.MANAGER ||
                    staffRole == StaffRole.RIDER ||
                    staffRole == StaffRole.SUB_ADMIN ||
                    staffRole == StaffRole.SUPPORT) &&
                    !accessPages.contains("HELP_SUPPORT")) {
                accessPages.add("HELP_SUPPORT");
            }

            staff.setAccessPages(accessPages);

            staffService.addStaff(staff, profileImage);

            redirectAttributes.addFlashAttribute("success", "Staff added successfully");
            return "redirect:/admin-staff";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/admin-staff";
        }
    }

    @PostMapping("/edit")
    public String editStaff(
            @RequestParam Long id,
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String phone,
            @RequestParam(required = false) String password,
            @RequestParam String role,
            @RequestParam(defaultValue = "false") boolean active,
            @RequestParam(required = false) MultipartFile profileImage,
            RedirectAttributes redirectAttributes) {

        try {
            Staff existingStaff = new Staff();
            existingStaff.setName(name);
            existingStaff.setEmail(email);
            existingStaff.setPhone(phone);
            existingStaff.setPassword(password);
            existingStaff.setRole(StaffRole.valueOf(role));
            existingStaff.setActive(active);

            staffService.updateStaff(id, existingStaff, profileImage);

            redirectAttributes.addFlashAttribute("success", "Staff updated successfully");
            return "redirect:/admin-staff";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error updating staff: " + e.getMessage());
            return "redirect:/admin-staff";
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteStaff(@PathVariable Long id) {
        try {
            staffService.deleteStaff(id);
            return ResponseEntity.ok().build();
        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error deleting staff: " + e.getMessage());
        }
    }

    @PostMapping("/update-access-pages")
    @ResponseBody
    public ResponseEntity<?> updateAccessPages(
            @RequestParam("staffId") Long staffId,
            @RequestParam(value = "accessPages", required = false) List<String> accessPages) {
        System.out.println("DEBUG: updateAccessPages called for staffId=" + staffId + ", accessPages=" + accessPages);
        try {
            Staff staff = staffService.getStaffById(staffId);

            // Make mutable copy because Spring might return unmodifiable list
            List<String> pages = accessPages != null ? new ArrayList<>(accessPages) : new ArrayList<>();

            // Ensure dashboard access is preserved
            if (!pages.contains("DASHBOARD")) {
                pages.add("DASHBOARD");
            }

            // Important: Clear and addAll is safer for Hibernate collections than replacing
            // the list
            staff.getAccessPages().clear();
            staff.getAccessPages().addAll(pages);

            staffService.saveStaff(staff);
            System.out.println("DEBUG: Permissions updated successfully for staffId=" + staffId);

            return ResponseEntity.ok()
                    .body(java.util.Map.of("success", true, "message", "Permissions updated successfully"));
        } catch (Exception e) {
            System.err.println("DEBUG ERROR: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest().body(java.util.Map.of("success", false, "message", e.getMessage()));
        }
    }

    private void refreshStaffData(Model model) {
        // Load all staff members
        model.addAttribute("staffList", staffService.getAllStaff());

        // Load staff statistics
        model.addAttribute("totalStaff", staffService.getTotalStaff());
        model.addAttribute("activeStaff", staffService.getActiveStaff());
        model.addAttribute("rejectedStaff", staffService.getRejectedStaff());

        // Placeholder for pending tasks (you can implement this later)
        model.addAttribute("pendingTasks", 0);
    }
}