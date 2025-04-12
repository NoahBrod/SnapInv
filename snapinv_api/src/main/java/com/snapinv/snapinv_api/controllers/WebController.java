package com.snapinv.snapinv_api.controllers;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
public class WebController {
    /**
     * Returns with model data if data exists.
     * 
     * @param subscribed Present after a successful sign up
     * 
     * @return HTML template "index.html".
     */
    @GetMapping("/")
    public String index(Model model, @RequestParam(required = false) Boolean subscribed) {
        if (subscribed != null) {
            model.addAttribute("subscribed", subscribed);
        }

        return "index";
    }
    
    /**
     * Page making it able to send update emails to users.
     * 
     * @param success Present after successfully sent.
     * 
     * @return HTML template "mail/e_update.html".
     */
    @GetMapping("/email")
    public String sendUpdateEmail(Model model, @RequestParam(required = false) boolean success) {
        System.out.println(success);
        if (success) {
            model.addAttribute("success", success);
        }

        return "mail/e_update";
    }
    
}
