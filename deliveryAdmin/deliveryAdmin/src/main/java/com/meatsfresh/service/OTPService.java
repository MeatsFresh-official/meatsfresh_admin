package com.meatsfresh.service;

import com.meatsfresh.entity.Otp;
import com.meatsfresh.repository.OtpRepository;
import okhttp3.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;

@Service
public class OTPService {
    private final OkHttpClient client = new OkHttpClient();

    @Autowired
    private OtpRepository otpRepository;

    @Value("${otp.expiry.minutes:5}") // Configurable expiry time (default 5 mins)
    private int otpExpiryMinutes;

    public String generateOTP(String phoneNumber) {
        String otp = generateOtp();
        saveOtp(phoneNumber, otp);
        sendOTPViaSMS(phoneNumber, otp);
        return otp;
    }

    private String generateOtp() {
        return String.format("%06d", new Random().nextInt(999999));
    }

    private void saveOtp(String phone, String otp) {
        Otp newOtp = new Otp();
        newOtp.setPhone(phone);
        newOtp.setOtp(otp);
        newOtp.setCreatedAt(LocalDateTime.now());
        newOtp.setExpiresAt(LocalDateTime.now().plusMinutes(otpExpiryMinutes));
        otpRepository.save(newOtp);
    }

    private void sendOTPViaSMS(String phoneNumber, String otp) {
        String url = "https://openapi.airtel.in/gateway/airtel-iq/iq-sms-utility/sendSmsWithAuth";

        HttpUrl.Builder urlBuilder = HttpUrl.parse(url).newBuilder()
                .addQueryParameter("customerId", "MEATSFRESH_oT3o3kOo7lKeaSo1O83r")
                .addQueryParameter("destinationAddress", phoneNumber)
                .addQueryParameter("message", "Dear User Your OTP for mobile verification is " + otp + ". Regards MEATSFRESH")
                .addQueryParameter("sourceAddress", "MTFRSH")
                .addQueryParameter("messageType", "SERVICE_IMPLICIT")
                .addQueryParameter("entityId", "1001953734198031220")
                .addQueryParameter("dltTemplateId", "1007544642099122208")
                .addQueryParameter("username", "meatsfreshoffical@gmail.com")
                .addQueryParameter("password", "TWVhdHNmcmVzaEAxMjM=");

        Request request = new Request.Builder()
                .url(urlBuilder.build())
                .get()
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (response.isSuccessful()) {
                System.out.println("OTP sent successfully: " + response.body().string());
            } else {
                System.err.println("Failed to send OTP: " + response.code() + " - " + response.message());
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error sending OTP: " + e.getMessage());
        }
    }

    public boolean validateOTP(String phoneNumber, String otp) {
        List<Otp> otpList = otpRepository.findTop1ByPhoneOrderByCreatedAtDesc(phoneNumber);

        if (otpList.isEmpty()) {
            return false;
        }

        Otp latestOtp = otpList.get(0);
        return latestOtp.getOtp().equals(otp) &&
                LocalDateTime.now().isBefore(latestOtp.getExpiresAt());
    }
}