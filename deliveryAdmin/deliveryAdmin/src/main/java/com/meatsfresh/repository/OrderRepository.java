package com.meatsfresh.repository;

import com.meatsfresh.dto.OrderTableDTO;
import com.meatsfresh.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {

    @Query(value = """
        SELECT 
            o.order_number AS orderId,
            u.name AS customerName,
            o.placed_at AS orderDate,
            o.status AS status,
            o.total_amount AS totalAmount,

            v.vendor_name AS shopName,
            v.phone_number AS shopContact,

            dp.name AS deliveryPartnerName,
            dp.phone AS deliveryPartnerContact

        FROM orders o
        LEFT JOIN users u ON o.user_id = u.users_id
        LEFT JOIN vendors v ON o.vendor_id = v.vendors_id
        LEFT JOIN delivery_partners dp ON o.delivery_partner_id = dp.partner_id

        ORDER BY o.placed_at DESC
        """, nativeQuery = true)
    List<Object[]> fetchOrderTableRaw();
}
