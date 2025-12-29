package com.meatsfresh.service;

import com.meatsfresh.StaffUserDetails;
import com.meatsfresh.entity.Staff;
import com.meatsfresh.repository.StaffRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;

@Service
@Transactional
public class StaffDetailsService implements UserDetailsService {

    @Autowired
    private StaffRepository staffRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        Staff staff = staffRepository.findByEmail(email.toLowerCase()) // Ensure case-insensitive
                .orElseThrow(() -> new UsernameNotFoundException("Staff not found with email: " + email));

        if (!staff.isActive()) {
            throw new UsernameNotFoundException("Staff account is inactive");
        }

        return new StaffUserDetails(staff);
    }
}
