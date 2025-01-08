package org.example.familiar.service.otp;

import jakarta.transaction.Transactional;
import org.example.familiar.model.Account;
import org.example.familiar.model.Otp;
import org.example.familiar.model.User;
import org.example.familiar.repository.account.AccountRepository;
import org.example.familiar.repository.otp.IOtpRepository;
import org.example.familiar.repository.user.IUserRepository;
import org.example.familiar.service.email.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.Random;

@Service
public class OtpService {


    @Autowired
    private IOtpRepository otpRepository;

    @Autowired
    private EmailService emailService;

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private IUserRepository userRepository;

    public void sendOtpToEmail(String username) {
        System.out.println(username +  "Tạo mã OTP mới");
        String otp = generateOTP(); // Tạo mã OTP
        LocalDateTime expiresAt = LocalDateTime.now().plusMinutes(1); // Thời gian hết hạn

        // Lưu OTP vào cơ sở dữ liệu
        Otp otpData = new Otp();
        otpData.setUsername(username);
        otpData.setOtp(otp);
        otpData.setExpiresAt(expiresAt);
        otpRepository.save(otpData);

        Account account = accountRepository.findByUsername(username);

        if (account == null) {
            throw new IllegalArgumentException("Tài khoản không tồn tại!");
        }

        int id = account.getUser().getId();
        User user = userRepository.findById(id).orElse(null);


        emailService.sendResetPasswordEmail(user.getEmail(), user.getFirstName()+" "+user.getLastName(), otp);
    }

    public boolean verifyOtp(String username, String otp) {
        Otp otpData = otpRepository.findByUsername(username);

        if (otpData == null || otpData.getExpiresAt().isBefore(LocalDateTime.now()) || !otpData.getOtp().equals(otp)) {
            return false;
        }
        return true;

    }


    //tạo mã otp
    public static String generateOTP() {
        int otpLength = 6; // Độ dài của OTP
        String numbers = "0123456789";
        Random random = new Random();
        StringBuilder otp = new StringBuilder();

        for (int i = 0; i < otpLength; i++) {
            otp.append(numbers.charAt(random.nextInt(numbers.length())));
        }
        return otp.toString();
    }
    @Transactional
    public void deleteOtpByUsername(String username) {
        otpRepository.deleteByUsername(username);
        System.out.println("Đã xóa OTP của tài khoản: " + username);
    }


    // Chạy mỗi 15p để xóa các OTP hết hạn
    @Scheduled(cron = "0 */15 * * * ?") // Chạy vào mỗi 15p
    @Transactional
    public void cleanupExpiredOtps() {
        otpRepository.deleteExpiredOtps();
        System.out.println("Đã xóa các OTP hết hạn.");
    }
}
