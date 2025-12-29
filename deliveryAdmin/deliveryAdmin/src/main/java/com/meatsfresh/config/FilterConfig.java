package com.meatsfresh.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;

@Configuration
public class FilterConfig {

    @Autowired
    private RoleSessionFilter roleSessionFilter;

    @Bean
    public FilterRegistrationBean<RoleSessionFilter> roleSessionFilterRegistration() {
        FilterRegistrationBean<RoleSessionFilter> registration = new FilterRegistrationBean<>();
        registration.setFilter(roleSessionFilter);
        registration.addUrlPatterns("/*");
        registration.setOrder(Ordered.HIGHEST_PRECEDENCE);
        return registration;
    }
}
