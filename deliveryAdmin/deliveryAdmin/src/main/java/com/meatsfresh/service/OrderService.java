package com.meatsfresh.service;

import com.meatsfresh.dto.OrderTableDTO;
import com.meatsfresh.repository.OrderRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class OrderService {

    private final OrderRepository orderRepository;

    public OrderService(OrderRepository orderRepository) {
        this.orderRepository = orderRepository;
    }

    public List<OrderTableDTO> getOrderTable() {

        return orderRepository.fetchOrderTableRaw()
                .stream()
                .map(row -> new OrderTableDTO(
                        (String) row[0],                 // orderId
                        (String) row[1],                 // customerName
                        (LocalDateTime) row[2],          // orderDate
                        (String) row[3],                 // status
                        (BigDecimal) row[4],             // totalAmount
                        (String) row[5],                 // shopName
                        (String) row[6],                 // shopContact
                        (String) row[7],                 // deliveryPartnerName
                        (String) row[8]                  // deliveryPartnerContact
                ))
                .collect(Collectors.toList());
    }
}
