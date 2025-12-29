package com.meatsfresh.service;

import com.meatsfresh.dto.UserTableFilterRequest;
import com.meatsfresh.dto.UserTableRowDTO;
import com.meatsfresh.repository.UserTableRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class UserTableService {

    private final UserTableRepository repository;

    public Page<UserTableRowDTO> getUsersTable(UserTableFilterRequest request) {

        LocalDateTime fromDate = request.getStartDate() != null
                ? request.getStartDate().atStartOfDay()
                : null;

        LocalDateTime toDate = request.getEndDate() != null
                ? request.getEndDate().atTime(23, 59, 59)
                : null;

        LocalDateTime activeLimit = LocalDateTime.now().minusDays(30);

        Pageable pageable = PageRequest.of(
                request.getPage(),
                request.getSize(),
                Sort.by(Sort.Direction.DESC, "lastActive")
        );

        return repository.findUserTableData(
                fromDate,
                toDate,
                request.getActivityStatus(), // ALL / ACTIVE_30 / INACTIVE_30
                activeLimit,
                pageable
        );
    }
    public Page<UserTableRowDTO> globalSearch(String search, int page, int size) {

        Pageable pageable = PageRequest.of(page, size);

        return repository.globalSearch(search, pageable);
    }


}
