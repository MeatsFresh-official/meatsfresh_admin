package com.meatsfresh.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class VendorListDTO {

    private Long vendorId;
    private String vendorInfo;       // Name + Code
    private String contactDetails;   // Phone + Email
    private String status;            // ONLINE / OFFLINE / BLOCKED
    private String availability;      // OPEN / CLOSED
}
