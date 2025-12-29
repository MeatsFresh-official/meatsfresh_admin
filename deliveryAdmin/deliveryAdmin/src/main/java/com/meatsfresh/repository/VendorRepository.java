package com.meatsfresh.repository;

import com.meatsfresh.entity.Vendor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface VendorRepository extends JpaRepository<Vendor, Long> {
    @Query("""
        SELECT v FROM Vendor v
        WHERE
        (:search IS NULL OR :search = '' OR
         LOWER(v.vendorName) LIKE LOWER(CONCAT('%', :search, '%')) OR
         LOWER(v.vendorCode) LIKE LOWER(CONCAT('%', :search, '%')) OR
         LOWER(v.phoneNumber) LIKE LOWER(CONCAT('%', :search, '%')) OR
         LOWER(v.email) LIKE LOWER(CONCAT('%', :search, '%')) OR
         LOWER(v.address) LIKE LOWER(CONCAT('%', :search, '%')) OR
         LOWER(v.status) LIKE LOWER(CONCAT('%', :search, '%'))
        )
        ORDER BY v.created DESC
    """)
    List<Vendor> globalSearchVendors(@Param("search") String search);

}
