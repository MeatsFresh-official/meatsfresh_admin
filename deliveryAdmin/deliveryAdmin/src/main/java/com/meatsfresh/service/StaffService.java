package com.meatsfresh.service;

import com.meatsfresh.entity.Staff;
import com.meatsfresh.repository.StaffRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

@Service
public class StaffService {

    @Autowired
    private StaffRepository staffRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Value("${file.upload-dir}")
    private String uploadDir;

    private static final String UPLOAD_SUBDIR = "staff/";

    public List<Staff> getAllStaff() {
        return staffRepository.findAllByOrderByNameAsc();
    }

    public Staff addStaff(Staff staff, MultipartFile profileImage) throws IOException {
        if (staffRepository.existsByEmail(staff.getEmail())) {
            throw new RuntimeException("Email already exists");
        }

        staff.setPassword(passwordEncoder.encode(staff.getPassword()));
        staff.setActive(true);

        // Initialize accessPages if null
        if (staff.getAccessPages() == null) {
            staff.setAccessPages(new ArrayList<>());
        }

        // Ensure dashboard access is always included
        if (!staff.getAccessPages().contains("DASHBOARD")) {
            staff.getAccessPages().add("DASHBOARD");
        }

        if (profileImage != null && !profileImage.isEmpty()) {
            String fileName = saveProfileImage(profileImage);
            staff.setProfileImage("/uploads/staff/" + fileName);
        }

        return staffRepository.save(staff);
    }

    private String saveProfileImage(MultipartFile profileImage) throws IOException {
        String fileName = System.currentTimeMillis() + "_" + profileImage.getOriginalFilename();
        Path uploadPath = Paths.get(uploadDir, UPLOAD_SUBDIR);

        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        Path filePath = uploadPath.resolve(fileName);
        profileImage.transferTo(filePath.toFile());
        return fileName;
    }

    public long getTotalStaff() {
        return staffRepository.count();
    }

    public long getActiveStaff() {
        return staffRepository.countByActive(true);
    }

    public long getRejectedStaff() {
        return staffRepository.countByActive(false);
    }

    public void deleteStaff(Long id) {
        if (!staffRepository.existsById(id)) {
            throw new EntityNotFoundException("Staff member not found with id: " + id);
        }
        staffRepository.deleteById(id);
    }

    public void updatePermissions(Long id, List<String> permissions) {
        Staff staff = staffRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Staff not found"));
        staff.setPermissions(permissions);
        staffRepository.save(staff);
    }

    public Staff findByEmail(String email) {
        Staff staff = staffRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Staff not found with email: " + email));

        // Initialize the collection
        staff.getAccessPages().size(); // This forces initialization

        return staff;
    }

    public Staff save(Staff staff) {
        if (staff.getPassword() != null && !staff.getPassword().isEmpty()) {
            staff.setPassword(passwordEncoder.encode(staff.getPassword()));
        }
        return staffRepository.save(staff);
    }

    public Staff findByPhone(String phone) {
        return staffRepository.findByPhone(phone)
                .orElseThrow(() -> new UsernameNotFoundException("Staff not found with phone: " + phone));
    }

    public boolean phoneNumberExists(String phone) {
        return staffRepository.existsByPhone(phone);
    }

    public Staff findByEmailWithAccessPages(String email) {
        return staffRepository.findByEmailWithAccessPages(email)
                .orElseThrow(() -> new UsernameNotFoundException("Staff not found with email: " + email));
    }

    public Staff getStaffById(Long id) {
        return staffRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Staff not found with id: " + id));
    }

    public Staff saveStaff(Staff staff) {
        return staffRepository.save(staff);
    }

    public Staff updateStaff(Long id, Staff updatedStaff, MultipartFile profileImage) throws IOException {
        Staff existingStaff = getStaffById(id);

        existingStaff.setName(updatedStaff.getName());
        existingStaff.setEmail(updatedStaff.getEmail());
        existingStaff.setPhone(updatedStaff.getPhone());
        existingStaff.setRole(updatedStaff.getRole());
        existingStaff.setActive(updatedStaff.isActive());

        // Update password only if provided
        if (updatedStaff.getPassword() != null && !updatedStaff.getPassword().isEmpty()) {
            existingStaff.setPassword(passwordEncoder.encode(updatedStaff.getPassword()));
        }

        // Update profile image if provided
        if (profileImage != null && !profileImage.isEmpty()) {
            String fileName = saveProfileImage(profileImage);
            existingStaff.setProfileImage("/uploads/staff/" + fileName);
        }

        return staffRepository.save(existingStaff);
    }
}
