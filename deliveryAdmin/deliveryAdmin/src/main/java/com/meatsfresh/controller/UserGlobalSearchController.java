package com.meatsfresh.controller;

import com.meatsfresh.dto.UserGlobalSearchRequest;
import com.meatsfresh.service.UserTableService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/dashboard/users")
@RequiredArgsConstructor
public class UserGlobalSearchController {

    private final UserTableService service;

    @PostMapping("/search")
    public ResponseEntity<?> globalSearch(
            @RequestBody UserGlobalSearchRequest request
    ) {
        Page<?> page = service.globalSearch(
                request.getSearch(),
                request.getPage(),
                request.getSize()
        );

        return ResponseEntity.ok(
                java.util.Map.of(
                        "totalElements", page.getTotalElements(),
                        "totalPages", page.getTotalPages(),
                        "currentPage", page.getNumber(),
                        "data", page.getContent()
                )
        );
    }
}
