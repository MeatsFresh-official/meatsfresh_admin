package com.meatsfresh.repository;

import com.meatsfresh.entity.Staff;
import com.meatsfresh.entity.StaffRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;


import java.util.Collection;
import java.util.List;
import java.util.Optional;

public interface StaffRepository extends JpaRepository<Staff, Long> {
    boolean existsByEmail(String email);
    Optional<Staff> findByEmail(String email);

    long countByActive(boolean b);

    @Query("SELECT s FROM Staff s LEFT JOIN FETCH s.permissions WHERE s.email = :email")
    Optional<Staff> findByEmailWithPermissions(@Param("email") String email);

    @Query("SELECT s FROM Staff s LEFT JOIN FETCH s.accessPages WHERE s.email = :email")
    Optional<Staff> findByEmailWithAccessPages(@Param("email") String email);

    List<Staff> findAllByOrderByNameAsc();

    Optional<Staff> findByPhone(String phone);

    boolean existsByPhone(String phone);

    List<Staff> findByRoleIn(Collection<StaffRole> roles);

    @Query(value = "SELECT COUNT(s) FROM staff s WHERE s.active = true", nativeQuery = true)
    long countByActiveTrue();
}
