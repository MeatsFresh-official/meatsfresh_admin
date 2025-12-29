package com.meatsfresh.controller;

import com.meatsfresh.StaffUserDetails;
import com.meatsfresh.entity.Staff;
import com.meatsfresh.service.StaffService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class SupportController {

    @Autowired
    private StaffService staffService;

    @GetMapping("/help-support")
    public String showHelpSupportPage(@AuthenticationPrincipal StaffUserDetails userDetails, Model model) {
        if (userDetails == null) {
            return "redirect:/login";
        }
        Staff currentStaff = staffService.findByEmailWithAccessPages(userDetails.getUsername());
        model.addAttribute("currentStaff", currentStaff);



        // Add placeholder ticket data
        model.addAttribute("openTickets", 0);
        model.addAttribute("inProgressTickets", 0);
        model.addAttribute("resolvedTickets", 0);
        model.addAttribute("avgResponseTime", "N/A");

        return "help-support"; // This corresponds to /pages/help-support.jsp
    }
}