package com.snapinv.snapinv_api.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
public class WebController {
    @GetMapping("/")
    public String index() {
        return "index";
    }
    
}
