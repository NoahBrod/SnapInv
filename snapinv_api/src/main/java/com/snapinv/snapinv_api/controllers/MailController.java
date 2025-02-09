package com.snapinv.snapinv_api.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
public class MailController {
    @PostMapping("/email")
    public String sendUpdate(@RequestParam String sender, @RequestParam String subject, @RequestParam String body) {
        //TODO: process POST request
        System.out.println(sender);
        System.out.println(subject);
        System.out.println(body);
        
        return "redirect:/email?success=" + Boolean.toString(true);
    }
    
}
