package com.meatsfresh.service;

import com.meatsfresh.dto.VendorListDTO;
import com.meatsfresh.entity.Vendor;
import com.meatsfresh.repository.VendorRepository;
import org.springframework.stereotype.Service;

import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class VendorService {

    private final VendorRepository vendorRepository;

    public VendorService(VendorRepository vendorRepository) {
        this.vendorRepository = vendorRepository;
    }

    public List<VendorListDTO> getAllVendors() {
        return vendorRepository.findAll()
                .stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    public List<VendorListDTO> globalSearchVendors(String search) {

        return vendorRepository.globalSearchVendors(search == null ? "" : search.trim())
                .stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }


    private VendorListDTO mapToDTO(Vendor vendor) {

        String vendorInfo = vendor.getVendorName() + " (" + vendor.getVendorCode() + ")";
        String contactDetails = vendor.getPhoneNumber()
                + (vendor.getEmail() != null ? " | " + vendor.getEmail() : "");

        String availability = calculateAvailability(
                vendor.getOpeningTime(),
                vendor.getClosingTime(),
                vendor.getStatus()
        );

        return new VendorListDTO(
                vendor.getId(),
                vendorInfo,
                contactDetails,
                vendor.getStatus(),
                availability
        );
    }



    private String calculateAvailability(String opening, String closing, String status) {

        if (!"ONLINE".equalsIgnoreCase(status)) {
            return "CLOSED";
        }

        if (opening == null || closing == null) {
            return "UNKNOWN";
        }

        try {
            LocalTime now = LocalTime.now();
            LocalTime openTime = LocalTime.parse(opening.trim());
            LocalTime closeTime = LocalTime.parse(closing.trim());

            // Normal same-day shop
            if (openTime.isBefore(closeTime)) {
                return (!now.isBefore(openTime) && !now.isAfter(closeTime))
                        ? "OPEN"
                        : "CLOSED";
            }

            // Overnight shop (09:00 → 01:30)
            else {
                return (!now.isBefore(openTime) || !now.isAfter(closeTime))
                        ? "OPEN"
                        : "CLOSED";
            }

        } catch (Exception e) {
            return "UNKNOWN";
        }
    }



}
