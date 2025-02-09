package com.snapinv.snapinv_api.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.snapinv.snapinv_api.entities.EmailSubscription;
import com.snapinv.snapinv_api.repositories.EmailSubscriptionRepo;

import jakarta.mail.internet.MimeMessage;

@Service
public class MailService {
    @Autowired
    private EmailSubscriptionRepo emailRepo;

    private MimeMessage message;
    private MimeMessageHelper helper;

    public boolean subscribeEmail(String email) {
        EmailSubscription subscription = new EmailSubscription(email);
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

    public boolean send(String to, String subject, String text) {
        return false;
    }
}
