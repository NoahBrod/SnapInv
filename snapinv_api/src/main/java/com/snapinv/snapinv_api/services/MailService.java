package com.snapinv.snapinv_api.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.internet.MimeMessage;

@Service
public class MailService {
    private MimeMessage message;
    private MimeMessageHelper helper;

    
}
