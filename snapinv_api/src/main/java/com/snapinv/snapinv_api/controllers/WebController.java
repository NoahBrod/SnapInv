package com.snapinv.snapinv_api.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
public class WebController {
    @GetMapping("/")
    public String index() {
        return "index";
    }
    
    @GetMapping("/email")
    public String sendUpdateEmail(Model model, @RequestParam(required = false) boolean success) {
        System.out.println(success);
        if (success) {
            model.addAttribute("success", success);
        }

        return "mail/e_update";
    }
    
}
