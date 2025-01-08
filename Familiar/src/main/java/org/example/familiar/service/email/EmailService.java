package org.example.familiar.service.email;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

@Service
public class EmailService {
    @Autowired
    private JavaMailSender mailSender;
    @Autowired
    private TemplateEngine templateEngine;

    //config gmail đơn giản
//    public void sendOtpEmail(String toEmail, String otp) {
//        SimpleMailMessage message = new SimpleMailMessage();
//        message.setTo(toEmail);
//        message.setSubject("Mã OTP để đổi mật khẩu");
//        message.setText("Mã OTP của bạn là: " + otp + ". Mã này có hiệu lực trong 5 phút.");
//
//        mailSender.send(message);
//    }


// config gmail bằng html
    public void sendResetPasswordEmail(String toEmail, String name, String otp) {
        Context context = new Context();
        context.setVariable("email", toEmail);
        context.setVariable("name", name);
        context.setVariable("otp", otp);
        String htmlContent = templateEngine.process("_email", context);
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, "utf-8");
        try {
            helper.setTo(toEmail);
            helper.setSubject("Mã OTP để thay đổi mật khẩu");
            helper.setText(htmlContent, true);
            mailSender.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
