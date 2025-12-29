package com.meatsfresh;

import com.meatsfresh.entity.Staff;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class StaffUserDetails implements UserDetails {

    private final Staff staff;

    public StaffUserDetails(Staff staff) {
        this.staff = staff;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        List<GrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority("ROLE_" + staff.getRole().name()));

        if (staff.getPermissions() != null) {
            staff.getPermissions().forEach(perm ->
                    authorities.add(new SimpleGrantedAuthority(perm))
            );
        }

        return authorities;
    }

    @Override
    public String getPassword() {
        return staff.getPassword();
    }

    @Override
    public String getUsername() {
        return staff.getEmail();
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return staff.isActive();
    }

    public Staff getStaff() {
        return staff;
    }
}