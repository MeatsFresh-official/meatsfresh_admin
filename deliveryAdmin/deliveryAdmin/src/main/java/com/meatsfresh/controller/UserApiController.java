package com.meatsfresh.controller;

import com.meatsfresh.entity.Staff;
import com.meatsfresh.entity.StaffRole;
import com.meatsfresh.repository.StaffRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/users")
public class UserApiController {

    @Autowired
    private StaffRepository staffRepository;

    @GetMapping("/{type}")
    public ResponseEntity<List<StaffInfo>> getUsersByType(@PathVariable String type) {
        List<Staff> users;
        switch (type.toLowerCase()) {
            case "vendors":
                users = staffRepository.findByRoleIn(List.of(StaffRole.MANAGER));
                break;
            case "delivery":
                users = staffRepository.findByRoleIn(List.of(StaffRole.RIDER));
                break;
            case "support":
                users = staffRepository.findByRoleIn(List.of(StaffRole.SUPPORT));
                break;
            default:
                return ResponseEntity.badRequest().build();
        }

        List<StaffInfo> userInfo = users.stream()
                .map(u -> new StaffInfo(u.getId(), u.getName(), u.getRole().name(),
                        u.getProfileImage() != null ? u.getProfileImage() : "/resources/images/default-avatar.jpg"))
                .collect(Collectors.toList());

        return ResponseEntity.ok(userInfo);
    }

    public static class StaffInfo {
        public Long id;
        public String name;
        public String role;
        public String profileImage;

        public StaffInfo(Long id, String name, String role, String profileImage) {
            this.id = id;
            this.name = name;
            this.role = role;
            this.profileImage = profileImage;
        }
    }
}