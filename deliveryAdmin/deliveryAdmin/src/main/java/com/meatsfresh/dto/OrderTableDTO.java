package com.meatsfresh.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
public class OrderTableDTO {

    private String orderId;
    private String customerName;
    private LocalDateTime orderDate;
    private String status;
    private BigDecimal totalAmount;

    private String shopName;
    private String shopContact;

    private String deliveryPartnerName;
    private String deliveryPartnerContact;
}
