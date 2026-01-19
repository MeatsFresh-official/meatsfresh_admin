package com.meatsfresh.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public interface UserTableRowDTO {
    Long getId();

    String getName();

    String getPhone();

    String getEmail();

    String getAddress();

    BigDecimal getTotalSpent();

    Long getOrders();

    LocalDateTime getLastActive();

    String getStatus();
}
