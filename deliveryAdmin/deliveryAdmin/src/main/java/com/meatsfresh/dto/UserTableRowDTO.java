package com.meatsfresh.dto;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
public class UserTableRowDTO {

    private String name;
    private String phone;
    private String address;
    private Long orders;
    private BigDecimal totalSpent;
    private LocalDateTime lastActive;
    private String status;
}
