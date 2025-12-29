package com.meatsfresh.entity;

import jakarta.persistence.*;
import lombok.Data;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Entity
@Data
@Table(name = "staff")
public class Staff {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String email;
    private String phone;
    private String password;
    private String profileImage;
    private boolean active = true;

    @Enumerated(EnumType.STRING)
    private StaffRole role;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "staff_access_pages", joinColumns = @JoinColumn(name = "staff_id"))
    @Column(name = "page")
    private List<String> accessPages = new ArrayList<>();

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "staff_permissions", joinColumns = @JoinColumn(name = "staff_id"))
    @Column(name = "permission")
    private List<String> permissions = new ArrayList<>();

    @Transient
    public Collection<? extends GrantedAuthority> getAuthorities() {
        List<GrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority("ROLE_" + role.name()));

        if (permissions != null) {
            permissions.forEach(perm ->
                    authorities.add(new SimpleGrantedAuthority(perm))
            );
        }

        return authorities;
    }
}