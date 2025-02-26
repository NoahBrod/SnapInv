package com.snapinv.snapinv_api.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.snapinv.snapinv_api.entities.EmailSubscription;
import com.snapinv.snapinv_api.services.MailService;

import org.springframework.web.bind.annotation.RequestBody;



@Controller
public class MailController {
    @Autowired
    private MailService mailService;
    
    /**
     * Subscirbes email to the database.
     * 
     * @param email User email.
     * 
     * @return Redirects with param subscribed.
     */
    @PostMapping("/subscribe")
    public String subscribeEmail(@RequestParam String email) {
        boolean subscribed = mailService.subscribeEmail(email);

        if (subscribed) {
            return "redirect:/?subscribed=true#signup";
        }
        System.out.println(subscribed);
        // mailService.sendVerify(email);
        
        return "redirect:/?subscribed=false#signup";
    }
    
    /**
     * Verifies user email.
     * 
     * @param code Verification code.
     * 
     * @return Returns template "mail/verify.html".
     */
    @PostMapping("/verify")
    public String emailVerify(@RequestBody String code) {
        //TODO: process POST request
        mailService.verifyCode();

        return "mail/verify";
    }
    
    /**
     * Subscirbes email to the database.
     * 
     * @todo Implement sending logic with SMTP Gmail.
     * 
     * @param sender  Email sender.
     * @param subject  Subject of the email.
     * @param body Body of the email.
     * 
     * @return Redirects with param success.
     */
    @PostMapping("/email")
    public String sendUpdate(@RequestParam String sender, @RequestParam String subject, @RequestParam String body) {
        //TODO: process POST request
        System.out.println(sender);
        System.out.println(subject);
        System.out.println(body);
        
        return "redirect:/email?success=" + Boolean.toString(true);
    }
    
}
