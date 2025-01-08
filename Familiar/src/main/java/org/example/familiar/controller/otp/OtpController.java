package org.example.familiar.controller.otp;

import org.example.familiar.model.Otp;
import org.example.familiar.service.otp.OtpService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@CrossOrigin("*")
@RequestMapping("/api/otp")
public class OtpController {

    @Autowired
    private OtpService otpService;

    @PostMapping("/enter-otp")
    public ResponseEntity<?> updatePassword(@RequestBody Otp otp) {
        otpService.sendOtpToEmail(otp.getUsername());
        return ResponseEntity.ok("Mã OTP đã gửi đến email của bạn.");
    }

    @PostMapping("/confirm-otp")
    public ResponseEntity<?> confirmOtp(@RequestBody Otp otp) {
        boolean check = otpService.verifyOtp(otp.getUsername(), otp.getOtp());
        if (check) {
            otpService.deleteOtpByUsername(otp.getUsername());
            return new ResponseEntity<>(check, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(check, HttpStatus.BAD_REQUEST);
        }

    }
}
