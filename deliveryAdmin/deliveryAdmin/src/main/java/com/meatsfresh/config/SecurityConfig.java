//package com.meatsfresh.config;
//
//import com.meatsfresh.service.StaffService;
//import com.meatsfresh.entity.StaffRole;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.context.annotation.Lazy;
//import org.springframework.http.HttpMethod;
//import org.springframework.security.config.annotation.web.builders.HttpSecurity;
//import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
//import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
//import org.springframework.security.crypto.password.PasswordEncoder;
//import org.springframework.security.web.SecurityFilterChain;
//import org.springframework.security.web.access.intercept.AuthorizationFilter;
//
//@Configuration
//@EnableWebSecurity
//public class SecurityConfig {
//
//    @Autowired
//    @Lazy
//    private StaffService staffService;
//
//    @Bean
//    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
//        http
//                .csrf(csrf -> csrf.ignoringRequestMatchers("/api/**", "/ws-chat/**","/api/dashboard/**","api/delivery/**","api/address/**","api/delivery/admin/**"))
//                .sessionManagement(session -> session
//                        .sessionFixation().newSession() // Creates new session on login
//                        .maximumSessions(-1) // Unlimited sessions per user
//                )
//                .authorizeHttpRequests(auth -> auth
//                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
//                        .requestMatchers(
//                                "/resources/**",
//                                "/webjars/**",
//                                "/uploads/**",
//                                "/pages/login.jsp",
//                                "/api/auth/**",
//                                "/login",
//                                "/logout",
//                                "/help-support",
//                                "/ws-chat/**"
//                        ).permitAll()
//                        .requestMatchers("/admin-staff", "/admin-staff/**").hasAnyRole("ADMIN", "SUB_ADMIN")
//                        .requestMatchers("/api/dashboard/**").hasAnyRole("ADMIN", "SUB_ADMIN", "MANAGER", "RIDER", "SUPPORT")
//                        .requestMatchers("/manager/**").hasRole(StaffRole.MANAGER.name())
//                        .requestMatchers("/rider/**").hasRole(StaffRole.RIDER.name())
//                        .requestMatchers("/support/**").hasRole(StaffRole.SUPPORT.name())
//                        .anyRequest().authenticated()
//                )
//                .addFilterBefore(new PageAccessFilter(staffService), AuthorizationFilter.class)
//                .formLogin(form -> form
//                        .loginPage("/login")
//                        .loginProcessingUrl("/login")
//                        .defaultSuccessUrl("/dashboard", true)
//                        .failureUrl("/login?error=true")
//                        .permitAll()
//                )
//                .logout(logout -> logout
//                        .logoutUrl("/logout")
//                        .logoutSuccessUrl("/login?logout=true")
//                        .invalidateHttpSession(true)
//                        .deleteCookies("JSESSIONID")
//                        .clearAuthentication(true)
//                        .permitAll()
//                )
//                .exceptionHandling(ex -> ex
//                        .accessDeniedPage("/access-denied")
//                );
//
//        return http.build();
//    }
//
//    @Bean
//    public PasswordEncoder passwordEncoder() {
//        return new BCryptPasswordEncoder();
//    }
//}

package com.meatsfresh.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {

        http
                // 🔹 Disable CSRF ONLY for APIs
                .csrf(csrf -> csrf
                        .ignoringRequestMatchers("/api/**")
                )

                // 🔹 Stateless for APIs
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
                )

                // 🔹 Authorization
                .authorizeHttpRequests(auth -> auth
                        // APIs → no login
                        .requestMatchers("/api/**").permitAll()
                        // Static resources, login page → permit
                        .requestMatchers(
                                "/login",
                                "/logout",
                                "/pages/**",
                                "/resources/**",
                                "/webjars/**",
                                "/uploads/**"
                        ).permitAll()
                        // Everything else → login required
                        .anyRequest().authenticated()
                )

                // 🔹 Enable form login for UI
                .formLogin(form -> form
                        .loginPage("/login")           // your login page URL
                        .loginProcessingUrl("/login")  // POST action for login
                        .defaultSuccessUrl("/dashboard", true)
                        .permitAll()
                )

                // 🔹 Logout for UI
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login?logout=true")
                        .invalidateHttpSession(true)
                        .deleteCookies("JSESSIONID")
                );

        return http.build();
    }

    // 🔹 Password encoder for login authentication
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
