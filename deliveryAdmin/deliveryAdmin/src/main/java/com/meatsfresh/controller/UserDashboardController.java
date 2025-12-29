package com.meatsfresh.controller;

import com.meatsfresh.dto.UserTableFilterRequest;
import com.meatsfresh.dto.UserTableRowDTO;
import com.meatsfresh.service.UserDashboardService;
import com.meatsfresh.service.UserTableService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/dashboard")
@RequiredArgsConstructor
public class UserDashboardController {

    private final UserDashboardService userDashboardService;
    private final UserTableService userTableService;

    @GetMapping("/users-card")
    public ResponseEntity<Map<String, Object>> getUsersCardData() {
        return ResponseEntity.ok(userDashboardService.getUserCardData());
    }

    @PostMapping("/table")
    public ResponseEntity<?> getUsersTable(@RequestBody UserTableFilterRequest request) {

        Page<UserTableRowDTO> page = userTableService.getUsersTable(request);

        return ResponseEntity.ok(
                Map.of(
                        "totalElements", page.getTotalElements(),
                        "totalPages", page.getTotalPages(),
                        "currentPage", page.getNumber(),
                        "data", page.getContent()
                )
        );
    }


}
