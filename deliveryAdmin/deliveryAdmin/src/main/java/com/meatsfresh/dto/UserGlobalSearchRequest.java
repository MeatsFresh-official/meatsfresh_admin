package com.meatsfresh.dto;

import lombok.Data;

@Data
public class UserGlobalSearchRequest {

    private String search;   // 👈 SINGLE STRING
    private int page;
    private int size;
}
