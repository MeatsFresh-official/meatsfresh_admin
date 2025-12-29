package com.meatsfresh.controller;

import com.meatsfresh.StaffUserDetails;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AuthController {

    @GetMapping("/login")
    public String login(
            @RequestParam(value = "error", required = false) String error,
            @RequestParam(value = "logout", required = false) String logout,
            Model model) {

        if (error != null) {
            model.addAttribute("error", "Invalid username or password");
        }

        if (logout != null) {
            model.addAttribute("message", "You have been logged out successfully");
        }

        return "login";
    }

    @PostMapping("/login")
    public String loginSuccess(HttpServletRequest request,
                               @AuthenticationPrincipal StaffUserDetails userDetails) {
        // Store role in session
        request.getSession().setAttribute("CURRENT_ROLE", userDetails.getStaff().getRole().name());
        return "redirect:/dashboard";
    }

    @GetMapping("/access-denied")
    public String accessDenied() {
        return "access-denied";
    }
}