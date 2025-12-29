package com.meatsfresh.config;

import com.meatsfresh.StaffUserDetails;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class RoleSessionFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (session != null && auth != null && auth.isAuthenticated()) {
            String sessionRole = (String) session.getAttribute("CURRENT_ROLE");
            String currentRole = ((StaffUserDetails) auth.getPrincipal()).getStaff().getRole().name();

            if (!currentRole.equals(sessionRole)) {
                // Create new session if role changed
                session.invalidate();
                HttpSession newSession = request.getSession(true);
                newSession.setAttribute("CURRENT_ROLE", currentRole);
            }
        }

        filterChain.doFilter(request, response);
    }
}
