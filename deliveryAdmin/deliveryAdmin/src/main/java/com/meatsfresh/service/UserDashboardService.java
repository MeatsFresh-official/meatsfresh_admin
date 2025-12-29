package com.meatsfresh.service;

import com.meatsfresh.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class UserDashboardService {

    private final UserRepository userRepository;

    public Map<String, Object> getUserCardData() {

        long totalUsers = userRepository.count();

        LocalDateTime last30Days = LocalDateTime.now().minusDays(30);
        long activeUsers30Days = userRepository.countActiveUsersLast30Days(last30Days);

        Double totalRevenue = userRepository.getTotalRevenue();
        Double avgOrderValue = userRepository.getAvgOrderValue();

        Map<String, Object> response = new HashMap<>();
        response.put("totalUsers", totalUsers);
        response.put("activeUsersLast30Days", activeUsers30Days);
        response.put("totalRevenue", totalRevenue != null ? totalRevenue : 0);
        response.put("avgOrderValue", avgOrderValue != null ? avgOrderValue : 0);

        return response;
    }
}
