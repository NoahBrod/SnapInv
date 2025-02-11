package com.snapinv.snapinv_api.services;

import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.snapinv.snapinv_api.entities.EmailSubscription;
import com.snapinv.snapinv_api.repositories.EmailSubscriptionRepo;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Service
public class MailService {
    @Autowired
    private EmailSubscriptionRepo emailRepo;

    private MimeMessage message;
    private MimeMessageHelper helper;

    @Value("${spring.mail.username}") 
    private String sender;

    private static final String EMAIL_REGEX = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";

    public boolean subscribeEmail(String email) {
        EmailSubscription subscription = new EmailSubscription(email);

        Pattern pattern = Pattern.compile(EMAIL_REGEX);
        Matcher matcher = pattern.matcher(email);

        if (!matcher.matches() || emailRepo.findByEmail(email).isPresent()) {
            return false;
        }

        emailRepo.save(subscription);
        return true;
    }

    public List<EmailSubscription> getEmails() {
        return emailRepo.findAll();
    }

    public boolean unsubscribeEmail(Long id) {
        emailRepo.deleteById(id);
        if (emailRepo.findById(id) == null) {
            return true;
        }
        return false;
    }

    public void sendVerify(String email) {
        String body = "Please click the link below to verify your registration:<br>" +
                        "<a href=\"https://snapinv.com/verify\" target=\"_blank\">Verify Here</a>";

        try {
            helper.setFrom(sender, "SnapInv");
            helper.setTo(email);
            helper.setSubject("Verify Email");
            helper.setText(email, true);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    public void verifyCode() {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'verifyCode'");
    }

    public boolean sendUpdateEmail(String to, String subject, String text) {
        return false;
    }
}
