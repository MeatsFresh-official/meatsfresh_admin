package com.meatsfresh.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Bean;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;
import java.util.Arrays;

@Configuration
public class CorsConfig {

    @Bean
    public CorsFilter corsFilter() {
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        CorsConfiguration config = new CorsConfiguration();

        // Allow your frontend origin
        config.setAllowedOrigins(Arrays.asList("http://localhost:9090"));

        // Allow specific headers
        config.setAllowedHeaders(Arrays.asList(
                "Origin", "Content-Type", "Accept", "Authorization",
                "X-Requested-With", "Access-Control-Request-Method",
                "Access-Control-Request-Headers"
        ));

        // Allow all methods you need
        config.setAllowedMethods(Arrays.asList(
                "GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS", "HEAD"
        ));

        // Allow credentials if needed
        config.setAllowCredentials(true);

        // Expose any custom headers if needed
        config.setExposedHeaders(Arrays.asList("Authorization", "Content-Disposition"));

        // Max age for preflight response caching
        config.setMaxAge(3600L);

        source.registerCorsConfiguration("/api/**", config);
        return new CorsFilter(source);
    }
}
