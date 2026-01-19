package com.meatsfresh.controller;

import com.meatsfresh.entity.Staff;
import com.meatsfresh.entity.StaffRole;
import com.meatsfresh.repository.StaffRepository;
// import com.meatsfresh.dto.UserDetailsDTO;
import com.meatsfresh.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/users")
public class UserApiController {

    @Autowired
    private StaffRepository staffRepository;

    @Autowired
    private UserRepository userRepository;

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

    // ================= USER DETAILS API =================

    // @GetMapping("/{id}/details")
    // public ResponseEntity<UserDetailsDTO> getUserDetails(@PathVariable Long id) {
    // return userRepository.findById(id)
    // .map(user -> {
    // UserDetailsDTO dto = new UserDetailsDTO();
    // dto.setId(user.getId());
    // dto.setName(user.getName());
    // dto.setEmail(user.getEmail());
    // dto.setPhone(user.getPhone());
    // dto.setAddress("N/A"); // Address is in separate table, simplified for now or
    // fetch via join if
    // // needed
    // dto.setProfileImage(user.getProfileImage());
    // dto.setDob(user.getDob());
    // dto.setRegistrationDate(user.getRegistrationDate());
    // // dto.setLastActive(user.getLastActive()); // Need to fetch from repository
    // // projection or entity
    // dto.setStatus(user.getStatus());
    // dto.setUserCode(user.getUserCode());

    // dto.setSmsEnabled(user.getSmsEnabled());
    // dto.setWhatsappEnabled(user.getWhatsappEnabled());
    // dto.setEmailEnabled(user.getEmailEnabled());
    // dto.setPromotionalEnabled(user.getPromotionalEnabled());
    // return ResponseEntity.ok(dto);
    // })
    // .orElse(ResponseEntity.notFound().build());
    // }

    // @PutMapping("/{id}/details")
    // public ResponseEntity<?> updateUserDetails(@PathVariable Long id,
    // @RequestBody UserDetailsDTO dto) {
    // return userRepository.findById(id)
    // .map(user -> {
    // user.setName(dto.getName());
    // user.setEmail(dto.getEmail());
    // user.setPhone(dto.getPhone());
    // user.setDob(dto.getDob());
    // userRepository.save(user);
    // return ResponseEntity.ok()
    // .body("{\"success\": true, \"message\": \"Profile updated successfully\"}");
    // })
    // .orElse(ResponseEntity.notFound().build());
    // }

    // @PutMapping("/{id}/preferences")
    // public ResponseEntity<?> updateUserPreferences(@PathVariable Long id,
    // @RequestBody UserDetailsDTO dto) {
    // return userRepository.findById(id)
    // .map(user -> {
    // if (dto.getSmsEnabled() != null)
    // user.setSmsEnabled(dto.getSmsEnabled());
    // if (dto.getWhatsappEnabled() != null)
    // user.setWhatsappEnabled(dto.getWhatsappEnabled());
    // if (dto.getEmailEnabled() != null)
    // user.setEmailEnabled(dto.getEmailEnabled());
    // if (dto.getPromotionalEnabled() != null)
    // user.setPromotionalEnabled(dto.getPromotionalEnabled());

    // userRepository.save(user);
    // return ResponseEntity.ok().body("{\"success\": true}");
    // })
    // .orElse(ResponseEntity.notFound().build());
    // }

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