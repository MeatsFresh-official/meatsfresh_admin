
package com.meatsfresh.repository;

import com.meatsfresh.dto.UserTableRowDTO;
import com.meatsfresh.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.Repository;
import org.springframework.data.repository.query.Param;

public interface UserTableRepository extends Repository<User, Long> {

    // ================= TABLE DATA =================
    @Query(value = """
            SELECT
                u.users_id    AS id,
                u.name        AS name,
                u.email       AS email,
                u.phone       AS phone,
                ua.address    AS address,
                COUNT(o.id)   AS orders,
                COALESCE(SUM(o.total_amount),0) AS totalSpent,
                MAX(o.placed_at) AS lastActive,
                u.status      AS status
            FROM users u
            LEFT JOIN user_address ua ON ua.users_id = u.users_id
            LEFT JOIN orders o ON o.user_id = u.users_id
            WHERE
                (:fromDate IS NULL OR u.created_at >= :fromDate)
            AND (:toDate IS NULL OR u.created_at <= :toDate)
            AND (
                :activityType = 'ALL'
                OR (:activityType = 'ACTIVE_30' AND o.placed_at >= :activeLimit)
                OR (:activityType = 'INACTIVE_30' AND (o.placed_at IS NULL OR o.placed_at < :activeLimit))
            )
            GROUP BY u.users_id, ua.address, u.name, u.phone, u.status
            """, countQuery = """
            SELECT COUNT(DISTINCT u.users_id)
            FROM users u
            LEFT JOIN orders o ON o.user_id = u.users_id
            WHERE
                (:fromDate IS NULL OR u.created_at >= :fromDate)
            AND (:toDate IS NULL OR u.created_at <= :toDate)
            """, nativeQuery = true)
    Page<UserTableRowDTO> findUserTableData(
            @Param("fromDate") Object fromDate,
            @Param("toDate") Object toDate,
            @Param("activityType") String activityType,
            @Param("activeLimit") Object activeLimit,
            Pageable pageable);

    // ================= GLOBAL SEARCH =================
    @Query(value = """
            SELECT
                u.users_id    AS id,
                u.name        AS name,
                u.email       AS email,
                u.phone       AS phone,
                ua.address    AS address,
                COUNT(o.id)   AS orders,
                COALESCE(SUM(o.total_amount),0) AS totalSpent,
                MAX(o.placed_at) AS lastActive,
                u.status      AS status
            FROM users u
            LEFT JOIN user_address ua ON ua.users_id = u.users_id
            LEFT JOIN orders o ON o.user_id = u.users_id
            WHERE
                :search IS NULL OR :search = ''
                OR LOWER(u.name) LIKE LOWER(CONCAT('%', :search, '%'))
                OR LOWER(u.phone) LIKE LOWER(CONCAT('%', :search, '%'))
                OR LOWER(u.status) LIKE LOWER(CONCAT('%', :search, '%'))
                OR LOWER(ua.address) LIKE LOWER(CONCAT('%', :search, '%'))
            GROUP BY u.users_id, ua.address, u.name, u.phone, u.status
            ORDER BY MAX(o.placed_at) DESC
            """, countQuery = """
            SELECT COUNT(DISTINCT u.users_id)
            FROM users u
            LEFT JOIN user_address ua ON ua.users_id = u.users_id
            WHERE
                :search IS NULL OR :search = ''
                OR LOWER(u.name) LIKE LOWER(CONCAT('%', :search, '%'))
                OR LOWER(u.phone) LIKE LOWER(CONCAT('%', :search, '%'))
                OR LOWER(u.status) LIKE LOWER(CONCAT('%', :search, '%'))
                OR LOWER(ua.address) LIKE LOWER(CONCAT('%', :search, '%'))
            """, nativeQuery = true)
    Page<UserTableRowDTO> globalSearch(
            @Param("search") String search,
            Pageable pageable);
}
