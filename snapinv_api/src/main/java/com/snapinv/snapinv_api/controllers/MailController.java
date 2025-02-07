package com.snapinv.snapinv_api.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
@RequestMapping(path = "/mail")
public class MailController {
    @PostMapping("/send")
    public String sendUpdate(@RequestParam String sender, @RequestParam String subject, @RequestParam String body) {
        //TODO: process POST request
        
        return "mail/e_success";
    }
    
}
